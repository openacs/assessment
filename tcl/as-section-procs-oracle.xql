<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="as::section::items.get_sorted_items">
	<querytext>

	select s.as_item_id, ci.name, r.title, r.description, i.subtext, m.required_p,
	       m.max_time_to_complete, r2.revision_id as content_rev_id,
	       r2.title as content_filename, ci2.content_type,
	       ir.target_rev_id as as_item_type_id, i.validate_block,
	       r.content as question_text               
	from as_session_items s, as_items i, as_item_section_map m, cr_revisions r,
	     cr_items ci, as_item_rels ar, cr_revisions r2, cr_items ci2,
	     as_item_rels ir
	where ar.item_rev_id(+) = s.as_item_id
	and ar.rel_type(+) = 'as_item_content_rel'
	and ar.target_rev_id = r2.revision_id(+)
	and ci2.item_id (+) = r2.item_id
	and s.session_id = :session_id
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
	from as_item_section_map m, as_items i, cr_revisions cr, cr_items ci,
	     as_item_rels ar, cr_revisions r2, cr_items ci2, as_item_rels ir
	where ar.item_rev_id (+) = i.as_item_id
	and ar.rel_type (+) = 'as_item_content_rel'
	and ar.target_rev_id = r2.revision_id (+)
	and ci2.item_id (+) = r2.item_id
	and cr.revision_id = i.as_item_id
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
			from as_session_items i, as_item_data d, as_session_item_map m
			where d.section_id (+) = i.section_id
			and d.session_id (+) = i.session_id
			and d.as_item_id (+) = i.as_item_id
			and m.session_id (+) = d.session_id
			and m.item_data_id (+) = d.item_data_id
			and i.session_id = :session_id
			and i.section_id = :section_id
			and d.points is null)

	</querytext>
</fullquery>
	
<fullquery name="as::section::calculate.update_section_points">
	<querytext>

	update as_section_data
	set points = :section_points,
	    completed_datetime = sysdate
	where session_id = :session_id
	and section_id = :section_id

	</querytext>
</fullquery>
	
<fullquery name="as::section::skip.set_zero_points">
	<querytext>

	update as_section_data
	set creation_datetime= sysdate,
	    completed_datetime = sysdate,
	    points = 0
	where section_data_id = :section_data_id

	</querytext>
</fullquery>

<fullquery name="as::section::new.update_clobs">
    <querytext>
      update as_sections set instructions=empty_clob()
      where section_id=:as_section_id
      returning instructions into :1
    </querytext>
</fullquery>

<fullquery name="as::section::edit.update_clobs">
    <querytext>
      update as_sections set instructions=empty_clob(),
      feedback_text=empty_clob()
      where section_id=:new_section_id
      returning instructions,feedback_text into :1, :2
    </querytext>
</fullquery>  
  
<fullquery name="as::section::new_revision.update_clobs">
    <querytext>
      update as_sections set instructions=empty_clob(),
      feedback_text=empty_clob()
      where section_id=:new_section_id
      returning instructions,feedback_text into :1, :2
    </querytext>
</fullquery>  
  
</queryset>
