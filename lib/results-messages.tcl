# Display all change messages for result points
# author Timo Hentschel (timo@timohentschel.de)

set format "[lc_get formbuilder_date_format], [lc_get formbuilder_time_format]"

db_multirow -extend {user_url} results result_changes {
} {
    set user_url [acs_community_member_url -user_id $creation_user]
}
