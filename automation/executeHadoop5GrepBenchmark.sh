. ./configDefaults.sh

for i in 1 2 3; do
	echo "i = $i"
	echo "running hadoop 5 terms 1TB grep $i" >> log_hadoop_5grep_driver
	start1=`date +%s`
	hadoop jar workdir/testjob/hadoop-jobs/target/hadoop-jobs-0.1-SNAPSHOT.jar com.github.projectflink.hadoop.GrepDriver hdfs:///datasets/wordcount-200 hdfs:///user/robert/playground/hadoop-grep-ou-2-200-$i tree house garden nomatchterm soda >> log_hadoop_5grep_driver
	end=`date +%s`
	runtime=$((end-start1))
	echo "runtime=$runtime" >> log_hadoop_5grep_driver
done
