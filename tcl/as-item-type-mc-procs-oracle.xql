<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="as::item_type_mc::render.get_sorted_choices">
      <querytext>

	select r.title, c.choice_id, r2.revision_id as content_rev_id,
	       r2.title as content_filename, i.content_type
	from as_session_choices sc, cr_revisions r, as_item_choices c,
	     cr_revisions r2, cr_items i
	where r2.revision_id(+) = c.content_value
	and i.item_id(+) = r2.item_id
	and sc.session_id = :session_id
	and sc.section_id = :section_id
	and sc.as_item_id = :as_item_id
	and r.revision_id = sc.choice_id
	and c.choice_id = sc.choice_id
	order by sc.sort_order

      </querytext>
</fullquery>

<fullquery name="as::item_type_mc::render.get_sorted_choices_with_feedback">
      <querytext>

	select r.title, c.choice_id, c.correct_answer_p, c.feedback_text,
	       r2.revision_id as content_rev_id, r2.title as content_filename,
	       i.content_type
	from as_session_choices sc, cr_revisions r, as_item_choices c,
	     cr_revisions r2, cr_items i
	where r2.revision_id(+) = c.content_value
	and i.item_id(+) = r2.item_id
	and sc.session_id = :session_id
	and sc.section_id = :section_id
	and sc.as_item_id = :as_item_id
	and r.revision_id = sc.choice_id
	and c.choice_id = sc.choice_id
	order by sc.sort_order

      </querytext>
</fullquery>

<fullquery name="as::item_type_mc::render.choices">
      <querytext>

	select c.choice_id, r.title, c.correct_answer_p, c.selected_p, c.fixed_position,
	       r2.revision_id as content_rev_id, r2.title as content_filename,
	       i.content_type
	from cr_revisions r, as_item_choices c, cr_revisions r2, cr_items i
	where r2.revision_id(+) = c.content_value
	and i.item_id(+) = r2.item_id
	and c.mc_id = :type_id
	and r.revision_id = c.choice_id
	order by c.sort_order

      </querytext>
</fullquery>

<fullquery name="as::item_type_mc::choices_swap.swap_choices">
      <querytext>
update as_item_choices
set sort_order = (case when sort_order = :sort_order then :next_sort_order when sort_order = :next_sort_order then :sort_order end)
where mc_id = :new_mc_id
and sort_order in (:sort_order, :next_sort_order)
      </querytext>
</fullquery>

</queryset>
