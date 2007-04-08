<?xml version="1.0"?>
<queryset>

<fullquery name="as::install::before_uninstantiate.get_package_actions">
      <querytext>
        select object_id from acs_objects 
         where context_id=:package_id 
           and object_type='as_action'
      </querytext>
</fullquery>

<fullquery name="as::install::before_uninstantiate.delete_action">
      <querytext>
        select as_action__delete(:object_id)
      </querytext>
</fullquery>

<fullquery name="as::install::before_uninstantiate.get_folders">
      <querytext>
        select folder_id from cr_folders where package_id = :package_id
      </querytext>
</fullquery>

</queryset>
