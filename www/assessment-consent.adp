<master>
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<p>
  @assessment_data.consent_page;noquote@
</p>

<form action="assessment" method="get">
  <div>
  <input type="hidden" name="assessment_id" value="@assessment_id@">
  <input type="hidden" name="session_id" value="@session_id@">
  <input type="hidden" name="password" value="@password@">
  <input type="submit" name="ok" value="       OK       ">
  </div>
</form>
