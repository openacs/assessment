ad_page_contract {
    Form to edit an item with textarea display.

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

set page_title [_ assessment.edit_item_display_ta]
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] [list [export_vars -base item-edit {assessment_id section_id as_item_id}] [_ assessment.edit_item]] $page_title]

set alignment_types [list]
foreach alignment_type [list besideleft besideright below above] {
    lappend alignment_types [list "[_ assessment.$alignment_type]" $alignment_type]
}


ad_form -name item_edit_display_ta -action item-edit-display-ta -export { assessment_id section_id } -form {
    {as_item_id:key}
    {html_display_options:text,optional {label "[_ assessment.Html_Options]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.Html_Options_help]"}}
    {abs_size:text {label "[_ assessment.Absolute_Size]"} {html {size 5 maxlength 5}} {help_text "[_ assessment.Absolute_Size_help]"}}
    {item_answer_alignment:text(select) {label "[_ assessment.Answer_Alignment]"} {options $alignment_types} {help_text "[_ assessment.Answer_Alignment_help]"}}
    {as_item_display_id:text(hidden)}
} -edit_request {
    db_1row last_used_display_type {}
    if {![empty_string_p $as_item_display_id]} {
	db_1row display_type_data {}
    } else {
	# default data if display newly mapped
	set html_display_options ""
	set abs_size 1000
	set item_answer_alignment "besideright"
	set as_item_display_id 0
    }
} -edit_data {
    db_transaction {
	set new_item_id [as::item::new_revision -as_item_id $as_item_id]

	if {$as_item_display_id} {
	    # edit existing display type
	    set new_item_display_id [as::item_display_ta::edit \
					 -as_item_display_id $as_item_display_id \
					 -html_display_options $html_display_options \
					 -abs_size $abs_size \
					 -acs_widget "" \
					 -item_answer_alignment $item_answer_alignment]
	} else {
	    # create new display type
	    set new_item_display_id [as::item_display_ta::new \
					 -html_display_options $html_display_options \
					 -abs_size $abs_size \
					 -acs_widget "" \
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
