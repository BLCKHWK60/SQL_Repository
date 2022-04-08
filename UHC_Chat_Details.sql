-- THIS WAS SENT TO CUSTOMER ON 2022-03-25 --
select    
intf.media_server_ixn_guid  as GUID_universal_ID, 
--irf.interaction_id          as irf_id,  
irf.start_ts                as start_time, 
irf.end_ts                  as end_time,    
rt.routing_target_type      as routing_target_type,
--rt.target_object_selected   as routing_object_selected,  
(case when rt.routing_target_type_code='AGENT GROUP' then  agent_group_name when rt.routing_target_type_code='PLACE GROUP' then  place_group_name when rt.routing_target_type_code='SKILL EXPRESSION' then  skill_expression else null end) as target_group_name, 
vqn.resource_name           as last_vqueue,  
r.resource_type             as handling_resource_type, 
(case when r.resource_type = 'Agent' then r.resource_name else 'n/a' end) 
                            as agent_name

from  interaction_resource_fact irf 
 
inner join interaction_fact intf    on (intf.interaction_id = irf.interaction_id) 
inner join routing_target   rt      on (rt.routing_target_key = irf.routing_target_key)   
inner join resource_        r       on (r.resource_key = irf.resource_key) 
inner join (select resource_.* from resource_ where resource_type_code in ('QUEUE','NONE','UNKNOWN')) vqn 
                                    on  (irf.last_vqueue_resource_key = vqn.resource_key) 

where irf.media_type_key = 3 and r.resource_type != 'RoutingPoint'
order by irf.start_ts desc 
--------------------------------------------------


select    
if.media_server_ixn_guid as GUID_universal_ID, 
irf.start_ts as start_time, 
irf.end_ts as end_time,   
rt.routing_target_type as routing_target_type,
rt.target_object_selected as routing_object_selected,  
(case when rt.routing_target_type_code='AGENT GROUP' then  agent_group_name when rt.routing_target_type_code='PLACE GROUP' then  place_group_name when rt.routing_target_type_code='SKILL EXPRESSION' then  skill_expression else null end) as target_group_name, 
vqn.resource_name as last_vqueue,  
r.resource_type as handling_resource_type,   
irf.interaction_id as irf_id
          
from  interaction_resource_fact irf 
 
inner join interaction_fact if on (if.interaction_id = irf.interaction_id) 
inner join routing_target   rt on (rt.routing_target_key = irf.routing_target_key)   
inner join resource_        r  on (r.resource_key = irf.resource_key) 
inner join (select resource_.* from resource_ where resource_type_code in ('QUEUE','NONE','UNKNOWN')) vqn 
  on  (irf.last_vqueue_resource_key = vqn.resource_key) 
  

where if.media_server_ixn_guid = '0000KaH1K09Y47RK' 
order by irf.start_ts desc  



---
select   
irf.start_ts, 
irf.end_ts, 
(Case when rt.routing_target_type = 'Skill Expression' then rt.routing_target_type else 'N/A' end) as Targeted_Skill, 
rt.target_object_selected, 
r.resource_type,   
(case when r.resource_type = 'Agent' then r.resource_name else 'N/A' end) Agent_Name,  
irf.interaction_id,
irf.interaction_resource_id,
irf.interaction_type_key,
(case when irf.last_vqueue_resource_key = r.resource_key then r.resource_name else 'N/A' end) as Last_VQueue,
(case when irf.media_resource_key = r.resource_key then r.resource_name else 'N/A' end) as Media_Resource ,
irf.media_type_key,
irf.mediation_resource_key,
irf.mediation_segment_id,
irf.mediation_segment_sdt_key,
irf.mediation_start_date_time_key,
irf.met_service_objective_flag,
irf.partyguid,
irf.requested_skill_key,
irf.resource_key,
irf.routing_target_key,
irf.start_date_time_key,
irf.target_address
          
from  interaction_resource_fact irf 
 
INNER JOIN INTERACTION_FACT if on (if.interaction_id = irf.interaction_id) 
INNER JOIN ROUTING_TARGET   rt on (rt.routing_target_key = irf.routing_target_key) 
INNER JOIN RESOURCE_        r  on (r.resource_key = irf.resource_key OR r.resource_key = irf.last_vqueue_resource_key OR r.resource_key = irf.media_resource_key)
  
order by irf.start_ts desc 
--WHERE if.media_server_ixn_guid = '0000KaH1K09Y47RK'




select   
irf.start_ts, 
irf.end_ts,  
irf.start_date_time_key, 
(Case when rt.routing_target_type = 'Skill Expression' then rt.routing_target_type else 'N/A' end) as Targeted_Skill,  
rt.target_object_selected, 
--r.resource_type,   
(case when r.resource_type = 'Agent' then r.resource_name else 'N/A' end) Agent_Name,  
irf.interaction_id,
irf.interaction_resource_id,
irf.interaction_type_key,
(case when irf.last_vqueue_resource_key = r.resource_key then r.resource_name else 'N/A' end) as Last_VQueue,
(case when irf.media_resource_key = r.resource_key then r.resource_name else 'N/A' end) as Media_Resource ,
irf.media_type_key,
irf.requested_skill_key,
irf.resource_key,
irf.routing_target_key
          
from  interaction_resource_fact irf 
 
INNER JOIN INTERACTION_FACT if on (if.interaction_id = irf.interaction_id) 
INNER JOIN ROUTING_TARGET   rt on (rt.routing_target_key = irf.routing_target_key)  
LEFT OUTER JOIN RESOURCE_        r  on  
(r.resource_key = irf.resource_key OR r.resource_key = irf.last_vqueue_resource_key OR r.resource_key = irf.media_resource_key)
   
WHERE  irf.media_type_key = 3
-- if.media_server_ixn_guid = '0000KaH1K09Y47RK' 
order by irf.start_ts desc  