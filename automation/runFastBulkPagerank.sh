#!/bin/bash

echo "Running readonly for flink"

. ./configDefaults.sh

echo "running fast bulk pr with dop=$DOP"
$FLINK_BUILD_HOME"/bin/flink" run -c com.github.projectflink.pagerank.PageRankStephan -p $DOP $TESTJOB_HOME"/flink-jobs/target/flink-jobs-*-SNAPSHOT.jar" $HDFS_PAGERANK_IN $HDFS_PAGERANK_OUT 80 41652230
