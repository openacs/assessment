<master>
<property name="title">@page_title@</property>
<property name="context_bar">@context_bar;noquote@</property>

<blockquote>
  <formtemplate id="action_admin"></formtemplate>

<if @parameter_exist@ eq "y">
	<include src=asm-action-param-list action_id=@action_id@>
</if>
</blockquote>

