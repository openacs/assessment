<?xml version="1.0"?>

<queryset>
  
  <rdbms>
    <type>oracle</type>
    <version>8.1.7</version>
  </rdbms>
  
  <fullquery name="as::item_data::new.update_clobs">
    <querytext>
      update as_item_data
      set clob_answer=empty_clob()
      where item_data_id=:as_item_data_id
      returning clob_answer into :1
    </querytext>
  </fullquery>

</queryset>
