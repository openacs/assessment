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
	       i.required_p, i.data_type, i.max_time_to_complete,
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

	select cr.title, cr.description, i.subtext, i.field_code,
	       i.required_p, i.data_type, i.max_time_to_complete,
	       i.feedback_right, i.feedback_wrong, i.points
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

<fullquery name="as::item::mc_type_not_cached.item_type_id">
<querytext>

    select max(t.as_item_type_id) as as_item_type_id
    from as_item_type_mc t, cr_revisions c, as_item_rels r
    where t.as_item_type_id = r.target_rev_id
    and r.item_rev_id = :as_item_id
    and r.rel_type = 'as_item_type_rel'
    and c.revision_id = t.as_item_type_id
    group by c.title, t.increasing_p, t.allow_negative_p,
    t.num_correct_answers, t.num_answers

</querytext>
</fullquery>

<fullquery name="as::item::get_choice_orientation_not_cached.get_choice_orientation">
	<querytext>

	    select d.choice_orientation
	    from as_item_rels r, as_item_display_$presentation_type d
	    where r.item_rev_id = :as_item_id
	    and r.rel_type = 'as_item_display_rel'
	    and r.target_rev_id = d.as_item_display_id

	</querytext>
</fullquery>
	

</queryset>
