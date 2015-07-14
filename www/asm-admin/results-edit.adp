<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<h1>#assessment.Add_Comment#</h1>
<h2>#assessment.item_Title#: @item_title;noquote@</h2>

<p><include src="/packages/assessment/lib/results-edit-@item_type@" item_data_id="@item_data_id;literal@">

<p>#assessment.currently# <if @result_points@ not nil><b>@result_points@ / @max_points@ #assessment.points#</b></if>
<else><b>#assessment.not_yet_reviewed#</b></else>
<p>

<include src="/packages/assessment/lib/results-messages" session_id="@session_id;literal@" section_id="@section_id;literal@" as_item_id="@as_item_id;literal@">

<formtemplate id="results-edit"></formtemplate>
