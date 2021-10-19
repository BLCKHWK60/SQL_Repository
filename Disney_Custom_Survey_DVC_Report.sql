select   
r.resource_name as AGENTNAME,  
r.employee_id,  
mt.media_name, 
ssf.interaction_id as INTERACTION_ID, 
inf.interaction_id as GIM_InteractionID, 
dt.cal_quarter_num_in_year as QUARTER,   
dt.cal_month_name as MONTH, 
dt.label_yyyy_mm_dd as DATE,  
to_timestamp(inf.start_ts) as GMTInteractionStartTime,
timezone('America/New_york', to_timestamp(inf.start_ts)) as ESTInteractionStartTime,
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 13 then a.survey_answer_str else null end) as "Net Promoter Score",
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 14 then a.survey_answer_str else null end) as "Reason",
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 15 then a.survey_answer_str else null end) as "Call Back Request",
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 16 then a.survey_answer_str else null end) as "Customer Effort",
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 17 then a.survey_answer_str else null end) as "Identify Needs and Knowledge",
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 18 then a.survey_answer_str else null end) as "Professionalism, Empathy, and Courtesy"

from SDR_SURVEY_FACT ssf
inner join DATE_TIME  dt  on(ssf.START_DATE_TIME_KEY = dt.DATE_TIME_KEY)
left outer join INTERACTION_FACT  inf  on (ssf.INTERACTION_ID=inf.MEDIA_SERVER_IXN_GUID)
left outer join INTERACTION_RESOURCE_FACT  irf  on (inf.INTERACTION_ID=irf.INTERACTION_ID and irf.IRF_ANCHOR = 1)
inner join SDR_SURVEY_QUESTIONS q on (q.ID = ssf.SDR_SURVEY_QUESTIONS_KEY)
inner join SDR_SURVEY_ANSWERS a on (a.ID= ssf.SDR_SURVEY_ANSWERS_KEY)
inner join resource_ r on (r.resource_key = irf.resource_key) 
inner join MEDIA_TYPE mt on mt.media_type_key = inf.media_type_key
 
where ssf.start_date_time_key BETWEEN ( SELECT RANGE_START_KEY FROM RELATIVE_RANGE WHERE RANGE_NAME='Last Month')  
 AND ( SELECT RANGE_END_KEY-1 FROM RELATIVE_RANGE WHERE RANGE_NAME='Last Month')
 
 
 --where  dt.label_yyyy_mm = '2021-01'  


Group by
r.resource_name,
r.employee_id,  
mt.media_name,  
ssf.interaction_id,
inf.interaction_id,
dt.cal_quarter_num_in_year,  
dt.cal_month_name,
dt.label_yyyy_mm_dd

order by r.resource_name, dt.label_yyyy_mm_dd, ssf.interaction_id