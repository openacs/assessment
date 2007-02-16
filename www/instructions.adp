<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>
@assessment_data.entry_page;noquote@
<p>
  @assessment_data.instructions;noquote@
</p>
<p>
  <if @unfinished_session_id@ not nil>
    #assessment.Resume_Assessment_Title#
  </if> 
  <else>
    <if @completed_session_count@ gt 0>
      #assessment.Retake_Assessment_Title#
    </if>
    <else>
      #assessment.Start_Assessment_Title#
    </else>
  </else>
 <if @total_pages@ eq 1>#assessment.Number_of_page_singular#</if>
 <else>#assessment.Number_of_page_plural#</else>
</p>