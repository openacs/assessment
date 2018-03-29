ad_library {
    Assessment Checks procs
    @author Vivian Aguilar (vivian@viaro.net) Viaro Networks (www.viaro.net)
    @creation-date 2005-01-13
}

namespace eval as::actionparam {}

ad_proc -public as::actionparam::paramdelete {
    {parameter_id}
} {
   Delete parameter if it doesn't have a value associated
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
   Delete action if it doesn't have a parameter associated
} {

    db_1row select_actions ""
   
    if { $maps == 0 } {
        package_exec_plsql -var_list [list [list action_id $action_id]] \
            as_action del
    } else {
	ad_return_complaint 1 "You have information stored on the db related to this action"
    }
    return  
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
