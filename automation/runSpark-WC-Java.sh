#!/bin/bash

echo "Running Spark wordcount example"

. ./configDefaults.sh


$SPARK_HOME/bin/spark-submit --master spark://$SPARK_MASTER \
 --class com.github.projectflink.spark.WordCount \
 `ls "$TESTJOB_HOME"/spark-jobs/target/spark-jobs-*-SparkWC.jar` \
 spark://$SPARK_MASTER $HDFS_WC $HDFS_SPARK_WC_OUT


