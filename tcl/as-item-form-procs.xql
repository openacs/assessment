<?xml version="1.0"?>
<queryset>

<fullquery name="as::item_form::add_item_to_form.item_choices_2">
	<querytext>
		select i.choice_id, cr.title, i.content_value
		from as_item_choices i, cr_revisions cr
		where i.mc_id = :mc_id
		and cr.revision_id = i.choice_id
		order by i.sort_order
	</querytext>
</fullquery>

<fullquery name="as::item_form::add_item_to_form.item_choices_3">
	<querytext>
		select i.choice_id, cr.title
		from as_item_choices i, cr_revisions cr
		where i.mc_id = :mc_id
		and cr.revision_id = i.choice_id
		order by i.sort_order
	</querytext>
</fullquery>

<fullquery name="as::item_form::add_item_to_form.item_properties">
	<querytext>
		select cr.title, i.required_p
		from as_items i, cr_revisions cr
		where i.as_item_id = :item_id
		and cr.revision_id = i.as_item_id
	</querytext>
</fullquery>

</queryset>
