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


ad_proc -callback merge::MergeShowUserInfo -impl as {
    -user_id:required
} {
    Shows assessments items	
} {
    set msg "Assessment items of user $user_id"
    set result [list $msg]

    lappend result [list "Staff of sessions: [db_list sel_sessions { *SQL* }] "]
    lappend result [list "Subject of sessions: [db_list sel_sessions2 {*SQL*}] "]

    lappend result [list "Subject of section data id: [db_list sel_sections { *SQL* }] "]
    lappend result [list "Staff of section data id: [db_list sel_sections2 { *SQL* }] "]

    lappend result [list "Subject of item data id : [db_list sel_items { *SQL* }] "]
    lappend result [list "Staff of item_data_id: [db_list sel_items2 { *SQL* }] "]
    
    return $result
}

ad_proc -callback merge::MergePackageUser -impl as {
    -from_user_id:required
    -to_user_id:required
} {
    Merge the as's of two users.
    The from_user_id is the user that will be 
    deleted and all the entries of this user 
    will be mapped to the to_user_id.
    
} {
    set msg "Merging assesment"
    set result [list $msg]
    ns_log Notice $msg
    db_transaction {
	db_dml upd_from_sessions { *SQL* }
	db_dml upd_from_sessions2 { *SQL* }
	db_dml upd_from_sections { *SQL* }
	db_dml upd_from_sections2 { *SQL* }
	db_dml upd_from_items { *SQL* }
	db_dml upd_from_items2 { *SQL* }
	
    }
    lappend result "assessment merge is done"
    return $result
}


ad_proc -public -callback datamanager::move_assessment -impl datamanager {
     -object_id:required
     -selected_community:required
} {
    Move an assessment to another class or community
} {

#se actualiza el parent_id del assessment en cr_items

#get the new parent_id and package_id
    db_1row get_new_parent_id {}
    db_1row get_new_package_id {}


    db_transaction {
#update table
        db_dml update_as_cr_items {}

#se actualiza el context_id y el package_id del assessment en acs_objects
        db_dml update_as_it_acs_objects1 {}
        db_dml update_as_it_acs_objects2 {}

#se actualiza el package_id del assessment en acs_objects
        db_dml update_as_as_acs_objects {}
    } on_error {
         ad_return_error "Error:" "The error was: $errmsg"
    }
}


ad_proc -public -callback datamanager::copy_assessment -impl datamanager {
     -object_id:required
     -selected_community:required
} {
    Copy an assessment to another class or community
} {
#get assessment data
    db_1row get_assessment_data {}
    set package_id [as::assessment::get_package_id -community_id $selected_community ]

#create the assessment
    set new_assessment_id [as::assessment::new  -title $title   \
    -creator_id $creator_id    \
    -description $description    \
    -instructions $instructions    \
    -run_mode $run_mode    \
    -anonymous_p $anonymous_p    \
    -secure_access_p $secure_access_p    \
    -reuse_responses_p $reuse_responses_p    \
    -show_item_name_p $show_item_name_p    \
    -random_p $random_p    \
    -entry_page $entry_page    \
    -exit_page $exit_page    \
    -consent_page $consent_page    \
    -return_url $return_url    \
    -start_time $start_time    \
    -end_time $end_time    \
    -number_tries $number_tries    \
    -wait_between_tries $wait_between_tries    \
    -time_for_response $time_for_response    \
    -ip_mask $ip_mask    \
    -password $password    \
    -show_feedback $show_feedback    \
    -section_navigation $section_navigation    \
    -survey_p $survey_p     \
    -package_id $package_id    \
    -type $type ]


#get sections data
     set sections_id_list [db_list get_sections_id_list {}]
#asociate section with assessment
     for {set i 0} {$i < [llength $sections_id_list]} {incr i} {
         set section_id [lindex $sections_id_list $i]

         db_1row get_section_data {}
         db_dml map_ass_sections {} 
     }        
    return $new_assessment_id
}



ad_proc -public -callback datamanager::delete_assessment -impl datamanager {
     -object_id:required
} {
    Delete an assessment. That is, move it to the trash
} {
#get the trash id
    set trash_id [datamanager::get_trash_id]
    set community_id [dotlrn_community::get_community_id]
    set trash_package_id [datamanager::get_trash_package_id -community_id $community_id]
 
#update tables
    db_transaction {
        db_dml del_update_as_cr_items {}
        db_dml del_update_as_it_acs_objects {}
#    db_dml del_update_as_it_acs_objects2 {}
        db_dml del_update_as_as_acs_objects {} 
    } on_error {
        ad_return_error "Database error" "A database error occured:<pre>$errmsg</pre>"
    }

}
