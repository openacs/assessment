ad_library {
    Open Question item procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item_type_oq {}

ad_proc -public as::item_type_oq::new {
    {-title ""}
    {-default_value ""}
    {-feedback_text ""}    
} {
    @author Natalia Perez (nperper@it.uc3m.es)
    @creation-date 2004-09-29

    New Open Question item to the data database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_type_oq in the CR (and as_item_type_oq table) getting the revision_id (as_item_type_id)
    db_transaction {
        set item_item_type_oq_id [content::item::new -parent_id $folder_id -content_type {as_item_type_oq} -name [ad_generate_random_string] -title $title ]
        set as_item_type_oq_id [content::revision::new \
				-item_id $item_item_type_oq_id \
				-content_type {as_item_type_oq} \
				-title $title \
				-attributes [list [list default_value $default_value] \
						[list feedback_text $feedback_text] ] ]
    }

    return $as_item_type_oq_id
}
