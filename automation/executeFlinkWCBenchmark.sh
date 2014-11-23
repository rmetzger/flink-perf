for i in 1 2 3; do
	echo "running flink wc $i" >> log_flink_wc_driver
	start1=`date +%s`
	./runWC-JAPI.sh >> log_flink_wc_driver
	end=`date +%s`
	runtime=$((end-start1))
	echo "runtime=$runtime" >> log_flink_wc_driver
done
