# packages/assessment/tcl/test/as-assessment-procs.tcl

ad_library {
    
    Test scripts for assessment operations
    
    @author Roel Canicula (roel@solutiongrove.com)
    @creation-date 2006-04-08
    @arch-tag: 1b582812-28ac-410f-8789-9c06cba3934a
    @cvs-id $Id$
}

aa_register_case -cats { smoke } assessment_owner {
    Check owners of assessments
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {
	    db_foreach get_assessments {
		select a.assessment_id, a.item_id, a.creation_user, o.creation_user as item_creation_user
		from as_assessmentsi a, acs_objects o
		where a.item_id = o.object_id
	    } {
		aa_true "Assessment item creation user: $item_creation_user, Assessment revision creation user: $creation_user" [expr { $item_creation_user ne "" || $creation_user ne "" }]
	    }
	}
}

aa_register_case -cats { api } assessment_new {
    Test creation of a new assessment
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {
            # we need an assessment package
            set node_name [ns_mktemp __assessment__test__XXXXXX]
            set package_id [site_node::instantiate_and_mount \
                                -node_name $node_name \
                                -package_key assessment]
            aa_log "Package_id = '${package_id}'"

            # now try to create an empty assessment
            set assessment_id \
                [as::assessment::new \
                     -package_id $package_id \
                     -title "Test Assessment" \
                     -instructions "These are the instructions"]
            
        }

}