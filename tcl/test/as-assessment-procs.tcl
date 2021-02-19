# packages/assessment/tcl/test/as-assessment-procs.tcl

ad_library {
    
    Tests for assessment procs
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2006-08-03
    @cvs-id $Id$
}

aa_register_init_class mount_assessment {
    Mount assessment package
} {
    # constructor

    # export these vars to the environment
    aa_export_vars {package_id}

    # mount the package
    set node_name [ad_generate_random_string]
    set package_id [site_node::instantiate_and_mount \
                        -node_name $node_name \
                        -package_key assessment]

} {
    # destructor

    if {[catch { 
        apm_package_instance_delete $package_id
    } errMsg]} {
        ns_log error "mount_assessment failed: $errMsg"
    }
}

aa_register_case -cats api -procs {
    as::assessment::new
    as::assessment::folder_id
    as::assessment::data
    as::assessment::sections
    as::item_type_sa::new
    as::item_type_sa::add_to_assessment
    as::section::new
    as::section::add_to_assessment
    as::section_data::new
    as::section::items
    as::assessment::sections
    as::session::new
} as_instantiate {
    Test package instantiate and uninstantiate.
} {
    # If this test fails, turn off rollback, so that you can 
    # view which objects are still lying around.
    aa_run_with_teardown -rollback -test_code {
        
        # mount the assessment package
        set title [ad_generate_random_string]
        set user_id [ad_conn user_id]
        set package_id [site_node::instantiate_and_mount \
                            -node_name $title \
                            -package_key assessment]
        set folder_id [as::assessment::folder_id -package_id $package_id]

        # without params, this function uses [ad_conn package_id].
        # we want our package, not the automated-testing package
        aa_stub as::assessment::folder_id "return $folder_id"

        # create an assessment
        set assessment_rev_id [as::assessment::new -title $title -package_id $package_id]
        set assessment_id [content::revision::item_id -revision_id $assessment_rev_id]

        # create a section
        set section_id [as::section::new -title "$title" -package_id $package_id]
        as::section::add_to_assessment \
            -assessment_rev_id $assessment_rev_id \
            -section_id $section_id
        aa_log "section_id: $section_id"

        # create a question
        set question_id [as::item_type_sa::new -title $title -package_id $package_id]
        as::item_type_sa::add_to_assessment \
            -assessment_id $assessment_id \
            -section_id $section_id \
            -as_item_id $question_id \
            -title $title \
            -after 1

        # get data
        array set assessment_data {}
        as::assessment::data -assessment_id $assessment_id
        aa_true "assessment exists" {$assessment_data(assessment_id) > 0}

        # start a session
        set session_id [as::session::new -assessment_id $assessment_rev_id -subject_id $user_id -package_id $package_id]
        aa_true "session exists" {$session_id > 0}

        set section_list [as::assessment::sections -assessment_id $assessment_rev_id \
                              -session_id $session_id \
                              -sort_order_type $assessment_data(section_navigation) \
                              -random_p $assessment_data(random_p)]
        set section_id [lindex $section_list 0]
        
        as::section_data::new -section_id $section_id \
            -session_id $session_id \
            -subject_id $user_id \
            -package_id $package_id

        set item_list [as::section::items -section_id $section_id -session_id $session_id]

        db_dml update_session ""

    } -teardown_code {
        # unmount and uninstantiate
        apm_package_instance_delete $package_id
    }
}




aa_register_case -cats { api } -procs {
    as::assessment::folder_id
    as::assessment::new
    as::assessment::data
} as_assessment_new {
    Test of a new created assessment
} {
   aa_run_with_teardown	\
     -rollback \
     -test_code {
	     
	 set folder_name [ns_mktemp as_folder_XXXXXX]
	 set folder_id [content::folder::new \
                               -name $folder_name \
                               -label $folder_name \
                               -description $folder_name]
            aa_true "Folder_id is not null '${folder_id}'" \
                {$folder_id ne ""}
            content::folder::register_content_type \
                -folder_id $folder_id \
                -content_type as_assessments
            aa_stub as::assessment::folder_id \
                [subst {
                    return $folder_id
                }]
     set title "JEff's Test Assessment New"
	 set assessment_id \
         [as::assessment::new \
            -title $title ]	    
	 aa_log "tfolder name = '${folder_name}'"
	 aa_log "tassessment_id = '${assessment_id}'"
	 
	 set assessment_id [ content::revision::item_id -revision_id $assessment_id ]
	 as::assessment::data -assessment_id $assessment_id
	 
	 aa_true "Item Created " { $title eq $assessment_data(title)}
     aa_log " $assessment_data(title) "
	 
     aa_true "Item Created " { $assessment_data(creator_name) ne ""}
	 aa_log " $assessment_data(creator_name) "
	 	 	 
	 }
}


aa_register_case -cats { api } -procs {
    as::assessment::folder_id
    as::assessment::new
    as::assessment::edit
} as_assessment_edit {
    Test of an Assessment Edit
} {
   aa_run_with_teardown	\
     -rollback \
     -test_code {
	     
	 set folder_name [ns_mktemp as_folder_XXXXXX]
     set folder_id [content::folder::new \
                               -name $folder_name \
                               -label $folder_name \
                               -description $folder_name]
            aa_true "Folder_id is not null '${folder_id}'" \
                {$folder_id ne ""}
            content::folder::register_content_type \
                -folder_id $folder_id \
                -content_type as_assessments
            aa_stub as::assessment::folder_id \
                [subst {
                    return $folder_id
                }]
                
	 set vartitle "Test Assessment Edit"
	 set newtitle "New Test Assessment Edit Title"
	 
	 set assessment_id \
         [as::assessment::new \
            -title $vartitle ]	    
	 
	 set assessment_id [ content::revision::item_id -revision_id $assessment_id ]
	 
	 set new_revision_id [ as::assessment::edit -assessment_id $assessment_id -title $newtitle ]
	 aa_true "New Title Created" [db_0or1row q "select title from cr_revisions where revision_id=:new_revision_id"]
	 aa_true "New Title Created - $title " {$title eq $newtitle}
	 aa_true "New Title Created - $title not equal to $vartitle" {$title ne $vartitle}
	 aa_log "new_revision_id - $new_revision_id" 	
	 
	 }
     
}


aa_register_case -cats { api } -procs {
    as::assessment::folder_id
    as::assessment::new
    as::assessment::copy
} as_assessment_copy {
    Test of an assessment copy
} {
   aa_run_with_teardown	\
     -rollback \
     -test_code {
	     
	 set folder_name [ns_mktemp as_folder_XXXXXX]
	 set folder_id [content::folder::new \
                               -name $folder_name \
                               -label $folder_name \
                               -description $folder_name]
            aa_true "Folder_id is not null '${folder_id}'" \
                {$folder_id ne ""}
            content::folder::register_content_type \
                -folder_id $folder_id \
                -content_type as_assessments
            aa_stub as::assessment::folder_id \
                [subst {
                    return $folder_id
                }]
     set vartitle "Test Assessment Copy"
	 set assessment_id \
         [as::assessment::new \
            -title $vartitle ]	    
	 
	 set assessment_id [ content::revision::item_id -revision_id $assessment_id ]
	 aa_log "assessment_id - $assessment_id"
	 
	 set new_assessment_id [ as::assessment::copy -assessment_id $assessment_id]
	 aa_true "New Assessment created" { $assessment_id ne $new_assessment_id }
	 aa_log "new_assessment_id - $new_assessment_id"	 
	 }  
}


aa_register_case -cats { api } -procs {
    as::assessment::folder_id
    as::assessment::new
    as::assessment::new_revision
} as_assessment_new_revisions {
  Test of an assessment new revisions
} {
   aa_run_with_teardown \
     -rollback \
     -test_code {

         set folder_name [ns_mktemp as_folder_XXXXXX]
         set folder_id [content::folder::new \
                               -name $folder_name \
                               -label $folder_name \
                               -description $folder_name]
            aa_true "Folder_id is not null '${folder_id}'" \
                {$folder_id ne ""}
            content::folder::register_content_type \
                -folder_id $folder_id \
                -content_type as_assessments
            aa_stub as::assessment::folder_id \
                [subst {
                    return $folder_id
                }]
     set vartitle "Test Assessment New Revisions"
         set assessment_id \
         [as::assessment::new \
            -title $vartitle ]

         set assessment_id [ content::revision::item_id -revision_id $assessment_id ]
         aa_log "assessment_id - $assessment_id"
         #aa_log "revision_id - $assessment_revision_id"
	
         set new_revision_id [ as::assessment::new_revision -assessment_id $assessment_id]
         aa_true "New Assessment created" { $assessment_id ne $new_revision_id }
         aa_log "new_revision_id - $new_revision_id"
         }
}


aa_register_case -cats { api } -procs {
    as::assessment::pretty_time
} as_assessment {
    Test for assessment  proc
} {
    foreach seconds {"" 0} {
        catch {as::assessment::pretty_time -seconds $seconds} pretty_time
    aa_true "\"$seconds\" returns \"$seconds\"" [expr {$pretty_time eq $seconds}]
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
