ad_page_contract {
    @author Eduardo Pérez Ureta (eperez@it.uc3m.es)
    @creation-date 2004-09-13
} -query {
  session_id:notnull
} -properties {
    context:onevalue
}

set context [list "Show Session Results"]

db_multirow -extend choice_html items query_all_items {} {
  set item_item_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:as_item_id"]
  set item_mc_id [db_string item_item_type "SELECT related_object_id FROM cr_item_rels WHERE item_id=:item_item_id"]
  set mc_id [db_string item_to_rev "SELECT revision_id FROM cr_revisions WHERE item_id=:item_mc_id"]
  set choice_html {<ul>}
  db_foreach choices {} {
    if {$correct_answer_p == {t}} {
    set correct_answer {&#9745;}
    } else {
    set correct_answer {&#9746;}
    }
    ns_log Warning "$choice_id $choice_id_answer"
    if {$choice_id_answer == $choice_id } {
      set choice_answer {&#8594;}
    } else {
      set choice_answer {}
    }
    append choice_html "<li>$choice_answer $correct_answer [ad_quotehtml $choice_title]</li>"
  }
  append choice_html {</ul>}
}

ad_return_template
