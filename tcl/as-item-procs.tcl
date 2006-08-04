ad_library {
    Item procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item {}

ad_proc -public as::item::new {
    {-item_item_id ""}
    {-title:required}
    {-description ""}
    {-subtext ""}
    {-field_name ""}
    {-field_code ""}
    {-required_p ""}
    {-data_type ""}
    {-max_time_to_complete ""}
    {-feedback_right ""}
    {-feedback_wrong ""}
    {-points ""}
    {-package_id ""}
    {-validate_block ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New item to the database
} {
    if { ![exists_and_not_null package_id] } {
    	set package_id [ad_conn package_id]
    }
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item in the CR (and as_items table) getting the revision_id (as_item_id)
    db_transaction {
	if {[empty_string_p $item_item_id]} {
	    set item_item_id [db_nextval acs_object_id_seq]
	}
	set name "QUE_$item_item_id"
	if {[empty_string_p $field_name]} {
	    set field_name $name
	}
        set item_item_id [content::item::new -item_id $item_item_id -parent_id $folder_id -content_type {as_items} -name $name -creation_user [ad_conn user_id] -creation_ip [ad_conn peeraddr] -storage_type text]

        set as_item_id [content::revision::new -item_id $item_item_id \
			    -content_type {as_items} \
			    -title [string range $title 0 999] \
                            -content $title \
                            -mime_type "text/html" \
			    -description $description \
			    -attributes [list [list subtext $subtext] \
					     [list field_name $field_name] \
					     [list field_code $field_code] \
					     [list required_p $required_p] \
					     [list data_type $data_type] \
					     [list max_time_to_complete $max_time_to_complete] \
						 [list points $points] ] ]
    }
    db_dml update_clobs "" -clobs [list $feedback_right $feedback_wrong $validate_block]
    return $as_item_id
}

ad_proc -public as::item::edit {
    -as_item_id:required
    {-title:required}
    {-description ""}
    {-subtext ""}
    {-field_name ""}
    {-field_code ""}
    {-required_p ""}
    {-data_type ""}
    {-max_time_to_complete ""}
    {-feedback_right ""}
    {-feedback_wrong ""}
    {-points ""}
    {-validate_block ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Edit item to the database
} {
    # Update as_item in the CR (and as_items table) getting the revision_id (as_item_id)
    db_transaction {
	set item_item_id [db_string item_item_id {}]
        set new_item_id [content::revision::new \
			     -item_id $item_item_id \
			     -content_type {as_items} \
			     -title $title \
			     -description $description \
			     -attributes [list [list subtext $subtext] \
					      [list field_name $field_name] \
					      [list field_code $field_code] \
					      [list required_p $required_p] \
					      [list data_type $data_type] \
					      [list max_time_to_complete $max_time_to_complete] \
						  [list points $points] ] ]

	copy_types -as_item_id $as_item_id -new_item_id $new_item_id
    }
    db_dml update_clobs "" -clobs [list $feedback_right $feedback_wrong $validate_block]
    return $new_item_id
}

ad_proc -public as::item::new_revision {
    -as_item_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Creates a new revision of an item in the database
} {
    # Update as_item in the CR (and as_items table) getting the revision_id (as_item_id)
    db_transaction {
	db_1row item_data {}
        set new_item_id [content::revision::new \
			     -item_id $item_item_id \
			     -content_type {as_items} \
			     -title $title \
			     -description $description \
			     -attributes [list [list subtext $subtext] \
					      [list field_name $field_name] \
					      [list field_code $field_code] \
					      [list required_p $required_p] \
					      [list data_type $data_type] \
					      [list max_time_to_complete $max_time_to_complete] \
					      [list points $points] ] ]

	copy_types -as_item_id $as_item_id -new_item_id $new_item_id
	as::assessment::copy_categories -from_id $as_item_id -to_id $new_item_id
    }
    db_dml update_clobs "" -clobs [list $feedback_right $feedback_wrong $validate_block]

    return $new_item_id
}

ad_proc -public as::item::latest {
    -as_item_id:required
    -section_id:required
    {-default ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-13

    Returns the latest revision of an item
} {
    if {![db_0or1row get_latest_item_id {}] && ![empty_string_p $default]} {
	return $default
    }
    return $as_item_id
}

ad_proc -public as::item::copy {
    {-as_item_id:required}
    -title:required
    {-description ""}
    {-field_name ""}
    {-package_id ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copies an item in the database
} {
    # Update as_item in the CR (and as_items table) getting the revision_id (as_item_id)
    if { ![exists_and_not_null package_id] } {
    	set package_id [ad_conn package_id]
    }
    set folder_id [as::assessment::folder_id -package_id $package_id]

    db_transaction {
	db_1row item_data {}

	set item_item_id [db_nextval acs_object_id_seq]
	set name "QUE_$item_item_id"
	if {[empty_string_p $field_name]} {
	    set field_name $name
	}

        set item_item_id [content::item::new -item_id $item_item_id -parent_id $folder_id -content_type {as_items} -name $name]
        set new_item_id [content::revision::new \
			     -item_id $item_item_id \
			     -content_type {as_items} \
			     -title $title \
			     -description $description \
			     -attributes [list [list subtext $subtext] \
					      [list field_name $field_name] \
					      [list field_code $field_code] \
					      [list required_p $required_p] \
					      [list data_type $data_type] \
					      [list max_time_to_complete $max_time_to_complete] \
					      [list feedback_right $feedback_right] \
					      [list feedback_wrong $feedback_wrong] \
					      [list points $points] \
					      [list validate_block $validate_block] ] ]

	as::assessment::copy_categories -from_id $as_item_id -to_id $new_item_id

	set subtypes [db_list_of_lists item_subtypes {}]
	foreach subtype $subtypes {
	    util_unlist $subtype type_id type
	    set new_type_id [eval as::[string range $type 3 end]::copy -type_id $type_id]
	    as::item_rels::new -item_rev_id $new_item_id -target_rev_id $new_type_id -type "[string range $type 0 end-2]rel"
	}
    }

    return $new_item_id
}

ad_proc as::item::copy_types {
    {-as_item_id:required}
    {-new_item_id:required}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copies item types and display types from as_item_id to new_item_id
} {
    db_dml copy_types {}
}

ad_proc -public as::item::item_data {
    -as_item_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-04-13

    Return cached item data
} {
    return [util_memoize [list as::item::item_data_not_cached -as_item_id $as_item_id]]
}

ad_proc -private as::item::item_data_not_cached  {
    -as_item_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-04-08

    Gets the item type and display
} {
    db_1row item_properties {} -column_array item

    set item(item_type) [lindex [split $item(item_type) "_"] end]
    set item(display_type) [lindex [split $item(display_type) "_"] end]

    return [array get item]
}

ad_proc -private as::item::generate_unique_name {
    args
} {
    Generate a unique string to be used as item name
    
    @author Roel Canicula (roelmc@info.com.ph)
    @creation-date 2005-05-06
    
    @param args

    @return 
    
    @error 
} {
    if { [llength $args] } {
	return [join $args "-"]
    } elseif { ! [catch {set uuid [exec uuidgen]}] } {
	return $uuid
    } else {
	return "[clock seconds]-[expr round([ns_rand]*100000)]"
    }
}
