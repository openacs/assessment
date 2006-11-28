<?xml version="1.0"?>
<queryset>

 <fullquery name="toggle_publish">
    <querytext>
        update cr_items set publish_status = (case when publish_status is null or publish_status <> 'live' then 'live' else null end) where item_id=:assessment_id        
    </querytext>
 </fullquery>
</queryset>