ad_page_contract {

    Let user confirm consent string before starting assessment

    @author Timo Hentschel (timo@timohentschel.de)
    @date   2005-01-24
} {
    session_id:integer,notnull
    assessment_id:integer,notnull
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