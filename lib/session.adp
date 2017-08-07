<table width="100%" cellpadding="3" cellspacing="0" border="0">
<tr>
<th colspan="3" align="left">#assessment.Assessment#: <a href="assessment?assessment_id=@assessment_id@">@assessment_data.title@</a></th></tr>
<tr><td><strong>#assessment.User_ID#:</strong> <span><if @show_username_p;literal@ true><a href="@session_user_url@">@first_names@ @last_name@</a><if @assessment_data.anonymous_p;literal@ true><br>#assessment.lt_bNoteb_This_assessmen#</if></if><else>#assessment.anonymous_name#</else></span></td>
<td><strong>#assessment.Attempt#:</strong> <multiple name="session_attempts"><if @session_attempts.session_id@ eq @session_id@><strong>@session_attempts.rownum@</strong></if><else><a href="session?session_id=@session_attempts.session_id@">@session_attempts.rownum@</a></else>&nbsp;&nbsp; </multiple> <if @admin_p;literal@ true> (<a href="@delete_url@">#assessment.Delete_Attempts#</a>)</if></td>
<td><if @assessment_data.survey_p@ ne t> <if @showpoints@ eq 1> <strong>#assessment.Percent_Score#:</strong>  <span>@percent_score@</span></if></if> </td></tr>

<tr><td><strong>#assessment.Started#:</strong> <span>@session_start@</span></td>
<td><strong>#assessment.Finished#:</strong> <span>@session_finish@</span></td>
<td><strong>#assessment.Time_spent#:</strong> <span>@session_time@</span></td></tr>
<tr>
<td colspan="3"></td>
</tr>

</table>
<p>


<multiple name="sections">

  <fieldset style="padding:10px;margin-bottom:10px"><!-- Section FieldSet -->
    <legend>@sections.title@   <if @assessment_data.survey_p@ ne t> <if @showpoints@ eq 1 and @sections.max_points@ gt 0>(@sections.points@ / @sections.max_points@ #assessment.points#)</p></if> </if></legend>

  <if @sections.max_time_to_complete@ not nil><p>(#assessment.max_time# @sections.max_time_to_complete@)</p></if>

    <if @sections.description@ not nil><p>@sections.description;noquote@</p></if>    
    <if @assessment_data.show_feedback@ ne none><p>@sections.feedback_text@</p></if>


  <include src="/packages/assessment/lib/session-items" section_id="@sections.section_id;literal@" subject_id="@subject_id;literal@" session_id="@session_id;literal@" show_item_name_p="@assessment_data.show_item_name_p;literal@" show_feedback="@assessment_data.show_feedback;literal@" survey_p="@assessment_data.survey_p;literal@" &=assessment_data>


      </fieldset><!-- End Section FieldSet -->

</multiple>
</p>


<hr>
<if @assessment_data.survey_p@ ne t and @assessment_data.show_feedback@ ne none and @assessment_score@ not nil and @assessment_score@ gt 0><strong>#assessment.Total_score#:</strong> @session_score@ / @assessment_score@ = @percent_score@%</if>

<if @comments_installed_p;literal@ true>
<include src="/packages/assessment/lib/comments-chunk" object_id="@session_id;literal@" >
</if>
