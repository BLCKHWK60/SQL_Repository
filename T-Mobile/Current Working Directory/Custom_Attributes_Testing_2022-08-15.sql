select
        dt.LABEL_YYYY_MM_DD as Day_,
        dt.LABEL_YYYY_MM_DD_HH as Day_Hour,
        to_timestamp(ssf.start_ts_ms/1000) as Start_Time,
        to_timestamp(ssf.end_ts_ms/1000) as End_Time,  
        scaf.session_id as sess_id, 
        ssf.ANI as ANI, 
        ssf.Interaction_ID as Int_ID, 
        scaf.sdr_cust_atributes_key, 
        scaf.atribute_value 
FROM sdr_Cust_Atributes_Fact scaf
inner join sdr_session_fact         ssf     on  (ssf.session_id             =   scaf.session_id)
inner join date_time                dt      on  (ssf.start_date_time_key    =   dt.date_time_key)
where
dt.cal_date >= CURRENT_DATE - 1  
and ssf.interaction_id in ('007OJ7LFH095V46SLLKKG2LAES0CFTVP', '01VN14LFL095V0ARS1KKG2LAES0CFM04', '025273LARS95V39IUTKKG2LAES0CVHJ4') 
--and  scaf.atribute_value = '5667680001' 
--and scaf.session_id = '~402~009H1AJ7S49473PKJLKKG2LAES01KLL2' 
 
--group by dt.LABEL_YYYY_MM_DD, dt.LABEL_YYYY_MM_DD_HH, scaf.session_id