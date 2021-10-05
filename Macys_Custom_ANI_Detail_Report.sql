with irf as (
  select
      irf.start_date_time_key,
      interaction_sdt_key,
      cast(irf.interaction_id as BIGINT) as Interaction_id,
      start_ts, 
      end_ts,  
      interaction_type_key,
      irf.Resource_key,
      iudk.interaction_resource_id,
      max(case when r.resource_type = 'Queue' then r.resource_name else null end) as VQueue,
      idk.customer_segment as Department,
      idk.service_type as Services,
      td.resource_role,
      td.role_reason,
      technical_result,
      result_reason,
      media_type_key,
      sum(customer_talk_duration+customer_hold_duration+customer_acw_duration) as customer_handle_time
    from interaction_resource_fact irf
      inner join technical_descriptor   td     on (irf.technical_descriptor_key = td.technical_descriptor_key)
      inner join IRF_USER_DATA_GEN_1   iudk   on (irf.INTERACTION_RESOURCE_ID = iudk.INTERACTION_RESOURCE_ID and  irf.START_DATE_TIME_KEY = iudk.START_DATE_TIME_KEY)
      inner join IRF_USER_DATA_KEYS     udk    on (irf.INTERACTION_RESOURCE_ID = udk.INTERACTION_RESOURCE_ID and irf.START_DATE_TIME_KEY = udk.START_DATE_TIME_KEY)
      inner join INTERACTION_DESCRIPTOR idk    on (udk.INTERACTION_DESCRIPTOR_KEY = idk.INTERACTION_DESCRIPTOR_KEY)
      inner join RESOURCE_              r     on (r.resource_key = irf.last_vqueue_resource_key)
    where 1=1
      and irf.START_DATE_TIME_KEY between (select RANGE_START_KEY from RELATIVE_RANGE where range_name='Week to Date') and (select RANGE_END_KEY-1 from RELATIVE_RANGE where range_name='Week to Date') 
and media_type_key = 1
  
      
    group by
      irf.start_date_time_key,
      interaction_sdt_key,
      interaction_id, 
      start_ts, 
      end_ts,  
      interaction_type_key,
      irf.Resource_key,
      iudk.interaction_resource_id,
      irf.last_vqueue_resource_key,
      idk.customer_segment,
      idk.service_type,
      td.resource_role,
      td.role_reason,
      technical_result,
      result_reason,
      media_type_key
  ),

  itf as (select
      start_date_time_key,
      cast(interaction_id as BIGINT) as Interaction_id,
      end_ts-start_ts as interaction_duration,
      SOURCE_ADDRESS,
      TARGET_ADDRESS,
      1 count_interaction     
    from interaction_fact
    where 1=1
      and START_DATE_TIME_KEY between (select RANGE_START_KEY from RELATIVE_RANGE where range_name='Week to Date') and (select RANGE_END_KEY-1 from RELATIVE_RANGE where range_name='Week to Date') 
and media_type_key = 1 
      
      
  )
select
   dt.LABEL_YYYY_MM_DD as DATE,
   cast(irf.interaction_id as BIGINT) as Interaction_id,
   dt.cal_date, 
   max(dt.cal_date +  CAST( irf.start_ts - irf.start_date_time_key || 'seconds' as Interval)) as Real_Date, 
   to_timestamp(irf.start_ts) as Start_TS,
   to_timestamp(irf.end_ts) as End_TS,
   itf.SOURCE_ADDRESS as Source_Address,
   itf.TARGET_ADDRESS as Target_Address,
   itg.interaction_type as Interaction_Type,
   mt.media_name as Media_Name,
   irf.VQueue,
   rs.resource_type as Resource_Type,
   rs.resource_name as Resource_Name,
   irf.Department,
   irf.services,
   irf.resource_role as Resource_Role,
   irf.role_reason as Resource_Role_Reason,
   irf.technical_result as Technical_Result,
   irf.result_reason as Result_Reason,
   sum(irf.customer_handle_time) as CHT,
   sum(itf.interaction_duration) as TOTDURATION,
   sum(count_interaction) as Count_Interaction
 from irf
   inner join itf on irf.INTERACTION_ID=itf.INTERACTION_ID and irf.INTERACTION_SDT_KEY=itf.START_DATE_TIME_KEY and itf.start_date_time_key=irf.start_date_time_key
   inner join resource_ rs on (irf.Resource_key= rs.Resource_key)
   inner join date_time dt on (irf.start_date_time_key=dt.date_time_key)
   inner join media_type mt on (irf.media_type_key=mt.media_type_key)
   inner join interaction_type itg on (irf.interaction_type_key=itg.interaction_type_key)  
 group by
   dt.LABEL_YYYY_MM_DD,
   irf.interaction_id,
   dt.cal_date,
   irf.start_ts,
   irf.end_ts,
   itf.SOURCE_ADDRESS,
   itf.TARGET_ADDRESS,
   itg.interaction_type,
   mt.media_name,
   irf.VQueue,
   rs.resource_type,
   rs.resource_name,
   irf.Department,
   irf.services,
   irf.resource_role,
   irf.role_reason,
   irf.technical_result,
   irf.result_reason