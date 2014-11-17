#!/bin/bash

echo "Running TPCH-3"

. ./configDefaults.sh

HDFS_TPCH3=hdfs:///datasets/tpch/scale_$1
HDFS_TPCH3_OUT=hdfs:///user/aljoscha/results/tpch3

ARGS="$HDFS_TPCH3/lineitem.tbl $HDFS_TPCH3/customer.tbl $HDFS_TPCH3/orders.tbl $HDFS_TPCH3_OUT"
echo "running TPCH-3 DOP: $DOP with args $ARGS"
$FLINK_BUILD_HOME"/bin/flink" run -p $DOP flink-java-examples.jar \
 -c org.apache.flink.examples.java.relational.TPCHQuery3 $ARGS

echo "ran TPCH-3 DOP: $DOP with args $ARGS"

