ad_page_contract {
    Form to add/edit a section.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer
    section_id:integer,optional
    after:integer,optional
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

if {[info exists section_id]} {
    set page_title [_ assessment.edit_section]
    set _section_id $section_id
} else {
    set page_title [_ assessment.add_new_section]
    set _section_id 0
}

set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]
set package_id [ad_conn package_id]

set display_types [db_list_of_lists section_display_types {}]
set display_types [concat [list [list "[_ assessment.section_new_display]" ""]] $display_types]


ad_form -name section_form -action section-form -export { assessment_id after } -form {
    {section_id:key}
}

if {[info exists section_id]} {
    ad_form -extend -name section_form -form {
	{name:text(inform) {label "[_ assessment.Name]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.section_Name_help]"}}
    }
} else {
    ad_form -extend -name section_form -form {
	{name:text,optional {label "[_ assessment.Name]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.section_Name_help]"}}
    }
}

ad_form -extend -name section_form -form {
    {title:text {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.section_Title_help]"}}
    {description:text(textarea) {label "[_ assessment.Description]"} {html {rows 5 cols 80}} {help_text "[_ assessment.section_Description_help]"}}
}

if {![empty_string_p [category_tree::get_mapped_trees $package_id]]} {
    category::ad_form::add_widgets -container_object_id $package_id -categorized_object_id $_section_id -form_name section_form
}

ad_form -extend -name section_form -form {
    {instructions:text(textarea),optional {label "[_ assessment.Instructions]"} {html {rows 5 cols 80}} {help_text "[_ assessment.section_Instructions_help]"}}
    {feedback_text:text(textarea),optional {label "[_ assessment.Feedback]"} {html {rows 5 cols 80}} {help_text "[_ assessment.section_Feedback_help]"}}
    {max_time_to_complete:integer,optional {label "[_ assessment.time_for_completion]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.section_time_help]"}}
    {points:integer,optional {label "[_ assessment.points_section]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.points_item_help]"}}
    {display_type_id:text(select),optional {label "[_ assessment.Display_Type]"} {options $display_types} {help_text "[_ assessment.section_Display_Type_help]"}}
} -new_request {
    set name ""
    set title ""
    set description ""
    set instructions ""
    set feedback_text ""
    set max_time_to_complete ""
    set points ""
    set display_type_id ""
} -edit_request {
    db_1row section_data {}
} -on_submit {
    set category_ids [category::ad_form::get_categories -container_object_id $package_id]
} -new_data {
    db_transaction {
	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]

	set new_section_id [as::section::new \
				-name $name \
				-title $title \
				-description $description \
				-instructions $instructions \
				-feedback_text $feedback_text \
				-max_time_to_complete $max_time_to_complete \
				-points $points \
				-display_type_id $display_type_id]

	db_dml move_down_sections {}
	set sort_order [expr $after + 1]
	db_dml add_section_to_assessment {}

	if {[exists_and_not_null category_ids]} {
	    category::map_object -object_id $new_section_id $category_ids
	}
    }
} -edit_data {
    db_transaction {
	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]

	set new_section_id [as::section::edit \
				-section_id $section_id \
				-title $title \
				-description $description \
				-instructions $instructions \
				-feedback_text $feedback_text \
				-max_time_to_complete $max_time_to_complete \
				-points $points \
				-display_type_id $display_type_id]

	db_dml update_section_of_assessment {}

	if {[exists_and_not_null category_ids]} {
	    category::map_object -object_id $new_section_id $category_ids
	}
    }
} -after_submit {
    if {[empty_string_p $display_type_id]} {
	set section_id $new_section_id
	ad_returnredirect [export_vars -base section-display-form {assessment_id section_id}]
	ad_script_abort
    } else {
	ad_returnredirect [export_vars -base one-a {assessment_id}]
	ad_script_abort
    }
}

ad_return_template
