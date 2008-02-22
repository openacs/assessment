<h1>@assessment_data.title;noquote@</h1>
<ul>
  <li><if @tab@ eq "front">#assessment.Admin#</if>
      <else><a href="@assessment_url@">#assessment.Admin#</a></else></li> 
  <li><if @tab@ eq "questions">#assessment.Questions#</if>
      <else><a href="@questions_url@">#assessment.Questions#</a></else></li> 
  <li><if @tab@ eq "results">#assessment.Results#</if>
      <else><a href="results-users?assessment_id=@assessment_id@">#assessment.Results#</a></else></li>
</ul>
