<?xml version="1.0"?>
<queryset>

<fullquery name="section_data">
	<querytext>

	    select r.title, r.description, s.instructions
	    from as_sections s, cr_revisions r
	    where r.revision_id = s.section_id
	    and s.section_id = :section_id

	</querytext>
</fullquery>
	
<fullquery name="choice_orientation">
	<querytext>

	    select d.choice_orientation
	    from as_item_rels r, as_item_display_$presentation_type d
	    where r.item_rev_id = :as_item_id
	    and r.rel_type = 'as_item_display_rel'
	    and r.target_rev_id = d.as_item_display_id

	</querytext>
</fullquery>
	
</queryset>
