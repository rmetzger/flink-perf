#!/bin/bash

echo "Running wordcount example"

. ./configDefaults.sh

ARGS="$HDFS_WC $HDFS_WC_OUT-hash"
echo "running wc with args $ARGS"
$FLINK_BUILD_HOME"/bin/flink" run $TESTJOB_HOME"/flink-jobs/target/flink-jobs-*-SNAPSHOT.jar" -p $DOP -c com.github.projectflink.testPlan.WordCountHashAgg $ARGS

