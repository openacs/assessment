ad_page_contract {

    Thank user for completing assessment and provide link to results

    @author Timo Hentschel (timo@timohentschel.de)
    @date   2005-01-20
} {
    session_id:integer,notnull
    assessment_id:integer,notnull
    return_url:optional
    next_asm:optional
} -properties {
    context:onevalue
    page_title:onevalue
}

set user_id [ad_conn user_id]

if { ![string eq $user_id 0]} {
    
    db_dml update_session {update as_sessions set subject_id=:user_id where session_id=:session_id}
    db_dml update_session {update as_item_data set subject_id=:user_id where session_id=:session_id}
}


set page_title "[_ assessment.Response_Submitted]"
set context [list $page_title]

callback imsld::finish_object -object_id $assessment_id 



if { [exists_and_not_null next_asm ] } {
    ad_returnredirect "assessment?assessment_id=$next_asm"
} 

set value [parameter::get -parameter "RegistrationId" -package_id [subsite::main_site_id]]

if  {[info exists return_url]} {
    if { $return_url != ""} {
	ad_returnredirect "$return_url"
    } else {
	if { [string eq $value $assessment_id] } {
	    ad_returnredirect "/pvt/home"
	}
    } 
}

ad_return_template
