#!/bin/bash

echo "Running ALS data generation"

. ./configDefaults.sh

echo "running ALS data generation with dop=$DOP"
$FLINK_BUILD_HOME"/bin/flink" run -v -c com.github.projectflink.als.ALSDataGeneration -p $DOP $TESTJOB_HOME"/flink-jobs/target/flink-jobs-*-SNAPSHOT.jar" 400000 50000 20 4 100 30 hdfs:///datasets/als-benchmark

