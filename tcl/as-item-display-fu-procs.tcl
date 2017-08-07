ad_library {
    Item display file upload type procs
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
    -item:required
} {
    Render an Item Display File Upload Type
} {
    array set type [util_memoize [list as::item_display_f::data -type_id $type_id]]
    if {$required_p eq ""} {
	set required_p f
    }
    if {$datatype eq ""} {
	set datatype file
    }

    set optional ""
    if {$required_p != "t"} {
	set optional ",optional"
    }
    set param_list [list [list label \$title] [list help_text \$subtext] [list value \$default_value] [list html \$type(html_display_options)]]
    if {$type(abs_size) ne ""} {
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

ad_proc -private as::item_display_f::set_item_display_type {
    -assessment_id
    -section_id
    -as_item_id
    -after
    {-type ""}
    {-html_options {size 50 maxlength 1000}}
    {-abs_size "1000"}
    {-box_orientation "vertical"}
} {

} {
	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	set section_id [as::section::latest -section_id $section_id -assessment_rev_id $new_assessment_rev_id]
	set new_section_id [as::section::new_revision -section_id $section_id -assessment_id $assessment_id]
	db_dml update_section_in_assessment {}
	set old_item_id $as_item_id

	if {![db_0or1row item_display {}] || $object_type ne "as_item_display_f"} {
	    set as_item_display_id [as::item_display_f::new \
					-html_display_options $html_options \
					-abs_size $abs_size \
					-box_orientation $box_orientation]
	    
	    if {![info exists object_type]} {
		# first item display mapped
		as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_display_id -type as_item_display_rel
	    } else {
		# old item display existing
		set as_item_id [as::item::new_revision -as_item_id $as_item_id]
	    }
	} else {
	    # old f item display existing
	    set as_item_id [as::item::new_revision -as_item_id $as_item_id]
	    set as_item_display_id [as::item_display_f::edit \
					-as_item_display_id $as_item_display_id \
					-html_display_options $html_options \
					-abs_size $abs_size \
					-box_orientation $box_orientation]
	}

	set old_item_id [as::item::latest -as_item_id $old_item_id -section_id $new_section_id -default 0]
	if {$old_item_id == 0} {
	    db_dml move_down_items {}
	    incr after
	    db_dml insert_new_item {}
	} else {
	    db_dml update_item_display {}
	    db_1row item_data {}
	    db_dml update_item {}
	}
}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
