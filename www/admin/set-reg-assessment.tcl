ad_page_contract {
    This display the anonymous assessments available for registration
    
    @author Vivian Hernandez (vivian@viaro.net) Viaro Networks (www.viaro.net)
    @creation-date 2005-01-20
    @cvs-id $Id: 
} {
    assessment_id:naturalnum,optional
}


set subsite_id [subsite::main_site_id]
set asm_instance [ad_conn package_id]

if {(![info exists assessment_id] || $assessment_id eq "")} {
    set value [parameter::get -parameter RegistrationId -package_id $subsite_id]
    set assessment_id $value
}



set page_title "[_ acs-subsite.set_reg_asm]"
set context [list "[_ acs-subsite.set_reg_asm]"]


set assessments [db_list_of_lists get_all_assessments {}]
lappend assessments [list "[_ acs-subsite.none]" 0]

set asm_p [llength $assessments]

ad_form -name get_assessment  -form {
    {assessment_id:text(select)
	{label "[_ acs-subsite.choose_assessment]"}
	{options $assessments}
	{help_text "[_ acs-subsite.choose_assessment_help]"}
	{value $assessment_id}}
    {submit:text(submit)
	{label "   OK   "}}
    {edit:text(submit)
	{label "[_ acs-subsite.edit_asm]"}}
} -after_submit {
    if {$edit ne ""} {
	if { $assessment_id != 0} {
	    set package_id [db_string package_id {}]
	    set url [apm_package_url_from_id $package_id]
	    ad_returnredirect "${url}asm-admin/one-a?assessment_id=$assessment_id&reg_p=1&asm_instance=$asm_instance"
	}
    }  else {
	parameter::set_value -package_id [subsite::main_site_id] -parameter RegistrationId -value $assessment_id
	parameter::set_value -package_id [subsite::main_site_id] -parameter RegistrationImplName -value "asm_url"
	ad_returnredirect ""
    }
}

ad_return_template













































# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
