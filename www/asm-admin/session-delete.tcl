ad_page_contract {
    Delete a users sessions for a particular assessment
} {
    assessment_id:naturalnum,notnull
    subject_id:naturalnum,notnull
    orig_session_id:naturalnum,optional
    {return_url:localurl ""}
} 

permission::require_permission \
    -party_id [ad_conn user_id] \
    -object_id $assessment_id \
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
ad_form -name session-delete -export {assessment_id subject_id return_url orig_session_id} \
    -has_submit 1 \
    -form {
        {cancel0:text(submit) {label "[_ acs-kernel.common_Cancel]"}}
        {ok0:text(submit) {label "[_ acs-kernel.common_Delete]"}}
	{check_all:text(checkbox),optional {label ""} {options $check_all_options}}
        {session_ids_to_delete:text(checkbox),multiple,optional {label "[_ assessment.Attempts_to_delete]"} {options $session_id_options}}
        {cancel:text(submit) {label "[_ acs-kernel.common_Cancel]"}}
        {ok:text(submit) {label "[_ acs-kernel.common_Delete]"}}
        
    } -on_request {
	if {[info exists orig_session_id]} {
	    template::element::set_values session-delete session_ids_to_delete $orig_session_id
	}
        template::add_event_listener -id "session-delete:elements:check_all:" -script {
            acs_CheckAll('session-delete:elements:session_id',this.checked);
        }
    } -on_submit {
        if {([info exists ok] && $ok ne "" || [info exists ok0] && $ok0 ne "" )
            && [info exists session_ids_to_delete]
        } {
            #delete sessions
            set message "[_ assessment.Requested_attempts_deleted]"
            foreach id $session_ids_to_delete {
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

template::head::add_javascript -script {
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
}

set page_title [_ assessment.Delete_Attempts]
set context [list $page_title]
ad_return_template
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
