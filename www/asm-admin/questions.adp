<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="/packages/assessment/lib/section-links" assessment_id="@assessment_id@" tab="@tab@">

<multiple name="sections">
<a name="@sections.sort_order@"><h3>#assessment.Section_Number#</h3>
  <a class="button" href="section-form?section_id=@sections.section_id@&assessment_id=@assessment_id@">#assessment.Edit#</a> 

  <a class=button href="section-form?assessment_id=@assessment_id@&after=@sections.sort_order@">#assessment.add_new_section#</a>
  <a class=button href="catalog-search?assessment_id=@assessment_id@&after=@sections.sort_order@">#assessment.Search_Section#</a>
  <if @sections.display_type_id@ not nil><a class=button href="section-display-form?assessment_id=@assessment_id@&section_id=@sections.section_id@&display_type_id=@sections.display_type_id@">#assessment.edit_section_display#</a></if>
  <a class=button href="section-preview?assessment_id=@assessment_id@&section_id=@sections.section_id@">#assessment.section_preview#</a>

  <if @sections.sort_order@ lt @max_sort_order@>
  <a  href="section-swap?assessment_id=@assessment_id@&sort_order=@sections.sort_order@&direction=down"><img src="/resources/assessment/down.gif" border="0" alt="#assessment.Move_Down#"></a>
  </if>
  <if @sections.sort_order@ gt 1>
  <a href="section-swap?assessment_id=@assessment_id@&sort_order=@sections.sort_order@&direction=up"><img src="/resources/assessment/up.gif" border="0" alt="#assessment.Move_Up#"></a>
  </if>

  <a href="section-delete?section_id=@sections.section_id@&assessment_id=@assessment_id@"><img src="/resources/acs-subsite/Delete16.gif" border="0" alt="#assessment.remove_section#"></a>
  <if @sections.max_time_to_complete@ not nil> (#assessment.max_time# @sections.max_time_to_complete@) </if>
  (@sections.points@ #assessment.points#)

<if @admin_trigger_p@>
  <a class=button href="checks-admin?assessment_id=@assessment_id@&section_id=@sections.section_id@">#assessment.admin_triggers#</a>
  <a class=button href="add-edit-section-check?assessment_id=@assessment_id@&section_id=@sections.section_id@">#assessment.add_section_trigger#</a>
</if>

<p>  @sections.title@ </p>
  <img src="/resources/assessment/spacer.gif" border="0" alt="" width="10">
<fieldset><legend>#assessment.Items#</legend>
  <include src="/packages/assessment/lib/section-items" assessment_id="@assessment_id@" section_id="@sections.section_id@" admin_trigger_p="@admin_trigger_p@">
</fieldset>
</multiple>

