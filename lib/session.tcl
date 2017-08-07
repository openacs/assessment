ad_page_contract {

    Show the result of a session.

    @author timo@timohentschel.de
    @date   2004-12-24
    @cvs-id $Id: 
}

set user_id [ad_conn user_id]

db_1row find_assessment {}

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set admin_p [permission::permission_p \
                 -object_id $session_id \
                 -privilege admin \
                 -party_id $user_id]

set delete_url [export_vars -base asm-admin/session-delete {assessment_id subject_id {orig_session_id $session_id} {return_url [ad_return_url]}}]

set page_title "[_ assessment.View_Results]"
set context_bar [ad_context_bar [list [export_vars -base sessions {assessment_id}] "[_ assessment.Show_Sessions]"] $page_title]
set format "[lc_get formbuilder_date_format], [lc_get formbuilder_time_format]"
set session_user_url [acs_community_member_url -user_id $subject_id]

# get start and end times
db_1row session_data {}
set session_time [as::assessment::pretty_time_hours_minutes -seconds $session_time]

# get the number of attempts

db_multirow session_attempts session_attempts {}
set show_username_p 1
# only admins are allowed to see responses of other users
if {$assessment_data(anonymous_p) == "t" && $subject_id != $user_id} {
    set show_username_p 0
}

if {$assessment_data(show_feedback) eq ""} {
    set assessment_data(show_feedback) "all"
}

# show_feedback: none, all, incorrect, correct

db_multirow sections sections {}
if {$session_finish ne ""} {
    set session_score [db_string get_session_score "select sum(coalesce(points,0)) from as_item_data where session_id=:session_id" -default ""]
    set assessment_score [db_string get_max_points "select sum(coalesce(i.points,0)) from as_items i, as_item_data d where d.session_id = :session_id and i.as_item_id = d.as_item_id" -default ""]
    #set max_time_to_complete [as::assessment::pretty_time -seconds $assessment_data(max_time_to_complete)]
    set max_time_to_complete ""
    if {$session_score ne "" && $assessment_score ne "" && $assessment_score > 0} {
	set percent_score "[format "%3.2f" [expr {$session_score / ($assessment_score + 0.0) * 100}]]%"
    } else {
	set percent_score ""
    } 
    set showpoints [parameter::get -parameter "ShowPoints" -default 1 ]
} else {
    set percent_score ""
    set showpoints 0
}

set comments_installed_p [apm_package_enabled_p "general-comments"]
ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
