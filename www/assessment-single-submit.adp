<master>
<property name="doc(title)">@assessment_data.html_title;literal@</property>
<property name="context">@context;literal@</property>

<table width="100%" cellpadding="3" cellspacing="0" border="0">
<tr><th colspan="3"><!-- @assessment_data.html_title;noquote@ --></th></tr>
<tr><td><em>@assessment_data.instructions;noquote@</em></td></tr>
<tr><td align="right">
<!--#assessment.section_counter#
<br>#assessment.item_counter#-->
<if @assessment_data.time_for_response@ not nil><br>#assessment.session_time_remaining#</if>
<if @section.max_time_to_complete@ not nil><br>#assessment.section_time_remaining#</if>
</td></tr>
<!--for future data of assessment-->
<tr>
<td colspan="3"><hr></td>
</tr>
</table>

<table border="0">
  <tr bgcolor="#d0d0d0"><td><strong>#assessment.section#: @section.title@ </strong></td></tr>
  <tr><td><em> @section.description@ </em><br></td></tr>
  <tr><td> @section.instructions;noquote@ <br></td></tr>
</table>

<br>&nbsp;&nbsp;
<strong>#assessment.Items#</strong><br><br>
<table border="0">


  <multiple name="items">
    <formtemplate id="show_item_form_@items.as_item_id@">
      <input type="hidden" name="as_item_id" value="@items.as_item_id@">
      <tr>
      <tr bgcolor="#e4eaef"><if @assessment_data.show_item_name_p;literal@ true><td colspan="2" nowrap><strong>@items.name@:<if @items.required_p;literal@ true> <span style="color: #f00;">*</span></if></strong></td></if>
        <td><strong><if @items.presentation_type@ ne fitb>@items.title;noquote@<if @assessment_data.show_item_name_p@ eq f and @items.required_p@ eq t> <span style="color: #f00;">*</span></if></if></strong></td></tr>
      <if @items.content@ not nil><tr><if @assessment_data.show_item_name_p;literal@ true><td colspan="4"></if><else><td colspan="3"></else>@items.content;noquote@</td></tr></if>

      <tr><if @assessment_data.show_item_name_p;literal@ true><td colspan="4"></if><else><td colspan="3"></else>
        <table>
          <tr class="form-widget">
          <if @items.description@ not nil><td valign="top">@items.description;noquote@</td></if><td>
          <if @items.presentation_type@ eq rb or @items.presentation_type@ eq cb>
            <formgroup id="response_to_item.@items.as_item_id@">
              <if @items.choice_orientation@ ne horizontal>
                @formgroup.widget;noquote@ @formgroup.label;noquote@<br>
              </if>
              <else>
                @formgroup.widget;noquote@ @formgroup.label;noquote@
              </else>
            </formgroup>
            <if @items.choice_orientation@ eq horizontal><br></if>
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
          <div class="form-error"><formerror id="response_to_item.@items.as_item_id@"></formerror></div>
          </td></tr><tr class="form-widget"><td>
            <if @items.submitted_p;literal@ false><br><input type="submit" value="#assessment.Submit#"></if>
          </td></tr></table>
        <hr>
      </td></tr>
    </formtemplate>
  </multiple>
  <if @required_count@ eq 0>
    <formtemplate id="show_item_form">
      <tr><td><input type="submit" value="#assessment.Next#"></td></tr>
    </formtemplate>
  </if>
  </table>
