ad_form -name admin_section -form {
    {section_id:text(hidden) {value $section_id}}
}

db_multirow -extend { presentation_type html } items section_items {} {
    set presentation_type [as::item_form::add_item_to_form admin_section $as_item_id]
    if {$presentation_type == "fitb"} {
        regsub -all -line -nocase -- {<textbox as_item_choice_id=} $title "<input name=response_to_item.${as_item_id}_" html
    }

    if {![empty_string_p $max_time_to_complete]} {
	set max_min [expr $max_time_to_complete / 60]
	set max_sec [expr $max_time_to_complete - ($max_min * 60)]
	set max_time_to_complete "$max_min\:$max_sec min"
    }
}
