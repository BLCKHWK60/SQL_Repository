-- IRF_QUERY --
select
dt.label_yyyy_mm_dd as date,
irf.last_vqueue_resource_key,
--r.resource_name,
irf.received_from_ixn_resource_id,  
irf.technical_descriptor_key,  
irf.resource_key,
intf.active_flag,
intf.anchor_id,
intf.anchor_sdt_key,
intf.create_audit_key,
intf.end_date_time_key,
intf.end_ts,
intf.interaction_id,
intf.interaction_type_key,
intf.media_server_ixn_guid,
cast(intf.media_server_ixn_id as BIGINT) as media_server_ixn_id,
intf.media_server_root_ixn_guid,
intf.media_server_root_ixn_id,
intf.media_type_key,
intf.source_address,
intf.start_date_time_key,
intf.start_ts,
intf.status,
intf.target_address
from interaction_fact intf
inner join interaction_resource_fact irf ON (irf.interaction_id = intf.interaction_id)
--inner join resource_ r ON (r.resource_key = irf.last_vqueue_resource_key)
inner join date_time dt ON (dt.date_time_key = irf.start_date_time_key)
where intf.media_server_ixn_guid IN
--unsuccessful Surveys
('01QSENG8R097511JH1HKG2LAES002BLG','01QSENG8R097511JH1HKG2LAES002BKV','01QSENG8R097511JH1HKG2LAES002BL7','01QSENG8R097511JH1HKG2LAES002M2O',
--successful surveys
'01QSENG8R097511JH1HKG2LAES002QL3','01QSENG8R097511JH1HKG2LAES002QOI','01QSENG8R097511JH1HKG2LAES002QH8','01QSENG8R097511JH1HKG2LAES002QDD','01QSENG8R097511JH1HKG2LAES002QBL',
-- Successful - New test 2022-05-26
'01QSENG8R097511JH1HKG2LAES003ALF')


-- SDR_QUERY --

select
    dt.label_yyyy_mm_dd as date,
    session_id,
    connection_id,
    interaction_id,
    ani,
    as_duration_ms,
    bailout_sdr_milestone_key,
    dtmf_path,
    final_sdr_milestone_key,
    input_count,
    menu_count,
    sdr_application_key,
    sdr_call_disposition_key,
    sdr_call_type_key,
    sdr_entry_point_key,
    sdr_exit_point_key,
    sdr_survey_i1_key,
    sdr_survey_i2_key,
    sdr_survey_questions_i1_key,
    sdr_survey_questions_i2_key,
    sdr_survey_questions_s1_key,
    sdr_survey_questions_s2_key,
    sdr_survey_s1_key,
    sdr_survey_s2_key,
    sdr_survey_scores_key,
    sdr_survey_status_key,
    self_helped_sdr_milestone_key,
    ss_duration_ms,
    start_date_time_key,
    start_ts_ms,
    strikeout_sdr_milestone_key
from sdr_session_fact ssf
inner join date_time dt on (dt.date_time_key = ssf.start_date_time_key)
where ssf.interaction_id IN
(
-- unsuccessful surveys
'01QSENG8R097511JH1HKG2LAES002BLG','01QSENG8R097511JH1HKG2LAES002BKV','01QSENG8R097511JH1HKG2LAES002BL7','01QSENG8R097511JH1HKG2LAES002M2O',
-- successful surveys
'01QSENG8R097511JH1HKG2LAES002QL3','01QSENG8R097511JH1HKG2LAES002QOI','01QSENG8R097511JH1HKG2LAES002QH8','01QSENG8R097511JH1HKG2LAES002QDD','01QSENG8R097511JH1HKG2LAES002QBL',
-- successful survey - 2022-05-26
'01QSENG8R097511JH1HKG2LAES003ALF'
)