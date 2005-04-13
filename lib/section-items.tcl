ad_form -name admin_section -form {
    {section_id:text(hidden) {value $section_id}}
}

db_multirow -extend { checks_related presentation_type html mc_type choice_orientation } items section_items {} {
    set presentation_type [as::item_form::add_item_to_form -name admin_section -section_id $section_id -item_id $as_item_id -random_p f]
    if {$presentation_type == "fitb"} {
        regsub -all -line -nocase -- {<textbox as_item_choice_id=} $title "<input name=response_to_item.${as_item_id}_" html
    }
    if {$presentation_type == "rb" || $presentation_type == "cb"} {
	set choice_orientation [as::item::get_choice_orientation -as_item_id $as_item_id -presentation_type $presentation_type]
    } else {
	set choice_orientation ""
    }

    #used to determine if the item is multiple choice
    set mc_type [as::item::mc_type -as_item_id $as_item_id]

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
