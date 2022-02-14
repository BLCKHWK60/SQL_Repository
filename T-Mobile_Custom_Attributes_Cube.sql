select
        dt.LABEL_YYYY_MM_DD as Day_,
        dt.LABEL_YYYY_MM_DD_HH as Day_Hour,
        max(to_timestamp(ssf.start_ts_ms/1000)) as Start_Time,
        max(to_timestamp(ssf.end_ts_ms/1000)) as End_Time,  
        scaf.session_id as sess_id, 
        max(ssf.ANI) as ANI, 
        max(ssf.Interaction_ID) as Int_ID, 
        max(case when sdr_cust_atributes_key = 1 then atribute_value else null end) as ID,
        max(case when sdr_cust_atributes_key = 2 then atribute_value else null end) as LOB,
        max(case when sdr_cust_atributes_key = 3 then atribute_value else null end) as GSW,
        max(case when sdr_cust_atributes_key = 4 then atribute_value else null end) as Disposition
FROM sdr_Cust_Atributes_Fact scaf
inner join sdr_session_fact         ssf     on  (ssf.session_id             =   scaf.session_id)
inner join date_time                dt      on  (ssf.start_date_time_key    =   dt.date_time_key)
where

dt.cal_date between CURRENT_DATE - 5 and CURRENT_DATE

Group by dt.LABEL_YYYY_MM_DD, dt.LABEL_YYYY_MM_DD_HH, scaf.session_id