ad_library {
    Item display checkbox Type procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item_display_cb {}

ad_proc -public as::item_display_cb::new {
    {-name:required}
    {-html_display_options ""}
    {-choice_orientation ""}
    {-choice_label_orientation ""}
    {-sort_order_type ""}
    {-item_answer_alignment ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @author Natalia Perez (nperper@it.uc3m.es)
    @creation-date 2004-09-23

    New Item Display CheckBox Type to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_display_cb in the CR (and as_item_display_cb table) getting the revision_id (as_item_display_id)
    set item_item_display_cb_id [content::item::new -parent_id $folder_id -content_type {as_item_display_cb} -name $name]
    set as_item_display_cb_id [content::revision::new -item_id $item_item_display_cb_id -content_type {as_item_display_cb} -attributes [list [list html_display_options $html_display_options] [list choice_orientation $choice_orientation] [list choice_label_orientation $choice_label_orientation] [list sort_order_type $sort_order_type] [list item_answer_alignment $item_answer_alignment] ] ]

    return $as_item_display_cb_id
}