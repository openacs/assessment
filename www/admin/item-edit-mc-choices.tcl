ad_page_contract {
    Form to edit the choice data of a multiple choice item.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer
    section_id:integer
    as_item_id:integer
    mc_id:integer
    feedback:array,optional
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

set page_title [_ assessment.edit_item_type_mc_choices]
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] [list [export_vars -base item-edit {assessment_id section_id as_item_id}] [_ assessment.edit_item]] $page_title]

set selected_options [list [list "[_ assessment.yes]" t]]

ad_form -name item_edit_mc_choices -action item-edit-mc-choices -export { assessment_id section_id mc_id } -form {
    {as_item_id:key}
}

# add form entries for each choice
set ad_form_code "-form \{\n"
set count_correct 0
set choices [db_list_of_lists get_choices {}]
foreach one_choice $choices {
    util_unlist $one_choice choice_id title correct_answer_p feedback_text selected_p percent_score
    if {$correct_answer_p == "t"} {
	append ad_form_code "\{infotxt.$choice_id:text(inform) \{label \"[_ assessment.Choice]\"\} \{value \"$title <img src=../graphics/correct.gif>\"\}\}\n"
    } else {
	append ad_form_code "\{infotxt.$choice_id:text(inform) \{label \"[_ assessment.Choice]\"\} \{value \"$title <img src=../graphics/wrong.gif>\"\}\}\n"
    }
    if {$selected_p == "t"} {
	append ad_form_code "\{selected.$choice_id:text(checkbox),optional \{label \"[_ assessment.Default_Selected]\"\} \{options \$selected_options\} \{value \"t\"\} \{help_text \"[_ assessment.Default_Selected_help]\"\}\}\n"
    } else {
	append ad_form_code "\{selected.$choice_id:text(checkbox),optional \{label \"[_ assessment.Default_Selected]\"\} \{options \$selected_options\} \{help_text \"[_ assessment.Default_Selected_help]\"\}\}\n"
    }
    append ad_form_code "\{feedback.$choice_id:text(textarea),optional \{label \"[_ assessment.Feedback]\"\} \{html \{rows 8 cols 80\}\} \{value \{$feedback_text\}\} \{help_text \"[_ assessment.choice_Feedback_help]\"\}\}\n"
    if {$correct_answer_p == "t"} {
	set default_percent "\$percentage"
	incr count_correct
    } else {
	set default_percent $percent_score
    }
    append ad_form_code "\{percent.$choice_id:text \{label \"[_ assessment.Percent_Score]\"\} \{value \"$default_percent\"\} \{html \{size 5 maxlength 5\}\} \{help_text \"[_ assessment.Percent_Score_help]\"\}\}\n"
}
append ad_form_code "\}"
set percentage [expr 100 / $count_correct]
eval ad_form -extend -name item_edit_mc_choices $ad_form_code


ad_form -extend -name item_edit_mc_choices -edit_request {
    foreach one_choice $choices {
	util_unlist $one_choice choice_id title correct_answer_p feedback_text selected_p percent_score
	set feedback($choice_id) $feedback_text
	set percent($choice_id) $percent_score
	if {$selected_p == "t"} {
	    set selected($choice_id) t
	}
    }
} -edit_data {
    db_transaction {
	set count 0
	foreach choice_id [array names feedback] {
	    set feedback_text $feedback($choice_id)
	    set selected_p [ad_decode [info exists selected($choice_id)] 0 f t]
	    set percent_score $percent($choice_id)
	    db_dml update_choice_data {}
	}
    }
} -after_submit {
    ad_returnredirect [export_vars -base "item-edit" {assessment_id section_id as_item_id}]
    ad_script_abort
}

ad_return_template
