<?xml version="1.0"?>
<queryset>

<fullquery name="as::item_display_ta::edit.display_item_id">
      <querytext>

	select item_id
	from cr_revisions
	where revision_id = :as_item_display_id

      </querytext>
</fullquery>

<fullquery name="as::item_display_ta::copy.display_item_data">
      <querytext>

	select i.html_display_options, i.abs_size, i.acs_widget, i.item_answer_alignment
	from cr_revisions cr, as_item_display_ta i
	where cr.revision_id = :type_id
	and i.as_item_display_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::item_display_ta::render.display_item_data">
      <querytext>

	select html_display_options, abs_size, item_answer_alignment
	from as_item_display_ta
	where as_item_display_id = :type_id

      </querytext>
</fullquery>

</queryset>
