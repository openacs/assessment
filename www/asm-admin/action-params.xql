<?xml version="1.0"?>
<queryset>

<fullquery name="get_params">
<querytext>
	select * from as_action_params where action_id=:action_id
</querytext>
</fullquery>

<fullquery name="get_perform">
<querytext>
	select action_perform from as_action_map where inter_item_check_id=:inter_item_check_id
</querytext>
</fullquery>


<fullquery name="has_params">
<querytext>
	select count(parameter_id) from as_action_params where action_id=:action_id
</querytext>
</fullquery>


<fullquery name="get_param_info">
<querytext>
	select * from as_param_map where parameter_id=:parameter_id and inter_item_check_id=:inter_item_check_id
</querytext>
</fullquery>


<fullquery name="choices">
<querytext>
    select cri.title, cri.item_id as as_item_id
    from as_item_section_map sm, cr_revisions cri
    where sm.as_item_id = cri.revision_id and sm.section_id = :section_id
</querytext>
</fullquery>

<fullquery name="prev_choices">
<querytext>
    select cri.title, cri.item_id as as_item_id
    from as_item_section_map sm, cr_revisions cri
    where sm.as_item_id = cri.revision_id and sm.section_id in (
    select s.section_id
    from as_sections s, cr_revisions cr, cr_items ci,
    as_assessment_section_map asm,as_item_section_map sm
    where ci.item_id = cr.item_id
    and cr.revision_id = s.section_id
    and s.section_id = asm.section_id 
    and asm.assessment_id = :new_assessment_revision and asm.sort_order <
    (select sort_order from as_assessment_section_map where
    section_id=:section_id and assessment_id=:new_assessment_revision))

</querytext>
</fullquery>


<fullquery name="param_values_n">
	   <querytext>
		insert into as_param_map
	   (parameter_id,inter_item_check_id,value,item_id) values
	   (:parameter_id,:inter_item_check_id,null,:item_id)
	   </querytext>
</fullquery>	

<fullquery name="param_values_q">
	   <querytext>
		insert into as_param_map
	   (parameter_id,inter_item_check_id,value,item_id) values
	   (:parameter_id,:inter_item_check_id,:value,null)
	   </querytext>
</fullquery>	

</queryset>
