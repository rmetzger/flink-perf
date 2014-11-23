for i in 1 2 3; do
	echo "running flink wc $i" >> log_spark_wc_driver
	start1=`date +%s`
	./runSpark-WC-Java.sh >> log_spark_wc_driver
	end=`date +%s`
	runtime=$((end-start1))
	echo "runtime=$runtime" >> log_spark_wc_driver
done
