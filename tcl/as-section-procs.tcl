ad_library {
    Section procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::section {}

ad_proc -public as::section::new {
    {-name:required}
    {-title:required}
    {-instructions ""}
    {-description ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New section to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_section in the CR (and as_sections table) getting the revision_id (as_section_id)
    set section_item_id [content::item::new -parent_id $folder_id -content_type {as_sections} -name $name -title $title -description $description ]
    set as_section_id [content::revision::new -item_id $section_item_id -content_type {as_sections} -title $title -description $description -attributes [list [list instructions $instructions] ] ]

    return $as_section_id
}