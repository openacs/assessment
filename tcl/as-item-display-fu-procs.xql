<?xml version="1.0"?>
<queryset>

<fullquery name="as::item_display_f::edit.display_item_id">
      <querytext>

	select item_id
	from cr_revisions
	where revision_id = :as_item_display_id

      </querytext>
</fullquery>

<fullquery name="as::item_display_f::copy.display_item_data">
      <querytext>

	select i.html_display_options, i.abs_size, i.box_orientation
	from cr_revisions cr, as_item_display_f i
	where cr.revision_id = :type_id
	and i.as_item_display_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::item_display_f::data_not_cached.display_item_data">
      <querytext>

	select html_display_options, abs_size, box_orientation
	from as_item_display_f
	where as_item_display_id = :type_id

      </querytext>
</fullquery>

<fullquery name="as::item_display_f::view.file_id">
      <querytext>
	select file_id 
	from as_item_data 
	where as_item_id=:item_id 
	and session_id=:session_id 
	and section_id=:section_id
      </querytext>
</fullquery>


</queryset>
