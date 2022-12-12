select  
dt.label_yyyy_mm_dd,
r.resource_name,
al.agent_location_string,  
dt.cal_date + (start_ts-start_date_time_key) * interval '1 second' as login_start_time,  
edt.cal_date + (end_ts-end_date_time_key) * interval '1 second' as login_end_time,
s.total_duration * interval '1 sec' as duration, 
s.total_duration 

from 
sm_res_session_fact s, 
date_time dt, resource_ r,   
date_time edt,
agent_location al 

where 
s.resource_key=r.resource_key and 
s.start_date_time_key=dt.date_time_key and   
s.end_date_time_key=edt.date_time_key and  
s.agent_location_key=al.agent_location_key and  
dt.LABEL_YYYY_MM = '2022-10' and 
r.resource_type = 'Agent' and 
case    when lower(resource_name) like '%healthcheck%'  then 1  
        when lower(resource_name) like '%test%' then 1 
        when lower(resource_name) like '%vhc_%' then 1  else 0 end = 0