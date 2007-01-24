ad_page_contract {

    Admin view of one assessment's questions.

    @param  assessment_id integer specifying assessment

    @author vinod@solutiongrove.com
    @date   January 15, 2007

} {
    assessment_id:integer
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin
set title "Questions"
set context [list [list index [_ assessment.admin]] $title]
set tab "questions"

# get assessment data
as::assessment::data -assessment_id $assessment_id
set assessment_rev_id $assessment_data(assessment_rev_id)

db_multirow -extend { section_url } sections sections_query {} {
    set section_url [export_vars -base one-section {assessment_id section_id}]
}

set max_sort_order [db_string max_sort_order {}]

ad_return_template
