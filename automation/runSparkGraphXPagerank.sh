 #!/bin/bash

echo "Running Spark PR example"

. ./configDefaults.sh

ARGS="$SPARK_MASTER 61 hdfs:///datasets/twitter-wo-header $HDFS_PAGERANK_OUT"

echo "args=$ARGS"

$SPARK_HOME/bin/spark-submit --master $SPARK_MASTER $SPARK_YARN \
 --class com.github.projectflink.spark.pagerank.GraphX \
 "$TESTJOB_HOME"/spark-jobs/target/spark-jobs-0.1-SNAPSHOT.jar \
 $ARGS


