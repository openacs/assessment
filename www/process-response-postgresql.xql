<?xml version="1.0"?>
<queryset>
	<rdbms><type>postgresql</type><version>7.4</version></rdbms>

	<fullquery name="session_finished">
		<querytext>
	UPDATE as_sessions
	SET last_mod_datetime = NOW(),
	completed_datetime = NOW()
	WHERE session_id = :as_session_id
		</querytext>
	</fullquery>

</queryset>
