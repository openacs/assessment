<?xml version="1.0"?>
<queryset>

<fullquery name="as::item_display_sb::edit.display_item_id">
      <querytext>

	select item_id
	from cr_revisions
	where revision_id = :as_item_display_id

      </querytext>
</fullquery>

<fullquery name="as::item_display_sb::copy.display_item_data">
      <querytext>

	select i.html_display_options, i.multiple_p, i.choice_label_orientation,
	       i.sort_order_type, i.item_answer_alignment
	from cr_revisions cr, as_item_display_sb i
	where cr.revision_id = :type_id
	and i.as_item_display_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::item_display_sb::data_not_cached.display_item_data">
      <querytext>

	select html_display_options, multiple_p, choice_label_orientation,
	       sort_order_type, item_answer_alignment
	from as_item_display_sb
	where as_item_display_id = :type_id

      </querytext>
</fullquery>

</queryset>
