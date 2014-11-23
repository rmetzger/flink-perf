#!/bin/bash

echo "Running Spark wordcount example"

. ./configDefaults.sh


$SPARK_HOME/bin/spark-submit --master $SPARK_MASTER \
 --class com.github.projectflink.spark.WordCount $SPARK_YARN \
 `ls "$TESTJOB_HOME"/spark-jobs/target/spark-jobs-*-SparkWC.jar` \
 $SPARK_MASTER $HDFS_WC $HDFS_SPARK_WC_OUT


