select 
dt.Label_YYYY_MM_DD, 
iuf.*,  
irf.* 
from irf_user_data_cust_1 iuf
inner join Date_time dt on (dt.date_time_key = iuf.start_date_time_key) 
inner join interaction_resource_fact irf  on (irf.interaction_resource_ID = iuf.interaction_resource_ID)
where
iuf.INTERACTION_RESOURCE_ID IN (
4471260773,
4482946929,
4484318161,
4480511209,
4483487857)