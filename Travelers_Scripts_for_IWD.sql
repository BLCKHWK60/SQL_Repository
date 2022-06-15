SELECT   
    dt.label_yyyy_mm_dd AS day, 
    assign_date_key,
    assign_task_event_id,
    assign_time_key,
    assigned_agent_key,
    business_value_key,
    capture_id,
    capture_point_key,
    category_key,
    created_etl_audit_key,
    custom_attribute1,
    custom_attribute10,
    custom_attribute2,
    custom_attribute3,
    custom_attribute4,
    custom_attribute5,
    custom_attribute6,
    custom_attribute7,
    custom_attribute8,
    custom_attribute9,
    custom_dim_key,
    customer_key,
    customer_segment_key,
    department_key,
    finish_date_key,
    finish_interval,
    finish_task_event_id,
    finish_time_key,
    id,
    interaction_id,
    interaction_type_key,
    is_abandon,
    media_channel_key,
    media_type_key,
    priority_key,
    process_key,
    product_key,
    queue_key,
    result_code_key,
    solution_key,
    source_process_key,
    source_tenant_key,
    start_date_time_key,
    tenant_key,
    updated_etl_audit_key,
    work_time_sec
FROM   i_task_work_fact f   
INNER JOIN date_time dt ON ( dt.date_time_key = f.start_date_time_key), 
(
    SELECT min(etl_audit_key) AS min_audit_key, 
max(etl_audit_key) AS max_audit_key
FROM etl_audit 
WHERE cast(to_char(etl_audit_start_time,'yyyy-mm-dd') AS DATE) = current_date - 1
) ea 
WHERE   (f.created_etl_audit_key >= min_audit_key AND f.created_etl_audit_key <= max_audit_key) OR
        (f.updated_etl_audit_key >= min_audit_key AND f.updated_etl_audit_key <= max_audit_key)