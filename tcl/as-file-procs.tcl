ad_library {
    File procs
    @author eperez@it.uc3m.es
    @creation-date 2004-10-25
}

namespace eval as::file {}

ad_proc -public as::file::new {
    {-file_pathname:required}
} {
    @author eperez@it.uc3m.es
    @creation-date 2004-10-25

    New as_file to the CR
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Get the filename part of the upload file
    if { ![regexp {[^//\\]+$} $file_pathname file_name] } {
        # no match
        set file_name $file_pathname
    }
    # TODO make the CR name be a SHA1 of the file to prevent too much files repeated
    set file_item_id [content::item::new -parent_id $folder_id -content_type {as_files} -name [ad_generate_random_string] -title $file_name]
    set file_revision_id [content::revision::new -item_id $file_item_id -content_type {as_files} -title $file_name ]
    set filename [cr_create_content_file $file_item_id $file_revision_id $file_pathname]
    set title [template::util::file::get_property filename $file_pathname]
    set mime_type [cr_filename_to_mime_type -create $title]
    set content_length [file size $file_pathname]
    db_dml set_file_content { update cr_revisions set content = :filename, mime_type = :mime_type, content_length = :content_length where revision_id = :file_revision_id }

    return $file_revision_id
}
