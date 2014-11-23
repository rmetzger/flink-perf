 #!/bin/bash

echo "Running Spark wordcount example"

. ./configDefaults.sh

$SPARK_HOME/bin/spark-submit --master $SPARK_MASTER \
 --class com.github.projectflink.spark.Grep --executor-memory 40g --num-executors $EXECUTORS --driver-memory 30g --executor-cores 8 \
 `ls "$TESTJOB_HOME"/spark-jobs/target/spark-jobs-*-All.jar` \
 $SPARK_MASTER hdfs:///datasets/wordcoun-1000 hdfs:///user/robert/playground/spark-grep-out $*


