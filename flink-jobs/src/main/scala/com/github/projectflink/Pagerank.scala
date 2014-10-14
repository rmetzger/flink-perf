package com.github.projectflink

import org.apache.flink.api.scala._

import scala.util.Random

/**
 * Skeleton for a Flink Job.
 *
 * For a full example of a Flink Job, see the WordCountJob.scala file in the
 * same package/directory or have a look at the website.
 *
 * You can also generate a .jar file that you can submit on your Flink
 * cluster. Just type
 * {{{
 *   mvn clean package
 * }}}
 * in the projects root directory. You will find the jar in
 * target/flink-quickstart-0.1-SNAPSHOT-Sample.jar
 *
 */
object Pagerank {
  case class Pagerank(node: Int, rank: Double){
    def +(pagerank: Pagerank) = {
      Pagerank(node, rank + pagerank.rank)
    }
  }
  case class AdjacencyRow(node: Int, neighbours: Array[Int]){
    override def toString: String = {
      s"$node: ${neighbours.mkString(",")}"
    }
  }

  val numVertices = 1000
  val dampingFactor = 0.85
  val maxIterations = 10

  def main(args: Array[String]) {
    // set up the execution environment
    ExecutionEnvironment.createCollectionsEnvironment
    val env = ExecutionEnvironment.getExecutionEnvironment

    val adjacencyMatrix = getInitialAdjacencyMatrix(numVertices, env)
    val initialPagerank = getInitialPagerank(numVertices, env)

    val solution = initialPagerank.iterateWithTermination(maxIterations) {
      pagerank =>
        val nextPagerank = pagerank.join(adjacencyMatrix).where(_.node).equalTo(_.node)
          .flatMap {
          _ match{
            case (Pagerank(node, rank), AdjacencyRow(_, neighbours)) =>{
              val length = neighbours.length
              (neighbours map {
                Pagerank(_, dampingFactor*rank/length)
              }) :+ Pagerank(node, (1-dampingFactor)/numVertices)
            }
          }
        }.groupBy(_.node).reduce(_ + _)

        val termination = pagerank.join(nextPagerank).where(_.node).equalTo(_.node).flatMap{
          _ match {
            case (Pagerank(_, left), Pagerank(_, right)) => if(left != right) {
              Some(left)
            }else{
              None
            }
          }
        }

        (nextPagerank, termination)
    }

    adjacencyMatrix.print()

    solution.print()

    env.execute("Flink Scala API Skeleton")
  }

  def getInitialPagerank(numVertices: Int, env: ExecutionEnvironment): DataSet[Pagerank] = {
    env.fromCollection(1 to numVertices map { i => Pagerank(i, 1.0d/numVertices)})
  }

  def getInitialAdjacencyMatrix(numVertices: Int, env: ExecutionEnvironment):
  DataSet[AdjacencyRow] = {
    env.fromCollection(1 to numVertices).map{
      node =>
        val rand = new Random(node)
        val neighbours = for(i <- 1 to numVertices if(i != node && rand.nextDouble() > 0.5)) yield {

          i
        }

        AdjacencyRow(node, neighbours.toArray)
    }
  }
}