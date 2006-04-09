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
