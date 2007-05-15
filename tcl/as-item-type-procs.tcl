# 

ad_library {
    
    Procedures to work with item_types
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-05-15
    @arch-tag: 6ab279ee-2c8a-472b-b0ba-35ad96529051
    @cvs-id $Id$
}

namespace eval as_item_type:: {}

ad_proc -public as_item_type::get_item_types {
} {
     
    Gets item types in a list of lists suitable for a form-builder
    options parameter
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-05-15
    
    @return List of lists of label/value for valid item types
    
    @error 
} {
    foreach item_type [db_list item_types {}] {
        lappend item_types [list "[_ assessment.item_type_$item_type]" $item_type]
    }
    lappend item_types [list "[_ assessment.item_type_ms]" ms]
    return $item_types
}

ad_proc -public as_item_type::get_display_types {
    item_type
} {
     Get valid display types for item_type
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-05-15
    
    @param item_type Assessment Item Type

    @return List of lists for label/value for display types valid for item_type
    
    @error 
} {

    set display_types [list]
    foreach display_type [db_list display_types {}] {
        lappend display_types [list "[_ assessment.item_display_$display_type]" $display_type]
    }
    return $display_types
}

