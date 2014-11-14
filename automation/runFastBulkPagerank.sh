#!/bin/bash

echo "Running readonly for flink"

. ./configDefaults.sh

echo "running fast bulk pr with dop=$DOP"
$FLINK_BUILD_HOME"/bin/flink" run -c com.github.projectflink.pagerank.PageRankStephan -p $DOP $TESTJOB_HOME"/flink-jobs/target/flink-jobs-*-SNAPSHOT.jar" hdfs:///user/robert/datasets/twitter-follower-graph-adj $HDFS_PAGERANK_OUT 20 41652230
