<?xml version="1.0"?>
<queryset>

<fullquery name="find_assessment">
      <querytext>
    select r.item_id as assessment_id, s.assessment_id as assessment_rev_id,
           s.subject_id, p.first_names, p.last_name
    from as_sessions s, cr_revisions r, persons p
    where s.session_id = :session_id
    and r.revision_id = s.assessment_id
    and s.subject_id = p.person_id
      </querytext>
</fullquery>

<fullquery name="get_item_data">
      <querytext>
    select d.item_data_id, o.object_type as item_type,
           cr.title as item_title, ism.points as max_points
    from as_item_data d, as_session_item_map m, as_item_rels r, acs_objects o,
         cr_revisions cr, as_item_section_map ism
    where d.session_id = :session_id
    and d.section_id = :section_id
    and d.as_item_id = :as_item_id
    and m.session_id = d.session_id
    and m.item_data_id = d.item_data_id
    and r.item_rev_id = d.as_item_id
    and r.target_rev_id = o.object_id
    and r.rel_type = 'as_item_type_rel'
    and cr.revision_id = d.as_item_id
    and ism.as_item_id = d.as_item_id
    and ism.section_id = d.section_id
      </querytext>
</fullquery>

<fullquery name="result_points">
<querytext>
    select r.points
    from as_session_results r
    where r.target_id = :item_data_id
    and r.result_id = (select max(result_id)
		    from as_session_results r2
		    where r2.target_id = :item_data_id)
</querytext>
</fullquery>

<fullquery name="update_item_points">
      <querytext>
    update as_item_data
    set points = :points
    where item_data_id = :item_data_id
      </querytext>
</fullquery>

</queryset>
