<?xml version="1.0"?>
<queryset>
<fullquery name="as::actionparam::paramdelete.select_params">
      <querytext>
      select count(inter_item_check_id) as maps from as_param_map where parameter_id=:parameter_id

      </querytext>
</fullquery>

<fullquery name="as::actionparam::paramdelete.delete_param">
      <querytext>
      delete from as_action_params where parameter_id =:parameter_id
      
      </querytext>
</fullquery>

<fullquery name="as::actionparam::actiondelete.select_actions">
      <querytext>
      select count(inter_item_check_id) as maps from as_action_map where action_id=:action_id
      </querytext>
</fullquery>



<fullquery name="as::actionparam::actiondelete.delete_param">
      <querytext>
      delete from as_action_params where action_id =:action_id
      </querytext>
</fullquery>

</queryset>

