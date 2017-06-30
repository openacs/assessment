ad_page_contract {
    This page admin the parameters that receive the Tcl code defined in the action
    @author vivian@viaro.net Viaro Networks (www.viaro.net)
    @date 07-01-2005
    @cvs-id $Id:
} {
    action_id:naturalnum,notnull
    parameter_id:naturalnum,optional
}

if { ![ad_form_new_p -key parameter_id] } {
    set page_title [_ assessment.edit_parameter]
    db_0or1row get_param_info {}
} else {
    set page_title [_ assessment.new_parameter]
}


set context [list [list [export_vars -base asm-action-new {action_id} ] [_ assessment.action_admin] ]  $page_title]
set user_id [ad_conn user_id]

set type_options [list [list "[_ assessment.query]" q] [list "[_ assessment.var ]" n]]


ad_form -name parameter_admin -form {
    parameter_id:key
    {varname:text {label "[_ assessment.parameter_varname]"} 
	{html {size 30 maxlength 40}} 
	{help_text "[_ assessment.as_parameter_help]"}
    }
    {description:text(textarea) {label "[_ assessment.parameter_description]"} 
	{html {rows 2 cols 50}}
	{help_text "[_ assessment.as_parameter_description_help]"}
	}
    {type:text(select) {label "[_ assessment.parameter_type]"}
	{options $type_options }
        {help_text "[_ assessment.as_parameter_type_help]"}
    }

    {query:text(textarea),optional {label "[_ assessment.parameter_query]"}
	{html {rows 5 cols 80}}
	{help_text "[_ assessment.as_parameter_query_help]"}
	}
    {action_id:text(hidden) {value $action_id}}

} -edit_request {
    db_1row get_param_info {}
} -new_data {
    if { $type eq "q" } {
	
	set user_id [ad_conn user_id]	
	set count_query_record [db_list_of_lists get_records "$query" ]
	
	if { [llength $count_query_record] != 0 } {
	    db_dml insert_param {}
	} else {
	    ad_script_abort
	}
    } else {
	db_dml insert_param {}
    }
} -edit_data {

    if { $type eq "q" } {
	set user_id [ad_conn user_id]	
	set count_query_record [db_list_of_lists get_records "$query" ]
	
	if { [llength $count_query_record] != 0 } {
	    db_dml edit_param {}
	} else {
	    ad_script_abort
	}
    } else {
	db_dml edit_param {}
    }
    
    
} -on_submit {
    
    ad_returnredirect "asm-action-param-admin?action_id=$action_id"
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
