<master>
<property name="doc(title)">@title;literal@</property>
<property name="context">@context;literal@</property>

<include src="/packages/assessment/lib/section-links" assessment_id="@assessment_id;literal@" tab="@tab;literal@">

<if @sections:rowcount@ eq 0><br><a class="button" href="section-form?assessment_id=@assessment_id@">#assessment.add_new_section#</a></if>

<multiple name="sections">
<h3><a name="@sections.sort_order@">#assessment.Section_Number#: @sections.title@</a></h3>
  <a class="button" href="@sections.section_form_edit_url@">#assessment.Edit#</a> 

  <a class="button" href="@sections.section_form_add_url@">#assessment.add_new_section#</a>
  <a class="button" href="@sections.catalog_section_url@">#assessment.Search_Section#</a>
  <if @sections.display_type_id@ not nil><a class="button" href="@sections.section_display_form_url@">#assessment.edit_section_display#</a></if>
  <a class="button" href="@sections.section_preview_url@">#assessment.section_preview#</a>

  <if @sections.sort_order@ lt @max_sort_order@>
  <a  href="@sections.section_swap_down_url@"><img src="/resources/assessment/down.gif" style="border: 0;" alt="#assessment.Move_Down#"></a>
  </if>
  <if @sections.sort_order@ gt 1>
  <a href="@sections.section_swap_up_url@"><img src="/resources/assessment/up.gif" style="border: 0;" alt="#assessment.Move_Up#"></a>
  </if>

  <a href="@sections.section_delete_url@"><img src="/resources/acs-subsite/Delete16.gif" style="border: 0;" alt="#assessment.remove_section#"></a>
  <if @sections.max_time_to_complete@ not nil> (#assessment.max_time# @sections.max_time_to_complete@) </if>
  (@sections.points@ #assessment.points#)

<if @admin_trigger_p;literal@ true>
  <a class="button" href="@sections.checks_admin_url@">#assessment.admin_triggers#</a>
  <a class="button" href="@sections.add_edit_section_check_url@">#assessment.add_section_trigger#</a>
</if>

  <img src="/resources/assessment/spacer.gif" style="border: 0;" alt="" width="10">
 <fieldset> 
   <legend>#assessment.Items#</legend>
   <include src="/packages/assessment/lib/section-items" assessment_id="@assessment_id;literal@" section_id="@sections.section_id;literal@" admin_trigger_p="@admin_trigger_p;literal@">
 </fieldset>
</multiple>

