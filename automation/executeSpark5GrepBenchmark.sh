for i in 1 2 3; do
	echo "i = $i"
	echo "running spark 5 terms grep $i" >> log_spark_5grep_driver
	start1=`date +%s`
	./runSparkGrep.sh tree house garden nomatchterm soda >> log_spark_5grep_driver
	end=`date +%s`
	runtime=$((end-start1))
	echo "runtime=$runtime" >> log_spark_5grep_driver
done
