<?xml version="1.0"?>
<queryset>

<fullquery name="get_choices">
      <querytext>

    select c.choice_id, r.title, c.correct_answer_p, c.feedback_text,
           c.selected_p, c.percent_score
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
		    percent_score = :percent_score
		where choice_id = :choice_id

      </querytext>
</fullquery>

</queryset>
