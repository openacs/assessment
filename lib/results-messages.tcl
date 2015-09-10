# Display all change messages for result points
# author Timo Hentschel (timo@timohentschel.de)

set format "[lc_get d_fmt], [lc_get t_fmt]"

db_multirow -unclobber -extend {session_url user_url} results result_changes {
} {
    set creation_date [lc_time_fmt $creation_date $format]
    set user_url [acs_community_member_url -user_id $creation_user]
    set session_url [export_vars -base results-session {session_id}]
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
