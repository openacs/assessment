ad_page_contract {
    Form to add an item with checkbox display.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer
    section_id:integer
    as_item_id:integer
    after:integer
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

set page_title [_ assessment.add_item_display_cb]
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]


set choice_or_types [list]
foreach choice_or_type [list horizontal vertical] {
    lappend choice_or_types [list "[_ assessment.$choice_or_type]" $choice_or_type]
}

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

ad_form -name item_add_display_cb -action item-add-display-cb -export { assessment_id section_id after } -form {
    {as_item_id:key}
    {html_options:text,optional {label "[_ assessment.Html_Options]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.Html_Options_help]"}}
    {choice_orientation:text(select) {label "[_ assessment.Choice_Orientation]"} {options $choice_or_types} {help_text "[_ assessment.Choice_Orientation_help]"}}
    {label_orientation:text(select) {label "[_ assessment.Label_Orientation]"} {options $label_or_types} {help_text "[_ assessment.Label_Orientation_help]"}}
    {order_type:text(select) {label "[_ assessment.Order_Type]"} {options $order_types} {help_text "[_ assessment.Order_Type_help]"}}
    {answer_alignment:text(select) {label "[_ assessment.Answer_Alignment]"} {options $alignment_types} {help_text "[_ assessment.Answer_Alignment_help]"}}
} -edit_request {
    set html_options ""
    set choice_orientation "vertical"
    set label_orientation "top"
    set order_type "order_of_entry"
    set answer_alignment "besideright"
} -edit_data {
    db_transaction {
	set as_item_display_id [as::item_display_cb::new \
				    -html_display_options $html_options \
				    -choice_orientation $choice_orientation \
				    -choice_label_orientation $label_orientation \
				    -sort_order_type $order_type \
				    -item_answer_alignment $answer_alignment]
	
	as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_display_id -type as_item_display_rel

	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	set new_section_id [as::section::new_revision -section_id $section_id]
	db_dml update_section_in_assessment {}
	db_dml move_down_items {}
	incr after
	db_dml insert_new_item {}
    }
} -after_submit {
    # now go to assessment-page
    ad_returnredirect [export_vars -base one-a {assessment_id}]
    ad_script_abort
}

ad_return_template
