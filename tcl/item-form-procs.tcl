ad_library {
    Items and forms
    @author alvaro@it.uc3m.es
    @creation-date 2004-04-01
}

ad_proc -public add_item_to_form  { form item_id } { Add items to a form. The form values are stored in response_to_itrm.item_id } {
    set element_name "response_to_item.$item_id"
    db_1row item_properties ""
    set user_value ""

    #Add the items depending on the type (as_item_display_types)
    switch -- $presentation_type {
	"textbox" {
	    template::element::create $form $element_name \
		-datatype text \
		-widget text \
		-label "$item_text" \
		-value $user_value \
		-size 40 \
		-required_p $required_p
	}

	"textarea" {
	    set html {rows 15 cols 55}
	    template::element::create $form $element_name \
		-datatype text \
		-widget textarea \
		-label "$item_text" \
		-value $user_value \
		-html $html \
		-required_p $required_p
	}

	"radiobutton" {
	    set widget "text(radio)"
	    set optionlist [list]
	    db_foreach item_choices_2 "" {
		lappend optionlist [list $choice_text $choice_id]
	    }
	    set options $optionlist
	    template::element::create $form $element_name \
		-datatype text \
		-widget radio \
		-label "$item_text" \
		-value $user_value \
		-options $options \
		-required_p $required_p
	}

	"checkbox" {
	    set choices [list]
	    set optionlist [list]
	    db_foreach item_choices_3 "" {
		lappend optionlist [list $choice_text $choice_id]
	    }
	    set options $optionlist
	    template::element::create $form $element_name \
		-datatype text \
		-widget checkbox \
		-label "$item_text" \
		-values $user_value \
		-options $options \
		-required_p $required_p
	}
    }
}
