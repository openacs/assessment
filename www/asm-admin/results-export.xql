<?xml version="1.0"?>
<queryset>

<fullquery name="all_sections">
      <querytext>
	select item_id from as_assessment_section_map asm, cr_items ci where asm.assessment_id = $assessment_rev_id and asm.section_id = ci.latest_revision
      </querytext>
</fullquery>

<fullquery name="all_section_items">
      <querytext>

	select cr.title, cr.description, o.object_type, i.data_type, i.field_name,
	       cr.item_id as as_item_item_id
	from as_item_section_map ism, cr_revisions cr, cr_items ci,
	     as_items i, as_item_rels ir, acs_objects o
	where ism.section_id = ci.latest_revision
	and ci.item_id = $section_id
	and cr.revision_id = ism.as_item_id
	and i.as_item_id = ism.as_item_id
	and ir.item_rev_id = i.as_item_id
	and ir.rel_type = 'as_item_type_rel'
	and o.object_id = ir.target_rev_id
	order by o.object_type, ism.sort_order

      </querytext>
</fullquery>

<fullquery name="all_sessions">
      <querytext> 
	select s.session_id, s.percent_score, s.subject_id,
	       to_char(s.completed_datetime, 'YYYY-MM-DD HH24:MI:SS') as submission_date
	from as_sessions s,
	     (select max(s2.session_id) as session_id, s2.subject_id
	      from as_sessions s2, cr_revisions r
	      where r.item_id = :assessment_id
	      and s2.assessment_id = r.revision_id
	      and s2.completed_datetime is not null
	      group by s2.subject_id) sub
	where s.session_id = sub.session_id
	$start_date_sql
	$end_date_sql
	order by s.session_id

      </querytext>
</fullquery>

<fullquery name="mc_items">
      <querytext>

	select d.session_id, d.item_data_id, c.text_value, rc.title, ri.item_id as mc_item_id
	from as_item_data d, as_session_item_map m, cr_revisions ri, cr_revisions rs,
	     as_item_data_choices dc, as_item_choices c, cr_revisions rc
	where d.session_id in ([join $session_list ,])
	and d.as_item_id = ri.revision_id
	and d.section_id = rs.revision_id
	and rs.item_id = $section_id
	and m.session_id = d.session_id
	and m.item_data_id = d.item_data_id
	and dc.item_data_id = d.item_data_id
	and c.choice_id = dc.choice_id
	and c.choice_id = rc.revision_id

      </querytext>
</fullquery>

</queryset>
