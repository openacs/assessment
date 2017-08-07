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
    {-required_p f}
    {-random_p ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-04-08

    Add items to a form. The form values are stored in response_to_item.item_id
} {
    randomInit [randomRange 20000]
    set element_name "response_to_item.$item_id"
    array set item [as::item::item_data -as_item_id $item_id]

    if {$random_p == "f"} {
	set item_data [util_memoize [list as::item_type_$item(item_type)\::render -type_id $item(item_type_id) -session_id "" -section_id $section_id -as_item_id $item_id -default_value $default_value -show_feedback $show_feedback]]
    } else {
	set item_data [as::item_type_$item(item_type)\::render -type_id $item(item_type_id) -session_id $session_id -section_id $section_id -as_item_id $item_id -default_value $default_value -show_feedback $show_feedback]
    }

    lassign $item_data default_value data

    if {$item(item_type) eq "mc"} {
	set item(allow_other_p) [as::item_type_mc::allow_other_p -item_type_id $item(item_type_id)]
    }

    set presentation_type [as::item_display_$item(display_type)\::render \
                               -form $name \
                               -element $element_name \
                               -type_id $item(display_type_id) \
                               -datatype $item(data_type) \
                               -title $item(title) \
                               -subtext $item(subtext) \
                               -required_p $required_p \
                               -random_p $random_p \
                               -default_value $default_value \
                               -data $data \
			       -item [array get item]]

    return $presentation_type
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
