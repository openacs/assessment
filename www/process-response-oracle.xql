<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="session_finished">
		<querytext>
	UPDATE as_sessions
	SET last_mod_datetime = sysdate,
	completed_datetime = sysdate
	WHERE session_id = :as_session_id
		</querytext>
	</fullquery>

</queryset>
