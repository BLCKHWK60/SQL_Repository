WITH 
Survey_Answers AS 
(
select
    mt.media_name as Media_Type,
    cast(irf.interaction_id as BIGINT) as Interaction_id,
    irf.start_date_time_key,
    r.resource_name as VQueue,
   pcs1.survey_iq1 as Q1,
    pcs2.survey_iq2 as Q2,
    pcs2.survey_iq3 as Q3,
    pcs2.survey_iq4 as Q4,
    pcs4.survey_iq5 as Q5
from interaction_resource_fact irf
inner join IRF_USER_DATA_KEYS           iudk    on  (iudk.interaction_resource_id   =       irf.interaction_resource_id and irf.START_DATE_TIME_KEY=iudk.START_DATE_TIME_KEY)
inner join post_call_survey_dim_1       pcs1    on  (pcs1.id                        =       iudk.post_call_survey_key_1)
inner join post_call_survey_dim_2       pcs2    on  (pcs2.id                        =       iudk.post_call_survey_key_2) 
inner join post_call_survey_dim_4       pcs4    on  (pcs4.id                        =       iudk.post_call_survey_key_4)
inner join Media_Type                   mt      on  (mt.media_type_key              =       irf.media_type_key)
inner join resource_                    r       on  (r.resource_key                 =       irf.last_vqueue_resource_key)

where 
     irf.START_DATE_TIME_KEY between 1632974400 and 1633664700
  and iudk.START_DATE_TIME_KEY between 1632974400 and 1633664700
and iudk.post_call_survey_key_1 > 0
)

select  
    sa.Media_type as Media_Type,
    dt.LABEL_YYYY_MM_DD_HH as Hour,
    sa.interaction_id, 
    sa.VQueue as VQueue,
    (case when r.resource_type = 'Agent' then r.resource_name end) as Agent,  
    (case when sa.Q1 != '-1' then sa.Q1 else 'Not Answered' end) as q1, 
    (case when sa.q2 != '-1' then sa.q2 else 'Not Answered' end) as q2, 
    (case when sa.q3 != '-1' then sa.q3 else 'Not Answered' end) as q3,
    (case when sa.q4 != '-1' then sa.q4 else 'Not Answered' end) as q4,
    (case when sa.q5 != '-1' then sa.q5 else 'Not Answered' end) as q5   
into tmp_survey_answers
from Survey_Answers sa
join (
select    r.resource_name,
                    r.resource_type,
                    irf.start_date_time_key,
                    irf.interaction_id
from interaction_resource_fact irf  
join resource_  r   on  irf.resource_key        =   r.resource_key   
--    join DATE_TIME  dt  on  (dt.date_time_key       =   irf.start_date_time_key) 
where r.resource_type in ('Agent', 'Queue') 
 and irf.START_DATE_TIME_KEY between 1632974400 and 1633664700

)   r on sa.interaction_id = r.interaction_id
join DATE_TIME  dt  on  (dt.date_time_key       =   sa.start_date_time_key)
