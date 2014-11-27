export SIZE=$1
for i in 1 2 3 4 5; do
	echo "i = $i"
	echo "running spark cached grep $i with $SIZE in exec" >> log_spark_5_cached_grep_driver
	start1=`date +%s`
	./runSparkCachedGrep.sh tree house garden nomatchterm soda >> log_spark_5_cached_grep_driver
	end=`date +%s`
	runtime=$((end-start1))
	echo "runtime=$runtime" >> log_spark_5_cached_grep_driver
done
