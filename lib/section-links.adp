<h1>@assessment_data.title;noquote@</h1>
<ul>
  <li><if @tab@ eq "front">Admin</if>
      <else><a href="@assessment_url@">Admin</a></else></li> 
  <li><if @tab@ eq "questions">Questions</if>
      <else><a href="@questions_url@">Questions</a></else></li> 
  <li><if @tab@ eq "results">Results</if>
      <else><a href="results-users?assessment_id=@assessment_id@">Results</a></else></li>
</ul>

<!--
vinodk: remove this
<p>

<if @tab@ eq "front">@assessment_data.title;noquote@ Admin | </if>
<else><a href="@assessment_url@">@assessment_data.title;noquote@ Admin</a> | </else>

<if @tab@ eq "results">Results | </if>
<else><a href="results-users?assessment_id=@assessment_id@">Results</a> | </else>

<if @sections:rowcount@>
<multiple name="sections" delimiter=" | ">
  <if @tab@ eq @sections.section_id@>@sections.title@</if>
  <else><a href="@sections.section_url@">@sections.title@</a></else>
</multiple>
</if>
<else>
No Sections
</else>
</p>
-->