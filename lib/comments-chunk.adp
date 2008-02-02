<if @has_permission_p@>
<h2>Reviewer Comments</h2>
<if @comments:rowcount@ gt 0>
  <multiple name="comments">
    <div><b>@comments.title@</b> <a href="@comments.edit_url@"></a></div>
    <div>
      @comments.html_content;noquote@
    </div>
    <div>- @comments.author@ (on @comments.creation_date_ansi@)</div>
  </multiple>
</if>
<else>
  <p style="font-style:italic">No reviewer comments have been added to this assessment yet.</p>
</else>

<div>
  <a href="@comment_add_url@" class="button">Add comment</a>
</div>
</if>
