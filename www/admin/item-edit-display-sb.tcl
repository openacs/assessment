ad_page_contract {
    Form to edit an item with selectbox display.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer
    section_id:integer
    as_item_id:integer
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

ad_require_permission $assessment_id admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set page_title [_ assessment.edit_item_display_sb]
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] [list [export_vars -base item-edit {assessment_id section_id as_item_id}] [_ assessment.edit_item]] $page_title]

set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]

set label_or_types [list]
foreach label_or_type [list top left right bottom] {
    lappend label_or_types [list "[_ assessment.$label_or_type]" $label_or_type]
}

set order_types [list]
foreach one_order_type [list numerical alphabetical randomized order_of_entry] {
    lappend order_types [list "[_ assessment.$one_order_type]" $one_order_type]
}

set alignment_types [list]
foreach alignment_type [list besideleft besideright below above] {
    lappend alignment_types [list "[_ assessment.$alignment_type]" $alignment_type]
}


ad_form -name item_edit_display_sb -action item-edit-display-sb -export { assessment_id section_id } -form {
    {as_item_id:key}
    {html_display_options:text,optional {label "[_ assessment.Html_Options]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.Html_Options_help]"}}
    {multiple_p:text(select) {label "[_ assessment.Multiple]"} {options $boolean_options} {help_text "[_ assessment.Multiple_help]"}}
    {choice_label_orientation:text(select) {label "[_ assessment.Label_Orientation]"} {options $label_or_types} {help_text "[_ assessment.Label_Orientation_help]"}}
    {sort_order_type:text(select) {label "[_ assessment.Order_Type]"} {options $order_types} {help_text "[_ assessment.Order_Type_help]"}}
    {item_answer_alignment:text(select) {label "[_ assessment.Answer_Alignment]"} {options $alignment_types} {help_text "[_ assessment.Answer_Alignment_help]"}}
    {as_item_display_id:text(hidden)}
} -edit_request {
    db_1row last_used_display_type {}
    if {![empty_string_p $as_item_display_id]} {
	db_1row display_type_data {}
    } else {
	# default data if display newly mapped
	set html_display_options ""
	set multiple_p f
	set choice_label_orientation "top"
	set sort_order_type "order_of_entry"
	set item_answer_alignment "besideright"
	set as_item_display_id 0
    }
} -edit_data {
    db_transaction {
	set new_item_id [as::item::new_revision -as_item_id $as_item_id]

	if {$as_item_display_id} {
	    # edit existing display type
	    set new_item_display_id [as::item_display_cb::edit \
					 -as_item_display_id $as_item_display_id \
					 -html_display_options $html_display_options \
					 -multiple_p $multiple_p \
					 -choice_label_orientation $choice_label_orientation \
					 -sort_order_type $sort_order_type \
					 -item_answer_alignment $item_answer_alignment]
	} else {
	    # create new display type
	    set new_item_display_id [as::item_display_cb::new \
					 -html_display_options $html_display_options \
					 -multiple_p $multiple_p \
					 -choice_label_orientation $choice_label_orientation \
					 -sort_order_type $sort_order_type \
					 -item_answer_alignment $item_answer_alignment]
	}

	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	set new_section_id [as::section::new_revision -section_id $section_id]
	db_dml update_section_in_assessment {}
	db_dml update_item_in_section {}
	db_dml update_display_of_item {}
    }
    set as_item_id $new_item_id
    set section_id $new_section_id
} -after_submit {
    ad_returnredirect [export_vars -base "item-edit" {assessment_id section_id as_item_id}]
    ad_script_abort
}

ad_return_template