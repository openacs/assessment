ad_page_contract {
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
} {
    assessment_id:naturalnum,optional
    {type ""}
    {permission_p:boolean ""}
    {page_title ""}
} -properties {
    context:onevalue
    page_title:onevalue
}

permission::require_permission \
    -object_id $assessment_id \
    -party_id [ad_conn user_id] \
    -privilege admin

if {[info exists assessment_id]} {

    # Get the assessment data
    as::assessment::data -assessment_id $assessment_id
    set type $assessment_data(type)
    set page_title [_ assessment.Edit_Assessment]
    set type $assessment_data(type)
    append page_title ": $assessment_data(title)"
    
} else {
    set page_title [_ assessment.New_Assessment2]    
}
set context [list [list index [_ assessment.admin]] $page_title]

set types_list [list [list "[_ assessment.type_s]" survey] [list "[_ assessment.type_test]" test ]]

ad_form -name assessment_type -export {assessment_id permission_p} -form {
    {type:text(radio)
	{label "[_ assessment.choose_type]"}
	{options $types_list}
	{value $type}
    }
} -on_submit {
    if { ([info exists assessment_id] && $assessment_id ne "")} {
    set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
    db_dml update_asm { update as_assessments set type=:type where assessment_id=:new_assessment_rev_id}
    ad_returnredirect [export_vars -base one-a {assessment_id}]
    } else {
	if { $permission_p ne ""} {
	    ad_returnredirect [export_vars -base assessment-form {type assessment_id permission_p}]
	} else {
	    ad_returnredirect [export_vars -base assessment-form {type assessment_id}]
	}
    }
}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
