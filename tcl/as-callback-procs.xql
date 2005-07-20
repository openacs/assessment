<?xml version="1.0"?>
  <queryset>
    
    <fullquery name="callback::MergeShowUserInfo::impl::as.sel_sessions">
      <querytext>
	select session_id 
	from as_sessions
	where staff_id = :user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::MergeShowUserInfo::impl::as.sel_sessions2">
      <querytext>
	select session_id
	from as_sessions
	where subject_id = :user_id
      </querytext>
    </fullquery>
    
    <fullquery name="callback::MergeShowUserInfo::impl::as.sel_sections">
      <querytext>
	select section_data_id
	from as_section_data
	where subject_id = :user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::MergeShowUserInfo::impl::as.sel_sections2">
      <querytext>
	select section_data_id
	from as_section_data
	where staff_id = :user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::MergeShowUserInfo::impl::as.sel_items">
      <querytext>
	select item_data_id
	from as_item_data
	where subject_id = :user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::MergeShowUserInfo::impl::as.sel_items2">
      <querytext>
	select item_data_id 
	from as_item_data
	where staff_id = :user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::MergePackageUser::impl::as.upd_from_sessions">
      <querytext>
	update as_sessions
	set staff_id = :to_user_id
	where staff_id = :from_user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::MergePackageUser::impl::as.upd_from_sessions2">
      <querytext>
	update as_sessions
	set subject_id = :to_user_id
	where subject_id = :from_user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::MergePackageUser::impl::as.upd_from_sections">
      <querytext>
	update as_section_data
	set subject_id = :to_user_id
	where subject_id = :from_user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::MergePackageUser::impl::as.upd_from_sections2">
      <querytext>
	update as_section_data
	set staff_id = :to_user_id
	where staff_id = :from_user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::MergePackageUser::impl::as.upd_from_items">
      <querytext>
	update as_item_data
	set subject_id = :to_user_id
	where subject_id = :from_user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::MergePackageUser::impl::as.upd_from_items2">
      <querytext>
	update as_item_data
	set staff_id = :to_user_id
	where staff_id = :from_user_id
      </querytext>
    </fullquery>
    
    <fullquery name="callback::datamanager::move_assessment::impl::datamanager.update_as_cr_items">
    <querytext>
            update cr_items
        set parent_id = (select folder_id 
                        from cr_folders 
                        where package_id=
                            (select package_id 
                             from dotlrn_community_applets 
                             where applet_id=
                                (select applet_id 
                                 from dotlrn_applets 
                                 where applet_key='dotlrn_assessment') 
                             and community_id=:selected_community))
        where item_id=(select context_id from acs_objects where object_id=:object_id);

    </querytext>
    </fullquery>

    <fullquery name="callback::datamanager::move_assessment::impl::datamanager.update_as_it_acs_objects1">
    <querytext>
    update acs_objects
        set context_id =(select folder_id 
                        from cr_folders 
                        where package_id=
                            (select package_id 
                             from dotlrn_community_applets 
                             where applet_id=
                                (select applet_id 
                                 from dotlrn_applets 
                                 where applet_key='dotlrn_assessment') 
                             and community_id=:selected_community))                   
        where object_id = (select context_id from acs_objects where object_id=:object_id)

    </querytext>
    </fullquery>

    <fullquery name="callback::datamanager::move_assessment::impl::datamanager.update_as_it_acs_objects2">
    <querytext>
    update acs_objects
        set package_id = (select package_id 
                             from dotlrn_community_applets 
                             where applet_id=
                                (select applet_id 
                                 from dotlrn_applets 
                                 where applet_key='dotlrn_assessment') 
                             and community_id=:selected_community)
        where object_id = (select context_id from acs_objects where object_id=:object_id)

    </querytext>
    </fullquery>

    <fullquery name="callback::datamanager::move_assessment::impl::datamanager.update_as_as_acs_objects">
    <querytext>
    update acs_objects
        set package_id =(select package_id 
                             from dotlrn_community_applets 
                             where applet_id=
                                (select applet_id 
                                 from dotlrn_applets 
                                 where applet_key='dotlrn_assessment') 
                             and community_id=:selected_community)
        where object_id in (select object_id 
                            from acs_objects 
                            where context_id=
                                (select context_id 
                                 from acs_objects 
                                 where object_id=:object_id)) 

    </querytext>
    </fullquery>

  </queryset>
