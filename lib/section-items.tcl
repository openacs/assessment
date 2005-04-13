ad_form -name admin_section -form {
    {section_id:text(hidden) {value $section_id}}
}

db_multirow -extend { checks_related presentation_type html item_type choice_orientation } items section_items {} {
    set presentation_type [as::item_form::add_item_to_form -name admin_section -section_id $section_id -item_id $as_item_id -random_p f]
    if {$presentation_type == "fitb"} {
        regsub -all -line -nocase -- {<textbox as_item_choice_id=} $title "<input name=response_to_item.${as_item_id}_" html
    }
    array set item [as::item::item_data -as_item_id $as_item_id]

    if {$presentation_type == "rb" || $presentation_type == "cb"} {
	array set type [as::item_display_$presentation_type\::data -type_id $item(display_type_id)]
	set choice_orientation $type(choice_orientation)
	array unset type
    } else {
	set choice_orientation ""
    }

    set item_type $item(item_type)
    array unset item

    if {[empty_string_p $points]} {
	set points 0
    }
    set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]
    
    set checks [as::section::checks_list -assessment_id $assessment_id -section_id $section_id] 
    set checks_related 0
    foreach  check_sql $checks {
	set cond_list  [split $check_sql "="]
	set item_id [lindex [split [lindex $cond_list 2] " "] 0]
	if {$item_id == $as_item_id} {
	    incr checks_related
	}
	
    }
}
