ad_library {
    Items and forms
    @author alvaro@it.uc3m.es
    @creation-date 2004-04-01
}

namespace eval as::item_form {}

ad_proc -public as::item_form::add_item_to_form  {
    form
    item_id
} {
    Add items to a form. The form values are stored in response_to_item.item_id
} {
    set element_name "response_to_item.$item_id"
    db_1row item_properties ""
    set user_value ""

    set item_display_id [as::item_rels::get_target -item_rev_id $item_id -type as_item_display_rel]
    db_0or1row as_item_display_rbx "SELECT as_item_display_id AS rb__display_id FROM as_item_display_rb WHERE as_item_display_id=:item_display_id"
    db_0or1row as_item_display_tbx "SELECT as_item_display_id AS tb__display_id FROM as_item_display_tbx WHERE as_item_display_id=:item_display_id"
    db_0or1row as_item_display_tax "SELECT as_item_display_id AS ta__display_id FROM as_item_display_tax WHERE as_item_display_id=:item_display_id"
    set presentation_type "checkbox" ;# DEFAULT
    #get the presentation type
    if {[info exists rb__display_id]} {set presentation_type "radio"}
    if {[info exists tb__display_id]} {set presentation_type "fitb"}
    if {[info exists ta__display_id]} {set presentation_type "textarea"}

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
	    db_0or1row html_rows_cols "SELECT html_display_options FROM as_item_display_ta WHERE as_item_display_id=:item_display_id"	   
	    template::element::create $form $element_name \
		-datatype text \
		-widget textarea \
		-label $title \
		-value $user_value \
		-html $html_display_options \
		-nospell \
		-required_p $required_p
	}

	"radio" {
	    set widget "text(radio)"
	    set mc_id [as::item_rels::get_target -item_rev_id $item_id -type as_item_type_rel]
	    set optionlist [list]
	    db_foreach item_choices_2 "" {
	        #for multiple choice item with multimedia
	        if {[empty_string_p $content_value]} {
		    lappend optionlist [list $title $choice_id]
		} elseif {[db_string mime_type {SELECT mime_type LIKE 'image%' FROM cr_revisions WHERE revision_id = :content_value}]} {
		    lappend optionlist [list "$title<img src=\"view/?revision_id=$content_value\">" $choice_id]
		} else {
		    lappend optionlist [list "$title<embed src=\"view/?revision_id=$content_value\">" $choice_id]
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
	    set mc_id [as::item_rels::get_target -item_rev_id $item_id -type as_item_type_rel]
	    set choices [list]
	    set optionlist [list]
	    db_foreach item_choices_2 "" {
	        #for multiple choice item with multimedia
	        if {[empty_string_p $content_value]} {
		    lappend optionlist [list $title $choice_id]
		} elseif {[db_string mime_type {SELECT mime_type LIKE 'image%' FROM cr_revisions WHERE revision_id = :content_value}]} {
		    lappend optionlist [list "$title<img src=\"view/?revision_id=$content_value\">" $choice_id]
		} else {
		    lappend optionlist [list "$title<embed src=\"view/?revision_id=$content_value\">" $choice_id]
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
