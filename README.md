# Testing Different Data Models

## Learning Goals

- Hands on understanding of performance changes using different data models

## Instructions

We've covered the different general classes that NoSQL database systems can fall into, and have briefly run through some
examples to see first hand what sort of data model they implement. However, we've not yet implemented any common tasks across all of them.
Let's go ahead and implement some straightforward processes using all these systems, and gather some performance data
on the output. We should expect to see some highly optimized runtimes when various NoSQL systems are used towards their
strengths, and possibly severe degradation when the wrong systems are selected.

## Setup

Let's go ahead and instantiate some data structures across these different DB types. We would like to implement the following
relations across all the systems:

Model 1

|  key  | value |
|-------|-------|
| word1 | word1 |
| word2 | word2 |
| word3 | word3 |
| ...   | ...   |
| wordn | wordn |

Model 2

| key   |   base64   |
|-------|------------|
| word1 | b64(word1) |
| word2 | b64(word2) |
| word3 | b64(word3) |
| ...   | ...        |
| wordn | b64(wordn) |

|   base64   | key   |
|------------|-------|
| b64(word1) | word1 |
| b64(word2) | word2 |
| b64(word3) | word3 |
| ...        | ...   |
| b64(wordn) | wordn |

Model 3

| id  |  key  |
|-----|-------|
|  1  | word1 |
|  2  | word2 |
|  3  | word3 |
| ... | ...   |
|  n  | wordn |


This is a fairly simple design, but it should be all that is needed to test out key/value type selections, multi-table joins, and partial text searches.


You can run the below commands to start loading this data into the containers. Some of them do take a few minutes to complete loading. 


``` shell
docker cp words_alpha.txt postgres-lab:/
docker cp postgres-data.sh postgres-lab:/
docker exec -it postgres-lab chmod +x /postgres-data.sh
docker exec -it postgres-lab /postgres-data.sh

docker cp words_alpha.txt redis-lab:/
docker cp redis-data.sh redis-lab:/
docker exec -it redis-lab chmod +x /redis-data.sh
docker exec -it redis-lab /redis-data.sh

docker cp words_alpha.txt elasticsearch-lab:/
docker cp elasticsearch-data.sh elasticsearch-lab:/
docker exec -it elasticsearch-lab chmod +x /elasticsearch-data.sh
docker exec -it elasticsearch-lab /elasticsearch-data.sh

docker cp words_alpha.txt cassandra-lab:/
docker cp cassandra-data.sh cassandra-lab:/
docker exec -it cassandra-lab chmod +x /cassandra-data.sh
docker exec -it cassandra-lab /cassandra-data.sh
```

What we would like to do is test similar data models across all these DB types.

However, we are immediately running into our first blocker; that the differing Database systems don't necessarily support the feature sets we need.
Only Postgres natively supports the three types of queries we want to test.
Redis doesn't support any type of join, or partial text search.
Elasticsearch doesn't support joins.
Cassandra doesn't support joins, and partial text search is only supported by adding non-standard index types.


At this point, go ahead and put together some simple queries to compare performance between these different DB systems.
You can go back and use the documentation linked in the previous lab for these examples, and go from there for
any specific syntax you don't know.

We'll need to query for the following:

1. Key/Value search against Model 1 on Postgres
2. Key/Value search against Model 1 on Redis
3. Key/Value search against Model 1 on Elasticsearch
4. Key/Value search against Model 1 on Cassandra
5. Partial text search against Model 3 on Postgres
6. Partial text search against Model 3 on Elasticsearch
7. Table join against Model 2 on Postgres


> Note: You can use the following DB specific commands for gathering performance data on queries
>
> Postgres: `EXPLAIN ANALYZE` ...
>
> Redis: Running queries inside a transaction with bounding TIME commands, and taking the difference:
> ``` shell
> 192.168.1.1:6379> MULT
> OK
> 192.168.1.1:6379> TIME
> QUEUED
> 192.168.1.1:6379> SET key value
> QUEUED
> 192.168.1.1:6379> TIME
> QUEUED
> 192.168.1.1:6379> EXEC
> 1) 1) "1658420481" (seconds)
>    2) "691484"     (microseconds)
> 2) OK
> 3) 1) "1658420481" (seconds)
>    2) "691542"     (microseconds)
> ```
>
> Elasticsearch: The "took" value in a returned search response cooresponds to **milliseconds** taken.
> You can also pass the following in a query to get more granular time breakdowns:
> ``` shell
> {
>   "profile": true,
>   "query": ...
> }
>```
>
> Cassandra: `TRACING ON/OFF` can be set in the cli prior to running queries 
>
>
> Run these performance tools a few times for each query, and take an average.

## Advanced Lab

Try implementing joining data models in the Neo4j Graph DB using the Model 2 from above, and compare with Postgres.
You can also try constructing arbitrarily long joins to see just how far a native Graph DB can be pushed.
