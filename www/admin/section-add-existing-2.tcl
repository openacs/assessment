ad_page_contract {

    This page adds sections from the catalog to an assessment.

    @param  assessment_id integer specifying assessment

    @author timo@timohentschel.de
    @date   November 10, 2004
    @cvs-id $Id: 
} {
    assessment_id:integer
    after:integer
    section_id:integer,multiple
}

ad_require_permission $assessment_id admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

db_transaction {
    set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]

    foreach sect_id $section_id {
	incr after
	db_dml add_section_to_assessment {}
    }
}

ad_returnredirect [export_vars -base one-a {assessment_id}]
