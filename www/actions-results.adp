<h2>Actions Performed:</h2>
<multiple name="actions">
 @actions.user_message@
<if @actions.error_txt@ ne  >
	<font color=red>@actions.error_txt@</font>
</if>
</multiple>