select
to_timestamp(max(inf.START_TS)) as INTERACTION_START_UTC, 
to_timestamp(max(inf.end_TS))   as INTERACTION_END_UTC,  
to_timestamp(max(irf.START_TS)) as HANDLING_START_UTC,
to_timestamp(max(irf.END_TS))   as HANDLING_END_UTC, 
dt.LABEL_YYYY_MM_DD             as DAY,
rq.RESOURCE_NAME                as Queue,  
ra.RESOURCE_NAME                as RESOURCE_NAME, 
inf.SOURCE_ADDRESS              as ANI,      
inf.TARGET_ADDRESS              as DNIS,    
max(irf.TARGET_ADDRESS)         as SECONDARY_NUMBER,
max(irf.talk_duration)          as TALK_TIME,
max(irf.hold_duration)          as HOLD_TIME,
max(irf.AFTER_CALL_WORK_COUNT)  as ACW_TIME

  
from INTERACTION_RESOURCE_FACT  irf 
     inner join DATE_TIME               dt  on(dt.DATE_TIME_KEY         = irf.START_DATE_TIME_KEY) 
     inner join INTERACTION_FACT        inf on(irf.INTERACTION_ID       = inf.INTERACTION_ID) 
     inner join INTERACTION_TYPE        it  on(it.INTERACTION_TYPE_KEY  = irf.INTERACTION_TYPE_KEY)
left outer join MEDIATION_SEGMENT_FACT  msf on(msf.MEDIATION_SEGMENT_ID = irf.MEDIATION_SEGMENT_ID 
                                            and irf.MEDIATION_RESOURCE_KEY = msf.RESOURCE_KEY)
      join 
        (SELECT RESOURCE_.* FROM RESOURCE_ WHERE RESOURCE_TYPE_CODE='AGENT' AND RESOURCE_SUBTYPE='Agent') ra
                on  (irf.RESOURCE_KEY = ra.RESOURCE_KEY)  
      join 
        (SELECT RESOURCE_.* FROM RESOURCE_ WHERE RESOURCE_TYPE_CODE in ('QUEUE','NONE','UNKNOWN')) rq
                on  (msf.RESOURCE_KEY = rq.RESOURCE_KEY) 

where  
    irf.TARGET_ADDRESS is not null --and inf.SOURCE_ADDRESS is not null 
and (dt.cal_date between CURRENT_DATE - 2 and CURRENT_DATE + 1)   

group by DAY, ra.RESOURCE_NAME, inf.SOURCE_ADDRESS, inf.TARGET_ADDRESS

order by inf.START_TS desc

--- Testing ---

select 
irf.interaction_id              as Interaction_ID, 
to_timestamp(irf.START_TS)      as HANDLING_START_UTC,
ra.RESOURCE_NAME                as RESOURCE_NAME,    
inf.SOURCE_ADDRESS              as ANI,      
inf.TARGET_ADDRESS              as DNIS,    
max(irf.TARGET_ADDRESS)         as SECONDARY_NUMBER,
sum(irf.talk_duration)          as TALK_TIME,
sum(irf.hold_duration)          as HOLD_TIME,
sum(irf.AFTER_CALL_WORK_COUNT)  as ACW_TIME

  
from INTERACTION_RESOURCE_FACT  irf 
     inner join DATE_TIME               dt  on(dt.DATE_TIME_KEY         = irf.START_DATE_TIME_KEY) 
     inner join INTERACTION_FACT        inf on(irf.INTERACTION_ID       = inf.INTERACTION_ID) 
     inner join INTERACTION_TYPE        it  on(it.INTERACTION_TYPE_KEY  = irf.INTERACTION_TYPE_KEY)
left outer join MEDIATION_SEGMENT_FACT  msf on(msf.MEDIATION_SEGMENT_ID = irf.MEDIATION_SEGMENT_ID 
                                            and irf.MEDIATION_RESOURCE_KEY = msf.RESOURCE_KEY)
      join 
        (SELECT RESOURCE_.* FROM RESOURCE_ WHERE RESOURCE_TYPE_CODE='AGENT' AND RESOURCE_SUBTYPE='Agent') ra
                on  (irf.RESOURCE_KEY = ra.RESOURCE_KEY)  
      join 
        (SELECT RESOURCE_.* FROM RESOURCE_ WHERE RESOURCE_TYPE_CODE in ('QUEUE','NONE','UNKNOWN')) rq
                on  (msf.RESOURCE_KEY = rq.RESOURCE_KEY) 

where  
    irf.TARGET_ADDRESS is not null --and inf.SOURCE_ADDRESS is not null 
and (dt.cal_date between CURRENT_DATE - 2 and CURRENT_DATE + 1)   

group by irf.interaction_id, HANDLING_START_UTC, ra.RESOURCE_NAME, inf.SOURCE_ADDRESS, inf.TARGET_ADDRESS  
 
--order by ra.resource_name asc 


--- Testing 2021-11-10 ---

select 
dt.LABEL_YYYY_MM_DD             as DAY, 
irf.interaction_id              as Interaction_ID,  
to_timestamp(max(inf.START_TS)) as INTERACTION_START_UTC, 
to_timestamp(max(inf.end_TS))   as INTERACTION_END_UTC,  
to_timestamp(max(irf.START_TS)) as HANDLING_START_UTC,
to_timestamp(max(irf.END_TS))   as HANDLING_END_UTC, 
rq.RESOURCE_NAME                as Queue,       
ra.RESOURCE_NAME                as Agent_Name, 
inf.SOURCE_ADDRESS              as ANI,      
inf.TARGET_ADDRESS              as DNIS,    
max(irf.TARGET_ADDRESS)         as SECONDARY_NUMBER,
sum(irf.talk_duration+irf.CONS_INIT_TALK_DURATION) as TOTAL_TALK_TIME,
sum(irf.hold_duration+irf.CONS_INIT_HOLD_DURATION) as TOTAL_HOLD_TIME,
sum(irf.CONS_INIT_TALK_DURATION)        as CONSULT_TALK_TIME,  
sum(irf.CONS_INIT_HOLD_DURATION)        as CONSULT_HOLD_TIME, 
sum(irf.AGENT_TO_AGENT_CONS_DURATION)   as A2A_CONSULT_TIME, 
sum(irf.CONS_INIT_DIAL_COUNT)           as Consult_Init_Attempts, 
sum(irf.CONS_INIT_TALK_COUNT)           as Consult_Init_Established


  
from INTERACTION_RESOURCE_FACT  irf 
     inner join DATE_TIME               dt  on(dt.DATE_TIME_KEY         = irf.START_DATE_TIME_KEY) 
     inner join INTERACTION_FACT        inf on(irf.INTERACTION_ID       = inf.INTERACTION_ID) 
     inner join INTERACTION_TYPE        it  on(it.INTERACTION_TYPE_KEY  = irf.INTERACTION_TYPE_KEY)
left outer join MEDIATION_SEGMENT_FACT  msf on(msf.MEDIATION_SEGMENT_ID = irf.MEDIATION_SEGMENT_ID 
                                            and irf.MEDIATION_RESOURCE_KEY = msf.RESOURCE_KEY)
      join 
        (SELECT RESOURCE_.* FROM RESOURCE_ WHERE RESOURCE_TYPE_CODE='AGENT' AND RESOURCE_SUBTYPE='Agent') ra
                on  (irf.RESOURCE_KEY = ra.RESOURCE_KEY)  
      join 
        (SELECT RESOURCE_.* FROM RESOURCE_ WHERE RESOURCE_TYPE_CODE in ('QUEUE','NONE','UNKNOWN')) rq
                on  (msf.RESOURCE_KEY = rq.RESOURCE_KEY) 

where     
irf.TARGET_ADDRESS is not null
and (dt.cal_date between CURRENT_DATE - 1 and CURRENT_DATE + 1)  


group by dt.LABEL_YYYY_MM_DD, rq.RESOURCE_NAME,irf.interaction_id, ra.RESOURCE_NAME, inf.SOURCE_ADDRESS, inf.TARGET_ADDRESS, irf.TARGET_ADDRESS

order by Day asc, irf.interaction_id asc, handling_start_utc asc