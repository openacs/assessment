<?xml version="1.0"?>
<queryset>

<fullquery name="as::notification::get_url.get_package_id">
      <querytext>

	select f.package_id
	from cr_folders f, cr_items i
	where i.item_id = :object_id
	and f.folder_id = i.parent_id

      </querytext>
</fullquery>

</queryset>
