ad_page_contract {
    This page deletes checks
    @author Anny Flores (annyflores@viaro.net) Viaro Networks
    @date 2005-01-17
} {
    action_log_id:multiple
    d_assessment
    d_state
    d_interval
    d_date

  }

set count [llength $action_log_id]

for { set i 0} { $i< $count } {incr i} {
    set log_id [lindex $action_log_id $i]
    set inter_item_check_id [db_string  get_check_id {select inter_item_check_id from as_actions_log where action_log_id=:log_id}]
    set session_id [db_string  get_session_id {select session_id from as_actions_log where action_log_id=:log_id}]
    

    as::assessment::check::manual_action_exec -inter_item_check_id $inter_item_check_id -session_id $session_id -action_log_id $log_id
}
ad_returnredirect "admin-request?assessment=$d_assessment&state=$d_state&interval=$d_interval&date=$d_date"