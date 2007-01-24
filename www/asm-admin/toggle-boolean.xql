<?xml version="1.0"?>
<queryset>

 <fullquery name="toggle_boolean">
    <querytext>
        update as_assessments 
           set $param = (case when $param is null or $param <> 't' then 't' else 'f' end) 
         where assessment_id=:revision_id        
    </querytext>
 </fullquery>
</queryset>
