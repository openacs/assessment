ad_library {
    Callback definitions 
    
}
ad_proc -public -callback user::registration -impl asm_url {} {
    
    Return the properly formed link (URL) that the user will click to go into the registration process.
    
} {
    set assessment_id [parameter::get -parameter RegistrationId -default 0]
    if { $assessment_id != 0 } {
	
	set package_id [db_string package_id {}]
	set url [apm_package_url_from_id $package_id]
	return "${url}assessment?assessment_id=$assessment_id"
	
    }
}

#Callbacks for application-track 

ad_proc -callback application-track::getApplicationName -impl assessments {} { 
        callback implementation 
    } {
        return "assessments"
    }    
    
ad_proc -callback application-track::getGeneralInfo -impl assessments {} { 
        callback implementation 
    } {
	db_1row my_query {
    		select  count(1) as result
		FROM as_assessments a,dotlrn_communities_all com, acs_objects ac, acs_objects ac2,acs_objects ac3
		WHERE com.community_id = 2560
		and a.assessment_id = ac.object_id
		and ac.context_id = ac2.object_id
		and ac2.package_id = ac3.object_id
		and ac3.context_id = com.package_id	
	}
	
	return "$result"
    }
    
ad_proc -callback application-track::getSpecificInfo -impl assessments {} { 
        callback implementation 
    } {
   	
	upvar $query_name my_query
	upvar $elements_name my_elements

	set my_query {
		SELECT 	a.assessment_id as id,a.instructions as instructions,a.start_time as initial_date,
		a.end_time as finish_date,
		a.number_tries
		FROM as_assessments a,dotlrn_communities_all com, acs_objects ac, acs_objects ac2,acs_objects ac3
		WHERE com.community_id = :class_instance_id
		and a.assessment_id = ac.object_id
		and ac.context_id = ac2.object_id
		and ac2.package_id = ac3.object_id
		and ac3.context_id = com.package_id
 }
		
	set my_elements {
	
    		id {
	            label "id"
	            display_col id 	      	               
	 	    html {align center}	 	                
	        }
	        instructions {
	            label "instructions"
	            display_col instructions 	      	               
	 	    html {align center}	 	                
	        }              
	        creation_date {
	            label "creation_date"
	            display_col initial_date 	      	               
	 	    html {align center}	 	                
	        }
	        finish_date {
	            label "finish_date"
	            display_col finish_time 	      	               
	 	    html {align center} 	 	             
	        }
	        number_tries {
	            label "number_tries"
	            display_col number_tries 	      	               
	 	    html {align center}	 	               
	        }
	        
	}

        return "OK"
    }       
 
ad_proc -callback learning_materials_portlet::portlet_multirow_data -impl assessment {
    -user_id
    -multirow
    {-community_id ""}
} {
    Get assessment data for aggregate learning portlet
} {
    set list_of_package_ids [list]
    set package_id_clause ""

    if {$community_id ne ""} {
	set node_id [dotlrn_community::get_community_node_id $community_id]
	set list_of_package_ids [site_node::get_children -node_id $node_id -element package_id -package_key assessment]
	if {[llength $list_of_package_ids]} {
	    set package_id_clause "and ass.package_id in ([join $list_of_package_ids ", "])"
	} else {
	    return
	}
    }

    db_foreach get_assessments {} {
	if {$in_progress_p > 0 } {
	    set status "\#assessment.Incomplete\#"
	    set action "\#assessment.Continue\#"
	} elseif {$completed_p >0} {
	    set status "\#assessment.Complete\#"
	    set action "\#assessment.Begin\#"
	} else {
	    set status "\#assessment.Not_Taken\#"
	    set action "\#assessment.Begin\#"
	}
	template::multirow append $multirow $assessment_id "$title" [export_vars -base assessment/assessment {assessment_id}] $status "Status URL" $action [export_vars -base assessment/assessment {assessment_id}] "admin_url"  $percent_score [export_vars -base ../assessment/session {assessment_id}]
    }
}

ad_proc -callback learning_materials_portlet::portlet_multirow_admin_data -impl assessment {
    -user_id
    -multirow
    {-community_id ""}
} {
    Get assessment data for aggregate learning portlet
} {
    set list_of_package_ids [list]
    if {$community_id ne ""} {
	set node_id [dotlrn_community::get_community_node_id $community_id]
	set list_of_package_ids [site_node::get_children -node_id $node_id -element package_id -package_key assessment]
    }
    set list_of_folder_ids [list]
    foreach package_id $list_of_package_ids {
	lappend list_of_folder_ids [as::assessment::folder_id -package_id $package_id]
    }
    set folder_id_clause ""
    if {[llength $list_of_folder_ids]} {
	set folder_id_clause "and ci.parent_id in ([join $list_of_folder_ids ", "])"
    } else {
	return
    }


    set return_url [ad_return_url]
    db_foreach get_assessments {} {
	set publish_status [string map {live "\#assessment.Live\#"} $publish_status]
	template::multirow append $multirow $assessment_id $title [export_vars -base "assessment/asm-admin/one-a" {assessment_id}] [expr {$publish_status ne "" ? $publish_status : "\#assessment.Not_Live\#"}] [export_vars -base "assessment/asm-admin/toggle-publish" {assessment_id return_url}] $completed_number [export_vars -base assessment/asm-admin/results-users {assessment_id}] [export_vars -base "assessment/asm-admin/one-a" {assessment_id}]
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
