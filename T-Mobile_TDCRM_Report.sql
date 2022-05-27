select
        dt.LABEL_YYYY_MM_DD as Day_,
        dt.LABEL_YYYY_MM_DD_HH as Day_Hour,
        max(to_timestamp(ssf.start_ts_ms/1000)) as Start_Time,
        max(to_timestamp(ssf.end_ts_ms/1000)) as End_Time,  
        scaf.session_id as sess_id, 
        max(ssf.ANI) as ANI, 
        max(ssf.Interaction_ID) as Int_ID, 
        max(case when sdr_cust_atributes_key = 8 then atribute_value else null end) as Ind_Personal_ID,
        max(case when sdr_cust_atributes_key = 10 then atribute_value else null end) as Event_Date_Time,
        max(case when sdr_cust_atributes_key = 11 then atribute_value else null end) as Ind_Entity_Proxy_ID,
        max(case when sdr_cust_atributes_key = 12 then atribute_value else null end) as Resp_Tracking_Code,
        max(case when sdr_cust_atributes_key = 4 then atribute_value else null end) as Disposition
FROM sdr_Cust_Atributes_Fact scaf
inner join sdr_session_fact         ssf     on  (ssf.session_id             =   scaf.session_id)
inner join date_time                dt      on  (ssf.start_date_time_key    =   dt.date_time_key)
where

dt.cal_date between CURRENT_DATE - 1 and CURRENT_DATE

Group by dt.LABEL_YYYY_MM_DD, dt.LABEL_YYYY_MM_DD_HH, scaf.session_id


---
with All_Contacts_Table as 
(select
        dt.LABEL_YYYY_MM_DD as Day_,
        dt.LABEL_YYYY_MM_DD_HH as Day_Hour,
        max(to_timestamp(ssf.start_ts_ms/1000)) as Start_Time,
        max(to_timestamp(ssf.end_ts_ms/1000)) as End_Time,  
        scaf.session_id as sess_id, 
        max(ssf.ANI) as ANI, 
        max(ssf.Interaction_ID) as Int_ID, 

FROM sdr_Cust_Atributes_Fact scaf
inner join sdr_session_fact         ssf     on  (ssf.session_id             =   scaf.session_id)
inner join date_time                dt      on  (ssf.start_date_time_key    =   dt.date_time_key)
where dt.cal_date >(current_date - interval '1 week')
Group by dt.LABEL_YYYY_MM_DD, scaf.session_id
)




--- TESTING ---
SELECT 
SUBSTRING(atribute_value, Accepted: ,5)
AS AcceptedDispoPart1
FROM SDR_CUST_ATRIBUTES_FACT  


---

SELECT atribute_value,
SUBSTRING('Accepted: ', 5) AS AcceptedDispoPart
FROM SDR_CUST_ATRIBUTES_FACT   
where SDR_CUST_ATRIBUTES_KEY=4

---

SELECT atribute_value,  
trim(split_part(atribute_value, '|', 1), 'Language Preference:')
 AS LanguagePref, 
trim(split_part(atribute_value, '|', 2), ' Customer Resolution:')
 AS CustomerResolution,
trim(split_part(atribute_value, '|', 3), ' Accepted: ')
 AS AcceptedDispoPart, 
trim(split_part(atribute_value, '|', 4), ' Issue State @ end-of-call: ')
 AS Issue_State_End 
FROM SDR_CUST_ATRIBUTES_FACT   
where SDR_CUST_ATRIBUTES_KEY=4 

---

SELECT atribute_value,  
split_part(atribute_value, '|', 1)
 AS at1, 
split_part(atribute_value, '|', 2)
 AS at2,
split_part(atribute_value, '|', 3)
 AS at3, 
split_part(atribute_value, '|', 4)
AS at4, 
split_part(atribute_value, '|', 5)
AS at5,
split_part(atribute_value, '|', 6)
AS at6,
split_part(atribute_value, '|', 7)
AS at7,
split_part(atribute_value, '|', 8)
AS at8,
split_part(atribute_value, '|', 9)
AS at9,
split_part(atribute_value, '|', 10)
AS at10,
split_part(atribute_value, '|', 11)
AS at11,
split_part(atribute_value, '|', 12)
AS at12,
split_part(atribute_value, '|', 13)
AS at13,
split_part(atribute_value, '|', 14)
AS at14
FROM SDR_CUST_ATRIBUTES_FACT   
where SDR_CUST_ATRIBUTES_KEY=4 



--- Successful Query 2022-04-11 ---
With EVENT_TYPE_CODE as
(
    SELECT atribute_value,
    (case when atribute_value like '%Accepted: No Selection Made%'      then 'Not_Accepted'  else 'Accepted'      end) as ACPT, 
    (case when atribute_value like '%Declined: No Selection Made%'      then 'Not_Declined'  else 'Declined'      end) as DECL,  
    (case when atribute_value like '%Non Contact: No Selection Made%'   then 'Contacted'     else 'Not_Contacted' end) as NOCT    
    FROM SDR_CUST_ATRIBUTES_FACT   sdrf  
    where SDR_CUST_ATRIBUTES_KEY=4
)
with EVENT_REASON_CODE as
(
    SELECT atribute_value,
    (case when atribute_value like '%Accepted: No Selection Made%'      then 'Not_Accepted'  else SUBSTRING(atribute_value, Accepted: ,5)  end) as ACPT, 
    (case when atribute_value like '%Declined: No Selection Made%'      then 'Not_Declined'  else 'Declined'      end) as DECL,  
    (case when atribute_value like '%Non Contact: No Selection Made%'   then 'Contacted'     else 'Not_Contacted' end) as NOCT    
    FROM SDR_CUST_ATRIBUTES_FACT   sdrf
    where SDR_CUST_ATRIBUTES_KEY=4
)


--------
With EVENT_TYPE_CODE as
(
    SELECT   
    session_id, 
    atribute_value,
    (case when atribute_value like '%Accepted: No Selection Made%'      then 'Not_Accepted'  else 'Accepted'      end) as ACPT, 
    (case when atribute_value like '%Declined: No Selection Made%'      then 'Not_Declined'  else 'Declined'      end) as DECL,  
    (case when atribute_value like '%Non Contact: No Selection Made%'   then 'Contacted'     else 'Not_Contacted' end) as NOCT    
    FROM SDR_CUST_ATRIBUTES_FACT   sdrf  
    where SDR_CUST_ATRIBUTES_KEY=4
),
ATRIBUTE_LIST as 
( 
SELECT   
session_id, 
atribute_value,  
split_part(atribute_value, '|', 1)
 AS at1, 
split_part(atribute_value, '|', 2)
 AS at2,
split_part(atribute_value, '|', 3)
 AS at3, 
split_part(atribute_value, '|', 4)
AS at4, 
split_part(atribute_value, '|', 5)
AS at5,
split_part(atribute_value, '|', 6)
AS at6,
split_part(atribute_value, '|', 7)
AS at7,
split_part(atribute_value, '|', 8)
AS at8,
split_part(atribute_value, '|', 9)
AS at9,
split_part(atribute_value, '|', 10)
AS at10,
split_part(atribute_value, '|', 11)
AS at11,
split_part(atribute_value, '|', 12)
AS at12,
split_part(atribute_value, '|', 13)
AS at13,
split_part(atribute_value, '|', 14)
AS at14
FROM SDR_CUST_ATRIBUTES_FACT   
where SDR_CUST_ATRIBUTES_KEY=4 
)
Select  
EVENT_TYPE_CODE.ACTP,
EVENT_TYPE_CODE.DECL,
EVENT_TYPE_CODE.NOCT,
ltrim(case when alist.at3 like 'Accepted: No Selection Made' then 'Accepted: No Selection Made' else alist.at3 end, 'Accepted: ') as Accepted,
ltrim(case when alist.at5 like 'Declined: No Selection Made' then 'Declined: No Selection Made' else alist.at5 end, 'Declined: ') as Declined,
ltrim(case when alist.at6 like 'Non Contact: No Selection Made' then 'Non Contact: No Selection Made' else alist.at6 end, 'Non Contact: ') as Non_Contact
from ATRIBUTE_LIST alist   
inner join EVENT_TYPE_CODE on (EVENT_TYPE_CODE.SESSION_ID = ATRIBUTE_LIST.SESSION_ID) 


---------

With EVENT_TYPE_CODE as
(
    SELECT   
    dt.LABEL_YYYY_MM_DD as Date,
    sdrf.session_id as Session_ID, 
    ssf.interaction_id as Int_ID,
    --ssf.DNIS as Cust_Num,
    sdrf.atribute_value,
    (case when sdrf.atribute_value like '%Accepted: No Selection Made%'      then 'Not_Accepted'  else 'Accepted'      end) as ACPT, 
    (case when sdrf.atribute_value like '%Declined: No Selection Made%'      then 'Not_Declined'  else 'Declined'      end) as DECL,  
    (case when sdrf.atribute_value like '%Non Contact: No Selection Made%'   then 'Contacted'     else 'Not_Contacted' end) as NOCT    
    FROM SDR_CUST_ATRIBUTES_FACT   sdrf  
    inner join DATE_TIME dt on (sdrf.START_DATE_TIME_KEY = dt.DATE_TIME_KEY)
    inner join SDR_SESSION_FACT ssf on (sdrf.SESSION_ID = ssf.SESSION_ID)
    where sdrf.SDR_CUST_ATRIBUTES_KEY=4
    and dt.cal_date >(current_date - interval '2 weeks')
),
----
WITH
ATRIBUTE_LIST as 
( 
    SELECT  
    sdrf.session_id                                                  as SESS_ID,
    (case when sdr_cust_atributes_key = 2   then atribute_value end) as LOB, --ClosedLoop--
    (case when sdr_cust_atributes_key = 11  then atribute_value end) as IND_ENT_PROXY_ID,
    (case when sdr_cust_atributes_key = 8   then atribute_value end) as IND_PERSONAL_LINK_SID,
    (case when sdr_cust_atributes_key = 12  then atribute_value end) as RESP_TRACKING_CODE,
    (case when sdr_cust_atributes_key = 10  then atribute_value end) as EVENT_DATE_TIME
    FROM SDR_CUST_ATRIBUTES_FACT sdrf  
    inner join DATE_TIME dt             on (sdrf.START_DATE_TIME_KEY = dt.DATE_TIME_KEY)
    where dt.cal_date >(current_date - interval '2 weeks') and sdrf.sdr_cust_atributes_key in (2,4,8,10,11,12)  
),
CUST_DISPOSITION as
(  
    Select
    dt.LABEL_YYYY_MM_DD                         AS Date,
    sdrf1.session_id                            AS SESS_ID,
    split_part(sdrf1.atribute_value, '|', 1)    AS at1,
    split_part(sdrf1.atribute_value, '|', 2)    AS at2, 
    split_part(sdrf1.atribute_value, '|', 3)    AS at3, 
    split_part(sdrf1.atribute_value, '|', 4)    AS at4, 
    split_part(sdrf1.atribute_value, '|', 5)    AS at5,
    split_part(sdrf1.atribute_value, '|', 6)    AS at6,
    split_part(sdrf1.atribute_value, '|', 7)    AS at7,
    (case when sdrf1.atribute_value like '%Accepted: No Selection Made%'     then 'No_Selection_Made'  else 'Accepted'      end) as ACPT, 
    (case when sdrf1.atribute_value like '%Declined: No Selection Made%'     then 'No_Selection_Made'  else 'Declined'      end) as DECL,  
    (case when sdrf1.atribute_value like '%Non Contact: No Selection Made%'  then 'No_Selection_Made'  else 'Not_Contacted' end) as NOCT  
    from SDR_CUST_ATRIBUTES_FACT sdrf1
    inner join DATE_TIME dt on (sdrf1.START_DATE_TIME_KEY = dt.DATE_TIME_KEY)
    where sdrf1.sdr_cust_atributes_key = 4 and dt.cal_date >(current_date - interval '2 weeks')
) 
Select
cust.Date                           as Date, 
alist.sess_id                       as Sess_ID, 
max(alist.IND_ENT_PROXY_ID)         as ENT_ID,
max(alist.IND_PERSONAL_LINK_SID)    as PERSONAL_ID,
max(alist.RESP_TRACKING_CODE)       as TRACKING_CODE,
max(alist.EVENT_DATE_TIME)          as DATE_TIME,
max(cust.ACPT)                      as ACPT,
max(cust.DECL)                      as DECL,
max(cust.NOCT)                      as NOCT,
max(ltrim(case when cust.at3 like 'Accepted: No Selection Made'    then 'Accepted: No Selection Made'      else cust.at3 end, 'Accepted: '))    as Accepted,
max(ltrim(case when cust.at5 like 'Declined: No Selection Made'    then 'Declined: No Selection Made'      else cust.at5 end, 'Declined: '))    as Declined,
max(ltrim(case when cust.at6 like 'Non Contact: No Selection Made' then 'Non Contact: No Selection Made'   else cust.at6 end, 'Non Contact: ')) as Non_Contact
from CUST_DISPOSITION cust  
inner join ATRIBUTE_LIST alist on (cust.SESS_ID = alist.SESS_ID)
group by
cust.date, alist.sess_id
