<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_choices">
      <querytext>

    select c.choice_id, r.title, c.correct_answer_p, c.feedback_text,
           c.selected_p, c.percent_score, c.fixed_position, c.sort_order,
	   c.text_value, c.content_value, r2.title as content_filename,
	   r2.title || ' (' || r2.content_length || ' bytes)' as content_name
    from cr_revisions r, as_item_choices c, cr_revisions r2
    where c.content_value = r2.revision_id(+)
    and r.revision_id = c.choice_id
    and c.mc_id = :as_item_type_id
    order by c.sort_order

      </querytext>
</fullquery>

</queryset>
