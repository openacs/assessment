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

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set page_title [_ assessment.edit_item]
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]
set package_id [ad_conn package_id]
set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]

db_1row general_item_data {}
set item_type [string range [db_string item_type {}] end-1 end]
set display_type [string range [db_string display_type {}] end-1 end]


ad_form -name item_edit -mode display -action item-edit-general -export { assessment_id section_id as_item_id } -form {
    {name:text {label "[_ assessment.Name]"} {html {size 80 maxlength 1000}} {value $name} {help_text "[_ assessment.item_Name_help]"}}
    {title:text {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {value $title} {help_text "[_ assessment.item_Title_help]"}}
    {description:text(textarea) {label "[_ assessment.Description]"} {html {rows 5 cols 80}} {value $description} {help_text "[_ assessment.item_Description_help]"}}
}

if {![empty_string_p [category_tree::get_mapped_trees $package_id]]} {
    category::ad_form::add_widgets -container_object_id $package_id -categorized_object_id $as_item_id -form_name item_edit
}

if {[db_0or1row get_item_content {}]} {
    ad_form -extend -name item_edit -form {
	{content:text(inform),optional {label "[_ assessment.item_display_Content]"} {value {<a href="../view/$content_filename?revision_id=$content_rev_id" target=view>$content_name</a>}} {help_text "[_ assessment.item_Content_help]"}}
    }
}

ad_form -extend -name item_edit -form {
    {subtext:text,optional {label "[_ assessment.Subtext]"} {html {size 80 maxlength 500}} {value $subtext} {help_text "[_ assessment.item_Subtext_help]"}}
    {field_code:text,optional {label "[_ assessment.Field_Code]"} {html {size 80 maxlength 500}} {value $field_code} {help_text "[_ assessment.Field_Code_help]"}}
    {required_p:text(select) {label "[_ assessment.Required]"} {options $boolean_options} {value $required_p} {help_text "[_ assessment.item_Required_help]"}}
    {feedback_right:text(textarea),optional {label "[_ assessment.Feedback_right]"} {html {rows 5 cols 80}} {value $feedback_right} {help_text "[_ assessment.Feedback_right_help]"}}
    {feedback_wrong:text(textarea),optional {label "[_ assessment.Feedback_wrong]"} {html {rows 5 cols 80}} {value $feedback_wrong} {help_text "[_ assessment.Feedback_wrong_help]"}}
    {max_time_to_complete:integer,optional {label "[_ assessment.time_for_completion]"} {html {size 10 maxlength 10}} {value $max_time_to_complete} {help_text "[_ assessment.item_time_help]"}}
    {points:integer,optional {label "[_ assessment.points_item]"} {html {size 10 maxlength 10}} {value $points} {help_text "[_ assessment.points_item_help]"}}
    {data_type:text {label "[_ assessment.Data_Type]"} {html {size 20 maxlength 20}} {value "[_ assessment.data_type_$data_type]"} {help_text "[_ assessment.Data_Type_help]"}}
    {display_type:text {label "[_ assessment.Display_Type]"} {value "[_ assessment.item_display_$display_type]"} {help_text "[_ assessment.Display_Type_help]"}}
}

ad_return_template