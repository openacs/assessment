ad_library {

    Assessment Library - Reply Handling
}


namespace eval assessment::notification_delivery {

    ad_proc -public do_notification {
    assessment_id
    user_id
    entr_id
    } { 

	db_1row  select_assessment_name {*SQL*}
        db_1row select_user_name {*SQL*}
	set q_a_text ""
	append q_a_text "Question: $question
Answer: $answer"
	set text_version ""
	set assessment_url [assessment::notification::get_url $entry_id]
	
	append text_version "Assessment: $assessment_name
Author: $name ($email)\n\n"
         append text_version [wrap_string $q_a_text]
     append text_version "\n\n-- 
To view the entire ASSESSMENT go to: 
$assessment_url
"
    set new_content $text_version
    set package_id [ad_conn package_id]

    # Notifies the users that requested notification for the specific ASSESSMENT

    notification::new \
        -type_id [notification::type::get_type_id \
        -short_name one_assessment_qa_notif] \
        -object_id $assessment_id \
        -response_id $entry_id \
        -notif_subject "New Q&A of $assessment_name" \
         -notif_text $new_content


      }
}
