<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<formtemplate id="item_edit_general">
  <formwidget id="__confirmed_p"><formwidget id="__refreshing_p"><formwidget id="assessment_id"><formwidget id="section_id"><formwidget id="__key_signature"><formwidget id="__new_p"><formwidget id="as_item_id">
      <br/>
        
              <if @formerror.question_text@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="question_text">
              Question
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
              <br>
                  @formerror.question_text;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="question_text">
              

        </span>   
        
      <br/>
        
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
              

        </span>   
        
      <br/>
        
              <if @formerror.points@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="points">
              Points for Question<br>(Optional)
            </label>

            
          </span>
          
            <if @formerror.points@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="points">

            
            <formerror id="points">
              <br>
                  @formerror.points;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="points">
              

        </span>   
        
      <br/>
        
              <if @formerror.feedback_right@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="feedback_right">
              Feedback right<br>(Optional)
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
              

        </span>   
        
      <br/>
        
              <if @formerror.feedback_wrong@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="feedback_wrong">
              Feedback wrong<br>(Optional)
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
        <formwidget id="description"><formwidget id="content"><formwidget id="subtext"><formwidget id="field_name"><formwidget id="field_code"><formwidget id="validate_block"><formwidget id="data_type"><formwidget id="display_type"><formwidget id="max_time_to_complete">
      <br/>

<switch @item_type@>
<case value="mc">
<formwidget id="num_choices">
         
       <p><span class="form-label">Correct<br>Answer</span><br>
        <multiple name="choice_elements">
    
           <formgroup id="correct.@choice_elements.id@">
                @formgroup.widget;noquote@
           </formgroup>

    <formwidget id="choice.@choice_elements.id@">
<if @choice_elements.new_p@ false>
       <if @choice_elements.rownum@ gt 1>
        <formwidget id="move_up.@choice_elements.id@">
        </if><else></else>
        <if @choice_elements.rownum@ lt @choice_elements:rowcount@>
        <formwidget id="move_down.@choice_elements.id@">
        </if>
        <formwidget id="delete.@choice_elements.id@">
</if>
    <br />
</multiple>
<formwidget id="add_another_choice">
</case>
<case value="oq">
            <label for="reference_answer">
              Reference Answer
            </label>
	<formwidget id="reference_answer">
<p class="form-help-text">        <formhelp id="reference_answer"></p>
</case>
</switch>
<p>
<formwidget id="formbutton_ok">
</p>
</formtemplate>
<a href="item-edit?as_item_id=@as_item_id@&section_id=@section_id@&assessment_id=@assessment_id@">Advanced Options</a>