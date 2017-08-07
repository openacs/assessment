ad_library {
    Section Data procs
    @author timo@timohentschel.de
    @creation-date 2005-01-14
}

namespace eval as::section_data {}

ad_proc -public as::section_data::new {
    -session_id:required
    -section_id:required
    {-subject_id ""}
    {-staff_id ""}
    {-points ""}
    {-package_id ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-14

    New as_section_data
} {
    if {$package_id eq ""} {
	set package_id [ad_conn package_id]
    }
    set folder_id [as::assessment::folder_id -package_id $package_id]

    if {[db_0or1row section_data_exists {}]} {
	return
    }

    # Insert as_section_data in the CR (and as_section_data table) getting the revision_id (section_data_id)
    db_transaction {
        set section_data_id [content::item::new -parent_id $folder_id -content_type {as_section_data} -name "$section_id-$session_id"]
        set as_section_data_id [content::revision::new \
				    -item_id $section_data_id \
				    -content_type {as_section_data} \
				    -title "$section_id-$session_id" \
				    -attributes [list [list session_id $session_id] \
						     [list section_id $section_id] \
						     [list subject_id $subject_id] \
						     [list staff_id $staff_id] \
						     [list points $points ] ] ]

	db_dml update_creation_time {}
    }

    return $as_section_data_id
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
