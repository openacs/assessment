<?xml version="1.0"?>
<queryset>

<fullquery name="as::item_display_cb::edit.display_item_id">
      <querytext>

	select item_id
	from cr_revisions
	where revision_id = :as_item_display_id

      </querytext>
</fullquery>

<fullquery name="as::item_display_cb::copy.display_item_data">
      <querytext>

	select i.html_display_options, i.choice_orientation, i.choice_label_orientation,
	       i.sort_order_type, i.item_answer_alignment
	from cr_revisions cr, as_item_display_cb i
	where cr.revision_id = :type_id
	and i.as_item_display_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::item_display_cb::render.display_item_data">
      <querytext>

	select html_display_options, choice_orientation, choice_label_orientation,
	       sort_order_type, item_answer_alignment
	from as_item_display_cb
	where as_item_display_id = :type_id

      </querytext>
</fullquery>

</queryset>
