<master>
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<blockquote>
  @assessment_data.consent_page;noquote@
</blockquote>

<form action="assessment" method="get">
  <input type="hidden" name="assessment_id" value="@assessment_id@">
  <input type="hidden" name="session_id" value="@session_id@">
  <input type="submit" name="ok" value="       OK       ">
</form>
