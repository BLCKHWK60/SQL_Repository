Select   
dt.label_yyyy_mm_dd as date, 
irf.interaction_id as interaction_id,  
td.technical_result as Technical_Result,
r.resource_name as VQueue,     
msf.mediation_duration as Queue_Duration,
irf.ring_duration as Alert_Duration,
(msf.mediation_duration + irf.ring_duration) as Accept_Time
 
from mediation_segment_fact msf   
inner join date_time dt on (msf.start_date_time_key = dt.date_time_key)
inner join technical_descriptor td on (msf.technical_descriptor_key = td.technical_descriptor_key) 
inner join interaction_resource_fact irf on (irf.interaction_resource_id = msf.ixn_resource_id) 
inner join Resource_ r on (r.resource_key = msf.resource_key)
 
where  dt.label_yyyy_mm_dd = '2022-03-24' and msf.resource_key = '30807' and td.technical_result = 'Diverted'