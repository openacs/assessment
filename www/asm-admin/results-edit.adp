<master>
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

@item_title;noquote@
<p>

<include src="/packages/assessment/lib/results-edit-@item_type@" item_data_id="@item_data_id@">

<p>
#assessment.currently# <if @result_points@ not nil><b>@result_points@ / @max_points@ #assessment.points#</b></if>
<else><b>#assessment.not_yet_reviewed#</b></else>
<p>

<include src="/packages/assessment/lib/results-messages" session_id="@session_id@" section_id="@section_id@" as_item_id="@as_item_id@">

<formtemplate id="results_edit"></formtemplate>
