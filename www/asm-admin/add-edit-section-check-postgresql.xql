<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!-- oacs-5-2/packages/assessment/www/asm-admin/add-edit-section-check-postgresql.xql -->
<!-- @author Deds Castillo (deds@i-manila.com.ph) -->
<!-- @creation-date 2005-07-26 -->
<!-- @arch-tag: ef77ce75-f6a8-4bf9-aa32-1af6fe5341e9 -->
<!-- @cvs-id $Id$ -->

<queryset>
  
  <fullquery name="new_check">
    <querytext>
      select as_inter_item_check__new (:inter_item_check_id, 
                                       :action_p, 
                                       :section_id_from, 
                                       null, 
                                       :check_sql, 
                                       :name, 
                                       :description, 
                                       :postcheck_p,
                                        null,
                                       :user_id,
                                        null,
                                       :assessment_id)	
    </querytext>
  </fullquery>
  
</queryset>
