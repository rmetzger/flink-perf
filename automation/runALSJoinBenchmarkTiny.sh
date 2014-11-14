#!/bin/bash

echo "Running ALS for flink"

. ./configDefaults.sh

echo "running ALS with dop=$DOP"
$FLINK_BUILD_HOME"/bin/flink" run -v -c com.github.projectflink.als.ALSJoin -p $DOP $TESTJOB_HOME"/flink-jobs/target/flink-jobs-*-SNAPSHOT.jar" master 15 1 10 0 rand hdfs:///datasets/als-benchmark400000-50000-100/ hdfs:///datasets/als-results400000-50000-100/
