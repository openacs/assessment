# Display multiple choice type data.
# author Timo Hentschel (timo@timohentschel.de)

db_1row item_type_data {}
set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]
set actions [list [list "[_ acs-kernel.common_Edit]" edit] [list "[_ assessment.add_item_type_mc_existing]" existing]]


ad_form -name item_show_mc -mode display -action item-edit-mc -export { assessment_id section_id as_item_id } -actions $actions -form {
    {title:text {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {value $title} {help_text "[_ assessment.oq_Title_help]"}}
    {increasing_p:text(select) {label "[_ assessment.Increasing]"} {options $boolean_options} {value $increasing_p} {help_text "[_ assessment.Increasing_help]"}}
    {negative_p:text(select) {label "[_ assessment.Allow_Negative]"} {options $boolean_options} {value $allow_negative_p} {help_text "[_ assessment.Allow_Negative_help]"}}
    {num_correct_answers:text {label "[_ assessment.num_Correct_Answer]"} {html {size 5 maxlength 5}} {value $num_correct_answers} {help_text "[_ assessment.num_Correct_help]"}}
    {num_answers:text,optional {label "[_ assessment.num_Answers]"} {html {size 5 maxlength 5}} {value $num_answers} {help_text "[_ assessment.num_Answers_help]"}}
}

# add form entries for each choice
set ad_form_code "-form \{\n"
set count 0
set choices [db_list_of_lists get_choices {}]
set total [llength $choices]
foreach one_choice $choices {
    lassign $one_choice choice_id title correct_answer_p feedback_text selected_p percent_score sort_order fixed_position answer_value content_rev_id content_filename content_name
    set title  [ns_quotehtml $title]
    set feedback_text [ns_quotehtml $feedback_text]
    incr count
    set options ""
    if {$count < $total} {
	append options " <a href=\\\"item-edit-mc-choices-swap?assessment_id=$assessment_id&section_id=$section_id&as_item_id=$as_item_id&mc_id=$as_item_type_id&sort_order=$sort_order&direction=down\\\"><img src=\\\"/resources/assessment/down.gif\\\" border=0 alt=\\\"[_ assessment.Move_Down]\\\"></a>"
    }
    if {$count > 1} {
	append options " <a href=\\\"item-edit-mc-choices-swap?assessment_id=$assessment_id&section_id=$section_id&as_item_id=$as_item_id&mc_id=$as_item_type_id&sort_order=$sort_order&direction=up\\\"><img src=\\\"/resources/assessment/up.gif\\\" border=0 alt=\\\"[_ assessment.Move_Up]\\\"></a>"
    }
    append options " <a href=\\\"item-edit-mc-choices-delete?assessment_id=$assessment_id&section_id=$section_id&as_item_id=$as_item_id&choice_id=$choice_id\\\"><img src=\\\"/resources/assessment/delete.gif\\\" border=0 alt=\\\"[_ assessment.remove_choice]\\\"></a>"

    if {$correct_answer_p == "t"} {
	append ad_form_code "\{infotxt.$choice_id:text(inform) \{label \"[_ assessment.Choice] $count\"\} \{value \"<img src=/resources/assessment/correct.gif> $title$options\"\}\}\n"
    } else {
	append ad_form_code "\{infotxt.$choice_id:text(inform) \{label \"[_ assessment.Choice] $count\"\} \{value \"<img src=/resources/assessment/wrong.gif> $title$options\"\}\}\n"
    }

    if {$content_rev_id ne ""} {
	append ad_form_code "\{content.$choice_id:text(inform),optional \{label \"[_ assessment.choice_display_Content]\"\} \{value \{<a href=\"../view/$content_filename?revision_id=$content_rev_id\" target=view>$content_name</a>\}\} \{help_text \"[_ assessment.choice_Content_help]\"\}\}\n"
    }

    append ad_form_code "\{selected.$choice_id:text(select),optional \{label \"[_ assessment.Default_Selected]\"\} \{options \$boolean_options\} \{value $selected_p\} \{help_text \"[_ assessment.Default_Selected_help]\"\}\}\n"
    append ad_form_code "\{fixed_pos.$choice_id:text,optional \{label \"[_ assessment.Fixed_Position]\"\} \{html \{size 5 maxlength 5\}\} \{value \"$fixed_position\"\} \{help_text \"[_ assessment.choice_Fixed_Position_help]\"\}\}\n"
    append ad_form_code "\{feedback.$choice_id:text(textarea),optional \{label \"[_ assessment.Feedback]\"\} \{html \{rows 8 cols 80\}\} \{value \"$feedback_text\"\} \{help_text \"[_ assessment.choice_Feedback_help]\"\}\}\n"
    append ad_form_code "\{answer_val.$choice_id:text,optional \{label \"[_ assessment.Answer_Value]\"\} \{html \{size 80 maxlength 500\}\} \{value \"$answer_value\"\} \{help_text \"[_ assessment.Answer_Value_help]\"\}\}\n"
    append ad_form_code "\{percent.$choice_id:text \{label \"[_ assessment.Percent_Score]\"\} \{value \"$percent_score\"\} \{html \{size 5 maxlength 5\}\} \{help_text \"[_ assessment.Percent_Score_help]\"\}\}\n"
}
append ad_form_code "\}"
eval ad_form -extend -name item_show_mc $ad_form_code

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
