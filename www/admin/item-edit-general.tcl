ad_page_contract {
    Form to edit an item.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer
    section_id:integer
    as_item_id:integer
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

set page_title [_ assessment.edit_item]
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] [list [export_vars -base item-edit {assessment_id section_id as_item_id}] [_ assessment.edit_item]] $page_title]
set package_id [ad_conn package_id]

set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]

set item_type [string range [db_string get_item_type {}] end-1 end]
set display_types [list]
foreach display_type [db_list display_types {}] {
    lappend display_types [list "[_ assessment.item_display_$display_type]" $display_type]
}


ad_form -name item_edit_general -action item-edit-general -export { assessment_id section_id } -form {
    {as_item_id:key}
    {title:text {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.item_Title_help]"}}
    {description:text(textarea) {label "[_ assessment.Description]"} {html {rows 5 cols 80}} {help_text "[_ assessment.item_Description_help]"}}
}

if {![empty_string_p [category_tree::get_mapped_trees $package_id]]} {
    category::ad_form::add_widgets -container_object_id $package_id -categorized_object_id $as_item_id -form_name item_edit_general
}

ad_form -extend -name item_edit_general -form {
    {subtext:text,optional {label "[_ assessment.Subtext]"} {html {size 80 maxlength 500}} {help_text "[_ assessment.item_Subtext_help]"}}
    {field_code:text,optional {label "[_ assessment.Field_Code]"} {html {size 80 maxlength 500}} {help_text "[_ assessment.Field_Code_help]"}}
    {definition:text(textarea),optional {label "[_ assessment.Definition]"} {html {rows 5 cols 80}} {help_text "[_ assessment.item_Definition_help]"}}
    {required_p:text(select) {label "[_ assessment.Required]"} {options $boolean_options} {help_text "[_ assessment.item_Required_help]"}}
    {feedback_right:text(textarea),optional {label "[_ assessment.Feedback_right]"} {html {rows 5 cols 80}} {help_text "[_ assessment.Feedback_right_help]"}}
    {feedback_wrong:text(textarea),optional {label "[_ assessment.Feedback_wrong]"} {html {rows 5 cols 80}} {help_text "[_ assessment.Feedback_wrong_help]"}}
    {max_time_to_complete:integer,optional {label "[_ assessment.time_for_completion]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.item_time_help]"}}
    {data_type_disp:text(inform) {label "[_ assessment.Data_Type]"} {help_text "[_ assessment.Data_Type_help]"}}
    {data_type:text(hidden)}
    {display_type:text(select) {label "[_ assessment.Display_Type]"} {options $display_types} {help_text "[_ assessment.Display_Type_help]"}}
} -edit_request {
    db_1row general_item_data {}
    set data_type_disp "[_ assessment.data_type_$data_type]" 
    ##set data_type varchar
    set display_type [string range [db_string get_display_type {}] end-1 end]
} -on_submit {
    set category_ids [category::ad_form::get_categories -container_object_id $package_id]
} -edit_data {
    db_transaction {
	set old_display_type [string range [db_string get_display_type {}] end-1 end]
	set new_item_id [as::item::edit \
			     -as_item_id $as_item_id \
			     -title $title \
			     -description $description \
			     -subtext $subtext \
			     -field_code $field_code \
			     -definition $definition \
			     -required_p $required_p \
			     -data_type $data_type \
			     -feedback_right $feedback_right \
			     -feedback_wrong $feedback_wrong \
			     -max_time_to_complete $max_time_to_complete]

	if {[exists_and_not_null category_ids]} {
	    category::map_object -object_id $new_item_id $category_ids
	}

	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	set new_section_id [as::section::new_revision -section_id $section_id]
	db_dml update_section_in_assessment {}
	db_dml update_item_in_section {}
    }
    set as_item_id $new_item_id
    set section_id $new_section_id
} -after_submit {
    if {$old_display_type == $display_type} {
	ad_returnredirect [export_vars -base "item-edit" {assessment_id section_id as_item_id}]
	ad_script_abort
    } else {
	ad_returnredirect [export_vars -base "item-edit-display-$display_type" {assessment_id section_id as_item_id}]
	ad_script_abort
    }
}

ad_return_template
