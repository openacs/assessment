ad_page_contract {
    Form to add the choice data of a multiple choice item.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer
    section_id:integer
    as_item_id:integer
    after:integer
    mc_id:integer
    display_type
    feedback:array,optional
    fixed_pos:array,optional
    answer_val:array,optional
    percent:array,optional
    selected:array,optional
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

permission::permission_p -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set package_id [ad_conn package_id]
set page_title [_ assessment.add_item_type_mc_choices]
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]

set selected_options [list [list "[_ assessment.yes]" t]]

ad_form -name item_add_mc_choices -action item-add-mc-choices -export { assessment_id section_id after mc_id display_type } -html {enctype multipart/form-data} -form {
    {as_item_id:key}
}

# add form entries for each choice
set ad_form_code "-form \{\n"
set count_correct 0
db_foreach get_choices {} {
    if {$correct_answer_p == "t"} {
	append ad_form_code "\{infotxt.$choice_id:text(inform) \{label \"[_ assessment.Choice]\"\} \{value \"$title <img src=../graphics/correct.gif>\"\}\}\n"
    } else {
	append ad_form_code "\{infotxt.$choice_id:text(inform) \{label \"[_ assessment.Choice]\"\} \{value \"$title <img src=../graphics/wrong.gif>\"\}\}\n"
    }
    append ad_form_code "\{selected.$choice_id:text(checkbox),optional \{label \"[_ assessment.Default_Selected]\"\} \{options \$selected_options\} \{help_text \"[_ assessment.Default_Selected_help]\"\}\}\n"
    append ad_form_code "\{fixed_pos.$choice_id:text,optional,nospell \{label \"[_ assessment.Fixed_Position]\"\} \{html \{size 5 maxlength 5\}\} \{help_text \"[_ assessment.choice_Fixed_Position_help]\"\}\}\n"
    append ad_form_code "\{answer_val.$choice_id:text,optional,nospell \{label \"[_ assessment.Answer_Value]\"\} \{html \{size 80 maxlength 500\}\} \{help_text \"[_ assessment.Answer_Value_help]\"\}\}\n"
    append ad_form_code "\{content_$choice_id:file,optional \{label \"[_ assessment.choice_Content]\"\} \{help_text \"[_ assessment.choice_Content_help]\"\}\}\n"
    append ad_form_code "\{feedback.$choice_id:text(textarea),optional,nospell \{label \"[_ assessment.Feedback]\"\} \{html \{rows 8 cols 80\}\} \{help_text \"[_ assessment.choice_Feedback_help]\"\}\}\n"
    if {$correct_answer_p == "t"} {
	set default_percent "\$percentage"
	incr count_correct
    } else {
	set default_percent 0
    }
    append ad_form_code "\{percent.$choice_id:text,nospell \{label \"[_ assessment.Percent_Score]\"\} \{value \"$default_percent\"\} \{html \{size 5 maxlength 5\}\} \{help_text \"[_ assessment.Percent_Score_help]\"\}\}\n"
}
append ad_form_code "\}"
set percentage [expr 100 / $count_correct]
eval ad_form -extend -name item_add_mc_choices $ad_form_code


ad_form -extend -name item_add_mc_choices -edit_request {
} -edit_data {
    set max_file_size 10000000
    # [ad_parameter MaxAttachmentSize]
    set pretty_max_size [util_commify_number $max_file_size]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    db_transaction {
	set count 0
	foreach choice_id [array names feedback] {
	    set feedback_text $feedback($choice_id)
	    set selected_p [ad_decode [info exists selected($choice_id)] 0 f t]
	    set percent_score $percent($choice_id)
	    set fixed_position $fixed_pos($choice_id)
	    set answer_value $answer_val($choice_id)

	    eval set content "\$content_$choice_id"
	    if {![empty_string_p $content]} {
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
		set content_rev_id [cr_import_content -title $filename $folder_id $tmp_filename $n_bytes $file_mimetype [exec uuidgen]]
	    } else {
		set content_rev_id ""
	    }

	    db_dml update_choice_data {}
	}
    }
} -after_submit {
    # now go to display-type specific form (i.e. textbox)
    ad_returnredirect [export_vars -base "item-add-display-$display_type" {assessment_id section_id as_item_id after}]
    ad_script_abort
}

ad_return_template
