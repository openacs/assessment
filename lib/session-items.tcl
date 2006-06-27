if {![exists_and_not_null edit_p]} {
    set edit_p 0
}

if {![exists_and_not_null feedback_only_p] } {
    set feedback_only_p 0
}
if {![info exists assessment_id]} {
    set assessment_id $assessment_data(assessment_id)
}
# if we can tell this is the last section, next button should go to feedback for the entire assessment.

set section_list [as::assessment::sections -assessment_id $assessment_id -session_id $session_id -sort_order_type $assessment_data(section_navigation) -random_p $assessment_data(random_p)]

if {[lsearch $section_list $section_id] eq [expr {[llength $section_list]-1}]} {
    set next_url [export_vars -base session {session_id next_url}]
}

if {[info exists assessment_id]} {
    # check if this assessment even allows feedback if not, bail out

    if {$feedback_only_p && $assessment_data(show_feedback) eq "none"} {
	ad_returnredirect $next_url
	ad_script_abort
    }
}

set items_clause ""
if {[info exists item_id_list]} {
    if {[llength $item_id_list]} {
	set items_clause "and i.as_item_id in ([join $item_id_list ,])"
    }
}

ad_form -name session_results_$section_id -mode display -form {
    {section_id:text(hidden) {value $section_id}}
}

# todo: display feedback text
set feedback_count 0
db_multirow -extend { presentation_type html result_points feedback answered_p choice_orientation next_title next_pr_type num content has_feedback_p } items session_items {} {
    set default_value [as::item_data::get -subject_id $subject_id -as_item_id $as_item_id -session_id $session_id]
    array set item [as::item::item_data -as_item_id $as_item_id]

    set presentation_type [as::item_form::add_item_to_form -name session_results_$section_id -section_id $section_id -item_id $as_item_id -session_id $session_id -default_value $default_value -show_feedback $show_feedback]
    

    if {$presentation_type == "fitb"} {
        regsub -all -line -nocase -- {<textbox as_item_choice_id=} $title "<input name=response_to_item.${as_item_id}_" html
    }
    if {$presentation_type == "f"} {
	set view "[as::item_display_$presentation_type\::view -item_id $as_item_id -session_id $session_id -section_id $section_id]"
    }

    if {$presentation_type == "rb" || $presentation_type == "cb"} {
	array set type [as::item_display_$presentation_type\::data -type_id $item(display_type_id)]
	set choice_orientation $type(choice_orientation)
	array unset type
    } else {
	set choice_orientation ""
    }

    if {[empty_string_p $points]} {
	set points 0
    }
    set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]
    if {![empty_string_p $default_value]} {
	array set values $default_value
	set result_points $values(points)
	set item_data_id $values(item_data_id)
	array unset values
	set answered_p t

	if { $points != 0 } {
	    if {$result_points < $points} {
		if {$show_feedback != "correct"} {
		    if { $feedback_wrong ne "" } {
			set feedback "<font color=red>$feedback_wrong</font>"
			set has_feedback_p 1
		    } else {
			set feedback ""
		    }
		}	
	    } else {
		if {$show_feedback != "incorrect"} {
		    if { $feedback_right ne "" } {
			set feedback "<font color=green>$feedback_right</font>"
			set has_feedback_p 1
		    } else {
			set feedback ""
		    }
		}
	    }
	} else {
	    if {$presentation_type == "rb" || $presentation_type == "cb"} {
		set user_answers [db_list get_user_choice_answers {}]

		set correct_answers [db_list get_correct_choice_answers {}]

		if { $presentation_type == "rb" } {
		    set user_answers [lindex $user_answers 0]
		 
		    if { [lsearch $correct_answers $user_answers] == -1 } {
			if {$show_feedback != "correct"} {
			    if { $feedback_wrong ne "" } {
				set feedback "<font color=red>$feedback_wrong</font>"
				set has_feedback_p 1
			    } else {
				set feedback ""
			    }
			}	
		    } else {
			if {$show_feedback != "incorrect"} {
			    if { $feedback_right ne "" } {
				set feedback "<font color=green>$feedback_right</font>"
				set has_feedback_p 1
			    } else {
				set feedback ""
			    }
			}
		    }		    
		} else {
		    # Checkbox, all answers must be correct if no
		    # points are set
		    if { [llength $user_answers] != [llength $correct_answers] } {
			set correct_p 0
		    } else {
			set correct_p 1
			foreach one_answer $user_answers {
			    if { [lsearch $correct_answers $one_answer] == -1 } {
				set correct_p 0
				break
			    }
			}
		    }

		    if { !$correct_p } {
			if {$show_feedback != "correct"} {
			    if { $feedback_wrong ne "" } {
				set feedback "<font color=red>$feedback_wrong</font>"
				set has_feedback_p 1
			    } else {
				set feedback ""
			    }
			}	
		    } else {
			if {$show_feedback != "incorrect"} {
			    if { $feedback_right ne "" } {
				set feedback "<font color=green>$feedback_right</font>"
				set has_feedback_p 1
			    } else {
				set feedback ""
			    }
			}
		    }
		}
	    }
	}
    } else {
	set result_points ""
	set feedback ""
	set answered_p f
    }

    set content [as::assessment::display_content -content_id $item(content_rev_id) -filename $item(content_filename) -content_type $item(content_type)]

    if { $has_feedback_p == 1 } {
	incr feedback_count
    }
}

if { $feedback_only_p && $feedback_count == 0 && [exists_and_not_null next_url] } {
    ad_returnredirect $next_url
    ad_script_abort
}

set counter 1
for {set i 1; set j 2} {$i <= ${items:rowcount}} {incr i; incr j} {
    upvar 0 items:$i this
    set this(num) $counter
    if {$i < ${items:rowcount}} {
	upvar 0 items:$j next
	set this(next_title) $next(title)
	set this(next_pr_type) $next(presentation_type)
	if {$this(title) != $next(title)} {
	    incr counter
	}
    } else {
	set this(next_title) ""
	set this(next_pr_type) ""
    }
}

set showpoints [parameter::get -parameter "ShowPoints" -default 1 ]
