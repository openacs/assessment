<?xml version="1.0"?>
<queryset>

  <fullquery name="open_asssessments">
    <rdbms><type>postgresql</type><version>7.3</version></rdbms>
    <querytext>
	select cr.item_id as assessment_id, cr.title, cr.description, a.password,
	       to_char(a.start_time, 'YYYY-MM-DD HH24:MI:SS') as start_time,
	       to_char(a.end_time, 'YYYY-MM-DD HH24:MI:SS') as end_time,
	       to_char(now(), 'YYYY-MM-DD HH24:MI:SS') as cur_time
	from as_assessments a, cr_revisions cr, cr_items ci
	where a.assessment_id = cr.revision_id
	and cr.revision_id = ci.latest_revision
	and ci.parent_id = :folder_id
        and ci.publish_status='live'
	and exists (select 1
		from as_assessment_section_map asm, as_item_section_map ism
		where asm.assessment_id = a.assessment_id
		and ism.section_id = asm.section_id)
	and acs_permission__permission_p (a.assessment_id, :user_id, 'read') = 't'
	order by lower(cr.title)
    </querytext>
  </fullquery>

  <fullquery name="open_asssessments">
    <rdbms><type>postgresql</type><version>8.4</version></rdbms>
    <querytext>
	  select cr.item_id as assessment_id,
                 cr.title,
                 cr.description,
                 a.password,
	         to_char(a.start_time, 'YYYY-MM-DD HH24:MI:SS') as start_time,
	         to_char(a.end_time, 'YYYY-MM-DD HH24:MI:SS') as end_time,
	         to_char(now(), 'YYYY-MM-DD HH24:MI:SS') as cur_time
	    from as_assessments a,
                 cr_revisions cr
	   where a.assessment_id in (
                 -- live revisions in selected folders our user is allowed to read      
                 select orig_object_id from acs_permission.permission_p_recursive_array(array(
                    select latest_revision from cr_items
                     where parent_id = :folder_id
                       and publish_status = 'live'), :user_id, 'read'))
             and a.assessment_id = cr.revision_id
	     and exists (select 1
	                   from as_assessment_section_map asm,
                                as_item_section_map ism
                          where asm.assessment_id = a.assessment_id
	                    and ism.section_id = asm.section_id)
 	   order by lower(cr.title)
    </querytext>
  </fullquery>
	
</queryset>
