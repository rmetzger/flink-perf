#!/bin/bash

echo "Running ALSJoinBlocking for flink with small data"

. ./configDefaults.sh

echo "running ALSJoinBlocking with dop=$DOP"
$FLINK_BUILD_HOME"/bin/flink" run -v -c com.github.projectflink.als.ALSJoinBlocking -p $DOP \
 $TESTJOB_HOME"/flink-jobs/target/flink-jobs-*-SNAPSHOT.jar" master 15 1 10 `expr 5 \* $DOP` \
rand hdfs:///datasets/als-benchmark4000000-500000-300/ \
hdfs:///datasets/als-results-4000000-500000-300/
