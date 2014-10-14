package com.github.projectflink.spark


import org.apache.spark.rdd.RDD
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.SparkContext._

import _root_.scala.collection.mutable


object Pagerank {

  def main(args: Array[String]): Unit = {
    val master = args(0)
    val numVertices = args(1).toInt
    val sparsity = args(2).toDouble
    val maxIterations = args(3).toInt
    val output = if(args.length > 4){
      args(4)
    }else{
      null
    }
    val input = args(5)

    val dampingFactor = 0.85

    val conf = new SparkConf().setAppName("Spark pagerank").setMaster(master)
    conf.set("spark.hadoop.skipOutputChecks", "false")
    implicit val sc = new SparkContext(conf)

    val inData : RDD[String] = sc.textFile(input.toString)
    val inKV = inData.map { line:String =>
      val sp = line.split(" ")
      (sp(0).toInt, sp(1).toInt)
    }
    val grouped = inKV.groupByKey();

    val adjacencyMatrix = grouped.map{ (tupIn) => // how to use pattern matchin? here, to directly extract the tuple?
      val nList = mutable.MutableList[Int]();
      tupIn._2.foreach ( i => {
        nList += i
      } )
      (tupIn._1, nList)
    }

    var pagerank = grouped.map{ (tup) =>
      (tup._1, 1.0/numVertices)
    }

    //  val adjacencyMatrix = createAdjacencyMatrix(numVertices, sparsity)

  //  var pagerank = createInitialPagerank(numVertices)

    for(i <- 1 to maxIterations) {
      pagerank = pagerank.join(adjacencyMatrix).flatMap {
        case (node, (rank, neighbours)) => {
          neighbours.map {
            (_, dampingFactor * rank / neighbours.length)
          } :+(node, (1 - dampingFactor) / numVertices)
        }
      }.reduceByKey(_ + _)

    }

    if(output != null) {
      pagerank.saveAsTextFile(output)
    }else{
      pagerank.foreach(println _)
    }
  }

  /*def createInitialPagerank(numVertices: Int)(implicit sc: SparkContext) = {
    sc.parallelize(1 to numVertices map ((_, 1.0/numVertices)))
  }

  def createAdjacencyMatrix(numVertices: Int, sparsity: Double)(implicit sc: SparkContext) = {
    sc.parallelize(1 to numVertices).map{
      node =>
        val random = new Random(node)
        val neighbours = 1 to numVertices flatMap {
          n =>
            if(n != node && random.nextDouble() <= sparsity){
              Some(n)
            }else{
              None
            }
        }
        (node, neighbours)
    } */

}
