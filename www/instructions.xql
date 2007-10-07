<?xml version="1.0"?>
<queryset>

<fullquery name="count_completed_sessions">
    <querytext>
        select count(*)
        from as_sessions,
        cr_revisions
        where item_id = :assessment_id
        and assessment_id = revision_id
        and subject_id = :user_id
        and completed_datetime is not null
    </querytext>
</fullquery>

</queryset>