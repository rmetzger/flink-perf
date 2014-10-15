/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.github.projectflink.pagerank;

import org.apache.flink.api.common.functions.FlatJoinFunction;
import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.common.functions.JoinFunction;
import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.api.common.functions.RichGroupReduceFunction;
import org.apache.flink.api.java.DataSet;
import org.apache.flink.api.java.ExecutionEnvironment;
import org.apache.flink.api.java.functions.FunctionAnnotation.ConstantFields;
import org.apache.flink.api.java.functions.FunctionAnnotation.ConstantFieldsFirst;
import org.apache.flink.api.java.functions.FunctionAnnotation.ConstantFieldsSecond;
import org.apache.flink.api.java.operators.DeltaIteration;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.core.fs.FileSystem.WriteMode;
import org.apache.flink.util.Collector;

@SuppressWarnings("serial")
public class AdaptivePageRank {

	public static void main(String[] args) throws Exception {

		int numIterations = 100;
		long numVertices = 82140;

		double threshold = 0.001 / numVertices;
		double dampeningFactor = 0.85;

	//	String adjacencyPath = "/data/demodata/pagerank/adjacency/adjacency.csv";
//		String outpath = "/home/cicero/Desktop/out.txt";

		String adjacencyPath = args.length > 1 ? args[0] : "/data/demodata/pagerank/edges/edges.csv";
		String outpath = args.length > 1 ? args[1] : "/data/demodata/pagerank/adacency_comp";

		ExecutionEnvironment env = ExecutionEnvironment.getExecutionEnvironment();
		// env.setDegreeOfParallelism(1);

		DataSet<Tuple2<Long, long[]>> adjacency1 = env.readTextFile(adjacencyPath).map(new AdjacencyBuilder());
		DataSet<Tuple2<Long, long[]>> adjacency2 = env.readTextFile(adjacencyPath).map(new AdjacencyBuilder());


		DataSet<Tuple2<Long, Double>> initialRanks = adjacency1
				.flatMap(new InitialMessageBuilder(numVertices, dampeningFactor))
				.groupBy(0)
				.reduceGroup(new AggAndFilter(Double.MIN_VALUE));

		DataSet<Tuple2<Long, Double>> initialDeltas = initialRanks.map(new InitialDeltaBuilder(numVertices));


		// ---------- iterative part ---------

		DeltaIteration<Tuple2<Long, Double>, Tuple2<Long, Double>> adaptiveIteration = initialRanks.iterateDelta(initialDeltas, numIterations, 0);

		DataSet<Tuple2<Long, Double>> deltas = adaptiveIteration.getWorkset()
				.join(adjacency2).where(0).equalTo(0).with(new DeltaDistributor(0.85))
				.groupBy(0)
				.reduceGroup(new AggAndFilter(threshold));

		DataSet<Tuple2<Long, Double>> rankUpdates = adaptiveIteration.getSolutionSet()
				.join(deltas).where(0).equalTo(0).with(new SolutionJoin());

		adaptiveIteration.closeWith(rankUpdates, deltas)
				.writeAsCsv(outpath + "_adapt", WriteMode.OVERWRITE);


//		System.out.println(env.getExecutionPlan());
		env.execute("Adaptive Page Rank");
	}



	public static final class AdjacencyBuilder implements MapFunction<String, Tuple2<Long, long[]>> {

		@Override
		public Tuple2<Long, long[]> map(String value) throws Exception {
			String[] parts = value.split(" ");
			if (parts.length < 1) {
				throw new Exception("Malformed line: " + value);
			}

			long id = Long.parseLong(parts[0]);
			long[] targets = new long[parts.length - 1];
			for (int i = 0; i < targets.length; i++) {
				targets[i] = Long.parseLong(parts[i+1]);
			}
			return new Tuple2<Long, long[]>(id, targets);
		}
	}

	public static final class InitialMessageBuilder implements FlatMapFunction<Tuple2<Long, long[]>, Tuple2<Long, Double>> {

		private final double initialRank;
		private final double dampeningFactor;
		private final double randomJump;

		public InitialMessageBuilder(double numVertices, double dampeningFactor) {
			this.initialRank = 1.0 / numVertices;
			this.dampeningFactor = dampeningFactor;
			this.randomJump = (1.0 - dampeningFactor) / numVertices;
		}

		@Override
		public void flatMap(Tuple2<Long, long[]> value, Collector<Tuple2<Long, Double>> out) {
			long[] targets = value.f1;
			double rankPerTarget = initialRank * dampeningFactor / targets.length;

			// dampend fraction to targets
			for (long target : targets) {
				out.collect(new Tuple2<Long, Double>(target, rankPerTarget));
			}

			// random jump to self
			out.collect(new Tuple2<Long, Double>(value.f0, randomJump));
		}
	}

	public static final class InitialDeltaBuilder implements MapFunction<Tuple2<Long, Double>, Tuple2<Long, Double>> {

		private final double uniformRank;

		public InitialDeltaBuilder(long numVertices) {
			this.uniformRank = 1.0 / numVertices;
		}

		@Override
		public Tuple2<Long, Double> map(Tuple2<Long, Double> initialRank) {
			initialRank.f1 -= uniformRank;
			return initialRank;
		}
	}


	public static final class DeltaDistributor implements FlatJoinFunction<Tuple2<Long, Double>, Tuple2<Long, long[]>, Tuple2<Long, Double>> {

		private final Tuple2<Long, Double> tuple = new Tuple2<Long, Double>();

		private final double dampeningFactor;


		public DeltaDistributor(double dampeningFactor) {
			this.dampeningFactor = dampeningFactor;
		}


		@Override
		public void join(Tuple2<Long, Double> deltaFromPage, Tuple2<Long, long[]> neighbors, Collector<Tuple2<Long, Double>> out) {
			long[] targets = neighbors.f1;

			double deltaPerTarget = dampeningFactor * deltaFromPage.f1 / targets.length;

			tuple.f1 = deltaPerTarget;
			for (long target : targets) {
				tuple.f0 = target;
				out.collect(tuple);
			}
		}
	}

	@ConstantFields("0")
	public static final class AggAndFilter extends RichGroupReduceFunction<Tuple2<Long, Double>, Tuple2<Long, Double>> {

		private final double threshold;

		public AggAndFilter(double threshold) {
			this.threshold = threshold;
		}

		@Override
		public void reduce(Iterable<Tuple2<Long, Double>> values, Collector<Tuple2<Long, Double>> out)  {
			Long key = null;
			double delta = 0.0;

			for (Tuple2<Long, Double> t : values) {
				key = t.f0;
				delta += t.f1;
			}

			if (Math.abs(delta) > threshold) {
				out.collect(new Tuple2<Long, Double>(key, delta));
			}
		}
	}

	@ConstantFieldsFirst("0")
	@ConstantFieldsSecond("0")
	public static final class SolutionJoin implements JoinFunction<Tuple2<Long, Double>, Tuple2<Long, Double>, Tuple2<Long, Double>> {

		@Override
		public Tuple2<Long, Double> join(Tuple2<Long, Double> page, Tuple2<Long, Double> delta) {
			page.f1 += delta.f1;
			return page;
		}
	}
}
