ad_library {
    Short answer item procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item_type_sa {}

ad_proc -public as::item_type_sa::new {
    {-title ""}
    {-increasing_p ""}
    {-allow_negative_p ""}
    {-package_id ""}
} {
    @author Natalia Perez (nperper@it.uc3m.es)
    @creation-date 2004-09-29

    New Short Answer Answers item to the data database
} {
    if { $package_id eq "" } {
        set package_id [ad_conn package_id]
    }
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_type_sa in the CR (and as_item_type_sa table) getting the revision_id (as_item_type_id)
    db_transaction {
        set item_item_type_sa_id [content::item::new -parent_id $folder_id -content_type {as_item_type_sa} -name [as::item::generate_unique_name]]
        set as_item_type_sa_id [content::revision::new \
                                    -item_id $item_item_type_sa_id \
                                    -content_type {as_item_type_sa} \
                                    -title $title \
                                    -attributes [list [list increasing_p $increasing_p] \
                                                      [list allow_negative_p $allow_negative_p] ] ]
    }

    return $as_item_type_sa_id
}

ad_proc -public as::item_type_sa::edit {
    -as_item_type_id:required
    {-title ""}
    {-increasing_p ""}
    {-allow_negative_p ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Edit Short Answer Answers item to the data database
} {
    # Update as_item_type_sa in the CR (and as_item_type_sa table) getting the revision_id (as_item_type_id)
    db_transaction {
        set type_item_id [db_string type_item_id {}]
        set new_item_type_id [content::revision::new \
                                  -item_id $type_item_id \
                                  -content_type {as_item_type_sa} \
                                  -title $title \
                                  -attributes [list [list increasing_p $increasing_p] \
                                                    [list allow_negative_p $allow_negative_p] ] ]
    }

    return $new_item_type_id
}

ad_proc -public as::item_type_sa::copy {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copy a Short Answer Type
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_type_sa in the CR (and as_item_type_sa table) getting the revision_id (as_item_type_id)
    db_transaction {
        db_1row item_type_data {}

        set new_item_type_id [new -title $title \
                                  -increasing_p $increasing_p \
                                  -allow_negative_p $allow_negative_p]
    }

    return $new_item_type_id
}

ad_proc -public as::item_type_sa::render {
    -type_id:required
    -section_id:required
    -as_item_id:required
    {-default_value ""}
    {-session_id ""}
    {-show_feedback ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-10

    Render a Short Answer Type
} {
    if {$default_value ne ""} {
        array set values $default_value
        set default $values(text_answer)
    } else {
        set default ""
    }

    return [list $default ""]
}

ad_proc -public as::item_type_sa::process {
    -type_id:required
    -session_id:required
    -as_item_id:required
    -section_id:required
    -subject_id:required
    {-staff_id ""}
    {-response ""}
    {-max_points 0}
    {-allow_overwrite_p t}
    {-package_id ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-11

    Process a Response to a Short Answer Type
} {
    as::item_data::new -session_id $session_id -subject_id $subject_id -staff_id $staff_id -as_item_id $as_item_id -section_id $section_id -text_answer [lindex $response 0] -points "" -allow_overwrite_p $allow_overwrite_p -package_id $package_id
}

ad_proc -public as::item_type_sa::results {
    -as_item_item_id:required
    -section_item_id:required
    -data_type:required
    -sessions:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-26

    Return the results of a given item in a given list of sessions as an array
} {
    db_foreach get_results {} {
        set results($session_id) $text_answer
    }

    if {[array exists results]} {
        return [array get results]
    } else {
        return
    }
}

ad_proc -private as::item_type_sa::add_to_assessment {
    -choices
    -correct_choices
    -assessment_id
    -section_id
    -as_item_id
    -title
    -after
    {-increasing_p "f"}
    {-allow_negative_p "f"}
} {
    Add the short answer item to an assessment. The creates the
    as_item_type_sa object and associates the as_item_id
    with an assessment, or updates the assessment with the latest version

    @param assessment_id Assessment to attach question to
    @param section_id Section the question is in
    @param as_item_id Item object this multiple choice belongs to
    @param title Title of question/choice set for question library
    @param after Add this question after the queston number in the section

    @author Dave Bauer (dave@solutiongrove.com)
    @creation-date 2006-10-25
} {
    if {![as::item::get_item_type_info -as_item_id $as_item_id] \
                || $item_type_info(object_type) ne "as_item_type_sa"} {
        set as_item_type_id [as::item_type_sa::new \
                                 -title $title \
                                 -increasing_p $increasing_p \
                                 -allow_negative_p $allow_negative_p]

        if {![info exists item_type_info(object_type)]} {
            # first item type mapped
            as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_type_id -type as_item_type_rel
        } else {
            # old item type existing
            set as_item_id [as::item::new_revision -as_item_id $as_item_id]
            db_dml update_item_type {}
        }
    } else {
        # old sa item type existing
        set as_item_id [as::item::new_revision -as_item_id $as_item_id]
        set as_item_type_id [as::item_type_sa::edit \
                                -as_item_type_id $as_item_type_id \
                                -title $title \
                                -increasing_p $increasing_p \
                                -allow_negative_p $allow_negative_p]

        as::item::update_item_type \
            -as_item_id $as_item_id \
            -item_type_id $as_item_type_id
    }
    as::item_display_tb::set_item_display_type \
            -as_item_id $as_item_id \
            -assessment_id $assessment_id \
            -section_id $section_id \
            -after $after
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
