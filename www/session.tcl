ad_page_contract {
    @author Eduardo P�rez Ureta (eperez@it.uc3m.es)
    @creation-date 2004-09-13
} -query {
  session_id:notnull
} -properties {
    context:onevalue
}

set context [list "[_ assessment.View_Results]"]

set assessment_name [db_string assessment_name {SELECT as_assessmentsx.title FROM as_assessmentsx INNER JOIN as_sessionsx ON as_assessmentsx.assessment_id = as_sessionsx.assessment_id WHERE as_sessionsx.session_id=:session_id}]
db_1row session_user_id {SELECT persons.first_names, persons.last_name, assessment_id FROM as_sessionsx INNER JOIN persons ON as_sessionsx.subject_id = persons.person_id WHERE as_sessionsx.session_id=:session_id}
set assessment_url [export_vars -base "assessment" {assessment_id}]
set session_user_name "$first_names $last_name"
db_1row session_data {SELECT subject_id, creation_datetime AS session_start, completed_datetime AS session_finish, completed_datetime-creation_datetime AS session_time FROM as_sessionsx WHERE as_sessionsx.session_id = :session_id}
set session_user_url [acs_community_member_url -user_id $subject_id]
set session_attempt [db_string session_attempt {SELECT COUNT(*) FROM as_sessionsx WHERE as_sessionsx.subject_id = :subject_id AND as_sessionsx.assessment_id=:assessment_id}]
set assessment_score 100 ;# FIXME
set assessment_items [db_string assessment_items {SELECT COUNT(*) FROM (as_sectionsx INNER JOIN (as_assessmentsx INNER JOIN as_assessment_section_map ON as_assessmentsx.assessment_id=as_assessment_section_map.assessment_id) ON as_sectionsx.section_id=as_assessment_section_map.section_id) INNER JOIN (as_itemsx INNER JOIN as_item_section_map ON as_itemsx.as_item_id=as_item_section_map.as_item_id) ON as_sectionsx.section_id=as_item_section_map.section_id WHERE as_assessmentsx.assessment_id = :assessment_id}]
set itemmaxscore [expr $assessment_score/$assessment_items] ;# FIXME total_points/items_number

set session_score 0
db_multirow -extend [list choice_html score maxscore notanswered item_correct presentation_type] items query_all_items {} {
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
  if {[info exists as_item_display_rbx__item_id]} {set presentation_type "radio"}
  if {[info exists as_item_display_tbx__item_id]} {set presentation_type "fitb"}
  if {[info exists as_item_display_tax__item_id]} {set presentation_type "textarea"}

  set notanswered 1
  set maxscore $itemmaxscore
  set score 0
  set item_correct 1
  set choice_html "<table cellspacing=\"0\" cellpadding=\"3\" border=\"0\">"
  
  if {[string compare $presentation_type "textarea"] == 0} {  
      set text_answer {}       
      db_0or1row html_rows_cols "SELECT abs_size FROM as_item_display_tax WHERE item_id=:item_display_id"
      set html_options "[lindex $abs_size 0]=[lindex $abs_size 1] [lindex $abs_size 2]=[lindex $abs_size 3]"
      db_0or1row shortanswer {} 
      set choice_answer "<textarea $html_options readonly disabled>$text_answer</textarea>"
      set correct_answer {}
      append choice_html "<tr><td>$correct_answer</td><td>$choice_answer </td></tr>"	 
      set item_correct 0
  }
  
  db_foreach choices {} {
    if {[string length "$choice_id_answer"]} {set notanswered 0}
    set choice_correct 0
    if {[info exists as_item_display_tbx__item_id]} {
        foreach text_value $choice_title {
            if {[empty_string_p $text_answer]} { } else {
                if {[string toupper $text_answer] == [string toupper $text_value]} { set choice_correct 1 }
            }
        }
    } else {
        if {$correct_answer_p == {t}} { set correct_answer_bool 1 } else { set correct_answer_bool 0 }
        set choice_correct [expr $correct_answer_bool == ("$choice_id_answer" == $choice_id)]
    }
    set item_correct [expr $item_correct && $choice_correct]
    if {$choice_correct} {
        set correct_answer {}
    } else {
        set correct_answer {<font color="#ff0000">Error</font>}
    }
    if {[info exists as_item_display_tbx__item_id]} {
        if {$choice_correct} {
            regsub -all -line -nocase -- "<textbox.as_item_choice_id=$choice_id" $title "<input value=\"$text_answer\" readonly disabled" title
        } else {
            regsub -all -line -nocase -- "<textbox.as_item_choice_id=$choice_id" $title "<input value=\"$text_answer\" readonly disabled style=\"color: #ff0000\"" title
        }
    } else {
    if {$choice_id_answer == $choice_id } {
      set choice_answer "<input type=\"$presentation_type\" readonly disabled checked>"
    } else {
      set choice_answer "<input type=\"$presentation_type\" readonly disabled>"
    }
    if {[empty_string_p $content_value]} {
        append choice_html "<tr><td>$correct_answer</td><td>$choice_answer [ad_quotehtml $choice_title]</td></tr>"
    } else {
        append choice_html "<tr><td>$correct_answer</td><td>$choice_answer [ad_quotehtml $choice_title]<img src=\"view/?revision_id=$content_value\"></td></tr>"
    }   
    }
  }
  if {$item_correct} { set score $itemmaxscore }
  set session_score [expr $session_score+$score]
  if {[info exists as_item_display_tbx__item_id]} { append choice_html $title }
  append choice_html {</table>}
}

ad_return_template
