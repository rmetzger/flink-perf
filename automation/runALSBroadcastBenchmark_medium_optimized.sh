#!/bin/bash

echo "Running ALS for flink"

. ./configDefaults.sh

echo "running ALS with dop=$BC_DOP"
$FLINK_BUILD_HOME"/bin/flink" run -v -p $BC_DOP -c "com.github.projectflink.alsjava.ALS" "/home/hadoop/als-1.0-SNAPSHOT-flink-fat-jar.jar" 20 10 1 hdfs:///datasets/als-benchmark4000000-500000-300 hdfs:///datasets/als-results-4000000-500000-300

