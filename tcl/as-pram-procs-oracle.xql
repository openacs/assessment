<?xml version="1.0"?>
<queryset>

<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="as::actionparam::actiondelete.delete_action">
<querytext>
	begin 
	as_action.delete (:action_id);
	end;
</querytext>
</fullquery>
</queryset>