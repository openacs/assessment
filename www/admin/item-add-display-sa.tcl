ad_page_contract {
    Form to add an item with shortanswer display.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer
    section_id:integer
    as_item_id:integer
    after:integer
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

ad_require_permission $assessment_id admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set page_title [_ assessment.add_item_display_sa]
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]


set orientation_types [list]
foreach orientation_type [list horizontal vertical] {
    lappend orientation_types [list "[_ assessment.$orientation_type]" $orientation_type]
}


ad_form -name item_add_display_sa -action item-add-display-sa -export { assessment_id section_id after } -form {
    {as_item_id:key}
    {html_options:text,optional {label "[_ assessment.Html_Options]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.Html_Options_help]"}}
    {abs_size:text {label "[_ assessment.Absolute_Size]"} {html {size 5 maxlength 5}} {help_text "[_ assessment.Absolute_Size_help]"}}
    {box_orientation:text(select) {label "[_ assessment.Box_Orientation]"} {options $orientation_types} {help_text "[_ assessment.Box_Orientation_help]"}}
} -edit_request {
    set html_options ""
    set abs_size 5
    set box_orientation "vertical"
} -edit_data {
    db_transaction {
	set as_item_display_id [as::item_display_sa::new \
				    -html_display_options $html_options \
				    -abs_size $abs_size \
				    -box_orientation $box_orientation]
	
	as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_display_id -type as_item_display_rel

	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	set new_section_id [as::section::new_revision -section_id $section_id]
	db_dml update_section_in_assessment {}
	db_dml move_down_items {}
	incr after
	db_dml insert_new_item {}
    }
} -after_submit {
    # now go to assessment-page
    ad_returnredirect [export_vars -base one-a {assessment_id}]
    ad_script_abort
}

ad_return_template
