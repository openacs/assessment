<h2>Actions Performed:</h2>
<multiple name="actions">
@actions.user_message@
<if @actions.error_txt@ ne  >
	<font color=red>This action has failed</font>
</if>
</multiple>