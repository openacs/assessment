<?xml version="1.0"?>
<queryset>

<fullquery name="section_title">
      <querytext>
      
    select title as section_title
    from cr_revisions
    where revision_id = :section_id
    
      </querytext>
</fullquery>

<fullquery name="item_types">
      <querytext>

    select distinct item_type
    from as_item_types_map

      </querytext>
</fullquery>

</queryset>
