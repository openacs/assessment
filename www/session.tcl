ad_page_contract {

    Lists the results that an user obtains after answer an assessment.
    In the results, users can view the started time and finished time
    of assessment, the time spent in take the assessment, as well as
    the number of attempts. The users also can view the obtained total
    score, the obtained score by each item, their incorrect answers and
    a right or wrong feedback. If an item isn't answered users are informed.

    @author Eduardo P�rez Ureta (eperez@it.uc3m.es)
    @creation-date 2004-09-13
} -query {
  session_id:notnull
} -properties {
    context:onevalue
}

set context [list "[_ assessment.View_Results]"]
#get survey_p in order to find out whether it's an assessment or a survey
set survey_p [db_string survey_p {SELECT as_assessmentsx.survey_p FROM as_assessmentsx INNER JOIN as_sessionsx ON as_assessmentsx.assessment_id = as_sessionsx.assessment_id WHERE as_sessionsx.session_id=:session_id}]

set assessment_name [db_string assessment_name {SELECT as_assessmentsx.title FROM as_assessmentsx INNER JOIN as_sessionsx ON as_assessmentsx.assessment_id = as_sessionsx.assessment_id WHERE as_sessionsx.session_id=:session_id}]
#get the user takes a session
db_1row session_user_id {SELECT persons.first_names, persons.last_name, assessment_id FROM as_sessionsx INNER JOIN persons ON as_sessionsx.subject_id = persons.person_id WHERE as_sessionsx.session_id=:session_id}
set assessment_url [export_vars -base "assessment" {assessment_id}]
set session_user_name "$first_names $last_name"
#get information of assessment as subject that took it, the started time and finished time of assessment
db_1row session_data {SELECT subject_id, creation_datetime AS session_start, completed_datetime AS session_finish, completed_datetime-creation_datetime AS session_time FROM as_sessionsx WHERE as_sessionsx.session_id = :session_id}
set session_user_url [acs_community_member_url -user_id $subject_id]
#get the number of attempts
set session_attempt [db_string session_attempt {SELECT COUNT(*) FROM as_sessionsx WHERE as_sessionsx.subject_id = :subject_id AND as_sessionsx.assessment_id=:assessment_id}]
set assessment_score 100 ;# FIXME
#get the number of items of an assessment
set assessment_items [db_string assessment_items {SELECT COUNT(*) FROM (as_sectionsx INNER JOIN (as_assessmentsx INNER JOIN as_assessment_section_map ON as_assessmentsx.assessment_id=as_assessment_section_map.assessment_id) ON as_sectionsx.section_id=as_assessment_section_map.section_id) INNER JOIN (as_itemsx INNER JOIN as_item_section_map ON as_itemsx.as_item_id=as_item_section_map.as_item_id) ON as_sectionsx.section_id=as_item_section_map.section_id WHERE as_assessmentsx.assessment_id = :assessment_id}]
#set maximum score by each item
set itemmaxscore [expr $assessment_score/$assessment_items] ;# FIXME total_points/items_number

set session_score 0
db_multirow -extend [list choice_html score maxscore notanswered item_correct presentation_type] items query_all_items {} {
  #reset variables
  set as_item_display_rbx__item_id {}
  unset as_item_display_rbx__item_id
  set as_item_display_tbx__item_id {}
  unset as_item_display_tbx__item_id
  set as_item_display_tax__item_id {}
  unset as_item_display_tax__item_id
  set item_item_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:as_item_id"]
  set item_mc_id [db_string item_item_type "SELECT related_object_id FROM cr_item_rels WHERE relation_tag = 'as_item_type_rel' AND item_id=:item_item_id"]
  set mc_id [db_string item_to_rev "SELECT revision_id FROM cr_revisions WHERE item_id=:item_mc_id"]
  set item_display_id [db_string item_item_type "SELECT related_object_id FROM cr_item_rels WHERE relation_tag = 'as_item_display_rel' AND item_id=:item_item_id"]
  set items_as_item_id [db_string items_items_as_item_id "SELECT as_itemsx.as_item_id FROM as_itemsx WHERE as_itemsx.item_id = :item_item_id"]
  db_0or1row as_item_display_rbx "SELECT item_id AS as_item_display_rbx__item_id FROM as_item_display_rbx WHERE item_id=:item_display_id"
  db_0or1row as_item_display_tbx "SELECT item_id AS as_item_display_tbx__item_id FROM as_item_display_tbx WHERE item_id=:item_display_id"
  db_0or1row as_item_display_tax "SELECT item_id AS as_item_display_tax__item_id FROM as_item_display_tax WHERE item_id=:item_display_id"
  set presentation_type "checkbox" ;# DEFAULT
  #get the presentation type
  if {[info exists as_item_display_rbx__item_id]} {set presentation_type "radio"}
  if {[info exists as_item_display_tbx__item_id]} {set presentation_type "fitb"}
  if {[info exists as_item_display_tax__item_id]} {set presentation_type "textarea"}

  set notanswered 1
  set maxscore $itemmaxscore
  set score 0
  set item_correct 1
  set choice_html "<table cellspacing=\"0\" cellpadding=\"3\" border=\"0\">"
  
  #for Short Answer item
  if {[string compare $presentation_type "textarea"] == 0} {  
      set text_answer {}
      #get rows and cols for painting a textarea (in abs_size is stored as "rows value cols value", we need to add the symbol =)        
      db_0or1row html_rows_cols "SELECT abs_size FROM as_item_display_tax WHERE item_id=:item_display_id"
      set html_options "[lindex $abs_size 0]=[lindex $abs_size 1] [lindex $abs_size 2]=[lindex $abs_size 3]"
      #get the user response
      db_0or1row shortanswer {} 
      #paint a disabled textarea with the user response
      set choice_answer "<textarea $html_options readonly disabled>$text_answer</textarea>"
      set correct_answer {}
      append choice_html "<tr><td>$correct_answer</td><td>$choice_answer </td></tr>"
      #item_correct=0 because this item has to be corrected by a teacher
      set item_correct 0
  }
  
  db_foreach choices {} {
    if {[string length "$choice_id_answer"]} {set notanswered 0}
    set choice_correct 0
    #for fill in the blank item
    if {[info exists as_item_display_tbx__item_id]} {
        foreach text_value $choice_title {
            if {[empty_string_p $text_answer]} { } else {
	        #if the user response is equal to stored answer (no case sensitive) the user response is correct
                if {[string toupper $text_answer] == [string toupper $text_value]} { set choice_correct 1 }
            }
        }
    #for multiple choice and multiple response items
    } else {
        if {$correct_answer_p == {t}} { set correct_answer_bool 1 } else { set correct_answer_bool 0 }
        set choice_correct [expr $correct_answer_bool == ("$choice_id_answer" == $choice_id)]
    }
    set item_correct [expr $item_correct && $choice_correct]
    if {$choice_correct} {
        set correct_answer {}
    } else {
        #if the user response is wrong, the word "Error" will be displayed in red color
        set correct_answer {<font color="#ff0000">Error</font>}
    }
    
    #if it's a survey we show the selected answer with out the word Error
    if {$survey_p == {t}} {
        set correct_answer {}
    }
    
    #for fill in the blank item
    if {[info exists as_item_display_tbx__item_id]} {
        if {$choice_correct} {
	    #replace <textbox> by readonly <input>
            regsub -all -line -nocase -- "<textbox.as_item_choice_id=$choice_id" $title "<input value=\"$text_answer\" readonly disabled" title
        } else {
	    #replace <textbox> by readonly <input> and the text is written in red color because the user response is incorrect
            regsub -all -line -nocase -- "<textbox.as_item_choice_id=$choice_id" $title "<input value=\"$text_answer\" readonly disabled style=\"color: #ff0000\"" title
        }
    #for multiple choice and multiple response items
    } else {
    if {$choice_id_answer == $choice_id } {
      set choice_answer "<input type=\"$presentation_type\" readonly disabled checked>"
    } else {
      set choice_answer "<input type=\"$presentation_type\" readonly disabled>"
    }
    #if a item is a multiple choice or multiple response with multimedia (images, sounds, videos)
    if {[empty_string_p $content_value]} {
        append choice_html "<tr><td>$correct_answer</td><td>$choice_answer [ad_quotehtml $choice_title]</td></tr>"
    #multiple choice or multiple response (text)
    } else {
        append choice_html "<tr><td>$correct_answer</td><td>$choice_answer [ad_quotehtml $choice_title]<img src=\"view/?revision_id=$content_value\"></td></tr>"
    }   
    }
  }
  if {$item_correct} { set score $itemmaxscore }
  # total points
  set session_score [expr $session_score+$score]
  if {[info exists as_item_display_tbx__item_id]} { append choice_html $title }
  append choice_html {</table>}
}

ad_return_template
