<queryset>

<fullquery name="as::list::get_items_multirow.sections">
    <querytext>
	select cr.title as option_section_title, 
        s.section_id as option_section_id,
        map.last_modified,
        map.assessment_id
	from as_sections s, 
        cr_revisions cr, 
        cr_items ci,
 	(select distinct section_id, sort_order, last_modified,assessment_id
         from (select m.assessment_id, o.last_modified,
               m.section_id, m.sort_order
               from as_assessment_section_map m,
	       acs_objects o
               where 
               m.assessment_id = o.object_id
	       and m.assessment_id 
               in ([template::util::tcl_to_sql_list $assessment_ids])) s1 
               $multiple_assessment_where) map
	where ci.item_id = cr.item_id
	and cr.revision_id = s.section_id
	and s.section_id = map.section_id
        order by map.last_modified desc, map.sort_order asc
    </querytext>
</fullquery>

<fullquery name="as::list::get_items_multirow.items">
    <querytext>
	select ci.item_id, 
        cr.title,
        ir.revision_id as as_item_id,
        ci.content_type as item_type,
	ism.sort_order,
        ci.latest_revision
	from as_items i, 
        cr_revisions cr, 
        cr_items ci, 
        as_item_section_map ism, 
        cr_revisions ir
   	where ci.item_id = cr.item_id
        and ir.revision_id = ci.latest_revision
	and cr.revision_id = i.as_item_id
	and i.as_item_id = ism.as_item_id
	and ism.section_id = :option_section_id
	order by ism.sort_order
    </querytext>
</fullquery>

<fullquery name="as::list::filter_spec.item_choices">
    <querytext>

	    select r.title, r.title
	    
	    from cr_revisions r, as_item_choices c
	    left outer join cr_revisions r2 on (c.content_value = r2.revision_id)
	    
	    where r.revision_id = c.choice_id
	    and c.mc_id = (select max(t.as_item_type_id)
			   from as_item_type_mc t, cr_revisions c, as_item_rels r
			   where t.as_item_type_id = r.target_rev_id
			   and r.item_rev_id = :as_item_id
			   and r.rel_type = 'as_item_type_rel'
			   and c.revision_id = t.as_item_type_id
			   group by c.title, t.increasing_p, t.allow_negative_p,
			   t.num_correct_answers, t.num_answers)
	    
	    order by c.sort_order	
    </querytext>
</fullquery>

<fullquery name="as::list::filter_spec.get_item_type">
    <querytext>
	select oi.object_type
	from cr_items i, as_item_rels it, as_item_rels dt, acs_objects oi
	where dt.item_rev_id = it.item_rev_id
	and it.rel_type = 'as_item_type_rel'
	and dt.rel_type = 'as_item_display_rel'
	and oi.object_id = it.target_rev_id
	and i.latest_revision = it.item_rev_id
	and i.item_id = :cr_item_id
    </querytext>
</fullquery>

<fullquery name="as::list::column_element_spec.get_item_type">
    <querytext>
	select oi.object_type
	from cr_items i, as_item_rels it, as_item_rels dt, acs_objects oi
	where dt.item_rev_id = it.item_rev_id
	and it.rel_type = 'as_item_type_rel'
	and dt.rel_type = 'as_item_display_rel'
	and oi.object_id = it.target_rev_id
	and i.latest_revision = it.item_rev_id
	and i.item_id = :cr_item_id
    </querytext>
</fullquery>

</queryset>