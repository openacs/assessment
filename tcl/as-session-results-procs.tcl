ad_library {
    Session Results procs
    @author timo@timohentschel.de
    @creation-date 2005-02-17
}

namespace eval as::session_results {}

ad_proc -public as::session_results::new {
    -target_id:required
    -points:required
    {-title ""}
    {-description ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-02-17

    New as_session_results
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_session_results in the CR (and as_session_results table) getting the revision_id
    db_transaction {
	if {![db_0or1row result_exists {}]} {
	    set result_item_id [content::item::new -parent_id $folder_id -content_type {as_session_results} -name [as::item::generate_unique_name]]
	}
        set result_id [content::revision::new \
			   -item_id $result_item_id \
			   -content_type {as_session_results} \
			   -title $title \
			   -description $description \
			   -attributes [list [list target_id $target_id] \
					    [list points $points] ] ]
    }

    return $result_id
}
