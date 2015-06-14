# oacs-5-2/packages/assessment/www/asm-admin/add-edit-section-check.tcl

ad_page_contract {
    
    adds or edits checks bound to sections
    
    @author Deds Castillo (deds@i-manila.com.ph)
    @creation-date 2005-07-26
    @arch-tag: 29e2145c-7bcc-4a3d-b2e7-b43a2e305f7c
    @cvs-id $Id$
} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,optional
    inter_item_check_id:naturalnum,optional
    edit_check:optional
    by_item_p:boolean,optional
} -properties {
} -validate {
} -errors {
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create

permission::require_permission -object_id $assessment_id -privilege admin
set item_id ""
set return_url ""
as::assessment::data -assessment_id $assessment_id
set assessment_rev_id $assessment_data(assessment_rev_id)
if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set title $assessment_data(title)
set context [list [list index [_ assessment.admin]] [list "one-a?assessment_id=$assessment_id" $title] "$title Triggers"]

set section_id_from $section_id

set as_item_id $item_id

if {([info exists edit_check] && $edit_check ne "")} {
    set return_url "&check_id=$inter_item_check_id&edit_check=t"
}
if {([info exists by_item_p] && $by_item_p ne "")} {
    if {$by_item_p==1} {
	    append return_url "&item_id=$item_id&by_item_p=$by_item_p"
	} else  {
	    append return_url "&by_item_p=$by_item_p"
	}
}

ad_form \
    -name new_check \
    -export { assessment_id section_id return_url } \
    -form {
        inter_item_check_id:key
        {section_id_from:integer(hidden)
            {value $section_id_from}
        } 
        {name:text(text) 
            {label "[_ assessment.Name]"} 
            {help_text "[_ assessment.name_of_trigger]"}
        }
        {postcheck_p:boolean(radio)
            {label "[_ assessment.post_check]"}
            {options { {"[_ assessment.yes]" t} {"[_ assessment.no]" f}}}
            {help_text "[_ assessment.help_postcheck_p]"}
        }
        {description:text(textarea)
            {label "[_ assessment.action_description]"}
            {html {cols 40 rows 20}}
            {help_text "[_ assessment.description_trigger]"}
        }
        {action_p:text(hidden)
            {value "t"}
        }
    } \
    -new_data {
        set user_id [ad_conn user_id]
        set check_sql "select 1 as perform_p from dual"
        db_transaction {
            set date [db_string get_date {select sysdate from dual}]
            db_exec_plsql new_check {}
        } 
    } -edit_request {
        db_1row get_check_properties {}
    } -edit_data {
        set check_sql "select 1 as perform_p from dual"
        db_dml update_check {}
    } -after_submit {
        set url [as::assessment::check::add_check_return_url $action_p]
        ad_returnredirect "${url}?assessment_id=$assessment_id&inter_item_check_id=$inter_item_check_id&section_id=$section_id_from&section_check_p=1$return_url"
}
