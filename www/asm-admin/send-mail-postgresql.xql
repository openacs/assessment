<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <partialquery name="all">
	<querytext>
            select parties.email,
	       (case acs_objects.object_type
	       	     when 'user' then 
                      (select first_names
                       from persons
                       where person_id = parties.party_id)
		     when 'group' then
                      (select group_name
                       from groups
                       where group_id = parties.party_id)
		     when 'rel_segment' then
                      (select segment_name
                       from rel_segments
                       where segment_id = parties.party_id)
		     else '' end) as first_names,
	       (case acs_objects.object_type
	       	     when 'user' then
                      (select last_name
                       from persons
                       where person_id = parties.party_id)
		     else '' end) as last_name
            from
                 parties,
                 acs_objects,
                 users
            where
            parties.party_id <> 0
            and parties.party_id = users.user_id        
            and parties.party_id = acs_objects.object_id
            and parties.party_id in (select party_id from acs_permission.parties_with_object_privilege(:assessment_id, 'read'))
	</querytext>
    </partialquery>

    <partialquery name="not_responded">
	<querytext>
		select parties.email,
	       (case acs_objects.object_type
	       	     when 'user' then 
                      (select first_names
                       from persons
                       where person_id = parties.party_id)
		     when 'group' then
                      (select group_name
                       from groups
                       where group_id = parties.party_id)
		     when 'rel_segment' then
                      (select segment_name
                       from rel_segments
                       where segment_id = parties.party_id)
		     else '' end) as first_names,
	       (case acs_objects.object_type
	       	     when 'user' then
                      (select last_name
                       from persons
                       where person_id = parties.party_id)
		     else '' end) as last_name
            from 
                 parties,
                 acs_objects,
                 users 
            where
            parties.party_id <> 0
            and parties.party_id = users.user_id
            and parties.party_id = acs_objects.object_id
	    and parties.party_id not in (
		select s.subject_id
		from as_sessions s, cr_revisions r
		where s.assessment_id = r.revision_id
		and s.completed_datetime is not null
		and r.item_id = :assessment_id)
            and parties.party_id in (select party_id from acs_permission.parties_with_object_privilege(:assessment_id, 'read'))
	</querytext>
    </partialquery>
    
</queryset>
