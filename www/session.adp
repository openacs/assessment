<master>
<property name="title">Assessment</property>
<property name="context">@context;noquote@</property>

<table width="100%" cellpadding="3" cellspacing="0" border="0">
<tr>
<th colspan="3">#assessment.Review_Asessment# <a href="@assessment_url@">@assessment_name@</a></th></tr>
<tr><td nowrap><b>#assessment.User_ID#:</b> <span><a href="@session_user_url@">@session_user_name@</a></span></td>
<td nowrap><b>#assessment.Attempt#:</b> <span>@session_attempt@ / Unlimited</span></td>
<td nowrap><b>#assessment.Out_of#:</b> <span>@assessment_score@</span></td></tr>

<tr><td><b>#assessment.Started#:</b> <span>@session_start@</span></td>
<td><b>#assessment.Finished#:</b> <span>@session_finish@</font></td>
<td><b>#assessment.Time_spent#:</b> <span>@session_time@</span></td></tr>
<tr>
<td colspan="3"></td>
</tr>
</table>

<table cellpadding="3" cellspacing="0" border="0" width="100%">
	<table border="0">
		<multiple name="items">
			<tr bgcolor="#e4eaef"><td colspan="2"><b>Question @items.rownum@</b>&nbsp;&nbsp;(@items.maxscore@ points)</td></tr>
			<tr><td colspan="2">
			<b>@items.title@</b>
			</td></tr>
			<tr><td valign="top" nowrap>
			Student response:</td><td>
			@items.choice_html;noquote@</td></tr>
			<tr><td></td><td><if @items.item_correct@ false>@items.feedback_text@</if></td></tr>
			<tr><td nowrap>
			Score:</td><td><span>@items.score@ / @items.maxscore@</span>
			<if @items.notanswered@>(<i>Question not answered.</i>)</if></td></tr>
			<tr><td><br></td></tr>
		</multiple>
	</table>
</table>
<hr>
<b>Total score:</b> @session_score@ / @assessment_score@
</master>
