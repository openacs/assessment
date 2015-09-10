ad_library {
    Item display textbox Type procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item_display_tb {}

ad_proc -public as::item_display_tb::new {
    {-html_display_options ""}
    {-abs_size ""}
    {-item_answer_alignment ""}
    {-package_id ""}
} {
    @author Natalia Perez (nperper@it.uc3m.es)
    @creation-date 2004-09-29

    New Item Display TextBox Type to the database
} {
    if { (![info exists package_id] || $package_id eq "") } {
    	set package_id [ad_conn package_id]
    }
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_display_tb in the CR (and as_item_display_tb table) getting the revision_id (as_item_display_id)
    db_transaction {
        set item_item_display_tb_id [content::item::new -parent_id $folder_id -content_type {as_item_display_tb} -name [as::item::generate_unique_name]]
        set as_item_display_tb_id [content::revision::new \
				-item_id $item_item_display_tb_id \
				-content_type {as_item_display_tb} \
				-attributes [list [list html_display_options $html_display_options] \
						[list abs_size $abs_size] \
						[list item_answer_alignment $item_answer_alignment] ] ]
    }

    return $as_item_display_tb_id
}

ad_proc -public as::item_display_tb::edit {
    -as_item_display_id:required
    {-html_display_options ""}
    {-abs_size ""}
    {-item_answer_alignment ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Edit Item Display TextBox Type to the database
} {
    # Update as_item_display_tb in the CR (and as_item_display_tb table) getting the revision_id (as_item_display_id)
    db_transaction {
	set display_item_id [db_string display_item_id {}]
        set new_item_display_id [content::revision::new \
				     -item_id $display_item_id \
				     -content_type {as_item_display_tb} \
				     -attributes [list [list html_display_options $html_display_options] \
						      [list abs_size $abs_size] \
						      [list item_answer_alignment $item_answer_alignment] ] ]
    }

    return $new_item_display_id
}

ad_proc -public as::item_display_tb::copy {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copy an Item Display TextBox Type
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_display_tb in the CR (and as_item_display_tb table) getting the revision_id (as_item_display_id)
    db_transaction {
	db_1row display_item_data {}

	set new_item_display_id [new -html_display_options $html_display_options \
				     -abs_size $abs_size \
				     -item_answer_alignment $item_answer_alignment]
    }

    return $new_item_display_id
}

ad_proc -public as::item_display_tb::render {
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

    Render an Item Display TextBox Type
} {
    array set type [util_memoize [list as::item_display_tb::data -type_id $type_id]]
    if {$required_p eq ""} {
	set required_p f
    }
    if {$datatype eq ""} {
	set datatype text
    }

    # fixme
    set datatype text

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

ad_proc -public as::item_display_tb::data {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-04-08

    Get the cached Display Data of TextBox Type
} {
    return [util_memoize [list as::item_display_tb::data_not_cached -type_id $type_id]]
}

ad_proc -private as::item_display_tb::data_not_cached {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-04-08

    Get the Display Data of TextBox Type
} {
    db_1row display_item_data {} -column_array type
    return [array get type]
}

ad_proc -private as::item_display_tb::set_item_display_type {
    -assessment_id
    -section_id
    -as_item_id
    -after
    {-type ""}
    {-html_options {size 50 maxlength 1000}}
    {-abs_size ""}
    {-answer_alignment "beside_right"}
} {
    Add display type to item and add item and all components to assessment
    and section


} {
	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	set section_id [as::section::latest -section_id $section_id -assessment_rev_id $new_assessment_rev_id]
	set new_section_id [as::section::new_revision -section_id $section_id -assessment_id $assessment_id]
	db_dml update_section_in_assessment {}
	set old_item_id $as_item_id

	if {![db_0or1row item_display {}] || $object_type ne "as_item_display_tb"} {
	    set as_item_display_id [as::item_display_tb::new \
					-html_display_options $html_options \
					-abs_size $abs_size \
					-item_answer_alignment $answer_alignment]
	    
	    if {![info exists object_type]} {
		# first item display mapped
		as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_display_id -type as_item_display_rel
	    } else {
		# old item display existing
		set as_item_id [as::item::new_revision -as_item_id $as_item_id]
	    }
	} else {
	    # old tb item display existing
	    set as_item_id [as::item::new_revision -as_item_id $as_item_id]
	    set as_item_display_id [as::item_display_tb::edit \
					-as_item_display_id $as_item_display_id \
					-html_display_options $html_options \
					-abs_size $abs_size \
					-item_answer_alignment $answer_alignment]
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
