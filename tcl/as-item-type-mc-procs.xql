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

<fullquery name="as::item_type_mc::copy.get_choices">
      <querytext>

	    select choice_id
	    from as_item_choices
	    where mc_id = :type_id

      </querytext>
</fullquery>

</queryset>
