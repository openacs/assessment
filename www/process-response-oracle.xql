<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="session_updated">
		<querytext>
	UPDATE as_sessions
	SET last_mod_datetime = sysdate
	WHERE session_id = :session_id
		</querytext>
	</fullquery>

	<fullquery name="session_finished">
		<querytext>
	UPDATE as_sessions
	SET completed_datetime = sysdate
	WHERE session_id = :session_id
		</querytext>
	</fullquery>

</queryset>
