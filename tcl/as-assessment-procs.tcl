ad_library {
    Assessment procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::assessment {}

ad_proc -public as::assessment::new {
    {-name ""}
    {-title:required}
    {-creator_id ""}
    {-description ""}
    {-instructions ""}
    {-run_mode ""}
    {-anonymous_p ""}
    {-secure_access_p ""}
    {-reuse_responses_p ""}
    {-show_item_name_p ""}
    {-entry_page ""}
    {-exit_page ""}
    {-consent_page ""}
    {-return_url ""}
    {-start_time ""}
    {-end_time ""}
    {-number_tries ""}
    {-wait_between_tries ""}
    {-time_for_response ""}
    {-show_feedback ""}
    {-section_navigation ""}
    {-survey_p ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New assessment to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_assessment in the CR (and as_assessments table) getting the revision_id (as_assessment_id)
    db_transaction {
	set assessment_item_id [db_nextval acs_object_id_seq]
	if {[empty_string_p $name]} {
	    set name "ASS_$assessment_item_id"
	}
	set assessment_item_id [content::item::new -item_id $assessment_item_id -parent_id $folder_id -content_type {as_assessments} -name $name -title $title ]

	set as_assessment_id [content::revision::new \
				  -item_id $assessment_item_id \
				  -content_type {as_assessments} \
				  -title $title \
				  -description $description \
				  -attributes [list [list creator_id $creator_id] \
						   [list instructions $instructions] \
						   [list run_mode $run_mode] \
						   [list anonymous_p $anonymous_p] \
						   [list secure_access_p $secure_access_p] \
						   [list reuse_responses_p $reuse_responses_p] \
						   [list show_item_name_p $show_item_name_p] \
						   [list entry_page $entry_page] \
						   [list exit_page $exit_page] \
						   [list consent_page $consent_page] \
						   [list return_url $return_url] \
						   [list start_time $start_time] \
						   [list end_time $end_time] \
						   [list number_tries $number_tries] \
						   [list wait_between_tries $wait_between_tries] \
						   [list time_for_response $time_for_response] \
						   [list show_feedback $show_feedback] \
						   [list section_navigation $section_navigation] \
						   [list survey_p $survey_p]] ]
    }

    return $as_assessment_id
}

ad_proc -public as::assessment::edit {
    {-assessment_id:required}
    {-title:required}
    {-creator_id ""}
    {-description ""}
    {-instructions ""}
    {-run_mode ""}
    {-anonymous_p ""}
    {-secure_access_p ""}
    {-reuse_responses_p ""}
    {-show_item_name_p ""}
    {-entry_page ""}
    {-exit_page ""}
    {-consent_page ""}
    {-return_url ""}
    {-start_time ""}
    {-end_time ""}
    {-number_tries ""}
    {-wait_between_tries ""}
    {-time_for_response ""}
    {-show_feedback ""}
    {-section_navigation ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-10-26

    Edit assessment in the database
} {
    set assessment_rev_id [db_string assessment_revision {}]

    # edit as_assessment in the CR
    db_transaction {
	set new_rev_id [content::revision::new \
			    -item_id $assessment_id \
			    -content_type {as_assessments} \
			    -title $title \
			    -description $description \
			    -attributes [list [list creator_id $creator_id] \
					     [list instructions $instructions] \
					     [list run_mode $run_mode] \
					     [list anonymous_p $anonymous_p] \
					     [list secure_access_p $secure_access_p] \
					     [list reuse_responses_p $reuse_responses_p] \
					     [list show_item_name_p $show_item_name_p] \
					     [list entry_page $entry_page] \
					     [list exit_page $exit_page] \
					     [list consent_page $consent_page] \
					     [list return_url $return_url] \
					     [list start_time $start_time] \
					     [list end_time $end_time] \
					     [list number_tries $number_tries] \
					     [list wait_between_tries $wait_between_tries] \
					     [list time_for_response $time_for_response] \
					     [list show_feedback $show_feedback] \
					     [list section_navigation $section_navigation] ] ]

	copy_sections -assessment_id $assessment_rev_id -new_assessment_id $new_rev_id
    }

    return $new_rev_id
}

ad_proc -public as::assessment::data {
    {-assessment_id:required}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-10-25

    Get all assessment info

    creates a tcl array variable named "assessment_data" in the caller's environment,
    which contains key/value pairs for all properties of the requested assessment.
} {
    upvar assessment_data assessment_data

    if {[empty_string_p $assessment_id]} {
	db_1row lookup_assessment_id ""
    }

    db_1row get_data_by_assessment_id {} -column_array assessment_data

    if {![info exists assessment_data(assessment_id)]} {
	# assessment doesn't exist, caller has to handle this in their
	# own way
	return
    }

    set assessment_data(creator_name) [person::name -person_id $assessment_data(creation_user)]
}

ad_proc -public as::assessment::new_revision {
    {-assessment_id:required}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-11-02

    Creates new revision of an assessment with all sections
} {
    data -assessment_id $assessment_id
    array set a [array get assessment_data]

    db_transaction {
	set new_rev_id [content::revision::new \
			    -item_id $assessment_id \
			    -content_type {as_assessments} \
			    -title $a(title) \
			    -description $a(description) \
			    -attributes [list [list creator_id $a(creator_id)] \
					     [list instructions $a(instructions)] \
					     [list run_mode $a(run_mode)] \
					     [list anonymous_p $a(anonymous_p)] \
					     [list secure_access_p $a(secure_access_p)] \
					     [list reuse_responses_p $a(reuse_responses_p)] \
					     [list show_item_name_p $a(show_item_name_p)] \
					     [list entry_page $a(entry_page)] \
					     [list exit_page $a(exit_page)] \
					     [list consent_page $a(consent_page)] \
					     [list return_url $a(return_url)] \
					     [list start_time $a(start_time)] \
					     [list end_time $a(end_time)] \
					     [list number_tries $a(number_tries)] \
					     [list wait_between_tries $a(wait_between_tries)] \
					     [list time_for_response $a(time_for_response)] \
					     [list show_feedback $a(show_feedback)] \
					     [list section_navigation $a(section_navigation)] ] ]
	
	copy_sections -assessment_id $a(assessment_rev_id) -new_assessment_id $new_rev_id
	copy_categories -from_id $a(assessment_rev_id) -to_id $new_rev_id
    }

    return $new_rev_id
}

ad_proc as::assessment::copy_sections {
    {-assessment_id:required}
    {-new_assessment_id:required}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-11-07

    Copies all sections from assessment_id to new_assessment_id
} {
    db_dml copy_sections {}
}

ad_proc as::assessment::copy_categories {
    {-from_id:required}
    {-to_id:required}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copies all categories from one object to new object
} {
    db_dml copy_categories {}
}

ad_proc as::assessment::sections {
    {-assessment_id:required}
    {-session_id:required}
    {-sort_order_type ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-14

    Returns all sections of an assessment in the correct order.
    may vary from session to session
} {
    set section_list [db_list get_sorted_sections {}]

    if {[llength $section_list] > 0} {
	return $section_list
    }

    # get all sections of assessment
    set all_sections [db_list_of_lists assessment_sections {}]

    # sort section positions
    switch -exact $sort_order_type {
	randomized {
	    set all_sections [util::randomize_list $all_sections]
	}
    }

    # save section order
    set section_list ""
    set count 0
    foreach one_section $all_sections {
	incr count
	util_unlist $one_section section_id title
	lappend section_list $section_id
	db_dml save_order {}
    }

    return $section_list
}

ad_proc as::assessment::pretty_time {
    {-seconds}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-14

    Returns a pretty string of min:sec
} {
    set time ""
    if {![empty_string_p $seconds]} {
	set time_min [expr $seconds / 60]
	set time_sec [expr $seconds - ($time_min * 60)]
	set time "$time_min\:$time_sec min"
    }
    return $time
}

ad_proc as::assessment::folder_id {
    -package_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-06

    Returns the folder_id of the package instance
} {
    return [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]
}

ad_proc as::assessment::unique_name {
    {-name ""}
    {-new_p 1}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-05

    Checks if a name string is unique or empty
} {
    if {$new_p && ![empty_string_p $name] && [db_string check_unique {}] > 0} {
	return 0
    } else {
	return 1
    }
}

ad_proc as::assessment::display_content {
    -content_id:required
    -content_type:required
    -filename:required
    {-title ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-06

    Returns a html snippet to display a content item (i.e. image)
} {
    if {[empty_string_p $content_id]} {
	return $title
    }
    if {$content_type == "image"} {
	return "<img src=\"view/$filename?revision_id=$content_id\" alt=\"$title\">"
    } else {
	return "<a href=\"view/$filename?revision_id=$content_id\">$title</a>"
    }
}
