ad_page_contract {

    Let user confirm consent string before starting assessment

    @author Timo Hentschel (timo@timohentschel.de)
    @date   2005-01-24
} {
    session_id:integer,notnull
    assessment_id:integer,notnull
    {password:optional ""}
    {next_asm:optional}
} -properties {
    context:onevalue
    page_title:onevalue
}

set page_title "[_ assessment.Confirm_Consent]"
set context [list $page_title]

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

ad_return_template
