<property name="title">@assessment_data.html_title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @assessment_data.html_title@ not nil><h2>@assessment_data.html_title;noquote@: Feedback</h2></if>

<if @total_pages@ defined>
  <include src="/packages/assessment/lib/progress-bar" total="@total_pages@" current="@current_page@" finished_page="@finished_page@"/>
</if>

  <h2>@section_title@</h2>

  <include src="/packages/assessment/lib/session-items" section_id="@section_id@" subject_id="@subject_id@" session_id="@session_id@" show_item_name_p="@assessment_data.show_item_name_p@" show_feedback="@assessment_data.show_feedback@" survey_p="@assessment_data.survey_p@" feedback_only_p="1" next_url="@next_url;noquote@" item_id_list=@item_id_list@ return_p=@return_p@  &=assessment_data>

  <p />

	<formtemplate id="next"></formtemplate>


