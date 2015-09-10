ad_library {
    Assessment action procs
    @author vivian@viaro.net Viaro Networks (www.viaro.net)
    @creation-date 2005-01-13
    
}

namespace eval as::action {}

ad_proc -public as::action::action_exec {
    {-inter_item_check_id}
    {-session_id}
} { 
    
} {
    db_foreach get_check_params { select * from as_param_map where inter_item_check_id = :inter_item_check_id } {
	
	set parameter_name [db_1row select_name "select varname from as_action_params where parameter_id = :parameter_id"]
	
	if {![exixts_and_not_null value]} {
	    
	    set $varname [db_string get_item_choice {select idc.choice_id from as_item_data_choices idc,as_item_data id where id.as_item_id=$item_id and id.item_data_id=idc.item_data_id and id.session_id=:session_id}]
	    
	} else {
	    
	    set $varname $value
	}
	
	set tcl_code [db_1row select_tcl "select a.tcl_code from as_actions a,as_actions_map am where am.action_id = a.action_id and inter_item_check_id = :inter_item_check_id"]
	eval $tcl_code
	return
    }
    
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
