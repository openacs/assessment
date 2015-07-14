<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>


<multiple name="sections">

<h3>#assessment.Selected_Sections#</h3>

<table cellspacing="0">
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
    @sections.title@
</td></tr>
</table>      

  <include src="/packages/assessment/lib/section-show" assessment_id="@assessment_id;literal@" section_id="@sections.section_id;literal@">

</multiple>

<formtemplate id="catalog_section_add"></formtemplate>
