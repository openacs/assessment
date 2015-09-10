ad_form -name show_section -form {
    {section_id:text(hidden) {value $section_id}}
}

db_multirow -extend { presentation_type html } items section_items {} {
    set presentation_type [as::item_form::add_item_to_form -name show_section -section_id $section_id -item_id $as_item_id]
    if {$presentation_type eq "fitb"} {
        regsub -all -line -nocase -- {<textbox as_item_choice_id=} $title "<input name=response_to_item.${as_item_id}_" html
    }

    if {$points eq ""} {
	set points 0
    }
    set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
