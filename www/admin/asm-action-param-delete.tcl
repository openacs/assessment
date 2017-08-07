ad_page_contract {
    This page display the parameters that receive the actions
    @authos vivian@viaro.net Viaro Networks (www.viaro.net)
    @date 07-01-2005
    @cvs-id $Id:
} {
    parameter_id:naturalnum,notnull
    action_id:naturalnum,notnull
}

set page_title [_ assessment.delete_parameter]
set context_bar [ad_context_bar [list [export_vars -base asm-action-new {action_id} ] [_ assessment.action_admin] ]  $page_title]
db_1row select_param_info {select type,varname,description,query 
	from as_action_params 
    where parameter_id = :parameter_id}
ad_form -name parameter_delete -form {
    {parameter_id:text(hidden) {value $parameter_id} }
    {action_id:text(hidden) {value $action_id} }
    {varname:text(inform) {label "[_ assessment.parameter_varname]"} {value $varname} }
    {description:text(inform) {label "[_ assessment.parameter_description]"} {value $description}}
    {query:text(inform) {label "[_ assessment.parameter_query]"} {value $query}}
    {submit:text(submit) {label "delete"}}
    {back:text(submit) {label "back"}}
}  -on_submit {
    if { $back eq "back" } {
	ad_returnredirect "asm-action-new?action_id=$action_id"
    } else {

	as::actionparam::paramdelete $parameter_id
	ad_returnredirect "asm-action-new?action_id=$action_id"
    }

}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
