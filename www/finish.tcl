ad_page_contract {

    Thank user for completing assessment and provide link to results

    @author Timo Hentschel (timo@timohentschel.de)
    @date   2005-01-20
} {
    session_id:integer,notnull
    assessment_id:integer,notnull
    return_url:optional
} -properties {
    context_bar:onevalue
    page_title:onevalue
}


if {[info exists return_url]} {
    if { $return_url != ""} {
    ad_returnredirect "$return_url"
    }
}
set page_title "[_ assessment.Response_Submitted]"
set context_bar [ad_context_bar $page_title]


ad_return_template
