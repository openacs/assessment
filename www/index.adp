<master>
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<if @admin_p@ eq "1"><p style="text-align: right;"><a href="admin/"><img src="graphics/admin.gif" border="0" alt="Administer Assessments"></a></p></if>

<listtemplate name="assessments"></listtemplate>
