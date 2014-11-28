#!/bin/bash

echo "Running readonly for flink"

. ./configDefaults.sh

echo "running wc with dop=$DOP"
$FLINK_BUILD_HOME"/bin/flink" run -c com.github.projectflink.grep.GrepJob -p $DOP $TESTJOB_HOME"/flink-jobs/target/flink-jobs-*-SNAPSHOT.jar" hdfs:///datasets/wordcount-200 hdfs:///user/robert/playground/flink-grep-out $*
