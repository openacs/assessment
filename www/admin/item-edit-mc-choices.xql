<?xml version="1.0"?>
<queryset>

<fullquery name="update_choice_data">
      <querytext>

		update as_item_choices
		set feedback_text = :feedback_text,
		    selected_p = :selected_p,
		    percent_score = :percent_score,
		    fixed_position = :fixed_position,
		    text_value = :answer_value
		where choice_id = :choice_id

      </querytext>
</fullquery>

<fullquery name="update_choice_content">
      <querytext>

		update as_item_choices
		set content_value = :content_rev_id
		where choice_id = :choice_id

      </querytext>
</fullquery>

<fullquery name="delete_choice_content">
      <querytext>

		update as_item_choices
		set content_value = null
		where choice_id = :choice_id

      </querytext>
</fullquery>

</queryset>
