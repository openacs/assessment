ad_page_contract {

    This page allows the admin to administer a single assessment.

    @param  assessment_id integer specifying assessment

    @author timo@timohentschel.de
    @date   September 28, 2004
    @cvs-id $Id: 
} {
    assessment_id:integer
}
set reg_p ""
set package_id [ad_conn package_id]


permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id
set value [parameter::get_from_package_key -parameter AsmForRegisterId -package_key "acs-subsite"]

if { [string eq $assessment_id $value] } {
    set reg_p "[_ assessment.reg_asm]"
}

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set assessment_rev_id $assessment_data(assessment_rev_id)

set creation_date [util_AnsiDatetoPrettyDate $assessment_data(creation_date)]
set creator_link [acs_community_member_url -user_id $assessment_data(creation_user)]
if {$assessment_data(number_tries) > 0} {
    set response_limit_toggle "[_ assessment.allow_multiple]"
} else {
    set response_limit_toggle "[_ assessment.allow_tries]"
}

# allow site-wide admins to enable/disable assessments directly from here
set target "[export_vars -base one-a {assessment_id}]"


set context_bar [ad_context_bar $assessment_data(title)]

set notification_chunk [notification::display::request_widget \
			    -type assessment_response_notif \
			    -object_id $assessment_id \
			    -pretty_name $assessment_data(title) \
			    -url [export_vars -base one-a {assessment_id}] ]

db_multirow sections assessment_sections {} {
    if {[empty_string_p $points]} {
	set points 0
    }
    set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]
}

ad_return_template
