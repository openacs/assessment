<?xml version="1.0"?>
<queryset>

<fullquery name="result_changes">
<querytext>

    select cr.title, cr.description, sr.points, p.first_names, p.last_name,
           to_char(o.creation_date, :format) as date, o.creation_user
    from as_session_results sr, cr_revisions cr, acs_objects o, persons p,
         as_item_data d, as_session_item_map m
    where cr.revision_id = sr.result_id
    and o.object_id = cr.revision_id
    and cr.description is not null
    and p.person_id = o.creation_user
    and sr.target_id = d.item_data_id
    and d.session_id = :session_id
    and d.section_id = :section_id
    and d.as_item_id = :as_item_id
    and m.item_data_id = d.item_data_id
    and m.session_id = d.session_id
    order by o.creation_date

</querytext>
</fullquery>

</queryset>
