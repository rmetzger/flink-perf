for i in 1 2 3; do
	echo "i = $i"
	echo "running spark PR $i" >> log_spark_PR_driver
	start1=`date +%s`
	./runSparkPagerank.sh >> log_spark_PR_driver 2>&1
	end=`date +%s`
	runtime=$((end-start1))
	echo "runtime=$runtime" >> log_spark_PR_driver
done
