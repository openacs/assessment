ad_page_contract {
    Form to edit a short answer item.

    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)

} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
    as_item_id:naturalnum,notnull
} -properties {
    context:onevalue
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

set page_title [_ assessment.edit_item_type_fu]
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] [list [export_vars -base item-edit {assessment_id section_id as_item_id}] [_ assessment.edit_item]] $page_title]

set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]


ad_form -name item_edit_fu -action item-edit-fu -export { assessment_id section_id } -form {
    {as_item_id:key}
    {title:text {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.oq_Title_help]"}}
} -edit_request {
    db_1row item_type_data {}
} -edit_data {
    db_transaction {
	set new_item_id [as::item::new_revision -as_item_id $as_item_id]
	set as_item_type_id [db_string item_type_id {}]
	set new_item_type_id [as::item_type_fu::edit \
				  -as_item_type_id $as_item_type_id \
				  -title $title]

	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	set section_id [as::section::latest -section_id $section_id -assessment_rev_id $new_assessment_rev_id]
	set new_section_id [as::section::new_revision -section_id $section_id -assessment_id $assessment_id]
	set as_item_id [as::item::latest -as_item_id $as_item_id -section_id $new_section_id]
	as::section::update_section_in_assessment\
                -old_section_id $section_id \
                -new_section_id $new_section_id \
                -new_assessment_rev_id $new_assessment_rev_id
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

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
