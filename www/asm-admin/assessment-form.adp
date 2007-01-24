<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<formtemplate id="assessment_form">

<formwidget id=__confirmed_p><formwidget id=__refreshing_p><formwidget id=permission_p><formwidget id=after><formwidget id=__key_signature><formwidget id=__new_p><formwidget id=assessment_id>
      <br>
        
<if @edit_p@>
<fieldset>
<legend>#assessment.assessment_form_title_description#</legend>
</if>
              <if @formerror.title@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="title">
              Title
            </label>
            <span class="form-required-mark">*</span>
          </span>
          
            <if @formerror.title@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="title">
            
            <formerror id="title">
              <br>
                  @formerror.title;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="title">
              
            </p>
          
      <br>
        
              <if @formerror.description@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="description">
              Description<br>(Optional)
            </label>
            
          </span>
          
            <if @formerror.description@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="description">
            
            <formerror id="description">
              <br>
                  @formerror.description;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="description">
              
            </p>
<if @edit_p@>
</fieldset>          
      <br>
<fieldset>
<legend>#assessment.assessment_form_instructions#</legend>
        
              <if @formerror.instructions@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="instructions">
              Instructions<br>(Optional)
            </label>
            
          </span>
          
            <if @formerror.instructions@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="instructions">
            
            <formerror id="instructions">
              <br>
                  @formerror.instructions;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="instructions">
              
            </p>
          
</fieldset>
      <br>
        
              <if @formerror.run_mode@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="run_mode">
              Mode
            </label>
            
          </span>
          
            <if @formerror.run_mode@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="run_mode">
            
            <formerror id="run_mode">
              <br>
                  @formerror.run_mode;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="run_mode">
              
            </p>
          
      <br>
<fieldset>
<legend>#assessment.assessment_form_response_options#</legend>
        
              <if @formerror.anonymous_p@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="anonymous_p">
              Anonymous Responses
            </label>
            
          </span>
          
            <if @formerror.anonymous_p@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="anonymous_p">
            
            <formerror id="anonymous_p">
              <br>
                  @formerror.anonymous_p;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="anonymous_p">
              
            </p>
          
      <br>
        
              <if @formerror.secure_access_p@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="secure_access_p">
              Secure Access Required
            </label>
            
          </span>
          
            <if @formerror.secure_access_p@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="secure_access_p">
            
            <formerror id="secure_access_p">
              <br>
                  @formerror.secure_access_p;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="secure_access_p">
              
            </p>
          
      <br>
        
              <if @formerror.reuse_responses_p@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="reuse_responses_p">
              Reuse Responses
            </label>
            
          </span>
          
            <if @formerror.reuse_responses_p@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="reuse_responses_p">
            
            <formerror id="reuse_responses_p">
              <br>
                  @formerror.reuse_responses_p;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="reuse_responses_p">
              
            </p>
          
      <br>
        
              <if @formerror.show_item_name_p@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="show_item_name_p">
              Show Question Name
            </label>
            
          </span>
          
            <if @formerror.show_item_name_p@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="show_item_name_p">
            
            <formerror id="show_item_name_p">
              <br>
                  @formerror.show_item_name_p;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="show_item_name_p">
              
            </p>
          
      <br>
        
              <if @formerror.random_p@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="random_p">
              Allow Randomizing
            </label>
            
          </span>
          
            <if @formerror.random_p@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="random_p">
            
            <formerror id="random_p">
              <br>
                  @formerror.random_p;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="random_p">
              
            </p>

      <br>
        
              <if @formerror.number_tries@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="number_tries">
              Number of Tries allowed
            </label>
            
          </span>
          
            <if @formerror.number_tries@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="number_tries">
            
            <formerror id="number_tries">
              <br>
                  @formerror.number_tries;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="number_tries">
              
            </p>
          
      <br>
        
              <if @formerror.wait_between_tries@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="wait_between_tries">
              Minutes required for Retry
            </label>
            
          </span>
          
            <if @formerror.wait_between_tries@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="wait_between_tries">
            
            <formerror id="wait_between_tries">
              <br>
                  @formerror.wait_between_tries;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="wait_between_tries">
              
            </p>
          
      <br>
        
              <if @formerror.time_for_response@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="time_for_response">
              Minutes allowed for completion
            </label>
            
          </span>
          
            <if @formerror.time_for_response@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="time_for_response">
            
            <formerror id="time_for_response">
              <br>
                  @formerror.time_for_response;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="time_for_response">
              
            </p>
          
</fieldset>
      <br>
        
              <if @formerror.consent_page@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="consent_page">
              Consent Page
            </label>
            
          </span>
          
            <if @formerror.consent_page@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="consent_page">
            
            <formerror id="consent_page">
              <br>
                  @formerror.consent_page;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="consent_page">
              
            </p>
          
      <br>
        
              <if @formerror.return_url@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="return_url">
              Return URL
            </label>
            
          </span>
          
            <if @formerror.return_url@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="return_url">
            
            <formerror id="return_url">
              <br>
                  @formerror.return_url;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="return_url">
              
            </p>
          
      <br>
<fieldset>
<legend>#assessment.assessment_form_time_options#</legend>
        
              <if @formerror.start_time@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="start_time">
              Start Time
            </label>
            
          </span>
          
            <if @formerror.start_time@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="start_time">
            
            <formerror id="start_time">
              <br>
                  @formerror.start_time;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="start_time">
              
            </p>
          
      <br>
        
              <if @formerror.end_time@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="end_time">
              End Time
            </label>
            
          </span>
          
            <if @formerror.end_time@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="end_time">
            
            <formerror id="end_time">
              <br>
                  @formerror.end_time;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="end_time">
              
            </p>
</fieldset>          
      <br>
        
              <if @formerror.ip_mask@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="ip_mask">
              IP Mask
            </label>
            
          </span>
          
            <if @formerror.ip_mask@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="ip_mask">
            
            <formerror id="ip_mask">
              <br>
                  @formerror.ip_mask;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="ip_mask">
              
            </p>
          
      <br>
        
              <if @formerror.password@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="password">
              Password
            </label>
            
          </span>
          
            <if @formerror.password@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="password">
            
            <formerror id="password">
              <br>
                  @formerror.password;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="password">
              
            </p>
          
      <br>
        
              <if @formerror.show_feedback@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="show_feedback">
              Show Feedback
            </label>
            
          </span>
          
            <if @formerror.show_feedback@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="show_feedback">
            
            <formerror id="show_feedback">
              <br>
                  @formerror.show_feedback;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="show_feedback">
              
            </p>
          
      <br>
        
              <if @formerror.section_navigation@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>
            
            <label for="section_navigation">
              Section Navigation
            </label>
            
          </span>
          
            <if @formerror.section_navigation@ not nil>
              <span class="form-widget-error">
            </if>
            <else>
              <span class="form-widget">                  
            </else>
          
              <formwidget id="section_navigation">
            
            <formerror id="section_navigation">
              <br>
                  @formerror.section_navigation;noquote@
            </formerror>
          
            <p class="form-help-text">
              
                <formhelp id="section_navigation">
              
            </p>
          <formwidget id=type>
      <br>
</if>
        
          <span class="form-element">
            <formwidget id="formbutton:ok">
            <br>
              <br>
          </span>
</formtemplate>
