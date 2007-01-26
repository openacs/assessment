<formtemplate id="admin_section">
<if @items:rowcount@ eq 0>
    <a href="item-add?section_id=@section_id@&assessment_id=@assessment_id@&after=0">#assessment.Add_New#</a>
    <a href="catalog-search?section_id=@section_id@&assessment_id=@assessment_id@&after=0">#assessment.Search_Item#</a>
</if>

<multiple name="items">

<a name=@items.as_item_id@><h4>#assessment.Question_Number#</h4>

<if @assessment_data.type@ ne 1>

    <a class="button" href="item-edit?as_item_id=@items.as_item_id@&section_id=@section_id@&assessment_id=@assessment_id@">#assessment.Edit#</a>
    <a class="button" href="item-copy?section_id=@section_id@&assessment_id=@assessment_id@&as_item_id=@items.as_item_id@&after=@items.sort_order@">#assessment.Copy#</a>
<a class=button href="item-add?section_id=@section_id@&assessment_id=@assessment_id@&after=@items.sort_order@">#assessment.Add_New#</a>

<a class=button href="catalog-search?section_id=@section_id@&assessment_id=@assessment_id@&after=@items.sort_order@">#assessment.Search_Item#</a>
    <img src="/resources/assessment/spacer.gif" border="0" alt="" width="10">
<if @items.rownum@ lt @items:rowcount@>
    <a href="item-swap?section_id=@section_id@&assessment_id=@assessment_id@&sort_order=@items.sort_order@&direction=down"><img src="/resources/assessment/down.gif" border="0" alt="#assessment.Move_Down#"></a>
</if>
    <if @items.rownum@ gt 1>
   <a href="item-swap?section_id=@section_id@&assessment_id=@assessment_id@&sort_order=@items.sort_order@&direction=up"><img src="/resources/assessment/up.gif" border="0" alt="#assessment.Move_Up#"></a>
 </if>
<a href="item-delete?as_item_id=@items.as_item_id@&section_id=@section_id@&assessment_id=@assessment_id@"><img src="/resources/acs-subsite/Delete16.gif" border="0" alt="#assessment.remove_item#"></a>


<if @items.max_time_to_complete@ not nil> (#assessment.max_time# @items.max_time_to_complete@) </if>
(@items.points@ #assessment.points#)
<if @items.item_type@ eq "mc" and @admin_trigger_p@>
<a class=button href="../asm-admin/add-edit-check?as_item_id=@items.as_item_id@&section_id=@section_id@&assessment_id=@assessment_id@&after=@items.sort_order@">#assessment.add_trigger#</a> (<a href="../asm-admin/checks-admin?section_id=@items.section_id@&assessment_id=@assessment_id@&item_id=@items.as_item_id@">@items.checks_related@</a>)<img src="/resources/assessment/spacer.gif" border="0" alt="" width="10">
</if>

    <if @items.presentation_type@ ne fitb><p>@items.question_text;noquote@</p>

<if @items.description@ not nil>@items.description;noquote@<br></if></if>

    <if @items.presentation_type@ eq rb or @items.presentation_type@ eq cb>
      <if @items.choice_orientation@ ne horizontal>
        <formgroup id="response_to_item.@items.as_item_id@">
          @formgroup.widget;noquote@ @formgroup.label;noquote@<br>
        </formgroup>
      </if>
      <else>
        <formgroup id="response_to_item.@items.as_item_id@">
          @formgroup.widget;noquote@ @formgroup.label;noquote@
        </formgroup>
        <br>
      </else>
    </if>
    <elseif @items.presentation_type@ eq fitb>
      @items.html;noquote@
    </elseif>
    <else>
      <formwidget id="response_to_item.@items.as_item_id@">
    </else>
    <if @items.subtext@ not nil>
      <div class="form-help-text">
      <img src="/shared/images/info.gif" width="12" height="9" alt="[i]" title="Help text" border="0">
      <noparse>@items.subtext@</noparse>
      </div>
    </if>

    <a href="item-add?section_id=@section_id@&assessment_id=@assessment_id@&after=@items:rowcount@">#assessment.Add_New#</a>
    <a href="catalog-search?section_id=@section_id@&assessment_id=@assessment_id@&after=@items:rowcount@">#assessment.Search_Item#</a>
</if>
</multiple>
</formtemplate>
