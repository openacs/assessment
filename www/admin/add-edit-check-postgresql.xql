<?xml version="1.0"?>
<queryset>

<fullquery name="get_item_sec_id">
<querytext>
  select item_id from cr_revisions where revision_id=:section_id

</querytext>
</fullquery>

<fullquery name="new_check">
<querytext>
	select as_inter_item_check__new (:inter_item_check_id,:action_p,:section_id_from,null,:check_sql,:name,:description,:postcheck_p,null,:user_id,null,:assessment_id)	
</querytext>
</fullquery>


</queryset>
