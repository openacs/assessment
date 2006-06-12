# packages/assessment/www/asm-admin/view-item-responses.tcl

ad_page_contract {
    
    View text/date responses
    
    @author Roel Canicula (roel@solutiongrove.com)
    @creation-date 2006-06-09
    @arch-tag: d97c0cf0-0f43-4958-86ca-2a3d2816f31d
    @cvs-id $Id$
} {
    item_id:integer,notnull
    section_id:integer,notnull
    return_url:notnull
} -properties {
} -validate {
} -errors {
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create

set as_item_id [content::item::get_latest_revision -item_id $item_id]
set data_type [db_string get_data_type {
    select data_type
    from as_items
    where as_item_id = :as_item_id
}]

if { $data_type eq "date" || $data_type eq "timestamp" } {
    set answer_field timestamp_field
} else {
    set answer_field text_answer
}

db_multirow -extend { session_url user_url file_url } responses responses [subst {
    select item_data_id, subject_id, session_id, $answer_field as answer,
    person__name(subject_id) as person_name

    from as_item_data
    where as_item_id = :as_item_id
    and not $answer_field is null
}] {
    set user_url [export_vars -base sessions { subject_id }]
    set session_url [export_vars -base ../session { session_id }]
    
    if { $data_type eq "file" } {
	set file_url [as::item_display_f::view \
			  -item_id $as_item_id \
			  -session_id $session_id \
			  -section_id $section_id]
    }
}

template::list::create \
    -name responses \
    -multirow responses \
    -no_data "[_ assessment.No_responses]" \
    -pass_properties { data_type } \
    -elements {
	session_id {
	    label "[_ assessment.Session]"
	    link_url_col session_url
	}
	person_name {
	    label "[_ assessment.Name]"
	    link_url_col user_url
	}
	answer {
	    label "[_ assessment.Answer]"
	    display_template {
		<if @data_type@ eq "file">		
		<a href="@responses.file_url;noquote@">@responses.answer;noquote@</a>
		</if>
		<else>
		@responses.answer@
		</else>
	    }
	}
    }