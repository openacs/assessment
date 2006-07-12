<master>
<property name="title">@p_title;noquote@</property>
<property name="context">@context;noquote@</property>

<table width=100%>
<tr><td>#assessment.Created_by# <a href="@creator_link@">@assessment_data.creator_name@</a>#assessment.on_creation_date# - <a href="assessment-history?assessment_id=@assessment_id@">#assessment.history#</a></td>
<td align=right><a href=".">#assessment.other_asm#</a></td></tr>
</table>

<p>
<table class="table-display" cellpadding=2 cellspacing=0>

<tr class="odd">
	<td valign="top">#assessment.Assessment_Title#:	<if @assessment_data.type@ gt 1><p>#assessment.Description#:</if><p>#assessment.Instructions#:<p>#assessment.Type#:</td>
	<td valign="top"> 
	<!-- <a href="assessment-preview?assessment_id=@assessment_id@">#assessment.Preview#</a> -->
	@assessment_data.title;noquote@ 
	<a href="assessment-form?assessment_id=@assessment_id@&edit_f=t">#assessment.Edit#</a>
	<div align=center><font color=red>@is_reg_asm_p@</font></div>
	<if @assessment_data.type@ gt 1>
        <p><if @assessment_data.description@ nil>#assessment.None#</if><else>@assessment_data.description;noquote@</else>
	<a href="assessment-form?assessment_id=@assessment_id@&edit_f=d">#assessment.Edit#</a>
	</if>
        <p><if @assessment_data.instructions@ nil>#assessment.None#</if><else>@assessment_data.instructions;noquote@</else>
	<a href="assessment-form?assessment_id=@assessment_id@&edit_f=i">#assessment.Edit#</a>
	<p><if @assessment_data.type@ nil>#assessment.None#</if><else><if @assessment_data.type@ eq 1>#assessment.type_s#</if> <if @assessment_data.type@ eq 2>#assessment.type_ea#</if></else>	<a href="assessment-new?assessment_id=@assessment_id@&edit_p=1">#assessment.Edit#</a></td>
</td>
</tr>

<tr class="even"><td>#assessment.View_Responses# </td><td>
	<a href="sessions?assessment_id=@assessment_id@">#assessment.All#</a> |
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
	      <br><a href="@reg_url@/set-reg-assessment?assessment_id=@assessment_id@">#acs-subsite.set_reg_asm#</a>
	   </if>
         </if>
        </if>
</td>
</tr>


</table>
<br>
<listtemplate name=sections></listtemplate>
<if @sections:rowcount@ eq 0>
<font color=red><b>#assessment.add_section_first#</b></font>
</if>

<multiple name="sections">
<h3>#assessment.Sections#</h3>

<table cellspacing=0>
<tr class="odd">
<td valign="top"><a name=@sections.section_id@>@sections.rownum@. @sections.name@</a></td></tr>
<tr class="odd">
<td>


<a class=button href="section-form?assessment_id=@assessment_id@&after=@sections.sort_order@">#assessment.add_new_section#</a>

<a class=button href="catalog-search?assessment_id=@assessment_id@&after=@sections.sort_order@">#assessment.Search_Section#</a>

<if @sections.display_type_id@ not nil><a class=button href="section-display-form?assessment_id=@assessment_id@&section_id=@sections.section_id@&display_type_id=@sections.display_type_id@">#assessment.edit_section_display#</a></if>

<a class=button href="section-preview?assessment_id=@assessment_id@&section_id=@sections.section_id@">#assessment.section_preview#</a>

<a class=button href="checks-admin?assessment_id=@assessment_id@&section_id=@sections.section_id@">#assessment.admin_triggers#</a>

<a class=button href="add-edit-section-check?assessment_id=@assessment_id@&section_id=@sections.section_id@">#assessment.add_section_trigger#</a>


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
<img src="/resources/assessment/spacer.gif" border="0" alt="" width="10">
<a href="section-form?section_id=@sections.section_id@&assessment_id=@assessment_id@">#assessment.Edit#</a> 
<if @sections.rownum@ lt @sections:rowcount@>
  <a href="section-swap?assessment_id=@assessment_id@&sort_order=@sections.sort_order@&direction=down"><img src="/resources/assessment/down.gif" border="0" alt="#assessment.Move_Down#"></a>
</if>
<if @sections.rownum@ gt 1>
  <a href="section-swap?assessment_id=@assessment_id@&sort_order=@sections.sort_order@&direction=up"><img src="/resources/assessment/up.gif" border="0" alt="#assessment.Move_Up#"></a>
</if>
<a href="section-delete?section_id=@sections.section_id@&assessment_id=@assessment_id@"><img src="/resources/acs-subsite/Delete16.gif" border="0" alt="#assessment.remove_section#"></a>

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
