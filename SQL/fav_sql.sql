select
b.unitname1
,concat(d.iyyyy_1, '_', d.iyyyy_1_wk) as yr_wk
from bimart.dsf_sale_daily a
left join bimart.management_category_hier_curr b on a.mngcateid=b.mngcateid
left join bimart.dim_date d on a.sale_basis_dy=d.dt
where 1=1
  and a.sale_basis_dy between 20170000 and 20170600
  and a.kind='1'
  and a.sale_type='S'
----------------------------------------------------------------------------------------------------
--Date comparisons in Hive
select d.dt
    -- ,unix_timestamp() as current_time_unix
    -- ,from_unixtime(unix_timestamp()) as current_time_readable
    -- ,from_unixtime(unix_timestamp(),'yyyyMMdd') as current_date_yyyyMMdd
    ,date_add(from_unixtime(unix_timestamp()),-5) current_date_subtraction_yyyyMMdd
    -- ,from_unixtime(unix_timestamp(cast(d.dt as string),'yyyyMMdd')) column_timestamp_from_yyyyMMdd
    ,date_add(from_unixtime(unix_timestamp(cast(d.dt as string),'yyyyMMdd')),-5) column_date_subtraction_yyyy_MM_dd
    ,from_unixtime(unix_timestamp(date_add(from_unixtime(unix_timestamp(cast(d.dt as string),'yyyyMMdd')),-5)),'yyyyMMdd') column_date_subtraction_yyyyMMdd
from bimart.dim_date d
where d.dt='20180110'
----------------------------------------------------------------------------------------------------
--http://hadooptutorial.info/hive-date-functions/
--https://cwiki.apache.org/confluence/display/Hive/LanguageManual+UDF
----------------------------------------------------------------------------------------------------
,datediff(from_unixtime(unix_timestamp(cast(a.dt as string),'yyyyMMdd')),from_unixtime(unix_timestamp(cast(b.start_date as string),'yyyyMMdd'))) as measure_date_index
----------------------------------------------------------------------------------------------------
select * from bimart.dim_date WHERE dt = cast(date_format(date_add(current_date, -15),'yyyyMMdd') as int)
----------------------------------------------------------------------------------------------------
%presto
where dt >= date_format(date_add('day', -15, current_date),'%Y%m%d')
and date_parse(concat(u.first_exposure_date,u.first_exposure_time),'%Y%m%d%H%i%S') <= a.event_time
----------------------------------------------------------------------------------------------------
--compare yyyyMMdd|HHmss to timestamp:
unix_timestamp(cast(concat(u.first_exposure_date,u.first_exposure_time) as string),'yyyyMMddHHmmss') <= unix_timestamp(a.log_time)
----------------------------------------------------------------------------------------------------
--Reproduce XPC metrics:
%presto
with users as (
  select test_option, user_id, first_exposure_date, first_exposure_time 
  from abtest.spark_normal_user where dt='20190108' and abtest_instance_id=19983
)

,events as (
  select u.test_option, u.user_id, a.dt
  from weblog.session_android a
  inner join users u on a.pcid=u.user_id
  where a.dt between '20190107' and '20190108'
  --Also need end of test filter if instance is not ongoing
  and date_parse(concat(u.first_exposure_date,u.first_exposure_time),'%Y%m%d%H%i%S') <= a.event_time
  and a.log_category='view' and a.log_type='page' and a.page_name='cart'
)

,user_summary as (
  select test_option, count(distinct user_id) as exposed_users
  from users group by test_option
)

,event_results as (
  select test_option, count(*) as event_count 
  from events group by test_option
)

select u.test_option, u.exposed_users, r.event_count, cast(r.event_count as double)/cast(u.exposed_users as double) as events_per_user
from user_summary u left outer join event_results r on u.test_option=r.test_option order by u.test_option