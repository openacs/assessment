
<property name="doc(title)">@assessment_data.html_title;literal@</property>
<property name="context">@context;literal@</property>


<!-- Pretty output starts here -->
<if @show_title_p@ true and @assessment_data.html_title@ not nil><h2>@assessment_data.html_title;noquote@</h2></if>
  <if @assessment_data.instructions@ not nil><p>@assessment_data.instructions;noquote@</p></if>

  <if @assessment_data.time_for_response@ not nil><br>#assessment.session_time_remaining#</if>
  <if @section.max_time_to_complete@ not nil><br>#assessment.section_time_remaining#</if>

  <if @progress_bar_list@ defined>
  <include src="/packages/acs-tcl/lib/static-progress-bar" total="@total_pages;literal@" current="@current_page;literal@" >
  </if>

  <if @form_is_submit@ true and @form_is_valid@ false>
  <div class="form-error">#assessment.There_was_a_problem_with_your_answers#</div>
  </if>

<if @show_title_p;literal@ true><h2>@section.title@</h2></if>
    <if @section.description@ not nil><p>@section.description;noquote@</p></if>    
    <if @section.instructions@ not nil><p>@section.instructions;noquote@</p></if>


     <formtemplate id="show_item_form">
     <multiple name="items">
       <!-- Item begin -->
       <if @assessment_data.show_item_name_p;literal@ true><p><strong>@items.name@:</strong><if @items.required_p;literal@ true> <span style="color: #f00;">*</span></if></p></if>
       <div class="question-container" style="margin-bottom:25px">
         <if @items.description@ not nil><p>@items.description;noquote@</p></if>
         <if @items.content@ not nil><p>@items.content;noquote@</p></if>
         <if @items.presentation_type@ ne fitb><strong>@items.question_text;noquote@<if @assessment_data.show_item_name_p@ eq f and @items.required_p@ eq t> <span style="color: #f00;">*</span></if></strong></if>
     
<group column=as_item_id>
         <div class="form-widget">

           <if @items.presentation_type@ eq rb or @items.presentation_type@ eq cb>
             <if @items.as_item_id@ eq @items.next_as_item_id@ and @items.groupnum@ eq 1>
               <if @items.presentation_type@ eq @items.next_pr_type@ or @items.choice_orientation@ eq horizontal>
                 <formgroup id="response_to_item.@items.as_item_id@">
                   <label for="show_item_form:elements:response_to_item.@items.as_item_id@:@formgroup.option@">@formgroup.label;noquote@</label>
                 </formgroup>
               </if>
             </if>
           </if>

           <if @items.presentation_type@ eq rb or @items.presentation_type@ eq cb>
               <if @items.choice_orientation@ ne horizontal>
                 <formgroup id="response_to_item.@items.as_item_id@">
                   @formgroup.widget;noquote@ 
<label for="show_item_form:elements:response_to_item.@items.as_item_id@:@formgroup.option@">
@formgroup.label;noquote@<br>
</label>
                 </formgroup>
               </if>
               <elseif @items.as_item_id@ ne @items.next_as_item_id@ and @items.groupnum@ eq 1>
                 <formgroup id="response_to_item.@items.as_item_id@">
                   @formgroup.widget;noquote@ <label for="show_item_form:elements:response_to_item.@items.as_item_id@:@formgroup.option@">@formgroup.label;noquote@</label>
                 </formgroup>
                 <br>
               </elseif>
               <else>
                 <formgroup id="response_to_item.@items.as_item_id@">
                   @formgroup.widget;noquote@
                 </formgroup>
               </else>
           </if>
          <elseif @items.presentation_type@ eq "rbo" or @items.presentation_type@ eq "cbo">
	<fieldset class="radio">
             <formwidget id="response_to_item.@items.as_item_id@">
	</fieldset>
	</elseif>
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
	<p>#assessment.This_is_a_required#</p>
    <div><input type="submit" value="#assessment.Submit#"></div>
  </formtemplate>

<!--<div style="clear: both;" />-->