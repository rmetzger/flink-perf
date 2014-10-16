 #!/bin/bash

echo "Running Spark wordcount example"

. ./configDefaults.sh

$SPARK_HOME/bin/spark-submit --master spark://$SPARK_MASTER \
 --class com.github.projectflink.spark.Pagerank \
 --driver-memory 8G \
 `ls "$TESTJOB_HOME"/spark-jobs/target/spark-jobs-*-All.jar` \
 spark://cloud-11:7077 41652230 0.5 10 $HDFS_PAGERANK_OUT $HDFS_PAGERANK_IN 384


