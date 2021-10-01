with Custom_Legislators_Table as
(
select 
        scaf.session_id as sess_id,
        dt.LABEL_YYYY_MM_DD as Date,
        max(case when sdr_cust_atributes_key = 3 then atribute_value else null end) as DNIS,
        max(case when sdr_cust_atributes_key = 17 then atribute_value else null end) as External_Transfer_Result,
        max(case when sdr_cust_atributes_key = 18 then atribute_value else null end) as Legislator,
        max(case when sdr_cust_atributes_key = 25 then atribute_value else null end) as LOB_Name
FROM sdr_Cust_Atributes_Fact scaf
inner join sdr_session_fact         ssf     on  (ssf.session_id             =   scaf.session_id)
inner join date_time                dt      on  (ssf.start_date_time_key    =   dt.date_time_key)
where dt.cal_date >= CURRENT_DATE -31
Group by dt.LABEL_YYYY_MM_DD, scaf.session_id
)

Select
        Date,
        DNIS,
        LOB_Name,
        Legislator,
        sum(case when Legislator is not null then 1 else 0 end) as Times_Selected,
        sum(case when External_Transfer_Result = 'true' then 1 else 0 end) Times_Transferred
        
 From Custom_Legislators_Table clt
 
 where Legislator is not null
 
 group by Date, DNIS, LOB_Name, Legislator
 
 order by date asc
