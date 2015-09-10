ad_library {
    Item display short answer Type procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item_display_sa {}

ad_proc -public as::item_display_sa::new {
    {-html_display_options ""}
    {-abs_size ""}
    {-box_orientation ""}    
} {
    @author Natalia Perez (nperper@it.uc3m.es)
    @creation-date 2004-09-29

    New Item Display ShortAnswer Type to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_display_sa in the CR (and as_item_display_sa table) getting the revision_id (as_item_display_id)
    db_transaction {
        set item_item_display_sa_id [content::item::new -parent_id $folder_id -content_type {as_item_display_sa} -name [as::item::generate_unique_name]]
        set as_item_display_sa_id [content::revision::new \
				-item_id $item_item_display_sa_id \
				-content_type {as_item_display_sa} \
				-attributes [list [list html_display_options $html_display_options] \
						[list abs_size $abs_size] \
						[list box_orientation $box_orientation] ] ]
    }

    return $as_item_display_sa_id
}

ad_proc -public as::item_display_sa::edit {
    -as_item_display_id:required
    {-html_display_options ""}
    {-abs_size ""}
    {-box_orientation ""}    
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Edit Item Display ShortAnswer Type to the database
} {
    # Update as_item_display_sa in the CR (and as_item_display_sa table) getting the revision_id (as_item_display_id)
    db_transaction {
	set display_item_id [db_string display_item_id {}]
        set new_item_display_id [content::revision::new \
				     -item_id $display_item_id \
				     -content_type {as_item_display_sa} \
				     -attributes [list [list html_display_options $html_display_options] \
						      [list abs_size $abs_size] \
						      [list box_orientation $box_orientation] ] ]
    }

    return $new_item_display_id
}

ad_proc -public as::item_display_sa::copy {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copy an Item Display ShortAnswer Type
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_display_sa in the CR (and as_item_display_sa table) getting the revision_id (as_item_display_id)
    db_transaction {
	db_1row display_item_data {}

	set new_item_display_id [new -html_display_options $html_display_options \
				     -abs_size $abs_size \
				     -box_orientation $box_orientation]
    }

    return $new_item_display_id
}

ad_proc -public as::item_display_sa::render {
    -form:required
    -element:required
    -type_id:required
    {-datatype ""}
    {-title ""}
    {-subtext ""}
    {-required_p ""}
    {-random_p ""}
    {-default_value ""}
    {-data ""}
    -item:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-10

    Render an Item Display ShortAnswer Type
} {
    array set type [util_memoize [list as::item_display_sa::data -type_id $type_id]]
    if {$required_p eq ""} {
	set required_p f
    }
    if {$datatype eq ""} {
	set datatype text
    }

    set optional ""
    if {$required_p != "t"} {
	set optional ",optional"
    }
    set param_list [list [list label \$title] [list help_text \$subtext] [list value \$default_value] [list html \$type(html_display_options)]]
    if {$type(abs_size) ne ""} {
	lappend param_list [list maxlength $type(abs_size)]
    }
    set element_params [concat [list "$element\:$datatype\(text)$optional"] $param_list]

    ad_form -extend -name $form -form [list $element_params]
}

ad_proc -public as::item_display_sa::data {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-04-08

    Get the cached Display Data of ShortAnswer Type
} {
    return [util_memoize [list as::item_display_sa::data_not_cached -type_id $type_id]]
}

ad_proc -private as::item_display_sa::data_not_cached {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-04-08

    Get the Display Data of ShortAnswer Type
} {
    db_1row display_item_data {} -column_array type
    return [array get type]
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
