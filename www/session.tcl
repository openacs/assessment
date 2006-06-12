 ad_page_contract {

     Show the result of a session.

     @author timo@timohentschel.de
     @date   2004-12-24
     @cvs-id $Id: 
 } {
 } -properties {
     context_bar:onevalue
     page_title:onevalue
 }


 set page_title "[_ assessment.View_Results]"
 set context_bar [ad_context_bar [list [export_vars -base sessions {assessment_id}] "[_ assessment.Show_Sessions]"] $page_title]


ad_return_template
