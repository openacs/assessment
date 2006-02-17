<?xml version="1.0"?>
<queryset>

<fullquery name="as::item_type_sa::edit.type_item_id">
      <querytext>

	select item_id
	from cr_revisions
	where revision_id = :as_item_type_id

      </querytext>
</fullquery>

<fullquery name="as::item_type_sa::copy.item_type_data">
      <querytext>

	select cr.title, i.increasing_p, i.allow_negative_p
	from cr_revisions cr, as_item_type_sa i
	where cr.revision_id = :type_id
	and i.as_item_type_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::item_type_sa::results.get_results">
      <querytext>

	select d.session_id, d.text_answer
	from as_item_data d, as_session_item_map m, cr_revisions ri, cr_revisions rs
	where d.session_id in ([join $sessions ,])
	and d.as_item_id = ri.revision_id
	and ri.item_id = $as_item_item_id
	and d.section_id = rs.revision_id
	and rs.item_id = $section_item_id
	and m.session_id = d.session_id
	and m.item_data_id = d.item_data_id

      </querytext>
</fullquery>

</queryset>
