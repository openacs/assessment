<?xml version="1.0"?>
<queryset>

<fullquery name="general_item_data">
<querytext>

	select r.title, r.description, i.subtext, i.field_name, i.field_code, i.required_p,
	       i.feedback_right, i.feedback_wrong, i.max_time_to_complete, i.data_type, i.points
	from cr_revisions r, as_items i
	where r.revision_id = i.as_item_id
	and i.as_item_id = :as_item_id

</querytext>
</fullquery>

<fullquery name="item_type">
      <querytext>

    select max(o.object_type)
    from acs_objects o, as_item_rels r
    where r.item_rev_id = :as_item_id
    and r.rel_type = 'as_item_type_rel'
    and o.object_id = r.target_rev_id

      </querytext>
</fullquery>

<fullquery name="display_type">
      <querytext>

    select o.object_type
    from acs_objects o, as_item_rels r
    where r.item_rev_id = :as_item_id
    and r.rel_type = 'as_item_display_rel'
    and o.object_id = r.target_rev_id

      </querytext>
</fullquery>

<fullquery name="get_item_content">
      <querytext>

    select cr.title || ' (' || cr.content_length || ' bytes)' as content_name,
           cr.revision_id as content_rev_id, cr.title as content_filename
    from cr_revisions cr, as_item_rels r
    where r.item_rev_id = :as_item_id
    and r.target_rev_id = cr.revision_id
    and r.rel_type = 'as_item_content_rel'

      </querytext>
</fullquery>

</queryset>
