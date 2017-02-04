<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<div class="result">
<h1>@assessment_data.title@</h1>
<p><span><strong>#acs-subsite.Name#:</strong> <if @show_username_p;literal@ true><a href="@session_user_url@">@first_names@ @last_name@</a></if><else>#assessment.anonymous_name#</else></span>
   <span><strong>#assessment.Attempt#:</strong> @session_attempt@<if @assessment_data.number_tries@ not nil> / @assessment_data.number_tries@</if></span> (<a href="@delete_url@">#assessment.Delete_Attempts#</a>)
   <if @assessment_data.type@ ne survey><span><strong>#assessment.Percent_Score#:</strong> @percent_score@%</span></if>
 <span><strong>#assessment.Started#:</strong> @session_start@</span>
 <span><strong>#assessment.Finished#:</strong> @session_finish@</span>
 <span><strong>#assessment.Time_spent#:</strong> @session_time@</span>
</p>

<multiple name="sections">
<div class="section">
<h2>@sections.title@</h2>
<if @sections.max_time_to_complete@ not nil> (#assessment.max_time# @sections.max_time_to_complete@) </if>
<if @sections.description@ not nil><p>@sections.description@</p></if>
<if @sections.feedback_text@ not nil><p>@sections.feedback_text@</p></if>
<include src="/packages/assessment/lib/session-items" edit_p=1 section_id="@sections.section_id;literal@" subject_id="@subject_id;literal@" session_id="@session_id;literal@" &assessment_data="assessment_data" show_item_name_p="@assessment_data.show_item_name_p;literal@" show_feedback="@assessment_data.show_feedback;literal@" survey_p="@assessment_data.survey_p;literal@">
</div> <!-- section -->
</multiple>
<hr>
<if @assessment_data.type@ ne survey><strong>#assessment.Total_score#:</strong> @session_score@ / @assessment_score@ = @percent_score@%</if>
<if @comments_installed_p;literal@ true>
<include src="/packages/assessment/lib/comments-chunk" object_id="@session_id;literal@" >
</if>
</div> <!-- result -->
