ad_page_contract {

    This page lets the user add sections from the catalog to an assessment.

    @param  assessment_id integer specifying assessment

    @author timo@timohentschel.de
    @date   November 10, 2004
    @cvs-id $Id: 
} {
    assessment_id:integer
    after:integer
    {orderby:optional "title,asc"}
    {page:optional 1}
}

ad_require_permission $assessment_id admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}


set assessment_rev_id $assessment_data(assessment_rev_id)
set page_title "[_ assessment.add_existing_section_1]"
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] "[_ assessment.add_existing_section]"]

set bulk_actions [list "[_ assessment.Add_to_assessment]" section-add-existing-2]

# somehow this should be done in a better way...
if {$orderby == "title,desc"} {
    set orderby_clause "order by title desc"
} else {
    set orderby_clause "order by title asc"
}

list::create \
    -name sections \
    -key section_id \
    -pass_properties { assessment_id after } \
    -no_data "[_ assessment.None]" \
    -elements {
	title {
	    label "[_ assessment.Title]"
	    orderby "title"
	}
    } -bulk_actions $bulk_actions -bulk_action_export_vars { assessment_id after } \
    -filters {
	assessment_id {}
	after {}
    } -page_size 20 -page_query_name section_list


set orderby_clause [list::orderby_clause -orderby -name sections]
set page_clause [list::page_where_clause -and -name sections]

db_multirow sections unmapped_sections_to_assessment ""

ad_return_template
return
