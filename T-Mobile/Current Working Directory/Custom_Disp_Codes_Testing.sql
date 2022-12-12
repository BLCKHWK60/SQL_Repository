Select
dt.label_yyyy_mm_dd as date,
cr.call_result,
ca.campaign_name,
crr.other20 as Disposition_caf,
it.interaction_type,
udc.custom_data_1 as Disposition_irf,
irf.interaction_resource_id,
caf.*

FROM contact_attempt_fact caf 
left outer join irf_user_data_gen_1 udg     on (caf.CALL_ATTEMPT_ID = udg.GSW_CALL_ATTEMPT_GUID)
left outer join cxc_crr_fact crr            on (caf.call_attempt_id = crr.id)
left outer join interaction_resource_fact irf    on (irf.interaction_resource_id = udg.interaction_resource_id)
right outer join irf_user_data_cust_1 udc   on (irf.interaction_resource_id = udc.interaction_resource_id)
inner join CAMPAIGN ca                      on (ca.campaign_key = caf.campaign_key)
inner join interaction_type it              on (it.interaction_type_key = irf.interaction_type_key)
inner join call_result cr                   on (cr.call_result_key = caf.call_result_key)
inner join date_time dt                     on (dt.date_time_key = caf.start_date_time_key and dt.date_time_key = irf.start_date_time_key)

where dt.cal_date between CURRENT_DATE - 2 and CURRENT_DATE - 1
and length(udc.custom_data_1) > 20
limit 1000



---Working---
Select
dt.label_yyyy_mm_dd as date,
caf.contact_attempt_fact_key,
caf.contact_complete_flag,
cr.call_result,
ca.campaign_name,
(case when caf.interaction_type_key > 0 then it.interaction_type else null) as caf_interaction_type,
crr.other20 as Disposition_caf,
(case when irf.interaction_type_key > 0 then it.interaction_type else null) as irf_interaction_type,
udc.custom_data_1 as Disposition_irf,
irf.interaction_resource_id

FROM contact_attempt_fact caf 
left outer join irf_user_data_gen_1 udg     on (caf.CALL_ATTEMPT_ID = udg.GSW_CALL_ATTEMPT_GUID)
left outer join cxc_crr_fact crr            on (caf.call_attempt_id = crr.id)
left outer join interaction_resource_fact irf    on (irf.interaction_resource_id = udg.interaction_resource_id)
right outer join irf_user_data_cust_1 udc   on (irf.interaction_resource_id = udc.interaction_resource_id)
inner join CAMPAIGN ca                      on (ca.campaign_key = caf.campaign_key)
inner join interaction_type it              on (it.interaction_type_key = irf.interaction_type_key and it.interaction_type_key = caf.interaction_type_key)
inner join call_result cr                   on (cr.call_result_key = caf.call_result_key)
inner join date_time dt                     on (dt.date_time_key = caf.start_date_time_key and dt.date_time_key = irf.start_date_time_key)

--where 
--dt.cal_date between CURRENT_DATE - 2 and CURRENT_DATE - 1
--and length(udc.custom_data_1) > 20
--limit 1000




Select
dt.label_yyyy_mm_dd as date,
caf.contact_attempt_fact_key,
caf.contact_info,
caf.contact_complete_flag,
cr.call_result,
ca.campaign_name,
crr.other20 as Disposition_caf,
udc.custom_data_1 as Disposition_irf,
irf.interaction_resource_id,
itf.source_address,
irf.IRF_ANCHOR,
IRF.Target_address,
irf.CUSTOMER_HANDLE_COUNT,
irf.CUSTOMER_TALK_DURATION,
irf.HANDLE_COUNT,
r.resource_type


FROM contact_attempt_fact caf 
left outer join irf_user_data_gen_1 udg         on (caf.CALL_ATTEMPT_ID = udg.GSW_CALL_ATTEMPT_GUID)
left outer join cxc_crr_fact crr                on (caf.call_attempt_id = crr.id)
left outer join interaction_resource_fact irf   on (irf.interaction_resource_id = udg.interaction_resource_id)
right outer join irf_user_data_cust_1 udc       on (irf.interaction_resource_id = udc.interaction_resource_id) 
inner join interaction_fact itf                 on (itf.interaction_id = irf.interaction_id) 
inner join resource_ r                          on (r.resource_key = irf.resource_key)
inner join CAMPAIGN ca                          on (ca.campaign_key = caf.campaign_key)
inner join call_result cr                       on (cr.call_result_key = caf.call_result_key)
inner join date_time dt                         on (dt.date_time_key = caf.start_date_time_key and dt.date_time_key = irf.start_date_time_key)


where caf.contact_attempt_fact_key in  
(
'140731029',
'141183874',
'141240880',
'141331285',
'140743302',
'140742023',
'140743034',
'140743036',
'140743035',
'140731028',
'140731161',
'140731031',
'140741387',
'140741624',
'140741626',
'140743055',
'140743053',
'140743316',
'140743329',
'140743261' 
)