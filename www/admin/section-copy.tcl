ad_page_contract {
    Confirmation form to copy a section of an assessment.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer
    section_id:integer
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

set page_title "[_ assessment.copy_section]"
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]

set confirm_options [list [list "[_ assessment.continue_with_copy]" t] [list "[_ assessment.cancel_and_return]" f]]

ad_form -name section_copy_confirm -action section-copy -export { assessment_id after } -form {
    {section_id:key}
    {section_title:text(inform) {label "[_ assessment.copy_1]"}}
    {from:text(inform) {label "[_ assessment.from]"} {value $assessment_data(title)}}
    {confirmation:text(radio) {label " "} {options $confirm_options} {value f}}
} -select_query_name {section_title} \
-on_submit {
    if {$confirmation} {
	db_transaction {
	    set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	    set new_section_id [as::section::copy -section_id $section_id]

	    db_dml move_down_sections {}
	    set sort_order [expr $after + 1]
	    db_dml add_section_to_assessment {}
	}
    }
} -after_submit {
    ad_returnredirect [export_vars -base one-a {assessment_id}]
    ad_script_abort
}

ad_return_template
