ad_library {
    Assessment procs
    @author eperez@it.uc3m.es
    @creation-date 2004-07-26
}

ad_proc -public as_item_choice_new {
    {-name:required}
    {-title:required}
    {-description ""}
    {-parent_id:required}
    {-data_type ""}
    {-numeric_value ""}
    {-text_value ""}
    {-boolean:boolean ""}
    {-content_value ""}
    {-feedback_text ""}
    {-selected_p:boolean ""}
    {-corrent_answer_p:boolean ""}
    {-score ""}
    {-sort_order ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New item choice to the data database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_choice in the CR (and as_item_choices table) getting the revision_id (as_item_choice_id)
    set item_choice_id [content::item::new -parent_id $folder_id -content_type {as_item_choices} -name $name -title $title ]
    set as_item_choice_id [content::revision::new -item_id $item_choice_id -content_type {as_item_choices} -title $title -attributes [list [list parent_id $parent_id ] [list data_type $data_type ] [list numeric_value $numeric_value ] [list $text_value text_value] [list boolean $boolean] [list content_value $content_value] [list feedback_text $feedback_text] [list selected_p $selected_p] [list corrent_answer_p $corrent_answer_p] [list score $score] [list sort_order $sort_order] ] ]
    # FIXME too much code repetition here
    # maybe there are more efficient ways to to it (maybe using hashes to pass the values between functions)
    return $as_item_choice_id
}

ad_proc -public as_item_mc_new {
    {-name:required}
    {-title:required}
    {-description ""}
    {-increasing_p ""}
    {-allow_negative_p ""}
    {-num_correct_answers ""}
    {-num_answers ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New Multiple Choice item to the data database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_type_mc in the CR (and as_assessments table) getting the revision_id (as_item_id)
    set item_item_type_mc_id [content::item::new -parent_id $folder_id -content_type {as_item_type_mc} -name $as_items__name -title $as_items__title ]
    set as_item_type_mc_id [content::revision::new -item_id $item_item_id -content_type {as_item_type_mc} -title $as_items__title -attributes [list [list increasing_p $increasing_p] [list allow_negative_p $allow_negative_p] [list num_correct_answers $num_correct_answers] [list num_answers $num_answers] ] ]

}

ad_proc -public as_item_new {
    {-name:required}
    {-title:required}
    {-description ""}
    {-item_type_id ""}
    {-item_display_type_id ""}
    {-item_subtext ""}
    {-field_code ""}
    {-enabled_p ""}
    {-required_p ""}
    {-item_default ""}
    {-max_time_to_complete ""}
    {-adp_chunk ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New item to the data database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item in the CR (and as_assessments table) getting the revision_id (as_item_id)
    set item_item_id [content::item::new -parent_id $folder_id -content_type {as_items} -name $name -title $title ]
    set as_item_id [content::revision::new -item_id $item_item_id -content_type {as_items} -title $title -attributes [list [list item_type_id $item_type_id] [list item_display_type_id $item_display_type_id] [list item_subtext $item_subtext] [list field_code $field_code] [list enabled_p $enabled_p] [list required_p $required_p] [list item_default $item_default] [list max_time_to_complete $max_time_to_complete] [list adp_chunk $adp_chunk] ] ]

    return $as_item_id
}
