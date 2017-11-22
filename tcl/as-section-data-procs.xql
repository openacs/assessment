<?xml version="1.0"?>
<queryset>

  <fullquery name="as::section_data::new.section_data_exists">
    <querytext>
      select 1
      from as_section_data
      where session_id = :session_id
      and section_id = :section_id
    </querytext>
  </fullquery>

  <fullquery name="as::section_data::new.update_creation_time">
    <querytext>
      update as_section_data
      set creation_datetime = current_timestamp
      where session_id = :session_id
      and section_id = :section_id
    </querytext>
  </fullquery>

</queryset>
