<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<include src="/packages/assessment/lib/section-links" assessment_id="@assessment_id;literal@" tab="results">

<if @status_p;literal@ false>
<p>@count_all_users@ #assessment.users_in_community#, @count_complete@ #assessment.complete_responses#, @count_incomplete@ #assessment.incomplete_responses#</p>
</if>

<listfilters name="results" style="inline-filters"></listfilters>
<listtemplate name="results"></listtemplate>

<if @assessment_data.anonymous_p;literal@ true>
  <h3>#assessment.Responding_Users#</h3>
  <listtemplate name="subjects"></listtemplate>
</if>

