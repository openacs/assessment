ad_page_contract {

    This page adds the sections the user selected for insertion into assessment.

    @param  assessment_id integer specifying assessment
    @param  section_id list of integers specifying sections

    @author timo@timohentschel.de
    @date   2004-12-08
    @cvs-id $Id: 
} {
    assessment_id:naturalnum,notnull
    after:integer
    section_id:naturalnum,multiple,optional
    section_ids:optional
} -properties {
    title:onevalue
    context:onevalue
    sections:multirow
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set page_title "[_ assessment.Search_Section_1]"
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] "[_ assessment.Search_Section]"]

if {[info exists section_id]} {
    set section_ids $section_id
}

set confirm_options [list [list "[_ assessment.continue_with_insert]" t] [list "[_ assessment.cancel_and_return]" f]]

ad_form -name catalog_section_add -action catalog-section-add -export { section_ids after } -form {
    {assessment_id:key}
    {to:text(inform) {label "[_ assessment.Add_Sections]"} {value $assessment_data(title)}}
    {confirmation:text(radio) {label " "} {options $confirm_options} {value t}}
} -edit_request {
} -on_submit {
    if {$confirmation} {
	db_transaction {
	    set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]

	    set section_count [llength $section_ids]
	    db_dml move_down_sections {}
	    foreach section_id $section_ids {
		incr after
		db_dml add_section_to_assessment {}
	    }
	}
    }
} -after_submit {
    ad_returnredirect [export_vars -base one-a {assessment_id}]
    ad_script_abort
}


db_multirow sections sections {} {
    if {$points eq ""} {
	set points 0
    }
    set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
