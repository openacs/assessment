ad_library {
    Item relationship procs
    @author timo@timohentschel.de
    @creation-date 2004-12-06
}

namespace eval as::item_rels {}

ad_proc -public as::item_rels::new {
    -item_rev_id:required
    -target_rev_id:required
    -type:required
} {
    New Item Relationship

    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-06
} {
    db_dml insert_relationship {}
}

ad_proc -public as::item_rels::get_target {
    -item_rev_id:required
    -type:required
} {
    Get target object of given relationship type

    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-06
} {
    return [db_string target_object {} -default ""]
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
