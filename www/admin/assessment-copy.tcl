ad_page_contract {
    Confirmation form to copy an assessment.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer
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

set assessment_rev_id $assessment_data(assessment_rev_id)
set page_title "[_ assessment.copy_assessment]"
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]

set confirm_options [list [list "[_ assessment.continue_with_copy]" t] [list "[_ assessment.cancel_and_return]" f]]

ad_form -name assessment_copy_confirm -action assessment-copy -form {
    {assessment_id:key}
    {assessment_title:text(inform) {label "[_ assessment.copy_1]"}}
    {name:text,optional {label "[_ assessment.Name]"} {help_text "[_ assessment.Name_help]"}}
    {confirmation:text(radio) {label " "} {options $confirm_options} {value f}}
} -edit_request {
    db_1row assessment_title {}
    set name ""
} -on_submit {
    if {$confirmation} {
	set assessment_id [as::assessment::copy -assessment_id $assessment_id -name $name]
    }
} -after_submit {
    ad_returnredirect [export_vars -base one-a {assessment_id}]
    ad_script_abort
}

ad_return_template
