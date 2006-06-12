# 

ad_library {
    
    Procedures for sitewide category item type
    
    @author Dave Bauer (dave@solutiongrove.com)
    @creation-date 2005-05-15
    @arch-tag: ba556f8e-d5bf-4455-bb19-06be198014d8
    @cvs-id $Id$
}

namespace eval as::item_type_swcat {}


ad_proc -public as::item_type_swcat::new {
    {-title ""}
    {-tree_id:required}
} {
    @author Dave Bauer (dave@solutiongrove.com)
    @creation-date 2005-05-15

    New SW Category item to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_type_swcat in the CR (and as_item_type_swcat table) getting the revision_id (as_item_type_id)
    db_transaction {
        set item_item_type_swcat_id [content::item::new -parent_id $folder_id -content_type {as_item_type_swcat} -name [as::item::generate_unique_name]]
        set as_item_type_swcat_id [content::revision::new \
				-item_id $item_item_type_swcat_id \
				-content_type {as_item_type_swcat} \
				-title $title \
                                    -attributes [list [list tree_id $tree_id]]]
    }

    return $as_item_type_swcat_id
}

ad_proc -public as::item_type_swcat::edit {
    -as_item_type_id:required
    -tree_id:required
} {
    @author Dave Bauer (dave@solutiongrove.com)
    @creation-date 2005-05-15

    Edit SW Category Answers item to the database
} {
    # Update as_item_type_swcat in the CR (and as_item_type_swcat table) getting the revision_id (as_item_type_id)
    db_transaction {
	set type_item_id [db_string type_item_id {}]
        set new_item_type_id [content::revision::new \
				  -item_id $type_item_id \
				  -content_type {as_item_type_swcat} \
				  -title $title \
				  -attributes [list [list tree_id $tree_id] ]
    }

    return $new_item_type_id
}

ad_proc -public as::item_type_swcat::copy {
    -type_id:required
} {
    @author Dave Bauer (dave@solutiongrove.com)
    @creation-date 2005-05-15

    Copy a Short Answer Type
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_type_swcat in the CR (and as_item_type_swcat table) getting the revision_id (as_item_type_id)
    db_transaction {
	db_1row item_type_data {}

	set new_item_type_id [new -tree_id $tree_id]
    }

    return $new_item_type_id
}

ad_proc -public as::item_type_swcat::render {
    -type_id:required
    -section_id:required
    -as_item_id:required
    {-default_value ""}
    {-session_id ""}
    {-show_feedback ""}
} {
    @author Dave Bauer (dave@solutiongrove.com)
    @creation-date 2005-05-15

    Render a SW Category Type
} {
    if {![empty_string_p $default_value]} {
	array set values $default_value
	set default $values(text_answer)
    } else {
	set default ""
    }
    set display_choices [list]
    set tree_id [db_string get_tree_id "" -default ""]
    set categories [category_tree::get_tree -all $tree_id]
    foreach cat $categories {
        foreach {category_id category_name deprecated_p level} $cat {break}
        lappend display_choices [list $category_name $category_id]
    }
    return [list $default $display_choices]
}

ad_proc -public as::item_type_swcat::process {
    -type_id:required
    -session_id:required
    -as_item_id:required
    -section_id:required
    -subject_id:required
    {-staff_id ""}
    {-response ""}
    {-max_points 0}
    {-allow_overwrite_p t}
    {-package_id ""}
} {
    @author Dave Bauer (dave@solutiongrove.com)
    @creation-date 2005-05-15

    Process a Response to a SW Category Answer
} {
    as::item_data::new -session_id $session_id -subject_id $subject_id -staff_id $staff_id -as_item_id $as_item_id -section_id $section_id -text_answer [lindex $response 0] -points "" -allow_overwrite_p $allow_overwrite_p -package_id $package_id
}

ad_proc -public as::item_type_swcat::results {
    -as_item_item_id:required
    -section_item_id:required
    -data_type:required
    -sessions:required
} {
    @author Dave Bauer (dave@solutiongrove.com)
    @creation-date 2005-05-15

    Return the results of a given item in a given list of sessions as an array
} {
    db_foreach get_results {} {
	set results($session_id) $text_answer
    }

    if {[array exists results]} {
	return [array get results]
    } else {
	return
    }
}
