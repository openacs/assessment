<?xml version="1.0"?>
<queryset>
	<rdbms><type>postgresql</type><version>7.4</version></rdbms>

	<fullquery name="session_start">
		<querytext>
    UPDATE as_sessions
    SET creation_datetime = NOW()
    WHERE session_id = :session_id
		</querytext>
	</fullquery>

	<fullquery name="session_updated">
		<querytext>
	UPDATE as_sessions
	SET last_mod_datetime = NOW()
	WHERE session_id = :session_id
		</querytext>
	</fullquery>

	<fullquery name="session_finished">
		<querytext>
	UPDATE as_sessions
	SET completed_datetime = NOW()
	WHERE session_id = :session_id
		</querytext>
	</fullquery>

</queryset>
