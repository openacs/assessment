# Display checkbox type data.
# author Timo Hentschel (timo@timohentschel.de)

db_1row display_type_data {}

ad_form -name item_show_display_cb -mode display -action item-edit-display-cb -export { assessment_id section_id as_item_id } -form {
    {html_options:text,optional {label "[_ assessment.Html_Options]"} {html {size 80 maxlength 1000}} {value $html_display_options} {help_text "[_ assessment.Html_Options_help]"}}
    {choice_orientation:text {label "[_ assessment.Choice_Orientation]"} {value "[_ assessment.$choice_orientation]"} {help_text "[_ assessment.Choice_Orientation_help]"}}
    {order_type:text {label "[_ assessment.Order_Type]"} {value "[_ assessment.$sort_order_type]"} {help_text "[_ assessment.Order_Type_help]"}}
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
