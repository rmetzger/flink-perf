#!/bin/bash

echo "Running Spark KMeans Low Dimension"

. ./configDefaults.sh

ARGS="$SPARK_MASTER $HDFS_KMEANS_PERF_POINTS $HDFS_KMEANS_PERF_CENTERS $HDFS_SPARK_KMEANS_OUT $ITERATIONS $DOP"
echo "running KMeans with args $ARGS"
echo "SPARKYARN = $SPARK_YARN"



CALL="$SPARK_HOME/bin/spark-submit --master $SPARK_MASTER $SPARK_YARN --class com.github.projectflink.spark.KMeansArbitraryDimension "`ls "$TESTJOB_HOME"/spark-jobs/target/spark-jobs-*-All.jar`" $ARGS"

echo "CALL=$CALL"

$CALL
