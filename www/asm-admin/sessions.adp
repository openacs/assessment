<master>
  <property name="doc(title)">@page_title;literal@</property>
  <property name="context">@context;literal@</property>
  <if @assessment_data.html_title@ defined><h2>#assessment.lt_Responses_for_assessm#</h2></if>
  <if @person_name@ defined><h2>#assessment.lt_Responses_of_user_per#</h2></if>

  <listtemplate name="sessions"></listtemplate>
