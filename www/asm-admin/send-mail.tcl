ad_page_contract {

    this page offers options for sending email regarding
    an assessment to various groups

    @param assessment_id
    
    @author dave@thedesignexperience.org
    @date   July 29, 2002
    @cvs-id $Id:
} {
  assessment_id:integer,notnull
  {to "responded"}  
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set sender_id [ad_conn user_id]

permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set page_title "[_ assessment.Send_Mail]"
set assessment_name $assessment_data(title)
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]

db_1row select_sender_info {}
set dotlrn_installed_p [apm_package_installed_p dotlrn]

if {$dotlrn_installed_p} {
    set rel_type "dotlrn_member_rel"
    set community_id [dotlrn_community::get_community_id]
    set segment_id [db_string select_rel_segment_id {}]
    set community_name [dotlrn_community::get_community_name $community_id]
    set community_url "[ad_parameter -package_id [ad_acs_kernel_id] SystemURL][dotlrn_community::get_community_url $community_id]"

    set n_responses [db_string n_responses {}]
    if {$n_responses > 0} {
	ad_form -name send-mail -form {
	    {to:text(radio) {options {
		{"[_ assessment.lt_Everyone_eligible_to_]" "all"}
		{"[_ assessment.lt_Everyone_who_has_alre]" "responded"}
		{"[_ assessment.lt_Everyone_who_has_not_]" "not_responded"}}}
		{label "[_ assessment.Send_mail_to]"}
		{value $to}
	    }
	}
    } else {
	ad_form -name send-mail -form {
	    {to:text(radio) {options {
		{"[_ assessment.lt_Everyone_eligible_to_]" "all"}
		{"[_ assessment.lt_Everyone_who_has_not_]" "not_responded"}}}
		{label "[_ assessment.Send_mail_to]"}
		{value $to}
	    }
	}
    }
} else {
    ad_form -name send-mail -form {
	{to:text(radio) {options {
	    {"[_ assessment.lt_Everyone_who_has_alre]" "responded"}}}
            {label "[_ assessment.Send_mail_to]"}
            {value ""}
	}
    }
}

ad_form -extend -name send-mail -form {
    {subject:text(text) {value $assessment_name} {label "[_ assessment.Message_Subject]"} {html {size 50}}}
    {message:text(textarea) {label "[_ assessment.Enter_Message]"} {html {rows 15 cols 60}}}
    {assessment_id:text(hidden) {value $assessment_id}}
} -on_submit {
    set query ""

    if {$dotlrn_installed_p} {
        switch $to {
	    all {
                set query [db_map dotlrn_all]
            }
	    
	    responded {
		set query [db_map dotlrn_responded]
            }
            
	    not_responded {
		set query [db_map dotlrn_not_responded]
	    }
        }
    } else {
	set query [db_map responded]
    }
    
    bulk_mail::new \
        -package_id $package_id \
        -from_addr $sender_email \
        -subject $subject \
        -message $message \
        -query $query

    ad_returnredirect [export_vars -base one-a {assessment_id}]
    ad_script_abort
}

ad_return_template
