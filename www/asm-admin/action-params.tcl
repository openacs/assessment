ad_page_contract {
    
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @date 2005-01-07
    
    This page allows to add branches or actions to the question and its choices.    
} {
    assessment_id:integer
    inter_item_check_id:integer
    section_id:integer
    action_id:integer
    check_id:optional
    edit_check:optional
}

permission::require_permission -object_id $assessment_id -privilege admin

as::assessment::data -assessment_id $assessment_id
if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}
set title $assessment_data(title)
set context_bar [ad_context_bar [list "one-a?assessment_id=$assessment_id" $title] "[_ assessment.action_params]" ]

set new_assessment_revision [db_string get_assessment_id {select max(revision_id) from cr_revisions where item_id=:assessment_id}]
	
set new_section_revision [db_string get_section_id {select max(revision_id) from cr_revisions where item_id=:section_id}]

set has_params_p [db_string has_params {} -default 0]

if {$has_params_p == 0} {
        ad_returnredirect "one-a?assessment_id=$assessment_id"
}

set action_perform [db_string get_perform {} -default " "]
set title "[_ assessment.action_params]"

ad_form -name get_params -export { assessment_id section_id action_perform} -form {
    
    check_id:key
    {inter_item_check_id:text(hidden)
	{value $inter_item_check_id}}
	
    {action_id:text(hidden)
	{value $action_id}}
    
} 
db_foreach get_params {} {
    set choices [list]
    if { $type == "n" } {
	if { $action_perform == "aa" || $action_perform == "m"} {
	    set choices [db_list_of_lists choices {}]
	} else {
	    set choices [db_list_of_lists prev_choices {}]
	}
    } else {
	set choices [db_list_of_lists choices_param $query]
    }    
    
    set parameter [list [list param_$parameter_id:text(select),optional [list label $varname] [list options $choices] ]]
    ad_form -extend -name get_params  -form $parameter
}

ad_form -extend -name get_params -new_data {
    db_foreach get_params {} {
	
	if { $type == "n"} {
	    set item_id [set param_$parameter_id]
	    db_dml param_values_n {}
	} else {
	    set value [set param_$parameter_id]
	    db_dml param_values_q {}
	}
	
    }
    
} -edit_request {
    
    set action_id $action_id
    db_foreach get_params {} {
	set param_$parameter_id [as::assessment::check::get_parameter_value -parameter_id $parameter_id -type $type -check_id $inter_item_check_id]
	if { [set param_$parameter_id] == ""} {
	    set param_$parameter_id [lindex [lindex $choices 0] 1]
	}
	
    }
} -edit_data {
    db_foreach get_params {} {
	as::assessment::check::set_parameter_value -parameter_id $parameter_id -type $type -check_id $inter_item_check_id -value [set param_$parameter_id]
    }
    
} -on_submit {
    ad_returnredirect "one-a?assessment_id=$assessment_id"
}

