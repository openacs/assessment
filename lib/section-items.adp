<h3>#assessment.Items#</h3>

<formtemplate id="admin_section">
<table cellspacing=0>
<if @items:rowcount@ eq 0>
  <tr class="odd">
  <td></td><td>
    <a href="item-form?section_id=@section_id@&assessment_id=@assessment_id@&after=0">#assessment.Add_New#</a>
    <a href="item-add-existing?section_id=@section_id@&assessment_id=@assessment_id@&after=0">#assessment.Add_Existing#</a>
  </td></tr>
</if>

<multiple name="items">

  <if @items.rownum@ odd>
    <tr class="odd">
  </if>
  <else>
    <tr class="even">
  </else>

<td valign="top">@items.rownum@.<if @items.required_p@ eq t> <font color=red>*</font> </if></td>

<td><a href="item-form?as_item_id=@items.as_item_id@&section_id=@section_id@&assessment_id=@assessment_id@">#assessment.Edit#</a>

<if @items.enabled_p@ eq "f"><span style="color: #f00;">#assessment.disabled#</span></if>

<a href="item-copy?as_item_id=@items.as_item_id@&sort_order=@items.sort_order@">#assessment.Copy#</a>

<a href="item-form?section_id=@section_id@&assessment_id=@assessment_id@&after=@items.sort_order@">#assessment.Add_New#</a>

<a href="item-add-existing?section_id=@section_id@&assessment_id=@assessment_id@&after=@items.sort_order@">#assessment.Add_Existing#</a><img src="../graphics/spacer.gif" border="0" alt="" width="10">

<if @items.rownum@ lt @items:rowcount@>
  <a href="item-swap?section_id=@section_id@&assessment_id=@assessment_id@&sort_order=@items.sort_order@&direction=down"><img src="../graphics/down" border="0" alt="#assessment.Move_Down#"></a>
</if>
<if @items.rownum@ gt 1>
  <a href="item-swap?section_id=@section_id@&assessment_id=@assessment_id@&sort_order=@items.sort_order@&direction=up"><img src="../graphics/up.gif" border="0" alt="#assessment.Move_Up#"></a>
</if>
<a href="item-delete?as_item_id=@items.as_item_id@&section_id=@section_id@&assessment_id=@assessment_id@"><img src="../graphics/delete.gif" border="0" alt="#assessment.remove_item#"></a>

<if @items.max_time_to_complete@ not nil> (max. time allowed: @items.max_time_to_complete@) </if>
</td></tr>

  <if @items.rownum@ odd>
    <tr class="odd">
  </if>
  <else>
    <tr class="even">
  </else>
<td colspan="3">
  <blockquote>
    <if @items.presentation_type@ ne fitb>@items.title;noquote@<br></if>
    <if @items.presentation_type@ eq radio or @items.presentation_type@ eq checkbox>
      <formgroup id="response_to_item.@items.as_item_id@">
        @formgroup.widget;noquote@ @formgroup.label;noquote@<br>
      </formgroup>
    </if>
    <elseif @items.presentation_type@ eq fitb>
      @items.html;noquote@
    </elseif>
    <else>
      <formwidget id="response_to_item.@items.as_item_id@">
    </else>
  </blockquote>
</td></tr>

<if @items.rownum@ eq @items:rowcount@>
  <if @items.rownum@ odd>
    <tr class="even">
  </if>
  <else>
    <tr class="odd">
  </else>
  <td></td><td>
    <a href="item-form?section_id=@section_id@&assessment_id=@assessment_id@&after=@items:rowcount@">#assessment.Add_New#</a>
    <a href="item-add-existing?section_id=@section_id@&assessment_id=@assessment_id@&after=@items:rowcount@">#assessment.Add_Existing#</a>
  </td></tr>
</if>
</multiple>
</table>      
</formtemplate>
