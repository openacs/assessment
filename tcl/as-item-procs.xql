<?xml version="1.0"?>
<queryset>

<fullquery name="as::item::edit.item_item_id">
      <querytext>

	select item_id
	from cr_revisions
	where revision_id = :as_item_id

      </querytext>
</fullquery>

<fullquery name="as::item::new_revision.item_data">
      <querytext>

	select cr.item_id as item_item_id, cr.title, cr.description, i.subtext, i.field_code,
	       i.field_name, i.required_p, i.data_type, i.max_time_to_complete,
	       i.feedback_right, i.feedback_wrong, i.points
	from cr_revisions cr, as_items i
	where cr.revision_id = :as_item_id
	and i.as_item_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::item::latest.get_latest_item_id">
      <querytext>

	select m.as_item_id
	from as_item_section_map m, cr_revisions r, cr_revisions i
	where m.section_id = :section_id
	and m.as_item_id = r.revision_id
	and i.revision_id = :as_item_id
	and i.item_id = r.item_id

      </querytext>
</fullquery>

<fullquery name="as::item::copy.item_data">
      <querytext>

	select i.subtext, i.field_code, i.required_p, i.data_type,
	       i.max_time_to_complete, i.feedback_right,
	       i.feedback_wrong, i.points
	from cr_revisions cr, as_items i
	where cr.revision_id = :as_item_id
	and i.as_item_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::item::copy.item_subtypes">
      <querytext>

	    select i.target_rev_id, o.object_type
	    from as_item_rels i, acs_objects o
	    where i.target_rev_id = o.object_id
	    and i.item_rev_id = :as_item_id

      </querytext>
</fullquery>

<fullquery name="as::item::copy_types.copy_types">
      <querytext>

	insert into as_item_rels
	(select :new_item_id as item_rev_id, target_rev_id, rel_type
	 from as_item_rels
	 where item_rev_id = :as_item_id)

      </querytext>
</fullquery>

<fullquery name="as::item::item_data_not_cached.item_properties">
	<querytext>
		select cr.title, i.subtext, i.data_type, i.field_name,
		       max(oi.object_id) as item_type_id, oi.object_type as item_type,
		       od.object_id as display_type_id, od.object_type as display_type
		from as_items i, cr_revisions cr, as_item_rels it,
		     as_item_rels dt, acs_objects oi, acs_objects od
		where i.as_item_id = :as_item_id
		and cr.revision_id = i.as_item_id
		and it.item_rev_id = i.as_item_id
		and dt.item_rev_id = i.as_item_id
		and it.rel_type = 'as_item_type_rel'
		and dt.rel_type = 'as_item_display_rel'
		and oi.object_id = it.target_rev_id
		and od.object_id = dt.target_rev_id
		group by cr.title, i.subtext, i.field_name, i.data_type, oi.object_type,od.object_id, od.object_type
	</querytext>
</fullquery>

</queryset>
