ad_library {
    Session procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::session {}

ad_proc -public as::session::new {
    {-assessment_id:required}
    {-subject_id:required}
    {-staff_id ""}
    {-target_datetime ""}
    {-creation_datetime ""}
    {-first_mod_datetime ""}
    {-last_mod_datetime ""}
    {-completed_datetime ""}
    {-ip_address ""}
    {-percent_score ""}
    {-consent_timestamp ""}
    {-package_id ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-09-12

    New as_session to the database
} {
    if {$package_id eq ""} {
	set package_id [ad_conn package_id]
    }

    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

#    # Check to see if there's a session already to not submit another one
#    db_0or1row as_session_last {SELECT session_id AS as_session_id FROM as_sessionsx WHERE subject_id = :subject_id AND assessment_id = :assessment_id}
#    if { ! [info exists as_session_id] } {    
    # Insert as_session in the CR (and as_sessions table) getting the revision_id (session_id)

    set transaction_successful_p 0

    while { ! $transaction_successful_p } {
	db_transaction {
	    set session_id [content::item::new -parent_id $folder_id -content_type {as_sessions} -name "$subject_id-$assessment_id-[as::item::generate_unique_name]" -title "$subject_id-$assessment_id-[as::item::generate_unique_name]" ]
	    set as_session_id [content::revision::new \
				   -item_id $session_id \
				   -content_type {as_sessions} \
				   -title "$subject_id-$assessment_id-[as::item::generate_unique_name]" \
				   -attributes [list [list assessment_id $assessment_id] \
						    [list subject_id $subject_id] \
						    [list staff_id $staff_id] \
						    [list target_datetime $target_datetime] \
						    [list creation_datetime $creation_datetime] \
						    [list first_mod_datetime $first_mod_datetime] \
						    [list last_mod_datetime $last_mod_datetime] \
						    [list completed_datetime $completed_datetime] \
						    [list percent_score $percent_score] \
						    [list consent_timestamp $consent_timestamp] ] ]
	    set transaction_successful_p 1
	} on_error {
	    ns_log notice "as::session::new: Transaction Error: $errmsg"
	}
    }
#    }
    callback as::session::update \
	-assessment_id [content::revision::item_id -revision_id $assessment_id] \
	-session_id $as_session_id \
	-user_id $subject_id \
	-start_time $creation_datetime \
	-end_time "" \
	-percent_score "" \
	-elapsed_time "" \
	-package_id $package_id \
	-session_points "" \
	-assessment_points ""

    return $as_session_id
}

ad_proc -private as::session::delete {
    -session_id:required
} {
    Remove a session and all associated data

    @author Dave Bauer (dave@solutiongrove.com)

    @param session_id
} {
    foreach item_id [db_list get_data_ids ""] {
        foreach result_item_id [db_list get_result_ids ""] {
            content::item::delete -item_id $result_item_id
        }
        content::item::delete -item_id $item_id
    }
    foreach item_id [db_list get_section_data_ids ""] {
        foreach result_item_id [db_list get_result_ids ""] {
            content::item::delete -item_id $result_item_id
        }
        content::item::delete -item_id $item_id
    }
    if {[apm_package_enabled_p "general-comments"]} {
        foreach comment_id [db_list get_comments ""] {
            content::item::delete -item_id $comment_id
        }
    }

    db_dml delete_choices {}
    db_dml delete_session_items {}

    set session_item_id [content::revision::item_id -revision_id $session_id]
    content::revision::delete -revision_id $session_id

}

ad_proc -private as::session::delete_all_sessions {
    -subject_id:required
    -assessment_id:required
} {
    Remove a session and all associated data

    @author Dave Bauer (dave@solutiongrove.com)

    @param subject_id
    @param assessment_id
} {
    foreach session_id [db_list get_session_ids "select session_id from as_sessions where assessment_id=:assessment_id and subject_id=:subject_id"] {
        as::session::delete -session_id $session_id
    }
}

ad_proc -private as::session::unfinished_session_id {
    -assessment_id:required
    -subject_id:required
} {
    return [db_string unfinished_session_id {} -default ""]
}

ad_proc -private as::session::update_elapsed_time {
    -session_id
    -section_id
} {
    Update the total elapsed time in seconds for a session
    based on how long the user took to submit the specified section

    @author Dave Bauer (dave@solutiongrove.com)
    
    @param session_id
    @param section_id 

} {
    set last_viewed ""
    set last_mod_datetime ""
    db_0or1row get_last_viewed "select to_char(last_viewed,'YYYY-MM-DD HH24:MI:SS') as last_viewed, to_char(last_mod_datetime, 'YYYY-MM-DD HH24:MI:SS') as last_mod_datetime from views_views, as_sessions where subject_id = viewer_id and session_id = :session_id and object_id = :section_id"

    if {$last_viewed eq ""} {
	if {$last_mod_datetime ne ""} {
	    set last_viewed $last_mod_datetime
	} else {
	    set elapsed_seconds 600
	}
    } 

    if {$last_viewed ne ""} {
	set last_seconds [clock scan $last_viewed]
	set last_mod_seconds [clock scan $last_mod_datetime]
	set current_seconds [clock seconds]
	set elapsed_seconds [expr {$current_seconds - $last_seconds}]
	set elapsed_mod_seconds [expr {$current_seconds - $last_mod_seconds}]

	if { $elapsed_mod_seconds < 600} {
	    set elapsed_seconds $elapsed_mod_seconds
	}

	if { $elapsed_seconds > 600} {
	    set elapsed_seconds 600
	}

    }

    db_dml update_elapsed_time "update as_sessions set elapsed_seconds = coalesce(elapsed_seconds,0) + :elapsed_seconds where session_id = :session_id"
    as::session::call_update_callback \
	-session_id $session_id
    return $elapsed_seconds
}


ad_proc as::session::response_as_email {
    -session_id
    {-mime_type "text/html"}
} {
    Format the session results as an email

    @param session_id
    @param mime_type text/html or text/plain
    @return list in array list format of html html_email text text_email
} {
    set html_email "[_ assessment.session_email_introduction]"

    # get all the results questions/answers
    db_multirow items session_items {} {
	array set default_value [as::item_data::get -subject_id $subject_id -as_item_id $as_item_id -session_id $session_id]
	array set item [as::item::item_data -as_item_id $as_item_id]
	append html_email "<p>${title}<br />\n"
	switch -- $item(item_type) {
	    "mc" {
		set choices [db_list get_choices "select title from cr_revisions r, as_item_data d, as_item_data_choices dc where d.session_id=:session_id and d.as_item_id = :as_item_id and d.item_data_id = dc.item_data_id and dc.choice_id = revision_id"]
		append html_email "CHOICE: [join $choices "<br />\n"]\n"
	    }
	    default {
		append html_email "TEXT: ${default_value(text_answer)}\n"
	    }
	}
	append html_email "</p>\n"
    }
    if {$mime_type eq "text/html"} {
	return $html_email
    }
    return [ad_html_text_convert -from text/html -to text/plain $html_email]


}

ad_proc as::session::call_update_callback {
    -session_id
    {-session_ref ""}
} {
    Call session callback

    @param session_id session_id to update
    @param session_ref reference to array containing session data in caller, if not specified we fill it with a query on the database

} {
    if {$session_ref ne ""} {
	upvar $session_ref session_array
    }

    if {![array exists session_array]} {

	if {![db_0or1row get_session "

select s.*, a.item_id as assessment_item_id, o.package_id from as_sessions s, as_assessmentsi a, acs_objects o where a.item_id = o.object_id and s.session_id  = :session_id and a.assessment_id = s.assessment_id
" -column_array session_array]} {
	    # if we can't find the session just return without doing anything
	    # there's nothing we can do from here
	    return
	}
    }
    foreach var {assessment_item_id subject_id creation_datetime completed_datetime percent_score elapsed_seconds package_id} {
	if {![info exists session_array($var)]} {
	    set session_array($var) ""
	}
    }
    set session_points [db_string get_session_score "select sum(coalesce(points,0)) from as_item_data where session_id=:session_id" -default ""]
    set assessment_points [db_string get_max_points "select sum(coalesce(i.points,0)) from as_items i, as_item_data d where d.session_id = :session_id and i.as_item_id = d.as_item_id" -default ""]
    if {$assessment_points ne "" && $session_points ne "" && $assessment_points > 0} {
    	set session_array(percent_score) "[format "%3.2f" [expr {$session_points / ($assessment_points + 0.0) * 100}]]"
}

ns_log notice "AS SESSION CALLBACK UPDATE
session_id = '${session_id}'
session_points = '${session_points}'
assessment_points = '${assessment_points}'"

	callback as::session::update \
	    -assessment_id $session_array(assessment_item_id) \
	    -session_id $session_array(session_id) \
	    -user_id $session_array(subject_id) \
	    -start_time $session_array(creation_datetime) \
	    -end_time $session_array(completed_datetime) \
	    -percent_score $session_array(percent_score) \
	    -elapsed_time $session_array(elapsed_seconds) \
	    -package_id $session_array(package_id) \
            -session_points $session_points \
            -assessment_points $assessment_points
}

ad_proc -callback as::session::update {
    -assessment_id
    -session_id
    -user_id
    -start_time
    -end_time
    -percent_score
    -elapsed_time
    -package_id
    -session_points
    -assessment_points
} {
    Notify listeners that something interesting happened with this assessment session.
} -


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
