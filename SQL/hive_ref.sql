--Favorite MapReduce Settings:
set hive.mapred.mode=nonstrict;
set hive.support.concurrency=true;
set hive.exec.dynamic.partition = true;
set hive.exec.dynamic.partition.mode = nonstrict;
set hive.execution.engine=mr;
set hive.vectorized.execution.reduce.enabled=false;
set hive.vectorized.execution.enabled=false;
set mapred.reduce.slowstart.completed.maps = 0.7;
set mapreduce.map.memory.mb=18000;
set mapreduce.map.java.opts=-Xmx14400m;
set mapreduce.reduce.memory.mb=18000;
set mapreduce.reduce.java.opts=-Xmx14400m;


--Increase memory (xmx####m should be 80% of total memory setting)
set mapreduce.map.memory.mb=18000;
set mapreduce.map.java.opts=-Xmx14400m;
set mapreduce.reduce.memory.mb=18000;
set mapreduce.reduce.java.opts=-Xmx14400m;


--Tez engine
set hive.execution.engine=tez;
set hive.vectorized.execution.reduce.enabled=true;
set hive.vectorized.execution.enabled=true;


--MR engine
set hive.execution.engine=mr;
set hive.vectorized.execution.reduce.enabled=false;
set hive.vectorized.execution.enabled=false;


--delay reducers until maps are done (0.0 starts reducers immediately, 1.0 starts reducers only when all mappers are done)
set mapred.reduce.slowstart.completed.maps = 0.9;


--Misc ?
set hive.auto.convert.join=true;


--Table creation with snappy compression and ORC file type
create table … partitioned by … STORED AS ORC TBLPROPERTIES ("orc.compress"="SNAPPY")



--to avoid illegal capacity error (if using Tez.  Or, switch to MR) (not sure how to decide the right quantities):
set hive.merge.tezfiles=true;
set hive.merge.smallfiles.avgsize=768000000;
set hive.merge.size.per.task=768000000;