ad_page_contract {

    This page adds the sections the user selected for insertion into assessment.

    @param  assessment_id integer specifying assessment
    @param  section_id integer specifying section
    @param  as_item_id list of integers specifying items

    @author timo@timohentschel.de
    @date   2004-12-08
    @cvs-id $Id: 
} {
    assessment_id:integer
    section_id:integer
    after:integer
    as_item_id:integer,multiple,optional
    item_ids:optional
}

permission::permission_p -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

db_1row section_title {}
set page_title "[_ assessment.Search_Item_1]"
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] "[_ assessment.Search_Item]"]

if {[info exists as_item_id]} {
    set item_ids $as_item_id
}

set confirm_options [list [list "[_ assessment.continue_with_insert]" t] [list "[_ assessment.cancel_and_return]" f]]

ad_form -name catalog_item_add -action catalog-item-add -export { assessment_id item_ids after } -form {
    {section_id:key}
    {to:text(inform) {label "[_ assessment.Add_Items]"} {value $section_title}}
    {confirmation:text(radio) {label " "} {options $confirm_options} {value f}}
} -edit_request {
} -on_submit {
    if {$confirmation} {
	db_transaction {
	    set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	    set new_section_id [as::section::new_revision -section_id $section_id]

	    set item_count [llength $item_ids]
	    db_dml update_section_in_assessment {}
	    db_dml move_down_items {}

	    foreach as_item_id $item_ids {
		incr after
		db_dml add_item_to_section {}
	    }
	}
    }
} -after_submit {
    ad_returnredirect [export_vars -base one-a {assessment_id}]
    ad_script_abort
}


ad_form -name show_items -form {
    {section_id:text(hidden) {value $section_id}}
}

db_multirow -extend { presentation_type html } items items {} {
    set presentation_type [as::item_form::add_item_to_form -name show_items -section_id $section_id -item_id $as_item_id]
    if {$presentation_type == "fitb"} {
        regsub -all -line -nocase -- {<textbox as_item_choice_id=} $title "<input name=response_to_item.${as_item_id}_" html
    }
    if {[empty_string_p $points]} {
	set points 0
    }
    set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]
}

ad_return_template
