#!/bin/bash

echo "Running Spark KMeans Low Dimension"
exit

. ./configDefaults.sh

ARGS="spark://$SPARK_MASTER $HDFS_KMEANS_PERF_POINTS $HDFS_KMEANS_PERF_CENTERS $HDFS_SPARK_KMEANS_OUT $ITERATIONS"
echo "running KMeans with args $ARGS"

$SPARK_HOME/bin/spark-submit --master spark://$SPARK_MASTER \
 --class com.github.projectflink.spark.KMeansArbitraryDimension --executor-memory 16G \
 --jars `ls "$TESTJOB_HOME"/spark-jobs/target/spark-jobs-*-All.jar` `ls "$TESTJOB_HOME"/spark-jobs/target/spark-jobs-*-All.jar` $ARGS