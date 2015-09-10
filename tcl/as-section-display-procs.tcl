ad_library {
    Section Display Type procs
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-09
}

namespace eval as::section_display {}

ad_proc -public as::section_display::new {
    {-title:required}
    {-description ""}
    {-num_items ""}
    {-adp_chunk ""}
    {-branched_p ""}
    {-back_button_p ""}
    {-submit_answer_p ""}
    {-sort_order_type ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-09

    New section display type to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_section_display_type in the CR (and as_section_display_types table) getting the revision_id (display_type_id)
    db_transaction {
	set display_item_id [content::item::new -parent_id $folder_id -content_type {as_section_display_types} -name [as::item::generate_unique_name]]

	set display_id [content::revision::new \
			    -item_id $display_item_id \
			    -content_type {as_section_display_types} \
			    -title $title \
			    -description $description \
			    -attributes [list [list num_items $num_items] \
					     [list branched_p $branched_p] \
					     [list back_button_p $back_button_p] \
					     [list submit_answer_p $submit_answer_p] \
					     [list sort_order_type $sort_order_type] ] ]
    }
    db_dml update_clobs "" -clobs [list $adp_chunk]
    return $display_id
}

ad_proc -public as::section_display::edit {
    {-display_type_id:required}
    {-title:required}
    {-description ""}
    {-num_items ""}
    {-adp_chunk ""}
    {-branched_p ""}
    {-back_button_p ""}
    {-submit_answer_p ""}
    {-sort_order_type ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-09

    Edit section display type in the database
} {
    # edit as_section_display_type in the CR
    set display_item_id [db_string display_item_id {}]

    db_transaction {
	set display_id [content::revision::new \
			    -item_id $display_item_id \
			    -content_type {as_section_display_types} \
			    -title $title \
			    -description $description \
			    -attributes [list [list num_items $num_items] \
					     [list branched_p $branched_p] \
					     [list back_button_p $back_button_p] \
					     [list submit_answer_p $submit_answer_p] \
					     [list sort_order_type $sort_order_type] ] ]
    }
    db_dml update_clobs "" -clobs [list $adp_chunk]
    return $display_id
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
