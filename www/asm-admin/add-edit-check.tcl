ad_page_contract {
        
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @date 2005-01-07
    This page allows to add branches or actions to the question and its choices.    

} {
    assessment_id:integer
    as_item_id:integer,optional
    section_id:integer,optional
    inter_item_check_id:optional
    edit_check:optional
    type:optional
    by_item_p:optional
    item_id:optional
}

permission::require_permission -object_id $assessment_id -privilege admin
set item_id ""
set section_id_from ""
set return_url ""
as::assessment::data -assessment_id $assessment_id
set assessment_rev_id $assessment_data(assessment_rev_id)
if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set title $assessment_data(title)
set context_bar [ad_context_bar [list "one-a?assessment_id=$assessment_id" $title] "$title Triggers"]

if {![exists_and_not_null as_item_id] } {
    set condition_sql [db_string get_item_id {}] 
    #parse condition_sql to get item_id
    set cond_list  [split $condition_sql "="]
    set item_id [lindex [split [lindex $cond_list 2] " "] 0]
    
} else {
    set item_id $as_item_id
}

if {[exists_and_not_null section_id]} {
    set section_id_from $section_id
}

set as_item_id $item_id

set as_item_type_id [db_string item_type_id {}]
set choices [db_list_of_lists get_choices {} ] 
set question_text [db_string get_question {}]

if {[exists_and_not_null edit_check]} {
    if { ![exists_and_not_null type]} {
    set return_url "&check_id=$inter_item_check_id&edit_check=t"
    } 
    
}
if {[exists_and_not_null by_item_p]} {
    if {$by_item_p==1} {
	    append return_url "&item_id=$item_id&by_item_p=$by_item_p"
	} else  {
	    append return_url "&by_item_p=$by_item_p"
	}
}
ad_form -name new_check -export {assessment_id return_url} -form {
    
    inter_item_check_id:key
    
    {as_item_id:integer(hidden)
	{value $as_item_id}
	
    }
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
    }
    {description:text(textarea)
	{label "[_ assessment.action_description]"}
	{html {cols 40} {rows 20}}
	{help_text "[_ assessment.description_trigger]"}
    }
    {action_p:boolean(radio)
	{label "[_ assessment.parameter_type]"}
	{options [as::assessment::check::get_types]}
	{help_text "[_ assessment.type_of_trigger]"}
    }
    {condition:text(radio)
	{label "[_ assessment.condition]"}
	{options $choices}
	{after_html $question_text}
	{help_text "[_ assessment.the_condition_to]"}
    }
    
} -new_data {
    set user_id [ad_conn user_id]
    set check_sql [as::assessment::check::get_sql -condition $condition -item_id $item_id]
#   set check_sql "check_sql"
    db_transaction {
	set date [db_string get_date {select sysdate from dual}]
	db_exec_plsql new_check {}
    } 
    
} -edit_request {
    db_1row get_check_properties {}
    set condition_sql [db_string get_item_id {}] 
    #parse condition_sql to get choice_id
    set cond_list  [split $condition_sql "="]
    #set condition [string range [lindex $cond_list 1] 0 3]
    set condition [lindex [split [lindex $cond_list 1] " "] 0]

} -edit_data {
    set check_sql [as::assessment::check::get_sql -condition $condition -item_id $item_id]
    db_dml update_check {}
} -after_submit {
    
    
    set url [as::assessment::check::add_check_return_url $action_p]
    ad_returnredirect "${url}?assessment_id=$assessment_id&inter_item_check_id=$inter_item_check_id&section_id=$section_id_from$return_url"

}