<?xml version="1.0"?>
<queryset>

<fullquery name="section_title">
      <querytext>
      
    select title as section_title
    from cr_revisions
    where revision_id = :section_id
    
      </querytext>
</fullquery>

<fullquery name="item_types">
      <querytext>

    select distinct item_type
    from as_item_types_map

      </querytext>
</fullquery>

<fullquery name="item_list">
      <querytext>
      
	select i.as_item_id
	from cr_items ci, cr_revisions cr, as_items i, acs_objects ao,
	     persons p, as_item_rels ir, acs_objects o
	where cr.revision_id = ci.latest_revision
	and i.as_item_id = cr.revision_id
	and i.as_item_id not in (select m.as_item_id
				 from as_item_section_map m
				 where m.section_id = :section_id)
	and ao.object_id = cr.revision_id
	and p.person_id = ao.creation_user
	and ir.item_rev_id = cr.revision_id
	and ir.target_rev_id = o.object_id
	and ir.rel_type = 'as_item_type_rel'
	$orderby_clause
    
      </querytext>
</fullquery>

<fullquery name="unmapped_items_to_section">
      <querytext>
      
    select i.as_item_id, cr.title, ci.name, p.first_names, p.last_name,
           o.object_type as item_type
    from cr_items ci, cr_revisions cr, as_items i, acs_objects ao,
         persons p, as_item_rels ir, acs_objects o
    where cr.revision_id = ci.latest_revision
    and i.as_item_id = cr.revision_id
    and i.as_item_id not in (select m.as_item_id
			     from as_item_section_map m
			     where m.section_id = :section_id)
    and ao.object_id = cr.revision_id
    and p.person_id = ao.creation_user
    and ir.item_rev_id = cr.revision_id
    and ir.target_rev_id = o.object_id
    and ir.rel_type = 'as_item_type_rel'
    $page_clause
    $orderby_clause
    
      </querytext>
</fullquery>

</queryset>
