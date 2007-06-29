<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>
<property name="header_stuff"><style>.form-label {text-align:left;} .form-label label {font-weight:bold;}</style></property>
<formtemplate id="item-add" style="accessible-forms">
<!-- Form elements -->
<fieldset>
<legend>Question</legend>
  <formwidget id=__confirmed_p><formwidget id=__refreshing_p><formwidget id=assessment_id><formwidget id=section_id><formwidget id=after><formwidget id=type><formwidget id=__key_signature><formwidget id=__new_p><formwidget id=as_item_id><formwidget id="num_choices">
      <br>
        
              <if @formerror.question_text@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="question_text">
              Item Question
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
              Required
            </label>
            
          </span>
          
            <if @formerror.required_p@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="required_p">
            
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
              Feedback right
            </label>
            
          </span>
          
            <if @formerror.feedback_right@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="feedback_right">
            
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
              Feedback wrong
            </label>
            
          </span>
          
            <if @formerror.feedback_wrong@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="feedback_wrong">
            
            <formerror id="feedback_wrong">
              <br>
                  @formerror.feedback_wrong;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="feedback_wrong">
              </span>
            </p>

           <if @formerror.points@ not nil>
            <span class="form-label-error">
          </if>
          <else>
            <span class="form-label">
          </else>
             <label for="points">
              Points
             </label>
           </span>
           <if @formerror.points@ not nil>
             <span class="form-widget-error">
           </if>
           <else>
            <span class="form-widget">
           </else>
             <formwidget id=points>
             <formerror id="points">
             <br>
               @formerror.points;noquote@
            </formerror>
            <p class="form-help-text">
              <formhelp id="points">
           </p>
          </br>
         </span>

</fieldset>        
<fieldset>              <if @formerror.item_type@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="item_type">
              #assessment.Question_Type#
            </label>
            <span class="form-required-mark">*</span>
          </span>

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
        <legend>Multiple Choice</legend>
<p class="form-help-text">       #assessment.item_type_multiple_choice_help#</p>
        <formgroup-widget id="item_type" row=2></formgroup-widget><br />
        <formgroup-widget id="item_type" row=5></formgroup-widget>
           
       <p><span class="form-label">Correct<br>Answer</span><br>
        <multiple name="choice_elements">
       <formgroup id="correct.@choice_elements.id@">
                @formgroup.widget;noquote@
           </formgroup>
&nbsp;&nbsp;<formwidget id="choice.@choice_elements.id@"><br />
</multiple></p>
<formwidget id="save_answer_set"> <label for="save_answer_set">#assessment.Save_this_set_of_answers_for_reuse_later#</label><br />
<formwidget id="formbutton_add_another_choice"><br />
<if @choice_sets@ not nil><p>Or use choices from an existing question<br />
<formwidget id="add_existing_mc_id">
</p></if>
<br />
</fieldset>        
</div>
<div>
<fieldset>
<legend>Short Answer</legend>
<p class="form-help-text">       #assessment.item_type_short_answer_help#</p>
        <formgroup-widget id="item_type" row=4></formgroup-widget>
</fieldset>
<fieldset>
<legend>Long Answer</legend>
<p class="form-help-text">       #assessment.item_type_long_answer_help#</p>
        <formgroup-widget id="item_type" row=3></formgroup-widget>
<br />
            <label for="reference_answer">
              Reference Answer
            </label>	<formwidget id="reference_answer">
<p class="form-help-text">        <formhelp id="reference_answer"></p>
</fieldset>
<fieldset>
<legend>File Upload</legend>
<p class="form-help-text">        #assessment.item_type_file_upload_help#</p>
<formgroup-widget id="item_type" row=1></formgroup-widget>
</fieldset>
</div>
</div>
</fieldset>
          <span class="form-element">
            <formwidget id="formbutton_ok">            <formwidget id="formbutton_add_another_question">
            <br>
              <br>
          </span>

</formtemplate>
