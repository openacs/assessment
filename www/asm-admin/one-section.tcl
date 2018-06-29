ad_page_contract {

    Admin view of one section.

    @param  assessment_id integer specifying assessment
    @param  section_id integer specifying section

    @author vinod@solutiongrove.com
    @creation-date   October 28, 2006

} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin
set title "vkSection Title"
set context [list [list index [_ assessment.admin]] $title]

# get assessment data
as::assessment::data -assessment_id $assessment_id
set assessment_rev_id $assessment_data(assessment_rev_id)

db_1row section_query {}

set max_sort_order [db_string max_sort_order {}]

if {$points eq ""} {
    set points 0
}
set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]
set section_url [export_vars -base one-section {assessment_id section_id}]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
