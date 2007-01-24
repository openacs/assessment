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
              
            </p>
          <formwidget id=points><formwidget id=field_code><formwidget id=field_name><formwidget id=max_time_to_complete><formwidget id=validate_block><formwidget id=content><formwidget id=description>
      <br>
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

<div style="float:right">        <fieldset>
        <legend>Multiple Choice</legend>
<p class="form-help-text">       #assessment.item_type_multiple_choice_help#</p>
        <formgroup-widget id="item_type" row=2></formgroup-widget><br />
        <formgroup-widget id="item_type" row=5></formgroup-widget><formwidget id="ms_label">
           
       <p><span class="form-label">Correct<br>Answer</span><br>
        <multiple name="choice_elements">
        <formwidget id="correct.@choice_elements.id@">&nbsp;&nbsp;<formwidget id="choice.@choice_elements.id@"><br />
</multiple>
<if 0>
              <if @formerror.choice.1@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="choice.1">
              Choice 1
            </label>
            
          </span>
    <br />      
            <if @formerror.choice.1@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="choice.1">
            
            <formerror id="choice.1">
              <br>
                  @formerror.choice.1;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="choice.1">
              
            </p>
          
<br>
        
              <if @formerror.correct.1@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="correct.1">
              Correct Answer Choice 1
            </label>
            
          </span>
          
            <if @formerror.correct.1@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formgroup id="correct.1">
                @formgroup.widget;noquote@
                <label for="item-add:elements:correct.1:@formgroup.option@">
                  @formgroup.label;noquote@
                </label>
              </formgroup>
            
            <formerror id="correct.1">
              <br>
                  @formerror.correct.1;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="correct.1">
              
            </p>
          
      <br>
        
              <if @formerror.choice.2@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="choice.2">
              Choice 2
            </label>
            
          </span>
          
            <if @formerror.choice.2@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="choice.2">
            
            <formerror id="choice.2">
              <br>
                  @formerror.choice.2;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="choice.2">
              
            </p>
          
      <br>
        
              <if @formerror.correct.2@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="correct.2">
              Correct Answer Choice 2
            </label>
            
          </span>
          
            <if @formerror.correct.2@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formgroup id="correct.2">
                @formgroup.widget;noquote@
                <label for="item-add:elements:correct.2:@formgroup.option@">
                  @formgroup.label;noquote@
                </label>
              </formgroup>
            
            <formerror id="correct.2">
              <br>
                  @formerror.correct.2;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="correct.2">
              
            </p>
          
      <br>
        
              <if @formerror.choice.3@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="choice.3">
              Choice 3
            </label>
            
          </span>
          
            <if @formerror.choice.3@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="choice.3">
            
            <formerror id="choice.3">
              <br>
                  @formerror.choice.3;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="choice.3">
              
            </p>
          
      <br>
        
              <if @formerror.correct.3@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="correct.3">
              Correct Answer Choice 3
            </label>
            
          </span>
          
            <if @formerror.correct.3@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formgroup id="correct.3">
                @formgroup.widget;noquote@
                <label for="item-add:elements:correct.3:@formgroup.option@">
                  @formgroup.label;noquote@
                </label>
              </formgroup>
            
            <formerror id="correct.3">
              <br>
                  @formerror.correct.3;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="correct.3">
              
            </p>
          
      <br>
        
              <if @formerror.choice.4@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="choice.4">
              Choice 4
            </label>
            
          </span>
          
            <if @formerror.choice.4@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="choice.4">
            
            <formerror id="choice.4">
              <br>
                  @formerror.choice.4;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="choice.4">
              
            </p>
          
      <br>
        
              <if @formerror.correct.4@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="correct.4">
              Correct Answer Choice 4
            </label>
            
          </span>
          
            <if @formerror.correct.4@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formgroup id="correct.4">
                @formgroup.widget;noquote@
                <label for="item-add:elements:correct.4:@formgroup.option@">
                  @formgroup.label;noquote@
                </label>
              </formgroup>
            
            <formerror id="correct.4">
              <br>
                  @formerror.correct.4;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="correct.4">
              
            </p>
          
      <br>
        
              <if @formerror.choice.5@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="choice.5">
              Choice 5
            </label>
            
          </span>
          
            <if @formerror.choice.5@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="choice.5">
            
            <formerror id="choice.5">
              <br>
                  @formerror.choice.5;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="choice.5">
              
            </p>
          
      <br>
        
              <if @formerror.correct.5@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="correct.5">
              Correct Answer Choice 5
            </label>
            
          </span>
          
            <if @formerror.correct.5@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formgroup id="correct.5">
                @formgroup.widget;noquote@
                <label for="item-add:elements:correct.5:@formgroup.option@">
                  @formgroup.label;noquote@
                </label>
              </formgroup>
            
            <formerror id="correct.5">
              <br>
                  @formerror.correct.5;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="correct.5">
</if>                        
            </p>

      <br>
<formwidget id="add_another_choice">
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
<br />	<formwidget id="reference_answer">
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
