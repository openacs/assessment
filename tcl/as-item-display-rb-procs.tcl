ad_library {
    Item display radio button Type procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item_display_rb {}

ad_proc -public as::item_display_rb::new {
    {-html_display_options ""}
    {-choice_orientation ""}
    {-choice_label_orientation ""}
    {-sort_order_type ""}
    {-item_answer_alignment ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @author Natalia Perez (nperper@it.uc3m.es)
    @creation-date 2004-07-26

    New Item Display RadioButton Type to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_display_rb in the CR (and as_item_display_rb table) getting the revision_id (as_item_display_id)
    db_transaction {
        set item_item_display_rb_id [content::item::new -parent_id $folder_id -content_type {as_item_display_rb} -name [exec uuidgen]]
        set as_item_display_rb_id [content::revision::new \
			-item_id $item_item_display_rb_id \
			-content_type {as_item_display_rb} \
			-attributes [list [list html_display_options $html_display_options] \
					[list choice_orientation $choice_orientation] \
					[list choice_label_orientation $choice_label_orientation] \
					[list sort_order_type $sort_order_type] \
					[list item_answer_alignment $item_answer_alignment] ] ]	
    }

    return $as_item_display_rb_id
}

ad_proc -public as::item_display_rb::edit {
    -as_item_display_id:required
    {-html_display_options ""}
    {-choice_orientation ""}
    {-choice_label_orientation ""}
    {-sort_order_type ""}
    {-item_answer_alignment ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Edit Item Display RadioButton Type to the database
} {
    # Update as_item_display_rb in the CR (and as_item_display_rb table) getting the revision_id (as_item_display_id)
    db_transaction {
	set display_item_id [db_string display_item_id {}]
        set new_item_display_id [content::revision::new \
				     -item_id $display_item_id \
				     -content_type {as_item_display_rb} \
				     -attributes [list [list html_display_options $html_display_options] \
						      [list choice_orientation $choice_orientation] \
						      [list choice_label_orientation $choice_label_orientation] \
						      [list sort_order_type $sort_order_type] \
						      [list item_answer_alignment $item_answer_alignment] ] ]	
    }

    return $new_item_display_id
}

ad_proc -public as::item_display_rb::copy {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copy an Item Display RadioButton Type
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_display_rb in the CR (and as_item_display_rb table) getting the revision_id (as_item_display_id)
    db_transaction {
	db_1row display_item_data {}

	set new_item_display_id [new -html_display_options $html_display_options \
				     -choice_orientation $choice_orientation \
				     -choice_label_orientation $choice_label_orientation \
				     -sort_order_type $sort_order_type \
				     -item_answer_alignment $item_answer_alignment]
    }

    return $new_item_display_id
}

ad_proc -public as::item_display_rb::render {
    -form:required
    -element:required
    -type_id:required
    {-datatype ""}
    {-title ""}
    {-subtext ""}
    {-required_p ""}
    {-default_value ""}
    {-data ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-10

    Render an Item Display RadioButton Type
} {
    db_1row display_item_data {}
    if {[empty_string_p $required_p]} {
	set required_p f
    }

    # numerical alphabetical randomized order_of_entry
    switch -exact $sort_order_type {
	alphabetical {
	    set data [lsort -dictionary -index 0 $data]
	}
	randomized {
	    set data [util::randomize_list $data]
	}
	default {
	    set data [lsort -dictionary -index 0 $data]
	}
    }

    set optional ""
    if {$required_p != "t"} {
	set optional ",optional"
    }
    set param_list [list [list label $title] [list help_text $subtext] [list value $default_value] [list options $data] [list html $html_display_options]]
    set element_params [concat [list "$element\:text(radio)$optional"] $param_list]

    ad_form -extend -name $form -form [list $element_params]
}
