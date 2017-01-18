<if @has_permission_p;literal@ true>
<h2>#assessment.Reviewer_Comments#</h2>
<if @comments:rowcount@ gt 0>
  <multiple name="comments">
    <div><strong>@comments.title@</strong> <a href="@comments.edit_url@"></a></div>
    <div>
      @comments.html_content;noquote@
    </div>
    <div>- @comments.author@ (@comments.creation_date_ansi@)</div>
  </multiple>
</if>
<else>
  <p style="font-style:italic">#assessment.No_reviewer_comments_have_been_added_to_this_assessment_yet#</p>
</else>

<div>
  <a href="@comment_add_url@" class="button">#assessment.Add_Comment#</a>
</div>
</if>
