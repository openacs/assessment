# packages/assessment/www/feedback.tcl

ad_page_contract {
    
    Check feedback
    
    @author Roel Canicula (roel@solutiongrove.com)
    @creation-date 2006-05-29
    @arch-tag: 36842c7c-99fa-4d71-904c-814bc3fde60c
    @cvs-id $Id$
} {
    assessment_id:naturalnum,notnull
    session_id:naturalnum,notnull
    section_id:naturalnum,notnull
    {return_p:boolean 0}
    section_order:optional
    item_order:optional
    password:optional
    return_url:localurl,optional
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

if { $next_url eq "" } {
    if { $return_p && ([info exists return_url] && $return_url ne "") } {
	set next_url $return_url
	
    } else {
	set next_url [export_vars -base assessment {assessment_id session_id section_order item_order password return_url next_asm section_id}]
    }
}

ad_form -name next -export {next_url assessment_id section_id session_id} -form {
    {next_button:text(submit) {label "[_ assessment.Next]"}}
} -on_submit {
    ad_returnredirect $next_url
}

set subject_id [ad_conn user_id]
as::assessment::data -assessment_id $assessment_id
permission::require_permission -object_id $assessment_id -privilege read
set page_title "[_ assessment.Show_Items]"
set context [list $page_title]


set section_title [db_string section_title "select title from cr_revisions where revision_id=:section_id"]

if {[info exists assessment_id]} {
    # check if this assessment even allows feedback if not, bail out

    if {$assessment_data(show_feedback) eq "none"} {
	ad_returnredirect $next_url
	ad_script_abort
    }
}

# we already finished the page, we are just looking at the feedback
# so we are at the next page
if {[info exists current_page]} {
    set finished_page $current_page
}

template::head::add_css -href "/resources/assessment/assessment.css"

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
