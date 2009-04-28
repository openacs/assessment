<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="/packages/assessment/lib/section-links" assessment_id="@assessment_id@" tab="results">

<if @status_p@ eq 0>
<p>@count_all_users@ #assessment.users_in_community#, @count_complete@ #assessment.complete_responses#, @count_incomplete@ #assessment.incomplete_responses#</p>
</if>

<listfilters name="results" style="inline-filters"></listfilters>
<listtemplate name="results"></listtemplate>

<if @assessment_data.anonymous_p@ eq t>
  <h3>#assessment.Responding_Users#</h3>
  <listtemplate name="subjects"></listtemplate>
</if>

