<?xml version="1.0"?>
<queryset>

<fullquery name="assessment_title">
      <querytext>

	select title as assessment_title
	from cr_revisions
	where revision_id = :assessment_rev_id

      </querytext>
</fullquery>

<fullquery name="remove_assessment">
      <querytext>

	update cr_items
	set latest_revision = null
	where item_id = :assessment_id

      </querytext>
</fullquery>

</queryset>
