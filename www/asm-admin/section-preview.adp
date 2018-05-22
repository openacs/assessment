<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context_bar">@context_bar;literal@</property>

<table width="100%" cellpadding="3" cellspacing="0" border="0">
<tr><th colspan="3">@assessment_data.title@</th></tr>
<tr><td><em style="font-size: 1pt;">@assessment_data.instructions;noquote@</em></td></tr>
<tr>
<td colspan="3"><hr></td>
</tr>
</table>

<table border="0">
  <tr style="background-color: #d0d0d0;"><td><strong>@section.title@</strong></td></tr>
  <tr><td><em>@section.description@</em></td></tr>
  <tr><td>@section.instructions@</td></tr>
</table>

<table border="0">


  <formtemplate id="section_preview_form">

      <multiple name="items">
      <tr>
      <tr><if @assessment_data.show_item_name_p;literal@ true><td bgcolor="#e4eaef" colspan="2" nowrap><strong>@items.name@:</strong><if @items.required_p;literal@ true> <span style="color: #f00;">*</span></if></td></if>
        <td bgcolor="#e4eaef"><strong><if @items.presentation_type@ ne fitb>@items.title;noquote@<if @assessment_data.show_item_name_p;literal@ false and @items.required_p;literal@ true> <span style="color: #f00;">*</span></if></if></strong>
      <if @items.content@ not nil><tr><td bgcolor="#e4eaef" colspan="4"><br>@items.content;noquote@</if>
      <if @items.title@ ne @items.next_title@>
        </td></tr>
        <tr class="form-widget"><if @assessment_data.show_item_name_p;literal@ true><td colspan="4"></if><else><td colspan="3"></else>
          <table>
      </if>
      <else>
        <td><table>
      </else>
<group column=title>
          <tr class="form-widget">
          <if @items.presentation_type@ eq rb or @items.presentation_type@ eq cb>
            <if @items.title@ eq @items.next_title@ and @items.groupnum@ eq 1>
              <td></td>
              <formgroup id="response_to_item.@items.as_item_id@">
                <td align="center">@formgroup.label;noquote@</td>
              </formgroup>
              </tr><tr class="form-widget">
            </if>
          </if>
          <td valign="top">@items.description;noquote@</td>
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
                <td align="center">@formgroup.widget;noquote@</td>
              </formgroup>
              </tr><tr><td></td><td colspan="10">
            </else>
          </if>
          <elseif @items.presentation_type@ eq fitb>
            <td>@items.html;noquote@
          </elseif>
          <else>
            <td colspan="10"><formwidget id="response_to_item.@items.as_item_id@">
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

        </td></tr>
        <tr><td colspan="4"><hr></td></tr>
      </multiple>

  </table>
  </formtemplate>
