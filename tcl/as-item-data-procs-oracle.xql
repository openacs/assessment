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

  <fullquery name="as::item_data::get.response">
      <querytext>

        select * from (
	select d.item_data_id, d.boolean_answer, d.clob_answer, d.numeric_answer,
	       d.integer_answer, d.text_answer, d.timestamp_answer, d.content_answer,
	       d.points
	from as_session_item_map m, as_item_data d
	where d.session_id = :session_id
	and d.subject_id = :subject_id
	and d.as_item_id = :as_item_id
	and m.session_id = d.session_id
	and m.item_data_id = d.item_data_id

	order by d.item_data_id desc) data
	where rownum = 1
      </querytext>
  </fullquery>

</queryset>
