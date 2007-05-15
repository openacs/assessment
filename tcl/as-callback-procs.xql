<?xml version="1.0"?>
  <queryset>
    
    <fullquery name="callback::merge::MergeShowUserInfo::impl::as.sel_sessions">
      <querytext>
	select session_id 
	from as_sessions
	where staff_id = :user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::merge::MergeShowUserInfo::impl::as.sel_sessions2">
      <querytext>
	select session_id
	from as_sessions
	where subject_id = :user_id
      </querytext>
    </fullquery>
    
    <fullquery name="callback::merge::MergeShowUserInfo::impl::as.sel_sections">
      <querytext>
	select section_data_id
	from as_section_data
	where subject_id = :user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::merge::MergeShowUserInfo::impl::as.sel_sections2">
      <querytext>
	select section_data_id
	from as_section_data
	where staff_id = :user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::merge::MergeShowUserInfo::impl::as.sel_items">
      <querytext>
	select item_data_id
	from as_item_data
	where subject_id = :user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::merge::MergeShowUserInfo::impl::as.sel_items2">
      <querytext>
	select item_data_id 
	from as_item_data
	where staff_id = :user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::merge::MergePackageUser::impl::as.upd_from_sessions">
      <querytext>
	update as_sessions
	set staff_id = :to_user_id
	where staff_id = :from_user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::merge::MergePackageUser::impl::as.upd_from_sessions2">
      <querytext>
	update as_sessions
	set subject_id = :to_user_id
	where subject_id = :from_user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::merge::MergePackageUser::impl::as.upd_from_sections">
      <querytext>
	update as_section_data
	set subject_id = :to_user_id
	where subject_id = :from_user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::merge::MergePackageUser::impl::as.upd_from_sections2">
      <querytext>
	update as_section_data
	set staff_id = :to_user_id
	where staff_id = :from_user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::merge::MergePackageUser::impl::as.upd_from_items">
      <querytext>
	update as_item_data
	set subject_id = :to_user_id
	where subject_id = :from_user_id
      </querytext>
    </fullquery>

    <fullquery name="callback::merge::MergePackageUser::impl::as.upd_from_items2">
      <querytext>
	update as_item_data
	set staff_id = :to_user_id
	where staff_id = :from_user_id
      </querytext>
    </fullquery>

  </queryset>