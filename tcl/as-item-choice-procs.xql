<?xml version="1.0"?>
<queryset>

<fullquery name="as::item_choice::new_revision.choice_data">
      <querytext>

	select r.title, c.data_type, c.numeric_value, c.text_value, c.boolean_value,
	       c.content_value, c.feedback_text, c.selected_p, c.correct_answer_p,
	       c.sort_order, c.percent_score, c.fixed_position, r.item_id as item_choice_id
	from cr_revisions r, as_item_choices c
	where r.revision_id = :choice_id
	and c.choice_id = r.revision_id

      </querytext>
</fullquery>

<fullquery name="as::item_choice::copy.choice_data">
      <querytext>

	select r.title, c.data_type, c.numeric_value, c.text_value, c.boolean_value,
	       c.content_value, c.feedback_text, c.selected_p, c.correct_answer_p,
	       c.sort_order, c.percent_score, c.fixed_position, r.item_id as choice_item_id
	from cr_revisions r, as_item_choices c
	where r.revision_id = :choice_id
	and c.choice_id = r.revision_id

      </querytext>
</fullquery>

</queryset>
