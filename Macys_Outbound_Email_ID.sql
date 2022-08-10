select  
    dt.label_yyyy_mm_dd as day,  
    mt.media_name as Media_Type, 
    r.resource_name as resource_name,
    cast(msf.interaction_id as BIGINT) as Interaction_ID,
    it.interaction_type,
    msf.media_server_ixn_guid 
 
from   mediation_segment_fact  msf

inner join interaction_Type it      on (it.interaction_Type_key = msf.interaction_type_key)  
join interaction_resource_fact irf  on (irf.interaction_resource_id = msf.ixn_resource_id) 
inner join date_time dt             on (dt.date_time_key = msf.start_date_time_key)  
inner join media_type mt            on (mt.media_type_key = msf.media_type_key) 
inner join resource_ r              on (r.resource_key = irf.last_interaction_resource) 

   
where dt.cal_date >= Current_date - 1  
and it.interaction_type = 'Outbound' 
and mt.media_name = 'Email' 
-- and interaction_id = '229117197086887609' 
 --where media_server_ixn_guid = 'AAHJA1000001GV1J' 
 --where media_server_ixn_guid = '01RG00B2HVGHBNT7'