<?xml version="1.0"?>
<queryset>

    <fullquery name="as::actions::update_checks_after_upgrade.get_all_checks">
        <querytext>
	 
		select inter_item_check_id,check_sql from as_inter_item_checks   	
	
        </querytext>
    </fullquery>
	
    <fullquery name="as::actions::update_checks_after_upgrade.update_checks">
        <querytext>
	
	 update as_inter_item_checks set check_sql=:check_sql where inter_item_check_id=:inter_item_check_id	 
	
        </querytext>
    </fullquery>

</queryset>
