<?xml version="1.0"?>
<queryset>

<fullquery name="get_assessment_id">
<querytext>
	select max(revision_id) from cr_revisions where item_id=:d_assessment
</querytext>
</fullquery>

</queryset>
