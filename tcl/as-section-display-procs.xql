<?xml version="1.0"?>
<queryset>

<fullquery name="as::section_display::edit.display_item_id">
      <querytext>

	select item_id
	from cr_revisions
	where revision_id = :display_type_id

      </querytext>
</fullquery>

</queryset>
