ad_page_contract {
     
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation-date 2005-01-07
    
    This page allows to relate an action to the check.    
} {
    assessment_id:naturalnum,notnull
    inter_item_check_id:naturalnum,notnull
    section_id:naturalnum,notnull
    check_id:naturalnum,optional
    edit_check:optional
    by_item_p:boolean,optional
    item_id:naturalnum,optional
    {section_check_p:boolean 0}
} -properties {
    context:onevalue
    title:onevalue
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create

permission::require_permission -object_id $assessment_id -privilege admin
as::assessment::data -assessment_id $assessment_id
set assessment_rev_id $assessment_data(assessment_rev_id)

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}
set edit_p [ db_string exist_check {}]

set title $assessment_data(title)
set context [list [list index [_ assessment.admin]] [list "one-a?assessment_id=$assessment_id" $title] [_ assessment.action_select]]

set title "[_ assessment.action_select]" 
if {$section_check_p} {
    set options [list [list "On Request" "or"] [list "[_ assessment.at_the_end]" "sa"]]
} else {
    set options [list [list "[_ assessment.immediately]" "i"] [list "[_ assessment.at_the_end]" "aa"] [list "[_ assessment.manually]" "m"]]
}
set actions_list [db_list_of_lists get_actions {} ]
set return_url ""

if {[info exists edit_check]} {
    set return_url "&check_id=$check_id&edit_check=t"
  
}
if {[info exists by_item_p]} {
    if { $by_item_p == 1} {
	append return_url "&by_item_p=$by_item_p&item_id=$item_id"
    } else {
	append return_url "&by_item_p=$by_item_p"
    }
}

 
ad_form -name get_action -export {edit_p action_perform_value action_value return_url by_item_p item_id} -form {
    check_id:key
    {inter_item_check_id:text(hidden)
	{value $inter_item_check_id}}
    
    {assessment_id:text(hidden)
	{value $assessment_id}}
    {section_id:text(hidden)
	{value $section_id}}
    {action_id:text(select)
	{label "[_ assessment.choose_action]"}
	{options $actions_list}
	{help_text "[_ assessment.action_that_will]"}
	{$action_value}
    }
    {action_perform:text(select)
	{label "[_ assessment.when_this_will]"}
	{options $options}
	{help_text "[_ assessment.when_this_action]"}
	{$action_perform_value}
    }
    {user_message:text(textarea),optional
	{label "[_ assessment.message]"}
	{html {cols 50 rows 15}}
	{help_text "[_ assessment.message_to_display_to]"}
	{$user_message}
    }
    
} -new_data {
    set order_value [as::assessment::check::get_max_order -section_id $section_id -action_perform $action_perform]
    db_dml select_action {}
    
} -edit_request {
    db_0or1row get_values {}
} -edit_data {
    if {$edit_p > 0} {
	set action_p [ db_string get_action_p {}]
	if {$action_p == "t"} {
	    set perform [db_string action_perform {}]
	    if { $perform==$action_perform} {
		db_dml edit_action {}
		
	    } else {
		
		#re-order the other group
		as::assessment::check::re_order_actions -check_id $inter_item_check_id -section_id $section_id -action_perform $perform
		set order_value [as::assessment::check::get_max_order -section_id $section_id -action_perform $action_perform]
		db_dml edit_action_order_by {}
	    }
	} else {
	    db_dml delete_action_map {}
	    db_dml delete_param_map {}
	    
	    set order_value [as::assessment::check::get_max_order -section_id $section_id -action_perform $action_perform]
	    db_dml select_action {}
	}
    } 
    
    
} -on_submit {
    set url [export_vars -base action-params {assessment_id inter_item_check_id action_id section_id}]
    ad_returnredirect "${url}$return_url"
    ad_script_abort
    
} -after_submit {
    if {  $action_perform eq "m" } {
	as::assessment::check::add_manual_check -assessment_id $assessment_rev_id -inter_item_check_id  $inter_item_check_id
    }
    
}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
