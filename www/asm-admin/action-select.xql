<?xml version="1.0"?>
<queryset>

<fullquery name="get_actions">
<querytext>
	select a.name, a.action_id from as_actions a where (select context_id from 
	acs_objects where object_id=a.action_id)=:package_id
</querytext>
</fullquery>

<fullquery name="get_max_order">
<querytext>
	select max(am.order_by) from as_action_map am,as_inter_item_checks c
	where c.inter_item_check_id=am.inter_item_check_id and
	c.section_id_from = :section_id and am.action_perform=:action_perform
</querytext>
</fullquery>

<fullquery name="select_action">
<querytext>
	insert into as_action_map
	(inter_item_check_id,action_id,order_by,user_message,action_perform)
	values (:inter_item_check_id,:action_id,:order_value,:user_message,:action_perform)
</querytext>
</fullquery>

<fullquery name="exist_check">
<querytext>
	select count(inter_item_check_id) from as_action_map where inter_item_check_id=:inter_item_check_id
</querytext>
</fullquery>

<fullquery name="get_values">
<querytext>
	select * from as_action_map where inter_item_check_id=:inter_item_check_id
</querytext>
</fullquery>

<fullquery name="get_action_p">
<querytext>
	select action_p from as_inter_item_checks  where inter_item_check_id=:inter_item_check_id
</querytext>
</fullquery>

<fullquery name="action_perform">
<querytext>
	select action_perform from as_action_map   where inter_item_check_id=:inter_item_check_id
</querytext>
</fullquery>

<fullquery name="edit_action">
<querytext>
	update as_action_map set action_perform=:action_perform, action_id=:action_id, user_message=:user_message where inter_item_check_id=:inter_item_check_id
</querytext>
</fullquery>


<fullquery name="edit_action_order_by">
<querytext>
	update as_action_map set action_perform=:action_perform, action_id=:action_id, user_message=:user_message,order_by=:order_value where inter_item_check_id=:inter_item_check_id
</querytext>
</fullquery>

<fullquery name="delete_action_map">
<querytext>
	delete from as_action_map where inter_item_check_id=:inter_item_check_id;
</querytext>
</fullquery>

<fullquery name="delete_param_map">
<querytext>
	delete from as_param_map where inter_item_check_id=:inter_item_check_id;
</querytext>
</fullquery>



</queryset>
