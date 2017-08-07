ad_page_contract {

    This page allows the admin to administer a single assessment.

    @param  assessment_id integer specifying assessment

    @author timo@timohentschel.de
    @date   September 28, 2004
    @cvs-id $Id: 
} {
    assessment_id:naturalnum,notnull
    {context ""}
    {reg_p:boolean ""}
    {asm_instance ""}
    {reg_url ""}
}

set package_id [ad_conn package_id]

permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id
set title [as::assessment::title -title $assessment_data(title)]
set p_title [_ assessment.One_Assessment_data]
set context [list [list index [_ assessment.admin]] $title]

set assessment_rev_id $assessment_data(assessment_rev_id)
set subsite_id [subsite::main_site_id]
set registration_id [parameter::get -parameter RegistrationId -package_id $subsite_id]
set url [apm_package_url_from_id $subsite_id]

set admin_p [acs_user::site_wide_admin_p]
set anonymous_p [db_string has_privilege {} -default "f"]
set read_p [permission::permission_p -object_id $assessment_id -privilege read -party_id -1]

set creation_date [util_AnsiDatetoPrettyDate $assessment_data(creation_date)]
set creator_url [acs_community_member_url -user_id $assessment_data(creation_user)]
set history_url [export_vars -base assessment-history {assessment_id}]
set edit_url [export_vars -base assessment-form {assessment_id}]
set toggle_publish_url [export_vars -base toggle-publish {assessment_id}]
set toggle_type_url [export_vars -base toggle-type {assessment_id}]
set toggle_anon_url [export_vars -base toggle-boolean {assessment_id {param anonymous_p}}]
set toggle_secure_url [export_vars -base toggle-boolean {assessment_id {param secure_access_p}}]
set toggle_reuse_url [export_vars -base toggle-boolean {assessment_id {param reuse_responses_p}}]
set toggle_show_name_url [export_vars -base toggle-boolean {assessment_id {param show_item_name_p}}]
set sessions_url [export_vars -base sessions {assessment_id}]
set results_url [export_vars -base results-users {assessment_id}]
set export_url [export_vars -base results-export {assessment_id}]

if { ([info exists asm_instance] && $asm_instance ne "")} {
    set reg_url "[apm_package_url_from_id $asm_instance]admin"
} else {
    set reg_url "../admin"
} 

if { $assessment_id eq $registration_id } {
    # This is the user-registration assessment
    set is_reg_asm_p 1
    set p_title "[_ assessment.Reg_Assessment_title]"
} else {
    set p_title [_ assessment.One_Assessment_data]
}

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

if {$assessment_data(number_tries) > 0} {
    set response_limit_toggle "[_ assessment.allow_multiple]"
} else {
    set response_limit_toggle "[_ assessment.allow_tries]"
}

# allow site-wide admins to enable/disable assessments directly from here
set target "[export_vars -base one-a {assessment_id reg_p}]"

set notification_chunk [notification::display::request_widget \
			    -type assessment_response_notif \
			    -object_id $assessment_id \
			    -pretty_name   $title \
			    -url [ad_return_url] ]

db_multirow -extend { section_url } sections assessment_sections {} {
    if {$points eq ""} {
	set points 0
    }
    set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]
    set section_url [export_vars -base one-section {assessment_id section_id}]
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
