<if @has_permission_p@>
<h2>Reviewer Comments</h2>
<if @comments:rowcount@ gt 0>
<multiple name="comments">
<b>@comments.title@</b> <a href="@comments.edit_url@"></a>
<br />
@comments.html_content;noquote@
<br />
- @comments.author@ (on @comments.creation_date_ansi@)
</multiple>
</if>
<else>
<i>No reviewer comments have been added to this assessment yet.</i>
</else>
<br />
<a href="@comment_add_url@" class="button">Add comment<a/>
</if>