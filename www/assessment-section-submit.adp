<master>
<property name="title">@assessment_data.html_title;noquote@</property>
<property name="context">@context;noquote@</property>
<property name="header_stuff"><link rel="stylesheet" type="text/css" href="/resources/assessment/crbForms.css" media="all"></property>


<!-- Pretty output starts here -->

  <if @assessment_data.html_title@ not nil><h2>@assessment_data.html_title;noquote@</h2></if>
  <if @assessment_data.instructions@ not nil><p>@assessment_data.instructions;noquote@</p></if>

  <if @assessment_data.time_for_response@ not nil><br>#assessment.session_time_remaining#</if>
  <if @section.max_time_to_complete@ not nil><br>#assessment.section_time_remaining#</if>

  <fieldset style="padding:10px;margin-bottom:10px"><!-- Section FieldSet -->
    <legend><b>@section.title@</b></legend>
    <if @section.description@ not nil><p>@section.description;noquote@</p></if>    
    <if @section.instructions@ not nil><p>@section.instructions;noquote@</p></if>

     <formtemplate id="show_item_form">
     <multiple name="items">
       <!-- Item begin -->
       <if @assessment_data.show_item_name_p@ eq t><p><b>@items.name@:</b><if @items.required_p@ eq t> <span style="color: #f00;">*</span></if></p></if>
       <div class="question-container" style="margin-bottom:25px">
         <if @items.presentation_type@ ne fitb><b>@items.title;noquote@<if @assessment_data.show_item_name_p@ eq f and @items.required_p@ eq t> <span style="color: #f00;">*</span></if></b></if>
         <if @items.content@ not nil><p>@items.content;noquote@</p></if>
     
<group column=title>
         <div class="form-widget">

           <if @items.presentation_type@ eq rb or @items.presentation_type@ eq cb>
             <if @items.title@ eq @items.next_title@ and @items.groupnum@ eq 1>
               <if @items.presentation_type@ eq @items.next_pr_type@ or @items.choice_orientation@ eq horizontal>
                 <formgroup id="response_to_item.@items.as_item_id@">
                   @formgroup.label;noquote@
                 </formgroup>
               </if>
             </if>
           </if>

           <if @items.presentation_type@ eq rb or @items.presentation_type@ eq cb>
             <fieldset class="radio">
               <if @items.choice_orientation@ ne horizontal>
                 <formgroup id="response_to_item.@items.as_item_id@">
                   @formgroup.widget;noquote@ @formgroup.label;noquote@<br>
                 </formgroup>
               </if>
               <elseif @items.title@ ne @items.next_title@ and @items.groupnum@ eq 1>
                 <formgroup id="response_to_item.@items.as_item_id@">
                   @formgroup.widget;noquote@ @formgroup.label;noquote@
                 </formgroup>
                 <br>
               </elseif>
               <else>
                 <formgroup id="response_to_item.@items.as_item_id@">
                   @formgroup.widget;noquote@
                 </formgroup>
               </else>
             </fieldset>
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
         </div><!--Form-Widget-->
</group>
       </div><!-- End "question-container" -->

    </multiple>
    <input type=submit value="#assessment.Submit#">
  </formtemplate>
</fieldset><!-- End Section FieldSet -->
<!--<div style="clear: both;" />-->