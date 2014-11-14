 #!/bin/bash

echo "Running Spark wordcount example"

. ./configDefaults.sh

$SPARK_HOME/bin/spark-submit --master spark://$SPARK_MASTER \
 --class com.github.projectflink.spark.Grep \
 --driver-memory 8G \
 `ls "$TESTJOB_HOME"/spark-jobs/target/spark-jobs-*-All.jar` \
 spark://cloud-11.dima.tu-berlin.de:7077 hdfs:///user/robert/datasets/access-1000.log hdfs:///user/robert/playground/spark-grep-out $*


