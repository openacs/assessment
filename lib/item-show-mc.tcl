# Display multiple choice type data.
# author Timo Hentschel (timo@timohentschel.de)

db_1row item_type_data {}
set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]

ad_form -name item_show_mc -mode display -action item-edit-mc -export { assessment_id section_id as_item_id } -form {
    {title:text {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {value $title} {help_text "[_ assessment.oq_Title_help]"}}
    {increasing_p:text(select) {label "[_ assessment.Increasing]"} {options $boolean_options} {value $increasing_p} {help_text "[_ assessment.Increasing_help]"}}
    {negative_p:text(select) {label "[_ assessment.Allow_Negative]"} {options $boolean_options} {value $allow_negative_p} {help_text "[_ assessment.Allow_Negative_help]"}}
    {num_correct_answers:text {label "[_ assessment.num_Correct_Answer]"} {html {size 5 maxlength 5}} {value $num_correct_answers} {help_text "[_ assessment.num_Correct_help]"}}
    {num_answers:text,optional {label "[_ assessment.num_Answers]"} {html {size 5 maxlength 5}} {value $num_answers} {help_text "[_ assessment.num_Answers_help]"}}
}

# add form entries for each choice
set ad_form_code "-form \{\n"
set count 0
db_foreach get_choices {} {
    incr count
    if {$correct_answer_p == "t"} {
	append ad_form_code "\{infotxt.$choice_id:text(inform) \{label \"[_ assessment.Choice] $count\"\} \{value \"$title <img src=../graphics/correct.gif>\"\}\}\n"
    } else {
	append ad_form_code "\{infotxt.$choice_id:text(inform) \{label \"[_ assessment.Choice] $count\"\} \{value \"$title <img src=../graphics/wrong.gif>\"\}\}\n"
    }
    append ad_form_code "\{selected.$choice_id:text(select),optional \{label \"[_ assessment.Default_Selected]\"\} \{options \$boolean_options\} \{value $selected_p\} \{help_text \"[_ assessment.Default_Selected_help]\"\}\}\n"
    append ad_form_code "\{feedback.$choice_id:text(textarea),optional \{label \"[_ assessment.Feedback]\"\} \{html \{rows 8 cols 80\}\} \{value \"$feedback_text\"\} \{help_text \"[_ assessment.choice_Feedback_help]\"\}\}\n"
    append ad_form_code "\{percent.$choice_id:text \{label \"[_ assessment.Percent_Score]\"\} \{value \"$percent_score\"\} \{html \{size 5 maxlength 5\}\} \{help_text \"[_ assessment.Percent_Score_help]\"\}\}\n"
}
append ad_form_code "\}"
eval ad_form -extend -name item_show_mc $ad_form_code
