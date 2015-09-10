ad_page_contract {
    Form to edit the choice data of a multiple choice item.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
    as_item_id:naturalnum,notnull
    mc_id:naturalnum,notnull
    feedback:array,optional
    fixed_pos:array,optional
    answer_val:array,optional
    delete_content:array,optional
    percent:array,optional
    selected:array,optional
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

set package_id [ad_conn package_id]
set page_title [_ assessment.edit_item_type_mc_choices]
set context [list [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] [list [export_vars -base questions {assessment_id}] Questions] [list [export_vars -base item-edit {assessment_id section_id as_item_id}] [_ assessment.edit_item]] $page_title]

set selected_options [list [list "[_ assessment.yes]" t]]

ad_form -name item_edit_mc_choices -action item-edit-mc-choices -export { assessment_id section_id mc_id } -html {enctype multipart/form-data} -form {
    {as_item_id:key}
}

# add form entries for each choice
set ad_form_code "-form \{\n"
set count_correct 0
set choices [db_list_of_lists get_choices {}]
foreach one_choice $choices {
    lassign $one_choice choice_id title correct_answer_p feedback_text selected_p percent_score fixed_position answer_value content_rev_id content_filename content_name
    if {$correct_answer_p == "t"} {
	append ad_form_code "\{infotxt.$choice_id:text(inform) \{label \"[_ assessment.Choice] $title\"\} \{value \"<img src=/resources/assessment/correct.gif>\"\}\}\n"
    } else {
	append ad_form_code "\{infotxt.$choice_id:text(inform) \{label \"[_ assessment.Choice] $title\"\} \{value \"<img src=/resources/assessment/wrong.gif>\"\}\}\n"
    }
    if {$selected_p == "t"} {
	append ad_form_code "\{selected.$choice_id:text(checkbox),optional \{label \"[_ assessment.Default_Selected]\"\} \{options \$selected_options\} \{value \"t\"\} \{help_text \"[_ assessment.Default_Selected_help]\"\}\}\n"
    } else {
	append ad_form_code "\{selected.$choice_id:text(checkbox),optional \{label \"[_ assessment.Default_Selected]\"\} \{options \$selected_options\} \{help_text \"[_ assessment.Default_Selected_help]\"\}\}\n"
    }
    append ad_form_code "\{fixed_pos.$choice_id:text,optional,nospell \{label \"[_ assessment.Fixed_Position]\"\} \{html \{size 5 maxlength 5\}\} \{value \"$fixed_position\"\} \{help_text \"[_ assessment.choice_Fixed_Position_help]\"\}\}\n"
    append ad_form_code "\{answer_val.$choice_id:text,optional,nospell \{label \"[_ assessment.Answer_Value]\"\} \{html \{size 80 maxlength 500\}\} \{value \"$answer_value\"\} \{help_text \"[_ assessment.Answer_Value_help]\"\}\}\n"

    if {$content_rev_id ne ""} {
	append ad_form_code "\{delete_content.$choice_id:text(checkbox),optional \{label \"[_ assessment.choice_Delete_Content]\"\} \{options \{\{\{<a href=\"../view/$content_filename?revision_id=$content_rev_id\" target=view>$content_name</a>\} t\}\} \}\}\n"
    }
    append ad_form_code "\{content_$choice_id:file,optional \{label \"[_ assessment.choice_Content]\"\} \{help_text \"[_ assessment.choice_Content_help]\"\}\}\n"
    append ad_form_code "\{feedback.$choice_id:text(textarea),optional,nospell \{label \"[_ assessment.Feedback]\"\} \{html \{rows 8 cols 80\}\} \{value \{$feedback_text\}\} \{help_text \"[_ assessment.choice_Feedback_help]\"\}\}\n"
    if {$correct_answer_p == "t"} {
	set default_percent "\$percentage"
	incr count_correct
    } else {
	set default_percent $percent_score
    }
    append ad_form_code "\{percent.$choice_id:text,nospell \{label \"[_ assessment.Percent_Score]\"\} \{value \"$default_percent\"\} \{html \{size 5 maxlength 5\}\} \{help_text \"[_ assessment.Percent_Score_help]\"\}\}\n"
}
append ad_form_code "\}"
if {$count_correct > 0} {
    set percentage [expr {100 / $count_correct}]
} else {
    set percentage 0
}
eval ad_form -extend -name item_edit_mc_choices $ad_form_code


ad_form -extend -name item_edit_mc_choices -edit_request {
    foreach one_choice $choices {
	lassign $one_choice choice_id title correct_answer_p feedback_text selected_p percent_score fixed_position answer_value
	set feedback($choice_id) $feedback_text
	set percent($choice_id) $percent_score
	set fixed_pos($choice_id) $fixed_position
	set answer_val($choice_id) $answer_value
	if {$selected_p == "t"} {
	    set selected($choice_id) t
	}
    }
} -edit_data {
    db_transaction {
	set max_file_size 10000000
	# [parameter::get -parameter MaxAttachmentSize]
	set pretty_max_size [util_commify_number $max_file_size]
	set folder_id [as::assessment::folder_id -package_id $package_id]

	set count 0
	foreach choice_id [array names feedback] {
	    set feedback_text $feedback($choice_id)
	    set selected_p [ad_decode [info exists selected($choice_id)] 0 f t]
	    set percent_score $percent($choice_id)
	    set fixed_position $fixed_pos($choice_id)
	    set answer_value $answer_val($choice_id)
	    db_dml update_choice_data {}

	    eval set content "\$content_$choice_id"
	    if {$content ne ""} {
		set filename [lindex $content 0]
		set tmp_filename [lindex $content 1]
		set file_mimetype [lindex $content 2]
		set n_bytes [file size $tmp_filename]

		if { $n_bytes > $max_file_size && $max_file_size > 0 } {
		    ad_return_complaint 1 "[_ assessment.file_too_large]"
		    return
		}
		if { $n_bytes == 0 } {
		    ad_return_complaint 1 "[_ assessment.file_zero_size]"
		    return
		}
		set content_rev_id [cr_import_content -title $filename $folder_id $tmp_filename $n_bytes $file_mimetype [as::item::generate_unique_name]]
		db_dml update_choice_content {}
	    } elseif {[info exists delete_content($choice_id)]} {
		db_dml delete_choice_content {}
	    }
	}
    }
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
