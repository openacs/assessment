<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="as::section_data::new.update_creation_time">
	<querytext>

	update as_section_data
	set creation_datetime = now()
	where session_id = :session_id
	and section_id = :section_id

	</querytext>
</fullquery>
	
</queryset>
