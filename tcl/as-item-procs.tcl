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
    if { (![info exists package_id] || $package_id eq "") } {
    	set package_id [ad_conn package_id]
    }
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item in the CR (and as_items table) getting the revision_id (as_item_id)
    db_transaction {
	if {$item_item_id eq ""} {
	    set item_item_id [db_nextval acs_object_id_seq]
	}
	set name "QUE_$item_item_id"
	if {$field_name eq ""} {
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
			     -title [string range $title 0 999] \
			     -content $title \
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
			     -content $content \
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
    if {![db_0or1row get_latest_item_id {}] && $default ne ""} {
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
    if { (![info exists package_id] || $package_id eq "") } {
    	set package_id [ad_conn package_id]
    }
    set folder_id [as::assessment::folder_id -package_id $package_id]
    set new_title $title
    db_transaction {
	db_1row item_data {}

	set item_item_id [db_nextval acs_object_id_seq]
	set name "QUE_$item_item_id"
	if {$field_name eq ""} {
	    set field_name $name
	}

        set item_item_id [content::item::new -item_id $item_item_id -parent_id $folder_id -content_type {as_items} -name $name -storage_type text]
        set new_item_id [content::revision::new \
			     -item_id $item_item_id \
			     -content_type {as_items} \
			     -title [string range $new_title 0 999] \
			     -content $new_title \
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
	    lassign $subtype type_id type
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

ad_proc -private as::item::get_item_type_info {
    -as_item_id
    {-array_name item_type_info}
} {
    An array of revision_id, item_type, object_type of a certain as_item
    
    @param as_item_id Revision_id of as_item object
    @param array_name Name of array to create in caller's scope via upvar

    @return 0 if as_item does not exists, 1 if it does

    @author Dave Bauer (dave@solutiongrove.com)
    @creation-date 2006-10-26
} {
    upvar $array_name column_array
    db_0or1row get_item_type_info {} -column_array column_array
}

ad_proc -private as::item::update_item_type {
    -item_type_id
    -as_item_id
} {
    Update the item_type of an as_item object. This could happen if you change the type of a
    question (as_item), and the associated as_item_type object that was related changed.
    @param item_type_id revision_id of as_item_type_* object
    @parma as_item_id revision_id of as_item_object
   
    @return does not return anything interesting

    @author Dave Bauer (dave@solutiongrove.com)
    @creation-date 2006-10-26
} {
    db_dml update_item_type {}
}

ad_proc -private as::item::update_item_in_section {
    -new_item_id
    -old_item_id
    -new_section_id
} {
    Update new item in section
} {
    db_dml update_item_in_section {}
}

ad_proc -private as::item::update_item_type_in_item {
    -new_item_id
    -new_item_type_id
    -old_item_type_id
} {
    Update new item type in item
} {
    db_dml update_item_type_in_item {}
}

ad_proc -private as::item::get_item_type_id {
    -as_item_id 
} {
    Get the item type id
} {
    return [db_string item_type_id {}]    
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
