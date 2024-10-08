ad_include_contract {
    Shows links relating to 1 assessment

    example:
    Assessment Admin | Results | Section 1 | Section 2

    @param tab specifies which tab we're currently on. options are
               "front", "results" or a section_id

} {
    assessment_id:object_type(content_item)
    tab
}

as::assessment::data -assessment_id $assessment_id
set assessment_rev_id $assessment_data(assessment_rev_id)

set assessment_url [export_vars -base one-a {assessment_id}]
set questions_url [export_vars -base questions {assessment_id}]

# validate that tab is set properly
if { ![string is integer -strict $tab] && $tab ni {"front" "results" "questions"} } {
    error "lib/section-links: tab should be front, results, questions or a section_id"
}

if { [string is integer -strict $tab] } {
    set tab questions
}

db_multirow -extend { section_url } sections sections_query {} {
    set section_url [export_vars -base one-section {assessment_id section_id}]
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
