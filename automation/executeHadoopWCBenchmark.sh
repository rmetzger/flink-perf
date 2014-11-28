#!/bin/bash

. ./configDefaults.sh

for i in 1 2 3; do
	echo "running hadoop wc $i" >> log_hadoop_wc_driver
	start1=`date +%s`
	hadoop jar /home/hadoop/hadoop-install/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.4.1.jar wordcount $HDFS_WC $HDFS_WC_OUT-hadoop-2-$i >> log_hadoop_wc_driver
	end=`date +%s`
	runtime=$((end-start1))
	echo "runtime=$runtime" >> log_hadoop_wc_driver
done
