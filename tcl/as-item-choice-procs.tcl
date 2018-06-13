ad_library {
    Item choice procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item_choice {}

ad_proc -public as::item_choice::new {
    {-mc_id:required}
    {-title:required}
    {-data_type ""}
    {-numeric_value ""}
    {-text_value ""}
    {-boolean_value ""}
    {-content_value ""}
    {-feedback_text ""}
    {-selected_p ""}
    {-correct_answer_p ""}
    {-sort_order ""}
    {-percent_score ""}
    {-fixed_position ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New item choice to the data database
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_choice in the CR (and as_item_choices table) getting the revision_id (as_item_choice_id)
    db_transaction {
        set item_choice_id [content::item::new -parent_id $folder_id -content_type {as_item_choices} -name [as::item::generate_unique_name]]
        set as_item_choice_id [content::revision::new \
            -item_id $item_choice_id \
            -content_type {as_item_choices} \
            -title $title \
            -attributes [list [list mc_id $mc_id ] \
                [list data_type $data_type ] \
                [list numeric_value $numeric_value ] \
                [list text_value $text_value] \
                [list boolean_value $boolean_value] \
                [list content_value $content_value] \
                [list feedback_text $feedback_text] \
                [list selected_p $selected_p] \
                [list correct_answer_p $correct_answer_p] \
                [list sort_order $sort_order] \
                [list percent_score $percent_score] \
                [list fixed_position $fixed_position] ] ]
    # FIXME too much code repetition here
    # maybe there are more efficient ways to do it (maybe using hashes to pass the values between functions)
    }

    return $as_item_choice_id
}

ad_proc -public as::item_choice::new_revision {
    -choice_id:required
    -mc_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    New item choice revision
} {
    # New revision of as_item_choice in the CR (and as_item_choices table) getting the revision_id (as_item_choice_id)
    db_transaction {
        db_1row choice_data {}
        set as_item_choice_id [content::revision::new \
                -item_id $item_choice_id \
                -content_type {as_item_choices} \
                -title $title \
                -attributes [list [list mc_id $mc_id ] \
                    [list data_type $data_type ] \
                    [list numeric_value $numeric_value ] \
                    [list text_value $text_value] \
                    [list boolean_value $boolean_value] \
                    [list content_value $content_value] \
                    [list feedback_text $feedback_text] \
                    [list selected_p $selected_p] \
                    [list correct_answer_p $correct_answer_p] \
                    [list sort_order $sort_order] \
                    [list percent_score $percent_score] \
                    [list fixed_position $fixed_position] ] ]
    }


    return $as_item_choice_id
}

ad_proc -public as::item_choice::copy {
    -choice_id:required
    -mc_id:required
    {-copy_correct_answer_p "t"}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copy a Multiple Choice
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_choice in the CR (and as_item_choices table) getting the revision_id (as_item_choice_id)
    db_transaction {
        db_1row choice_data {}
        if {![string is true $copy_correct_answer_p]} {
            set correct_answer_p ""
        }
        set new_choice_id [new -title $title \
                   -mc_id $mc_id \
                   -data_type $data_type \
                   -numeric_value $numeric_value \
                   -text_value $text_value \
                   -boolean_value $boolean_value \
                   -content_value $content_value \
                   -feedback_text $feedback_text \
                   -selected_p $selected_p \
                   -correct_answer_p $correct_answer_p \
                   -sort_order $sort_order \
                   -percent_score $percent_score \
                   -fixed_position $fixed_position]
    }

    return $new_choice_id
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
