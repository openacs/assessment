ad_library {
    Item display short answer Type procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item_display_sa {}

ad_proc -public as::item_display_sa::new {
    {-html_display_options ""}
    {-abs_size ""}
    {-box_orientation ""}    
} {
    @author Natalia Perez (nperper@it.uc3m.es)
    @creation-date 2004-09-29

    New Item Display Short Answer Type to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_display_sa in the CR (and as_item_display_sa table) getting the revision_id (as_item_display_id)
    db_transaction {
        set item_item_display_sa_id [content::item::new -parent_id $folder_id -content_type {as_item_display_sa} -name [ad_generate_random_string]]
        set as_item_display_sa_id [content::revision::new \
				-item_id $item_item_display_sa_id \
				-content_type {as_item_display_sa} \
				-attributes [list [list html_display_options $html_display_options] \
						[list abs_size $abs_size] \
						[list box_orientation $box_orientation] ] ]
    }

    return $as_item_display_sa_id
}