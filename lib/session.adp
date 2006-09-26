<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<table width="100%" cellpadding="3" cellspacing="0" border="0">
<tr>
<th colspan="3" align=left>#assessment.Assessment#: <a href="assessment?assessment_id=@assessment_id@">@assessment_data.title@</a></th></tr>
<tr><td nowrap><b>#assessment.User_ID#:</b> <span><if @show_username_p@><a href="@session_user_url@">@first_names@ @last_name@</a><if @assessment_data.anonymous_p@ eq "t"><br />#assessment.lt_bNoteb_This_assessmen#</if></if><else>#assessment.anonymous_name#</else></span></td>
<td nowrap><b>#assessment.Attempt#:</b> <multiple name="session_attempts"><if @session_attempts.session_id@ eq @session_id@><b>@session_attempts.rownum@</b></if><else><a href="session?session_id=@session_attempts.session_id@">@session_attempts.rownum@</a></else>&nbsp;&nbsp; </multiple></td>
<td nowrap><if @assessment_data.survey_p@ ne t> <if @showpoints@ eq 1> <b>#assessment.Percent_Score#:</b>  <span>@percent_score@</span></if></if> </td></tr>

<tr><td><b>#assessment.Started#:</b> <span>@session_start@</span></td>
<td><b>#assessment.Finished#:</b> <span>@session_finish@</font></td>
<td><b>#assessment.Time_spent#:</b> <span>@session_time@</span></td></tr>
<tr>
<td colspan="3"></td>
</tr>

</table>
<p>


<multiple name="sections">

  <fieldset style="padding:10px;margin-bottom:10px"><!-- Section FieldSet -->
    <legend><b>@sections.title@</b></legend>

  <if @sections.max_time_to_complete@ not nil><p>(#assessment.max_time# @sections.max_time_to_complete@)</p></if>
  <if @assessment_data.survey_p@ ne t> <if @showpoints@ eq 1><p>(@sections.points@ / @sections.max_points@ #assessment.points#)</p></if> </if>

    <if @sections.description@ not nil><p>@sections.description;noquote@</p></if>    
    <if @assessment_data.show_feedback@ ne none><p>@sections.feedback_text@</p></if>


  <include src="/packages/assessment/lib/session-items" section_id="@sections.section_id@" subject_id="@subject_id@" session_id="@session_id@" show_item_name_p="@assessment_data.show_item_name_p@" show_feedback="@assessment_data.show_feedback@" survey_p="@assessment_data.survey_p@" &=assessment_data>


      </fieldset><!-- End Section FieldSet -->

</multiple>
</p>
<p><include src="/packages/assessment/lib/actions-results" session_id="@session_id@"></p>

<hr>
<if @assessment_data.survey_p@ ne t and @assessment_data.show_feedback@ ne none ><b>#assessment.Total_score#:</b> @session_score@ / @assessment_score@ = @percent_score@%</if>

<if @comments_installed_p@>
<include src="/packages/assessment/lib/comments-chunk" object_id="@session_id@" />
</if>
</master>
