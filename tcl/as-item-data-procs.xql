<?xml version="1.0"?>
<queryset>

<fullquery name="as::item_data::new.save_choice_answer">
      <querytext>

	insert into as_item_data_choices (item_data_id, choice_id)
	values (:as_item_data_id, :choice_id)

      </querytext>
</fullquery>

<fullquery name="as::item_data::get.last_session">
      <querytext>

	select max(session_id) as session_id
	from as_item_data
	where subject_id = :subject_id
	and as_item_id = :as_item_id

      </querytext>
</fullquery>

<fullquery name="as::item_data::get.response">
      <querytext>

	select item_data_id, boolean_answer, clob_answer, numeric_answer,
	       integer_answer, text_answer, timestamp_answer, content_answer,
	       points
	from as_item_data
	where session_id = :session_id
	and subject_id = :subject_id
	and as_item_id = :as_item_id

      </querytext>
</fullquery>

<fullquery name="as::item_data::get.mc_response">
      <querytext>

	select choice_id
	from as_item_data_choices
	where item_data_id = :item_data_id

      </querytext>
</fullquery>

</queryset>
