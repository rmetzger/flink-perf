for i in "lemon" "lemon tree" "lemon tree garden" "lemon tree garden nonmatchinggrep" "lemon tree garden nonmatchinggrep keyboards"; do
	echo "running spark grep for terms $i" >> log_spark_grep_driver
	start1=`date +%s`
	./runSparkGrep.sh $i >> log_spark_grep_driver
	end=`date +%s`
	runtime=$((end-start1))
	echo "runtime=$runtime" >> log_spark_grep_driver
done
