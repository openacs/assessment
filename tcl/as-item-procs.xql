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
	       i.definition, i.required_p, i.data_type, i.max_time_to_complete,
	       i.feedback_right, i.feedback_wrong
	from cr_revisions cr, as_items i
	where cr.revision_id = :as_item_id
	and i.as_item_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::item::copy.item_data">
      <querytext>

	select cr.title, cr.description, i.subtext, i.field_code,
	       i.definition, i.required_p, i.data_type, i.max_time_to_complete,
	       i.feedback_right, i.feedback_wrong
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

</queryset>
