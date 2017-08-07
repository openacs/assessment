ad_page_contract {
    Instructions, launch page for one assessment

    This lets a user see what an assessment is all about before 
    creating a session
    @author Dave Bauer (dave@solutiongrove.com)
    @creation-date 2007-02-15
} {
    assessment_id:naturalnum,notnull
}

set user_id [ad_conn user_id]
permission::require_permission \
    -object_id $assessment_id \
    -party_id $user_id \
    -privilege read

as::assessment::data -assessment_id $assessment_id
if { $assessment_data(publish_status) ne "live" } {
    ad_return_complaint 1 [_ assessment.Requested_assess_is_no_longer_available]
    return
}

if {$assessment_data(instructions) eq ""} {
    set assessment_data(instructions) "[_ assessment.lt_default_instructions]"
}

if {$assessment_data(entry_page) eq ""} {
    set assessment_data(entry_page) "[_ assessment.lt_default_entry_page]"
}

set assessment_data(url) [export_vars -base assessment {assessment_id}]

set unfinished_session_id [as::session::unfinished_session_id \
			     -subject_id $user_id \
			     -assessment_id $assessment_id]

set completed_session_count [db_string count_completed_sessions ""]
set total_pages [db_string get_section_count "select count(*) from as_assessment_section_map, cr_items where latest_revision = assessment_id and item_id=:assessment_id"]
set page_title $assessment_data(title)
set context [list $page_title]

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
