<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="as::section_data::new.update_creation_time">
	<querytext>

	update as_section_data
	set creation_datetime = sysdate
	where session_id = :session_id
	and section_id = :section_id

	</querytext>
</fullquery>
	
</queryset>
