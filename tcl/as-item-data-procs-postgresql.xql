<?xml version="1.0"?>

<queryset>
  
  <rdbms>
    <type>postgresql</type>
    <version>7.4</version>
  </rdbms>
  
  <fullquery name="as::item_data::new.update_clobs">
    <querytext>
      update as_item_data
      set clob_answer=:clob_answer
      where item_data_id=:as_item_data_id
      </querytext>
  </fullquery>

</queryset>
