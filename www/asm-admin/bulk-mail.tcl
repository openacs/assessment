ad_page_contract {
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
} {
    action_log_id:multiple
    d_assessment
    d_date
    d_interval
    d_state
}

if {[llength $action_log_id] == 1} { 
set action_log_id [split [lindex $action_log_id  0] " "]
}

set users_list "("

for {set i 0} {$i < [llength  $action_log_id]} {incr i} {
    set action_id [lindex $action_log_id $i]
    set subject_id [db_string subject {select subject_id from as_sessions where session_id=(select session_id from as_actions_log where action_log_id=:action_id)}]
    append users_list "$subject_id,"
}

set users_list [string range $users_list 0 [expr [string length $users_list] -2]]
append users_list ")"

set query "select email from cc_users where object_id in $users_list"

set spam_name [bulk_mail::parameter -parameter PrettyName -default [_ dotlrn.Spam_]]

set sender_id [ad_conn user_id]
set context_bar ""
set portal_id ""

set users [db_list_of_lists get_users $query]


form create spam_message

element create spam_message subject \
    -label [_ dotlrn.Subject] \
    -datatype text \
    -widget text \
    -html {size 60}

element create spam_message message \
    -label [_ dotlrn.Message] \
    -datatype text \
    -widget textarea \
    -html {rows 10 cols 80 wrap soft}


element create spam_message format \
    -label "Format" \
    -datatype text \
    -widget select \
    -options {{"Preformatted Text" "pre"} {"Plain Text" "plain"} {HTML "html"}}

element create spam_message d_date\
    -widget hidden\
    -datatype date\
    -value $d_date
element create spam_message d_assessment \
    -widget hidden\
    -datatype text\
    -value $d_assessment
element create spam_message d_interval\
    -widget hidden\
    -datatype text\
    -value $d_interval
element create spam_message d_state \
    -widget hidden\
    -datatype text\
    -value $d_state
element create spam_message action_log_id \
    -widget hidden\
    -datatype text\
    -value $action_log_id
    
element create spam_message send_date \
    -label [_ dotlrn.Send_Date] \
    -datatype date \
    -widget date \
    -format {MONTH DD YYYY HH12 MI AM} \
    -value [template::util::date::now_min_interval]

if {[form is_valid spam_message]} {
    form get_values spam_message \
	subject message send_date format d_date d_state d_assessment action_log_id d_interval
    ns_log notice "antes del bulk-mail"        
    set id [bulk_mail::new \
		-from_addr annyflores@viaro.net\
		-send_date $send_date\
		-date_format "YYYY MM DD HH24 MI SS" \
		-subject "$subject" \
		-message $message \
		-query $query]
    ns_log notice "despues del bulk-mail $id"    
    ad_returnredirect "admin-request?assessment=$d_assessment&state=$d_state&interval=$d_interval&date=$d_date"
}





