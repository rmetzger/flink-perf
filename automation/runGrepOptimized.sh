#!/bin/bash

echo "Running readonly for flink"

. ./configDefaults.sh

echo "running wc with dop=$DOP"
$FLINK_BUILD_HOME"/bin/flink" run -v -c com.github.projectflink.grep.GrepJobOptimized -p $DOP \
 $TESTJOB_HOME"/flink-jobs/target/flink-jobs-*-SNAPSHOT.jar" hdfs:///datasets/wordcoun-1000 hdfs:///user/robert/playground/flink-grep-out $*
