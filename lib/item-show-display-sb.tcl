# Display selectbox type data.
# author Timo Hentschel (timo@timohentschel.de)

db_1row display_type_data {}
set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]

ad_form -name item_show_display_sb -mode display -action item-edit-display-sb -export { assessment_id section_id as_item_id } -form {
    {html_options:text,optional {label "[_ assessment.Html_Options]"} {html {size 80 maxlength 1000}} {value $html_display_options} {help_text "[_ assessment.Html_Options_help]"}}
    {multiple_p:text(select) {label "[_ assessment.Multiple]"} {options $boolean_options} {value $multiple_p} {help_text "[_ assessment.Multiple_help]"}}
    {order_type:text {label "[_ assessment.Order_Type]"} {value "[_ assessment.$sort_order_type]"} {help_text "[_ assessment.Order_Type_help]"}}
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
