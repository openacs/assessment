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

set page_title [_ assessment.edit_item_general]
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] [list [export_vars -base item-edit {assessment_id section_id as_item_id}] [_ assessment.edit_item]] $page_title]
set package_id [ad_conn package_id]

set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]

set item_type [string range [db_string get_item_type {}] end-1 end]
set display_types [list]
foreach display_type [db_list display_types {}] {
    lappend display_types [list "[_ assessment.item_display_$display_type]" $display_type]
}


ad_form -name item_edit_general -action item-edit-general -export { assessment_id section_id } -html {enctype multipart/form-data} -form {
    {as_item_id:key}
    {name:text(inform),nospell {label "[_ assessment.Name]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.item_Name_help]"}}
    {title:text(textarea) {label "[_ assessment.Title]"} {html {rows 3 cols 80}} {help_text "[_ assessment.item_Title_help]"}}
    {description:text(textarea),optional {label "[_ assessment.Description]"} {html {rows 5 cols 80}} {help_text "[_ assessment.item_Description_help]"}}
}

if {![empty_string_p [category_tree::get_mapped_trees $package_id]]} {
    category::ad_form::add_widgets -container_object_id $package_id -categorized_object_id $as_item_id -form_name item_edit_general
}

if {[db_0or1row get_item_content {}]} {
    ad_form -extend -name item_edit_general -form {
	{delete_content:text(checkbox),optional {label "[_ assessment.item_Delete_Content]"} {options {{{<a href="../view/$content_filename?revision_id=$content_rev_id" target=view>$content_name</a>} t}} }}
    }
}

ad_form -extend -name item_edit_general -form {
    {content:file,optional {label "[_ assessment.item_Content]"} {help_text "[_ assessment.item_Content_help]"}}
    {subtext:text,optional {label "[_ assessment.Subtext]"} {html {size 80 maxlength 500}} {help_text "[_ assessment.item_Subtext_help]"}}
    {field_code:text,optional,nospell {label "[_ assessment.Field_Code]"} {html {size 80 maxlength 500}} {help_text "[_ assessment.Field_Code_help]"}}
    {required_p:text(select) {label "[_ assessment.Required]"} {options $boolean_options} {help_text "[_ assessment.item_Required_help]"}}
    {feedback_right:text(textarea),optional {label "[_ assessment.Feedback_right]"} {html {rows 5 cols 80}} {help_text "[_ assessment.Feedback_right_help]"}}
    {feedback_wrong:text(textarea),optional {label "[_ assessment.Feedback_wrong]"} {html {rows 5 cols 80}} {help_text "[_ assessment.Feedback_wrong_help]"}}
    {max_time_to_complete:integer,optional,nospell {label "[_ assessment.time_for_completion]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.item_time_help]"}}
    {points:integer,optional,nospell {label "[_ assessment.points_item]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.points_item_help]"}}
    {data_type_disp:text(inform) {label "[_ assessment.Data_Type]"} {help_text "[_ assessment.Data_Type_help]"}}
    {data_type:text(hidden)}
    {display_type:text(select) {label "[_ assessment.Display_Type]"} {options $display_types} {help_text "[_ assessment.Display_Type_help]"}}
} -edit_request {
    db_1row general_item_data {}
    if {[empty_string_p $data_type]} {
	set data_type varchar
    }
    set data_type_disp "[_ assessment.data_type_$data_type]" 
    set display_type [string range [db_string get_display_type {}] end-1 end]
} -on_submit {
    set category_ids [category::ad_form::get_categories -container_object_id $package_id]
    if {[empty_string_p $points]} {
	set points 0
    }
} -edit_data {
    db_transaction {
	set old_display_type [string range [db_string get_display_type {}] end-1 end]
	set new_item_id [as::item::edit \
			     -as_item_id $as_item_id \
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
	    category::map_object -object_id $new_item_id $category_ids
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
	    set content_rev_id [cr_import_content -title $filename $folder_id $tmp_filename $n_bytes $file_mimetype [exec uuidgen]]
	    db_dml update_item_content {}
	} elseif {[info exists delete_content]} {
	    db_dml delete_item_content {}
	}
	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	set section_id [as::section::latest -section_id $section_id -assessment_rev_id $new_assessment_rev_id]
	set new_section_id [as::section::new_revision -section_id $section_id -assessment_id $assessment_id]
	set as_item_id [as::item::latest -as_item_id $as_item_id -section_id $new_section_id]
	as::assessment::check::copy_item_checks -assessment_id $assessment_id -section_id $new_section_id -as_item_id $as_item_id -new_item_id $new_item_id
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
