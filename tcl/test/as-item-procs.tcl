# packages/assessment/tcl/test/as-item-procs.tcl

ad_library {
    
    Test scripts for item operations
    
    @author Roel Canicula (roel@solutiongrove.com)
    @creation-date 2006-02-22
    @arch-tag: c2241f06-97b7-4f1f-9809-1a7e0724c947
    @cvs-id $Id$
}

aa_register_case -cats { api } as_item {
    Assessment item operations tests
} {
    
    aa_run_with_teardown \
        -rollback \
        -test_code {	    
	    # Create an item
	    # Improve: run tests on different data/question types

	    # Run on all assessment packages
	    foreach package_id [db_list asm_packages {
		select p.package_id
		from site_nodes n, apm_packages p
		where n.object_id = p.package_id
		and p.package_key = 'assessment'
	    }] {
		set url [site_node::get_url_from_object_id -object_id $package_id]
		aa_log "running on $url"

		set as_item_id [as::item::new \
				    -title "AA Test Item" \
				    -description "AA Test Item Description" \
				    -subtext "AA Test Subtext" \
				    -field_name "AA Field Name" \
				    -field_code "" \
				    -required_p "t" \
				    -data_type "varchar" \
				    -package_id $package_id]

		aa_true "question created: $as_item_id" $as_item_id

		# Copy the item
		set copy_item_id [as::item::copy \
				      -as_item_id $as_item_id \
				      -title "AA Copy of Test Item" \
				      -description "AA Copy of Test Item Description" \
				      -field_name "AA Copy of Item Field Name" \
				      -package_id $package_id]

		aa_true "question copied: $copy_item_id" $copy_item_id

		# Edit the item
		set new_item_id [as::item::edit \
				     -as_item_id $as_item_id \
				     -title "AA Edited Test Item" \
				     -description "AA Edited Test Item Description" \
				     -subtext "AA Edited Test Subtext" \
				     -field_name "AA Edited Field Name" \
				     -field_code "" \
				     -required_p "f" \
				     -data_type "varchar"]

		aa_true "question edited: $new_item_id" $new_item_id
	    }
	}
}
