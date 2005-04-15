ad_page_contract {

    Show the result of a session and provide links to edit the points.

    @author timo@timohentschel.de
    @date   2005-02-16
    @cvs-id $Id: 
} {
    session_id:integer
} -properties {
    context:onevalue
    page_title:onevalue
}

db_1row find_assessment {}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set user_id [ad_conn user_id]
if {$subject_id != $user_id} {
    permission::require_permission -object_id $assessment_id -privilege admin
}

set page_title "[_ assessment.View_Results]"
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] [list [export_vars -base results-users {assessment_id}] [_ assessment.Results_by_user]] $page_title]
set format "[lc_get formbuilder_date_format], [lc_get formbuilder_time_format]"
set session_user_url [acs_community_member_url -user_id $subject_id]

# get start and end times
db_1row session_data {}
set session_time [as::assessment::pretty_time -seconds $session_time -hours]

# get the number of attempts
set session_attempt [db_string session_attempt {}]

set show_username_p 1
# only admins are allowed to see responses of other users
if {$assessment_data(anonymous_p) == "t" && $subject_id != $user_id} {
    set show_username_p 0
}

if {[empty_string_p $assessment_data(show_feedback)]} {
    set assessment_data(show_feedback) "all"
}

# show_feedback: none, all, incorrect, correct


set session_score 0
set assessment_score 0
db_multirow sections sections {} {
    if {[empty_string_p $points]} {
	set points 0
    }
    if {[empty_string_p $max_points]} {
	set max_points 0
    }
    set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]
    incr session_score $points
    incr assessment_score $max_points
}

ad_return_template
