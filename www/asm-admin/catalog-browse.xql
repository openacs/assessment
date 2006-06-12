<?xml version="1.0"?>
<queryset>

<fullquery name="section_title">
      <querytext>
      
    select title as section_title
    from cr_revisions
    where revision_id = :section_id
    
      </querytext>
</fullquery>

<partialquery name="other_letter">
      <querytext>
      and (lower(cr.title) < 'a' or lower(cr.title) > 'z')
      </querytext>
</partialquery>

<partialquery name="regular_letter">
      <querytext>
      and lower(cr.title) like :bind_letter
      </querytext>
</partialquery>

<partialquery name="item_type">
      <querytext>
      and o.object_type = :obj_type
      </querytext>
</partialquery>

<partialquery name="categories">
      <querytext>
      and cr.revision_id = s.object_id
      </querytext>
</partialquery>

<partialquery name="item_keywords">
      <querytext>
      and (lower(cr.title) like :keyword_sql or lower(cr.description) like :keyword_sql or lower(i.field_name) like :keyword_sql)
      </querytext>
</partialquery>

<partialquery name="section_keywords">
      <querytext>
      and (lower(cr.title) like :keyword_sql or lower(cr.description) like :keyword_sql or lower(ci.name) like :keyword_sql)
      </querytext>
</partialquery>

<partialquery name="include_subtree_and">
      <querytext>
      select v.object_id
      from (select distinct m.object_id, c.category_id
            from category_object_map m, categories c,
                 categories c_sub
            where c.category_id in ($category_id_sql)
            and m.category_id = c_sub.category_id
            and c_sub.tree_id = c.tree_id
            and c_sub.left_ind >= c.left_ind
            and c_sub.left_ind < c.right_ind) v
      group by v.object_id having count(*) = :category_ids_length
      </querytext>
</partialquery>

<partialquery name="exact_categorization_and">
      <querytext>
      select m.object_id
      from category_object_map m
      where m.category_id in ($category_id_sql)
      group by m.object_id having count(*) = :category_ids_length
      </querytext>
</partialquery>

<partialquery name="include_subtree_or">
      <querytext>
      select distinct m.object_id
      from category_object_map m, categories c,
           categories c_sub
      where c.category_id in ($category_id_sql)
      and m.category_id = c_sub.category_id
      and c_sub.tree_id = c.tree_id
      and c_sub.left_ind >= c.left_ind
      and c_sub.left_ind < c.right_ind
      </querytext>
</partialquery>

<partialquery name="exact_categorization_or">
      <querytext>
      select distinct m.object_id
      from category_object_map m
      where m.category_id in ($category_id_sql)
      </querytext>
</partialquery>

<fullquery name="item_list">
      <querytext>
      
	select i.as_item_id
	from cr_items ci, cr_revisions cr, as_items i, acs_objects ao,
	     persons p, as_item_rels ir, acs_objects o $category_table_clause
	where cr.revision_id = ci.latest_revision
	and i.as_item_id = cr.revision_id
	and i.as_item_id not in (select m.as_item_id
				 from as_item_section_map m
				 where m.section_id = :section_id)
        and exists (select 1 from as_item_rels ir where item_rev_id =
	cr.revision_id and ir.rel_type = 'as_item_display_rel')
	and ao.object_id = cr.revision_id
	and p.person_id = ao.creation_user
	and ir.item_rev_id = cr.revision_id
	and ir.target_rev_id = o.object_id
	and ir.rel_type = 'as_item_type_rel'
	$category_where_clause
	$keyword_where_clause
	$letter_where_clause
	$itype_where_clause
	$orderby_clause
    
      </querytext>
</fullquery>

<fullquery name="unmapped_items_to_section">
      <querytext>
      
    select i.as_item_id, cr.title, i.field_name, p.first_names, p.last_name,
           o.object_type as item_type
    from cr_items ci, cr_revisions cr, as_items i, acs_objects ao,
         persons p, as_item_rels ir, acs_objects o $category_table_clause
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
    $page_where_clause
    $category_where_clause
    $keyword_where_clause
    $letter_where_clause
    $itype_where_clause
    $orderby_clause
    
      </querytext>
</fullquery>

<fullquery name="section_list">
      <querytext>
      
	select i.section_id
	from cr_items ci, cr_revisions cr, as_sections i, acs_objects ao,
	     persons p $category_table_clause
	where cr.revision_id = ci.latest_revision
	and i.section_id = cr.revision_id
	and i.section_id not in (select m.section_id
				 from as_assessment_section_map m
				 where m.assessment_id = :assessment_rev_id)
	and ao.object_id = ci.item_id
	and p.person_id = ao.creation_user
	$category_where_clause
	$keyword_where_clause
	$letter_where_clause
	$orderby_clause
    
      </querytext>
</fullquery>

<fullquery name="unmapped_sections_to_assessment">
      <querytext>
      
    select i.section_id, cr.title, ci.name, p.first_names, p.last_name
    from cr_items ci, cr_revisions cr, as_sections i, acs_objects ao,
         persons p $category_table_clause
    where cr.revision_id = ci.latest_revision
    and i.section_id = cr.revision_id
    and i.section_id not in (select m.section_id
			     from as_assessment_section_map m
			     where m.assessment_id = :assessment_rev_id)
    and ao.object_id = ci.item_id
    and p.person_id = ao.creation_user
    $page_where_clause
    $category_where_clause
    $keyword_where_clause
    $letter_where_clause
    $orderby_clause
    
      </querytext>
</fullquery>

</queryset>
