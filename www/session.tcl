 ad_page_contract {

     Show the result of a session.

     @author timo@timohentschel.de
     @date   2004-12-24
     @cvs-id $Id: 
 } {
    {session_id:naturalnum,notnull 0}
    {assessment_id:naturalnum,notnull 0}
    {next_url ""}
 } -properties {
     context:onevalue
     page_title:onevalue
 }

set user_id [ad_conn user_id]

if {$session_id == 0} {
    # require assessment_id if session_id is blank
    if {$assessment_id == 0} {
	ad_return_complaint 1 "Session_id or Assessment_id is required"
    }
    #find the latest session
    if {![db_0or1row get_latest_session "" -column_array latest_session]} {
	ad_return_complaint 1 "You have not completed this assessment yet."
    }
    set session_id $latest_session(session_id)
}

db_1row find_assessment {}

permission::require_permission -object_id $assessment_id -privilege read

if {$subject_id != $user_id} {
    permission::require_permission -object_id $assessment_id -privilege admin
}

set page_title "[_ assessment.View_Results]"
set context [list [list [export_vars -base sessions {assessment_id}] "[_ assessment.Show_Sessions]"] $page_title]

template::head::add_css -href "/resources/assessment/assessment.css"

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
