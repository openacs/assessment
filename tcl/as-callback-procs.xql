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
   
    <fullquery name="callback::datamanager::move_assessment::impl::datamanager.get_new_parent_id">
    <querytext>
    SELECT crf.folder_id as new_parent_id
    FROM dotlrn_applets as da,
         dotlrn_community_applets as dca,
         cr_folders as crf
    WHERE da.applet_key='dotlrn_assessment'
          and dca.applet_id=da.applet_id
          and dca.community_id=:selected_community
          and crf.package_id=dca.package_id;
    </querytext>
    </fullquery>
    
    <fullquery name="callback::datamanager::move_assessment::impl::datamanager.update_as_cr_items">
    <querytext>
        update cr_items
        set parent_id = :new_parent_id
        where item_id=(select context_id from acs_objects where object_id=:object_id);
    </querytext>
    </fullquery>

    <fullquery name="callback::datamanager::move_assessment::impl::datamanager.update_as_it_acs_objects1">
    <querytext>
        update acs_objects
        set context_id = :new_parent_id               
        where object_id = (select context_id from acs_objects where object_id=:object_id)
    </querytext>
    </fullquery>

    <fullquery name="callback::datamanager::move_assessment::impl::datamanager.get_new_package_id">
    <querytext>
    SELECT dca.package_id 
    FROM dotlrn_community_applets as dca, 
         dotlrn_applets as da 
    WHERE da.applet_key='dotlrn_assessment' 
          and dca.applet_id=da.applet_id 
          and dca.community_id=:selected_community
    </querytext>
    </fullquery>
    
    <fullquery name="callback::datamanager::move_assessment::impl::datamanager.update_as_it_acs_objects2">
    <querytext>
        update acs_objects
        set package_id = :package_id        
        where object_id = (select context_id from acs_objects where object_id=:object_id)
    </querytext>
    </fullquery>

    <fullquery name="callback::datamanager::move_assessment::impl::datamanager.update_as_as_acs_objects">
    <querytext>
        update acs_objects
        set package_id =:package_id
        where object_id in (select object_id 
                            from acs_objects 
                            where context_id=
                                (select context_id 
                                 from acs_objects 
                                 where object_id=:object_id)) 
    </querytext>
    </fullquery>

    <fullquery name="callback::datamanager::copy_assessment::impl::datamanager.get_assessment_data">
    <querytext>
    SELECT cri.name,
           ao.title,
           ao.creation_user as creator_id,
           crr.description,
           ass.instructions,
           ass.run_mode,
           ass.anonymous_p,
           ass.secure_access_p,
           ass.reuse_responses_p,
           ass.show_item_name_p,
           ass.random_p,
           ass.entry_page,
           ass.exit_page,
           ass.consent_page,
           ass.return_url,
           ass.start_time,
           ass.end_time,
           ass.number_tries,
           ass.wait_between_tries,
           ass.time_for_response,
           ass.ip_mask,
           ass.password,
           ass.show_feedback,
           ass.section_navigation,
           ass.survey_p,
           ass.type                     
    FROM acs_objects as ao,
         cr_items as cri,
         cr_revisions as crr,
         as_assessments as ass
    WHERE ao.object_id=ass.assessment_id 
          and crr.revision_id=ass.assessment_id 
          and cri.item_id=crr.item_id
          and ass.assessment_id=:object_id 
    </querytext>
    </fullquery>


<fullquery name="callback::datamanager::copy_assessment::impl::datamanager.get_assessment_package_id">
<querytext>
    SELECT b.object_id as package_id 
    FROM acs_objects as a,acs_objects as b  
    WHERE a.context_id=:selected_community and a.object_type='apm_package' and a.object_id=b.context_id and b.title='Assessment';
</querytext>
</fullquery>

<fullquery name="callback::datamanager::copy_assessment::impl::datamanager.get_sections_id_list">
<querytext>
    SELECT section_id 
    FROM as_assessment_section_map  
    WHERE assessment_id=:object_id
</querytext>
</fullquery>

<fullquery name="callback::datamanager::copy_assessment::impl::datamanager.get_section_data">
<querytext>
    SELECT max_time_to_complete,
           sort_order,
           points
    FROM as_assessment_section_map  
    WHERE section_id=:section_id and assessment_id=:object_id
</querytext>
</fullquery>

 <fullquery name="callback::datamanager::copy_assessment::impl::datamanager.map_ass_sections">
<querytext>
   INSERT INTO  as_assessment_section_map(assessment_id, section_id, max_time_to_complete, sort_order, points)
   VALUES (:new_assessment_id,:section_id,:max_time_to_complete,:sort_order,:points)
</querytext>
</fullquery>



    <fullquery name="callback::datamanager::delete_assessment::impl::datamanager.del_update_as_cr_items">
    <querytext>
        update cr_items
        set parent_id = :trash_id
        where item_id=(select context_id from acs_objects where object_id=:object_id);
    </querytext>
    </fullquery>

    <fullquery name="callback::datamanager::delete_assessment::impl::datamanager.del_update_as_it_acs_objects">
    <querytext>
        update acs_objects
        set context_id = :trash_id, package_id = :trash_package_id               
        where object_id = (select context_id from acs_objects where object_id=:object_id)
    </querytext>
    </fullquery>

<!--
    <fullquery name="callback::datamanager::delete_assessment::impl::datamanager.del_update_as_it_acs_objects2">
    <querytext>
        update acs_objects
        set package_id = :trash_package_id
        where object_id = (select context_id from acs_objects where object_id=:object_id)
    </querytext>
    </fullquery>
-->

    
    <fullquery name="callback::datamanager::delete_assessment::impl::datamanager.del_update_as_as_acs_objects">
    <querytext>
        update acs_objects
        set package_id =:trash_package_id
        where object_id in (select object_id from acs_objects where context_id=(select context_id from acs_objects where object_id=:object_id)) 
    </querytext>
    </fullquery>

   
 </queryset>
