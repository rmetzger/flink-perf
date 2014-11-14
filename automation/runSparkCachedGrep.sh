 #!/bin/bash

echo "Running Spark wordcount example"

. ./configDefaults.sh

$SPARK_HOME/bin/spark-submit --master spark://$SPARK_MASTER \
 --class com.github.projectflink.spark.GrepCaching \
 --driver-memory 8G \
 `ls "$TESTJOB_HOME"/spark-jobs/target/spark-jobs-*-All.jar` \
 spark://$SPARK_MASTER hdfs:///user/robert/datasets/access-$1.log hdfs:///user/robert/playground/spark-grep-out lemon tree garden nonmatchinggrep keyboards

