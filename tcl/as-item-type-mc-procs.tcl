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
        set item_item_type_mc_id [content::item::new -parent_id $folder_id -content_type {as_item_type_mc} -name [ad_generate_random_string] -title $title ]
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