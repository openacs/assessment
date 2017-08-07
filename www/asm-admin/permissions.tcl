ad_page_contract {
    Permissions for the subsite itself.
    
    @creation-date 2004-11-09
    
} {
    object_id:naturalnum,notnull
} -properties {
    context:onevalue
    page_title:onevalue
}

set page_title "Permissions"



set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -party_id $user_id -privilege "create"

set node_id [ad_conn node_id]
set return_url "[site_node::get_url -node_id $node_id]asm-admin/"
set context [list [list index [_ assessment.admin]] $page_title]
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
