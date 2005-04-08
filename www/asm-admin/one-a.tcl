ad_page_contract {

    This page allows the admin to administer a single assessment.

    @param  assessment_id integer specifying assessment

    @author timo@timohentschel.de
    @date   September 28, 2004
    @cvs-id $Id: 
} {
    assessment_id:integer
    {context ""}
    {reg_p ""}
}
set is_reg_asm_p ""
set package_id [ad_conn package_id]
set p_title ""

permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin
set admin_p [acs_user::site_wide_admin_p]
# Get the assessment data
as::assessment::data -assessment_id $assessment_id
set context [list [list index [_ assessment.admin]] $assessment_data(title)]

set assessment_rev_id $assessment_data(assessment_rev_id)
set subsite_id [ad_conn subsite_id]
set url [apm_package_url_from_id $subsite_id]
set anonymous_p [db_string has_privilege {} -default "f"]
set read_p [permission::permission_p -object_id $assessment_id -privilege read -party_id -1]
set value [parameter::get -parameter AsmForRegisterId -package_id $subsite_id]

if { [string eq $assessment_id $value] } {
    set is_reg_asm_p "[_ assessment.reg_asm]"
}

if {[exists_and_not_null is_reg_asm_p]} {
    set p_title "[_ assessment.Reg_Assessment_title]"
} else {
    set p_title [_ assessment.One_Assessment_data]

}


if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set creation_date [util_AnsiDatetoPrettyDate $assessment_data(creation_date)]
set creator_link [acs_community_member_url -user_id $assessment_data(creation_user)]
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
			    -pretty_name $assessment_data(title) \
			    -url [export_vars -base one-a {assessment_id reg_p}] ]

db_multirow sections assessment_sections {} {
    if {[empty_string_p $points]} {
	set points 0
    }
    set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]
}

ad_return_template
