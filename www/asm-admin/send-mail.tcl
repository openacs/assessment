# packages/assessment/www/asm-admin/send-mail-to.tcl

ad_page_contract {
    
    Choose who to send mail to
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2007-07-06
    @cvs-id $Id$

} -query {
    {assessment_id ""}
    {session_id:multiple ""}
    {return_url ""}
} -properties {
    context:onevalue
    page_title:onevalue
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission \
    -privilege "admin" \
    -party_id $user_id \
    -object_id $package_id

as::assessment::data -assessment_id $assessment_id
set page_title "[_ assessment.Send_Mail]"
set assessment_name $assessment_data(title)
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]


ad_form -name send-mail -has_submit 1 -form {
    {subject:text(text) {value $assessment_name} {label "[_ assessment.Message_Subject]"} {html {size 50}}}
    {message:text(textarea) {label "[_ assessment.Enter_Message]"} {html {rows 15 cols 60}}}
    {assessment_id:text(hidden) {value $assessment_id}}
    {formbutton_ok:text(submit) {label "[_ acs-templating.OK]"}}
}

if {[llength $session_id]} {
    if {[llength $session_id] == 1} {
	set session_id [split [lindex $session_id 0]]
    }
    set options [db_list_of_lists get_session_user_options "select u.last_name || ', ' || u.first_names,user_id  from acs_users_all u, as_sessions s where s.session_id in ([template::util::tcl_to_sql_list $session_id]) and u.user_id = s.subject_id"]
    ad_form -extend -name send-mail -form {
        {user_ids:text(checkbox) {label "[_ assessment.Send_mail_to_the_selected_users]"} {options $options}}
        {session_id:text(hidden) {value $session_id}}
    }
} else {
    set n_responses [db_string n_responses {}]

    if {$n_responses > 0} {
        ad_form -extend -name send-mail -form {
            {to:text(radio) {options {
                {"[_ assessment.lt_Everyone_eligible_to_]" "all"}
                {"[_ assessment.lt_Everyone_who_has_alre]" "responded"}
                {"[_ assessment.lt_Everyone_who_has_not_]" "not_responded"}}}
                {label "[_ assessment.Send_mail_to]"}
            }
        }
    } else {
        ad_form -extend -name send-mail -form {
            {to:text(radio) {options {
                {"[_ assessment.lt_Everyone_eligible_to_]" "all"}
                {"[_ assessment.lt_Everyone_who_has_not_]" "not_responded"}}}
                {label "[_ assessment.Send_mail_to]"}
                {value $to}
            }
        }
    }
}

ad_form -extend -name send-mail -on_request {
    if {[info exists options]} {
        set user_ids [list]
        foreach elm $options {
            lappend user_ids [lindex $elm 1]
        }
    }
} -on_submit {
    acs_user::get -user_id $user_id -array sender
    set sender_email $sender(email)
    set sender_first_names $sender(first_names)
    set sender_last_name $sender(last_name)
    set query ""

    if {[info exists to] && $to ne ""} {
        switch $to {
	    all {
                set query [db_map all]
            }
	    
	    responded {
		set query [db_map responded]
            }
            
	    not_responded {
		set query [db_map not_responded]
	    }
        }
    } elseif {[info exists user_ids] && [llength $user_ids]} {
        set query [db_map list_of_user_ids]
    } else {
	set query [db_map responded]
    }
 
    bulk_mail::new \
        -package_id $package_id \
        -from_addr $sender_email \
        -subject $subject \
        -message $message \
        -query $query

    if {$return_url eq ""} {
        set return_url [export_vars -base one-a {assessment_id}]
    }
    set redirect_message "[_ assessment.Mail_subject_sent]"
    ad_returnredirect -message $redirect_message $return_url
    ad_script_abort

    
}