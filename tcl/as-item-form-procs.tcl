ad_library {
    Items and forms
    @author alvaro@it.uc3m.es
    @creation-date 2004-04-01
}

namespace eval as::item_form {}

ad_proc -public as::item_form::add_item_to_form  { form item_id } { Add items to a form. The form values are stored in response_to_item.item_id } {
    set element_name "response_to_item.$item_id"
    db_1row item_properties ""
    set user_value ""

    set item_item_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:item_id"]
    set item_display_id [db_string item_item_type "SELECT related_object_id FROM cr_item_rels WHERE relation_tag = 'as_item_display_rel' AND item_id=:item_item_id"]
    db_0or1row as_item_display_rbx "SELECT item_id AS as_item_display_rbx__item_id FROM as_item_display_rbx WHERE item_id=:item_display_id"
    db_0or1row as_item_display_tbx "SELECT item_id AS as_item_display_tbx__item_id FROM as_item_display_tbx WHERE item_id=:item_display_id"
    db_0or1row as_item_display_tax "SELECT item_id AS as_item_display_tax__item_id FROM as_item_display_tax WHERE item_id=:item_display_id"
    set presentation_type "checkbox" ;# DEFAULT
    #get the presentation type
    if {[info exists as_item_display_rbx__item_id]} {set presentation_type "radio"}
    if {[info exists as_item_display_tbx__item_id]} {set presentation_type "fitb"}
    if {[info exists as_item_display_tax__item_id]} {set presentation_type "textarea"}

    #Add the items depending on the presentation type (as_item_display_types)
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
	    db_0or1row html_rows_cols "SELECT abs_size FROM as_item_display_tax WHERE item_id=:item_display_id"	   
	    template::element::create $form $element_name \
		-datatype text \
		-widget textarea \
		-label $title \
		-value $user_value \
		-html $abs_size \
		-nospell \
		-required_p $required_p
	}

	"radio" {
	    set widget "text(radio)"
	    set item_item_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:item_id"]
	    set item_mc_id [db_string item_item_type "SELECT related_object_id FROM cr_item_rels WHERE relation_tag = 'as_item_type_rel' AND item_id=:item_item_id"]
	    set mc_id [db_string item_to_rev "SELECT revision_id FROM cr_revisions WHERE item_id=:item_mc_id"]
	    set optionlist [list]
	    db_foreach item_choices_2 "" {
	        #for multiple choice item with multimedia
	        if {![empty_string_p $content_value]} {
		    lappend optionlist [list "$title<img src=\"view/?revision_id=$content_value\">" $choice_id]
		} else {
		    lappend optionlist [list $title $choice_id]
		}
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
	    set item_mc_id [db_string item_item_type "SELECT related_object_id FROM cr_item_rels WHERE relation_tag = 'as_item_type_rel' AND item_id=:item_item_id"]
	    set mc_id [db_string item_to_rev "SELECT revision_id FROM cr_revisions WHERE item_id=:item_mc_id"]
	    set choices [list]
	    set optionlist [list]
	    db_foreach item_choices_2 "" {
	        #for multiple choice item with multimedia
	        if {![empty_string_p $content_value]} {
		    lappend optionlist [list "$title<img src=\"view/?revision_id=$content_value\">" $choice_id]
		} else {
		    lappend optionlist [list $title $choice_id]
		}    
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
    return $presentation_type
}
