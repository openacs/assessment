ad_library {
    Section procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::section {}

ad_proc -public as::section::new {
    {-name:required}
    {-title:required}
    {-description ""}
    {-instructions ""}
    {-feedback_text ""}
    {-max_time_to_complete ""}
    {-display_type_id ""}
    {-points ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New section to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_section in the CR (and as_sections table) getting the revision_id (as_section_id)
    db_transaction {
	set section_item_id [db_nextval acs_object_id_seq]
	if {[empty_string_p $name]} {
	    set name "SEC_$section_item_id"
	}
	set section_item_id [content::item::new -item_id $section_item_id -parent_id $folder_id -content_type {as_sections} -name $name -title $title -description $description ]

	set as_section_id [content::revision::new \
			       -item_id $section_item_id \
			       -content_type {as_sections} \
			       -title $title \
			       -description $description \
			       -attributes [list [list instructions $instructions] \
						[list feedback_text $feedback_text] \
						[list max_time_to_complete $max_time_to_complete] \
						[list display_type_id $display_type_id] \
						[list points $points] ] ]
    }

    return $as_section_id
}

ad_proc -public as::section::edit {
    {-section_id:required}
    {-title:required}
    {-description ""}
    {-instructions ""}
    {-feedback_text ""}
    {-max_time_to_complete ""}
    {-display_type_id ""}
    {-points ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-10-26

    Edit section in the database
} {
    # edit as_section in the CR
    set section_item_id [db_string section_item_id {}]

    db_transaction {
	set new_section_id [content::revision::new \
				-item_id $section_item_id \
				-content_type {as_sections} \
				-title $title \
				-description $description \
				-attributes [list [list instructions $instructions] \
						 [list feedback_text $feedback_text] \
						 [list max_time_to_complete $max_time_to_complete] \
						 [list display_type_id $display_type_id] \
						 [list points $points] ] ]

	copy_items -section_id $section_id -new_section_id $new_section_id
    }

    return $new_section_id
}

ad_proc -public as::section::new_revision {
    {-section_id:required}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-11-07

    Creates a new revision of a section with all items
} {
    # edit as_section in the CR
    db_transaction {
	db_1row section_data {}
	set new_section_id [content::revision::new \
				-item_id $section_item_id \
				-content_type {as_sections} \
				-title $title \
				-description $description \
				-attributes [list [list instructions $instructions] \
						 [list feedback_text $feedback_text] \
						 [list max_time_to_complete $max_time_to_complete] \
						 [list display_type_id $display_type_id] \
						 [list points $points] ] ]

	copy_items -section_id $section_id -new_section_id $new_section_id
	as::assessment::copy_categories -from_id $section_id -to_id $new_section_id
    }

    return $new_section_id
}

ad_proc -public as::section::copy {
    {-section_id:required}
    {-name:required}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-11-07

    Copies a section with all items
} {
    # edit as_section in the CR
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    db_transaction {
	db_1row section_data {}
	append title "[_ assessment.copy_appendix]"

	set section_item_id [db_nextval acs_object_id_seq]
	if {[empty_string_p $name]} {
	    set name "SEC_$section_item_id"
	}
	set section_item_id [content::item::new -item_id $section_item_id -parent_id $folder_id -content_type {as_sections} -name $name -title $title -description $description ]
	set new_section_id [content::revision::new \
				-item_id $section_item_id \
				-content_type {as_sections} \
				-title $title \
				-description $description \
				-attributes [list [list instructions $instructions] \
						 [list feedback_text $feedback_text] \
						 [list max_time_to_complete $max_time_to_complete] \
						 [list required_p $required_p] \
						 [list display_type_id $display_type_id] \
						 [list points $points] ] ]

	copy_items -section_id $section_id -new_section_id $new_section_id
	as::assessment::copy_categories -from_id $section_id -to_id $new_section_id
    }

    return $new_section_id
}

ad_proc as::section::copy_items {
    {-section_id:required}
    {-new_section_id:required}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-11-07

    Copies all items from section_id to new_section_id
} {
    db_dml copy_items {}
}
