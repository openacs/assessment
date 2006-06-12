<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!-- oacs-5-2/packages/assessment/www/asm-admin/add-edit-section-check.xql -->
<!-- @author Deds Castillo (deds@i-manila.com.ph) -->
<!-- @creation-date 2005-07-26 -->
<!-- @arch-tag: 985f76f4-da4d-4a3b-89e2-1c8f8e71ecc5 -->
<!-- @cvs-id $Id$ -->

<queryset>

  <fullquery name="get_check_properties">
    <querytext>
      select * 
      from as_inter_item_checks 
      where inter_item_check_id = :inter_item_check_id
    </querytext>
  </fullquery>
  
  <fullquery name="update_check">
    <querytext>
      update as_inter_item_checks 
      set name = :name,
          section_id_from = :section_id_from,
          action_p = :action_p,
          postcheck_p = :postcheck_p,
          check_sql = :check_sql 
      where inter_item_check_id = :inter_item_check_id
    </querytext>
  </fullquery>

</queryset>
