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
    {-correct_answer_p:boolean ""}
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
    {-title:required}
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

    foreach choice $choices {
	as_item_choice_new -mc_id $as_item_type_mc_id $choice
    }

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

    New Item Display RadioButton Type to the data database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_display_rb in the CR (and as_item_display_rb table) getting the revision_id (as_item_display_id)
    set item_item_display_rb_id [content::item::new -parent_id $folder_id -content_type {as_item_display_rb} -name $name]
    set as_item_display_rb_id [content::revision::new -item_id $item_item_display_rb_id -content_type {as_item_display_rb} -attributes [list [list html_display_options $html_display_options] [list choice_orientation $choice_orientation] [list choice_label_orientation $choice_label_orientation] [list sort_order_type $sort_order_type] [list item_answer_alignment $item_answer_alignment] ] ]

    return $as_item_display_rb_id
}

ad_proc -public as_item_new {
    {-name:required}
    {-title:required}
    {-type ""}
    {-type_attributes ""}
    {-display ""}
    {-display_attributes ""}
    {-subtext ""}
    {-field_code ""}
    {-definition ""}
    {-required_p ""}
    {-data_type ""}
    {-max_time_to_complete ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New item to the data database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item in the CR (and as_assessments table) getting the revision_id (as_item_id)
    set item_item_id [content::item::new -parent_id $folder_id -content_type {as_items} -name $name -title $title ]
    set as_item_id [content::revision::new -item_id $item_item_id -content_type {as_items} -title $title -attributes [list [list subtext $subtext] [list field_code $field_code] [list definition $definition] [list required_p $required_p] [list data_type $data_type] [list max_time_to_complete $max_time_to_complete] ] ]

    if {$type == {mc}} {
        set as_item_type_id [as_item_type_mc_new $type_attributes]
    }

    if {$display == {rb}} {
        set as_item_display_id [as_item_display_rb_new $display_attributes]
    }

    # rel display and type to the item
    content::item::relate -item_id $as_item_id -object_id $as_item_type_id -relation_tag {as_item_type_rel}
    content::item::relate -item_id $as_item_id -object_id $as_item_display_id -relation_tag {as_item_display_rel}

    return $as_item_id
}
