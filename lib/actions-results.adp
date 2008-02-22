<h2>#assessment.Actions_Performed#:</h2>
<multiple name="actions">
 @actions.user_message@
<if @actions.error_txt@ ne nil>
	<font color=red>@actions.error_txt@</font>
</if>
</multiple>