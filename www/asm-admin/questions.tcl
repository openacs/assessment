ad_page_contract {

    Admin view of one assessment's questions.

    @param  assessment_id integer specifying assessment

    @author vinod@solutiongrove.com
    @creation-date   January 15, 2007

} {
    assessment_id:naturalnum,notnull
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin
set admin_trigger_p [acs_user::site_wide_admin_p -user_id [ad_conn user_id]]
set title "Questions"
set context [list [list index [_ assessment.admin]] $title]
set tab "questions"

# get assessment data
as::assessment::data -assessment_id $assessment_id
set assessment_rev_id $assessment_data(assessment_rev_id)

db_multirow -extend { section_url section_form_edit_url section_form_add_url catalog_section_url section_display_form_url section_preview_url section_delete_url checks_admin_url add_edit_section_check_url section_swap_down_url section_swap_up_url } sections sections_query {} {
    set section_url [export_vars -base one-section {assessment_id section_id}]

    # Build URLs
    set section_form_edit_url [export_vars -base section-form {section_id assessment_id}]
    set section_form_add_url [export_vars -base section-form {assessment_id {after $sort_order}}]
    set catalog_section_url [export_vars -base catalog-search {assessment_id {after $sort_order}}]
    set section_display_form_url [export_vars -base section-display-form {assessment_id section_id display_type_id}]
    set section_preview_url [export_vars -base section-preview {assessment_id section_id}]
    set section_delete_url [export_vars -base section-delete {section_id assessment_id}]
    set checks_admin_url [export_vars -base checks-admin {assessment_id section_id}]
    set add_edit_section_check_url [export_vars -base add-edit-section-checks {assessment_id section_id}]
    set section_swap_down_url [export_vars -base section-swap {assessment_id section_id {direction down} sort_order}]
    set section_swap_up_url [export_vars -base section-swap {assessment_id section_id {direction up} sort_order}]
}


set max_sort_order [db_string max_sort_order {}]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
