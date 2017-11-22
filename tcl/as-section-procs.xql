<?xml version="1.0"?>
<queryset>

<fullquery name="as::section::items.get_sorted_items">
	<querytext>

	select s.as_item_id, ci.name, r.title,
               r.description, i.subtext, m.required_p,
	       m.max_time_to_complete, r2.revision_id as content_rev_id,
	       r2.title as content_filename, ci2.content_type,
	       ir.target_rev_id as as_item_type_id, i.validate_block,
	       r.content as question_text
	from cr_items ci, as_items i, as_item_section_map m, cr_revisions r,
	     as_item_rels ir, as_session_items s
	left outer join as_item_rels ar on (ar.item_rev_id = s.as_item_id and ar.rel_type = 'as_item_content_rel')
	left outer join cr_revisions r2 on (ar.target_rev_id = r2.revision_id)
	left outer join cr_items ci2 on (ci2.item_id = r2.item_id)
	where s.session_id = :session_id
	and s.section_id = :section_id
	and i.as_item_id = s.as_item_id
	and r.revision_id = i.as_item_id
	and ci.item_id = r.item_id
	and m.as_item_id = s.as_item_id
	and m.section_id = s.section_id
	and ir.item_rev_id = s.as_item_id
	and ir.rel_type = 'as_item_type_rel'
	order by s.sort_order

	</querytext>
</fullquery>

<fullquery name="as::section::items.section_items">
	<querytext>

	select i.as_item_id, ci.name, cr.title, cr.description, i.subtext,
	       m.required_p, m.max_time_to_complete, r2.revision_id as content_rev_id,
	       r2.title as content_filename, ci2.content_type, m.fixed_position,
	       ir.target_rev_id as as_item_type_id, i.validate_block,
               cr.content as question_text
	from as_item_section_map m, cr_revisions cr, cr_items ci,
	     as_item_rels ir, as_items i
	left outer join as_item_rels ar on (ar.item_rev_id = i.as_item_id and ar.rel_type = 'as_item_content_rel')
	left outer join cr_revisions r2 on (ar.target_rev_id = r2.revision_id)
	left outer join cr_items ci2 on (ci2.item_id = r2.item_id)
	where cr.revision_id = i.as_item_id
	and i.as_item_id = m.as_item_id
	and m.section_id = :section_id
	and ci.item_id = cr.item_id
	and ir.item_rev_id = i.as_item_id
	and ir.rel_type = 'as_item_type_rel'
	order by m.sort_order

	</querytext>
</fullquery>

<fullquery name="as::section::calculate.max_section_points">
	<querytext>

	select asm.points as section_max_points
	from as_assessment_section_map asm
	where asm.assessment_id = :assessment_id
	and asm.section_id = :section_id
	and not exists (select 1
			from as_session_items i
			left outer join as_item_data d on (d.section_id = i.section_id
							and d.session_id = i.session_id
							and d.as_item_id = i.as_item_id)
			left outer join as_session_item_map m on (m.session_id = d.session_id
							and m.item_data_id = d.item_data_id)
			where i.session_id = :session_id
			and i.section_id = :section_id
			and d.points is null)

	</querytext>
</fullquery>

<fullquery name="as::section::calculate.update_section_points">
	<querytext>

	update as_section_data
	set points = :section_points,
	    completed_datetime = current_timestamp
	where section_data_id = :section_data_id

	</querytext>
</fullquery>
	
<fullquery name="as::section::skip.set_zero_points">
	<querytext>

	update as_section_data
	set creation_datetime= current_timestamp,
	    completed_datetime = current_timestamp,
	    points = 0
	where session_id = :session_id
	and section_id = :section_id

	</querytext>
</fullquery>
  
<fullquery name="as::section::edit.section_item_id">
      <querytext>

	select item_id
	from cr_revisions
	where revision_id = :section_id

      </querytext>
</fullquery>

<fullquery name="as::section::new_revision.section_data">
      <querytext>

	select cr.item_id as section_item_id, cr.title, cr.description,
	       s.instructions, s.feedback_text, s.max_time_to_complete,
	       s.display_type_id, s.points, s.num_items
	from cr_revisions cr, as_sections s
	where cr.revision_id = :section_id
	and s.section_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::section::latest.get_latest_section_id">
      <querytext>

	select m.section_id
	from as_assessment_section_map m, cr_revisions r, cr_revisions s
	where m.assessment_id = :assessment_rev_id
	and m.section_id = r.revision_id
	and s.revision_id = :section_id
	and s.item_id = r.item_id

      </querytext>
</fullquery>

<fullquery name="as::section::copy.section_data">
      <querytext>

	select cr.title, cr.description,
	       s.instructions, s.feedback_text, s.max_time_to_complete,
	       s.display_type_id, s.points, s.num_items
	from cr_revisions cr, as_sections s
	where cr.revision_id = :section_id
	and s.section_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::section::copy_items.copy_items">
      <querytext>

	insert into as_item_section_map
	(select as_item_id, :new_section_id, required_p, max_time_to_complete,
	        sort_order, fixed_position, points
	 from as_item_section_map
	 where section_id = :section_id)

      </querytext>
</fullquery>

<fullquery name="as::section::items.save_order">
	<querytext>

	    insert into as_session_items (session_id, section_id, as_item_id, sort_order)
	    values (:session_id, :section_id, :as_item_id, :count)

	</querytext>
</fullquery>
	
<fullquery name="as::section::calculate.sum_of_item_points">
	<querytext>

	select sum(m.points) as item_max_points, sum(d.points) as item_points,
	       max(s.section_data_id) as section_data_id
	from as_item_data d, as_item_section_map m, as_session_item_map sm,
	     as_section_data s
	where m.section_id = :section_id
	and d.section_id = m.section_id
	and d.as_item_id = m.as_item_id
	and d.session_id = :session_id
	and sm.session_id = d.session_id
	and sm.item_data_id = d.item_data_id
	and s.session_id = d.session_id
	and s.section_id = d.section_id

	</querytext>
</fullquery>
	
<fullquery name="as::section::close.remaining_items">
	<querytext>

	select i.as_item_id
	from as_session_items i
	where i.session_id = :session_id
	and i.section_id = :section_id
	and i.as_item_id not in (select d.as_item_id
				from as_item_data d
				where d.session_id = :session_id
				and d.section_id = :section_id)

	</querytext>
</fullquery>

<fullquery name="as::section::checks_list_not_cached.checks_related">
<querytext>
	
	select check_sql from as_inter_item_checks where assessment_id=:assessment_id and section_id_from=:section_id

</querytext>
</fullquery>

<fullquery name="as::section::new.item_exists">
      <querytext>

      select item_id
      from cr_items
      where parent_id = :folder_id
      and name = :name

      </querytext>
</fullquery>


<fullquery name="as::section::update_section_in_assessment.update_section_in_assessment">
      <querytext>
		update as_assessment_section_map
		set section_id = :new_section_id
		where assessment_id = :new_assessment_rev_id
		and section_id in (select revision_id from cr_revisions where item_id = (select item_id from cr_revisions where revision_id=:old_section_id))
      </querytext>
</fullquery>

<fullquery name="as::section::add_to_assessment.add">
      <querytext>

	    insert into as_assessment_section_map 
        (assessment_id, section_id, max_time_to_complete, sort_order, points)
	    values 
        (:assessment_rev_id, :section_id, :max_time_to_complete, :sort_order, :points)

      </querytext>
</fullquery>

</queryset>
