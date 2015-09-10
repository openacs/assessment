# Display multiple choice type data.
# author Timo Hentschel (timo@timohentschel.de)

db_1row item_type_data {}

# user answer
ad_form -name results_edit_mc_user -mode display -form {
    {item_data_id:text(hidden) {value $item_data_id}}
}

set user_answer [as::item_data::get -subject_id $subject_id -as_item_id $as_item_id -session_id $session_id]

set presentation_type [as::item_form::add_item_to_form -name results_edit_mc_user -section_id $section_id -item_id $as_item_id -session_id $session_id -default_value $user_answer -show_feedback all]

# reference answer
ad_form -name results_edit_mc_reference -mode display -form {
    {item_data_id:text(hidden) {value $item_data_id}}
}

array set reference_answer $user_answer
set reference_answer(choice_answer) [db_list reference_answer {}]

set presentation_type [as::item_form::add_item_to_form -name results_edit_mc_reference -section_id $section_id -item_id $as_item_id -session_id $session_id -default_value [array get reference_answer] -show_feedback correct]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
