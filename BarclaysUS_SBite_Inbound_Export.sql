select   
sdr.session_id, 
max(case when sdr2.atribute_name = 'ClientID' then sdr.atribute_value else NULL end) as "clientid",  
max(case when sdr2.atribute_name = 'strat_flag' then sdr.atribute_value else NULL end) as "userData.strat_flag",  
max(case when sdr2.atribute_name = 'Min_Pay_Due' then sdr.atribute_value else NULL end) as "userData.Min_Pay_Due",  
max(case when sdr2.atribute_name = 'total_due' then sdr.atribute_value else NULL end) as "userData.total_due",  
max(case when sdr2.atribute_name = 'actual_dpd' then sdr.atribute_value else NULL end) as "userData.actual_dpd",  
max(case when sdr2.atribute_name = 'current_balance' then sdr.atribute_value else NULL end) as "userData.current_balance",  
max(case when sdr2.atribute_name = 'overlimit' then sdr.atribute_value else NULL end) as "userData.overlimit",  
max(case when sdr2.atribute_name = 'pd_status' then sdr.atribute_value else NULL end) as "userData.pd_status",  
max(case when sdr2.atribute_name = 'client_product_code' then sdr.atribute_value else NULL end) as "userData.client_product_code",  
max(case when sdr2.atribute_name = 'MDLScore' then sdr.atribute_value else NULL end) as "userData.MDLScore",  
max(case when sdr2.atribute_name = 'qmr_key_queue_id' then sdr.atribute_value else NULL end) as "userData.qmr_key_queue_id",  
max(case when sdr2.atribute_name = 'Region' then sdr.atribute_value else NULL end) as "userData.Region",  
max(case when sdr2.atribute_name = 'offer_id' then sdr.atribute_value else NULL end) as "userData.offer_id",  
max(case when sdr2.atribute_name = 'SubCampaign' then sdr.atribute_value else NULL end) as "campaignGroupName",
sess.ani as "contact_info",
max(case when sdr2.atribute_name = 'deviceTimezone' then sdr.atribute_value else NULL end) as "deviceTimezone",  
--max(case when sdr2.atribute_name = '@timestamp' then sdr.atribute_value else NULL end) as "@timestamp", 
to_timestamp(sess.start_ts_ms/1000) as "@timestamp",  
max(sess.end_ts_ms - sess.start_ts_ms) as "duration",
'INBOUND_IVR_COMPLETED' as "callResult",
max(case when sdr2.atribute_name = 'report_markers' then sdr.atribute_value else NULL end) as "userData.report_markers" 

--dt.label_yyyy_mm_dd, sdr2.id, sdr2.atribute_name,sdr.* 
 from sdr_cust_atributes_fact sdr
inner join date_time dt on dt.date_time_key =  sdr.start_date_time_key 
inner join sdr_cust_atributes sdr2 on sdr2.id = sdr.sdr_cust_atributes_key
inner join sdr_session_fact sess on sess.session_id = sdr.session_id

where dt.label_yyyy_mm_dd = '2022-06-23' 
--and sdr.session_id like '%379V'   
 
--where dt.date_time_key BETWEEN ( SELECT RANGE_START_KEY FROM RELATIVE_RANGE WHERE RANGE_NAME='Yesterday') AND ( SELECT RANGE_END_KEY-1 FROM RELATIVE_--RANGE WHERE RANGE_NAME='Yesterday')    
 
--where dt.cal_date >= current_date -1 
 
group by sdr.session_id, sdr.start_date_time_key, sess.ani, sess.start_ts_ms
order by sdr.start_date_time_key desc