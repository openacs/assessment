ad_page_contract {
    Form to add an item with selectbox display.

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

permission::permission_p -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set page_title [_ assessment.add_item_display_sb]
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]

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

ad_form -name item_add_display_sb -action item-add-display-sb -export { assessment_id section_id after } -form {
    {as_item_id:key}
    {html_options:text,optional {label "[_ assessment.Html_Options]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.Html_Options_help]"}}
    {multiple_p:text(select) {label "[_ assessment.Multiple]"} {options $boolean_options} {help_text "[_ assessment.Multiple_help]"}}
    {label_orientation:text(select) {label "[_ assessment.Label_Orientation]"} {options $label_or_types} {help_text "[_ assessment.Label_Orientation_help]"}}
    {order_type:text(select) {label "[_ assessment.Order_Type]"} {options $order_types} {help_text "[_ assessment.Order_Type_help]"}}
    {answer_alignment:text(select) {label "[_ assessment.Answer_Alignment]"} {options $alignment_types} {help_text "[_ assessment.Answer_Alignment_help]"}}
} -edit_request {
    set html_options ""
    set multiple_p f
    set label_orientation "top"
    set order_type "order_of_entry"
    set answer_alignment "besideright"
} -edit_data {
    db_transaction {
	set as_item_display_id [as::item_display_sb::new \
				    -html_display_options $html_options \
				    -multiple_p $multiple_p \
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
