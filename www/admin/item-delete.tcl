ad_page_contract {
    Confirmation form to remove an item from a section.

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

set page_title "[_ assessment.remove_item]"
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]

set confirm_options [list [list "[_ assessment.continue_with_remove]" t] [list "[_ assessment.cancel_and_return]" f]]

ad_form -name item_delete_confirm -action item-delete -export { assessment_id section_id } -form {
    {as_item_id:key}
    {item_title:text(inform) {label "[_ assessment.remove_1]"}}
    {from:text(inform) {label "[_ assessment.from]"} {value $assessment_data(title)}}
    {confirmation:text(radio) {label " "} {options $confirm_options} {value f}}
} -select_query_name {item_title} -on_submit {
    if {$confirmation} {
	db_transaction {
	    set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	    
	    set new_section_id [as::section::new_revision -section_id $section_id]

	    db_dml update_section_in_assessment {}
	    db_1row get_sort_order_to_be_removed {}
	    db_dml remove_item_from_section {}
	    db_dml move_up_items {}
	}
    }
} -after_submit {
    ad_returnredirect [export_vars -base one-a {assessment_id}]
    ad_script_abort
}

ad_return_template
