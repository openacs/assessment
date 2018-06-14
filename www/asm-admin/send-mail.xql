<?xml version="1.0"?>

<queryset>

    <fullquery name="select_sender_info">
        <querytext>
            select parties.email as sender_email,
                   persons.first_names as sender_first_names,
                   persons.last_name as sender_last_name
            from parties,
                 persons
            where parties.party_id = :sender_id
            and persons.person_id = :sender_id
        </querytext>
    </fullquery>

    <fullquery name="n_responses">
	<querytext>
		select count(*)
		from as_sessions s, cr_revisions r
		where s.assessment_id = r.revision_id
		and s.completed_datetime is not null
		and r.item_id = :assessment_id
	</querytext>
    </fullquery>

    <partialquery name="responded">
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
            parties.party_id = users.user_id                 
            and parties.party_id = acs_objects.object_id
	    and parties.party_id in (
		select s.subject_id
		from as_sessions s, cr_revisions r
		where s.assessment_id = r.revision_id
		and s.completed_datetime is not null
		and r.item_id = :assessment_id)
	</querytext>
    </partialquery>
    
    <partialquery name="list_of_user_ids">
	<querytext>
 	  select parties.email
            from parties
            where parties.party_id in ([template::util::tcl_to_sql_list $user_ids])
	</querytext>
    </partialquery>    

</queryset>
