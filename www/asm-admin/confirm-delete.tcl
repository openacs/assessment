ad_page_contract {
    This page deletes checks
    @author Anny Flores (annyflores@viaro.net) Viaro Networks
    @creation-date 2005-01-17
} {
    inter_item_check_id:naturalnum,multiple
    section_id:naturalnum,notnull
    assessment_id:naturalnum,notnull
    by_item_p:boolean,integer
    item_id_check:optional
}

set inter_item_check_id [split $inter_item_check_id " "]
set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin
as::assessment::data -assessment_id $assessment_id
set title "$assessment_data(title)"

set context [list [list "one-a?assessment_id=$assessment_id" $title] [list "checks-admin?assessment_id=$assessment_id&section_id=$section_id" "$title [_ assessment.Administration]"] "[_ assessment.trigger_delete]"]


set title "[_ assessment.trigger_delete]"

ad_form -name delete_checks -export {by_item_p item_id_check} -form {
    
    {inter_item_check_id:text(hidden) 
	{value $inter_item_check_id}
    }
    {section_id:text(hidden) 
	{value $section_id}
    }
    {assessment_id:text(hidden) 
	{value $assessment_id}
    }
}  -after_submit {
    
    if {$by_item_p == 1} {
	ad_returnredirect [export_vars -base checks-delete {section_id inter_item_check_id assessment_id by_item_p item_id}]
    } else {
	ad_returnredirect [export_vars -base checks-delete {section_id inter_item_check_id assessment_id by_item_p}]
    }
    ad_script_abort
    
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
