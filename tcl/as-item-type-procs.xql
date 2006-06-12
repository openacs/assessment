<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN"
"http://www.thecodemill.biz/repository/xql.dtd">
<!--  -->
<!-- @author Dave Bauer (dave@thedesignexperience.org) -->
<!-- @creation-date 2005-05-15 -->
<!-- @arch-tag: a1a6c3d3-a627-4211-beae-e26822470948 -->
<!-- @cvs-id $Id$ -->

<queryset>
  <fullquery name="as_item_type::get_item_types.item_types">
      <querytext>

      select distinct item_type
      from as_item_types_map

      </querytext>
  </fullquery>

  
  <fullquery name="as_item_type::get_display_types.display_types">
    <querytext>
      
      select display_type
      from as_item_types_map
      where item_type = :item_type
      
    </querytext>
  </fullquery>

</queryset>