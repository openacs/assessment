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

<fullquery name="session_attempt">
      <querytext>
    select count(*)
    from as_sessions s, cr_revisions r
    where s.subject_id = :subject_id
    and s.assessment_id = r.revision_id
    and r.item_id = :assessment_id
      </querytext>
</fullquery>

<fullquery name="sections">
      <querytext>
    select s.section_id, cr.title, cr.description, ci.name, s.instructions,
           s.feedback_text, m.max_time_to_complete, m.points as max_points, d.points
    from as_assessment_section_map m, as_session_sections ss, as_section_data d,
         as_sections s, cr_revisions cr, cr_items ci
    where ci.item_id = cr.item_id
    and cr.revision_id = s.section_id
    and s.section_id = m.section_id
    and m.assessment_id = :assessment_rev_id
    and m.section_id = ss.section_id
    and ss.session_id = :session_id
    and d.session_id = ss.session_id
    and d.section_id = ss.section_id
    order by ss.sort_order
      </querytext>
</fullquery>

</queryset>
