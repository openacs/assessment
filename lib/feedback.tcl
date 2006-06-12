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
} -properties {
} -validate {
} -errors {
}

set subject_id [ad_conn user_id]
as::assessment::data -assessment_id $assessment_id
permission::require_permission -object_id $assessment_id -privilege read
set page_title "[_ assessment.Show_Items]"
set context [list $page_title]

if { $return_p && [exists_and_not_null return_url] } {
    set next_url $return_url
} else {
    set next_url [export_vars -base assessment {assessment_id session_id section_order item_order password return_url next_asm section_id}]
}
