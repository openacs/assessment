<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_choices">
      <querytext>

    select c.choice_id, r.title, c.correct_answer_p, c.feedback_text,
           c.selected_p, c.percent_score, c.fixed_position, c.text_value,
	   c.content_value, r2.title as content_filename,
	   r2.title || ' (' || r2.content_length || ' bytes)' as content_name
    from cr_revisions r, as_item_choices c
    left outer join cr_revisions r2 on (c.content_value = r2.revision_id)
    where r.revision_id = c.choice_id
    and c.mc_id = :mc_id
    order by c.sort_order

      </querytext>
</fullquery>

</queryset>
