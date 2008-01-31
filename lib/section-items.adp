<formtemplate id="admin_section">
<if @items:rowcount@ eq 0>
    <div>
    <a href="@item_add_url@">#assessment.Add_New#</a>
    <a href="@catalog_search_url@">#assessment.Search_Item#</a>
    </div>
</if>

<multiple name="items">

<h4><a name="Q@items.as_item_id@">#assessment.Question_Number#</a></h4>

<if @assessment_data.type@ ne 1>

    <div><a class="button" href="@item_edit_general_url@">#assessment.Edit#</a>
    <a class="button" href="@item_copy_url@">#assessment.Copy#</a>
    <a class=button href="@item_add_url@">#assessment.Add_New#</a>
    <a class=button href="@catalog_search_url@">#assessment.Search_Item#</a>
    <img src="/resources/assessment/spacer.gif" style="border: 0;" alt="" width="10">
    <if @items.rownum@ lt @items:rowcount@>
        <a href="@item_swap_down_url@"><img src="/resources/assessment/down.gif" style="border: 0;" alt="#assessment.Move_Down#"></a>
    </if>
    <if @items.rownum@ gt 1>
        <a href="@item_swap_up_url"><img src="/resources/assessment/up.gif" style="border: 0;" alt="#assessment.Move_Up#"></a>
    </if>
    <a href="@item_delete_url@"><img src="/resources/acs-subsite/Delete16.gif" style="border: 0;" alt="#assessment.remove_item#"></a>

    <if @items.max_time_to_complete@ not nil> (#assessment.max_time# @items.max_time_to_complete@) </if>
    (@items.points@ #assessment.points#)
    <if @items.item_type@ eq "mc" and @admin_trigger_p@>
    <a class=button href="@add_edit_check_url@">#assessment.add_trigger#</a> (<a href="@check_admin_url@">@items.checks_related@</a>)<img src="/resources/assessment/spacer.gif" style="border: 0;" alt="" width="10">
    </if>
    </div>

    <if @items.presentation_type@ ne fitb><p>@items.question_text;noquote@</p>
<div>
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
</div>
    <if @items.subtext@ not nil>
      <div class="form-help-text">
      <img src="/shared/images/info.gif" width="12" height="9" alt="[i]" title="Help text" style="border: 0;">
      <noparse>@items.subtext@</noparse>
      </div>
    </if>
</if>
</multiple>
</formtemplate>
