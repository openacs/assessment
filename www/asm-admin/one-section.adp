<master>
<property name="doc(title)">@title;literal@</property>
<property name="context">@context;literal@</property>

<include src="/packages/assessment/lib/section-links" assessment_id="@assessment_id;literal@" tab="@section_id;literal@">

<h3>#assessment.Sections#</h3>

<table cellspacing="0">
<tr class="odd">
<td valign="top"><a name=@section_id@>@sort_order@. @name@</a></td></tr>
<tr class="odd">
<td>


<a class=button href="section-form?assessment_id=@assessment_id@&after=@sort_order@">#assessment.add_new_section#</a>

<a class=button href="catalog-search?assessment_id=@assessment_id@&after=@sort_order@">#assessment.Search_Section#</a>

<if @display_type_id@ not nil><a class=button href="section-display-form?assessment_id=@assessment_id@&amp;section_id=@section_id@&amp;display_type_id=@display_type_id@">#assessment.edit_section_display#</a></if>

<a class=button href="section-preview?assessment_id=@assessment_id@&amp;section_id=@section_id@">#assessment.section_preview#</a>

<a class=button href="checks-admin?assessment_id=@assessment_id@&amp;section_id=@section_id@">#assessment.admin_triggers#</a>

<a class=button href="add-edit-section-check?assessment_id=@assessment_id@&amp;section_id=@section_id@">#assessment.add_section_trigger#</a>


<if @max_time_to_complete@ not nil> (#assessment.max_time# @max_time_to_complete@) </if>
(@points@ #assessment.points#)
</td></tr>

    <tr class="odd">
    <tr class="even">
<td colspan="3">
    @title@ 
<img src="/resources/assessment/spacer.gif" border="0" alt="" width="10">
<a href="section-form?section_id=@section_id@&amp;assessment_id=@assessment_id@">#assessment.Edit#</a> 

<if @sort_order@ lt @max_sort_order@>
  <a href="section-swap?assessment_id=@assessment_id@&amp;sort_order=@sort_order@&amp;direction=down"><img src="/resources/assessment/down.gif" border="0" alt="#assessment.Move_Down#"></a>
</if>
<if @sort_order@ gt 1>
  <a href="section-swap?assessment_id=@assessment_id@&amp;sort_order=@sort_order@&amp;direction=up"><img src="/resources/assessment/up.gif" border="0" alt="#assessment.Move_Up#"></a>
</if>

<a href="section-delete?section_id=@section_id@&amp;assessment_id=@assessment_id@"><img src="/resources/acs-subsite/Delete16.gif" border="0" alt="#assessment.remove_section#"></a>

</td></tr>
</table>      

  <include src="/packages/assessment/lib/section-items" assessment_id="@assessment_id;literal@" section_id="@section_id;literal@">

</multiple>
