ad_page_contract {

    This page allows the admin to administer a single assessment.

    @param  assessment_id integer specifying assessment

    @author timo@timohentschel.de
    @date   September 28, 2004
    @cvs-id $Id: 
} {
    assessment_id:integer
}

ad_require_permission $assessment_id admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

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
    -url [ad_conn url]?assessment_id=$assessment_id \
]

db_multirow sections assessment_sections {} {
    if {![empty_string_p $max_time_to_complete]} {
	set max_min [expr $max_time_to_complete / 60]
	set max_sec [expr $max_time_to_complete - ($max_min * 60)]
	set max_time_to_complete "$max_min\:$max_sec min"
    }
}

ad_return_template
