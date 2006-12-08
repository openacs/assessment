ad_page_contract {
    Delete a users sessions for a particular assessment
} {
    assessment_id:integer
    subject_id:integer
    {return_url ""}
} 

permission::require_permission \
    -party_id [ad_conn user_id] \
    -object_id [ad_conn package_id] \
    -privilege admin
as::assessment::data -assessment_id $assessment_id
set assessment_name $assessment_data(name)
if {$assessment_data(anonymous_p)} {
    set subject_name "Anonymous"
} else {
    set subject_name "Not Anonymous"
}

# setup a list of session_ids
set session_id_options [list]
db_foreach get_sessions "" {
    set creation_datetime [lc_time_fmt $creation_datetime "%x %X"]
    set completed_datetime [lc_time_fmt $completed_datetime "%x %X"]
    lappend session_id_options [list "$session_id [_ assessment.Attempt_started_completed [list creation_datetime $creation_datetime completed_datetime $completed_datetime]]" $session_id]
}

ad_form -name session-delete -export {assessment_id subject_id return_url} \
    -has_submit 1 \
    -form {
        {session_id:text(checkbox),multiple {label "[_ assessment.Attempts_to_delete]"} {options $session_id_options}}
        {cancel:text(submit) {label "[_ acs-kernel.common_Cancel]"}}
        {ok:text(submit) {label "[_ acs-kernel.common_Delete]"}}
        
    } -on_submit {
        if {[info exists ok] && $ok ne ""} {
            #delete sessions
            set message "[_ assessment.Requested_attempts_deleted]"
            foreach id $session_id {
                as::session::delete -session_id $id
            }
        } else {
            set message "[_ assessment.Delete_canceled]"
        }

        if {$return_url eq "" || [set session_count [db_string count_sessions "" -default 0]] == 0} {
            set return_url [export_vars -base results-users {assessment_id}]
        }
        ad_returnredirect -message $message $return_url
        ad_script_abort
    }

ad_return_template