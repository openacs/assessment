<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context_bar">@context_bar;literal@</property>

<if @admin_p;literal@ true><p style="text-align: right;"><a href="asm-admin/"><img src="/resources/assessment/admin.gif" style="border:0" alt="#acs-kernel.common_Administration#"></a></p></if>

<listtemplate name="assessments"></listtemplate>

<if @sessions:rowcount@ gt 0>
  <h3>#assessment.answered_assessments#</h3>
  <listtemplate name="sessions"></listtemplate>
</if>
