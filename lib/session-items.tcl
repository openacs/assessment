ad_form -name session_results_$section_id -mode display -form {
    {section_id:text(hidden) {value $section_id}}
}

# todo: display feedback text
db_multirow -extend { presentation_type html result_points } items session_items {} {
    set default_value [as::item_data::get -subject_id $subject_id -as_item_id $as_item_id -session_id $session_id]

    ns_log notice "\#\#\# $default_value"

    set presentation_type [as::item_form::add_item_to_form -name session_results_$section_id -section_id $section_id -item_id $as_item_id -session_id $session_id -default_value $default_value]

    if {$presentation_type == "fitb"} {
        regsub -all -line -nocase -- {<textbox as_item_choice_id=} $title "<input name=response_to_item.${as_item_id}_" html
    }

    if {[empty_string_p $points]} {
	set points 0
    }
    set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]
    array set values $default_value
    set result_points $values(points)
    array unset values
}
