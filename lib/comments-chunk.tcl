# packages/assessment/lib/comments-chunk.tcl
#
# shows comments for an object
#
# @author Deds Castillo (deds@i-manila.com.ph)
# @creation-date 2005-08-16
# @arch-tag: 989f6620-380f-49b9-a6e0-00c0effd7bb8
# @cvs-id $Id$

foreach required_param {object_id} {
    if {![info exists $required_param]} {
        return -code error "$required_param is a required parameter."
    }
}
foreach optional_param {} {
    if {![info exists $optional_param]} {
        set $optional_param {}
    }
}

set return_url [ad_return_url]

# If the user has package admin perms, give him general_comments_create perms
if { [permission::permission_p -object_id [ad_conn package_id] -privilege "admin"] && ![permission::permission_p -object_id $object_id -privilege "general_comments_create"] } {
    permission::grant -object_id $object_id -privilege "general_comments_create" -party_id [ad_conn user_id]
}

set general_comments_url [apm_package_url_from_key "general-comments"]
if {[set has_permission_p [permission::permission_p -object_id $object_id -privilege "general_comments_create"]]} {
    set comment_add_url [export_vars -base "${general_comments_url}comment-add" {object_id return_url}]

    db_multirow -extend { html_content edit_url author } comments comments {
	  select g.comment_id,
           r.content,
           r.title,
           r.mime_type,
           o.creation_user,
           to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date_ansi
	  from general_comments g,
         cr_revisions r,
         cr_items ci,
         acs_objects o
	  where g.object_id = :object_id
          and r.revision_id = ci.live_revision
          and ci.item_id = g.comment_id
          and o.object_id = g.comment_id
	  order by o.creation_date
    } {
        set author [acs_user::get_element -user_id $creation_user -element "name"]
        set html_content [ad_html_text_convert -from $mime_type -- $content]
        set edit_url [export_vars -base "${general_comments_url}comment-edit" {comment_id return_url}]
    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
