#!/bin/bash

echo "Running ALS for flink"

. ./configDefaults.sh

echo "running ALS with $BC_DOP"
$FLINK_BUILD_HOME"/bin/flink" run -v -p $BC_DOP -c "com.github.projectflink.alsjava.ALS" "/home/hadoop/als-1.0-SNAPSHOT-flink-fat-jar.jar" 20 10 1 hdfs:///datasets/als-benchmark400000-50000-100 hdfs:///datasets/als-results-400000-50000-100

