<master>
<property name="title">@p_title@</property>
<property name="context">@context;noquote@</property>

#assessment.Created_by# <a href="@creator_link@">@assessment_data.creator_name@</a>#assessment.on_creation_date#</h2>


<p>
<table class="table-display" cellpadding=2 cellspacing=0>

<tr class="odd">
	<td valign="top">#assessment.Assessment_Title#:<p>#assessment.Description#:<p>#assessment.Instructions#: </td>
	<td valign="top"> 
	<!-- <a href="assessment-preview?assessment_id=@assessment_id@">#assessment.Preview#</a> -->
	<a href="assessment-form?assessment_id=@assessment_id@">#assessment.Edit#</a>
	@assessment_data.title@ <div align=center><font color=red>@is_reg_asm_p@</font></div>
        <p><if @assessment_data.description@ nil>#assessment.None#</if><else>@assessment_data.description;noquote@</else>
        <p><if @assessment_data.instructions@ nil>#assessment.None#</if><else>@assessment_data.instructions;noquote@</else></td>
</tr>

<tr class="even"><td>#assessment.View_Responses# </td><td>
	<a href="../sessions?assessment_id=@assessment_id@">#assessment.All#</a> |
	<a href="results-users?assessment_id=@assessment_id@">#assessment.By_user#</a> |
<!--	<a href="results-summary?assessment_id=@assessment_id@">#assessment.Summary#</a> | -->
	<a href="results-export?assessment_id=@assessment_id@">#assessment.CSV_file#</a></td>
</tr>
<!--
<tr class="odd">
	<td valign="top" rowspan="8"><nobr>#assessment.Response_Options# </nobr></td>
</tr>

<tr class="odd">
	<td><if @assessment_data.anonymous_p@> #assessment.anonymous_users_allow#</if><else>#assessment.reg_users_required#</else> -
	[ <a href="assessment-form?assessment_id=@assessment_id@">
	<if @assessment_data.anonymous_p@>#assessment.make_non_anonymous#</if><else>#assessment.make_anonymous#</else></a> ]</td>
</tr>

<tr class="odd">
	<td><if @assessment_data.secure_access_p@> #assessment.secure_access_require#</if><else>#assessment.unsecure_access_allow#</else> -
	[ <a href="assessment-form?assessment_id=@assessment_id@">
	<if @assessment_data.secure_access_p@>#assessment.make_unsecure#</if><else>#assessment.make_secure#</else></a> ]</td>
</tr>

<tr class="odd">
	<td><if @assessment_data.reuse_responses_p@> #assessment.reuse_responses#</if><else>#assessment.dont_reuse_responses#</else> -
	[ <a href="assessment-form?assessment_id=@assessment_id@">
	<if @assessment_data.reuse_responses_p@>#assessment.make_not_reuse_respo#</if><else>#assessment.make_reuse_responses#</else></a> ]</td>
</tr>

<tr class="odd">
	<td><if @assessment_data.show_item_name_p@> #assessment.show_item_name#</if><else>#assessment.hide_item_name#</else> -
	[ <a href="assessment-form?assessment_id=@assessment_id@">
	<if @assessment_data.show_item_name_p@>#assessment.make_hide_item_name#</if><else>#assessment.make_show_item_name#</else></a> ]</td>
</tr>

<tr class="odd">
	<td><if @assessment_data.number_tries@ not nil> #assessment.limited_tries#</if><else>#assessment.unlimited_tries#</else> -
	[ <a href="assessment-form?assessment_id=@assessment_id@">#assessment.Edit#</a> ]</td>
</tr>

<tr class="odd">
	<td><if @assessment_data.wait_between_tries@ not nil> #assessment.time_to_wait#</if><else>#assessment.no_waiting#</else> -
	[ <a href="assessment-form?assessment_id=@assessment_id@">#assessment.Edit#</a> ]</td>
</tr>

<tr class="odd">
	<td><if @assessment_data.time_for_response@ not nil> #assessment.time_response#</if><else>#assessment.unlimited_time#</else> -
	[ <a href="assessment-form?assessment_id=@assessment_id@">#assessment.Edit#</a> ]</td>
</tr>
-->
<tr class="even"><td valign="top" rowspan="2">#assessment.Email_Options#</td><td >@notification_chunk;noquote@</td></tr>

<tr class="even"><td ><a href="send-mail?assessment_id=@assessment_id@">#assessment.Send_bulkmail#</a> #assessment.regarding_this_assess# </td></tr>
	
<tr><td></td><td >
	
<tr class="odd">
	<td>#assessment.Extreme_Actions# </td>
	<td><a href="assessment-delete?assessment_id=@assessment_id@">#assessment.Delete_this_assess#</a> #assessment.Removes_all_questio#<br>
	<a href="assessment-copy?assessment_id=@assessment_id@">#assessment.Copy_this_assess#</a> #assessment.Lets_you_use_this_a#
	<if @admin_p@ eq 1>	
	 <if @anonymous_p@ eq t>
	   <if @read_p@ eq 1>
	      <br><a href="/admin/set-reg-assessment?assessment_id=@assessment_id@">#acs-subsite.set_reg_asm#</a>
	   </if>
         </if>
        </if>
</td>
</tr>


</table>
<br>

<if @sections:rowcount@ eq 0>
<font color=red><b>#assessment.add_section_first#</b></font>
</if>

<multiple name="sections">
<h3>#assessment.Sections#</h3>

<table cellspacing=0>
<tr class="odd">
<td valign="top">@sections.rownum@. @sections.name@</td></tr>
<tr class="odd">

<td><a href="section-form?section_id=@sections.section_id@&assessment_id=@assessment_id@">#assessment.Edit#</a>

<a href="section-form?assessment_id=@assessment_id@&after=@sections.sort_order@">#assessment.add_new_section#</a>

<a href="catalog-search?assessment_id=@assessment_id@&after=@sections.sort_order@">#assessment.Search_Section#</a>

<if @sections.display_type_id@ not nil><a href="section-display-form?assessment_id=@assessment_id@&section_id=@sections.section_id@&display_type_id=@sections.display_type_id@">#assessment.edit_section_display#</a></if>

<a href="section-preview?assessment_id=@assessment_id@&section_id=@sections.section_id@">#assessment.section_preview#</a>

<a href="checks-admin?assessment_id=@assessment_id@&section_id=@sections.section_id@">#assessment.admin_triggers#</a>

<img src="/resources/assessment/spacer.gif" border="0" alt="" width="10">

<if @sections.rownum@ lt @sections:rowcount@>
  <a href="section-swap?assessment_id=@assessment_id@&sort_order=@sections.sort_order@&direction=down"><img src="/resources/assessment/down.gif" border="0" alt="#assessment.Move_Down#"></a>
</if>
<if @sections.rownum@ gt 1>
  <a href="section-swap?assessment_id=@assessment_id@&sort_order=@sections.sort_order@&direction=up"><img src="/resources/assessment/up.gif" border="0" alt="#assessment.Move_Up#"></a>
</if>
<a href="section-delete?section_id=@sections.section_id@&assessment_id=@assessment_id@"><img src="/resources/assessment/delete.gif" border="0" alt="#assessment.remove_section#"></a>

<if @sections.max_time_to_complete@ not nil> (#assessment.max_time# @sections.max_time_to_complete@) </if>
(@sections.points@ #assessment.points#)
</td></tr>

  <if @sections.rownum@ odd>
    <tr class="odd">
  </if>
  <else>
    <tr class="even">
  </else>
<td colspan="3">
  <blockquote>
    @sections.title@
  </blockquote>
</td></tr>
</table>      

<blockquote>
  <include src="/packages/assessment/lib/section-items" assessment_id="@assessment_id@" section_id="@sections.section_id@">
</blockquote>

</multiple>

<h3>#assessment.Sections#</h3>

<table cellspacing=0>
  <tr class="odd">
  <td></td><td>
    <a href="section-form?assessment_id=@assessment_id@&after=@sections:rowcount@">#assessment.add_new_section#</a>
    <a href="catalog-search?assessment_id=@assessment_id@&after=@sections:rowcount@">#assessment.Search_Section#</a>
  </td></tr>
</table>
