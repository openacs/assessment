ad_library {
    Assessment Checks procs
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation-date 2005-01-13
}

namespace eval as::assessment::check {}

ad_proc -public as::assessment::check::get_types {
} {
    Return the checks types
} {
    set types [list [list "Action" "t"] [list "Branch" "f"]]
    return $types
}

ad_proc -public as::assessment::check::get_assessments {
} {
    
} {
    set package_id [ad_conn package_id]
    set assessment_list [list [list "All" "all"]]
    db_foreach  assessment {} {
	lappend assessment_list [list $title $assessment_id]
    }
    
    return $assessment_list
}

ad_proc -public as::assessment::check::state_options {
} {
    
} {
    set approved_options [list  {"Approved" "t"} {"Approved with errors" "ae"} {"Not Approved" "f"} ]
    return $approved_options
}

ad_proc -public as::assessment::check::intervals {
} {
    Return the time intervals
} {
    
    set today [db_string today {}]
    set yesterday  [db_string yesterday {}]
    set two_days [db_string two_days {}]
    set last_week [db_string last_week {}]
    set last_month [db_string last_month  {}]
    
    set intervals [list [list "All" "all"] [list "Today" $today]  [list "Yesterday" $yesterday] [list "Two days ago" $two_days] [list "Last Week" $last_week] [list "Last Month" $last_month]]
    
}

ad_proc -public as::assessment::check::add_check_return_url {
    {action_p}
} {
    Return the url
} {
    if { $action_p == "t"} {
	return  "action-select"
    } else {
        return "section-select"
    }
}

ad_proc -public as::assessment::check::get_max_order {
    {-action_perform}
    {-section_id}
} {
    Return the next value for order_by
} {
    set order [db_string get_max_order {}]
    if { $order == ""} {
	set order 1
    } else {
        incr order
    }
    return $order
}

ad_proc -public as::assessment::check::get_parameter_value {
    {-parameter_id}
    {-type}
    {-check_id}
} {
    Return the parameter_value
} {
    if { $type == "n"} {
	return  [db_string get_param_n {} -default " "]
    } else {
	return [db_string get_param_q {} -default " "]
	
    }
}


ad_proc -public as::assessment::check::set_parameter_value {
    {-parameter_id}
    {-value}
    {-check_id}
    {-type}
} {
    
} {
    set exists_p [db_string get_check_id {select inter_item_check_id from as_param_map where parameter_id=:parameter_id and inter_item_check_id = :check_id } -default 0]
    
    if { $type == "n"} {
	if {$exists_p != 0} {
	    db_dml param_value_update_n {}
	} else {
	    db_dml param_value_insert_n {}
	}
    } else {
	if { $exists_p != 0} {
	    db_dml param_value_update_q {}
	} else {
	    db_dml param_value_insert_q {}
	}
	
    }
    
}

ad_proc -public as::assessment::check::re_order_actions {
    {-check_id}
    {-action_perform}
    {-section_id}
} {
    
} {
    set order_by [db_string get_order_by {}]
    set count 0
    db_foreach next_order {} {
	set order [expr $order_by+$count]
	db_dml update_order {}
	incr count
    }
    
}

ad_proc -public as::assessment::check::get_sql {
    {-item_id}
    {-condition}
} {
    
} {
    set check_sql "select (case when idc.choice_id=$condition then \'1\' else \'0\' end) as perform_p from as_item_data id, as_item_data_choices idc where id.as_item_id=$item_id and id.item_data_id=idc.item_data_id and id.session_id=:session_id"
    
    return $check_sql
}


ad_proc -public as::assessment::check::swap_actions {
    {-check_id}
    {-action_perform}
    {-section_id}
    {-direction}
    {-order_by}
} {
    
} {
    if { $direction == "d"} {
	set order [expr $order_by + 1]
	set swap_check_id [db_string get_swap_check {}]
	db_dml update_1 {}
	db_dml update_2 {}
    } else {
	set order [expr $order_by - 1]
	set swap_check_id [db_string get_swap_check_e {}]
	db_dml update_1_e {}
	db_dml update_2_e {}
	
    }
    
}
ad_proc -public as::assessment::check::action_log {
    {-session_id}
    {-check_id}
    {-failed }
} {
    
} {
    
    db_transaction {
	set user_id [ad_conn user_id]
	set log_id [db_string get_next_val {}]
	set action_id [db_string action_id {}]
	db_dml insert_action {}
    }
}

ad_proc -public as::assessment::check::manual_action_log {
    {-session_id}
    {-check_id}
    
} {
    
} {

    db_transaction {
	set user_id [ad_conn user_id]
	set log_id [db_string get_next_val {}]
	set action_id [db_string action_id {}]
	db_dml insert_action {}
        ns_log notice "inserta en mannually"
    }
}


ad_proc -public as::assessment::check::action_exec {
    {-inter_item_check_id}
    {-session_id}
} { 
    
} {
    db_foreach get_check_params { } {
	set parameter_name [db_1row select_name {}]
	
	set $varname ""
	
	if {$value == ""} {
    	    set choice [db_0or1row get_item_choice {}]
	    set answer [db_0or1row get_answer {}] 
	    if {[exists_and_not_null choice_id]} {
		set $varname "$choice_id"
	    } else {
		append $varname $boolean_answer
		append $varname $numeric_answer
		append $varname $integer_answer
		append $varname $text_answer
		append $varname $clob_answer
		append $varname $content_answer
	    }
	} else {
	    set $varname $value
	}
	ns_log notice "--------------------------parameter $varname [set $varname]"

    }
    
    set tcl_code_p [db_1row select_tcl {}]
    set failed_p "t"
    set failed [catch $tcl_code]
    ns_log notice "--------------------------TCL $tcl_code"
    if { $failed > 0 } {
	set failed_p "f"
    }
    as::assessment::check::action_log -session_id $session_id -check_id $inter_item_check_id -failed $failed_p
}


ad_proc -public as::assessment::check::manual_action_exec {
    {-inter_item_check_id}
    {-session_id}
    {-action_log_id}
} { 
    
} {
    db_foreach get_check_params { } {
	set parameter_name [db_1row select_name {}]
	
	set $varname ""
	
	if {$value == ""} {
    	    set choice [db_0or1row get_item_choice {}]
	    set answer [db_0or1row get_answer {}] 
	    if {[exists_and_not_null choice_id]} {
		set $varname "$choice_id"
	    } else {
		append $varname $boolean_answer
		append $varname $numeric_answer
		append $varname $integer_answer
		append $varname $text_answer
		append $varname $clob_answer
		append $varname $content_answer
	    }
	} else {
	    set $varname $value
	}
	ns_log notice "--------------------------parameter $varname [set $varname]"

    }
    
    set tcl_code_p [db_1row select_tcl {}]
    set failed_p "t"
    set failed [catch $tcl_code]
    ns_log notice "--------------------------TCL $tcl_code"
    if { $failed > 0 } {
	set failed_p "f"
    }
    
    set user_id [ad_conn user_id]
    db_dml update_actions_log {}
    
}



ad_proc -public as::assessment::check::eval_i_checks {
    {-session_id}
    {-section_id}
} {
    
} {
    
    db_foreach section_checks {} {
	set perform [db_string check_sql $check_sql]
	if {$action_p == "t"} {
	    if {$perform == 1} {
		as::assessment::check::action_exec -inter_item_check_id $inter_item_check_id -session_id $session_id
	    }
	}
    }
}


ad_proc -public as::assessment::check::branch_checks {
    {-session_id}
    {-section_id}
    {-assessment_id}
    {-response}
    {-item_id_to:required}
} {
    
} {
    set order "f"
    set perform 0
    ns_log notice "-----------> entra a branch"
    db_foreach section_checks {} {
	set new_assessment_revision [db_string get_assessment_id {select max(revision_id) from cr_revisions where item_id=:assessment_id}]
	
	#parse condition_sql to get item_id
	set cond_list  [split $check_sql "="]
	set as_item_id [lindex [split [lindex $cond_list 2] " "] 0]


	#parse condition_sql to get choice_id
	set cond_list  [split $check_sql "="]
	set condition [lindex [split [lindex $cond_list 1] " "] 0]	

	ns_log notice "$condition  $response  $as_item_id  item_id $item_id_to"
	if { $condition == $response && $as_item_id == $item_id_to} {
	    set perform 1
	    ns_log notice "----------------> perform $perform rev $new_assessment_revision sec $section_id_to"
	}
	if {$perform == 1} {
	    set order [db_string get_order { }]
	}
	
    }
    ns_log notice "$order"    
    if {$order == "f"} {
	return $order
    } {
	return [expr $order -1]
    }
}




ad_proc -public as::assessment::check::eval_aa_checks {
    {-session_id}
    {-assessment_id}
} {
    
} {
    ns_log notice "entra a eval_aa_checks"
    set assessment_rev_id [db_string get_assessment_id {}]
    
    set section_list [db_list_of_lists sections {}]
    foreach section_id $section_list { 
	set checks [db_list_of_lists section_checks {}]
	foreach check $checks {
	    set info [db_0or1row check_info {}]
	    set perform [db_string check_sql $check_sql]
	    if {$action_p == "t"} {
		if {$perform == 1} {
		    as::assessment::check::action_exec -inter_item_check_id $inter_item_check_id -session_id $session_id
		}
	    }
	}
    }
}


ad_proc -public as::assessment::check::eval_m_checks {
    {-session_id}
    {-assessment_id}
} {
    
} {
    ns_log notice "entra a mannually"
    set assessment_rev_id [db_string get_assessment_id {}]
    
    db_foreach sections {} { 
	db_foreach section_checks {} {
	    if {$action_p == "t"} {
	    set perform [db_string check_sql $check_sql]
	    ns_log notice "-------------manual perform $perform"
	    
		if {$perform == 1} {
		    set failed ""
		    as::assessment::check::manual_action_log -check_id $inter_item_check_id -session_id $session_id 
		}
	    }
	}
    }
    
}

ad_proc -public as::assessment::check::confirm_display {
    {-check_id}
    {-index}
} {
    
} {
    set show_check_info ""
    set mod ""
    
    set info [db_0or1row get_check_info {}]
 
    
    set mod [expr $index%2]
    
    if {$mod==0} {
	set class "odd"
    } else {
	set class "even"
    }
    
    set action ""
    
    if { $action_p=="t"} {
	set info [db_0or1row get_check_info_a {}]
	
	db_foreach parameters {} {
	    append parameter_list "<li>$varname: "
	    if {$type == "q"} {
		append parameter_list "$value"
	    } else {
		append parameter_list "$item_id"
	    }
	}
	
	set action "<tr class=$class><td align=center>$name</d><td align=center>$action_name</td><td><ul>$parameter_list</ul></tr>"
    } else {
	set section_name_to [db_string get_section_name {} ]
	set action "<tr class=$class><td>$name</td><td>$section_name_to</td></tr>"	
    }
    
    
    set display_info $action
    return $display_info
}
