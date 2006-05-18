<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN"
"http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/assessment/tcl/as-item-procs-oracle.xql -->
<!-- @author Dave Bauer (dave@thedesignexperience.org) -->
<!-- @creation-date 2006-05-18 -->
<!-- @cvs-id $Id$ -->
<queryset>
  
  <rdbms>
    <type>oracle</type>
    <version>8.1.7</version>
  </rdbms>
  
  <fullquery name="as::item::new.update_clobs">
    <queryset>
      update as_items
      set feedback_right=empty_clob(),
      feedback_wrong=empty_clob()
      where as_item_id=:as_item_id
      returning feedback_right, feedback_wrong into :1, :2
    </queryset>
  </fullquery>

  <fullquery name="as::item::edit.update_clobs">
    <queryset>
      update as_items
      set feedback_right=empty_clob(),
      feedback_wrong=empty_clob()
      where as_item_id=:new_item_id
      returning feedback_right, feedback_wrong into :1, :2
    </queryset>
  </fullquery>  
  
</queryset>