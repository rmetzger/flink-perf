 #!/bin/bash

echo "Running Spark wordcount example"

. ./configDefaults.sh

$SPARK_HOME/bin/spark-submit --master spark://$SPARK_MASTER \
 --class com.github.projectflink.spark.GroupReduceBenchmarkSpark \
 --driver-memory 8G \
 `ls "$TESTJOB_HOME"/spark-jobs/target/spark-jobs-*-All.jar` \
 spark://$SPARK_MASTER $DOP 5 hdfs:///datasets/$1 hdfs:///datasets/group-reduce-output-k5
 #spark://$SPARK_MASTER $DOP 5 hdfs:///datasets/group-reduce-benchmark100-200000-100000000-35.0 hdfs:///datasets/group-reduce-output-k5



