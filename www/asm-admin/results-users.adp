<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="/packages/assessment/lib/section-links" assessment_id="@assessment_id@" tab="results">
<p>@count_all_users@ users in community, @count_complete@ complete responses, @count_incomplete@ incomplete responses</p>
<listfilters name="results" style="inline-filters"></listfilters>
<listtemplate name="results"></listtemplate>

<if @assessment_data.anonymous_p@ eq t>
  <h3>#assessment.Responding_Users#</h3>
  <listtemplate name="subjects"></listtemplate>
</if>

