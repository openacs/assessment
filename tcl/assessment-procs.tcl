ad_library {
    Assessment procs
    @author eperez@it.uc3m.es
    @creation-date 2004-07-26
}

ad_proc -public as_item_choice_new {
    {-mc_id:required}
    {-name:required}
    {-title:required}
    {-data_type ""}
    {-numeric_value ""}
    {-text_value ""}
    {-boolean_value:boolean ""}
    {-content_value ""}
    {-feedback_text ""}
    {-selected_p:boolean ""}
    {-correct_answer_p ""}
    {-sort_order ""}
    {-percent_score ""}

} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New item choice to the data database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_choice in the CR (and as_item_choices table) getting the revision_id (as_item_choice_id)
    set item_choice_id [content::item::new -parent_id $folder_id -content_type {as_item_choices} -name $name -title $title ]
    set as_item_choice_id [content::revision::new -item_id $item_choice_id -content_type {as_item_choices} -title $title -attributes [list [list mc_id $mc_id ] [list data_type $data_type ] [list numeric_value $numeric_value ] [list $text_value text_value] [list boolean_value $boolean_value] [list content_value $content_value] [list feedback_text $feedback_text] [list selected_p $selected_p] [list correct_answer_p $correct_answer_p] [list sort_order $sort_order] [list percent_score $percent_score] ] ]
    # FIXME too much code repetition here
    # maybe there are more efficient ways to to it (maybe using hashes to pass the values between functions)
    return $as_item_choice_id
}

ad_proc -public as_item_type_mc_new {
    {-name:required}
    {-title ""}
    {-increasing_p ""}
    {-allow_negative_p ""}
    {-num_correct_answers ""}
    {-num_answers ""}
    {-choices ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New Multiple Choice item to the data database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_type_mc in the CR (and as_item_type_mc table) getting the revision_id (as_item_type_id)
    set item_item_type_mc_id [content::item::new -parent_id $folder_id -content_type {as_item_type_mc} -name $name -title $title ]
    set as_item_type_mc_id [content::revision::new -item_id $item_item_type_mc_id -content_type {as_item_type_mc} -title $title -attributes [list [list increasing_p $increasing_p] [list allow_negative_p $allow_negative_p] [list num_correct_answers $num_correct_answers] [list num_answers $num_answers] ] ]

    return $as_item_type_mc_id
}

ad_proc -public as_item_display_rb_new {
    {-name:required}
    {-html_display_options ""}
    {-choice_orientation ""}
    {-choice_label_orientation ""}
    {-sort_order_type ""}
    {-item_answer_alignment ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @author Natalia Perez (nperper@it.uc3m.es)
    @creation-date 2004-07-26

    New Item Display RadioButton Type to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_display_rb in the CR (and as_item_display_rb table) getting the revision_id (as_item_display_id)
    set item_item_display_rb_id [content::item::new -parent_id $folder_id -content_type {as_item_display_rb} -name $name]
    set as_item_display_rb_id [content::revision::new -item_id $item_item_display_rb_id -content_type {as_item_display_rb} -attributes [list [list html_display_options $html_display_options] [list choice_orientation $choice_orientation] [list choice_label_orientation $choice_label_orientation] [list sort_order_type $sort_order_type] [list item_answer_alignment $item_answer_alignment] ] ]

    return $as_item_display_rb_id
}

ad_proc -public as_item_display_cb_new {
    {-name:required}
    {-html_display_options ""}
    {-choice_orientation ""}
    {-choice_label_orientation ""}
    {-sort_order_type ""}
    {-item_answer_alignment ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-09-23

    New Item Display CheckBox Type to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_display_cb in the CR (and as_item_display_cb table) getting the revision_id (as_item_display_id)
    set item_item_display_cb_id [content::item::new -parent_id $folder_id -content_type {as_item_display_cb} -name $name]
    set as_item_display_cb_id [content::revision::new -item_id $item_item_display_cb_id -content_type {as_item_display_cb} -attributes [list [list html_display_options $html_display_options] [list choice_orientation $choice_orientation] [list choice_label_orientation $choice_label_orientation] [list sort_order_type $sort_order_type] [list item_answer_alignment $item_answer_alignment] ] ]

    return $as_item_display_cb_id
}

ad_proc -public as_item_new {
    {-name:required}
    {-title:required}
    {-subtext ""}
    {-field_code ""}
    {-definition ""}
    {-required_p ""}
    {-data_type ""}
    {-max_time_to_complete ""}
    {-feedback_text ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New item to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item in the CR (and as_items table) getting the revision_id (as_item_id)
    set item_item_id [content::item::new -parent_id $folder_id -content_type {as_items} -name $name -title $title ]
    set as_item_id [content::revision::new -item_id $item_item_id -content_type {as_items} -title $title -attributes [list [list subtext $subtext] [list field_code $field_code] [list definition $definition] [list required_p $required_p] [list data_type $data_type] [list max_time_to_complete $max_time_to_complete] [list feedback_text $feedback_text] ] ]

    return $as_item_id
}

ad_proc -public as_section_new {
    {-name:required}
    {-title:required}
    {-instructions ""}
    {-description ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New section to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_section in the CR (and as_sections table) getting the revision_id (as_section_id)
    set section_item_id [content::item::new -parent_id $folder_id -content_type {as_sections} -name $name -title $title -description $description ]
    set as_section_id [content::revision::new -item_id $section_item_id -content_type {as_sections} -title $title -description $description -attributes [list [list instructions $instructions] ] ]

    return $as_section_id
}

ad_proc -public as_assessment_new {
    {-name:required}
    {-title:required}
    {-creator_id ""}
    {-description ""}
    {-instructions ""}
    {-mode ""}
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
    set assessment_item_id [content::item::new -parent_id $folder_id -content_type {as_assessments} -name $name -title $title ]
    set as_assessment_id [content::revision::new -item_id $assessment_item_id -content_type {as_assessments} -title $title -attributes [list [list creator_id $creator_id] [list instructions $instructions] [list mode $mode] [list anonymous_p $anonymous_p] [list secure_access_p $secure_access_p] [list reuse_responses_p $reuse_responses_p] [list show_item_name_p $show_item_name_p] [list entry_page $entry_page] [list exit_page $exit_page] [list consent_page $consent_page] [list return_url $return_url] [list start_time $start_time] [list end_time $end_time] [list number_tries $number_tries] [list wait_between_tries $wait_between_tries] [list time_for_response $time_for_response] [list show_feedback $show_feedback] [list section_navigation $section_navigation] ] ]

    return $as_assessment_id
}

ad_proc -public as_session_new {
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
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-09-12

    New as_session to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

#    # Check to see if there's a session already to not submit another one
#    db_0or1row as_session_last {SELECT session_id AS as_session_id FROM as_sessionsx WHERE subject_id = :subject_id AND assessment_id = :assessment_id}
#    if { ! [info exists as_session_id] } {    
    # Insert as_session in the CR (and as_sessions table) getting the revision_id (session_id)
    set session_id [content::item::new -parent_id $folder_id -content_type {as_sessions} -name "$subject_id-$assessment_id-[ad_generate_random_string]" -title "$subject_id-$assessment_id-[ad_generate_random_string]" ]
    set as_session_id [content::revision::new -item_id $session_id -content_type {as_sessions} -title "$subject_id-$assessment_id-[ad_generate_random_string]" -attributes [list [list assessment_id $assessment_id] [list subject_id $subject_id] [list staff_id $staff_id] [list target_datetime $target_datetime] [list creation_datetime $creation_datetime] [list first_mod_datetime $first_mod_datetime] [list last_mod_datetime $last_mod_datetime] [list completed_datetime $completed_datetime] [list percent_score $percent_score] [list consent_timestamp $consent_timestamp] ] ]
#    }
    return $as_session_id
}

ad_proc -public as_item_data_new {
    {-session_id:required}
    {-event_id ""}
    {-subject_id ""}
    {-staff_id ""}
    {-as_item_id:required}
    {-choice_id_answer ""}
    {-boolean_answer ""}
    {-numeric_answer ""}
    {-integer_answer ""}
    {-text_answer ""}
    {-timestamp_answer ""}
    {-content_answer ""}
    {-signed_data ""}
    {-percent_score ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-09-12

    New as_item_data to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_data in the CR (and as_item_data table) getting the revision_id (item_data_id)
    set item_data_id [content::item::new -parent_id $folder_id -content_type {as_item_data} -name "$as_item_id-$session_id-$choice_id_answer" -title "$as_item_id-$session_id-$choice_id_answer" ]
    set as_item_data_id [content::revision::new -item_id $item_data_id -content_type {as_item_data} -title "$as_item_id-$session_id-$choice_id_answer" -attributes [list [list session_id $session_id] [list event_id $event_id] [list subject_id $subject_id] [list staff_id $staff_id] [list as_item_id $as_item_id] [list choice_id_answer $choice_id_answer] [list boolean_answer $boolean_answer] [list numeric_answer $numeric_answer] [list integer_answer $integer_answer] [list text_answer $text_answer] [list timestamp_answer $timestamp_answer] [list content_answer $content_answer] [list signed_data $signed_data] [list percent_score $percent_score] ] ]

    return $as_item_data_id
}
