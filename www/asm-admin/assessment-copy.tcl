ad_page_contract {
    Confirmation form to copy an assessment.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:naturalnum,notnull
} -properties {
    context:onevalue
    page_title:onevalue
}

set package_id [ad_conn package_id]
set user_id [ad_conn untrusted_user_id]

permission::require_permission -object_id $package_id -privilege create

permission::require_permission -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set assessment_rev_id $assessment_data(assessment_rev_id)
set page_title "[_ assessment.copy_assessment]"
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]

set confirm_options [list [list "[_ assessment.continue_with_copy]" t] [list "[_ assessment.cancel_and_return]" f]]
set node_options [db_list_of_lists assessment_instances {}]

ad_form -name assessment_copy_confirm -action assessment-copy -form {
    {assessment_id:key}
    {assessment_title:text(inform) {label "[_ assessment.copy_1]"}}
    {name:text,optional {label "[_ assessment.Name]"} {help_text "[_ assessment.Name_help]"}}
    {new_title:text,optional {label "[_ assessment.Title]"} {help_text "[_ assessment.as_Title_help]"}}
    {node_id:text(select) {label "[_ assessment.Target_Community]"} {options $node_options} {help_text "[_ assessment.Target_Community_help]"}}
    {confirmation:text(radio) {label " "} {options $confirm_options} {value f}}
} -edit_request {
    db_1row assessment_title {}
    set name ""
    set node_id [site_node::get_node_id -url [ad_conn url]]
} -on_submit {
    if {$confirmation} {
	set folder_id [as::assessment::folder_id -package_id [site_node::get_object_id -node_id $node_id]]
	set assessment_id [as::assessment::copy -assessment_id $assessment_id -name $name -folder_id $folder_id -new_title $new_title]
    }
    permission::grant -party_id $user_id -object_id $assessment_id -privilege admin
} -after_submit {
    ad_returnredirect "[site_node::get_url -node_id $node_id][export_vars -base "asm-admin/one-a" {assessment_id}]"
    ad_script_abort
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
