ad_page_contract {
     
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @date 2005-01-07
    
    This page allows to relate an action to the check.    
} {
    assessment_id:integer
    inter_item_check_id:integer
    section_id:integer
    check_id:optional
    edit_check:optional
}

as::assessment::data -assessment_id $assessment_id
if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}
set edit_p [ db_string exist_check {}]

set title $assessment_data(title)
set context_bar [ad_context_bar [list "one-a?assessment_id=$assessment_id" $title] [ list "add-edit-check?assessment_id=$assessment_id&section_id=$section_id" "$title Triggers"] [_ assessment.action_select]]

set title "[_ assessment.action_select]" 
set options [list [list "[_ assessment.immediately]" "i"] [list "[_ assessment.at_the_end]" "aa"] [list "[_ assessment.manually]" "m"]]
set actions_list [db_list_of_lists get_actions {} ]
set return_url ""

if {[info exists edit_check]} {
    set return_url "&check_id=$check_id&edit_check=t"
  
} 
ad_form -name get_action -export {edit_p action_perform_value action_value return_url} -form {
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
	{html {cols 50} {rows 15}}
	{help_text "[_ assessment.message_to_display_to]"}
	{$user_message}
    }
    
} -new_data {
    set order [as::assessment::check::get_max_order -section_id $section_id -action_perform $action_perform]
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
		    ns_log notice "----------------------- no es igual $perform $action_perform"
		#re-order the other group
		as::assessment::check::re_order_actions -check_id $inter_item_check_id -section_id $section_id -action_perform $perform
		set order [as::assessment::check::get_max_order -section_id $section_id -action_perform $action_perform]
		db_dml edit_action_order_by {}
	    }
	} else {
	    set order [as::assessment::check::get_max_order -section_id $section_id -action_perform $action_perform]
	    db_dml select_action {}
	}
    } 
    
    
} -on_submit {
    ns_log notice "----------------------- $action_perform"
    set url "action-params?assessment_id=$assessment_id&inter_item_check_id=$inter_item_check_id&action_id=$action_id&section_id=$section_id"
    ad_returnredirect "${url}$return_url"
}