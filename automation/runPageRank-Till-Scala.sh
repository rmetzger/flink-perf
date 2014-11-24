#!/bin/bash

echo "Running Scala Page Rank"

. ./configDefaults.sh

echo "running wc with dop=$DOP"
ARGS="$HDFS_PAGERANK_IN $HDFS_PAGERANK_OUT 41652230 20"
echo "A = $ARGS"
#exit
$FLINK_BUILD_HOME"/bin/flink" run -v -c com.github.projectflink.Pagerank -p $DOP $TESTJOB_HOME"/flink-jobs/target/flink-jobs-*-SNAPSHOT.jar" $ARGS
