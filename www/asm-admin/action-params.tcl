ad_page_contract {
    
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation-date 2005-01-07
    
    This page allows to add branches or actions to the question and its choices.    
} {
    assessment_id:naturalnum,notnull
    inter_item_check_id:naturalnum,notnull
    section_id:naturalnum,notnull
    action_id:naturalnum,notnull
    check_id:naturalnum,optional
    edit_check:optional
    item_id:naturalnum,optional
    by_item_p:boolean,optional
} -properties {
    context:onevalue
    title:onevalue
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
permission::require_permission -object_id $package_id -privilege create

permission::require_permission -object_id $assessment_id -privilege admin

as::assessment::data -assessment_id $assessment_id
if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set return_url "one-a?assessment_id=$assessment_id"
set title $assessment_data(title)
set context [list [list index [_ assessment.admin]] [list "one-a?assessment_id=$assessment_id" $title] "[_ assessment.action_params]" ]

set new_assessment_revision $assessment_data(assessment_rev_id)

if {[info exists by_item_p] && $by_item_p ne ""} {
    set return_url "checks-admin?assessment_id=$assessment_id&section_id=$section_id"
    
    if {$by_item_p == 1} {
	append return_url "&by_item_p=$by_item_p&item_id=$item_id"
    } else {
	append return_url "&by_item_p=$by_item_p"
    }
}


set has_params_p [db_string has_params {} -default 0]

if {$has_params_p == 0} {
    ad_returnredirect "one-a?assessment_id=$assessment_id"
    ad_script_abort
}

set action_perform [db_string get_perform {} -default " "]
set title "[_ assessment.action_params]"

ad_form -name get_params -export { assessment_id section_id action_perform by_item_p item_id} -form {
    
    check_id:key
    {inter_item_check_id:text(hidden)
	{value $inter_item_check_id}}
	
    {action_id:text(hidden)
	{value $action_id}}
    
} 
db_foreach get_params {} {
    set choices [list]
    if { $type eq "n" } {
	if { $action_perform eq "aa" || $action_perform eq "m" || $action_perform eq "or" || $action_perform eq "sa"} {
	    set choices [db_list_of_lists choices {}]
	} else {
	    set choices [db_list_of_lists prev_choices {}]
	}
    } else {
	set choices [db_list_of_lists choices_param $query]
    }   
    set parameter [list [list param_$parameter_id:text(select),optional [list label $varname] [list html [list style "width:200px"]] [list options $choices] [list help_text $description]]]
    ad_form -extend -name get_params  -form $parameter
}

ad_form -extend -name get_params -new_data {
    db_foreach get_params {} {
	
	if { $type eq "n"} {
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
	set param_$parameter_id [as::assessment::check::get_parameter_value \
                                     -parameter_id $parameter_id \
                                     -type $type \
                                     -check_id $inter_item_check_id]
	if { [set param_$parameter_id] eq ""} {
	    set param_$parameter_id [lindex $choices 0 1]
	}
	
    }
} -edit_data {
    db_foreach get_params {} {
	as::assessment::check::set_parameter_value \
            -parameter_id $parameter_id \
            -type $type \
            -check_id $inter_item_check_id \
            -value [set param_$parameter_id]
    }
    
} -on_submit {
    ad_returnredirect $return_url
    ad_script_abort
}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
