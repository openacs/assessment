ad_page_contract {
    Form to add/edit a section.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,optional
    {after:integer,optional 1}
    {__new_p:boolean 0}
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

if {![info exists section_id] || $__new_p} {
    set page_title [_ assessment.add_new_section]
    set _section_id 0
} else {
    set page_title [_ assessment.edit_section]
    set _section_id $section_id
}

set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]

set type $assessment_data(type)

ad_form -name section_form -action section-form -export { assessment_id after } -form {
    {section_id:key}
}

ad_form -extend -name section_form -form {
    {title:text {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.section_Title_help]"}}
}
if {$type > 1} {
    ad_form -extend -name section_form -form {
	{description:text(textarea),optional {label "[_ assessment.Description]"} {html {rows 5 cols 80}} {help_text "[_ assessment.section_Description_help]"}}
    }
}

if {[category_tree::get_mapped_trees $package_id] ne ""} {
    category::ad_form::add_widgets -container_object_id $package_id -categorized_object_id $_section_id -form_name section_form
}


ad_form -extend -name section_form -form {
    {instructions:text(textarea),optional {label "[_ assessment.Instructions]"} {html {rows 5 cols 80}} {help_text "[_ assessment.section_Instructions_help]"}}
}
if {$type > 1} {
    ad_form -extend -name section_form -form {
	{feedback_text:text(textarea),optional {label "[_ assessment.Feedback]"} {html {rows 5 cols 80}} {help_text "[_ assessment.section_Feedback_help]"}}
	{max_time_to_complete:integer,optional,nospell {label "[_ assessment.time_for_completion]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.section_time_help]"}}
    }
} else {
    ad_form -extend -name section_form -form {
	{description:text(hidden) {value ""}}
	{feedback_text:text(hidden) {value ""}}
	{max_time_to_complete:text(hidden) {value ""}}
    }
}

ad_form -extend -name section_form -new_request {
    set title ""
    set description ""
    set instructions ""
    set feedback_text ""
    set max_time_to_complete ""
} -edit_request {
    db_1row section_data {}
} -on_submit {
    set category_ids [category::ad_form::get_categories -container_object_id $package_id]
} -new_data {
    db_transaction {
	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]

	set new_section_id [as::section::new \
				-title $title \
				-description $description \
				-instructions $instructions \
				-feedback_text $feedback_text \
				-max_time_to_complete $max_time_to_complete]

	db_dml move_down_sections {}
	set sort_order [expr {$after + 1}]
	db_dml add_section_to_assessment {}

	if {([info exists category_ids] && $category_ids ne "")} {
	    category::map_object -object_id $new_section_id $category_ids
	}
    }
} -edit_data {
    
    db_transaction {
	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	set section_id [as::section::latest -section_id $section_id -assessment_rev_id $new_assessment_rev_id]

	set new_section_id [as::section::edit \
				-section_id $section_id \
				-title $title \
				-description $description \
				-instructions $instructions \
				-feedback_text $feedback_text \
				-max_time_to_complete $max_time_to_complete \
				-assessment_id $assessment_id]

	db_dml update_section_of_assessment {}

	if {([info exists category_ids] && $category_ids ne "")} {
	    category::map_object -object_id $new_section_id $category_ids
	}
    }
} -after_submit {
    ad_returnredirect [export_vars -base questions {assessment_id}]&\#S${new_section_id}
    ad_script_abort
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
