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

	select cr.item_id as item_item_id, cr.content, cr.title, cr.description, i.subtext, i.field_code,
	       i.field_name, i.required_p, i.data_type, i.max_time_to_complete,
	       i.feedback_right, i.feedback_wrong, i.points, i.validate_block
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

	select cr.content, cr.title, cr.description, i.subtext, i.field_code, i.required_p, i.data_type,
	       i.max_time_to_complete, i.feedback_right,
	       i.feedback_wrong, i.points, i.validate_block
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
		       od.object_id as display_type_id, od.object_type as display_type,
		       r2.revision_id as content_rev_id, r2.title as content_filename, ci2.content_type
		from cr_revisions cr, as_item_rels it,
		     as_item_rels dt, acs_objects oi, acs_objects od,
		     as_items i
		left outer join as_item_rels ar on (ar.item_rev_id = i.as_item_id and ar.rel_type = 'as_item_content_rel')
		left outer join cr_revisions r2 on (ar.target_rev_id = r2.revision_id)
		left outer join cr_items ci2 on (ci2.item_id = r2.item_id)
		where i.as_item_id = :as_item_id
		and cr.revision_id = i.as_item_id
		and it.item_rev_id = i.as_item_id
		and dt.item_rev_id = i.as_item_id
		and it.rel_type = 'as_item_type_rel'
		and dt.rel_type = 'as_item_display_rel'
		and oi.object_id = it.target_rev_id
		and od.object_id = dt.target_rev_id
		group by cr.title, i.subtext, i.field_name, i.data_type, oi.object_type,od.object_id, od.object_type, r2.revision_id, r2.title, ci2.content_type
	</querytext>
</fullquery>

<fullquery name="as::item::get_item_type_info.get_item_type_info">
      <querytext>
	select r.target_rev_id as as_item_type_id, o.object_type
	from as_item_rels r, acs_objects o
	where r.item_rev_id = :as_item_id
	and r.rel_type = 'as_item_type_rel'
	and o.object_id = r.target_rev_id

      </querytext>
</fullquery>

<fullquery name="as::item::update_item_type.update_item_type">
      <querytext>
		update as_item_rels
		set target_rev_id = :item_type_id
		where item_rev_id = :as_item_id
		and rel_type = 'as_item_type_rel'

      </querytext>
</fullquery>


<fullquery name="as::item::update_item_in_section.update_item_in_section">
      <querytext>

		update as_item_section_map
		set as_item_id = :new_item_id
		where section_id = :new_section_id
		and as_item_id = :old_item_id

      </querytext>
</fullquery>


<fullquery name="as::item::update_item_type_in_item.update_item_type_in_item">
      <querytext>

		update as_item_rels
		set target_rev_id = :new_item_type_id
		where item_rev_id = :new_item_id
		and target_rev_id = :old_item_type_id
		and rel_type = 'as_item_type_rel'

      </querytext>
</fullquery>


<fullquery name="as::item::get_item_type_id.item_type_id">
      <querytext>

	select target_rev_id
	from as_item_rels
	where item_rev_id = :as_item_id
	and rel_type = 'as_item_type_rel'

      </querytext>
</fullquery>

</queryset>
