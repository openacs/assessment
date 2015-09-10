ad_library {
    Use tclwebtest to test web UI for assessment
}

aa_register_case assessment_create_and_respond {
    Create an assessment and respond to it
} {
::tclwebtest::init 
    set assessment_name "__test [ns_mktemp XXXXXX]"
    set assessment_url "__test_[ns_mktemp XXXXXX]"
    aa_log "Assessment url = '${assessment_url}'"
    aa_log "Assesment name = '${assessment_name}'"

    set assessment_package_id [site_node::instantiate_and_mount \
                                   -node_name $assessment_url \
                                   -package_key assessment]
    array set user [twt::user::create]
    array set admin_user [twt::user::create -admin]

    twt::user::login $admin_user(email) $admin_user(password) $admin_user(username)

    ::tclwebtest::do_request "/${assessment_url}/asm-admin/"
    ::tclwebtest::link follow {New Assessment} ;# ~u {/${assessment_url}/asm-admin/assessment-form?type=test}
    ::tclwebtest::form find ~n {assessment_form}
    ::tclwebtest::field fill $assessment_name ;# ~n {title} ;# type of field = text 
    ::tclwebtest::field fill {} ;# ~n {description} ;# type of field = textarea 
::tclwebtest::form submit 
    ::tclwebtest::link follow {Questions} ;# ~u {/${assessment_url}/asm-admin/one-section?section%5fid=727724&assessment%5fid=727720}
    ::tclwebtest::link follow {Add a new question} ;# ~u {/${assessment_url}/asm-admin/item-add?section_id=727724&assessment_id=727720&after=0}
    ::tclwebtest::form find ~n {item-add}
    set question_text [string repeat X 100]
    ::tclwebtest::field fill $question_text ~n {question_text} ;# type of field = textarea 
    ::tclwebtest::field select -index 0 ;# ~n {required_p} ;# selected <Yes>
    ::tclwebtest::field fill {} ~n {feedback_wrong} ;# type of field = textarea 
    ::tclwebtest::field fill {} ~n {points} ;# type of field = text 
    ::tclwebtest::field select -index 2 ~n {item_type}
    ::tclwebtest::field fill {} ;# ~n {reference_answer} ;# type of field = textarea 

    ::tclwebtest::form submit {formbutton_ok} 
    ns_log notice "[::tclwebtest::response text]"
    ::tclwebtest::assert text $question_text
    aa_log "Added One Question"    
    ::tclwebtest::link follow ~u {one-a} ;# ~u {/${assessment_url}/asm-admin/one-a?assessment%5fid=727720}
    ::tclwebtest::link follow {Change status} ;# ~u {/${assessment_url}/asm-admin/toggle-publish?assessment_id=727720}

    aa_log "Made Live" 

#    twt::user::login $user(email) $user(password) $user(username)
    twt::do_request "/${assessment_url}/"

    ::tclwebtest::link follow $assessment_name ;# ~u {/${assessment_url}/assessment?assessment%5fid=727720}
    ::tclwebtest::link follow Start
    ::tclwebtest::form find ~n {show_item_form}
    ::tclwebtest::field fill {{}[]} ;# ~n {response_to_item.727726} ;# type of field = text 
::tclwebtest::form submit 
    ::tclwebtest::link follow ~u {session} ;# ~u {/${assessment_url}/session?session_id=727735}

#    twt::user::login $admin_user(email) $admin_user(password) $admin_user(username)
    twt::do_request "/${assessment_url}/asm-admin"
#    ns_log notice "[::tclwebtest::link all]" 
   ::tclwebtest::link follow $assessment_name ;# ~u {/${assessment_url}/asm-admin/one-a?assessment%5fid=727720}
    ::tclwebtest::link follow {Delete this assessment} ;# ~u {/${assessment_url}/asm-admin/assessment-delete?assessment_id=727720}
    ::tclwebtest::form find ~n {assessment_delete_confirm}
    ::tclwebtest::field select -index 0 ;# ~n {confirmation}
::tclwebtest::form submit 
 
    # unmount and uninstantiate
    apm_package_instance_delete $assessment_package_id
    
   catch {twt::user::delete -user_id $user(user_id)} errmsg
    aa_log $errmsg
    catch {twt::user::delete -user_id $admin_user(user_id)} errmsg
    aa_log $errmsg
}

aa_register_case cleanup_test {
    cleanup cruft from previous tests
} {
    db_multirow assessments q "
select distinct item_id,title from as_assessmentsx where title like '__test%'
"
    template::multirow foreach assessments {
aa_log "Found assessment_id $item_id title $title"
	as::assessment::delete -assessment_id $item_id
    }
    db_multirow users q "
select user_id from cc_users where email like '%test.test'
" {
    catch {twt::user::delete -user_id $user_id} errmsg
    aa_log $errmsg
}
}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
