<master>
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<include src="/packages/assessment/lib/session">

<if @comments_installed_p@>
<include src="/packages/assessment/lib/comments-chunk" object_id="@session_id@" />
</if>
</master>
