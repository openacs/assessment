ad_page_contract {

    Show the result of a session and provide links to edit the points.

    @author timo@timohentschel.de
    @date   2005-02-16
    @cvs-id $Id: 
} {
    session_id:naturalnum,notnull
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
template::head::add_css -href "/resources/assessment/assessment.css"
set format "[lc_get d_fmt], [lc_get t_fmt]"
set session_user_url [acs_community_member_url -user_id $subject_id]

# get start and end times
db_1row session_data {}

set session_time [as::assessment::pretty_time -seconds $session_time -hours]
set session_start [lc_time_fmt $creation_datetime $format]
set session_finish [lc_time_fmt $completed_datetime $format]

# get the number of attempts
set session_attempt [db_string session_attempt {}]

set show_username_p 1
# only admins are allowed to see responses of other users
if {$assessment_data(anonymous_p) == "t" && $subject_id != $user_id} {
    set show_username_p 0
}

if {$assessment_data(show_feedback) eq ""} {
    set assessment_data(show_feedback) "all"
}

# show_feedback: none, all, incorrect, correct


set session_score 0
set assessment_score 0
db_multirow sections sections {} {
    if {$session_finish ne ""} {
        set session_score [db_string get_session_score {} -default ""]
        set assessment_score [db_string get_max_points {} -default ""]
        #set max_time_to_complete [as::assessment::pretty_time -seconds $assessment_data(max_time_to_complete)]
        set max_time_to_complete ""
        if {$session_score ne "" && $assessment_score ne "" && $assessment_score > 0} {
            set percent_score "[format "%3.2f" [expr {$session_score / ($assessment_score + 0.0) * 100}]]"
        } else {
            set percent_score ""
        }
        set showpoints [parameter::get -parameter "ShowPoints" -default 1 ]
    } else {
        set percent_score ""
        set showpoints 0
    }

}

set showpoints [parameter::get -parameter "ShowPoints" -default 1 ]

set comments_installed_p [apm_package_enabled_p "general-comments"]
set delete_url [export_vars -base session-delete {assessment_id subject_id {orig_session_id $session_id} {return_url [ad_return_url]}}]
ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
