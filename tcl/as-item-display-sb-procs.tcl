ad_library {
    Item display selectbox Type procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item_display_sb {}

ad_proc -public as::item_display_sb::new {
    {-html_display_options ""}
    {-multiple_p "f"}
    {-choice_label_orientation ""}
    {-sort_order_type ""}
    {-item_answer_alignment ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-08

    New Item Display SelectBox Type to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_display_sb in the CR (and as_item_display_sb table) getting the revision_id (as_item_display_id)
    db_transaction {
        set item_item_display_sb_id [content::item::new -parent_id $folder_id -content_type {as_item_display_sb} -name [exec uuidgen]]
	set as_item_display_cb_id [content::revision::new \
				-item_id $item_item_display_cb_id \
				-content_type {as_item_display_sb} \
				-attributes [list [list html_display_options $html_display_options] \
						[list mulitple_p $multiple_p] \
						[list choice_label_orientation $choice_label_orientation] \
						[list sort_order_type $sort_order_type] \
						[list item_answer_alignment $item_answer_alignment] ] ]	
    }

    return $as_item_display_sb_id
}

ad_proc -public as::item_display_sb::edit {
    -as_item_display_id:required
    {-html_display_options ""}
    {-multiple_p "f"}
    {-choice_label_orientation ""}
    {-sort_order_type ""}
    {-item_answer_alignment ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-08

    Edit Item Display SelectBox Type to the database
} {
    # Update as_item_display_sb in the CR (and as_item_display_sb table) getting the revision_id (as_item_display_id)
    db_transaction {
	set display_item_id [db_string display_item_id {}]
	set new_item_display_id [content::revision::new \
				     -item_id $display_item_id \
				     -content_type {as_item_display_sb} \
				     -attributes [list [list html_display_options $html_display_options] \
						      [list multiple_p $multiple_p] \
						      [list choice_label_orientation $choice_label_orientation] \
						      [list sort_order_type $sort_order_type] \
						      [list item_answer_alignment $item_answer_alignment] ] ]	
    }

    return $new_item_display_id
}

ad_proc -public as::item_display_sb::copy {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copy an Item Display SelectBox Type
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_display_sb in the CR (and as_item_display_sb table) getting the revision_id (as_item_display_id)
    db_transaction {
	db_1row display_item_data {}

	set new_item_display_id [new -html_display_options $html_display_options \
				     -multiple_p $multiple_p \
				     -choice_label_orientation $choice_label_orientation \
				     -sort_order_type $sort_order_type \
				     -item_answer_alignment $item_answer_alignment]
    }

    return $new_item_display_id
}
