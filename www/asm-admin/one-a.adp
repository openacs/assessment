<master>
<property name="doc(title)">@p_title;literal@</property>
<property name="context">@context;literal@</property>

<include src="/packages/assessment/lib/section-links" assessment_id="@assessment_id;literal@" tab="front">

<table width="100%">
<tr>
<td>#assessment.Created_by# <a href="@creator_url@">@assessment_data.creator_name@</a>#assessment.on_creation_date# - <a href="@history_url@">#assessment.history#</a></td>
<td align="right"><a href=".">#assessment.other_asm#</a></td>
</tr>
</table>

<br>

<table class="table-display" cellpadding="2" cellspacing="0">

<if @is_reg_asm_p@ not nil>
  <tr class="even">
    <th colspan="2">
      <span style="color:red">#assessment.reg_asm#</span>
    </th>
  </tr>
</if>

  <tr class="odd">
    <td>#assessment.Assessment_Title#:</td>
    <td>@assessment_data.title;noquote@ <a href="@edit_url@">#assessment.Edit#</a> </td>
  </tr>

  <tr class="odd">
    <td>#assessment.publish_status#:</td>
    <td><if @assessment_data.publish_status@ eq "live">#assessment.Live#</if><else>#assessment.Not_Live#</else> (<a href="@toggle_publish_url@">#assessment.Change_status#</a>)</td>
  </tr>

  <tr class="odd">
    <td>#assessment.Description#:</td>
    <td><if @assessment_data.description@ nil>#assessment.None#</if><else>@assessment_data.description;noquote@</else>
	<a href="@edit_url@">#assessment.Edit#</a></td>
  </tr>

  <tr class="odd">
    <td>#assessment.Instructions#:</td>
    <td><if @assessment_data.instructions@ nil>#assessment.None#</if><else>@assessment_data.instructions;noquote@</else>
	<a href="@edit_url@">#assessment.Edit#</a></td>
  </tr>

  <tr class="odd">
    <td>#assessment.Type#:</td>
    <td><if @assessment_data.type@ nil>#assessment.None#</if>
        <elseif @assessment_data.type@ eq "survey">#assessment.type_s#</elseif>
        <elseif @assessment_data.type@ eq "test">#assessment.type_test#</elseif>
        (<a href="@toggle_type_url@">#assessment.Change_type#</a>)
    </td>
  </tr>
  <tr class="odd">
    <td>&nbsp;</td><td>
	#assessment.Preview_link_and_message#
    </td>
  </tr>


<tr class="even">
  <td>#assessment.View_Responses# </td>
  <td>
    <a href="@sessions_url@">#assessment.All#</a> |
    <a href="@results_url@">#assessment.By_user#</a> |
    <a href="@export_url@">#assessment.CSV_file#</a></td>
</tr>

<tr class="odd">
  <td valign="top" rowspan="7"><div>#assessment.Response_Options# </div></td>
</tr>

<tr class="odd">
  <td><if @assessment_data.anonymous_p;literal@ true>#assessment.anonymous_users_allow#</if>
      <else>#assessment.reg_users_required#</else> -
	[ <a href="@toggle_anon_url@">
	<if @assessment_data.anonymous_p;literal@ true>#assessment.make_non_anonymous#</if><else>#assessment.make_anonymous#</else></a> ]</td>
</tr>

<tr class="odd">
	<td><if @assessment_data.secure_access_p;literal@ true> #assessment.secure_access_require#</if><else>#assessment.unsecure_access_allow#</else> -
	[ <a href="@toggle_secure_url@">
	<if @assessment_data.secure_access_p;literal@ true>#assessment.make_unsecure#</if><else>#assessment.make_secure#</else></a> ]</td>
</tr>

<tr class="odd">
	<td><if @assessment_data.reuse_responses_p;literal@ true> #assessment.reuse_responses#</if><else>#assessment.dont_reuse_responses#</else> -
	[ <a href="@toggle_reuse_url@">
	<if @assessment_data.reuse_responses_p;literal@ true>#assessment.make_not_reuse_respo#</if><else>#assessment.make_reuse_responses#</else></a> ]</td>
</tr>

<tr class="odd">
	<td><if @assessment_data.number_tries@ not nil> #assessment.limited_tries#</if><else>#assessment.unlimited_tries#</else> -
	[ <a href="@edit_url@">#assessment.Edit#</a> ]</td>
</tr>

<tr class="odd">
	<td><if @assessment_data.wait_between_tries@ not nil> #assessment.time_to_wait#</if><else>#assessment.no_waiting#</else> -
	[ <a href="@edit_url@">#assessment.Edit#</a> ]</td>
</tr>

<tr class="odd">
	<td><if @assessment_data.time_for_response@ not nil> #assessment.time_response#</if><else>#assessment.unlimited_time#</else> -
	[ <a href="@edit_url@">#assessment.Edit#</a> ]</td>
</tr>

<tr class="even"><td valign="top">#assessment.Email_Options#</td><td >@notification_chunk;noquote@ <br><a href="send-mail?assessment_id=@assessment_id@">#assessment.Send_bulkmail#</a> #assessment.regarding_this_assess# </td></tr>

<tr class="odd">
	<td>#assessment.Extreme_Actions# </td>
	<td><a href="assessment-delete?assessment_id=@assessment_id@">#assessment.Delete_this_assess#</a> #assessment.Removes_all_questio#<br>
	<a href="assessment-copy?assessment_id=@assessment_id@">#assessment.Copy_this_assess#</a> #assessment.Lets_you_use_this_a#
	<if @admin_p;literal@ true>
	 <if @anonymous_p;literal@ true>
	   <if @read_p;literal@ true>
	      <br><a href="@reg_url@/set-reg-assessment?assessment_id=@assessment_id@">#acs-subsite.set_reg_asm#</a>
	   </if>
         </if>
        </if>
</td>
</tr>


</table>
