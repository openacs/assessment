<?xml version="1.0"?>
<!-- oacs-5-2/packages/assessment/www/asm-admin/add-edit-section-check-oracle.xql -->
<!-- @author Deds Castillo (deds@i-manila.com.ph) -->
<!-- @creation-date 2005-07-26 -->
<!-- @arch-tag: ef315c6f-3ea8-4656-9aba-3e06d5fe323e -->
<!-- @cvs-id $Id$ -->

<queryset>
  
  <rdbms>
    <type>oracle</type><version>8.1.6</version>
  </rdbms>
  
  <fullquery name="new_check">
    <querytext>
      declare begin
      :1 := as_inter_item_check.new (
      inter_item_check_id	=>     	:inter_item_check_id,
      name			=> 	:name,
      action_p		=>	:action_p,
      section_id_from 	=>	:section_id_from,
      section_id_to		=>	null,
      check_sql		=>	:check_sql,
      description		=>	:description,
      postcheck_p		=>	:postcheck_p,
      item_id			=>	null,
      assessment_id		=>	:assessment_id,
      creation_user		=>	:user_id,
      context_id		=>	null,
      object_type		=>	'as_inter_item_check',
      creation_date		=>	:date
      );
      end;
      
    </querytext>
  </fullquery>
  
</queryset>
