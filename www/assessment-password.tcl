ad_page_contract {

    This page asks for the assessment password

    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-02-20
} -query {
    assessment_id:integer,notnull
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set user_id [ad_conn user_id]
set page_title "[_ assessment.Password_Enter]"
set context_bar [ad_context_bar $page_title]

# Get the assessment data
as::assessment::data -assessment_id $assessment_id
permission::require_permission -object_id $assessment_id -privilege read

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set assessment_rev_id $assessment_data(assessment_rev_id)
set errors [as::assessment::check_session_conditions -assessment_id $assessment_rev_id -subject_id $user_id -password $assessment_data(password)]
if {![empty_string_p $errors]} {
    ad_return_complaint 1 $errors
    ad_script_abort
}


ad_form -name assessment_password -action assessment -form {
    {assessment_id:key}
    {password:text,nospell {label "[_ assessment.password]"} {html {size 20 maxlength 100}} {help_text "[_ assessment.as_password_user_help]"}}
} -edit_request {
}

ad_return_template
