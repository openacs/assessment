ad_library {
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation_date 2004-12-03
    
}


namespace eval as::actions {
    
    ad_proc -public insert_actions {
	-package_id:integer,required
	-node_id:integer,required
    } {
    } { 
	set user_id [auth::test::get_admin_user_id]
	set instance_id $package_id
	   
	 db_exec_plsql insert_default {}
    }
    
}
