/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.github.projectflink

import org.apache.flink.api.common.operators.Order
import org.apache.flink.api.scala._
import org.apache.flink.core.fs.FileSystem.WriteMode
import org.apache.flink.util.Collector

import scala.collection.mutable
import scala.util.Random

object GroupReduceBenchmarkFlink {
  val rnd = new Random(System.currentTimeMillis())

  private final def skewedSample(skew: Double, max: Int): Int = {
    val uniform = rnd.nextDouble()
    val `var` = Math.pow(uniform, skew)
    val pareto = 0.2 / `var`
    val `val` = pareto.toInt
    if (`val` > max) `val` % max else `val`
  }

  def main(args: Array[String]) {
    if (args.length < 4) {
      println("Usage: [numCountries] [numBooks] [numReads] [skew]")
      return
    }

    var master = args(0)
    var dop = args(1).toInt
    var numCountries = args(2).toInt
    var numBooks = args(3).toInt
    var numReads = args(4).toInt
    var skew = args(5).toFloat
    var k = args(6).toInt
    val outputPath = if (args.length > 7) {
      args(7)
    } else {
      null
    }

    val hash = mutable.HashMap[Int, Int]()

    for (i <- 0 to numReads) {
      val key = skewedSample(skew, numCountries - 1)
      val prev: Int = hash.getOrElse(key, 0)
      hash.put(key, prev + 1)
    }

    val readsInCountry = hash.values.toArray


    // set up the execution environment
    val env = ExecutionEnvironment.getExecutionEnvironment
    env.setDegreeOfParallelism(dop);

    val countryIds = env.generateSequence(0, numCountries - 1)
    val bookIds = env.generateSequence(0, numBooks - 1)

    val countryNames = countryIds map { id => (id.toInt, rnd.nextString(20)) }
    val bookNames = bookIds map { id => (id.toInt, rnd.nextString(30)) }

    val reads = countryIds flatMap {
      (id, out: Collector[(Int, Int)]) =>
        val numReads = readsInCountry(id.toInt)
        for (i <- 0 until numReads) {
          out.collect((id.toInt, rnd.nextInt(numBooks)))
        }
    }

    val readsWithCountry = reads.join(countryNames).where("_1").equalTo("_1") {
      (left, right) =>
        (right._2, left._2)
    }

    val readsWithCountryAndBook = readsWithCountry.join(bookNames).where("_2").equalTo("_1") {
      (left, right) =>
        (left._1, right._2)
    }

    // Group by country and determine top-k books
    val result = readsWithCountryAndBook
      .map { in => (in._1, in._2, 1) }
      .groupBy("_1", "_2")
      .sum("_3")
      .groupBy("_1").sortGroup("_3", Order.DESCENDING)
      .reduceGroup {
      in =>
        val it = in.toIterator.buffered
        val first = it.head
        val topk = it.take(k) map { t => (t._2, t._3) }
        (first._1, topk.mkString(", "))
    }

    if (outputPath == null) {
      result.print()
    } else {
      result.writeAsText(outputPath + "_flink", WriteMode.OVERWRITE)
    }

    // execute program
    env.execute("Flink Scala API Skeleton")
  }
}

