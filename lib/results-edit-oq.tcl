# Display open question type data.
# author Timo Hentschel (timo@timohentschel.de)

db_1row item_type_data {}
set keywords [string tolower [ad_quotehtml [join $keywords "\n"]]]
set answer_text [ad_text_to_html -no_links -- $answer_text]

foreach keyword $keywords {
    regsub -all -nocase $keyword $answer_text {<font color=green>\0</font>} answer_text
}
