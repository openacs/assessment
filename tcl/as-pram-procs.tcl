ad_library {
    Assessment Checks procs
    @author Vivian Aguilar (vivian@viaro.net) Viaro Networks (www.viaro.net)
    @creation-date 2005-01-13
}

namespace eval as::actionparam {}

ad_proc -public as::actionparam::paramdelete {
    {parameter_id}
} {
   Delete parameter if it doesnt have a value asociated
} {

    db_1row select_params ""

    if { $maps == 0 } {
	db_dml delete_param "" 
    } else {
	ad_return_complaint 1 "You have information stored on the db related to this parameter"
    }
    return  
}


ad_proc -public as::actionparam::actiondelete {
    {action_id}
} {
   Delete action if it doesnt have a parameter asociated
} {

    db_1row select_actions ""
   
    if { $maps == 0 } {
	db_dml delete_action "" 
	db_dml delete_param "" 
    } else {
	ad_return_complaint 1 "You have information stored on the db related to this action"
    }
    return  
}