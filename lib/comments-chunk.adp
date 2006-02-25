<if @has_permission_p@>
<h3>Comments</h3>
<if @comments:rowcount@ gt 0>
<multiple name="comments">
<p />
<b>@comments.title@</b> <a href="@comments.edit_url@">Edit</a>
<br /><br />
@comments.html_content;noquote@
<br /><br />
- @comments.author@ (on @comments.creation_date_ansi)
</multiple>
</if>
<else>
<i>No comments.</i>
</else>
<br /><br />
<a href="@comment_add_url@" class="button">Add comment<a/>
</if>