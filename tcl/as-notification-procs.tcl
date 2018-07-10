ad_library {
    Notification procs
    @author timo@timohentschel.de
    @creation-date 2005-01-23
}

namespace eval as::notification {}

ad_proc -public as::notification::get_url {
    object_id
} {
    NotificationType.GetURL Service Contract implementation.
} {
    set package_id [db_string get_package_id {}]
    set package_url [apm_package_url_from_id $package_id]
    return "${package_url}asm-admin/one-a?assessment_id=$object_id"
}

ad_proc -public as::notification::process_reply {
    reply_id
} {
    NotificationType.ProcessReply Service Contract implementation.
} -

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
