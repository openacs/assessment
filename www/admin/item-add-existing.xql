<?xml version="1.0"?>
<queryset>

<fullquery name="section_title">
      <querytext>
      
    select title as section_title
    from cr_revisions
    where revision_id = :section_id
    
      </querytext>
</fullquery>

<fullquery name="item_list">
      <querytext>
      
	select i.as_item_id
	from cr_items ci, cr_revisions cr, as_items i
	where cr.revision_id = ci.latest_revision
	and i.as_item_id = cr.revision_id
	and i.as_item_id not in (select m.as_item_id
				 from as_item_section_map m
				 where m.section_id = :section_id)
	$orderby_clause
    
      </querytext>
</fullquery>

<fullquery name="unmapped_items_to_section">
      <querytext>
      
    select i.as_item_id, cr.title
    from cr_items ci, cr_revisions cr, as_items i
    where cr.revision_id = ci.latest_revision
    and i.as_item_id = cr.revision_id
    and i.as_item_id not in (select m.as_item_id
			     from as_item_section_map m
			     where m.section_id = :section_id)
    $page_clause
    $orderby_clause
    
      </querytext>
</fullquery>

</queryset>
