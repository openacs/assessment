ad_library {
    Item display textarea Type procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item_display_ta {}

ad_proc -public as::item_display_ta::new {
    {-html_display_options ""}
    {-abs_size ""}
    {-acs_widget ""}    
    {-item_answer_alignment ""}
} {
    @author Natalia Perez (nperper@it.uc3m.es)
    @creation-date 2004-09-29

    New Item Display TextArea Type to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_display_ta in the CR (and as_item_display_ta table) getting the revision_id (as_item_display_id)
    db_transaction {
        set item_item_display_ta_id [content::item::new -parent_id $folder_id -content_type {as_item_display_ta} -name [exec uuidgen]]
        set as_item_display_ta_id [content::revision::new \
				-item_id $item_item_display_ta_id \
				-content_type {as_item_display_ta} \
				-attributes [list [list html_display_options $html_display_options] \
						[list abs_size $abs_size] \
						[list acs_widget $acs_widget] \
						[list item_answer_alignment $item_answer_alignment] ] ]
    }

    return $as_item_display_ta_id
}

ad_proc -public as::item_display_ta::edit {
    -as_item_display_id:required
    {-html_display_options ""}
    {-abs_size ""}
    {-acs_widget ""}    
    {-item_answer_alignment ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Edit Item Display TextArea Type to the database
} {
    # Update as_item_display_ta in the CR (and as_item_display_ta table) getting the revision_id (as_item_display_id)
    db_transaction {
	set display_item_id [db_string display_item_id {}]
        set new_item_display_id [content::revision::new \
				     -item_id $display_item_id \
				     -content_type {as_item_display_ta} \
				     -attributes [list [list html_display_options $html_display_options] \
						      [list abs_size $abs_size] \
						      [list acs_widget $acs_widget] \
						      [list item_answer_alignment $item_answer_alignment] ] ]
    }

    return $new_item_display_id
}

ad_proc -public as::item_display_ta::copy {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copy an Item Display TextArea Type
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_display_ta in the CR (and as_item_display_ta table) getting the revision_id (as_item_display_id)
    db_transaction {
	db_1row display_item_data {}

	set new_item_display_id [new -html_display_options $html_display_options \
				     -abs_size $abs_size \
				     -acs_widget $acs_widget \
				     -item_answer_alignment $item_answer_alignment]
    }

    return $new_item_display_id
}
