for i in 1 2 3; do
	echo "i = $i"
	echo "running flink 5 terms grep $i" >> log_flink_5grep_driver
	start1=`date +%s`
	./runGrep.sh tree house garden nomatchterm soda >> log_flink_5grep_driver
	end=`date +%s`
	runtime=$((end-start1))
	echo "runtime=$runtime" >> log_flink_5grep_driver
done
