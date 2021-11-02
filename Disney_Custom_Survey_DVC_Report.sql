--- Reference Script for Additional Reports ---
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
dt.cal_date >(current_date - interval '2 weeks') 
AND  
ssf.SDR_SURVEY_QUESTIONS_KEY in (13,14,15,16,17,18)  

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

order by r.resource_name, dt.label_yyyy_mm_dd, ssf.interaction_id

--- Different Set of Questions for Other LOBs ---
--- DVC MS Survey Report ---

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
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 19 then a.survey_answer_str end) as "Advisor Willingness To Help",
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 20 then a.survey_answer_str end) as "Advisor Friendliness",
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 21 then a.survey_answer_str end) as "Overall Experience with Call Process",
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 21 and a.survey_answer_str != '5' then 1 else 0 end) as "Overall Experience Not Excellent"

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
dt.cal_date >(current_date - interval '2 weeks') 
AND  
ssf.SDR_SURVEY_QUESTIONS_KEY in (19,20,21,22)  
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

order by r.resource_name, dt.label_yyyy_mm_dd, ssf.interaction_id

--- DVC MA Survey Report ---
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
dt.cal_date >(current_date - interval '2 weeks') 
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

order by r.resource_name, dt.label_yyyy_mm_dd, ssf.interaction_id

--- DVC Member Education Survey Report ---
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
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 24 then a.survey_answer_str else null end) as "Advisor Knowledge Level",
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 19 then a.survey_answer_str else null end) as "Advisor Willingness To Help",
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 20 then a.survey_answer_str else null end) as "Advisor Friendliness",
max(case when ssf.SDR_SURVEY_QUESTIONS_KEY = 23 then a.survey_answer_str else null end) as "Value of Call"

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
dt.cal_date >(current_date - interval '2 weeks') 
AND  
ssf.SDR_SURVEY_QUESTIONS_KEY in (24,19,20,23)  
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

order by r.resource_name, dt.label_yyyy_mm_dd, ssf.interaction_id