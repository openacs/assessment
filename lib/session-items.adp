<formtemplate id="session_results_@section_id@">
<table cellspacing=0>

<multiple name="items">

  <if @items.rownum@ odd>
    <tr class="odd">
  </if>
  <else>
    <tr class="even">
  </else>

  <td valign="top"><b><if @show_item_name_p@ eq t>@items.name@:</if><else>#assessment.Question# @items.rownum@:</else></b></td></tr>

  <if @items.rownum@ odd>
    <tr class="odd">
  </if>
  <else>
    <tr class="even">
  </else>

<td>
<if @items.result_points@ not nil><b>@items.result_points@ / @items.points@ #assessment.points#</b></if>
<else><b>#assessment.not_yet_reviewed#</b></else>

<if @items.max_time_to_complete@ not nil> (#assessment.max_time# @items.max_time_to_complete@) </if>
</td></tr>

  <if @items.rownum@ odd>
    <tr class="odd">
  </if>
  <else>
    <tr class="even">
  </else>
<td>
  <blockquote>
    <if @items.presentation_type@ ne fitb>@items.title;noquote@<br></if>
    <if @items.presentation_type@ eq rb or @items.presentation_type@ eq cb>
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
    <if @items.subtext@ not nil>
      <div class="form-help-text">
      <img src="/shared/images/info.gif" width="12" height="9" alt="[i]" title="Help text" border="0">
      <noparse>@items.subtext@</noparse>
      </div>
    </if>
  </blockquote>
</td></tr>

</multiple>
</table>      
</formtemplate>
