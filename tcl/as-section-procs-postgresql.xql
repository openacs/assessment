<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="as::section::items.get_sorted_items">
	<querytext>

	select s.as_item_id, ci.name, r.title, r.description, i.subtext, m.required_p,
	       m.max_time_to_complete, r2.revision_id as content_rev_id,
	       r2.title as content_filename, ci2.content_type
	from cr_items ci, as_items i, as_item_section_map m, cr_revisions r,
	     as_session_items s
	left outer join as_item_rels ar on (ar.item_rev_id = s.as_item_id and ar.rel_type = 'as_item_content_rel')
	left outer join cr_revisions r2 on (ar.target_rev_id = r2.revision_id)
	left outer join cr_items ci2 on (ci2.item_id = r2.item_id)
	where s.session_id = :session_id
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
	from as_item_section_map m, cr_revisions cr, cr_items ci, as_items i
	left outer join as_item_rels ar on (ar.item_rev_id = i.as_item_id and ar.rel_type = 'as_item_content_rel')
	left outer join cr_revisions r2 on (ar.target_rev_id = r2.revision_id)
	left outer join cr_items ci2 on (ci2.item_id = r2.item_id)
	where cr.revision_id = i.as_item_id
	and i.as_item_id = m.as_item_id
	and m.section_id = :section_id
	and ci.item_id = cr.item_id
	order by m.sort_order

	</querytext>
</fullquery>
	
</queryset>