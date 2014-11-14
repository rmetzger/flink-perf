#!/bin/bash

echo "Running ALSMLLib for spark with small data"

. ./configDefaults.sh

echo "running ALSMLLib for spark with dop=$DOP with small data"
$SPARK_HOME/bin/spark-submit --master spark://$SPARK_MASTER \
 --class com.github.projectflink.spark.als.ALSMLLib \
 --driver-memory 8G \
 `ls "$TESTJOB_HOME"/spark-jobs/target/spark-jobs-*-SNAPSHOT.jar` \
 spark://$SPARK_MASTER 15 1 10 $DOP rand hdfs:///datasets/als-benchmark400000-50000-100/ hdfs:///datasets/als-results-400000-50000-100/

