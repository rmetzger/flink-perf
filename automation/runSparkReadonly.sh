#!/bin/bash

echo "Running Spark wordcount example"

. ./configDefaults.sh

HOST=`hostname`
$SPARK_HOME/bin/spark-submit --master $SPARK_MASTER \
 --class com.github.projectflink.spark.Readonly \
 `ls "$TESTJOB_HOME"/spark-jobs/target/spark-jobs-*-All.jar` \
 $SPARK_MASTER $*


