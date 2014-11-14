 #!/bin/bash

echo "Running Spark wordcount example"

. ./configDefaults.sh

$SPARK_HOME/bin/spark-submit sparkWordcount.py --master spark://$SPARK_MASTER --driver-memory 8G


