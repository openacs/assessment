ad_page_contract {
    Confirmation form to copy an item of a section.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
    as_item_id:naturalnum,notnull
    after:integer
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

set page_title "[_ assessment.copy_item]"
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]

set confirm_options [list [list "[_ assessment.continue_with_copy]" t] [list "[_ assessment.cancel_and_return]" f]]

ad_form -name item_copy_confirm -action item-copy -export { assessment_id section_id after } -has_submit 1 -form {
    {as_item_id:key}
    {item_title:text(inform) {label "[_ assessment.copy_1]"}}
    {from:text(inform) {label "[_ assessment.from]"} {value $assessment_data(title)}}
    {title:text(textarea) {label "[_ assessment.item_Title]"} {html {rows 3 cols 80 maxlength 1000}} {help_text "[_ assessment.item_Title_help]"}}
    {description:text(textarea),optional {label "[_ assessment.Description]"} {html {rows 5 cols 80}} {help_text "[_ assessment.item_Description_help]"}}
    {field_name:text,optional,nospell {label "[_ assessment.Field_Name]"} {html {size 80 maxlength 500}} {help_text "[_ assessment.Field_Name_help]"}}
    {submit_ok:text(submit) {label "[_ acs-kernel.common_Copy]"}}
    {submit_cancel:text(submit) {label "[_ acs-kernel.common_Cancel]"}}
} -edit_request {
    db_1row item_data {}
} -on_submit {
    if {([info exists submit_ok] && $submit_ok ne "")} {
	db_transaction {
	    set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	    set section_id [as::section::latest -section_id $section_id -assessment_rev_id $new_assessment_rev_id]
	    set new_section_id [as::section::new_revision -section_id $section_id -assessment_id $assessment_id]
	    set as_item_id [as::item::latest -as_item_id $as_item_id -section_id $new_section_id]
	    set new_item_id [as::item::copy -as_item_id $as_item_id -title $title -description $description -field_name $field_name]

	    as::section::update_section_in_assessment\
                -old_section_id $section_id \
                -new_section_id $new_section_id \
                -new_assessment_rev_id $new_assessment_rev_id
	    db_dml move_down_items {}
	    incr after
	    db_dml insert_new_item {}
	}
    }
} -after_submit {
    ad_returnredirect [export_vars -base questions {assessment_id}]
    ad_script_abort
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
