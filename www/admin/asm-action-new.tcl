ad_page_contract {
    This page admin the new actions to be used on the checks
    @authos vivian@viaro.net Viaro Networks (www.viaro.net)
    @date 07-01-2005
    @cvs-id $Id:
} {
    action_id:optional
}

if { ![ad_form_new_p -key action_id] } {
    set page_title [_ assessment.Edit_Assessment]
      set parameter_exist "y"
    db_0or1row get_action_info {}
} else {
    set page_title [_ assessment.New_Assessment2]
       set parameter_exist "n"
}

set page_title "Add new Action"
set context_bar [ad_context_bar [list [export_vars -base asm-action-admin ] [_ assessment.action_admin]] $page_title]

ad_form -name action_admin -form {
    action_id:key
    {name:text {label "[_ assessment.action_name]"} 
	{html {size 30 maxlength 40}} 
	{help_text "[_ assessment.as_action_help]"}
    }
    {description:text(textarea) {label "[_ assessment.action_description]"} 
	{html {rows 5 cols 80}}
	{help_text "[_ assessment.as_action_description_help]"}
	}
    {tcl_code:text(textarea) {label "[_ assessment.action_tcl_code]"}
	{html {rows 5 cols 80}}
        {help_text "[_ assessment.as_action_tcl_code_help]"}
    }

} -validate {
    {tcl_code {![empty_string_p $tcl_code]} "[_ assessment.error_enter_tcl_code]"}

} -select_query {
    	select name,description,tcl_code 
	from as_actions
	where action_id = :action_id

} -new_data {
    db_dml insert_action {}
} -edit_data {
    db_dml edit_action {}
} -on_submit {
  ad_returnredirect "asm-action-new?action_id=$action_id"
}


