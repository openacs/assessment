ad_page_contract {

    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation-date 2005-01-07

    This page allows to add branches or actions to the question and its choices.
} {
    assessment_id:naturalnum,notnull
    inter_item_check_id:naturalnum,notnull
    section_id:naturalnum,notnull
    by_item_p:boolean,optional
    item_id:naturalnum,optional
} -properties {
    context:onevalue
    title:onevalue
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set return_url "one-a?assessment_id=$assessment_id"

if { [info exists by_item_p] && $by_item_p ne "" } {
    if { $by_item_p == 1} {
        set return_url "checks-admin?assessment_id=$assessment_id&section_id=$section_id&item_id=$item_id"
    } else {
        set return_url "checks-admin?assessment_id=$assessment_id&section_id=$section_id"
    }
}



set new_assessment_revision $assessment_data(assessment_rev_id)
set sections_list [db_list_of_lists get_sections {}]

set title $assessment_data(title)
set context [list [list index [_ assessment.admin]] [list "one-a?assessment_id=$assessment_id" $title] "$title Triggers"]

set title "[_ assessment.section_select]"
ad_form -name get_section -export {by_item_p item_id} -form {
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
    ad_returnredirect $return_url
    ad_script_abort
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
