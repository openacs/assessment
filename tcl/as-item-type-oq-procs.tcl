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
        set item_item_type_oq_id [content::item::new -parent_id $folder_id -content_type {as_item_type_oq} -name [exec uuidgen] -title $title ]
        set as_item_type_oq_id [content::revision::new \
				-item_id $item_item_type_oq_id \
				-content_type {as_item_type_oq} \
				-title $title \
				-attributes [list [list default_value $default_value] \
						[list feedback_text $feedback_text] ] ]
    }

    return $as_item_type_oq_id
}

ad_proc -public as::item_type_oq::edit {
    -as_item_type_id:required
    {-title ""}
    {-default_value ""}
    {-feedback_text ""}    
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Edit Open Question item to the data database
} {
    # Update as_item_type_oq in the CR (and as_item_type_oq table) getting the revision_id (as_item_type_id)
    db_transaction {
	set type_item_id [db_string type_item_id {}]
        set new_item_type_id [content::revision::new \
				  -item_id $type_item_id \
				  -content_type {as_item_type_oq} \
				  -title $title \
				  -attributes [list [list default_value $default_value] \
						   [list feedback_text $feedback_text] ] ]
    }

    return $new_item_type_id
}

ad_proc -public as::item_type_oq::copy {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copy an Open Question Type
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_type_oq in the CR (and as_item_type_oq table) getting the revision_id (as_item_type_id)
    db_transaction {
	db_1row item_type_data {}

	set new_item_type_id [new -title $title \
				  -default_value $default_value \
				  -feedback_text $feedback_text]
    }

    return $new_item_type_id
}

ad_proc -public as::item_type_oq::render {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-10

    Render an Open Question Type
} {
    db_1row item_type_data {}

    return [list $default_value ""]
}

ad_proc -public as::item_type_oq::process {
    -type_id:required
    -session_id:required
    -as_item_id:required
    -subject_id:required
    {-staff_id ""}
    {-response ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-11

    Process a Response to an Open Question Type
} {
    as::item_data::new -session_id $session_id -subject_id $subject_id -staff_id $staff_id -as_item_id $as_item_id -clob_answer $response -points ""
}
