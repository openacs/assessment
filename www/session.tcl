ad_page_contract {

    Show the result of a session.

    @author timo@timohentschel.de
    @date   2004-12-24
    @cvs-id $Id: 
} {
    session_id:integer
}

set context [list "[_ assessment.View_Results]"]

db_1row find_assessment {}

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set assessment_rev_id $assessment_data(assessment_rev_id)
set session_user_url [acs_community_member_url -user_id $subject_id]

# get start and end times
db_1row session_data {}

# get the number of attempts
set session_attempt [db_string session_attempt {}]

if {[empty_string_p $assessment_data(show_feedback)]} {
    set assessment_data(show_feedback) "all"
}
    set assessment_data(show_feedback) "all"

# show_feedback: none, all, incorrect, correct


db_multirow sections sections {} {
    if {[empty_string_p $points]} {
	set points 0
    }
    set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]
}

# todo: calculate result
set session_score 0
set assessment_score 0

ad_return_template
