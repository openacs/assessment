# 

ad_library {
    
    Tests for sitewide category item type
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-05-15
    @arch-tag: 89f9454a-0c69-48e6-a9c1-d2d214982ff6
    @cvs-id $Id$
}

aa_register_case as_item_type_swcat {
    SW Category Assessment Item Type Test
} {

    aa_run_with_teardown \
        -rollback \
        -test_code {

            # content type for swcat item type exists
            aa_true "Object Type Exists" \
                [expr ![catch {acs_object_type::get \
                                   -object_type as_item_type_swcat \
                                   -array object_type} errmsg]]
            aa_true "Type created correctly" \
                [string equal \
                     [array get object_type] {dynamic_p f package_name as_item_type_swcat table_name as_item_type_swcat pretty_name {Assessment Item Type Sitewide Category} object_type as_item_type_swcat type_extension_table {} name_method {} supertype content_revision id_column as_item_type_id pretty_plural {Assessment Item Type Sitewide Category} abstract_p f}]
            if {[info exists object_type]} {

                set attribute_list [package_object_attribute_list -start_with as_item_type_swcat as_item_type_swcat]
                array set attributes [list]

                foreach {attribute_id table_name attribute_name pretty_name datatype required_p default_value} [lindex $attribute_list 0] {
                    set attributes($attribute_name) [list $attribute_name $table_name $pretty_name $datatype $required_p $default_value]
                }
                
                foreach name [list tree_id] {
                    aa_true "Attribute ${name} exists" [info exists attributes($name)]
                }
                
            } else {
                aa_log "skipping object attribute checks, object type does not exist"
            }

            
        }
}
