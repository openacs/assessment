ad_library {
    Item procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item {}

ad_proc -public as::item::new {
    {-title:required}
    {-description ""}
    {-subtext ""}
    {-field_code ""}
    {-definition ""}
    {-required_p ""}
    {-data_type ""}
    {-max_time_to_complete ""}
    {-feedback_right ""}
    {-feedback_wrong ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New item to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item in the CR (and as_items table) getting the revision_id (as_item_id)
    db_transaction {
        set item_item_id [content::item::new -parent_id $folder_id -content_type {as_items} -name [exec uuidgen] -title $title ]
        set as_item_id [content::revision::new -item_id $item_item_id \
			    -content_type {as_items} \
			    -title $title \
			    -description $description \
			    -attributes [list [list subtext $subtext] \
					     [list field_code $field_code] \
					     [list definition $definition] \
					     [list required_p $required_p] \
					     [list data_type $data_type] \
					     [list max_time_to_complete $max_time_to_complete] \
					     [list feedback_right $feedback_right] \
					     [list feedback_wrong $feedback_wrong] ] ]
    }

    return $as_item_id
}

ad_proc -public as::item::edit {
    -as_item_id:required
    {-title:required}
    {-description ""}
    {-subtext ""}
    {-field_code ""}
    {-definition ""}
    {-required_p ""}
    {-data_type ""}
    {-max_time_to_complete ""}
    {-feedback_right ""}
    {-feedback_wrong ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Edit item to the database
} {
    # Update as_item in the CR (and as_items table) getting the revision_id (as_item_id)
    db_transaction {
	set item_item_id [db_string item_item_id {}]
        set new_item_id [content::revision::new \
			     -item_id $item_item_id \
			     -content_type {as_items} \
			     -title $title \
			     -description $description \
			     -attributes [list [list subtext $subtext] \
					      [list field_code $field_code] \
					      [list definition $definition] \
					      [list required_p $required_p] \
					      [list data_type $data_type] \
					      [list max_time_to_complete $max_time_to_complete] \
					      [list feedback_right $feedback_right] \
					      [list feedback_wrong $feedback_wrong] ] ]

	copy_types -as_item_id $as_item_id -new_item_id $new_item_id
    }

    return $new_item_id
}

ad_proc -public as::item::new_revision {
    -as_item_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Creates a new revision of an item in the database
} {
    # Update as_item in the CR (and as_items table) getting the revision_id (as_item_id)
    db_transaction {
	db_1row item_data {}
        set new_item_id [content::revision::new \
			     -item_id $item_item_id \
			     -content_type {as_items} \
			     -title $title \
			     -description $description \
			     -attributes [list [list subtext $subtext] \
					      [list field_code $field_code] \
					      [list definition $definition] \
					      [list required_p $required_p] \
					      [list data_type $data_type] \
					      [list max_time_to_complete $max_time_to_complete] \
					      [list feedback_right $feedback_right] \
					      [list feedback_wrong $feedback_wrong] ] ]

	copy_types -as_item_id $as_item_id -new_item_id $new_item_id
	as::assessment::copy_categories -from_id $as_item_id -to_id $new_item_id
    }

    return $new_item_id
}

ad_proc -public as::item::copy {
    -as_item_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copies an item in the database
} {
    # Update as_item in the CR (and as_items table) getting the revision_id (as_item_id)
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    db_transaction {
	db_1row item_data {}
	append title "[_ assessment.copy_appendix]"

        set item_item_id [content::item::new -parent_id $folder_id -content_type {as_items} -name [exec uuidgen] -title $title ]
        set new_item_id [content::revision::new \
			     -item_id $item_item_id \
			     -content_type {as_items} \
			     -title $title \
			     -description $description \
			     -attributes [list [list subtext $subtext] \
					      [list field_code $field_code] \
					      [list definition $definition] \
					      [list required_p $required_p] \
					      [list data_type $data_type] \
					      [list max_time_to_complete $max_time_to_complete] \
					      [list feedback_right $feedback_right] \
					      [list feedback_wrong $feedback_wrong] ] ]

	as::assessment::copy_categories -from_id $as_item_id -to_id $new_item_id

	set subtypes [db_list_of_lists item_subtypes {}]
	foreach subtype $subtypes {
	    util_unlist $subtype type_id type
	    set new_type_id [eval as::[string range $type 3 end]::copy -type_id $type_id]
	    as::item_rels::new -item_rev_id $new_item_id -target_rev_id $new_type_id -type "[string range $type 0 end-2]rel"
	}
    }

    return $new_item_id
}

ad_proc as::item::copy_types {
    {-as_item_id:required}
    {-new_item_id:required}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copies item types and display types from as_item_id to new_item_id
} {
    db_dml copy_types {}
}
