<master>
<property name="title">Assessment</property>
<property name="context">@context;noquote@</property>

<table width="100%" cellpadding="3" cellspacing="0" border="0">
<tr>
<th colspan="3">#assessment.Review_Asessment# <a href="assessment?assessment_id=@assessment_id@">@assessment_data.title@</a></th></tr>
<tr><td nowrap><b>#assessment.User_ID#:</b> <span><a href="@session_user_url@">@first_names@ @last_name@</a></span></td>
<td nowrap><b>#assessment.Attempt#:</b> <span>@session_attempt@ / Unlimited</span></td>
<td nowrap><if @assessment_data.survey_p@ in f><b>#assessment.Out_of#:</b> <span>@assessment_score@</span></if></td></tr>

<tr><td><b>#assessment.Started#:</b> <span>@session_start@</span></td>
<td><b>#assessment.Finished#:</b> <span>@session_finish@</font></td>
<td><b>#assessment.Time_spent#:</b> <span>@session_time@</span></td></tr>
<tr>
<td colspan="3"></td>
</tr>
</table>
<p>

<multiple name="sections">

<table cellspacing=0>
<tr><td valign="top">#assessment.section# @sections.title@
<if @sections.max_time_to_complete@ not nil> (#assessment.max_time# @sections.max_time_to_complete@) </if>
(0 / @sections.points@ #assessment.points#)
</td></tr>

<tr><td><i> @sections.description@ </i><br></td></tr>
<tr><td>@sections.feedback_text@</td></tr>
</table>      

<blockquote>
  <include src="/packages/assessment/lib/session-items" section_id="@sections.section_id@" subject_id="@subject_id@" session_id="@session_id@" show_item_name_p="@assessment_data.show_item_name_p@" show_feedback="@assessment_data.show_feedback@">
</blockquote>

</multiple>

<hr>
<if @assessment_data.survey_p@ eq f and @assessment_data.show_feedback@ ne none ><b>#assessment.Total_score#:</b> @session_score@ / @assessment_score@</if>
</master>
