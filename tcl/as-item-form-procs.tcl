ad_library {
    Items and forms
    @author alvaro@it.uc3m.es
    @creation-date 2004-04-01
}

namespace eval as::item_form {}

ad_proc -public as::item_form::add_item_to_form  {
    -name:required
    -section_id:required
    -item_id:required
    {-session_id ""}
    {-default_value ""}
    {-show_feedback ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @modified-date 2004-12-10

    Add items to a form. The form values are stored in response_to_item.item_id
} {
    randomInit [randomRange 20000]
    set element_name "response_to_item.$item_id"
    db_1row item_properties {}
    set item_type [string range $item_type end-1 end]
    set display_type [string range $display_type end-1 end]

    util_unlist [as::item_type_$item_type\::render -type_id $item_type_id -session_id $session_id -section_id $section_id -as_item_id $item_id -default_value $default_value -show_feedback $show_feedback] default_value data

    as::item_display_$display_type\::render \
	-form $name \
	-element $element_name \
	-type_id $display_type_id \
	-datatype $data_type \
	-title $title \
	-subtext $subtext \
	-required_p $required_p \
	-default_value $default_value \
	-data $data

    return $display_type
}
