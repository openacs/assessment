<?xml version="1.0"?>
<queryset>

<fullquery name="existing_choices">
      <querytext>

    select r.title, c.choice_id, c.correct_answer_p
    from as_item_choices c, cr_revisions r, as_item_rels i
    where r.revision_id = c.choice_id
    and c.mc_id = i.target_rev_id
    and i.item_rev_id = :as_item_id
    and i.rel_type = 'as_item_type_rel'
    order by c.sort_order

      </querytext>
</fullquery>

<fullquery name="item_type_data">
<querytext>

	select r.title, i.increasing_p, i.allow_negative_p, i.num_correct_answers,
	       i.num_answers
	from cr_revisions r, as_item_rels ir, as_item_type_mc i
	where r.revision_id = i.as_item_type_id
	and i.as_item_type_id = ir.target_rev_id
	and ir.item_rev_id = :as_item_id
	and ir.rel_type = 'as_item_type_rel'

</querytext>
</fullquery>

<fullquery name="item_type_id">
      <querytext>

	select target_rev_id
	from as_item_rels
	where item_rev_id = :new_item_id
	and rel_type = 'as_item_type_rel'

      </querytext>
</fullquery>

<fullquery name="update_section_in_assessment">
      <querytext>

		update as_assessment_section_map
		set section_id = :new_section_id
		where assessment_id = :new_assessment_rev_id
		and section_id = :section_id

      </querytext>
</fullquery>

<fullquery name="update_item_in_section">
      <querytext>

		update as_item_section_map
		set as_item_id = :new_item_id
		where section_id = :new_section_id
		and as_item_id = :as_item_id

      </querytext>
</fullquery>

<fullquery name="update_item_type">
      <querytext>

		update as_item_rels
		set target_rev_id = :new_item_type_id
		where item_rev_id = :new_item_id
		and rel_type = 'as_item_type_rel'

      </querytext>
</fullquery>

<fullquery name="update_title">
      <querytext>

		    update cr_revisions
		    set title = :title
		    where revision_id = :new_choice_id

      </querytext>
</fullquery>

<fullquery name="update_correct_and_sort_order">
      <querytext>

		    update as_item_choices
		    set correct_answer_p = :correct_answer_p,
		        sort_order = :count
		    where choice_id = :new_choice_id

      </querytext>
</fullquery>

</queryset>
