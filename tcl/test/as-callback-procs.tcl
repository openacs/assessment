ad_library {
    Automated tests for assessment-callbacks.

    @author Luis de la Fuente (lfuente@it.uc3m.es)
    @creation-date 21 November 2005
}

aa_register_case as_move {
    Test the cabability of moving assessments.
} {    

    aa_run_with_teardown \
        -rollback \
        -test_code {
            #Create origin and destiny communities
            set origin_club_key [dotlrn_club::new -pretty_name [ad_generate_random_string]]
            set destiny_club_key [dotlrn_club::new -pretty_name [ad_generate_random_string]]  
            #add the applet to communities
            dotlrn_community::add_applet_to_community $origin_club_key dotlrn_assessment
            dotlrn_community::add_applet_to_community $destiny_club_key dotlrn_assessment

            set orig_package_id [as::assessment::get_package_id -community_id $origin_club_key]
            set dest_package_id [as::assessment::get_package_id -community_id $destiny_club_key]

            #create the assessment
            set assessment_id [as::assessment::new -title "foo" -package_id $orig_package_id]

            #check if assessment has been created successfully
            set orig_success_p [db_string orig_success_p {
                select 1 from acs_objects where package_id=:orig_package_id and object_id = (select context_id from acs_objects where object_id=:assessment_id) 
            } -default "0"]
            aa_equals "assessment has been created at origin" $orig_success_p 1

            callback -catch datamanager::move_assessment -object_id $assessment_id -selected_community $destiny_club_key

            #check if assessment has been moved successfully
            set orig_success_p [db_string orig_success_p {
                select 0 from acs_objects where package_id=:orig_package_id and object_id = (select context_id from acs_objects where object_id=:assessment_id) 
            } -default "1"]
            aa_equals "assessment has been removed from origin" $orig_success_p 1

            set orig_success_p [db_string orig_success_p {
                select 1 from acs_objects where package_id=:dest_package_id and object_id = (select context_id from acs_objects where object_id=:assessment_id) 
            } -default "0"]
            aa_equals "assessment has been created at origin" $orig_success_p 1

        }
}

aa_register_case as_copy {
    Test the cabability of copying assessments.
} {    

    aa_run_with_teardown \
        -rollback \
        -test_code {
            #Create origin and destiny communities
            set origin_club_key [dotlrn_club::new -pretty_name [ad_generate_random_string]]
            set destiny_club_key [dotlrn_club::new -pretty_name [ad_generate_random_string]]  
            #add the applet to communities
            dotlrn_community::add_applet_to_community $origin_club_key dotlrn_assessment
            dotlrn_community::add_applet_to_community $destiny_club_key dotlrn_assessment

            set orig_package_id [as::assessment::get_package_id -community_id $origin_club_key]
            set dest_package_id [as::assessment::get_package_id -community_id $destiny_club_key]

            #create the assessment
            set assessment_id [as::assessment::new -title "foo" -package_id $orig_package_id]

            #check if assessment has been created successfully
            set orig_success_p [db_string orig_success_p {
                select 1 from acs_objects where package_id=:orig_package_id and object_id = (select context_id from acs_objects where object_id=:assessment_id) 
            } -default "0"]
            aa_equals "assessment has been created at origin" $orig_success_p 1

            set new_assessment_id [callback -catch datamanager::move_assessment -object_id $assessment_id -selected_community $destiny_club_key]
            #check if assessment has been copied successfully
            set orig_success_p [db_string orig_success_p {
                select 1 from acs_objects where package_id=:orig_package_id and object_id = (select context_id from acs_objects where object_id=:assessment_id) 
            } -default "0"]
            aa_equals "assessment has been removed from origin" $orig_success_p 1

            set orig_success_p [db_string orig_success_p {
                select 1 from acs_objects where package_id=:dest_package_id and object_id = (select context_id from acs_objects where object_id=:new_assessment_id) 
            } -default "0"]
            aa_equals "assessment has been created at origin" $orig_success_p 1

        }
}
