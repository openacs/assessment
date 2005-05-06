<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<table width="100%" cellpadding="3" cellspacing="0" border="0">
<tr><th colspan="3">@assessment_data.title@</th></tr>
<tr><td><i><font size="1">@assessment_data.instructions;noquote@</font></i></td></tr>
<tr><td align=right>
#assessment.section_counter#
<br>#assessment.item_counter#
<if @assessment_data.time_for_response@ not nil><br>#assessment.session_time_remaining#</if>
<if @section.max_time_to_complete@ not nil><br>#assessment.section_time_remaining#</if>
</td></tr>
<!--for future data of assessment-->
<tr>
<td colspan="3"><hr></td>
</tr>
</table>

<table border="0">
  <tr bgcolor="#d0d0d0"><td><b>@section.title@</b></td></tr>
  <tr><td><i>@section.description@</i></td></tr>
  <tr><td>@section.instructions@</td></tr>
</table>

<table border="0">


  <formtemplate id="show_item_form">

      <multiple name="items">
      <tr>
      <tr><if @assessment_data.show_item_name_p@ eq t><td bgcolor="#e4eaef" colspan="2" nowrap><b>@items.name@:</b><if @items.required_p@ eq t> <span style="color: #f00;">*</span></if></td></if>
        <td bgcolor="#e4eaef"><b><if @items.presentation_type@ ne fitb>@items.title;noquote@<if @assessment_data.show_item_name_p@ eq f and @items.required_p@ eq t> <span style="color: #f00;">*</span></if></if></b>
      <if @items.content@ not nil><tr><td bgcolor="#e4eaef" colspan="4"><br>@items.content;noquote@</if>
      <if @items.title@ ne @items.next_title@>
        </td></tr>
        <tr class="form-widget"><if @assessment_data.show_item_name_p@ eq t><td colspan=4></if><else><td colspan=3></else>
          <blockquote><table>
      </if>
      <else>
        <td><blockquote><table>
      </else>
<group column=title>
          <tr class="form-widget">
          <if @items.presentation_type@ eq rb or @items.presentation_type@ eq cb>
            <if @items.title@ eq @items.next_title@ and @items.groupnum@ eq 1>
              <td></td>
              <formgroup id="response_to_item.@items.as_item_id@">
                <td align=center>@formgroup.label;noquote@</td>
              </formgroup>
              </tr><tr class="form-widget">
            </if>
          </if>
          <td valign=top>@items.description;noquote@</td>
          <if @items.presentation_type@ eq rb or @items.presentation_type@ eq cb>
            <if @items.choice_orientation@ ne horizontal>
              <td><formgroup id="response_to_item.@items.as_item_id@">
                @formgroup.widget;noquote@ @formgroup.label;noquote@<br>
              </formgroup>
            </if>
            <elseif @items.title@ ne @items.next_title@ and @items.groupnum@ eq 1>
              <td><formgroup id="response_to_item.@items.as_item_id@">
                @formgroup.widget;noquote@ @formgroup.label;noquote@
              </formgroup>
              <br>
            </elseif>
            <else>
              <formgroup id="response_to_item.@items.as_item_id@">
                <td align=center>@formgroup.widget;noquote@</td>
              </formgroup>
              </tr><tr><td></td><td colspan=10>
            </else>
          </if>
          <elseif @items.presentation_type@ eq fitb>
            <td>@items.html;noquote@
          </elseif>
          <else>
            <td colspan=10><formwidget id="response_to_item.@items.as_item_id@">
          </else>

          <if @items.subtext@ not nil>
            <div class="form-help-text">
              <img src="/shared/images/info.gif" width="12" height="9" alt="[i]" title="Help text" border="0">
              <noparse>@items.subtext@</noparse>
            </div>
          </if>

          <div class="form-error"><formerror id="response_to_item.@items.as_item_id@"></formerror></div>
</td></tr>
</group></table>

        </blockquote>
        </td></tr>
        <tr><td colspan=4><hr></td></tr>
      </multiple>

  </table>
  <table align="center"><tr><td><input type=submit value="#assessment.Submit#"></td></tr></table>

  </formtemplate>
