ad_page_contract {
    @author Eduardo Pérez Ureta (eperez@it.uc3m.es)
    @creation-date 2004-09-13
} -query {
  session_id:notnull
} -properties {
    context:onevalue
}

set context [list "View Results"]

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
db_multirow -extend [list choice_html score maxscore notanswered item_correct] items query_all_items {} {
  set item_item_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:as_item_id"]
  set item_mc_id [db_string item_item_type "SELECT related_object_id FROM cr_item_rels WHERE relation_tag = 'as_item_type_rel' AND item_id=:item_item_id"]
  set mc_id [db_string item_to_rev "SELECT revision_id FROM cr_revisions WHERE item_id=:item_mc_id"]
  set item_display_id [db_string item_item_type "SELECT related_object_id FROM cr_item_rels WHERE relation_tag = 'as_item_display_rel' AND item_id=:item_item_id"]
  db_0or1row as_item_display_rbx "SELECT item_id AS as_item_display_rbx__item_id FROM as_item_display_rbx WHERE item_id=:item_display_id"
  set presentation_type "checkbox" ;# DEFAULT
  if {[info exists as_item_display_rbx__item_id]} {set presentation_type "radio"}

  set notanswered 1
  set maxscore $itemmaxscore
  set score 0
  set item_correct 1
  set choice_html "<table cellspacing=\"0\" cellpadding=\"3\" border=\"0\">"
  db_foreach choices {} {
    if {[string length "$choice_id_answer"]} {set notanswered 0}
    if {$correct_answer_p == {t}} { set correct_answer_bool 1 } else { set correct_answer_bool 0 }
    set choice_correct [expr $correct_answer_bool == ("$choice_id_answer" == $choice_id)]
    set item_correct [expr $item_correct && $choice_correct]
    if {$choice_correct} {
    set correct_answer {}
    } else {
    set correct_answer {<font color="#ff0000">Error</font>}
    }
    if {$choice_id_answer == $choice_id } {
      set choice_answer "<input type=\"$presentation_type\" readonly disabled checked>"
    } else {
      set choice_answer "<input type=\"$presentation_type\" readonly disabled>"
    }
    append choice_html "<tr><td>$correct_answer</td><td>$choice_answer [ad_quotehtml $choice_title]</td></tr>"
  }
  if {$item_correct} { set score $itemmaxscore }
  set session_score [expr $session_score+$score]
  append choice_html {</table>}
}

ad_return_template
