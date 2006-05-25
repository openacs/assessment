ad_library {
    assessment -- callback routines
    @author eduardo.perez@uc3m.es
    @creation-date 2005-05-23
    @cvs-id $Id$
}

ad_proc -public -callback lors::import -impl qti {} {
    this is the lors qti importer
} {
    if {$res_type == "imsqti_xmlv1p0" || $res_type == "imsqti_xmlv1p1" || $res_type =="imsqti_item_xmlv2p0"} {
        return [as::qti::register \
            -tmp_dir $tmp_dir/$res_href \
            -community_id $community_id]
    }
}


ad_proc -public -callback imsld::import -impl qti {} {
    this is the imsld qti importer
} {
    if {$res_type == "imsqti_xmlv1p0" || $res_type == "imsqti_xmlv1p1" || $res_type =="imsqti_item_xmlv2p0"} {
        return [as::qti::register_xml_object_id \
            -xml_file $tmp_dir/$res_href \
            -community_id $community_id]
    }
}
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
		FROM as_assessments a,dotlrn_communities_all com, acs_objects ac, acs_objects ac2,acs_objects ac3,cr_revisions cr, cr_items ci, cr_folders cf
		WHERE com.community_id = :comm_id
		and a.assessment_id = ac.object_id
		and ac.context_id = ac2.object_id
		and ac2.package_id = ac3.object_id
		and ac3.context_id = com.package_id		
		and cr.revision_id = ci.latest_revision
		and ci.parent_id = cf.folder_id		
		and a.assessment_id = cr.revision_id
	}
	
	return "$result"
    }
    
    ad_proc -callback application-track::getSpecificInfo -impl assessments {} { 
        callback implementation 
    } {
   	
	upvar $query_name my_query
	upvar $elements_name my_elements

	set my_query {
		SELECT 	ac.title as name,assessment_id as id,a.start_time as initial_date,
		a.end_time as finish_date,
		a.number_tries	as number_tries
		FROM as_assessments a,dotlrn_communities_all com, acs_objects ac, acs_objects ac2,acs_objects ac3,cr_revisions cr, cr_items ci, cr_folders cf
		WHERE com.community_id = :class_instance_id
		and a.assessment_id = ac.object_id
		and ac.context_id = ac2.object_id
		and ac2.package_id = ac3.object_id
		and ac3.context_id = com.package_id		
		and cr.revision_id = ci.latest_revision
		and ci.parent_id = cf.folder_id		
		and a.assessment_id = cr.revision_id
		    		
 }
		
	set my_elements {
	
		name {
		    label "name"
	            display_col name 	      	               
	 	    html {align center}
		
		}
	
    		id {
	            label "id"
	            display_col id 	      	               
	 	    html {align center}	 	                
	        }	                   
	        creation_date {
	            label "creation_date"
	            display_col initial_date 	      	               
	 	    html {align center}	 	                
	        }
	        finish_date {
	            label "finish_date"
	            display_col finish_date 	      	               
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