# packages/assessment/tcl/test/as-item-procs.tcl

ad_library {
    
    Tests for as_items (questions)
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2006-08-03
    @cvs-id $Id$
}

aa_register_case as_item_new {
    Create a new question
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
                -content_type as_items
            aa_stub as::assessment::folder_id \
                [subst {
                    return $folder_id
                }]

            aa_log "Testing long title (question text)"
            set long_text [string repeat X 8000]
            catch {as::item::new  -title $long_text} as_item_rev_id
            if {[string is integer $as_item_rev_id]} {
            aa_true "Item created" [db_0or1row q "select title,mime_type from cr_revisions where revision_id=:as_item_rev_id"]
            } else {
                aa_log "Item creation failed with $as_item_rev_id"
            }
            set content [db_string q "select content from cr_revisions where revision_id=:as_item_rev_id"]
            aa_true "Long title successfully entered" \
                [expr {[string range $long_text 0 999] eq $title}]
            aa_true "Long question successfully entered" [expr {$content eq $long_text}]
            aa_true "Mime type is text/html" \
                [expr {$mime_type eq "text/html"}]
         }
}
 