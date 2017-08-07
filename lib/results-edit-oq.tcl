# Display open question type data.
# author Timo Hentschel (timo@timohentschel.de)

db_1row item_type_data {}
set keywords [string tolower [ns_quotehtml [join $keywords "\n"]]]
set answer_text [ad_text_to_html -no_links -- $answer_text]

foreach keyword $keywords {
    regsub -all -nocase $keyword $answer_text {<span style="color:green">\0</span>} answer_text
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
