for i in 1 2 3; do
	echo "i = $i"
	echo "running flink PR $i" >> log_flink_PR_driver
	start1=`date +%s`
	./runFastBulkPagerank.sh >> log_flink_PR_driver
	end=`date +%s`
	runtime=$((end-start1))
	echo "runtime=$runtime" >> log_flink_PR_driver
done
