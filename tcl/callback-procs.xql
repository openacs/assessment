<?xml version="1.0"?>
<queryset>

<fullquery name="callback::user::registration::impl::asm_url.package_id">
<querytext>
  select package_id from cr_folders
  where folder_id = (select context_id from acs_objects where object_id=:assessment_id)
</querytext>
</fullquery>

</queryset>
