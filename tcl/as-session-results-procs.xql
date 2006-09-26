<?xml version="1.0"?>
<queryset>

<fullquery name="as::session_results::new.result_exists">
      <querytext>
	select cr.item_id as result_item_id
	from cr_revisions cr, as_session_results sr,
	cr_items ci
	where sr.target_id = :target_id
	and sr.result_id = cr.revision_id
	and cr.revision_id = ci.latest_revision
      </querytext>
</fullquery>

</queryset>
