ad_page_contract {
    Form to add the choice data of a multiple choice item.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:naturalnum,notnull
    as_item_id:naturalnum,notnull
    mc_id:naturalnum,notnull
    return_url:localurl
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

set package_id [ad_conn package_id]
set type $assessment_data(type)
set page_title [_ assessment.Save_answer_set]
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]



set selected_options [list [list "[_ assessment.yes]" t]]

ad_form -name save-answer-set -export { assessment_id as_item_id mc_id return_url } -form {
    {answer_set_title:text {label "[_ assessment.Title]"} {help_text "[_ assessment.answer_set_title_help_text]"} {html {size 60}}}
} -on_submit {
    # update mc title
    db_dml update_mc_title ""
} -after_submit {
    # now go to display-type specific form (i.e. textbox)
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
