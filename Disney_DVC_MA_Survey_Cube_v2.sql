select   
r.resource_name             as AGENT_NAME,  
r.employee_id               as EMPLOYEE_ID,  
mt.media_name               as Media_Type,  
sl.language_name            as Language,
ssf.interaction_id          as External_ID, 
inf.interaction_id          as Interaction_ID_GIM, 
dt.cal_quarter_num_in_year  as QUARTER,   
dt.cal_month_name           as MONTH, 
dt.label_yyyy_mm_dd         as DATE,  
to_timestamp(inf.start_ts)                                  as Start_Time_GMT,
timezone('America/New_york', to_timestamp(inf.start_ts))    as Start_Time_EST,
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 25 then a.survey_answer_str else null end) as "Primary Reason for Calling",
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 26 then a.survey_answer_str else null end) as "Friendliness and Courtesy of CM",
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 27 then a.survey_answer_str else null end) as "CM Knowledge Level",
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 28 then a.survey_answer_str else null end) as "Overall Experience",
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 30 then a.survey_answer_str else null end) as "Primary Reason for Not Using Website",
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 29 then a.survey_answer_str else null end) as "Online Options"

from SDR_SURVEY_FACT ssf
inner join DATE_TIME                        dt  on(ssf.START_DATE_TIME_KEY = dt.DATE_TIME_KEY)
left outer join INTERACTION_FACT            inf on (ssf.INTERACTION_ID = inf.MEDIA_SERVER_IXN_GUID)
left outer join INTERACTION_RESOURCE_FACT   irf on (inf.INTERACTION_ID = irf.INTERACTION_ID and irf.IRF_ANCHOR = 1)
inner join SDR_SURVEY_QUESTIONS             q   on (q.ID = ssf.SDR_SURVEY_QUESTIONS_KEY)
inner join SDR_SURVEY_ANSWERS               a   on (a.ID = ssf.SDR_SURVEY_ANSWERS_KEY)  
inner join SDR_SESSION_FACT                 sdf on (sdf.session_id = ssf.SESSION_ID)
inner join SDR_LANGUAGE                     sl  on (sl.ID = sdf.SDR_LANGUAGE_KEY)
inner join resource_                        r   on (r.resource_key = irf.resource_key) 
inner join MEDIA_TYPE                       mt  on (mt.media_type_key = inf.media_type_key)
 
where   
dt.cal_date >(current_date - interval '90 Days') 
AND  
ssf.SDR_SURVEY_QUESTIONS_KEY in (25,26,27,28,29,30)  
AND
r.employee_id <>''

group by
r.resource_name,
r.employee_id,  
mt.media_name,  
sl.language_name,  
ssf.interaction_id,
inf.interaction_id,
dt.cal_quarter_num_in_year,  
dt.cal_month_name,
dt.label_yyyy_mm_dd