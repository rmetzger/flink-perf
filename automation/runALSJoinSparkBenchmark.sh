#!/bin/bash

echo "Running ALS for flink"

. ./configDefaults.sh

echo "running ALS with dop=$DOP"
$FLINK_BUILD_HOME"/bin/flink" run -v -c com.github.projectflink.spark.als.ALSJoin -p $DOP $TESTJOB_HOME"/flink-jobs/target/flink-jobs-*-SNAPSHOT.jar" spark://$SPARK_MASTER 15 1 10 0 rand hdfs:///datasets/als-benchmark40000000-5000000-700/ hdfs:///datasets/als-results40000000-5000000-700/
