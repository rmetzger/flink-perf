#!/bin/bash

echo "Starting Spark"

. ./configDefaults.sh

if [[ $YARN == "true" ]]; then
	echo "YARN or what"
else
	$SPARK_HOME/sbin/start-all.sh
fi
