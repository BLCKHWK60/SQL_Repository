Select
dt.LABEL_YYYY_MM_DD         as DATE,
ldrc.CAMPAIGN_TEMPLATE_NAME as CAMPAIGN_GROUP,
ldrc.CAMPAIGN_GROUP_NAME    as CAMPAIGN,
ldrg.GROUP_NAME             as GROUP_NAME,
ldrl.LIST_NAME              as CAMP_LIST_NAME,
ldrd.DEVICE_TIMEZONE        as TIME_ZONE,
ldrd.DEVICE_STATE_CODE      as CUST_STATE,
ldrp.POSTAL_CODE            as POSTAL_CODE,
ldrr.CONTACT_INFO_TYPE      as CONTACT_TYPE,
ldrr.DISPOSITION            as DISPOSITION,
ldrr.RECORD_STATUS          as RECORD_STATUS,
ldrr.RECORD_TYPE            as RECORD_TYPE


from       LDR_FACT         ldrf 
inner join DATE_TIME        dt   on (dt.DATE_TIME_KEY           = ldrf.START_DATE_TIME_KEY)
inner join LDR_CAMPAIGN     ldrc on (ldrf.LDR_CAMPAIGN_KEY      = ldrc.ID)
inner join LDR_GROUP        ldrg on (ldrf.LDR_GROUP_KEY         = ldrg.ID)
inner join LDR_RECORD       ldrr on (ldrf.LDR_RECORD_KEY        = ldrr.ID)
inner join LDR_DEVICE       ldrd on (ldrf.LDR_DEVICE_KEY        = ldrd.ID)
inner join LDR_POSTAL_CODE  ldrp on (ldrf.LDR_POSTAL_CODE_KEY   = ldrp.ID)
inner join LDR_LIST         ldrl on (ldrf.LDR_LIST_KEY          = ldrl.ID)

where   
dt.CAL_DATE > (current_date - interval '2 weeks')