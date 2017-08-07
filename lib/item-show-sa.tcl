# Display short answer type data.
# author Timo Hentschel (timo@timohentschel.de)

db_1row item_type_data {}
set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]

ad_form -name item_show_sa -mode display -action item-edit-sa -export { assessment_id section_id as_item_id } -form {
    {title:text {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {value $title} {help_text "[_ assessment.oq_Title_help]"}}
    {increasing_p:text(select) {label "[_ assessment.Increasing]"} {options $boolean_options} {value $increasing_p} {help_text "[_ assessment.Increasing_help]"}}
    {negative_p:text(select) {label "[_ assessment.Allow_Negative]"} {options $boolean_options} {value $allow_negative_p} {help_text "[_ assessment.Allow_Negative_help]"}}
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
