<master>
  <property name="title">#assessment.All_Users#</property>
  	
  <if @assessment_data.html_title@ defined><h2>#assessment.lt_Responses_for_assessm#</h2></if>
  <if @person_name@ defined><h2>#assessment.lt_Responses_of_user_per#</h2></if>
  <p />
  <listtemplate name="sessions"></listtemplate>