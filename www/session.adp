<master>
<property name="title">Assessment</property>
<property name="context">@context;noquote@</property>

<table width="100%" cellpadding="3" cellspacing="0" border="0">
<tr>
<th colspan="3">#assessment.Review_Asessment# <a href="@assessment_url@">@assessment_data.title@</a></th></tr>
<tr><td nowrap><b>#assessment.User_ID#:</b> <span><a href="@session_user_url@">@session_user_name@</a></span></td>
<td nowrap><b>#assessment.Attempt#:</b> <span>@session_attempt@ / Unlimited</span></td>
<td nowrap><if @survey_p@ in f><b>#assessment.Out_of#:</b> <span>@assessment_score@</span></if></td></tr>

<tr><td><b>#assessment.Started#:</b> <span>@session_start@</span></td>
<td><b>#assessment.Finished#:</b> <span>@session_finish@</font></td>
<td><b>#assessment.Time_spent#:</b> <span>@session_time@</span></td></tr>
<tr>
<td colspan="3"></td>
</tr>
</table>

<multiple name="items">
    <table border="0">
        <tr bgcolor="#d0d0d0"><td><b>#assessment.section#: @items.section_title@ </b></td></tr>
	<tr><td><i> @items.section_description@ </i><br></td></tr>
    </table>

    <table cellpadding="3" cellspacing="0" border="0" width="100%">
	<table border="0">
		<group column="section_id">
			<tr bgcolor="#e4eaef"><td colspan="2"><b>#assessment.Question# @items.rownum@</b>&nbsp;&nbsp;<if @survey_p@ in f> (@items.maxscore@ #assessment.points#) </if></td></tr>
			<tr><td colspan="2">
			<b><if @items.presentation_type@ not in fitb>@items.title@</if></b>
			</td></tr>
			<tr><td colspan="2">
			@items.choice_html;noquote@</td></tr>
			<if @items.presentation_type@ in textarea>
			   <tr><td nowrap></td><td><if @survey_p@ eq f and @assessment_show_feedback@ ne none><span><i>#assessment.This_question_will_be_corrected_by_the_teacher#.</i></span></if></td></tr>
			   <tr><td></td><td></td></tr>
			   <tr><td><br></td></tr>
			</if>
			<else>
			<if @survey_p@ eq f and @assessment_show_feedback@ ne none >
			<tr><td nowrap>
			#assessment.Score#</td><td><span>@items.score@ / @items.maxscore@</span>
			<if @items.notanswered@>(<i>#assessment.Question_not_answered#.</i>)</if></td></tr>
			<tr><td></td> <if @assessment_show_feedback@ eq all or @assessment_show_feedback@ eq correct>
			<if @items.item_correct@><td><b>#assessment.Feedback#:</b> @items.feedback_right@</if></if>
			<if @assessment_show_feedback@ eq all or @assessment_show_feedback@ eq incorrect>
			<if @items.item_correct@ false><td><b>#assessment.Feedback#:</b> @items.feedback_wrong@</if></if></td></tr>
			</if>
			<tr><td><br></td></tr>
			</else>
		</group>
	</table>
    </table>
</multiple>
<hr>
<if @survey_p@ eq f and @assessment_show_feedback@ ne none ><b>#assessment.Total_score#:</b> @session_score@ / @assessment_score@</if>
</master>
