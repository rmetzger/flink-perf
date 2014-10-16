#!/bin/bash

echo "Running Scala Page Rank"

. ./configDefaults.sh

echo "running wc with dop=$DOP"
$FLINK_BUILD_HOME"/bin/flink" run -c com.github.projectflink.Pagerank -p 100 $TESTJOB_HOME"/flink-jobs/target/flink-jobs-*-SNAPSHOT.jar" $HDFS_PAGERANK_IN $HDFS_PAGERANK_OUT 41652230
