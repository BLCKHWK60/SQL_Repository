select
        dt.LABEL_YYYY_MM_DD as Day_,
        dt.LABEL_YYYY_MM_DD_HH as Day_Hour,
        to_timestamp(ssf.start_ts_ms/1000) as Start_Time,
        to_timestamp(ssf.end_ts_ms/1000) as End_Time,  
        scaf.session_id as sess_id,
        max(case when sdr_cust_atributes_key = 1 then atribute_value else null end) as ANI,
        max(case when sdr_cust_atributes_key = 2 then atribute_value else null end) as Caregiving_Menu,
        max(case when sdr_cust_atributes_key = 3 then atribute_value else null end) as DNIS,
        max(case when sdr_cust_atributes_key = 4 then atribute_value else null end) as Department,
        max(case when sdr_cust_atributes_key = 5 then atribute_value else null end) as Jump_to,
        max(case when sdr_cust_atributes_key = 6 then atribute_value else null end) as Language_,
        max(case when sdr_cust_atributes_key = 7 then atribute_value else null end) as State_Abbr,
        max(case when sdr_cust_atributes_key = 8 then atribute_value else null end) as Transfer_Type,
        max(case when sdr_cust_atributes_key = 17 then atribute_value else null end) as External_Transfer_Result,
        max(case when sdr_cust_atributes_key = 18 then atribute_value else null end) as Legislator,
        max(case when sdr_cust_atributes_key = 19 then atribute_value else null end) as US_State,
        max(case when sdr_cust_atributes_key = 20 then atribute_value else null end) as AARP_Lookup_Result,
        max(case when sdr_cust_atributes_key = 21 then atribute_value else null end) as Address_Lookup_Result,
        max(case when sdr_cust_atributes_key = 22 then atribute_value else null end) as Contact_Mode,
        max(case when sdr_cust_atributes_key = 23 then atribute_value else null end) as Is_Attempt,
        max(case when sdr_cust_atributes_key = 24 then atribute_value else null end) as Is_Interactive,
        max(case when sdr_cust_atributes_key = 25 then atribute_value else null end) as LOB_Name,
        max(case when sdr_cust_atributes_key = 26 then atribute_value else null end) as Legislator_Amount,
        max(case when sdr_cust_atributes_key = 27 then atribute_value else null end) as Legislator_Lookup_Result,
        max(case when sdr_cust_atributes_key = 28 then atribute_value else null end) as Legislator_Number,
        max(case when sdr_cust_atributes_key = 29 then atribute_value else null end) as Media_Type,
        max(case when sdr_cust_atributes_key = 30 then atribute_value else null end) as Source_Address,
        max(case when sdr_cust_atributes_key = 31 then atribute_value else null end) as Tenant_ID,
        max(case when sdr_cust_atributes_key = 32 then atribute_value else null end) as Tenant_Name,
        max(case when sdr_cust_atributes_key = 33 then atribute_value else null end) as Version_, 
        max(case when sdr_cust_atributes_key = 34 then atribute_value else null end) as Zip_Captured, 
        max(case when sdr_cust_atributes_key = 35 then atribute_value else null end) as Zip_Request,
        max(case when sdr_cust_atributes_key = 49 then atribute_value else null end) as Address,
        max(case when sdr_cust_atributes_key = 50 then atribute_value else null end) as Intro_Option,
        max(case when sdr_cust_atributes_key = 51 then atribute_value else null end) as Postal_Code
FROM sdr_Cust_Atributes_Fact scaf
inner join sdr_session_fact         ssf     on  (ssf.session_id             =   scaf.session_id)
inner join date_time                dt      on  (ssf.start_date_time_key    =   dt.date_time_key)
where

dt.cal_date between CURRENT_DATE - 7 and CURRENT_DATE

Group by dt.LABEL_YYYY_MM_DD, dt.LABEL_YYYY_MM_DD_HH, ssf.start_ts_ms, ssf.end_ts_ms, scaf.session_id