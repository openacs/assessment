<master>
<property name="title">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<if @total_pages@ defined>
  <include src="/packages/acs-tcl/lib/static-progress-bar" total="@total_pages@" current="@current_page@" finish="1" />
</if>

@assessment_data.exit_page;noquote@

<if @user_id@ ne 0>
  <p><a href="session?session_id=@session_id@">#assessment.View_results#</a></p>
</if>

