ad_page_contract {
    Form to add an item.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer
    section_id:integer
    after:integer
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

set page_title [_ assessment.add_item]
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]
set package_id [ad_conn package_id]

set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]
set type $assessment_data(type)

set data_types [list]
foreach data_type [list varchar text integer float date timestamp boolean content_type] {
    lappend data_types [list "[_ assessment.data_type_$data_type]" $data_type]
}

set item_types [list]
foreach item_type [db_list item_types {}] {
    lappend item_types [list "[_ assessment.item_type_$item_type]" $item_type]
}


ad_form -name item_add -action item-add -export { assessment_id section_id after type} -html {enctype multipart/form-data} -form {
    {as_item_id:key}
    {title:text(textarea) {label "[_ assessment.item_Title]"} {html {rows 3 cols 80 maxlength 1000}} {help_text "[_ assessment.item_Title_help]"}}
}
if { $type > 1} {
    ad_form -extend -name item_add -form {{description:text(textarea),optional {label "[_ assessment.Description]"} {html {rows 5 cols 80}} {help_text "[_ assessment.item_Description_help]"}}
    }
}

if {![empty_string_p [category_tree::get_mapped_trees $package_id]]} {
    category::ad_form::add_widgets -container_object_id $package_id -categorized_object_id 0 -form_name item_add
}

if { $type > 1} {
ad_form -extend -name item_add -form {
    {content:file,optional {label "[_ assessment.item_Content]"} {help_text "[_ assessment.item_Content_help]"}}
    {subtext:text,optional {label "[_ assessment.Subtext]"} {html {size 80 maxlength 500}} {help_text "[_ assessment.item_Subtext_help]"}}
    {field_name:text,optional,nospell {label "[_ assessment.Field_Name]"} {html {size 80 maxlength 500}} {help_text "[_ assessment.Field_Name_help]"}}
    {field_code:text,optional,nospell {label "[_ assessment.Field_Code]"} {html {size 80 maxlength 500}} {help_text "[_ assessment.Field_Code_help]"}}
}
}
ad_form -extend -name item_add -form {   {required_p:text(select) {label "[_ assessment.Required]"} {options $boolean_options} {help_text "[_ assessment.item_Required_help]"}}
}
if { $type > 1} {
ad_form -extend -name item_add -form {
    {feedback_right:text(textarea),optional {label "[_ assessment.Feedback_right]"} {html {rows 5 cols 80}} {help_text "[_ assessment.Feedback_right_help]"}}
    {feedback_wrong:text(textarea),optional {label "[_ assessment.Feedback_wrong]"} {html {rows 5 cols 80}} {help_text "[_ assessment.Feedback_wrong_help]"}}
    {max_time_to_complete:integer,optional,nospell {label "[_ assessment.time_for_completion]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.item_time_help]"}}
    {points:integer,optional,nospell {label "[_ assessment.points_item]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.points_item_help]"}}
}
} else {
ad_form -extend -name item_add -form {
    {description:text(hidden) {value ""}}
    {content:text(hidden) {value ""}}
    {subtext:text(hidden) {value ""}}
    {field_name:text,optional,nospell {label "[_ assessment.Field_Name]"} {html {size 80 maxlength 500}} {help_text "[_ assessment.Field_Name_help]"}}
    {field_code:text(hidden) {value ""}}
    {feedback_right:text(hidden) {value ""}}
    {feedback_wrong:text(hidden) {value ""}}
    {max_time_to_complete:text(hidden) {value ""}}
    {points:text(hidden) {value ""}}
    {data_type:text(hidden) {value ""}}

}
}

if { $type > 1} {
ad_form -extend -name item_add -form {
    {data_type:text(select) {label "[_ assessment.Data_Type]"} {options $data_types} {help_text "[_ assessment.Data_Type_help]"}}}
} 
ad_form -extend -name item_add -form {
    {item_type:text(select) {label "[_ assessment.Item_Type]"} {options $item_types} {help_text "[_ assessment.Item_Type_help]"}}
    {num_choices:integer,optional,nospell {label "[_ assessment.Num_Choices]"} {html {size 5 maxlength 3}} {help_text "[_ assessment.Num_Choices_help]"}}
    {validate_block:text(textarea),optional {label "[_ assessment.Validation_Block]"} {help_text "[_ assessment.lt_This_field_is_used_to]"} {html {cols 70 rows 6}}}
} -new_request {
    set name ""
    set title ""
    set description ""
    set subtext ""
    set field_name ""
    set field_code ""
    set required_p t
    set feedback_right ""
    set feedback_wrong ""
    set max_time_to_complete ""
    set points ""
    set data_type "varchar"
    set item_type "sa"
    set num_choices 10
    if { $type == 1} {
	set num_choices 3
    }
} -on_submit {
    set category_ids [category::ad_form::get_categories -container_object_id $package_id]
    if {[empty_string_p $points]} {
	set points 0
    }
} -new_data {
    if {[string eq $item_type "sa"]} {
	set data_type "varchar" 
    } elseif {[string eq $item_type "oq"]} {
	set data_type "text" 
    } elseif {[string eq $item_type "mc"]} {
	set data_type "varchar" 
    } elseif {[string eq $item_type "fu"]} {
	set data_type "file" 
    } 

    db_transaction {
	if {![db_0or1row item_exists {}]} {
	    set as_item_id [as::item::new \
				-item_item_id $as_item_id \
				-title $title \
				-description $description \
				-subtext $subtext \
				-field_name $field_name \
				-field_code $field_code \
				-required_p $required_p \
				-data_type $data_type \
				-feedback_right $feedback_right \
				-feedback_wrong $feedback_wrong \
				-max_time_to_complete $max_time_to_complete \
				-points $points \
				-validate_block $validate_block]
	} else {
	    set as_item_id [as::item::edit \
				-as_item_id $as_item_id \
				-title $title \
				-description $description \
				-subtext $subtext \
				-field_name $field_name \
				-field_code $field_code \
				-required_p $required_p \
				-data_type $data_type \
				-feedback_right $feedback_right \
				-feedback_wrong $feedback_wrong \
				-max_time_to_complete $max_time_to_complete \
				-points $points \
				-validate_block $validate_block]

	    db_dml delete_files {}
	}

	if {[exists_and_not_null category_ids]} {
	    category::map_object -object_id $as_item_id $category_ids
	}

	if {![empty_string_p $content]} {
	    set filename [lindex $content 0]
	    set tmp_filename [lindex $content 1]
	    set file_mimetype [lindex $content 2]
	    set n_bytes [file size $tmp_filename]
	    set max_file_size 10000000
	    # [ad_parameter MaxAttachmentSize]
	    set pretty_max_size [util_commify_number $max_file_size]

	    if { $n_bytes > $max_file_size && $max_file_size > 0 } {
		ad_return_complaint 1 "[_ assessment.file_too_large]"
		return
	    }
	    if { $n_bytes == 0 } {
		ad_return_complaint 1 "[_ assessment.file_zero_size]"
		return
	    }

	    set folder_id [as::assessment::folder_id -package_id $package_id]
	    set content_rev_id [cr_import_content -title $filename $folder_id $tmp_filename $n_bytes $file_mimetype [as::item::generate_unique_name]]
	    as::item_rels::new -item_rev_id $as_item_id -target_rev_id $content_rev_id -type as_item_content_rel
	}
    }
} -after_submit {
    # now go to item-type specific form (i.e. multiple choice)
    ad_returnredirect [export_vars -base "item-add-$item_type" {assessment_id section_id as_item_id after num_choices}]
    ad_script_abort
}

ad_return_template
