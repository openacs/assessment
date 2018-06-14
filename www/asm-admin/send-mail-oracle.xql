<?xml version="1.0"?>
<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>


    <partialquery name="all">
	<querytext>
            select parties.email,
            decode(acs_objects.object_type,
            'user',
            (select first_names
            from persons
            where person_id = parties.party_id),
            'group',
            (select group_name
            from groups
            where group_id = parties.party_id),
            'rel_segment',
            (select segment_name
            from rel_segments
            where segment_id = parties.party_id),
            '') as first_names,
            decode(acs_objects.object_type,
            'user',
            (select last_name
            from persons
            where person_id = parties.party_id),
            '') as last_name
            from
                 parties,
                 acs_objects,
                 users
            where
            parties.party_id <> 0
            and parties.party_id = users.user_id        
            and parties.party_id = acs_objects.object_id
            and exists (select 1 from acs_object_party_privilege_map m
                        where m.object_id = $assessment_id
                        and m.party_id = parties.party_id
                        and m.privilege = 'read')
        
               
	</querytext>
    </partialquery>

    <partialquery name="not_responded">
	<querytext>
		select parties.email,
               decode(acs_objects.object_type,
                      'user',
                      (select first_names
                       from persons
                       where person_id = parties.party_id),
                      'group',
                      (select group_name
                       from groups
                       where group_id = parties.party_id),
                      'rel_segment',
                      (select segment_name
                       from rel_segments
                       where segment_id = parties.party_id),
                      '') as first_names,
               decode(acs_objects.object_type,
                      'user',
                      (select last_name
                       from persons
                       where person_id = parties.party_id),
                      '') as last_name
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
		and r.item_id = $assessment_id)
                and exists (select 1 from acs_object_party_privilege_map m
                        where m.object_id = $assessment_id
                        and m.party_id = parties.party_id
                        and m.privilege = 'read')
	</querytext>
    </partialquery>

</queryset>
