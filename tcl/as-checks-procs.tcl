ad_library {    Assessment Checks procs
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation-date 2005-01-13
}

namespace eval as::assessment::check {}

ad_proc -public as::assessment::check::get_types {
} {
    Return the checks types
} {
    set types [list [list "\#assessment.action\#" "t"] [list "\#assessment.branch\#" "f"]]
    return $types
}

ad_proc -public as::assessment::check::get_assessments {
} {
    
} {
    set package_id [ad_conn package_id]
    set user_id [ad_conn user_id]
    set permission ""
    if {![acs_user::site_wide_admin_p -user_id $user_id]} {
	set permission "and ci.item_id in (select object_id from acs_permissions where grantee_id=:user_id and privilege='admin')"}
    set assessment_list [list [list "[_ assessment.all]" "all"]]
    set assessments [db_list_of_lists assessment {}]
    foreach  assessment $assessments {
	lappend assessment_list [list [lindex $assessment 0] [lindex $assessment 1]]
    }
    
    return $assessment_list
}

ad_proc -public as::assessment::check::state_options {
} {
    
} {
    set approved_options [list  [list "[_ assessment.approved]" "t"] [list "[_ assessment.approved_with]" "ae"] [list "[_ assessment.not_approved]" "f"] ]
    return $approved_options
}

ad_proc -public as::assessment::check::intervals {
} {
    Return the time intervals
} {
    set today [clock format [clock seconds] -format %Y-%m-%d]
    set yesterday [clock format [clock scan yesterday] -format %Y-%m-%d]
    set two_days [clock format [clock scan "2 days ago"] -format %Y-%m-%d]
    set last_week [clock format [clock scan "1 week ago"] -format %Y-%m-%d]
    set last_month [clock format [clock scan "1 month ago"] -format %Y-%m-%d]
    
    return [list [list [_ assessment.all] "all"] \
                [list [_ assessment.today]      $today] \
                [list [_ assessment.yesterday]  $yesterday] \
                [list [_ assessment.two_days]   $two_days] \
                [list [_ assessment.last_week]  $last_week] \
                [list [_ assessment.last_month] $last_month]]
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
    set order [db_string get_max_order {} -default 1]
    if { $order eq ""} {
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
    if { $type eq "n"} {
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
    set exists_p [db_string get_check_id {} -default 0]
    
    if { $type eq "n"} {
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
	set order [expr {$order_by+$count}]
	db_dml update_order {}
	incr count
    }
    
}

ad_proc -public as::assessment::check::get_sql {
    {-item_id}
    {-condition}
} {
    
} {
    set as_item_id [db_string get_item_id {select item_id from cr_revisions where revision_id=:item_id}]
    
    set check_sql "select (case when idc.choice_id in (select revision_id from cr_revisions where item_id=$condition) then \'1\' else \'0\' end) as perform_p from as_item_data id, as_item_data_choices idc where id.as_item_id in (select revision_id from cr_revisions where item_id=$as_item_id) and id.item_data_id=idc.item_data_id and id.session_id=:session_id"
    
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
    if { $direction eq "d"} {
	set order_p [expr {$order_by + 1}]
	set swap_check_id [db_string get_swap_check {}]
	db_dml update_1 {}
	db_dml update_2 {}
    } else {
	set order_p [expr {$order_by - 1}]
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
    set user_id [ad_conn user_id]
    set log_id [db_string get_next_val {}]
    set action_id [db_string action_id {}]
    set message " "

    if { $failed == "f" } {
	set message "This action failed."
    }
    db_transaction {
	    db_dml insert_action {}
    }
    
}

ad_proc -public as::assessment::check::manual_action_log {
    {-session_id}
    {-check_id}
    
} {
    
} {
    set user_id [ad_conn user_id]
    set log_id [db_string get_next_val {}]
    set action_id [db_string action_id {}]
    set message " "

    db_transaction {
	db_dml insert_action {}
	
    }
}


ad_proc -public as::assessment::check::action_exec {
    {-inter_item_check_id}
    {-session_id}
} { 
    
} {
    set error_txt ""

    db_foreach get_check_params {} {
	set parameter_name [db_1row select_name {}]
	
	set $varname ""
	
	if {$value eq ""} {
    	    set choice [db_list_of_lists get_item_choice {}]
	    set answer [db_0or1row get_answer {}] 
	    if {([info exists choice_id] && $choice_id ne "")} {
		set $varname "$choice_id"
	    } else {
		if { [info exists boolean_answer] } {
		    append $varname $boolean_answer
		}
		if { [info exists numeric_answer] } {
		    append $varname $numeric_answer
		}
		if { [info exists integer_answer] } {
		    append $varname $integer_answer
		}
		if { [info exists text_answer] } {
		    append $varname $text_answer
		}
		if { [info exists clob_answer] } {
		    append $varname $clob_answer
		}
		if { [info exists content_answer] } {
		    append $varname $content_answer
		}
	    }
	} else {
	    set $varname $value
	}


    }
    
    set tcl_code_p [db_1row select_tcl {}]
    set failed_p "f"
    if {[catch $tcl_code errorMsg]} {
	set failed_p "t"
	ns_log error "Error running assessment action $action_name '${errorMsg}'"
    }
    set admin [db_list_of_lists get_assessment_admin {}]
    
    set to [list]
    foreach notify_user $admin {
	lappend to $notify_user
    }
    
    if {$failed_p} {
	notification::new -type_id [notification::type::get_type_id -short_name inter_item_check_notif] -object_id $inter_item_check_id -notif_subject "$action_name has been executed" -notif_text "The action $action_name has encountered an error: $errorMsg" -subset $to -force -action_id $inter_item_check_id
    }

    
    
    as::assessment::check::action_log -session_id $session_id -check_id $inter_item_check_id -failed $failed_p
    
}


ad_proc -public as::assessment::check::manual_action_exec {
    {-inter_item_check_id}
    {-session_id}
    {-action_log_id}
} { 
    
} {
    db_0or1row subject_id {select subject_id from as_sessions where session_id=:session_id}
    db_foreach get_check_params {} {
	set parameter_name [db_1row select_name {}]
	
	set $varname ""
	
	if {$value eq ""} {
    	    set choice [db_list_of_lists get_item_choice {}]
	    set answer [db_0or1row get_answer {}] 
	    if {([info exists choice_id] && $choice_id ne "")} {
		set $varname "$choice_id"
	    } else {
				if { [info exists boolean_answer] } {
		    append $varname $boolean_answer
		}
		if { [info exists numeric_answer] } {
		    append $varname $numeric_answer
		}
		if { [info exists integer_answer] } {
		    append $varname $integer_answer
		}
		if { [info exists text_answer] } {
		    append $varname $text_answer
		}
		if { [info exists clob_answer] } {
		    append $varname $clob_answer
		}
		if { [info exists content_answer] } {
		    append $varname $content_answer
		}
		
	    }
	} else {
	    set $varname $value
	}


    }
    
    set tcl_code_p [db_1row select_tcl {}]
    set failed_p "t"
    set failed [catch $tcl_code]

    if { $failed > 0 } {
	set failed_p "f"
    }
    
    set user_id [ad_conn user_id]
    db_dml update_actions_log {}
        set admin [db_list_of_lists get_assessment_admin {}]
    
    set to [list]
    foreach notify_user $admin {
	lappend to $notify_user
    }
    if { [parameter::get -package_id [ad_conn package_id] -parameter NotifyAdminOfActions -default 1] } {
    	notification::new -type_id [notification::type::get_type_id -short_name inter_item_check_notif] -object_id $inter_item_check_id -notif_subject "$action_name has been executed" -notif_text "The action $action_name has been executed. This message has been showed to the user: $user_message" -subset $to -force -action_id $inter_item_check_id
    }

    
}



ad_proc -public as::assessment::check::eval_i_checks {
    {-session_id}
    {-section_id}
} {
    
} {
    
    set section_checks [db_list_of_lists section_checks {}]

    foreach check $section_checks  {
	set check_sql [lindex $check 1]
	set perform [db_string check_sql $check_sql -default 0]
	if {[lindex $check 2] == "t"} {
	    if {$perform == 1} {
		as::assessment::check::action_exec -inter_item_check_id [lindex $check 0] -session_id $session_id
	    }
	}
    }
}


ad_proc -public as::assessment::check::branch_checks {
    {-session_id}
    {-section_id}
    {-assessment_id}
} {
    
} {
    set order "f"
    set perform 0
    set checks [db_list_of_lists section_checks {}]
    
    foreach check $checks {
	as::assessment::data -assessment_id $assessment_id
	set new_assessment_revision $assessment_data(assessment_rev_id)
	set section_id_to [lindex $check 2]
	set perform [db_string check_sql "[lindex $check 0]" -default 0]
	
	if {$perform == 1} {
	    set order [db_string get_order {}]
	}
	
    }
    
    if {$order == "f"} {
	return $order
    } {
	return [expr {$order -1}]
    }
}




ad_proc -public as::assessment::check::eval_aa_checks {
    {-session_id}
    {-assessment_id}
} {
    
} {

    set assessment_rev_id [db_string get_assessment_id {}]

	set checks [db_list_of_lists section_checks {}]
	foreach check_id $checks {

	    set info [db_0or1row check_info {}]
	    set perform [db_string check_sql $check_sql -default 0]
	    if {$action_p == "t"} {
		if {$perform == 1} {
		    as::assessment::check::action_exec -inter_item_check_id $inter_item_check_id -session_id $session_id
		}
	    }
	}
    
}


ad_proc -public as::assessment::check::eval_m_checks {
    {-session_id}
    {-assessment_id}
} {
    
} {

	db_foreach assessment_checks {} {
	    if {$action_p == "t"} {
	    set perform [db_string check_sql $check_sql -default 0]

	    
		if {$perform == 1} {
		    set failed ""
		    as::assessment::check::manual_action_log -check_id $inter_item_check_id -session_id $session_id 
		}
	    }
	
	}
    
}

ad_proc -public as::assessment::check::eval_or_checks {
    {-session_id}
    {-section_id}
} {
    
} {
    
    set section_checks [db_list_of_lists section_checks {}]
    
    foreach check $section_checks  {
        set check_sql [lindex $check 1]
        set perform [db_string check_sql $check_sql -default 0]
        if {[lindex $check 2] == "t"} {
            if {$perform == 1} {
                as::assessment::check::action_exec -inter_item_check_id [lindex $check 0] -session_id $session_id
            }
        }
    }
}


ad_proc -public as::assessment::check::eval_sa_checks {
    {-session_id}
    {-assessment_id}
} {
    
} {

    set assessment_rev_id [db_string get_assessment_id {}]

	set checks [db_list_of_lists section_checks {}]
	foreach check_id $checks {

	    set info [db_0or1row check_info {}]
	    set perform [db_string check_sql $check_sql -default 0]
	    if {$action_p == "t"} {
		if {$perform == 1} {
		    as::assessment::check::action_exec -inter_item_check_id $inter_item_check_id -session_id $session_id
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
 
    
    set mod [expr {$index%2}]
    
    if {$mod==0} {
	set class "odd"
    } else {
	set class "even"
    }
    
    set action ""
    set parameter_list ""
    if { $action_p=="t"} {
	set info [db_0or1row get_check_info_a {}]
	
	db_foreach parameters {} {
	    append parameter_list "<li>$varname: "
	    if {$type eq "q"} {
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

ad_proc -public as::assessment::check::copy_checks {
    {-section_id:required}
    {-new_section_id:required}
    {-assessment_id:required}
} {
    
} {
    set user_id [ad_conn user_id]
    set checks [db_list_of_lists get_checks {}]
    foreach check $checks {
	
	set inter_item_check_id [lindex $check 0]
	db_dml update_checks {}
    }
    #update other checks
    update_checks -section_id $section_id -new_section_id $new_section_id
}

ad_proc -public as::assessment::check::update_checks {
    {-section_id:required}
    {-new_section_id:required}
} {
    
} {
    set checks [db_list_of_lists checks {}]
    foreach check_id $checks {
	db_dml update_check {}
    }
}

ad_proc -public as::assessment::check::delete_assessment_checks {
    {-assessment_id:required}
} {
    
} {
    set checks [db_list_of_lists assessment_checks {}]
    foreach check_id $checks {
	set delete_p [db_exec_plsql delete_checks {}]
    }
}
ad_proc -public as::assessment::check::delete_item_checks {
    {-assessment_id:required}
    {-section_id}
    {-as_item_id}
} {
    
} {
    set checks [db_list_of_lists related_checks {}]
    foreach check $checks {
	set cond_list  [split [lindex $check 1] "="]
	set item_id [lindex [split [lindex $cond_list 2] ")"] 0]
	if {$item_id == $as_item_id} {
	    set check_id [lindex $check 0]
	    db_exec_plsql delete_check {}
	}
    }

}

ad_proc -public as::assessment::check::copy_item_checks {
    {-assessment_id:required}
    {-section_id}
    {-as_item_id}
    {-new_item_id}
} {
    
} {
    set checks [db_list_of_lists related_checks {}]
    set user_id [ad_conn user_id]
    foreach check $checks {

	
	set cond_list  [split [lindex $check 1] "="]
	set item_id [lindex [split [lindex $cond_list 2] ")"] 0]
	set condition [lindex [split [lindex $cond_list 1] ")"] 0]
	
	if {$item_id == $as_item_id} {
	    set inter_item_check_id [lindex $check 0]
	    set check_sql [as::assessment::check::get_sql -item_id $new_item_id  -condition $condition]
	    
	    db_dml update_checks {}
	    
	}
    }
}


ad_proc -public as::assessment::check::eval_single_check {
    {-session_id}
    {-assessment_id}
    {-inter_item_check_id}
} {
    
} {
    db_1row get_check_info {} 
    
    set perform [db_string check_sql $check_sql -default 0]
    ns_log notice "$check_sql $perform"
    if {$perform == 1} {
	set failed ""
	as::assessment::check::manual_action_log -check_id $inter_item_check_id -session_id $session_id 
    }
}


ad_proc -public as::assessment::check::add_manual_check {
    {-assessment_id:required}
    {-inter_item_check_id:required}
} {
    
} {
    set sessions [db_list_of_lists get_sessions {select session_id from as_sessions where assessment_id=:assessment_id}]
    foreach session_id $sessions {
	as::assessment::check::eval_single_check -session_id $session_id -assessment_id $assessment_id  -inter_item_check_id $inter_item_check_id
    }
}



# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
