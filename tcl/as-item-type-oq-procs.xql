<?xml version="1.0"?>
<queryset>

<fullquery name="as::item_type_oq::edit.type_item_id">
      <querytext>

	select item_id
	from cr_revisions
	where revision_id = :as_item_type_id

      </querytext>
</fullquery>

<fullquery name="as::item_type_oq::copy.item_type_data">
      <querytext>

	select cr.title, i.default_value, i.feedback_text
	from cr_revisions cr, as_item_type_oq i
	where cr.revision_id = :type_id
	and i.as_item_type_id = cr.revision_id

      </querytext>
</fullquery>

</queryset>
