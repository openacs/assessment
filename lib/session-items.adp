<formtemplate id="session_results_@section_id@">
<table cellspacing=0>
<if @items:rowcount@ eq 0>
  <tr><td>#assessment.not_answered#</td></tr>
</if>

<multiple name="items">

  <if @items.rownum@ odd>
    <tr class="odd">
  </if>
  <else>
    <tr class="even">
  </else>

  <td valign="top"><b><if @show_item_name_p@ eq t>@items.name@:</if><else>#assessment.Question# @items.rownum@:</else></b>
  <if @items.max_time_to_complete@ not nil> (#assessment.max_time# @items.max_time_to_complete@) </if></td></tr>

  <if @items.rownum@ odd>
    <tr class="odd">
  </if>
  <else>
    <tr class="even">
  </else>

<td>
<if @survey_p@ ne t>
    <if @items.result_points@ not nil><b>@items.result_points@ / @items.points@ #assessment.points#
    <if @show_feedback@ ne none>
        <if @items.feedback@ not nil>: @items.feedback;noquote@</b></if>
    </if>	
    </b>
    </if>
    <else>
      <if @items.answered_p@ eq t><b>#assessment.not_yet_reviewed#</b> </if>
      <else><b>#assessment.not_answered#</b> </else>
    </else>
    <if @edit_p@ eq 1 and @items.answered_p@ eq t><a href="results-edit?session_id=@session_id@&section_id=@section_id@&as_item_id=@items.as_item_id@">#assessment.Edit#</a></if>
    <include src="/packages/assessment/lib/results-messages" session_id="@session_id@" section_id="@section_id@" as_item_id="@items.as_item_id@">
</if>
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
