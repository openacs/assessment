<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/assessment/www/asm-admin/sessions.xql -->
<!-- @author Dave Bauer (dave@thedesignexperience.org) -->
<!-- @creation-date 2007-09-14 -->
<!-- @cvs-id $Id$ -->
<queryset>
  <fullquery name="get_sessions">
    <querytext>
    select a.*,
    to_char(cs.completed_datetime, 'YYYY-MM-DD HH24:MI:SS') as completed_datetime,
    to_char(coalesce(cs.last_mod_datetime, ns.last_mod_datetime), 'YYYY-MM-DD HH24:MI:SS') as last_mod_datetime,
    coalesce(cs.subject_id, ns.subject_id) as subject_id,
    coalesce(cs.session_id, ns.session_id) as session_id,
    cs.percent_score
 
    from (select a.assessment_id, cr.title, cr.item_id, cr.revision_id,
          u.user_id, u.first_names, u.last_name
          
          from as_assessments a, cr_revisions cr, cr_items ci, acs_users_all u
          where a.assessment_id = cr.revision_id
          and cr.revision_id = ci.latest_revision
          and ci.parent_id = :folder_id
          and u.user_id <> 0
          and acs_permission__permission_p(:context_object_id, u.user_id, 'read')
          ) a
    left join (select as_sessions.*, cr.item_id
               from as_sessions, cr_revisions cr
               where session_id in (select max(session_id)
                                    from as_sessions, acs_objects o
                                    where not completed_datetime is null
                                    and o.object_id = session_id
                                    and o.package_id = :package_id
                                    group by subject_id, assessment_id )
               and revision_id=assessment_id) cs
    on (a.user_id = cs.subject_id and a.item_id = cs.item_id)

    left join (select *
               from as_sessions
               where session_id in (select max(session_id)
                                    from as_sessions, acs_objects o
                                    where completed_datetime is null
                                    and o.object_id = session_id
                                    and o.package_id = :package_id
                                    group by subject_id, assessment_id)) ns
    on (a.user_id = ns.subject_id and a.assessment_id = ns.assessment_id)

    where 1=1
    [list::filter_where_clauses -and -name "sessions"]


    </querytext>
  </fullquery>
</queryset>
