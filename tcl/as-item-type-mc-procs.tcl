ad_library {
    Multiple choice item procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item_type_mc {}


ad_proc -public as::item_type_mc::new {
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
    db_transaction {
        set item_item_type_mc_id [content::item::new -parent_id $folder_id -content_type {as_item_type_mc} -name [exec uuidgen] -title $title ]
        set as_item_type_mc_id [content::revision::new \
				-item_id $item_item_type_mc_id \
				-content_type {as_item_type_mc} \
				-title $title \
				-attributes [list [list increasing_p $increasing_p] \
						[list allow_negative_p $allow_negative_p] \
						[list num_correct_answers $num_correct_answers] \
						[list num_answers $num_answers] ] ]
    }

    return $as_item_type_mc_id
}

ad_proc -public as::item_type_mc::edit {
    -as_item_type_id:required
    {-title ""}
    {-increasing_p ""}
    {-allow_negative_p ""}
    {-num_correct_answers ""}
    {-num_answers ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Edit Multiple Choice item to the data database
} {
    # Update as_item_type_mc in the CR (and as_item_type_mc table) getting the revision_id (as_item_type_id)
    db_transaction {
	set type_item_id [db_string type_item_id {}]
        set new_item_type_id [content::revision::new \
				  -item_id $type_item_id \
				  -content_type {as_item_type_mc} \
				  -title $title \
				  -attributes [list [list increasing_p $increasing_p] \
						   [list allow_negative_p $allow_negative_p] \
						   [list num_correct_answers $num_correct_answers] \
						   [list num_answers $num_answers] ] ]
    }

    return $new_item_type_id
}

ad_proc -public as::item_type_mc::new_revision {
    -as_item_type_id:required
    {-with_choices_p "t"}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Create new revision of Multiple Choice item in the data database
} {
    # Update as_item_type_mc in the CR (and as_item_type_mc table) getting the revision_id (as_item_type_id)
    db_transaction {
	db_1row item_type_data {}
        set new_item_type_id [content::revision::new \
				  -item_id $type_item_id \
				  -content_type {as_item_type_mc} \
				  -title $title \
				  -attributes [list [list increasing_p $increasing_p] \
						   [list allow_negative_p $allow_negative_p] \
						   [list num_correct_answers $num_correct_answers] \
						   [list num_answers $num_answers] ] ]

	if {$with_choices_p == "t"} {
	    set choices [db_list get_choices {}]
	    foreach choice_id $choices {
		set new_choice_id [as::item_choice::new_revision -choice_id $choice_id -mc_id $new_item_type_id]
	    }
	}
    }

    return $new_item_type_id
}

ad_proc -public as::item_type_mc::copy {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copy a Multiple Choice Type
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_type_mc in the CR (and as_item_type_mc table) getting the revision_id (as_item_type_id)
    db_transaction {
	db_1row item_type_data {}

	set new_item_type_id [new -title $title \
				  -increasing_p $increasing_p \
				  -allow_negative_p $allow_negative_p \
				  -num_correct_answers $num_correct_answers \
				  -num_answers $num_answers]

	set choices [db_list get_choices {}]
	foreach choice_id $choices {
	    set new_choice_id [as::item_choice::copy -choice_id $choice_id -mc_id $new_item_type_id]
	}
    }

    return $new_item_type_id
}
