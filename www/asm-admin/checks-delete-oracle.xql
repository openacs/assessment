<?xml version="1.0"?>
<queryset>

<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="delete_check">
<querytext>
	begin
	as_inter_item_check.del($check_id);
	end;
</querytext>
</fullquery>


</queryset>
