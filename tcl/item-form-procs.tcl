ad_library {
    Items and forms
    @author alvaro@it.uc3m.es
    @creation-date 2004-04-01
}

ad_proc -public add_item_to_form  { form item_id } { Add items to a form. The form values are stored in response_to_item.item_id } {
    set element_name "response_to_item.$item_id"
    db_1row item_properties ""
    set user_value ""

    #Add the items depending on the type (as_item_display_types)
    switch -- $presentation_type {
	"textbox" {
	    template::element::create $form $element_name \
		-datatype text \
		-widget text \
		-label $title \
		-value $user_value \
		-size 40 \
		-required_p $required_p
	}

	"textarea" {
	    set html {rows 15 cols 55}
	    template::element::create $form $element_name \
		-datatype text \
		-widget textarea \
		-label $title \
		-value $user_value \
		-html $html \
		-required_p $required_p
	}

	"radiobutton" {
	    set widget "text(radio)"
	    set item_item_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:item_id"]
	    set item_mc_id [db_string item_item_type "SELECT related_object_id FROM cr_item_rels WHERE item_id=:item_item_id"]
	    set mc_id [db_string item_to_rev "SELECT revision_id FROM cr_revisions WHERE item_id=:item_mc_id"]
	    set optionlist [list]
	    db_foreach item_choices_2 "" {
		lappend optionlist [list $title $choice_id]
	    }
	    set options $optionlist
	    template::element::create $form $element_name \
		-datatype text \
		-widget radio \
		-label $title \
		-value $user_value \
		-options $options \
		-required_p $required_p
	}

	"checkbox" {
	    set item_item_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:item_id"]
	    set item_mc_id [db_string item_item_type "SELECT related_object_id FROM cr_item_rels WHERE item_id=:item_item_id"]
	    set mc_id [db_string item_to_rev "SELECT revision_id FROM cr_revisions WHERE item_id=:item_mc_id"]
	    set choices [list]
	    set optionlist [list]
	    db_foreach item_choices_2 "" {
		lappend optionlist [list $title $choice_id]
	    }
	    set options $optionlist
	    template::element::create $form $element_name \
		-datatype text \
		-widget checkbox \
		-label $title \
		-values $user_value \
		-options $options \
		-required_p $required_p
	}
    }
}
