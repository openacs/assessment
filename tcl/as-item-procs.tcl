ad_library {
    Item procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item {}

ad_proc -public as::item::new {
    {-name:required}
    {-title:required}
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
    set item_item_id [content::item::new -parent_id $folder_id -content_type {as_items} -name $name -title $title ]
    set as_item_id [content::revision::new -item_id $item_item_id -content_type {as_items} -title $title -attributes [list [list subtext $subtext] [list field_code $field_code] [list definition $definition] [list required_p $required_p] [list data_type $data_type] [list max_time_to_complete $max_time_to_complete] [list feedback_right $feedback_right] [list feedback_wrong $feedback_wrong] ] ]

    return $as_item_id
}