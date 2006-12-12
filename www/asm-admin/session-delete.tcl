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
    if {$completed_datetime eq ""} {
	set message_key assessment.Attempt_started_incomplete
    } else {
	set message_key assessment.Attempt_started_completed
    }
    set view_session_url [export_vars -base results-session {session_id}]
    lappend session_id_options [list "[_ $message_key [list creation_datetime $creation_datetime completed_datetime $completed_datetime]] [_ assessment.View_session_in_a_new_window [list view_session_url $view_session_url]]" $session_id]
}
set check_all_options [list [list [_ assessment.Select_All] ""]]
ad_form -name session-delete -export {assessment_id subject_id return_url} \
    -has_submit 1 \
    -form {
        {cancel0:text(submit) {label "[_ acs-kernel.common_Cancel]"}}
        {ok0:text(submit) {label "[_ acs-kernel.common_Delete]"}}
	{check_all:text(checkbox),optional {label ""} {options $check_all_options} {html {onClick acs_CheckAll('session-delete:elements:session_id',this.checked)}}}
        {session_id:text(checkbox),multiple,optional {label "[_ assessment.Attempts_to_delete]"} {options $session_id_options}}
        {cancel:text(submit) {label "[_ acs-kernel.common_Cancel]"}}
        {ok:text(submit) {label "[_ acs-kernel.common_Delete]"}}
        
    } -on_request {
	if {[info exists session_id]} {
	    template::element::set_values session-delete session_id $session_id
	}
    } -on_submit {
        if {([info exists ok] && $ok ne "" \
		 || [info exists ok0] && $ok0 ne "" ) \
		&& [info exists session_id]} {
            #delete sessions
            set message "[_ assessment.Requested_attempts_deleted]"
            foreach id $session_id {
                as::session::delete -session_id $id
            }
        } else {
            set message "[_ assessment.Delete_cancelled]"
        }

        if {$return_url eq "" || [set session_count [db_string count_sessions "" -default 0]] == 0} {
            set return_url [export_vars -base results-users {assessment_id}]
        }
        ad_returnredirect -message $message $return_url
        ad_script_abort
    }

set header_stuff {
<script type="text/javascript">
    function acs_CheckAll(elementName, checkP) {
	var Obj, Type, Name, Id;
	var Controls = acs_ListFindInput(); if (!Controls) { return; }
	// Regexp to find name of controls
	var re = new RegExp('^' + elementName + '.+');

	checkP = checkP ? true : false;

	for (var i = 0; i < Controls.length; i++) {
						   Obj = Controls[i];
						   Type = Obj.type ? Obj.type : false;
						   Name = Obj.name ? Obj.name : false;
						   Id = Obj.id ? Obj.id : false;

						   if (!Type || !Name || !Id) { continue; }

						   if (Type == "checkbox" && re.exec(Id)) {
						       Obj.checked = checkP;
						   }
					       }
    }

</script>
}

set page_title [_ assessment.Delete_Attempts]
set context [list $page_title]
ad_return_template