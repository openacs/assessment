<?xml version="1.0"?>
<queryset>

 <fullquery name="toggle_type">
    <querytext>
        update as_assessments 
           set type = (case when type is null or type <> 'survey' then 'survey' else 'test' end) 
         where assessment_id=:revision_id        
    </querytext>
 </fullquery>
</queryset>