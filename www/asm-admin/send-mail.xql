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

</queryset>
