<?xml version="1.0"?>
<queryset>

<fullquery name="as::item_display_tb::edit.display_item_id">
      <querytext>

	select item_id
	from cr_revisions
	where revision_id = :as_item_display_id

      </querytext>
</fullquery>

<fullquery name="as::item_display_tb::copy.display_item_data">
      <querytext>

	select i.html_display_options, i.abs_size, i.item_answer_alignment
	from cr_revisions cr, as_item_display_tb i
	where cr.revision_id = :type_id
	and i.as_item_display_id = cr.revision_id

      </querytext>
</fullquery>

</queryset>
