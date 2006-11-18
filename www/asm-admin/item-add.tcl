 style {width:95%}}} {help_text "[_ assessment.oq_Reference_Answer_help]"}}
}

ad_form -extend -name item-add -form {
    {formbutton_ok:text(submit) {label "[_ assessment.Save_and_go_to_Question_List]"}}
    {formbutton_add_another_q:text(submit) {label "[_ assessment.Save_and_add_another_question]"}}
}

ad_form -extend -name item-add -validate {
    {item_type {$item_type ne "mc" || [array size choice] > [llength [lsearch -all -exact [array get choice] ""]]} "Please enter at least one choice for multiple choice question."}
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
    if {[empty_string_p $points]} {
	set points 0
    }
} -new_data {
    if {[info exists add_another_choice] && $add_another_choice ne ""} {
        ad_return_template
        break
    }
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
        # check question type

        switch -exact $item_type {
            mc {
                as::item_type_mc::add_to_assessment \
                    -assessment_id $assessment_id \
                    -section_id $section_id \
                    -as_item_id $as_item_id \
                    -choices [array get choice] \
                    -correct_choices [array get correct] \
                    -after $after \
                    -title $question_text\
                    -display_type $display_type
            }
            oq {
                as::item_type_oq::add_to_assessment \
                    -assessment_id $assessment_id \
                    -section_id $section_id \
                    -as_item_id $as_item_id \
                    -after $after \
                    -title $question_text                    
            }
            sa {
                as::item_type_sa::add_to_assessment \
                    -assessment_id $assessment_id \
                    -section_id $section_id \
                    -as_item_id $as_item_id \
                    -after $after \
                    -title $question_text                    
            }
            fu {
                as::item_type_fu::add_to_assessment \
                    -assessment_id $assessment_id \
                    -section_id $section_id \
                    -as_item_id $as_item_id \
                    -after $after \
                    -title $question_text                                    
            }
        }
    }

} -after_submit {
    set return_url [export_vars -base one-section {section_id assessment_id}]
    if {[info exists formbutton_add_another_q] && $formbutton_add_another_q ne ""} {
	incr after
	set return_url [export_vars -base item-add {assessment_id section_id after}]
    }
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
