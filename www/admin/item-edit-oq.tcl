ad_page_contract {
    Form to edit an open question item.

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

permission::permission_p -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set page_title [_ assessment.edit_item_type_oq]
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] [list [export_vars -base item-edit {assessment_id section_id as_item_id}] [_ assessment.edit_item]] $page_title]


ad_form -name item_edit_oq -action item-edit-oq -export { assessment_id section_id } -form {
    {as_item_id:key}
    {title:text {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.oq_Title_help]"}}
    {default_value:text(textarea),optional {label "[_ assessment.Default_Value]"} {html {rows 5 cols 80}} {help_text "[_ assessment.Deafult_Value_help]"}}
    {feedback_text:text(textarea),optional {label "[_ assessment.Feedback]"} {html {rows 5 cols 80}} {help_text "[_ assessment.Feedback_help]"}}
} -edit_request {
    db_1row item_type_data {}
} -edit_data {
    db_transaction {
	set new_item_id [as::item::new_revision -as_item_id $as_item_id]
	set as_item_type_id [db_string item_type_id {}]
	set new_item_type_id [as::item_type_oq::edit \
				  -as_item_type_id $as_item_type_id \
				  -title $title \
				  -default_value $default_value \
				  -feedback_text $feedback_text]

	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	set new_section_id [as::section::new_revision -section_id $section_id]
	db_dml update_section_in_assessment {}
	db_dml update_item_in_section {}
	db_dml update_item_type {}
    }
    set as_item_id $new_item_id
    set section_id $new_section_id
} -after_submit {
    ad_returnredirect [export_vars -base "item-edit" {assessment_id section_id as_item_id}]
    ad_script_abort
}

ad_return_template
