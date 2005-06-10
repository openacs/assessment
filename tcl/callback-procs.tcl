ad_library {
    Callback definitions 
    
}
ad_proc -public -callback user::registration -impl url {} {
    
    Return the properly formed link (URL) that the user will click to go into the registration process.
    
} {
    set assessment_id [parameter::get -parameter AsmForRegisterId]
    
    if { $assessment_id != 0 } {
	
	set package_id [db_string package_id {}]
	set url [apm_package_url_from_id $package_id]
	return "${url}assessment?assessment_id=$assessment_id"
	
    }
}
