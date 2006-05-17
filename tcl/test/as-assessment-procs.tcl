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
            set instructions "These are the instructions"
            set assessment_id \
                [as::assessment::new \
                     -package_id $package_id \
                     -title "Test Assessment" \
                     -instructions $instructions \
                     -consent_page "This is the consent page"]

            aa_true "Instructions set for section" \
                [expr {
                     $instructions eq \
                     [db_string get_instructions \
                          "select instructions
                           from as_assessments
                           where assessment_id=:assessment_id"]}]
            
            set section_id \
                [as::section::new \
                     -package_id $package_id \
                     -title "Test Title" \
                     -instructions $instructions]
db_dml add_section_to_assessment "insert into as_assessment_section_map (assessment_id, section_id)
	    values (:assessment_id, :section_id)"
            aa_true "Instructions set for section" \
                [expr {
                     $instructions eq \
                     [db_string get_instructions \
                          "select instructions
                           from as_sections
                           where section_id=:section_id"]}]

            as::assessment::edit \
                -assessment_id [content::revision::item_id -revision_id $assessment_id] \
                -title "Test Assessment" \
                -instructions $instructions \
                -consent_page "This is the consent_page"

            as::section::edit \
                -section_id $section_id \
                -title "Test Title" \
                -instructions $instructions \
                -assessment_id [content::revision::item_id -revision_id $assessment_id]
            
        }

}