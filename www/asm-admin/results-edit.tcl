ad_page_contract {
    Form to edit the points awarded to an item response.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    session_id:integer
    section_id:integer
    as_item_id:integer
} -properties {
    context:onevalue
    page_title:onevalue
}

db_1row find_assessment {}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id
#set assessment_rev_id $assessment_data(assessment_rev_id)

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

db_1row get_item_data {}
set item_type [string range $item_type end-1 end]
set result_points [db_string result_points {} -default ""]

set page_title "[_ assessment.Results_edit]"
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] [list [export_vars -base results-users {assessment_id}] [_ assessment.Results_by_user]] [list [export_vars -base results-session {session_id}] [_ assessment.View_Results]] $page_title]


ad_form -name results_edit -action results-edit -export { session_id section_id as_item_id } -form {
    {result_id:key}
    {title:text,nospell,optional {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.Results_edit_Title_help]"}}
    {description:text(textarea),optional {label "[_ assessment.Results_edit_Description]"} {html {rows 5 cols 80}} {help_text "[_ assessment.Results_edit_Description_help]"}}
    {points:integer,nospell {label "[_ assessment.points_answer]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.points_answer_help]"}}
} -new_request {
    set title ""
    set description ""
    set points ""
} -new_data {
    db_transaction {
	as::session_results::new -target_id $item_data_id -title $title -description $description -points $points
	db_dml update_item_data {}
	as::section::calculate -section_id $section_id -assessment_id $assessment_rev_id -session_id $session_id
	as::assessment::calculate -assessment_id $assessment_rev_id -session_id $session_id
    }
} -after_submit {
    ad_returnredirect [export_vars -base results-session {session_id}]
    ad_script_abort
}

ad_return_template
