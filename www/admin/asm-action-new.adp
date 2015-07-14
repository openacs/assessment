<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context_bar">@context_bar;literal@</property>

  <formtemplate id="action_admin"></formtemplate>

<if @parameter_exist@ eq "y">
	<include src=asm-action-param-list action_id="@action_id;literal@">
</if>

