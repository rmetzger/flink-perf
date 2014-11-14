for i in 50 100 150 200 250; do
	echo "running flink grep data size $i" >> log_flink_grep_cache_driver
	start1=`date +%s`
	./runCachedGrep.sh $i >> log_flink_grep_cache_driver
	end=`date +%s`
	runtime=$((end-start1))
	echo "runtime=$runtime" >> log_flink_grep_cache_driver
done
