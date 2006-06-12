<?xml version="1.0"?>

<queryset>
  <rdbms><type>postgresql</type><version>7.1</version></rdbms>

  <fullquery name="comments">
	<querytext>
	  select g.comment_id,
           r.content,
           r.title,
           r.mime_type,
           acs_object__name(o.creation_user) as author,
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
	</querytext>
  </fullquery>

</queryset>
