 #!/bin/bash

echo "Running Spark PR example"

. ./configDefaults.sh

$SPARK_HOME/bin/spark-submit --master $SPARK_MASTER $SPARK_YARN \
 --class com.github.projectflink.spark.Pagerank \
 --driver-memory 8G \
 `ls "$TESTJOB_HOME"/spark-jobs/target/spark-jobs-*-All.jar` \
 $SPARK_MASTER 41652230 0.5 80 $HDFS_PAGERANK_OUT $HDFS_PAGERANK_IN $DOP


