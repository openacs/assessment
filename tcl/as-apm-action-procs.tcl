ad_library {
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation_date 2004-12-03
    
}

namespace eval as::actions {}
    
ad_proc -public as::actions::insert_actions {
    {-package_id}
    {-node_id}
} {
} { 
    set user_id [auth::test::get_admin_user_id]
    
    db_exec_plsql insert_default {}
}


