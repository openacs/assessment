<master>
<property name="title">Assessment</property>
<property name="context">@context;noquote@</property>

<table width="100%" cellpadding="3" cellspacing="0" border="0">
<tr><th colspan="3">@assessment_data.title@</th></tr>
<tr><td><i><font size="1">@assessment_data.instructions@</font></i></td></tr>
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

<if @display.submit_answer_p@ eq f>
  <formtemplate id="show_item_form">
      <input type="hidden" name="session_id" value="@session_id@">

      <multiple name="items">
      <tr>
      <tr bgcolor="#e4eaef"><td colspan="2" nowrap><b><if @assessment_data.show_item_name_p@ eq t>@items.name@:</if><else>#assessment.Question# @items.rownum@:</else></b></td>
        <td><b><if @items.presentation_type@ ne fitb>@items.title;noquote@</if></b></td></tr>
      <tr><td colspan="4">
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

        </blockquote>
        <hr>
      </td></tr>
      </multiple>

  </table>
  <table align="center"><tr><td><input type=submit value="#assessment.Submit#"></td></tr></table>

  </formtemplate>
</if><else>
  <multiple name="items">
    <formtemplate id="show_item_form_@items.as_item_id@">
      <input type="hidden" name="session_id" value="@session_id@">
      <input type="hidden" name="section_order" value="@old_section_order@">
      <input type="hidden" name="item_order" value="@old_item_order@">
      <input type="hidden" name="as_item_id" value="@items.as_item_id@">
      <tr>
      <tr bgcolor="#e4eaef"><td colspan="2" nowrap><b><if @assessment_data.show_item_name_p@ eq t>@items.name@:</if><else>#assessment.Question# @items.rownum@:</else></b></td>
        <td><b><if @items.presentation_type@ ne fitb>@items.title;noquote@</if></b></td></tr>
      <tr><td colspan="4">
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
          <if @items.submitted_p@ eq f><br><input type=submit value="#assessment.Submit#"></if>
        </blockquote>
        <hr>
      </td></tr>
    </formtemplate>
  </multiple>
  <formtemplate id="show_item_form">
    <input type="hidden" name="session_id" value="@session_id@">
    <tr><td><input type=submit value="#assessment.Next#"></td></tr>
  </formtemplate>
  </table>
</else>
