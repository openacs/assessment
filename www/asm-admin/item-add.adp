<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>
<formtemplate id="item-add" style="accessible-forms">
<!-- Form elements -->
<fieldset>
<legend>#assessment.Question#</legend>
  <formwidget id="__confirmed_p"><formwidget id="__refreshing_p"><formwidget id="assessment_id"><formwidget id="section_id"><formwidget id="after"><formwidget id="type"><formwidget id="__key_signature"><formwidget id="__new_p"><formwidget id="as_item_id"><formwidget id="num_choices">
      <br>
        
              <if @formerror.question_text@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="question_text">
              #assessment.Item_Question#
            </label>
            <span class="form-required-mark">*</span>
          </span>
          
            <if @formerror.question_text@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="question_text">
            </span>
              <formerror id="question_text">
              <span class="form-error">
              <br>
                  @formerror.question_text;noquote@
              </span>
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="question_text">
              
            </p>
          
      <br>
        
              <if @formerror.required_p@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="required_p">
              #assessment.Required#
            </label>
            
          </span>
          
            <if @formerror.required_p@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="required_p">
            </span>
            <formerror id="required_p">
              <br>
                  @formerror.required_p;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="required_p">
              
            </p>
          
      <br>
        
              <if @formerror.feedback_right@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="feedback_right">
              #assessment.Feedback_right#
            </label>
            
          </span>
          
            <if @formerror.feedback_right@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="feedback_right">
            </span>
            <formerror id="feedback_right">
              <br>
                  @formerror.feedback_right;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="feedback_right">
              
            </p>
          
      <br>
        
              <if @formerror.feedback_wrong@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="feedback_wrong">
              #assessment.Feedback_wrong#
            </label>
            
          </span>
          
            <if @formerror.feedback_wrong@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="feedback_wrong">
            </span>
            <formerror id="feedback_wrong">
              <br>
                  @formerror.feedback_wrong;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="feedback_wrong">
            </p>

           <if @formerror.points@ not nil>
            <span class="form-label-error">
          </if>
          <else>
            <span class="form-label">
          </else>
             <label for="points">
              #assessment.Points#
             </label>
           </span>
           <if @formerror.points@ not nil>
             <span class="form-widget-error">
           </if>
           <else>
            <span class="form-widget">
           </else>
             <formwidget id="points">
             </span>
             <formerror id="points">
             <br>
               @formerror.points;noquote@
            </formerror>
            <p class="form-help-text">
              <formhelp id="points">
           </p>
          <br>

</fieldset>        
<fieldset>
        <legend>
              #assessment.Question_Type#
            <span class="form-required-mark">*</span>
        </legend>

            <if @formerror.item_type@ not nil>
              <div class="form-widget-error">
            </if>
            <else>
              <div class="form-widget">                  
            </else>

            <formerror id="item_type">
              <span class="form-error">
                  <br>
                  @formerror.item_type;noquote@
              </span>
            </formerror>

<div style="float:right; width: 40%;">        <fieldset>
        <legend>#assessment.Multiple_Choice#</legend>
<p class="form-help-text">       #assessment.item_type_multiple_choice_help#</p>
        <formgroup-widget id="item_type" row=2></formgroup-widget><br>
        <formgroup-widget id="item_type" row=5></formgroup-widget>
           
       <p><span class="form-label">#assessment.Correct_Answer#</span><br>
        <multiple name="choice_elements">
       <formgroup id="correct.@choice_elements.id@">
                @formgroup.widget;noquote@
           </formgroup>
&nbsp;&nbsp;<formwidget id="choice.@choice_elements.id@"><br>
</multiple></p>
       <formgroup id="save_answer_set">
                @formgroup.widget;noquote@
                <label for="item-add:elements:save_answer_set:t">#assessment.Save_this_set_of_answers_for_reuse_later#</label><br>
           </formgroup>

<formwidget id="formbutton_add_another_choice"><br>
<if @choice_sets@ not nil><p>#assessment.Or_use_choices_from_an_existing_question#<br>
<formwidget id="add_existing_mc_id">
</p></if>
<br>
</fieldset>        
</div>
<div>
<fieldset>
<legend>#assessment.Short_Answer#</legend>
<p class="form-help-text">       #assessment.item_type_short_answer_help#</p>
        <formgroup-widget id="item_type" row="4"></formgroup-widget>
</fieldset>
<fieldset>
<legend>#assessment.Long_Answer#</legend>
<p class="form-help-text">       #assessment.item_type_long_answer_help#</p>
        <formgroup-widget id="item_type" row="3"></formgroup-widget>
<br>
            <label for="reference_answer">
              #assessment.Reference_Answer#
            </label>	<formwidget id="reference_answer">
<p class="form-help-text">        <formhelp id="reference_answer"></p>
</fieldset>
<fieldset>
<legend>#assessment.File_Upload#</legend>
<p class="form-help-text">        #assessment.item_type_file_upload_help#</p>
<formgroup-widget id="item_type" row="1"></formgroup-widget>
</fieldset>
</div>
</div>
</fieldset>
          <div class="form-element">
            <formwidget id="formbutton_ok">            <formwidget id="formbutton_add_another_question">
          </div>

</formtemplate>
