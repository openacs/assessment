<?xml version="1.0"?>
<queryset>

<fullquery name="get_aa_checks">
<querytext>		
        select am.action_perform,c.inter_item_check_id,c.name,a.name as action_name, am.order_by,c.section_id_from from as_inter_item_checks c,as_actions a, as_action_map am where am.inter_item_check_id = c.inter_item_check_id and am.action_id=a.action_id and c.section_id_from =:section_id and am.action_perform = 'aa' and c.action_p = 't'order by order_by
</querytext>			
</fullquery>

<fullquery name="get_i_checks">
<querytext>		
	select am.action_perform,am.order_by, c.inter_item_check_id,c.name,a.name as action_name,c.section_id_from from
	as_inter_item_checks c,as_actions a, as_action_map am where
	am.inter_item_check_id = c.inter_item_check_id and am.action_id=a.action_id
	and c.section_id_from =:section_id and am.action_perform = 'i' and c.action_p
	= 't' order by order_by
</querytext>			
</fullquery>

<fullquery name="get_m_checks">
<querytext>		
	select am.action_perform,am.order_by, c.inter_item_check_id,c.name,a.name as action_name,c.section_id_from from
	as_inter_item_checks c,as_actions a, as_action_map am where
	am.inter_item_check_id = c.inter_item_check_id and am.action_id=a.action_id
	and c.section_id_from =:section_id and am.action_perform = 'm' and c.action_p
	= 't' order by order_by
</querytext>			
</fullquery>

<fullquery name="get_branches">
<querytext>		
	select c.name,c.inter_item_check_id,c.section_id_to,(select cr.title from
	cr_revisions cr where cr.revision_id=c.section_id_to) as sname  from
	as_inter_item_checks c where c.action_p='f' and c.section_id_from=:section_id
</querytext>			
</fullquery>

</queryset>
