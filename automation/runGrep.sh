#!/bin/bash

echo "Running readonly for flink"

. ./configDefaults.sh

echo "running wc with dop=$DOP"
$FLINK_BUILD_HOME"/bin/flink" run -c com.github.projectflink.grep.GrepJob -p $DOP $TESTJOB_HOME"/flink-jobs/target/flink-jobs-*-SNAPSHOT.jar" hdfs:///user/robert/datasets/access-1000.log hdfs:///user/robert/playground/flink-grep-out $*
