<?xml version="1.0"?>
<queryset>

<fullquery name="subject">
      <querytext>
	select subject_id from as_sessions where session_id=(select session_id from as_actions_log where action_log_id=:action_id)
	
      </querytext>
</fullquery>
</queryset>