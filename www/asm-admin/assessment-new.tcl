ad_page_contract {
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
} {
    assessment_id:integer,optional
    {type ""}
    {permission_p ""}
    {page_title ""}
} -properties {
    context:onevalue
    page_title:onevalue
}

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

set types_list [list [list "[_ assessment.type_s]" 1] [list "[_ assessment.type_ea]" 2 ]]

ad_form -name assessment_type -export {assessment_id permission_p} -form {
    {type:text(radio)
	{label "[_ assessment.choose_type]"}
	{options $types_list}
	{value $type}
    }
} -on_submit {
    if { ![empty_string_p $permission_p]} {
	ad_returnredirect [export_vars -base assessment-form {type assessment_id permission_p}]
    } else {
	ad_returnredirect [export_vars -base assessment-form {type assessment_id}]
    }
}
