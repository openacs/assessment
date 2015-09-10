ad_page_contract {
    Form to add/edit a section display type.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,optional
    display_type_id:naturalnum,optional
} -properties {
    context:onevalue
    page_title:onevalue
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

if {[info exists display_type_id]} {
    set page_title [_ assessment.edit_section_display]
} else {
    set page_title [_ assessment.add_new_section_display]
}

set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]
set package_id [ad_conn package_id]

set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]
set type $assessment_data(type)

set order_types [list]
foreach one_order_type [list alphabetical randomized order_of_entry] {
    lappend order_types [list "[_ assessment.$one_order_type]" $one_order_type]
}


ad_form -name section_display_form -action section-display-form -export { assessment_id section_id } -form {
    {display_type_id:key}
    {title:text {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.sect_disp_Title_help]"}}
    {description:text(textarea) {label "[_ assessment.Description]"} {html {rows 5 cols 80}} {help_text "[_ assessment.sect_disp_Description_help]"}}
    {num_items:integer,optional,nospell {label "[_ assessment.section_num_Items]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.sect_num_items_help]"}}
}

if { $type > 1} {
    ad_form -extend -name section_display_form -form {
    {adp_chunk:text(textarea),optional,nospell {label "[_ assessment.Section_Template]"} {html {rows 5 cols 80}} {help_text "[_ assessment.section_template_help]"}}
    {branched_p:text(select) {label "[_ assessment.section_Branched]"} {options $boolean_options} {help_text "[_ assessment.section_branched_help]"}}
    {back_button_p:text(select) {label "[_ assessment.Back_Button]"} {options $boolean_options} {help_text "[_ assessment.back_button_help]"}}
    {submit_answer_p:text(select) {label "[_ assessment.Submit_Answer]"} {options $boolean_options} {help_text "[_ assessment.submit_answer_help]"}}
    {sort_order_type:text(select) {label "[_ assessment.Section_Order]"} {options $order_types} {help_text "[_ assessment.section_order_help]"}}
    }
} else {
   ad_form -extend -name section_display_form -form {
    {adp_chunk:text(hidden) {value ""}}
    {branched_p:text(hidden) {value ""}}
    {back_button_p:text(hidden) {value ""}}
    {submit_answer_p:text(hidden) {value ""}}
    {sort_order_type:text(hidden) {value ""}}
    }
}
ad_form -extend -name section_display_form -new_request {
    set title ""
    set description ""
    set num_items ""
    set adp_chunk ""
    set branched_p f
    set back_button_p t
    set submit_answer_p f
    set sort_order_type order_of_entry
} -edit_request {
    db_1row section_display_data {}
} -on_submit {
    set section_id [as::section::latest -section_id $section_id -assessment_rev_id $assessment_data(assessment_rev_id)]
} -new_data {
    db_transaction {
	set display_id [as::section_display::new \
			    -title $title \
			    -description $description \
			    -num_items $num_items \
			    -adp_chunk $adp_chunk \
			    -branched_p $branched_p \
			    -back_button_p $back_button_p \
			    -submit_answer_p $submit_answer_p \
			    -sort_order_type $sort_order_type]

	# now update section and map display type
	db_dml add_display_to_section {}
    }
} -edit_data {
    db_transaction {
	set display_id [as::section_display::edit \
			    -display_type_id $display_type_id \
			    -title $title \
			    -description $description \
			    -num_items $num_items \
			    -adp_chunk $adp_chunk \
			    -branched_p $branched_p \
			    -back_button_p $back_button_p \
			    -submit_answer_p $submit_answer_p \
			    -sort_order_type $sort_order_type]

	# now update section and map display type
	db_dml add_display_to_section {}
    }
} -after_submit {
    ad_returnredirect [export_vars -base one-a {assessment_id}]
    ad_script_abort
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
