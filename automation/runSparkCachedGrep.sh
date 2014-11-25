 #!/bin/bash

echo "Running Spark wordcount example"

. ./configDefaults.sh

$SPARK_HOME/bin/spark-submit --master $SPARK_MASTER \
 --class com.github.projectflink.spark.GrepCaching \
 $SPARK_YARN \
 `ls "$TESTJOB_HOME"/spark-jobs/target/spark-jobs-*-All.jar` \
  $SPARK_MASTER hdfs:///datasets/wordcoun-1000 hdfs:///user/robert/playground/spark-multi-grep-out $*

