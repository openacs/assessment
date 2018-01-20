ad_page_contract {
    Redirect page for adding users to the permissions list.

    @author Lars Pind (lars@collaboraid.biz)
    @creation-date 2003-06-13
    @cvs-id $Id$
} {
    object_id:naturalnum,notnull
    
}

set page_title "Add User"

set context [list [list "/assessment/asm-admin/" "[_ assessment.Assessment] [_ assessment.Administration]"] [list [export_vars -base permissions { object_id }] "Permissions"] $page_title]

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -party_id $user_id -privilege "create"


form create permissions
element create permissions object_id \
    -widget hidden\
    -value $object_id
element create permissions party_id \
    -widget party_search \
    -datatype party_search \
    -label User
if {[template::form is_valid permissions]} {
    template::form get_values permissions party_id object_id
    db_transaction {
	
	db_exec_plsql add_user {}
	    
    } on_error {
	ad_return_complaint 1 "We had a problem adding the users you selected. Sorry."
        ad_script_abort
    }
    ad_returnredirect [export_vars -base permissions {object_id}]
    ad_script_abort
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
