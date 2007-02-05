# packages/assessment/tcl/test/as-assessment-procs.tcl

ad_library {
    
    Tests for assessment procs
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2006-08-03
    @cvs-id $Id$
}

aa_register_case -cats { api } as_assessment_new {
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
                [expr {$folder_id ne ""}]
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
	 
	 aa_true "Item Created " [expr { $title eq $assessment_data(title)}]
     aa_log " $assessment_data(title) "
	 
     aa_true "Item Created " [expr { $assessment_data(creator_name) ne ""}]
	 aa_log " $assessment_data(creator_name) "
	 	 	 
	 }
}


aa_register_case -cats { api } as_assessment_edit {
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
                [expr {$folder_id ne ""}]
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
	 aa_true "New Title Created - $title " [expr {$title eq $newtitle}]
	 aa_true "New Title Created - $title not equal to $vartitle" [expr {$title ne $vartitle}]
	 aa_log "new_revision_id - $new_revision_id" 	
	 
	 }
     
}


aa_register_case -cats { api } as_assessment_copy {
  Test of a assessment copy
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
                [expr {$folder_id ne ""}]
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
	 aa_true "New Assessment created" [expr { $assessment_id ne $new_assessment_id }]
	 aa_log "new_assessment_id - $new_assessment_id"	 
	 }  
}


aa_register_case -cats { api } as_assessment_new_revisions {
  Test of a assessment new revisions
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
                [expr {$folder_id ne ""}]
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
         aa_true "New Assessment created" [expr { $assessment_id ne $new_revision_id }]
         aa_log "new_revision_id - $new_revision_id"
         }
}


aa_register_case -cats { api }   as_assessment {
    Test for assessment  proc
} {
    foreach seconds {"" 0} {
        catch {as::assessment::pretty_time -seconds $seconds} pretty_time
    aa_true "\"$seconds\" returns \"$seconds\"" [expr {$pretty_time eq $seconds}]
    }
}
