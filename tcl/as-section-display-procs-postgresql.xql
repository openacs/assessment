<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN"
"http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/assessment/tcl/as-section-display-procs-postgresql.xql -->
<!-- -->
<!-- @author Dave Bauer (dave@thedesignexperience.org) -->
<!-- @creation-date 2006-05-18 -->
<!-- @cvs-id $Id$ -->
<queryset>
  
  <rdbms>
    <type>postgresql</type>
    <version>7.4</version>
  </rdbms>
  
  <fullquery name="as::section_display::new.update_clobs">
    <querytext>
      update as_section_display_types
      set adp_chunk=:adp_chunk
      where display_type_id=:display_id
    </querytext>
  </fullquery>

  <fullquery name="as::section_display::edit.update_clobs">
    <querytext>
      update as_section_display_types
      set adp_chunk=:adp_chunk
      where display_type_id=:display_id
    </querytext>

  </fullquery>  
  
</queryset>