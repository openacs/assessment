ad_page_contract {
    Form to add an item.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer
    section_id:integer
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

set page_title [_ assessment.add_item]
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]
set package_id [ad_conn package_id]

set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]

set data_types [list]
foreach data_type [list varchar text integer float date timestamp boolean content_type] {
    lappend data_types [list "[_ assessment.data_type_$data_type]" $data_type]
}

set item_types [list]
foreach item_type [db_list item_types {}] {
    lappend item_types [list "[_ assessment.item_type_$item_type]" $item_type]
}


ad_form -name item_add -action item-add -export { assessment_id section_id after } -form {
    {as_item_id:key}
    {name:text {label "[_ assessment.Name]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.item_Name_help]"}}
    {title:text {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.item_Title_help]"}}
    {description:text(textarea) {label "[_ assessment.Description]"} {html {rows 5 cols 80}} {help_text "[_ assessment.item_Description_help]"}}
}

if {![empty_string_p [category_tree::get_mapped_trees $package_id]]} {
    category::ad_form::add_widgets -container_object_id $package_id -categorized_object_id 0 -form_name item_add
}

ad_form -extend -name item_add -form {
    {subtext:text,optional {label "[_ assessment.Subtext]"} {html {size 80 maxlength 500}} {help_text "[_ assessment.item_Subtext_help]"}}
    {field_code:text,optional {label "[_ assessment.Field_Code]"} {html {size 80 maxlength 500}} {help_text "[_ assessment.Field_Code_help]"}}
    {definition:text(textarea),optional {label "[_ assessment.Definition]"} {html {rows 5 cols 80}} {help_text "[_ assessment.item_Definition_help]"}}
    {required_p:text(select) {label "[_ assessment.Required]"} {options $boolean_options} {help_text "[_ assessment.item_Required_help]"}}
    {feedback_right:text(textarea),optional {label "[_ assessment.Feedback_right]"} {html {rows 5 cols 80}} {help_text "[_ assessment.Feedback_right_help]"}}
    {feedback_wrong:text(textarea),optional {label "[_ assessment.Feedback_wrong]"} {html {rows 5 cols 80}} {help_text "[_ assessment.Feedback_wrong_help]"}}
    {max_time_to_complete:integer,optional {label "[_ assessment.time_for_completion]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.item_time_help]"}}
    {points:integer,optional {label "[_ assessment.points_item]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.points_item_help]"}}
    {data_type:text(select) {label "[_ assessment.Data_Type]"} {options $data_types} {help_text "[_ assessment.Data_Type_help]"}}
    {item_type:text(select) {label "[_ assessment.Item_Type]"} {options $item_types} {help_text "[_ assessment.Item_Type_help]"}}
} -new_request {
    set name ""
    set title ""
    set description ""
    set subtext ""
    set field_code ""
    set required_p t
    set feedback_right ""
    set feedback_wrong ""
    set max_time_to_complete ""
    set points ""
    set data_type "varchar"
    set item_type "sa"
} -on_submit {
    set category_ids [category::ad_form::get_categories -container_object_id $package_id]
} -new_data {
    db_transaction {
	set as_item_id [as::item::new \
			    -name $name \
			    -title $title \
			    -description $description \
			    -subtext $subtext \
			    -field_code $field_code \
			    -required_p $required_p \
			    -data_type $data_type \
			    -feedback_right $feedback_right \
			    -feedback_wrong $feedback_wrong \
			    -max_time_to_complete $max_time_to_complete \
			    -points $points]

	if {[exists_and_not_null category_ids]} {
	    category::map_object -object_id $as_item_id $category_ids
	}
    }
} -after_submit {
    # now go to item-type specific form (i.e. multiple choice)
    ad_returnredirect [export_vars -base "item-add-$item_type" {assessment_id section_id as_item_id after}]
    ad_script_abort
}

ad_return_template
