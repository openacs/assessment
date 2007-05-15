<?xml version="1.0"?>
<queryset>
    <fullquery name="get_sessions">
        <querytext>
            select session_id, creation_datetime, completed_datetime 
            from as_sessions, cr_revisions 
            where item_id=:assessment_id 
            and assessment_id=revision_id 
            and subject_id=:subject_id
        </querytext>
    </fullquery>

    <fullquery name="count_sessions">
        <querytext>
            select count(*) 
            from as_sessions, cr_revisions
            where item_id=:assessment_id
            and assessment_id=revision_id
            and subject_id=:subject_id
        </querytext>
    </fullquery>

</queryset>