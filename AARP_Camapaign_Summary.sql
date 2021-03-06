with All_Contacts_Table as 
(select
        dt.LABEL_YYYY_MM_DD as Delivery_Date,
        scaf.session_id as sess_id,
        max(ssf.start_ts_ms/1000) as Start_Time,
        max(ssf.end_ts_ms/1000) as End_Time,
        max(case when sdr_cust_atributes_key = 49 then atribute_value else null end) as Address_,
        max(case when sdr_cust_atributes_key = 34 then atribute_value else null end) as Zip_Captured,
        max(case when sdr_cust_atributes_key = 51 then atribute_value else null end) as Postal_Code,
        max(case when sdr_cust_atributes_key = 17 then atribute_value else null end) as External_Transfer_Result,
        max(case when sdr_cust_atributes_key = 22 then atribute_value else null end) as Contact_Mode,
        max(case when sdr_cust_atributes_key = 50 then atribute_value else null end) as Intro_Option,
        max(case when sdr_cust_atributes_key = 21 then atribute_value else null end) as Address_Lookup_Result,
        max(case when sdr_cust_atributes_key = 20 then atribute_value else null end) as AARP_Lookup_Result,
        max(case when sdr_cust_atributes_key = 35 then atribute_value else null end) as Zip_Request,
        max(case when sdr_cust_atributes_key = 8  then atribute_value else null end) as Transfer_Type,
        max(case when sdr_cust_atributes_key = 18 then atribute_value else null end) as Legislator,
        max(case when sdr_cust_atributes_key = 26 then atribute_value else null end) as Legislator_Amount,
        max(case when sdr_cust_atributes_key = 27 then atribute_value else null end) as Legislator_Lookup_Result,
        max(case when sdr_cust_atributes_key = 28 then atribute_value else null end) as Legislator_Number,
        max(case when sdr_cust_atributes_key = 53 then atribute_value else null end) as Campaign_Name
FROM sdr_Cust_Atributes_Fact scaf
inner join sdr_session_fact         ssf     on  (ssf.session_id             =   scaf.session_id)
inner join date_time                dt      on  (ssf.start_date_time_key    =   dt.date_time_key)
where dt.cal_date >(current_date - interval '1 week')
Group by dt.LABEL_YYYY_MM_DD, scaf.session_id
)

Select
    act.Delivery_Date,
    act.Campaign_Name,
    sum(case when act.External_Transfer_Result  is not null     then 1 else 0 end)  as Selections_Made,
    sum(case when act.External_Transfer_Result  = 'Success'     then 1 else 0 end)  as Direct_Connect_Success,
    sum(case when act.External_Transfer_Result  = 'Fail'        then 1 else 0 end)  as Direct_Connect_Failed,
    --sum(case when act.External_Transfer_Result  = 'false'       then 1 else 0 end)  as Direct_Connect_False,
    --sum(case when act.External_Transfer_Result  = 'true'        then 1 else 0 end)  as Direct_Connect_True,
    sum(case when act.Legislator_Lookup_Result  = 'Fail'        then 1 else 0 end)  as third_Party_API_Fail,
    sum(case when act.Legislator_Amount         = 'Multiple'    then 1 else 0 end)  as third_Party_API_Multiple,
    sum(case when act.Legislator_Amount         = 'Single'      then 1 else 0 end)  as third_Party_API_Single,
    sum(case when act.Address_                  is not null     then 1 else 0 end)  as Address_Captured,
    sum(case when act.Zip_Captured              is not null     then 1 else 0 end)  as Zip_Captured,
    sum(case when act.Postal_Code               is not null     then 1 else 0 end)  as Postal_Code_Captured,
    sum(case when act.Intro_Option              = 'End Call'    then 1 else 0 end)  as Intro_Option_End_Call,
    sum(case when act.Intro_Option              = 'Transfer'    then 1 else 0 end)  as Intro_Option_Transfer,
    sum(case when act.Intro_Option              = 'Repeat'      then 1 else 0 end)  as Intro_Option_Repeat,
    sum(case when act.Intro_Option              = 'Hang Up'     then 1 else 0 end)  as Intro_Option_HangUp,
    sum(case when act.Address_Lookup_Result     = 'Not Found'   then 1 else 0 end)  as Address_Missing,
    sum(case when act.Address_Lookup_Result     = 'AARP DB API' then 1 else 0 end)  as Address_AARP,
    sum(case when act.Address_Lookup_Result     = 'Source Data' then 1 else 0 end)  as Address_Source_Data,
    sum(case when act.Zip_Request               = 'Invalid'     then 1 else 0 end)  as Zip_Request_Invalid,
    sum(case when act.Zip_Request               = 'Confirmed'   then 1 else 0 end)  as Zip_Request_Confirmed,
    sum(case when act.Zip_Request               = 'Timed Out'   then 1 else 0 end)  as Zip_Request_Timed_Out,
    sum(case when act.AARP_Lookup_Result        = 'Fail'        then 1 else 0 end)  as AARP_API_Fail,
    sum(case when act.AARP_Lookup_Result        = 'Success'     then 1 else 0 end)  as AARP_API_Success,
    count(*)                                                                        as Total_Inbound,
    round(max(act.End_Time - act.Start_Time),2)                                     as Total_Duration,
    round(max(act.End_Time - act.Start_Time)/Count(*),2)                            as Avg_Duration

from All_Contacts_Table act
group by act.Delivery_Date, act.Campaign_Name
    

