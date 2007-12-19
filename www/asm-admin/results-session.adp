<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<div class="result">
<h1>@assessment_data.title@</h1>
<p><span><b>#acs-subsite.Name#:</b> <if @show_username_p@><a href="@session_user_url@">@first_names@ @last_name@</a></if><else>#assessment.anonymous_name#</else></span>
   <span><b>#assessment.Attempt#:</b> @session_attempt@<if @assessment_data.number_tries@ not nil> / @assessment_data.number_tries@</if></span> (<a href="@delete_url@">#assessment.Delete_Attempts#</a>)
   <if @assessment_data.type@ ne survey><span><b>#assessment.Percent_Score#:</b> @percent_score@%</span></if>
 <span><b>#assessment.Started#:</b> @session_start@</span>
 <span><b>#assessment.Finished#:</b> @session_finish@</span>
 <span><b>#assessment.Time_spent#:</b> @session_time@</span>
</p>

<multiple name="sections">
<div class="section">
<h2>@sections.title@</h2>
<if @sections.max_time_to_complete@ not nil> (#assessment.max_time# @sections.max_time_to_complete@) </if>
<if @sections.description@ not nil><p>@sections.description@</p></if>
<if @sections.feedback_text@ not nil><p>@sections.feedback_text@</p></if>
<include src="/packages/assessment/lib/session-items" edit_p=1 section_id="@sections.section_id@" subject_id="@subject_id@" session_id="@session_id@" &assessment_data="assessment_data" show_item_name_p="@assessment_data.show_item_name_p@" show_feedback="@assessment_data.show_feedback@" survey_p="@assessment_data.survey_p@"></p>
</div>
</multiple>
<hr>
<if @assessment_data.type@ ne survey and @assessment_data.show_feedback@ ne none ><b>#assessment.Total_score#:</b> @session_score@ / @assessment_score@ = @percent_score@%</if>
<if @comments_installed_p@>
<include src="/packages/assessment/lib/comments-chunk" object_id="@session_id@" />
</if>
</master>