ad_page_contract {
    Confirmation form to copy an item of a section.

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

set page_title "[_ assessment.copy_item]"
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]

set confirm_options [list [list "[_ assessment.continue_with_copy]" t] [list "[_ assessment.cancel_and_return]" f]]

ad_form -name item_copy_confirm -action item-copy -export { assessment_id section_id after } -form {
    {as_item_id:key}
    {item_title:text(inform) {label "[_ assessment.copy_1]"}}
    {from:text(inform) {label "[_ assessment.from]"} {value $assessment_data(title)}}
    {name:text,optional {label "[_ assessment.Name]"} {help_text "[_ assessment.Name_help]"}}
    {confirmation:text(radio) {label " "} {options $confirm_options} {value f}}
} -edit_request {
    db_1row item_title {}
    set name ""
} -on_submit {
    if {$confirmation} {
	db_transaction {
	    set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	    set new_section_id [as::section::new_revision -section_id $section_id]
	    set new_item_id [as::item::copy -as_item_id $as_item_id -name $name]

	    db_dml update_section_in_assessment {}
	    db_dml move_down_items {}
	    incr after
	    db_dml insert_new_item {}
	}
    }
} -after_submit {
    ad_returnredirect [export_vars -base one-a {assessment_id}]
    ad_script_abort
}

ad_return_template
