<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @total_pages@ defined>
  <include src="/packages/assessment/lib/progress-bar" total="@total_pages@" current="@current_page@" finish="1" />
</if>

@assessment_data.exit_page;noquote@

  <p><a href="session?session_id=@session_id@">#assessment.View_results#</a></p>

