<?xml version="1.0"?>
<queryset>

<fullquery name="as::item_type_mc::edit.type_item_id">
      <querytext>

	select item_id
	from cr_revisions
	where revision_id = :as_item_type_id

      </querytext>
</fullquery>

<fullquery name="as::item_type_mc::copy.item_type_data">
      <querytext>

	select cr.title, i.increasing_p, i.allow_negative_p, i.num_correct_answers,
	       i.num_answers
	from cr_revisions cr, as_item_type_mc i
	where cr.revision_id = :type_id
	and i.as_item_type_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::item_type_mc::new_revision.item_type_data">
      <querytext>

	select cr.item_id as type_item_id, cr.title, i.increasing_p,
	       i.allow_negative_p, i.num_correct_answers, i.num_answers
	from cr_revisions cr, as_item_type_mc i
	where cr.revision_id = :as_item_type_id
	and i.as_item_type_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::item_type_mc::new_revision.get_choices">
      <querytext>

	    select choice_id
	    from as_item_choices
	    where mc_id = :type_id

      </querytext>
</fullquery>

<fullquery name="as::item_type_mc::copy.get_choices">
      <querytext>

	    select choice_id
	    from as_item_choices
	    where mc_id = :type_id

      </querytext>
</fullquery>

<fullquery name="as::item_type_mc::render.get_sorted_choices">
      <querytext>

	select r.title, c.choice_id
	from as_session_choices c, cr_revisions r
	where c.session_id = :session_id
	and c.section_id = :section_id
	and c.as_item_id = :as_item_id
	and r.revision_id = c.choice_id

      </querytext>
</fullquery>

<fullquery name="as::item_type_mc::render.item_type_data">
      <querytext>

	select num_correct_answers, num_answers
	from as_item_type_mc
	where as_item_type_id = :type_id

      </querytext>
</fullquery>

<fullquery name="as::item_type_mc::render.choices">
      <querytext>

	    select c.choice_id, r.title, c.correct_answer_p, c.selected_p
	    from as_item_choices c, cr_revisions r
	    where c.mc_id = :type_id
	    and r.revision_id = c.choice_id
	    order by c.sort_order

      </querytext>
</fullquery>

<fullquery name="as::item_type_mc::render.save_order">
	<querytext>

	    insert into as_session_choices (session_id, section_id, as_item_id, choice_id, sort_order)
	    values (:session_id, :section_id, :as_item_id, :choice_id, :count)

	</querytext>
</fullquery>
	
<fullquery name="as::item_type_mc::process.item_type_data">
      <querytext>

	select increasing_p, allow_negative_p
	from as_item_type_mc
	where as_item_type_id = :type_id

      </querytext>
</fullquery>

<fullquery name="as::item_type_mc::process.check_choices">
      <querytext>

	    select choice_id, correct_answer_p, percent_score
	    from as_item_choices
	    where mc_id = :type_id

      </querytext>
</fullquery>

</queryset>
