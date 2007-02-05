# packages/assessment/www/feedback.tcl

ad_page_contract {
    
    Check feedback
    
    @author Roel Canicula (roel@solutiongrove.com)
    @creation-date 2006-05-29
    @arch-tag: 36842c7c-99fa-4d71-904c-814bc3fde60c
    @cvs-id $Id$
} {
    assessment_id
    session_id
    section_id
    {return_p 0}
    section_order:optional
    item_order:optional
    password:optional
    return_url:optional
    next_asm:optional
    {item_id_list:multiple,optional {}}
    {next_url ""}
    no_complaint:optional
    total_pages:optional
    current_page:optional
} -properties {
} -validate {
} -errors {
}
#if {![info exists no_complain]} {
#    ad_return_complaint 1 "feedback! [ns_conn query]"
#}
set subject_id [ad_conn user_id]
as::assessment::data -assessment_id $assessment_id
permission::require_permission -object_id $assessment_id -privilege read
set page_title "[_ assessment.Show_Items]"
set context [list $page_title]
ns_log notice "feedback.tcl '${next_url}' '${return_url}'"

set section_title [db_string section_title "select title from cr_revisions where revision_id=:section_id"]

if { $next_url eq "" } {
    if { $return_p && [exists_and_not_null return_url] } {
	set next_url $return_url
	
    } else {
	set next_url [export_vars -base assessment {assessment_id session_id section_order item_order password return_url next_asm section_id}]
    }
}

if {[info exists assessment_id]} {
    # check if this assessment even allows feedback if not, bail out

    if {$assessment_data(show_feedback) eq "none"} {
	ad_returnredirect $next_url
	ad_script_abort
    }
}
