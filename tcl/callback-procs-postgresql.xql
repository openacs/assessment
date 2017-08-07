<?xml version="1.0"?>
<queryset>

  <rdbms><type>postgresql</type><version>7.2</version></rdbms>

<fullquery name="callback::learning_materials_portlet::portlet_multirow_admin_data::impl::assessment.get_assessments">
    <querytext>
       select ci.item_id as assessment_id, cr.title, ci.publish_status,
         (select count(*) from (select distinct subject_id from as_sessions
                           where assessment_id in (select revision_id
                           from cr_revisions where item_id=ci.item_id)
                           and completed_datetime is not null) c
         ) as completed_number
       from cr_items ci, cr_revisions cr, acs_objects o
       where cr.revision_id = ci.latest_revision
       and o.package_id in ([template::util::tcl_to_sql_list $list_of_package_ids])
       and o.object_id = ci.item_id
       and ci.content_type = 'as_assessments'
and not exists (select 1 from
as_assessment_section_map m,
ims_cp_resources r,
cr_revisions cr,
cr_revisions cr2
where r.identifier= cr2.item_id
and cr2.revision_id = m.section_id
and m.assessment_id = cr.revision_id
and cr.item_id = ci.item_id)

       $folder_id_clause
       and acs_permission__permission_p(ci.item_id, :user_id, 'admin')

       order by cr.title
    </querytext>
</fullquery>
  

</queryset>
