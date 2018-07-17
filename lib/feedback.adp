<property name="doc(title)">@assessment_data.html_title;literal@</property>
<property name="context">@context;literal@</property>

<if @assessment_data.html_title@ not nil><h2>@assessment_data.html_title;noquote@: Feedback</h2></if>

<if @total_pages@ defined>
  <include src="/packages/acs-tcl/lib/static-progress-bar" total="@total_pages;literal@" current="@current_page;literal@" finished_page="@finished_page;literal@">
</if>

  <h2>@section_title@</h2>

  <include src="/packages/assessment/lib/session-items" section_id="@section_id;literal@" subject_id="@subject_id;literal@" session_id="@session_id;literal@" show_item_name_p="@assessment_data.show_item_name_p;literal@" show_feedback="@assessment_data.show_feedback;literal@" survey_p="@assessment_data.survey_p;literal@" feedback_only_p="1" next_url="@next_url;literal@" item_id_list="@item_id_list;literal@" return_p="@return_p;literal@"  &=assessment_data>

  <p />

	<formtemplate id="next"></formtemplate>


