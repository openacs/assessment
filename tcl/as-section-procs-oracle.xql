<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="as::section::new.update_clobs">
    <querytext>
      update as_sections set instructions=empty_clob()
      where section_id=:as_section_id
      returning instructions into :1
    </querytext>
</fullquery>

<fullquery name="as::section::edit.update_clobs">
    <querytext>
      update as_sections set instructions=empty_clob(),
      feedback_text=empty_clob()
      where section_id=:new_section_id
      returning instructions,feedback_text into :1, :2
    </querytext>
</fullquery>  
  
<fullquery name="as::section::new_revision.update_clobs">
    <querytext>
      update as_sections set instructions=empty_clob(),
      feedback_text=empty_clob()
      where section_id=:new_section_id
      returning instructions,feedback_text into :1, :2
    </querytext>
</fullquery>  
  
</queryset>
