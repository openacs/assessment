<?xml version="1.0"?>
<queryset>

<fullquery name="get_choices">
      <querytext>

    select c.choice_id, r.title, c.correct_answer_p
    from as_item_choices c, cr_revisions r
    where r.revision_id = c.choice_id
    and c.mc_id = :mc_id
    order by c.sort_order

      </querytext>
</fullquery>

<fullquery name="update_choice_data">
      <querytext>

		update as_item_choices
		set feedback_text = :feedback_text,
		    selected_p = :selected_p,
		    percent_score = :percent_score,
		    fixed_position = :fixed_position,
		    text_value = :answer_value,
		    content_value = :content_rev_id
		where choice_id = :choice_id

      </querytext>
</fullquery>

</queryset>
