ad_page_contract {
    Confirmation form to remove an assessment.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:naturalnum,notnull
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

set assessment_rev_id $assessment_data(assessment_rev_id)
set page_title "[_ assessment.remove_assessment]"
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]

set confirm_options [list [list "[_ assessment.continue_with_remove]" t] [list "[_ assessment.cancel_and_return]" f]]

ad_form -name assessment_delete_confirm -action assessment-delete -form {
    {assessment_id:key}
    {assessment_title:text(inform) {label "[_ assessment.remove_1]"}}
    {confirmation:text(radio) {label " "} {options $confirm_options} {value t}}
} -select_query_name {assessment_title} \
-on_submit {
    if {$confirmation} {
	as::assessment::check::delete_assessment_checks -assessment_id $assessment_id
	as::assessment::delete -assessment_id $assessment_id
    }
} -after_submit {
    if {$confirmation} {
	ad_returnredirect .
	ad_script_abort
    } else {
	ad_returnredirect [export_vars -base one-a {assessment_id}]
	ad_script_abort
    }
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
