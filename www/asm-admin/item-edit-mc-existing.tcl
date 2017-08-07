ad_page_contract {
    Form to edit a multiple choice item.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
    as_item_id:naturalnum,notnull
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set page_title [_ assessment.add_item_type_mc_existing]
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]
set folder_id [as::assessment::folder_id -package_id $package_id]

set choice_sets [db_list_of_lists existing_choice_sets {}]


ad_form -name item_edit_mc_existing -action item-edit-mc-existing -export { assessment_id section_id } -form {
    {as_item_id:key}
    {mc_id:text(select),optional {label "[_ assessment.Choice_Sets]"} {options $choice_sets} {help_text "[_ assessment.Choice_Sets_help]"}}
} -edit_request {
    set mc_id ""
} -edit_data {
    db_transaction {
	set new_item_id [as::item::new_revision -as_item_id $as_item_id]
	set as_item_type_id [db_string item_type_id {}]

	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	set section_id [as::section::latest -section_id $section_id -assessment_rev_id $new_assessment_rev_id]
	set new_section_id [as::section::new_revision -section_id $section_id -assessment_id $assessment_id]
	set as_item_id [as::item::latest -as_item_id $as_item_id -section_id $new_section_id]
	as::assessment::check::copy_item_checks -assessment_id $assessment_id -section_id $new_section_id -as_item_id $as_item_id -new_item_id $new_item_id

	as::section::update_section_in_assessment\
                -old_section_id $section_id \
                -new_section_id $new_section_id \
                -new_assessment_rev_id $new_assessment_rev_id
	db_dml update_item_in_section {}
	db_dml update_item_type {}
    }
} -after_submit {
    ad_returnredirect [export_vars -base item-edit {assessment_id section_id as_item_id}]
    ad_script_abort
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
