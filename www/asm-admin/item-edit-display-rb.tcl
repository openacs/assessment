ad_page_contract {
    Form to edit an item with radiobutton display.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
    as_item_id:naturalnum,notnull
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

set page_title [_ assessment.edit_item_display_rb]
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] [list [export_vars -base item-edit {assessment_id section_id as_item_id}] [_ assessment.edit_item]] $page_title]

set choice_or_types [list]
foreach choice_or_type [list horizontal vertical] {
    lappend choice_or_types [list "[_ assessment.$choice_or_type]" $choice_or_type]
}

set label_or_types [list]
foreach label_or_type [list top left right bottom] {
    lappend label_or_types [list "[_ assessment.$label_or_type]" $label_or_type]
}

set order_types [list]
foreach one_order_type [list alphabetical randomized order_of_entry] {
    lappend order_types [list "[_ assessment.$one_order_type]" $one_order_type]
}

set alignment_types [list]
foreach alignment_type [list besideleft besideright below above] {
    lappend alignment_types [list "[_ assessment.$alignment_type]" $alignment_type]
}


ad_form -name item_edit_display_rb -action item-edit-display-rb -export { assessment_id section_id } -form {
    {as_item_id:key}
    {html_display_options:text,optional,nospell {label "[_ assessment.Html_Options]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.Html_Options_help]"}}
    {choice_orientation:text(select) {label "[_ assessment.Choice_Orientation]"} {options $choice_or_types} {help_text "[_ assessment.Choice_Orientation_help]"}}
    {choice_label_orientation:text(hidden)}
    {sort_order_type:text(select) {label "[_ assessment.Order_Type]"} {options $order_types} {help_text "[_ assessment.Order_Type_help]"}}
    {item_answer_alignment:text(hidden)}
    {as_item_display_id:text(hidden)}
} -edit_request {
    db_1row last_used_display_type {}
    if {$as_item_display_id ne ""} {
	db_1row display_type_data {}
    } else {
	# default data if display newly mapped
	set html_display_options ""
	set choice_orientation "vertical"
	set choice_label_orientation "top"
	set sort_order_type "order_of_entry"
	set item_answer_alignment "besideright"
	set as_item_display_id 0
    }
} -validate {
    {html_display_options {[as::assessment::check_html_options -options $html_display_options]} "[_ assessment.error_html_options]"}
} -edit_data {
    db_transaction {
	set new_item_id [as::item::new_revision -as_item_id $as_item_id]

	if {$as_item_display_id} {
	    # edit existing display type
	    set new_item_display_id [as::item_display_rb::edit \
					 -as_item_display_id $as_item_display_id \
					 -html_display_options $html_display_options \
					 -choice_orientation $choice_orientation \
					 -choice_label_orientation $choice_label_orientation \
					 -sort_order_type $sort_order_type \
					 -item_answer_alignment $item_answer_alignment]
	} else {
	    # create new display type
	    set new_item_display_id [as::item_display_rb::new \
					 -html_display_options $html_display_options \
					 -choice_orientation $choice_orientation \
					 -choice_label_orientation $choice_label_orientation \
					 -sort_order_type $sort_order_type \
					 -item_answer_alignment $item_answer_alignment]
	}

	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	set section_id [as::section::latest -section_id $section_id -assessment_rev_id $new_assessment_rev_id]
	set new_section_id [as::section::new_revision -section_id $section_id -assessment_id $assessment_id]
	set as_item_id [as::item::latest -as_item_id $as_item_id -section_id $new_section_id]
	as::assessment::check::copy_item_checks -assessment_id $assessment_id -section_id $new_section_id -as_item_id $as_item_id -new_item_id $new_item_id

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
