#!/bin/bash

echo "Running Spark wordcount example"

. ./configDefaults.sh

HOST=`hostname`
$SPARK_HOME/bin/spark-submit --master spark://$HOST:7077 \
 --deploy-mode cluster --class com.github.projectflink.spark.WordCount \
 `ls "$TESTJOB_HOME"/target/flink-perf-*-SparkWC.jar` \
 spark://$HOST:7077 $HDFS_WC $HDFS_SPARK_WC_OUT


