WITH Survey_Answers AS 
(Select
    mt.media_name as Media_Type,
    cast(irf.interaction_id as BIGINT) as interaction_id,
    cast(irf.interaction_resource_id as BIGINT) as Interaction_r_id,
    msf.media_server_ixn_guid as GUID,
    irf.start_date_time_key, 
    irf.start_ts, 
    r.resource_name as VQueue,
    pcs1.survey_iq1 as Q1,
    pcs2.survey_iq2 as Q2,
    pcs2.survey_iq3 as Q3,
    pcs2.survey_iq4 as Q4,
    pcs4.survey_iq5 as Q5

from interaction_resource_fact irf

    inner join IRF_USER_DATA_KEYS           iudk    on  (iudk.interaction_resource_id   =       irf.interaction_resource_id)
    inner join post_call_survey_dim_1       pcs1    on  (pcs1.id                        =       iudk.post_call_survey_key_1)
    inner join post_call_survey_dim_2       pcs2    on  (pcs2.id                        =       iudk.post_call_survey_key_2) 
    inner join post_call_survey_dim_4       pcs4    on  (pcs4.id                        =       iudk.post_call_survey_key_4)
    inner join Media_Type                   mt      on  (mt.media_type_key              =       irf.media_type_key)
    inner join resource_                    r       on  (r.resource_key                 =       irf.last_vqueue_resource_key)
    inner join MEDIATION_SEGMENT_FACT       msf     on  (irf.MEDIATION_SEGMENT_ID       =       msf.MEDIATION_SEGMENT_ID)

Where  
mt.media_name in ('Voice', 'Chat')  
and   
irf.START_DATE_TIME_KEY >= (select min(date_time_key) as Label_key from date_time where date(cal_date) = current_date - 1)  
and 
irf.START_DATE_TIME_KEY <= (select max(date_time_key) as Label_key from date_time where date(cal_date) = current_date - 1)
and 
iudk.post_call_survey_key_1 > 0 
and  
pcs1.survey_iq1 != '-1' 
)


Select  
    sa.Media_type as Media_Type,
    dt.LABEL_YYYY_MM_DD_HH as Hour,
    timezone('America/New_york', to_timestamp(sa.start_ts)) as Start_Time_EST,
    timezone('GMT', to_timestamp(sa.start_ts)) as Start_Time_GMT,
    max(sa.interaction_r_id) as interaction_r_id,
    max(sa.GUID) as GUID, 
    r1.Agent as Agent, 
    r1.Queue as Queue,   
    max(case when sa.Q1 != '-1' then sa.Q1 else 'Not Answered' end) as q1, 
    max(case when sa.q2 != '-1' then sa.q2 else 'Not Answered' end) as q2, 
    max(case when sa.q3 != '-1' then sa.q3 else 'Not Answered' end) as q3,
    max(case when sa.q4 != '-1' then sa.q4 else 'Not Answered' end) as q4,
    max(case when sa.q5 != '-1' then sa.q5 else 'Not Answered' end) as q5   

from Survey_Answers sa
    
    join    (select    
                    ra.resource_name AS Agent, 
                    rq.resource_name AS Queue,
                    msf.MEDIATION_SEGMENT_ID as msf_ID,
                    irf.start_date_time_key,
                    cast(irf.interaction_resource_id as BIGINT) as interaction_r_id,
                    cast(irf.interaction_id as BIGINT) as interaction_id
                from interaction_resource_fact irf   
                    left outer join MEDIATION_SEGMENT_FACT  msf on(msf.MEDIATION_SEGMENT_ID = irf.MEDIATION_SEGMENT_ID and irf.MEDIATION_RESOURCE_KEY = msf.RESOURCE_KEY)          
                    join (SELECT RESOURCE_.* FROM RESOURCE_ WHERE RESOURCE_TYPE_CODE='AGENT' AND RESOURCE_SUBTYPE='Agent') ra
                        on  (irf.RESOURCE_KEY = ra.RESOURCE_KEY)  
                    join (SELECT RESOURCE_.* FROM RESOURCE_ WHERE RESOURCE_TYPE_CODE in ('QUEUE','NONE','UNKNOWN')) rq
                        on  (msf.RESOURCE_KEY = rq.RESOURCE_KEY) 
                where 
                    irf.START_DATE_TIME_KEY >= (select min(date_time_key) as Label_key from date_time where date(cal_date) = current_date - 1)  
                    and 
                    irf.START_DATE_TIME_KEY <= (select max(date_time_key) as Label_key from date_time where date(cal_date) = current_date - 1)
            ) R1 
        on sa.interaction_id = R1.interaction_id
    join DATE_TIME  dt  on  (dt.date_time_key       =   sa.start_date_time_key)

    Where r1.Queue NOT IN ('GSYS_VoiceHealthCheck_VQ', 'ChatHealthTestQueue') 
    group by sa.media_type, dt.LABEL_YYYY_MM_DD_HH, sa.start_ts, r1.agent, r1.queue
order by start_time_est desc