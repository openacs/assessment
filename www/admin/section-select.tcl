ad_page_contract {
    
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @date 2005-01-07
    
    This page allows to add branches or actions to the question and its choices.    
} {
    assessment_id:integer
    inter_item_check_id:integer
    section_id:integer
}

as::assessment::data -assessment_id $assessment_id
if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}
set new_assessment_revision [db_string get_assessment_id {select max(revision_id) from cr_revisions where item_id=:assessment_id}]
set new_section_revision [db_string get_section_id {select max(revision_id) from cr_revisions where item_id=:section_id}]

set sections_list [db_list_of_lists get_sections {}]

set title $assessment_data(title)
set context_bar [ad_context_bar [list "one-a?assessment_id=$assessment_id" $title] "$title Triggers"]

set title "[_ assessment.section_select]"
ad_form -name get_section -form {
    inter_item_check_id:key
    {assessment_id:text(hidden)
	{value $assessment_id}}
    {section_id:text(hidden)
	{value $section_id}}
    
    {section_id_to:text(select)
	{label "[_ assessment.section_to_branch]"}
	{options $sections_list}
	{help_text "[_ assessment.lead_you]"}
    }
    
} -new_data {
    db_transaction {
	db_dml update_check {}
    }
} -edit_request {
    db_1row get_section {}
} -edit_data {
	db_dml update_check {}

} -on_submit {
    ad_returnredirect "one-a?assessment_id=$assessment_id"
}