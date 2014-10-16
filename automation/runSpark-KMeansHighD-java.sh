#!/bin/bash

echo "Running Spark KMeans High Dimension"

. ./configDefaults.sh

ARGS="spark://$SPARK_MASTER $HDFS_KMEANS/point-high.txt $HDFS_KMEANS/center-high.txt $HDFS_SPARK_KMEANS_OUT/high 100"
echo "running KMeans with args $ARGS"

$SPARK_HOME/bin/spark-submit --master spark://$SPARK_MASTER \
 --class com.github.projectflink.spark.KMeansArbitraryDimension \
 `ls "$TESTJOB_HOME"/spark-jobs/target/spark-jobs-*.jar` \
 $ARGS

