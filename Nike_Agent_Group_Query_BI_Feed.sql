--- Main Query For Agent Groups ---

Select 
irf.START_TS                        as START_TIME_UTC,
irf.END_TS                          as END_TIME_UTC,
irf.INTERACTION_ID                  as INTERACTION_ID,
irf.INTERACTION_RESOURCE_ID         as INTERACTION_RESOURCE_ID,   
irf.RESOURCE_GROUP_COMBINATION_KEY  as GROUP_COMBINATION_KEY, 
irf.RESOURCE_KEY                    as RESOURCE_KEY,  
it.INTERACTION_TYPE                 as INTERACTION_TYPE, 
g.GROUP_NAME                        as GROUP_NAME, 
r.RESOURCE_NAME                     as AGENT_NAME, 
af.FIRST_ENGAGE_FOR_AGENT_IXN       as FIRST_AGENT_1_IS_TRUE 

from INTERACTION_RESOURCE_FACT irf
    inner join      RESOURCE_               r      on(irf.RESOURCE_KEY = r.RESOURCE_KEY)
    inner join      RESOURCE_GROUP_FACT_    rgf    on(irf.RESOURCE_KEY = rgf.RESOURCE_KEY)
    inner join      GROUP_                  g      on(rgf.GROUP_KEY = g.GROUP_KEY)
    inner join      DATE_TIME               dt     on(irf.START_DATE_TIME_KEY = dt.DATE_TIME_KEY)
    inner join      TECHNICAL_DESCRIPTOR    td     on(irf.TECHNICAL_DESCRIPTOR_KEY = td.TECHNICAL_DESCRIPTOR_KEY)
    left outer join ANCHOR_FLAGS            af     on(irf.ANCHOR_FLAGS_KEY = af.ANCHOR_FLAGS_KEY)
    inner join      MEDIA_TYPE              mt     on(mt.MEDIA_TYPE_KEY = irf.MEDIA_TYPE_KEY)
    inner join      INTERACTION_TYPE        it     on(it.INTERACTION_TYPE_KEY = irf.INTERACTION_TYPE_KEY) 
 
where r.RESOURCE_TYPE = 'Agent' and dt.LABEL_YYYY_MM_DD = '2021-10-20' and g.group_name <> 'GSYS_Internal_Agents'  
 /*This line is for querying directly from GIM for 2021-10-20 and excludes all  
 group types except Agent Groups and filters out the GSYS Internal Agent Group */



--- RESOURCE_GROUP_FACT (view) ---

	select
	RESOURCE_GROUP_FACT_KEY,
	START_DATE_TIME_KEY,
	END_DATE_TIME_KEY,
	TENANT_KEY,
	RESOURCE_KEY,
	GROUP_KEY,
	CREATE_AUDIT_KEY,
	UPDATE_AUDIT_KEY,
	START_TS,
	END_TS,
		(
		case when ACTIVE_FLAG <> 0 
		then (select (max(LAST_CFG_EXTRACT_TS) - START_TS) 
		from CTL_EXTRACT_METRICS) 
		else END_TS - START_TS end
		) 
	as  TOTAL_DURATION,
		ACTIVE_FLAG,
		PURGE_FLAG

	from RESOURCE_GROUP_FACT_

--- END ---

--- GROUP_ (view) ---

	SELECT
	ID 					AS GROUP_KEY,
	TENANTID 			AS TENANT_KEY,
	NAME 				AS GROUP_NAME,
	CREATE_AUDIT_KEY 	AS CREATE_AUDIT_KEY,
	UPDATE_AUDIT_KEY 	AS UPDATE_AUDIT_KEY,
	CASE TYPE
		WHEN 0 THEN 'Unknown'
		WHEN 1 THEN 'Agent'
		WHEN 2 THEN 'Place'
		WHEN 3 THEN
	CASE DNGROUPTYPE
		WHEN 0 THEN 'Unknown'
		WHEN 1 THEN 'Single Port'
		WHEN 2 THEN 'Queue'
		WHEN 3 THEN 'RoutingPoint'
		WHEN 4 THEN 'Network Port'
		WHEN 5 THEN 'Service Number'
		ELSE 'Unknown'
		END
		ELSE 'Unknown'
		END 			AS GROUP_TYPE,
	CASE TYPE
		WHEN 0 THEN 'UNKNOWN'
		WHEN 1 THEN 'AGENT'
		WHEN 2 THEN 'PLACE'
		WHEN 3 THEN
	CASE DNGROUPTYPE
		WHEN 0 THEN 'UNKNOWN'
		WHEN 1 THEN 'SINGLEPORT'
		WHEN 2 THEN 'QUEUE'
		WHEN 3 THEN 'ROUTINGPOINT'
		WHEN 4 THEN 'NETWORKPORT'
		WHEN 5 THEN 'SERVICENUMBER'
		ELSE 'UNKNOWN'
		END
		ELSE 'UNKNOWN'
		END 			AS GROUP_TYPE_CODE,
	ID 					AS GROUP_CFG_DBID,
	TYPE 				AS GROUP_CFG_TYPE_ID,
	CREATED_TS 			AS START_TS,
	DELETED_TS 			AS END_TS
	
	FROM GIDB_GC_GROUP
	UNION ALL
	SELECT
	-1 					AS GROUP_KEY,
	-1 					AS TENANT_KEY,
	'UNKNOWN' 			AS GROUP_NAME,
	-1 					AS CREATE_AUDIT_KEY,
	-1 					AS UPDATE_AUDIT_KEY,
	'UNKNOWN' 			AS GROUP_TYPE,
	'UNKNOWN' 			AS GROUP_TYPE_CODE,
	-1 					AS GROUP_CFG_DBID,
	-1 					AS GROUP_CFG_TYPE_ID,
	-1 					AS START_TS,
	-1 					AS END_TS
	FROM dual
	UNION ALL
	SELECT
	-2 					AS GROUP_KEY,
	-1 					AS TENANT_KEY,
	'No Group' 			AS GROUP_NAME,
	-1 					AS CREATE_AUDIT_KEY,
	-1 					AS UPDATE_AUDIT_KEY,
	'NO_VALUE' 			AS GROUP_TYPE,
	'NO_VALUE' 			AS GROUP_TYPE_CODE,
	-1 					AS GROUP_CFG_DBID,
	-1 					AS GROUP_CFG_TYPE_ID,
	-1 					AS START_TS,
	-1 					AS END_TS
	FROM dual

	--- END ---