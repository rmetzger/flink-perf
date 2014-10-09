package com.github.projectflink.spark;

import com.esotericsoftware.kryo.Kryo;
import org.apache.spark.SparkConf;
import org.apache.spark.serializer.KryoSerializer;

/**
* Created by robert on 10/9/14.
*/

public class MyRegistrator extends KryoSerializer {
	public MyRegistrator() {
		super();
	}

	public MyRegistrator(SparkConf conf) {
		super(conf);
	}
	public void registerClasses(Kryo kryo) {
		System.err.println("Registered Point with Kryo");
		kryo.register(KMeansArbitraryDimension.Point.class);
	}

}
