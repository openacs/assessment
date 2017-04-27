ad_page_contract {
    Form to add an item.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
    after:integer
    choice:optional,array
    correct:optional,array
} -properties {
    context:onevalue
    page_title:onevalue
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

set folder_id [as::assessment::folder_id -package_id $package_id]
if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set page_title [_ assessment.add_item]
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]
template::head::add_style -style ".form-label {text-align:left;} .form-label label {font-weight:bold;}"
set package_id [ad_conn package_id]

set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]
set type $assessment_data(type)

#set data_types [list]
#foreach data_type [list varchar text integer float date timestamp boolean content_type] {
#    lappend data_types [list "[_ assessment.data_type_$data_type]" $data_type]
#}

set item_types [as_item_type::get_item_types]

ad_form -name item-add -action item-add -export { assessment_id section_id after type } -html {enctype multipart/form-data} -form {
    {as_item_id:key}
    {question_text:richtext,nospell {label "[_ assessment.item_Question]"} {html {rows 12 cols 80 style {width: 99%}}} {help_text "[_ assessment.item_Question_help]"}}
}
if { $type ne "survey"} {
#    ad_form -extend -name item-add -form {{description:text(textarea),optional {label "[_ assessment.Description]"} {html {rows 12 cols 80}} {help_text "[_ assessment.item_Description_help]"}}
#    }
}

if {[category_tree::get_mapped_trees $package_id] ne ""} {
    category::ad_form::add_widgets -container_object_id $package_id -categorized_object_id 0 -form_name item-add
}

if { $type ne "survey"} {
ad_form -extend -name item-add -form {
#    {content:file,optional {label "[_ assessment.item_Content]"} {help_text "[_ assessment.item_Content_help]"}}
#    {field_name:text,optional,nospell {label "[_ assessment.Field_Name]"} {html {size 80 maxlength 500}} {help_text "[_ assessment.Field_Name_help]"}}
#    {field_code:text,optional,nospell {label "[_ assessment.Field_Code]"} {html {size 80 maxlength 500}} {help_text "[_ assessment.Field_Code_help]"}}
}
}
ad_form -extend -name item-add -form {   {required_p:text(select) {label "[_ assessment.Required]"} {options $boolean_options} {help_text "[_ assessment.item_Required_help]"}}
}
if { $type ne "survey"} {
ad_form -extend -name item-add -form {
    {points:integer,optional,nospell {label "[_ assessment.points_item]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.points_item_help]"}}
    {feedback_right:richtext,optional,nospell {label "[_ assessment.Feedback_right]"} {html {rows 12 cols 80 style {width: 99%}}} {help_text "[_ assessment.Feedback_right_help]"}}
    {feedback_wrong:richtext,optional,nospell {label "[_ assessment.Feedback_wrong]"} {html {rows 12 cols 80 style {width: 99%}}} {help_text "[_ assessment.Feedback_wrong_help]"}}
#    {max_time_to_complete:integer,optional,nospell {label "[_ assessment.time_for_completion]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.item_time_help]"}}
#    {points:integer,optional,nospell {label "[_ assessment.points_item]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.points_item_help]"}}
    {field_code:text(hidden),optional}
    {field_name:text(hidden),optional}
    {max_time_to_complete:text(hidden),optional}
    {validate_block:text(hidden),optional}
    {content:text(hidden),optional}
    {description:text(hidden),optional {value ""}}
    {data_type:text(hidden),optional {value ""}}
}
} else {
ad_form -extend -name item-add -form {
    {description:text(hidden),optional {value ""}}
    {content:text(hidden),optional {value ""}}
    {field_name:text,optional,nospell {label "[_ assessment.Field_Name]"} {html {size 80 maxlength 500}} {help_text "[_ assessment.Field_Name_help]"}}
    {field_code:text(hidden),optional {value ""}}
    {feedback_right:text(hidden),optional {value ""}}
    {feedback_wrong:text(hidden),optional {value ""}}
    {max_time_to_complete:text(hidden),optional {value ""}}
    {points:text(hidden),optional {value ""}}
    {data_type:text(hidden),optional {value ""}}
    {validate_block:text(textarea),optional \
	 {label "[_ assessment.Validation_Block]"} \
	 {help_text "[_ assessment.lt_This_field_is_used_to]"} \
	 {html {cols 70 rows 6}}}
}
}

if { $type ne "survey"} {
    #ad_form -extend -name item-add -form {
    #    {data_type:text(select) {label "[_ assessment.Data_Type]"} {options $data_types} {help_text "[_ assessment.Data_Type_help]"}}}
} 

ad_form -extend -name item-add -form {
    {item_type:text(radio) {label "[_ assessment.Item_Type]"} {options $item_types} {help_text "[_ assessment.Item_Type_help]"}}
    #	    {validate_block:text(textarea),optional {label "[_ assessment.Validation_Block]"} {help_text "[_ assessment.lt_This_field_is_used_to]"} {html {cols 70 rows 6}}}
    {num_choices:text(hidden)}
}



##############################################################################
# Multiple Choice Section
##############################################################################
set choice_sets [db_list_of_lists existing_choice_sets {}]
if {[llength $choice_sets]} {
    set choice_sets [concat [list [list "--" ""]] $choice_sets]
    ad_form -extend -name item-add -form {
	{add_existing_mc_id:text(select),optional {label "[_ assessment.Choice_Sets]"} {options $choice_sets} {help_text "[_ assessment.Choice_Sets_help]"}}
    }
} else {
    ad_form -extend -name item-add -form {
	{add_existing_mc_id:text(hidden),optional}
    }
}

ad_form -extend -name item-add -form {
    {save_answer_set:text(checkbox),optional 
        {options {{"#assessment.Save_this_set_of_answers_for_reuse_later#" t}}}
    }
    {formbutton_add_another_choice:text(submit) {label "[_ assessment.Add_another_choice]"}}
}
if {[template::form::is_submission item-add] \
	&& [template::element::get_value item-add formbutton_add_another_choice] \
	eq [_ assessment.Add_another_choice]} {
    set num_choices [element::get_value item-add num_choices]
    incr num_choices
    element::set_value item-add num_choices $num_choices
} 

if {![template::form::is_submission item-add] \
	&& ![info exists num_choices]} {
    set num_choices 5
} else {
    set num_choices [template::element::get_value item-add num_choices]
}

template::multirow create choice_elements id
for {set i 1} {$i <=$num_choices} {incr i} {
    template::multirow append choice_elements ${i}
}
as::item_type_mc::add_choices_to_form \
    -form_id item-add \
    -num_choices $num_choices \
    -choice_array_name choice \
    -correct_choice_array_name correct

# for open questions
ad_form -extend -name item-add -form {
    {reference_answer:text(textarea),optional {label "[_ assessment.oq_Reference_Answer]"} {html {rows 5 cols 30 style {width:95%}}} {help_text "[_ assessment.oq_Reference_Answer_help]"}}
}

ad_form -extend -name item-add -form {
    {formbutton_ok:text(submit) {label "[_ assessment.Save_and_finish]"}}
    {formbutton_add_another_question:text(submit) {label "[_ assessment.Save_and_add_another_question]"}}
}

ad_form -extend -name item-add -validate {
    {item_type {$item_type ne "mc" || ([info exists add_existing_mc_id] && $add_existing_mc_id ne "") || [array size choice] > [llength [lsearch -all -exact [array get choice] ""]]} "Please enter at least one choice for multiple choice question."}
}
ad_form -extend -name item-add -new_request {
    set name ""
    set question_text ""
    set description ""
    set field_name ""
    set field_code ""
    set required_p t
    set feedback_right ""
    set feedback_wrong ""
    set max_time_to_complete ""
    set points ""
    set num_choices 5
    set ms_label "Choose all that apply"
} -on_submit {
    set category_ids [category::ad_form::get_categories -container_object_id $package_id]
    if {$points eq ""} {
	set points 0
    }

    if {(![info exists formbutton_add_another_choice] || $formbutton_add_another_choice eq "")} {
    # map display types to data types
    switch -exact $item_type {
        sa {
	set data_type "varchar" 
	set display_type "tb"
        }
        oq {
	set data_type "text" 
	set display_type "ta"
        }
        mc {
	set data_type "varchar" 
	set display_type "rb"            
        }
        ms {
            #multiple select is just multiple choice with checkboxes
        set item_type "mc"
	set data_type "varchar" 
	set display_type "cb"                        
        }
        fu {
	set data_type "file" 
	set display_type "fu"
        }
    }
    set question_text [template::util::richtext::get_property content $question_text]
    set feedback_right [template::util::richtext::get_property content $feedback_right]
    set feedback_wrong [template::util::richtext::get_property content $feedback_wrong]
    db_transaction {
	if {![db_0or1row item_exists {}]} {

	    set as_item_id [as::item::new \
				-item_item_id $as_item_id \
				-title $question_text \
				-description $description \
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
				-title $question_text \
				-description $description \
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

	if {([info exists category_ids] && $category_ids ne "")} {
	    category::map_object -object_id $as_item_id $category_ids
	}

	if {$content ne ""} {
	    set filename [lindex $content 0]
	    set tmp_filename [lindex $content 1]
	    set file_mimetype [lindex $content 2]
	    set n_bytes [file size $tmp_filename]
	    set max_file_size 10000000
	    # [parameter::get -parameter MaxAttachmentSize]
	    set pretty_max_size [util_commify_number $max_file_size]

	    if { $n_bytes > $max_file_size && $max_file_size > 0 } {
		ad_return_complaint 1 "[_ assessment.file_too_large]"
		return
	    }
	    if { $n_bytes == 0 } {
		ad_return_complaint 1 "[_ assessment.file_zero_size]"
		return
	    }

	    set content_rev_id [cr_import_content -title $filename $folder_id $tmp_filename $n_bytes $file_mimetype [as::item::generate_unique_name]]
	    as::item_rels::new -item_rev_id $as_item_id -target_rev_id $content_rev_id -type as_item_content_rel
	}
        # check question type
	set title [string range $question_text 0 999]
        switch -exact $item_type {
            mc {
		# title for MC is the name of a saved answer set
		# always set to empty on a new question and
		# ask for the title separately in save-answer-set page
                set new_mc_id [as::item_type_mc::add_to_assessment \
				   -assessment_id $assessment_id \
				   -section_id $section_id \
				   -as_item_id $as_item_id \
				   -choices [array get choice] \
				   -correct_choices [array get correct] \
				   -after $after \
				   -title "" \
				   -display_type $display_type]

		if {[info exists add_existing_mc_id] && $add_existing_mc_id ne ""} {
		    set add_existing_mc_id [as::item_type_mc::copy -type_id $add_existing_mc_id -copy_correct_answer_p "f" -new_title ""]
		    if {![db_0or1row item_type {}] || $object_type ne "as_item_type_mc"} {
			if {![info exists object_type]} {
			    # first item type mapped
			    as::item_rels::new -item_rev_id $as_item_id -target_rev_id $add_existing_mc_id -type as_item_type_rel
			} else {
			    # old item type existing
			    db_dml update_item_type {}
			}
		    } else {
			# old mc item type existing
			db_dml update_item_type {}
		    }
		}
	    }
            oq {
                as::item_type_oq::add_to_assessment \
                    -assessment_id $assessment_id \
                    -section_id $section_id \
                    -as_item_id $as_item_id \
                    -after $after \
                    -title $title                    
            }
            sa {
                as::item_type_sa::add_to_assessment \
                    -assessment_id $assessment_id \
                    -section_id $section_id \
                    -as_item_id $as_item_id \
                    -after $after \
                    -title $title                    
            }
            fu {
                as::item_type_fu::add_to_assessment \
                    -assessment_id $assessment_id \
                    -section_id $section_id \
                    -as_item_id $as_item_id \
                    -after $after \
                    -title $title                                    
            }
        }
    }
}
} -after_submit {
    if {(![info exists formbutton_add_another_question] || $formbutton_add_another_question eq "") \
	    && (![info exists formbutton_add_another_choice] || $formbutton_add_another_choice eq "")} {
	set return_url "[export_vars -base questions {assessment_id}]\&#Q$as_item_id"
    } elseif {([info exists formbutton_add_another_question] && $formbutton_add_another_question ne "")} {
	set after [expr {$after + 1}]
	set return_url  "[export_vars -base item-add {after assessment_id section_id}]\#Q$as_item_id"
    }
    if {[info exists return_url] && $return_url ne ""} {
	if {[info exists save_answer_set] && $save_answer_set eq "on" && (![info exists add_existing_mc_id] || $add_existing_mc_id eq "")} {
	    set return_url [export_vars -base save-answer-set {assessment_id as_item_id return_url {mc_id $new_mc_id}}]
	}
	ad_returnredirect $return_url
	ad_script_abort	
    }
}


ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
