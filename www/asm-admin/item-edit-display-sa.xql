<?xml version="1.0"?>
<queryset>

<fullquery name="last_used_display_type">
<querytext>

	select max(d.as_item_display_id) as as_item_display_id
	from cr_revisions r, as_item_rels ir, cr_revisions r2, as_item_display_sa d
	where r.revision_id = :as_item_id
	and r2.item_id = r.item_id
	and ir.item_rev_id = r2.revision_id
	and ir.rel_type = 'as_item_display_rel'
	and d.as_item_display_id = ir.target_rev_id

</querytext>
</fullquery>

<fullquery name="display_type_data">
<querytext>

	select d.html_display_options, d.abs_size, d.box_orientation
	from cr_revisions r, as_item_display_sa d
	where r.revision_id = d.as_item_display_id
	and d.as_item_display_id = :as_item_display_id

</querytext>
</fullquery>

<fullquery name="update_section_in_assessment">
      <querytext>

		update as_assessment_section_map
		set section_id = :new_section_id
		where assessment_id = :new_assessment_rev_id
		and section_id = :section_id

      </querytext>
</fullquery>

<fullquery name="update_item_in_section">
      <querytext>

		update as_item_section_map
		set as_item_id = :new_item_id
		where section_id = :new_section_id
		and as_item_id = :as_item_id

      </querytext>
</fullquery>

<fullquery name="update_display_of_item">
      <querytext>

		update as_item_rels
		set target_rev_id = :new_item_display_id
		where item_rev_id = :new_item_id
		and rel_type = 'as_item_display_rel'

      </querytext>
</fullquery>

</queryset>
