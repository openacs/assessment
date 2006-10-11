<?xml version="1.0"?>
<queryset>

<fullquery name="all_sections">
      <querytext>

	select asm.section_id, cr.item_id
        from as_assessment_section_map asm, cr_revisions cr
        where asm.assessment_id = :assessment_rev_id
        and asm.section_id = cr.revision_id
        order by asm.sort_order

      </querytext>
</fullquery>

<fullquery name="all_section_items">
      <querytext>

	select cr.title, cr.description, o.object_type, i.data_type, i.field_name,
	       cr.item_id as as_item_item_id
	from as_item_section_map ism, cr_revisions cr,
	     as_items i, as_item_rels ir, acs_objects o
	where ism.section_id = :section_id
	and cr.revision_id = ism.as_item_id
	and i.as_item_id = ism.as_item_id
	and ir.item_rev_id = i.as_item_id
	and ir.rel_type = 'as_item_type_rel'
	and o.object_id = ir.target_rev_id
	order by ism.sort_order, o.object_type

      </querytext>
</fullquery>

<fullquery name="all_sessions">
      <querytext> 
	select s.session_id, s.percent_score, s.subject_id,
	       to_char(s.completed_datetime, 'YYYY-MM-DD HH24:MI:SS') as submission_date
	from as_sessions s, cr_revisions r
	where r.item_id = :assessment_id
	and s.assessment_id = r.revision_id
	and s.completed_datetime is not null
	$start_date_sql
	$end_date_sql
	order by s.session_id

      </querytext>
</fullquery>

<fullquery name="mc_items">
      <querytext>

	select d.session_id, d.item_data_id, c.text_value, rc.title, ri.item_id as mc_item_id
	from as_item_data d, as_session_item_map m, cr_revisions ri,
	     as_item_data_choices dc, as_item_choices c, cr_revisions rc,
             as_session_sections s, cr_revisions rs
	where s.session_id in ([join $session_list ,])
        and s.section_id = rs.revision_id
        and rs.item_id = :section_item_id
        and d.session_id = s.session_id
	and d.as_item_id = ri.revision_id
	and d.section_id = s.section_id
	and m.session_id = d.session_id
	and m.item_data_id = d.item_data_id
	and dc.item_data_id = d.item_data_id
	and c.choice_id = dc.choice_id
	and c.choice_id = rc.revision_id

      </querytext>
</fullquery>

</queryset>
