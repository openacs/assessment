ad_page_contract {
    Form to add/edit a section.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer
    section_id:integer,optional
    after:integer,optional
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

if {[info exists section_id]} {
    set page_title [_ assessment.edit_section]
} else {
    set page_title [_ assessment.add_new_section]
}

set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]

set display_types [db_list_of_lists section_display_types {}]
set display_types [concat [list [list "" ""]] $display_types]


ad_form -name section_form -action section-form -export { assessment_id after } -form {
    {section_id:key}
}

if {[exists_and_not_null after]} {
    ad_form -extend -name section_form -form {
	{name:text {label "[_ assessment.Name]"} {html {size 40 maxlength 400}}}
    }
}

set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]

ad_form -extend -name section_form -form {
    {title:text {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}}}
    {description:text(textarea) {label "[_ assessment.Description]"} {html {rows 5 cols 80}}}
    {definition:text(textarea),optional {label "[_ assessment.Definition]"} {html {rows 5 cols 80}}}
    {instructions:text(textarea),optional {label "[_ assessment.Instructions]"} {html {rows 5 cols 80}}}
    {feedback_text:text(textarea),optional {label "[_ assessment.Feedback]"} {html {rows 5 cols 80}}}
    {max_time_to_complete:integer,optional {label "[_ assessment.time_for_completion]"} {html {size 10 maxlength 10}}}
    {section_display_type_id:text(select),optional {label "[_ assessment.Display_Type]"} {options $display_types}}
    {required_p:text(select) {label "[_ assessment.Required]"} {options $boolean_options}}
} -new_request {
    set title ""
    set description ""
    set definition ""
    set instructions ""
    set feedback_text ""
    set max_time_to_complete ""
    set section_display_type_id ""
    set required_p t
} -edit_request {
    db_1row section_data {}
} -new_data {
    db_transaction {
	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]

	set section_id [as::section::new \
			    -title $title \
			    -description $description \
			    -definition $definition \
			    -instructions $instructions \
			    -feedback_text $feedback_text \
			    -max_time_to_complete $max_time_to_complete \
			    -required_p $required_p \
			    -section_display_type_id $section_display_type_id]

	db_dml move_down_sections {}
	set sort_order [expr $after + 1]
	db_dml add_section_to_assessment {}
    }
} -edit_data {
    db_transaction {
	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]

	set new_section_id [as::section::edit \
				-section_id $section_id \
				-title $title \
				-description $description \
				-definition $definition \
				-instructions $instructions \
				-feedback_text $feedback_text \
				-max_time_to_complete $max_time_to_complete \
				-required_p $required_p \
				-section_display_type_id $section_display_type_id]

	db_dml update_section_of_assessment {}
    }
} -after_submit {
    ad_returnredirect [export_vars -base one-a {assessment_id}]
    ad_script_abort
}

ad_return_template
