<master>
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<table width="100%" cellpadding="3" cellspacing="0" border="0">
<tr><th colspan="3">@assessment_data.title@</th></tr>
<tr><td><i><font size="1">@assessment_data.instructions@</font></i></td></tr>
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
  <tr bgcolor="#d0d0d0"><td><b>#assessment.section#: @section.title@ </b></td></tr>
  <tr><td><i> @section.description@ </i><br></td></tr>
  <tr><td> @section.instructions@ <br></td></tr>
</table>

<br>&nbsp;&nbsp;
<b>#assessment.Items#</b><br><br>
<table border="0">


  <formtemplate id="show_item_form">

      <multiple name="items">
      <tr>
      <tr bgcolor="#e4eaef"><td colspan="2" nowrap><b><if @assessment_data.show_item_name_p@ eq t>@items.name@:</if><else>#assessment.Question# @items.rownum@:</else></b><if @items.required_p@ eq t> <span style="color: #f00;">*</span></if></td>
        <td><b><if @items.presentation_type@ ne fitb>@items.title;noquote@</if></b></td></tr>
      <if @items.content@ not nil><tr><td colspan="4">@items.content;noquote@</td></tr></if>

      <tr class="form-widget"><td colspan="4">
        <blockquote>
          <if @items.presentation_type@ eq rb or @items.presentation_type@ eq cb>
            <formgroup id="response_to_item.@items.as_item_id@">
              @formgroup.widget;noquote@
              @formgroup.label;noquote@
              <br>
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

          <div class="form-error"><formerror id="response_to_item.@items.as_item_id@"></formerror></div>

        </blockquote>
        <hr>
      </td></tr>
      </multiple>

  </table>
  <table align="center"><tr><td><input type=submit value="#assessment.Submit#"></td></tr></table>

  </formtemplate>
