ad_page_contract {
    Form to edit an item with shortanswer display.

    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @cvs-id $Id:
} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
    as_item_id:naturalnum,notnull
} -properties {
    context_bar:onevalue
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

set page_title [_ assessment.edit_item_display_f]
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] [list [export_vars -base item-edit {assessment_id section_id as_item_id}] [_ assessment.edit_item]] $page_title]

set orientation_types [list]
foreach orientation_type [list horizontal vertical] {
    lappend orientation_types [list "[_ assessment.$orientation_type]" $orientation_type]
}


ad_form -name item_edit_display_f -action item-edit-display-f -export { assessment_id section_id } -form {
    {as_item_id:key}
    {html_display_options:text,optional,nospell {label "[_ assessment.Html_Options]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.Html_Options_help]"}}
    {abs_size:text,nospell {label "[_ assessment.Absolute_Size]"} {html {size 5 maxlength 5}} {help_text "[_ assessment.Absolute_Size_help]"}}
    {box_orientation:text(select) {label "[_ assessment.Box_Orientation]"} {options $orientation_types} {help_text "[_ assessment.Box_Orientation_help]"}}
    {as_item_display_id:text(hidden)}
} -edit_request {
    db_1row last_used_display_type {}
    if {$as_item_display_id ne ""} {
	db_1row display_type_data {}
    } else {
	# default data if display newly mapped
	set html_display_options ""
	set abs_size 5
	set box_orientation "vertical"
	set as_item_display_id 0
    }
} -validate {
    {html_display_options {[as::assessment::check_html_options -options $html_display_options]} "[_ assessment.error_html_options]"}
} -edit_data {
    db_transaction {
	set new_item_id [as::item::new_revision -as_item_id $as_item_id]

	if {$as_item_display_id} {
	    # edit existing display type
	    set new_item_display_id [as::item_display_f::edit \
					 -as_item_display_id $as_item_display_id \
					 -html_display_options $html_display_options \
					 -abs_size $abs_size \
					 -box_orientation $box_orientation]
	} else {
	    # create new display type
	    set new_item_display_id [as::item_display_f::new \
					 -html_display_options $html_display_options \
					 -abs_size $abs_size \
					 -box_orientation $box_orientation]
	}

	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	set section_id [as::section::latest -section_id $section_id -assessment_rev_id $new_assessment_rev_id]
	set new_section_id [as::section::new_revision -section_id $section_id -assessment_id $assessment_id]
	set as_item_id [as::item::latest -as_item_id $as_item_id -section_id $new_section_id]
	as::section::update_section_in_assessment\
                -old_section_id $section_id \
                -new_section_id $new_section_id \
                -new_assessment_rev_id $new_assessment_rev_id
	db_dml update_item_in_section {}
	db_dml update_display_of_item {}
    }
    set as_item_id $new_item_id
    set section_id $new_section_id
} -after_submit {
    ad_returnredirect [export_vars -base "item-edit" {assessment_id section_id as_item_id}]
    ad_script_abort
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
