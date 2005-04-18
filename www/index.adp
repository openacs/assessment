<master>
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<if @admin_p@ eq "1"><p style="text-align: right;"><a href="asm-admin/"><img src="/resources/assessment/admin.gif" border="0" alt="Administer Assessments"></a></p></if>

<listtemplate name="assessments"></listtemplate>

<if @sessions:rowcount@ gt 0>
  <h3>#assessment.answered_assessments#</h3>
  <listtemplate name="sessions"></listtemplate>
</if>
