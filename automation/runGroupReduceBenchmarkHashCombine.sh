#!/bin/bash

echo "Running readonly for flink"

. ./configDefaults.sh

echo "running wc with dop=$DOP"
#$FLINK_BUILD_HOME"/bin/flink" run -v -c com.github.projectflink.GroupReduceBenchmarkFlink -p $DOP $TESTJOB_HOME"/flink-jobs/target/flink-jobs-*-SNAPSHOT.jar" foo $DOP 5 hdfs:///datasets/group-reduce-benchmark100-20000000-2000000000-35.0 hdfs:///datasets/group-deduce-ouput-k5
$FLINK_BUILD_HOME"/bin/flink" run -v -c com.github.projectflink.GroupReduceBenchmarkFlinkHashCombine -p $DOP $TESTJOB_HOME"/flink-jobs/target/flink-jobs-*-SNAPSHOT.jar" foo $DOP 5 hdfs:///datasets/$1 hdfs:///datasets/group-reduce-ouput-k5
