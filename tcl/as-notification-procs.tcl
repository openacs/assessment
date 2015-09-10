ad_library {
    Notification procs
    @author timo@timohentschel.de
    @creation-date 2005-01-23
}

namespace eval as::notification {}

ad_proc -public as::notification::get_url {
    object_id
} {
    set package_id [db_string get_package_id {}]
    set package_url [site_node::get_url_from_object_id -object_id $package_id]
    return "${package_url}asm-admin/one-a?assessment_id=$object_id"
}

ad_proc -public as::notification::process_reply {
    reply_id
} {
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
