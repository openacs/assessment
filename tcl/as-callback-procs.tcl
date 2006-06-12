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



ad_proc -public -callback imsld::finish_object {
    -object_id
} {
}
