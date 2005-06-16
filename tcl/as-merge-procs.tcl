ad_library {
    Assessment Merge procs
    @author Enrique Catalan (quio@galileo.edu)
    @creation-date 2005-04-12
}

namespace eval as::merge {

    ad_proc -callback MergeShowUserInfo -impl as {
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

    ad_proc -callback MergePackageUser -impl as {
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
}
