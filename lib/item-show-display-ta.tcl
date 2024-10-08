ad_include_contract {
    Display textarea type data.

    @author Timo Hentschel (timo@timohentschel.de)
} {
    as_item_id:object_type(acs_object)
}

db_1row display_type_data {}

ad_form -name item_show_display_ta -mode display -action item-edit-display-ta -export { assessment_id section_id as_item_id } -form {
    {html_options:text,optional {label "[_ assessment.Html_Options]"} {html {size 80 maxlength 1000}} {value $html_display_options} {help_text "[_ assessment.Html_Options_help]"}}
    {abs_size:text {label "[_ assessment.Absolute_Size]"} {html {size 5 maxlength 5}} {value $abs_size} {help_text "[_ assessment.Absolute_Size_help]"}}
    {answer_alignment:text {label "[_ assessment.Answer_Alignment]"} {value "[_ assessment.$item_answer_alignment]"} {help_text "[_ assessment.Answer_Alignment_help]"}}
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
