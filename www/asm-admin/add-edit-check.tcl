ad_page_contract {
        
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @date 2005-01-07
    This page allows to add branches or actions to the question and its choices.    

} {
    assessment_id:naturalnum,notnull
    as_item_id:naturalnum,optional
    section_id:naturalnum,optional
    inter_item_check_id:naturalnum,optional
    edit_check:optional
    type:optional
    by_item_p:boolean,optional
    item_id:naturalnum,optional
} -properties {
    context:onevalue
    title:onevalue
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create

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
set context [list [list index [_ assessment.admin]] [list "one-a?assessment_id=$assessment_id" $title] "$title Triggers"]

if {(![info exists as_item_id] || $as_item_id eq "") } {
    set condition_sql [db_string get_item_id {}] 
    #parse condition_sql to get item_id
    set cond_list  [split $condition_sql "="]
    set item_id [lindex [split [lindex $cond_list 2] ")"] 0]
    set item_id [content::item::get_latest_revision -item_id $item_id]


} else {
    set item_id $as_item_id
}

if {([info exists section_id] && $section_id ne "")} {
    set section_id_from $section_id
}


set as_item_id $item_id

set as_item_type_id [db_string item_type_id {}]
set choices [db_list_of_lists get_choices {} ] 
set question_text [db_string get_question {}]

if {([info exists edit_check] && $edit_check ne "")} {
    if { (![info exists type] || $type eq "")} {
    set return_url "&check_id=$inter_item_check_id&edit_check=t"
    } 
    
}
if {([info exists by_item_p] && $by_item_p ne "")} {
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
	{help_text "[_ assessment.help_postcheck_p]"}
    }
    {description:text(textarea)
	{label "[_ assessment.action_description]"}
	{html {cols 40 rows 20}}
	{help_text "[_ assessment.description_trigger]"}
    }
    {condition:text(radio)
	{label "[_ assessment.condition]"}
	{options $choices}
	{after_html $question_text}
	{help_text "[_ assessment.the_condition_to]"}
    }

}

if {(![info exists inter_item_check_id] || $inter_item_check_id eq "")} {
    ad_form -extend -name new_check -form {
	{action_p:boolean(radio)
	    {label "[_ assessment.parameter_type]"}
	    {options [as::assessment::check::get_types]}
	    {help_text "[_ assessment.type_of_trigger]"}
	}
    } 
} else {
    ad_form -extend -name new_check -form {
	{action_p:text(hidden)}
    }
}

ad_form -extend -name new_check  -new_data {
    set user_id [ad_conn user_id]
    set check_sql [as::assessment::check::get_sql -condition $condition -item_id $item_id]
    #   set check_sql "check_sql"
    db_transaction {
	set date [db_string get_date {select sysdate from dual}]
	db_exec_plsql new_check {}
    } 
    
} -edit_request {
    db_1row get_check_properties {}
    set condition_sql $check_sql
    #parse condition_sql to get choice_id
    set cond_list  [split $condition_sql "="]
    set condition [lindex [split [lindex $cond_list 1] ")"] 0]
    #ad_return_complaint 1 "${condition} $choices"
    
} -edit_data {
    set check_sql [as::assessment::check::get_sql -condition $condition -item_id $item_id]
    db_dml update_check {}
} -after_submit {
    
    
    set url [as::assessment::check::add_check_return_url $action_p]
    ad_returnredirect "${url}?assessment_id=$assessment_id&inter_item_check_id=$inter_item_check_id&section_id=$section_id_from$return_url"

}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
