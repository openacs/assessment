# Display open question type data.
# author Timo Hentschel (timo@timohentschel.de)

db_1row item_type_data {}

ad_form -name item_show_oq -mode display -action item-edit-oq -export { assessment_id section_id as_item_id } -form {
    {title:text {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {value $title} {help_text "[_ assessment.oq_Title_help]"}}
    {default_value:text(textarea),optional {label "[_ assessment.Default_Value]"} {html {rows 5 cols 80}} {value $default_value} {help_text "[_ assessment.Deafult_Value_help]"}}
    {feedback:text(textarea),optional {label "[_ assessment.Feedback]"} {html {rows 5 cols 80}} {value $feedback_text} {help_text "[_ assessment.Feedback_help]"}}
}