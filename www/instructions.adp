<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>
@assessment_data.entry_page;noquote@
<p>
  @assessment_data.instructions;noquote@
</p>
<p>
  <if @assessment_data.number_tries@ eq "" or @assessment_data.number_tries@ lt 1 or @completed_session_count@ lt @assessment_data.number_tries@>
  <if @unfinished_session_id@ not nil>
    #assessment.Resume_Assessment_Title#
  </if> 
  <else>
    <if @completed_session_count@ gt 0 and @user_id@ ne 0>
      #assessment.Retake_Assessment_Title#
    </if>
    <else>
      #assessment.Start_Assessment_Title#
    </else>
  </else>
  </if>
  <else>
	#assessment.You_have_completed_the_maximum_number_of_attempts#</p>
  <p><a href="session?assessment_id=@assessment_id@">#assessment.View_results#</a>	
  </else>
 <if @total_pages@ eq 1>#assessment.Number_of_page_singular#</if>
 <else>#assessment.Number_of_page_plural#</else>
</p>