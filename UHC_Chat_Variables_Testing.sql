
select
    scaf.sdr_cust_atributes_key,
    scaf.atribute_value,
    ssf.ani,
    ssf.end_ts_ms,
    ssf.final_sdr_milestone_key,
    ssf.interaction_id,
    ssf.menu_count,
    ssf.sdr_application_key,
    ssf.sdr_call_disposition_key,
    ssf.sdr_call_type_key,
    ssf.sdr_entry_point_key,
    ssf.sdr_exit_point_key,
    ssf.sdr_geo_location_key,
    ssf.self_helped_sdr_milestone_key,
    ssf.session_id,
    ssf.ss_duration_ms,
    ssf.start_date_time_key,
    ssf.start_ts_ms
from sdr_session_fact ssf
inner join sdr_cust_atributes_fact scaf on (ssf.session_id = scaf.session_id)
where ssf.sdr_application_key = '25'
order by ssf.start_date_time_key desc
