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
        set item_item_display_ta_id [content::item::new -parent_id $folder_id -content_type {as_item_display_ta} -name [ad_generate_random_string]]
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

