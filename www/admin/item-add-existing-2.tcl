ad_page_contract {

    This page adds items from the catalog to a section.

    @param  assessment_id integer specifying assessment
    @param  section_id integer specifying section

    @author timo@timohentschel.de
    @date   November 10, 2004
    @cvs-id $Id: 
} {
    assessment_id:integer
    section_id:integer
    after:integer
    as_item_id:integer,multiple
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
    set new_section_id [as::section::new_revision -section_id $section_id]
    db_dml update_section_in_assessment {}

    foreach item_id $as_item_id {
	incr after
	db_dml add_item_to_section {}
    }
}

ad_returnredirect [export_vars -base one-a {assessment_id}]
