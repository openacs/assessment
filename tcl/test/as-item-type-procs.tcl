# 

ad_library {
    
    Tests for assessment item types procedures
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-05-15
    @arch-tag: 324f8059-253b-43a4-bc8b-767cb6f627fc
    @cvs-id $Id$
}


aa_register_case as_item_type {
    Assessment Item Type Tests
} {

    aa_run_with_teardown \
        -rollback \
        -test_code {

            # test item_types
            set item_types [as_item_type::get_item_types]
            aa_true "Item Types Exist" [llength $item_types]
            # test display types per item type

            foreach type $item_types {
                set type_name [lindex $type 1]
                aa_true "Display types for ${type_name} exist" \
                        [llength [as_item_type::get_display_types $type_name]]
                }

            # end
        }
}
