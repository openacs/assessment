ad_library {
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation-date 2004-12-03
    
}

namespace eval as::parameter {}
    
ad_proc -public as::parameter::reset_parameter {
    {-package_id}
    {-node_id ""}
} {
} { 
    set exist_assessment [parameter::get -parameter RegistrationId]
    if { $exist_assessment != 0} {
	set par_package_id [db_string package_id {select package_id from cr_folders where folder_id=(select context_id from acs_objects where object_id=:exist_assessment)} -default 0]
	
	if { $package_id == $par_package_id } {
	parameter::set_value -package_id [ad_conn package_id] -parameter RegistrationId -value 0
	}
    }
}



































# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
