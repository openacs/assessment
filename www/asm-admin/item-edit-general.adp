<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<formtemplate id="item_edit_general">
  <div><formwidget id="__confirmed_p"><formwidget id="__refreshing_p"><formwidget id="assessment_id"><formwidget id="section_id"><formwidget id="__key_signature"><formwidget id="__new_p"><formwidget id="as_item_id">
      <br></div>
            <div>
              <if @formerror.question_text@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>

            <label for="question_text">
              #assessment.Question#
            </label>
            </span>

            <span class="form-required-mark">*</span>

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
         </span></div>
            <p class="form-help-text">

                <formhelp id="question_text">
            </p>

        <div>
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


            <formerror id="required_p">
              <br>
                  @formerror.required_p;noquote@
            </formerror>
        </span></div>
            <p class="form-help-text">

                <formhelp id="required_p">
            </p>


      <div><br>

              <if @formerror.points@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>

            <label for="points">
              #assessment.Points_for_Question_Optional#
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
          </span></div>
            <p class="form-help-text">

                <formhelp id="points">
            </p>

      <div><br>

              <if @formerror.feedback_right@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>

            <label for="feedback_right">
	     #assessment.Feedback_right_Optional#
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
        </span></div>
            <p class="form-help-text">

                <formhelp id="feedback_right">
            </p>


      <div><br>

              <if @formerror.feedback_wrong@ not nil>
                <span class="form-label-error">
              </if>
              <else>
                <span class="form-label">
              </else>

            <label for="feedback_wrong">
	     #assessment.Feedback_wrong_Optional#
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
        </span></div>
            <p class="form-help-text">

                <formhelp id="feedback_wrong">
            </p>
       <div><br></div>
<if @item_type@ eq "mc">

            <div><br><formgroup-widget id="display_type" row=1></formgroup-widget></div>
            <div><br><formgroup-widget id="display_type" row=2></formgroup-widget></div>

            <if @formerror.display_type@ not nil>
              <div class="form-widget-error">
            </if>
            <else>
              <div class="form-widget">
            </else>
            </div>

            <formerror id="display_type">
                  @formerror.data_type;noquote@
            </formerror>

            <p class="form-help-text">

                <formhelp id="display_type">
            </p>
</if>

<switch @item_type@>
<case value="mc">
<div><formwidget id="num_choices"></div>

       <p><span class="form-label">#assessment.Correct_Answer#</span><br>
        <multiple name="choice_elements">

           <formgroup id="correct.@choice_elements.id@">
                @formgroup.widget;noquote@
           </formgroup>

    <formwidget id="choice.@choice_elements.id@">
<if @choice_elements.new_p;literal@ false>
       <if @choice_elements.rownum@ gt 1>
        <formwidget id="move_up.@choice_elements.id@">
        </if><else></else>
        <if @choice_elements.rownum@ lt @choice_elements:rowcount@>
        <formwidget id="move_down.@choice_elements.id@">
        </if>
        <formwidget id="delete.@choice_elements.id@">
</if>
    <br>
</multiple>

  <formgroup id="save_answer_set">
    @formgroup.widget;noquote@
    <label for="item_edit_general:elements:save_answer_set:t">#assessment.Save_this_set_of_answers_for_reuse_later#</label><br>
  </formgroup>

<formwidget id="add_another_choice"><br>
<if @choice_sets@ not nil><p>#assessment.OrUseChoices#<br>
<formwidget id="add_existing_mc_id">
</p></if>
</case>
<case value="oq">
            <label for="reference_answer">
              #assessment.oq_Reference_Answer#
            </label>
	<formwidget id="reference_answer">
<p class="form-help-text">        <formhelp id="reference_answer"></p>
</case>
</switch>
<p>
<formwidget id="formbutton_ok">
</p>
</formtemplate>

<a href="@advanced_options_url@">#assessment.Advanced_Options#</a>

