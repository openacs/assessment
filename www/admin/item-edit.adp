<master>
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<blockquote>
  <formtemplate id="item_edit"></formtemplate>
</blockquote>

<include src="/packages/assessment/lib/item-show-@item_type@" assessment_id="@assessment_id@" section_id="@section_id@" as_item_id="@as_item_id@">

<include src="/packages/assessment/lib/item-show-display-@display_type@" assessment_id="@assessment_id@" section_id="@section_id@" as_item_id="@as_item_id@">