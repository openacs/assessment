ad_page_contract {

    Let user confirm consent string before starting assessment

    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date   2005-01-24
} {
    session_id:naturalnum,notnull
    assessment_id:naturalnum,notnull
    {password:optional ""}
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set page_title "[_ assessment.Confirm_Consent]"
set context_bar [ad_context_bar $page_title]

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
