ad_library {
    Assessment procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::assessment {}

ad_proc -public as::assessment::new {
    {-name:required}
    {-title:required}
    {-creator_id ""}
    {-description ""}
    {-instructions ""}
    {-mode ""}
    {-editable_p ""}
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
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New assessment to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_assessment in the CR (and as_assessments table) getting the revision_id (as_assessment_id)
    db_transaction {
	set assessment_item_id [content::item::new -parent_id $folder_id -content_type {as_assessments} -name $name -title $title ]

	set as_assessment_id [content::revision::new \
				  -item_id $assessment_item_id \
				  -content_type {as_assessments} \
				  -title $title \
				  -description $description \
				  -attributes [list [list creator_id $creator_id] \
						   [list instructions $instructions] \
						   [list mode $mode] \
						   [list editable_p $editable_p] \
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
    }

    return $as_assessment_id
}

ad_proc -public as::assessment::edit {
    {-assessment_id:required}
    {-title:required}
    {-creator_id ""}
    {-description ""}
    {-instructions ""}
    {-mode ""}
    {-editable_p ""}
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
					     [list mode $mode] \
					     [list editable_p $editable_p] \
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

    return $assessment_rev_id
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
					     [list mode $a(mode)] \
					     [list editable_p $a(editable_p)] \
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
