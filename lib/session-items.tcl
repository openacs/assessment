if {![exists_and_not_null edit_p]} {
    set edit_p 0
}

ad_form -name session_results_$section_id -mode display -form {
    {section_id:text(hidden) {value $section_id}}
}

# todo: display feedback text
db_multirow -extend { presentation_type html result_points feedback answered_p choice_orientation next_title num } items session_items {} {
    set default_value [as::item_data::get -subject_id $subject_id -as_item_id $as_item_id -session_id $session_id]

    set presentation_type [as::item_form::add_item_to_form -name session_results_$section_id -section_id $section_id -item_id $as_item_id -session_id $session_id -default_value $default_value -show_feedback $show_feedback]

    if {$presentation_type == "fitb"} {
        regsub -all -line -nocase -- {<textbox as_item_choice_id=} $title "<input name=response_to_item.${as_item_id}_" html
    }
    if {$presentation_type == "rb" || $presentation_type == "cb"} {
	array set item [as::item::item_data -as_item_id $as_item_id]
	array set type [as::item_display_$presentation_type\::data -type_id $item(display_type_id)]
	set choice_orientation $type(choice_orientation)
	array unset item
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
	array unset values
	set answered_p t

	if {$result_points < $points} {
	    if {$show_feedback != "correct"} {
	        set feedback "<font color=red>$feedback_wrong</font>"
	    }	
	} else {
	    if {$show_feedback != "incorrect"} {
	        set feedback "<font color=green>$feedback_right</font>"
	    }
	}	
    } else {
	set result_points ""
	set feedback ""
	set answered_p f
    }    
}

set counter 1
for {set i 1; set j 2} {$i <= ${items:rowcount}} {incr i; incr j} {
    upvar 0 items:$i this
    set this(num) $counter
    if {$i < ${items:rowcount}} {
	upvar 0 items:$j next
	set this(next_title) $next(title)
	if {$this(title) != $next(title)} {
	    incr counter
	}
    } else {
	set this(next_title) ""
    }
}
