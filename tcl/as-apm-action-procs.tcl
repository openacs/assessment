ad_library {
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation-date 2004-12-03

}

namespace eval as::actions {}

ad_proc -private as::actions::get_admin_user_id {} {
    Return the user id of a site-wide-admin on the system
} {
    set context_root_id [acs_lookup_magic_object security_context_root]

    return [db_string select_user_id {}]
}

ad_proc -public as::actions::insert_actions {
    {-package_id}
    {-node_id}
} {
} {

# The code does not work at all on Oracle
    set user_id [as::actions::get_admin_user_id]

    db_exec_plsql insert_default {}
}

ad_proc -public as::actions::insert_actions_after_upgrade {

} {
} {
    db_exec_plsql after_upgrade {}

}
ad_proc -public as::actions::update_checks_after_upgrade {

} {
} {
    set checks [db_list_of_lists get_all_checks {}]

    foreach check $checks {
        lassign $check inter_item_check_id check_sql
        set cond_list  [split  $check_sql "="]
        set item_id [lindex [split [lindex $cond_list 2] " "] 0]
        set condition [lindex [split [lindex $cond_list 1] " "] 0]

        set append_sql " and id.item_data_id = (select max(item_data_id) from as_item_data where as_item_id=$item_id and session_id=:session_id)"
        append check_sql $append_sql

        db_dml update_checks {}

    }
}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
