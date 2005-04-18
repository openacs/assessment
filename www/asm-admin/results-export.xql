<?xml version="1.0"?>
<queryset>

<fullquery name="all_items">
      <querytext>

	select cr.title, cr.description, o.object_type, i.data_type, i.field_name,
	       cr.item_id as as_item_item_id, rs.item_id as section_item_id
	from as_assessment_section_map asm, as_item_section_map ism, cr_revisions cr,
	     as_items i, as_item_rels ir, acs_objects o, cr_revisions rs
	where asm.assessment_id = :assessment_rev_id
	and ism.section_id = asm.section_id
	and cr.revision_id = ism.as_item_id
	and i.as_item_id = ism.as_item_id
	and ir.item_rev_id = i.as_item_id
	and ir.rel_type = 'as_item_type_rel'
	and o.object_id = ir.target_rev_id
	and rs.revision_id = ism.section_id
	order by asm.sort_order, ism.sort_order

      </querytext>
</fullquery>

<fullquery name="all_sessions">
      <querytext>

	select s.session_id, s.percent_score, s.subject_id, p.first_names, p.last_name,
	       to_char(s.completed_datetime, 'YYYY-MM-DD HH24:MI:SS') as submission_date,
	       y.email
	from as_sessions s, persons p, parties y,
	     (select max(s2.session_id) as session_id, s2.subject_id
	      from as_sessions s2, cr_revisions r
	      where r.item_id = :assessment_id
	      and s2.assessment_id = r.revision_id
	      and s2.completed_datetime is not null
	      group by s2.subject_id) sub
	where s.session_id = sub.session_id
	and sub.subject_id = p.person_id
	and sub.subject_id = y.party_id
	$start_date_sql
	$end_date_sql
	order by s.session_id

      </querytext>
</fullquery>

</queryset>
