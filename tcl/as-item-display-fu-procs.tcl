ad_library {
    Item display short answer Type procs
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation-date 2005-06-24
}

namespace eval as::item_display_f {}

ad_proc -public as::item_display_f::new {
    {-html_display_options ""}
    {-abs_size ""}
    {-box_orientation ""}    
} {
    New Item Display File Upload Type to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]
    
    # Insert as_item_display_f in the CR (and as_item_display_f table) getting the revision_id (as_item_display_id)
    db_transaction {
        set item_item_display_f_id [content::item::new -parent_id $folder_id -content_type {as_item_display_f} -name [as::item::generate_unique_name]]
        set as_item_display_f_id [content::revision::new \
				-item_id $item_item_display_f_id \
				-content_type {as_item_display_f} \
				-attributes [list [list html_display_options $html_display_options] \
						[list abs_size $abs_size] \
						[list box_orientation $box_orientation] ] ]
    }

    return $as_item_display_f_id
}

ad_proc -public as::item_display_f::edit {
    -as_item_display_id:required
    {-html_display_options ""}
    {-abs_size ""}
    {-box_orientation ""}    
} {

    Edit Item Display File Upload Type to the database
} {
    # Update as_item_display_f in the CR (and as_item_display_f table) getting the revision_id (as_item_display_id)
    db_transaction {
	set display_item_id [db_string display_item_id {}]
        set new_item_display_id [content::revision::new \
				     -item_id $display_item_id \
				     -content_type {as_item_display_f} \
				     -attributes [list [list html_display_options $html_display_options] \
						      [list abs_size $abs_size] \
						      [list box_orientation $box_orientation] ] ]
    }

    return $new_item_display_id
}

ad_proc -public as::item_display_f::copy {
    -type_id:required
} {

    Copy an Item Display File Upload Type
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_display_f in the CR (and as_item_display_f table) getting the revision_id (as_item_display_id)
    db_transaction {
	db_1row display_item_data {}

	set new_item_display_id [new -html_display_options $html_display_options \
				     -abs_size $abs_size \
				     -box_orientation $box_orientation]
    }

    return $new_item_display_id
}

ad_proc -public as::item_display_f::render {
    -form:required
    -element:required
    -type_id:required
    {-datatype "file"}
    {-title ""}
    {-subtext ""}
    {-required_p ""}
    {-random_p ""}
    {-default_value ""}
    {-data ""}
} {
    Render an Item Display File Upload Type
} {
    array set type [util_memoize [list as::item_display_f::data -type_id $type_id]]
    if {[empty_string_p $required_p]} {
	set required_p f
    }
    if {[empty_string_p $datatype]} {
	set datatype file
    }

    set optional ""
    if {$required_p != "t"} {
	set optional ",optional"
    }
    set param_list [list [list label $title] [list help_text $subtext] [list value $default_value] [list html $type(html_display_options)]]
    if {![empty_string_p $type(abs_size)]} {
	lappend param_list [list maxlength $type(abs_size)]
    }
    set element_params [concat [list "$element\:file$optional"] $param_list]

    ad_form -extend -name $form -form [list $element_params]
}

ad_proc -public as::item_display_f::data {
    -type_id:required
} {

    Get the cached Display Data of File Upload Type
} {
    return [util_memoize [list as::item_display_f::data_not_cached -type_id $type_id]]
}

ad_proc -private as::item_display_f::data_not_cached {
    -type_id:required
} {

    Get the Display Data of File Upload Type
} {
    db_1row display_item_data {} -column_array type
    return [array get type]
}

ad_proc -public as::item_display_f::view {
    -item_id:required
    -session_id:required
    -section_id:required
} {
    set file_id [db_string file_id {} -default "-1"]
    if { $file_id == -1 } {
	return 
    }
    return "view?revision_id=$file_id"
}