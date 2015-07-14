<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

  <formtemplate id="item_edit"></formtemplate>

<include src="/packages/assessment/lib/item-show-@item_type@" assessment_id="@assessment_id;literal@" section_id="@section_id;literal@" as_item_id="@as_item_id;literal@">

<include src="/packages/assessment/lib/item-show-display-@display_type@" assessment_id="@assessment_id;literal@" section_id="@section_id;literal@" as_item_id="@as_item_id;literal@">

<p><a href="one-a?assessment_id=@assessment_id@">@assessment_data.title@</a></p>
