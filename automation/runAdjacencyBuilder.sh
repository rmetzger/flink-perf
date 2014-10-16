#!/bin/bash

echo "Running readonly for flink"

. ./configDefaults.sh

echo "running wc with dop=$DOP"
$FLINK_BUILD_HOME"/bin/flink" run -c com.github.projectflink.pagerank.AdjacencyBuilder -p $DOP $TESTJOB_HOME"/flink-jobs/target/flink-jobs-*-SNAPSHOT.jar" hdfs:///user/robert/datasets/twitter-follower-graph hdfs:///user/robert/datasets/twitter-follower-graph-adi