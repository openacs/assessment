<master>
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>


<multiple name="sections">

<h3>#assessment.Selected_Sections#</h3>

<table cellspacing=0>
<tr class="odd">
<td valign="top">@sections.rownum@. @sections.name@
<if @sections.max_time_to_complete@ not nil> (#assessment.max_time# @sections.max_time_to_complete@) </if>
(@sections.points@ #assessment.points#)
</td></tr>

  <if @sections.rownum@ odd>
    <tr class="odd">
  </if>
  <else>
    <tr class="even">
  </else>
<td>
  <blockquote>
    @sections.title@
  </blockquote>
</td></tr>
</table>      

<blockquote>
  <include src="/packages/assessment/lib/section-show" assessment_id="@assessment_id@" section_id="@sections.section_id@">
</blockquote>

</multiple>

