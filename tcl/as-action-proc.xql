<?xml version="1.0"?>
<queryset>

<fullquery name="as::action::select_tcl">
<querytext>
  select a.tcl_code from as_actions a,as_actions_map am where am.action_id = a.action_id and inter_item_check_id = :inter_item_check_id

</querytext>
</fullquery>


<fullquery name="as::action::get_check_params">
<querytext>
	select parameter_id,value from as_param_map where inter_item_check_id = :inter_item_check_id


</querytext>
</fullquery>


<fullquery name="as::action::select_name">
<querytext>
	select varname from as_action_params where parameter_id = :parameter_id

</querytext>
</fullquery>

</queryset>
