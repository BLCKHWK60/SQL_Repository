select  
dt.label_yyyy_mm_dd as date,
irf.last_vqueue_resource_key,
r.resource_name,
irf.received_from_ixn_resource_id,  
irf.technical_descriptor_key,  
irf.resource_key,
intf.active_flag,
intf.anchor_id,
intf.anchor_sdt_key,
intf.create_audit_key,
intf.end_date_time_key,
intf.end_ts,
intf.interaction_id,
intf.interaction_type_key,
intf.media_server_ixn_guid,
cast(intf.media_server_ixn_id as BIGINT) as media_server_ixn_id,
intf.media_server_root_ixn_guid,
intf.media_server_root_ixn_id,
intf.media_type_key,
intf.source_address,
intf.start_date_time_key,
intf.start_ts,
intf.status,
intf.target_address
from interaction_fact intf  
inner join interaction_resource_fact irf ON (irf.interaction_id = intf.interaction_id)
inner join resource_ r ON (r.resource_key = irf.last_vqueue_resource_key) 
inner join date_time dt ON (dt.date_time_key = irf.start_date_time_key)
where intf.media_server_ixn_guid IN
--unsuccessful Surveys
('01QSENG8R097511JH1HKG2LAES002BLG','01QSENG8R097511JH1HKG2LAES002BKV','01QSENG8R097511JH1HKG2LAES002BL7','01QSENG8R097511JH1HKG2LAES002M2O',
--successful surveys
'01QSENG8R097511JH1HKG2LAES002QL3','01QSENG8R097511JH1HKG2LAES002QOI','01QSENG8R097511JH1HKG2LAES002QH8','01QSENG8R097511JH1HKG2LAES002QDD','01QSENG8R097511JH1HKG2LAES002QBL')