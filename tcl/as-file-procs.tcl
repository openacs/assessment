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

    New file to the CR
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Get the filename part of the upload file
    if { ![regexp {[^//\\]+$} $file_pathname file_name] } {
        # no match
        set file_name $file_pathname
    }
    # TODO make the CR name be a SHA1 of the file to prevent too much files repeated
    set filename [template::util::file::get_property filename $file_pathname]
    set mime_type [cr_filename_to_mime_type -create $filename]
    set content_length [file size $file_pathname]
    set content_rev_id [cr_import_content -title $filename $folder_id $file_pathname $content_length $file_mimetype [exec uuidgen]]
    as::item_rels::new -item_rev_id $as_item_id -target_rev_id $content_rev_id -type as_item_content_rel

    return $content_rev_id
}
