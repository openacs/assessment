<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<listtemplate name="results"></listtemplate>

<if @assessment_data.anonymous_p@ eq t>
  <h3>#assessment.Responding_Users#</h3>
  <listtemplate name="subjects"></listtemplate>
</if>
