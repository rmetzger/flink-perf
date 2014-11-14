for i in 50 100 150 200 250; do
	echo "running spark grep data size $i" >> log_spark_grep_cache_driver
	start1=`date +%s`
	./runSparkCachedGrep.sh $i >> log_spark_grep_cache_driver
	end=`date +%s`
	runtime=$((end-start1))
	echo "runtime=$runtime" >> log_spark_grep_cache_driver
done
