<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="as::section::items.get_sorted_items">
	<querytext>

	select s.as_item_id, ci.name, r.title, r.description, i.subtext, m.required_p,
	       m.max_time_to_complete, r2.revision_id as content_rev_id,
	       r2.title as content_filename, ci2.content_type
	from as_session_items s, as_items i, as_item_section_map m, cr_revisions r,
	     cr_items ci, as_item_rels ar, cr_revisions r2, cr_items ci2
	where ar.item_rev_id(+) = s.as_item_id
	and ar.rel_type(+) = 'as_item_content_rel'
	and ar.target_rev_id = r2.revision_id(+)
	and ci2.item_id (+) = r2.item_id
	and s.session_id = :session_id
	and s.section_id = :section_id
	and i.as_item_id = s.as_item_id
	and r.revision_id = i.as_item_id
	and ci.item_id = r.item_id
	and m.as_item_id = s.as_item_id
	and m.section_id = s.section_id
	order by s.sort_order

	</querytext>
</fullquery>
	
<fullquery name="as::section::items.section_items">
	<querytext>

	select i.as_item_id, ci.name, cr.title, cr.description, i.subtext,
	       m.required_p, m.max_time_to_complete, r2.revision_id as content_rev_id,
	       r2.title as content_filename, ci2.content_type, m.fixed_position
	from as_item_section_map m, as_items i, cr_revisions cr, cr_items ci,
	     as_item_rels ar, cr_revisions r2, cr_items ci2
	where ar.item_rev_id (+) = i.as_item_id
	and ar.rel_type (+) = 'as_item_content_rel'
	and ar.target_rev_id = r2.revision_id (+)
	and ci2.item_id (+) = r2.item_id
	and cr.revision_id = i.as_item_id
	and i.as_item_id = m.as_item_id
	and m.section_id = :section_id
	and ci.item_id = cr.item_id
	order by m.sort_order

	</querytext>
</fullquery>
	
<fullquery name="as::section::calculate.max_section_points">
	<querytext>

	select asm.points as section_max_points
	from as_assessment_section_map asm
	where asm.assessment_id = :assessment_id
	and asm.section_id = :section_id
	and not exists (select 1
			from as_item_data d, as_session_items i
			where i.session_id = :session_id
			and d.as_item_id(+) = i.as_item_id
			and d.session_id(+) = i.session_id
			and i.section_id = :section_id
			and d.points is null)

	</querytext>
</fullquery>
	
</queryset>
