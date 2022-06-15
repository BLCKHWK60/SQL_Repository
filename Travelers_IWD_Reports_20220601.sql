--- H_TASK_FACT Export ---
select
    interaction_type_key,
    media_type_key,
    media_channel_key,
    start_date_time_key,
    interaction_id,
    activate_time_from_created_sec,
    activation_interval,
    assign_time_from_created_sec,
    activation_date_key,
    activation_time_key,
    assigned_date_key,
    assigned_interval,
    assigned_time_key,
    business_value_key,
    capture_id,
    capture_point_key,
    category_key,
    complete_time_from_created_sec,
    completed_date_key,
    completed_interval,
    completed_time_key,
    completed_ts,
    created_date_key,
    created_interval,
    created_time_key,
    crt_time_fr_src_crtd_sec,
    current_priority_key,
    current_queue_key,
    current_queue_target_key,
    current_status_key,
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
    due_date_key,
    due_interval,
    due_time_key,
    due_ts,
    last_assigned_agent_key,
    last_result_code_key,
    last_task_event_id,
    process_key,
    product_key,
    requested_agent_key,
    requested_skill_key,
    solution_key,
    source_created_date_key,
    source_created_interval,
    source_created_time_key,
    source_due_date_key,
    source_due_time_key,
    source_first_created_date_key,
    source_first_created_interval,
    source_first_created_time_key,
    source_process_key,
    source_tenant_key,
    src_crt_time_fr_first_crtd_sec,
    stopped_date_key,
    tenant_key,
    timezone_key,
    total_held_time_sec,
    total_work_time_sec,
    created_etl_audit_key,
    updated_etl_audit_key
from  h_task_fact htf,
(
    SELECT min(etl_audit_key) AS min_audit_key, 
max(etl_audit_key) AS max_audit_key
FROM etl_audit 
WHERE cast(to_char(etl_audit_start_time,'yyyy-mm-dd') AS DATE) = current_date - 1
) ea 
WHERE   (htf.created_etl_audit_key >= min_audit_key AND htf.created_etl_audit_key <= max_audit_key) OR
        (htf.updated_etl_audit_key >= min_audit_key AND htf.updated_etl_audit_key <= max_audit_key)

--- I_TASK_EVENT_FACT Export ---
select 
    activation_date_key,
    activation_time_key,
    assigned_agent_key,
    business_value_key,
    capture_id,
    created_etl_audit_key,
    custom_dim_key,
    department_key,
    due_date_key,
    due_time_key,
    entered_queue_key,
    entered_queue_target_key,
    event_date_key,
    event_interval,
    event_time_key,
    exited_queue_key,
    exited_queue_target_key,
    held_time_sec,
    id,
    interaction_id,
    priority_key,
    process_key,
    result_code_key,
    solution_key,
    start_date_time_key,
    status_key,
    task_event_id,
    task_event_type_key,
    updated_etl_audit_key,
    work_time_sec
from   i_task_event_fact itef, 
(
    SELECT min(etl_audit_key) AS min_audit_key, 
max(etl_audit_key) AS max_audit_key
FROM etl_audit 
WHERE cast(to_char(etl_audit_start_time,'yyyy-mm-dd') AS DATE) = current_date - 1
) ea 
WHERE   (itef.created_etl_audit_key >= min_audit_key AND itef.created_etl_audit_key <= max_audit_key) OR
        (itef.updated_etl_audit_key >= min_audit_key AND itef.updated_etl_audit_key <= max_audit_key)


--- I_TASK_WORK_FACT Export ---
select 
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
from   i_task_work_fact itwf,
(
    SELECT min(etl_audit_key) AS min_audit_key, 
max(etl_audit_key) AS max_audit_key
FROM etl_audit 
WHERE cast(to_char(etl_audit_start_time,'yyyy-mm-dd') AS DATE) = current_date - 1
) ea 
WHERE   (itwf.created_etl_audit_key >= min_audit_key AND itwf.created_etl_audit_key <= max_audit_key) OR
        (itwf.updated_etl_audit_key >= min_audit_key AND itwf.updated_etl_audit_key <= max_audit_key)

--- QUEUE Export ---
select 
    created_etl_audit_key,
    queue_key,
    queue_name,
    queue_type,
    updated_etl_audit_key
from queue q, 
(
    SELECT min(etl_audit_key) AS min_audit_key, 
max(etl_audit_key) AS max_audit_key
FROM etl_audit 
WHERE cast(to_char(etl_audit_start_time,'yyyy-mm-dd') AS DATE) = current_date - 1
) ea 
WHERE   (q.created_etl_audit_key >= min_audit_key AND q.created_etl_audit_key <= max_audit_key) OR
        (q.updated_etl_audit_key >= min_audit_key AND q.updated_etl_audit_key <= max_audit_key) 

--- CUSTOM_DIM Export ---
select 
    created_etl_audit_key,
    custom_dim_attribute1,
    custom_dim_attribute2,
    custom_dim_attribute3,
    custom_dim_attribute4,
    custom_dim_attribute5,
    custom_dim_key,
    updated_etl_audit_key
from   custom_dim cd, 
(
    SELECT min(etl_audit_key) AS min_audit_key, 
max(etl_audit_key) AS max_audit_key
FROM etl_audit 
WHERE cast(to_char(etl_audit_start_time,'yyyy-mm-dd') AS DATE) = current_date - 1
) ea 
WHERE   (cd.created_etl_audit_key >= min_audit_key AND cd.created_etl_audit_key <= max_audit_key) OR
        (cd.updated_etl_audit_key >= min_audit_key AND cd.updated_etl_audit_key <= max_audit_key)

--- PROCESS Export ---
select 
    category_level10,
    category_level3,
    category_level4,
    category_level5,
    category_level6,
    category_level7,
    category_level8,
    category_level9,
    created_etl_audit_key,
    custom_dim_key,
    department_key,
    process_config_event_id,
    process_config_id,
    process_key,
    process_name,
    process_runtime_id,
    solution_key,
    tenant_key,
    updated_etl_audit_key,
    valid_from,
    valid_from_date_key,
    valid_from_time_key,
    valid_to,
    valid_to_date_key,
    valid_to_time_key,
    version
from   process pr,
(
    SELECT min(etl_audit_key) AS min_audit_key, 
max(etl_audit_key) AS max_audit_key
FROM etl_audit 
WHERE cast(to_char(etl_audit_start_time,'yyyy-mm-dd') AS DATE) = current_date - 1
) ea 
WHERE   (pr.created_etl_audit_key >= min_audit_key AND pr.created_etl_audit_key <= max_audit_key) OR
        (pr.updated_etl_audit_key >= min_audit_key AND pr.updated_etl_audit_key <= max_audit_key)


--- RESULT_CODE Export ---
select 
    created_etl_audit_key,
    result_code_key,
    result_code_name,
    updated_etl_audit_key
from   result_code rc,
(
    SELECT min(etl_audit_key) AS min_audit_key, 
max(etl_audit_key) AS max_audit_key
FROM etl_audit 
WHERE cast(to_char(etl_audit_start_time,'yyyy-mm-dd') AS DATE) = current_date - 1
) ea 
WHERE   (rc.created_etl_audit_key >= min_audit_key AND rc.created_etl_audit_key <= max_audit_key) OR
        (rc.updated_etl_audit_key >= min_audit_key AND rc.updated_etl_audit_key <= max_audit_key)


--- STATUS Export (No Update to table) ---
select 
    is_final,
    is_held,
    status_key,
    status_name
from  status

--- EVENT_DATE Export (No Update to Table) ---
select 
    day_name,
    day_num_in_month,
    day_num_in_week,
    day_num_in_year,
    event_date,
    event_date_key,
    event_date_str,
    month_name,
    month_num_in_year,
    quarter_num_in_year,
    week_end_date,
    week_num_in_year,
    week_start_date,
    year_num
from   event_date
