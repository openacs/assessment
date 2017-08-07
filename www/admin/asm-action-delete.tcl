ad_page_contract {
    This page delete the action
    @authos vivian@viaro.net Viaro Networks (www.viaro.net)
    @date 07-01-2005
    @cvs-id $Id:
} {
    action_id:naturalnum,notnull
}

set page_title [_ assessment.delete]
set context_bar [ad_context_bar [list [export_vars -base asm-action-new {action_id} ] [_ assessment.action_admin] ]  $page_title]
db_1row select_action_info {select name,description,tcl_code 
	from as_actions
    where action_id = :action_id}
ad_form -name action_delete -form {
    {action_id:text(hidden) {value $action_id} }
    {name:text(inform) {label "[_ assessment.action_name]"} {value $name} }
    {description:text(inform) {label "[_ assessment.action_description]"} {value $description}}
    {tcl_code:text(inform) {label "[_ assessment.action_tcl_code]"} {value $tcl_code}}
    {submit:text(submit) {label "delete"}}
    {back:text(submit) {label "back"}}
}  -on_submit {
    if { $back eq "back" } {
	ad_returnredirect "asm-action-admin"
    } else {
	as::actionparam::actiondelete $action_id
	ad_returnredirect "asm-action-admin"	


    }

}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
