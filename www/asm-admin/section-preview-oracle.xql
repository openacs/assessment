<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="section_items">
	<querytext>

	select i.as_item_id, ci.name, cr.title, cr.description, i.subtext,
	       m.required_p, m.max_time_to_complete, r2.revision_id as content_rev_id,
	       r2.title as content_filename, ci2.content_type,
	       ir.target_rev_id as as_item_type_id
	from as_item_section_map m, as_items i, cr_revisions cr, cr_items ci,
	     as_item_rels ar, cr_revisions r2, cr_items ci2, as_item_rels ir
	where ar.item_rev_id (+) = i.as_item_id
	and ar.rel_type (+) = 'as_item_content_rel'
	and ar.target_rev_id = r2.revision_id (+)
	and ci2.item_id (+) = r2.item_id
	and cr.revision_id = i.as_item_id
	and i.as_item_id = m.as_item_id
	and m.section_id = :section_id
	and ci.item_id = cr.item_id
	and ir.item_rev_id = i.as_item_id
	and ir.rel_type = 'as_item_type_rel'
	order by m.sort_order

	</querytext>
</fullquery>
	
</queryset>
