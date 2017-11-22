<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>
		
<fullquery name="as::section::new.update_clobs">
    <querytext>
      update as_sections set instructions=:instructions
      where section_id=:as_section_id
    </querytext>
</fullquery>

<fullquery name="as::section::edit.update_clobs">
    <querytext>
      update as_sections 
	  set instructions=:instructions, feedback_text=:feedback_text
      where section_id=:new_section_id
    </querytext>
</fullquery>
  
<fullquery name="as::section::new_revision.update_clobs">
    <querytext>
      update as_sections 
	  set instructions=:instructions, feedback_text=:feedback_text
      where section_id=:new_section_id
    </querytext>
</fullquery>

</queryset>
