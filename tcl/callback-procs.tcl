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
 