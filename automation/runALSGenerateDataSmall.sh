#!/bin/bash

echo "Running ALS data generation"

. ./configDefaults.sh

echo "running ALS data generation with dop=$DOP"
$FLINK_BUILD_HOME"/bin/flink" run -v -c com.github.projectflink.als.ALSDataGeneration -p $DOP $TESTJOB_HOME"/flink-jobs/target/flink-jobs-*-SNAPSHOT.jar" 4000000 500000 20 4 300 100 hdfs:///datasets/als-benchmark

