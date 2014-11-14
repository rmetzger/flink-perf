#!/bin/bash

echo "Running ALSJoin for Spark with small data"

. ./configDefaults.sh

echo "running ALSJoin for Spark with dop=$DOP"
$FLINK_BUILD_HOME"/bin/flink" run -v -c com.github.projectflink.spark.als.ALSJoin -p $DOP $TESTJOB_HOME"/flink-jobs/target/flink-jobs-*-SNAPSHOT.jar" spark://$SPARK_MASTER 15 1 10 0 rand hdfs:///datasets/als-benchmark4000000-500000-300/ hdfs:///datasets/als-results4000000-500000-300/
