#!/bin/bash

echo "Running Spark wordcount example"

. ./configDefaults.sh

$SPARK_HOME/bin/spark-submit --master spark://$SPARK_MASTER \
 --deploy-mode client --class com.github.projectflink.spark.WordCountGrouping \
 `ls "$TESTJOB_HOME"/spark-jobs/target/spark-jobs-*-SparkWC.jar` \
 spark://$SPARK_MASTER $HDFS_WC $HDFS_SPARK_WC_OUT 400


