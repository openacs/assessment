
<property name="context">{/doc/assessment {Assessment}} {As_Item Display Types}</property>
<property name="doc(title)">As_Item Display Types</property>
<master>
<h2><span class="context">Overview</span></h2>
<span class="context">Displaying items to users has a couple of
challanges. First of all the display of a single item can be
different for each item_type (and even within a type). Second of
all, the display of items within a section can be different from
assessment to assessment. Last but not least, the whole assessment
might be displayed differently depending on attributes and the type
of assessment we are talking about.</span>
<p><span class="context"><strong><em>Note: please refer to the
discussion of Items <a href="as_items">here</a>. That
discussion complements the discussion here, and the data model
graphic pertaining to the Item Display Types system is available
there also.</em></strong></span></p>
<h2><span class="context">Item Display Types</span></h2>
<span class="context">Each item has an item_display_type object
associated with it, that defines how to display the item. Each
item_display_type has a couple of attributes, that can be passed to
the formbuilder for the creation of the widget. Each widget has at
least one item_display_type associated with it. In the long run I
think this system has the potential to become a part of OpenACS
itself (storing additional display information for each
acs_object), but we are not there yet :). Obviouslly we are talking
cr_item_types here as well.</span>
<p><span class="context">Each item_display_type has a couple of
attributes in common.</span></p>
<ul>
<li><span class="context">item_display_type_id</span></li><li><span class="context">item_type_name - name like "Select
box, aligned right", stored in the name field of
CR.<br>
</span></li><li><span class="context">presentation_type - the type of
"widget" displayed when the Item is output in html. There
are many types we should support beyond the stock html types. We
are talking <a href="../../../acs-templating/www/doc/widgets/index">ACS Templating
widgets</a> here.<br>
</span></li><li>
<span class="context">item_answer_alignment - the orientation
between the "question part" of the Item (the
item_text/item_subtext) and the "answer part" -- the
native Item widget (eg the textbox) or the 1..n choices.
Alternatives accommodate L-&gt;R and R-&gt;L alphabets (or is this
handled automagically be Internationalization?) and include:</span><ol>
<li><span class="context">beside_left - the "answers" are
left of the "question"</span></li><li><span class="context">beside_right - the "answers"
are right of the "question"</span></li><li><span class="context">below - the "answers" are below
the "question"</span></li><li><span class="context">above - the "answers" are above
the "question"</span></li>
</ol>
</li><li><span class="context">html_display_options - field to specify
other stuff like textarea dimensions ("rows=10 cols=50"
eg)</span></li><li><span class="context"><span class="context"><span class="reg">as_item_default - optional field that sets what the as_item
will display when first output (eg text in a textbox; eg the
defaults that ad_dateentrywidget expects: "" for "no
date", "0" for "today", or else some
specific date set by the author; see <a href="http://www.epimetrics.com/groups/Bay%20Area%20OpenACS%20Users%20Group/questionnaires/index#Date%20Test">
this example</a>)</span></span></span></li>
</ul>
<p>Depending on the presentation_types <font color="red">additonal
attributes (presentation_type attributes)</font> come into play
(are added as attributes to the CR item type) (mark: this is not
feature complete. It really is up to the coder to decide what
attributes each widget should have, down here are only
*suggestions*). Additionally we&#39;re not mentioning all HTML
possibilities associated with each type (e.g. a textarea has width
and heigth..).</p>
<ul>
<li>textbox - single-line typed entry
<ul><li>abs_size - An abstraction of the real size value in
"small","medium","large". Up to the
developer how this translates.</li></ul>
</li><li>text area - multiple-line typed entry
<ul><li>abs_size - An abstraction of the real size value in
"small","medium","large". Up to the
developer how this translates.</li></ul>
</li><li>radiobutton - single-choice multiple-option
<ul>
<li>choice_orientation - the pattern by which 2..n Item Choices are
laid out when displayed. Note that this isn&#39;t a purely
stylistic issue better left to the .adp templates or css; the
patterns have semantic implications that the Assessment author
appropriately should control here. Note also that Items with no
Choices (eg a simple textbox Item) has no choice_orientation, but
handles the location of that textbox relative to the Item label by
the item_alignment option (discussed below).
<ol>
<li>horizontal - all Choices are in one line</li><li>vertical - all Choices are in one column</li><li>matrix_col-row - Choices are laid out in matrix, filling first
col then row</li><li>matrix_row-col -Choices are laid out in matrix, filling first
row then col</li>
</ol>
</li><li>Button type - type of button to use</li><li>sort_order: Numerical, alphabetic, randomized or by order of
entry (sort_order field).</li>
</ul>
</li><li>checkbox - multiple-choice multiple-option
<ul>
<li>choice_orientation (see above)</li><li>allow_multiple_p - Is it allow to select multiple values ?</li><li>sort_order: Numerical, alphabetic, randomized or by order of
entry (sort_order field).</li>
</ul>
</li><li>select - multiple-option displayed in "popup
menu"</li><li style="list-style: none"><ul>
<li>sort_order: Numerical, alphabetic, randomized or by order of
entry (sort_order field).</li><li><span class="context"><span class="reg">allow_multiple_p - Is
it allow to select multiple values ?</span></span></li>
</ul></li><li>multiple-choice-other: Consider, for instance, a combo box that
consists of a radiobutton plus a textbox -- used for instance when
you need a check "other" and then fill in what that
"other" datum is. In effect this is a single Item but it
has two different forms: a radiobutton and a textbox.
<ul>
<li>other_size: size of the other text field.</li><li>other_label: label (instead of "other").</li><li>display_type: What display type should be used for the
multiple-choice-part ?</li>
</ul>
</li><li>pop-up_date - a widget with month-day-year select elements that
resets the day element based on year and month (ie include Feb 29
during leap years -- via Javascript) and tests for valid dates</li><li>typed_date - similar to pop-up_date but month-day-year elements
are textboxes for all-keyboard entry; needs no resetting scripts
but does need date validity check</li><li>image_map - requires a linked image; the image map coordinates
are handled as Item Choices</li><li>file_upload - present a File box (browse button, file_name
textbox, and submit button together) so user can upload a file</li><li><font color="red">many more</font></li>
</ul>
<p>In addition, there are some potential presentation_types that
actually seem to be better modeled as a Section of separate
Items:</p>
<ul>
<li>ranking - a set of alternatives each need to be assigned an
exclusive rank ("Indicate the order of US Presidents from bad
to worse"). Is this one Item with multiple Item Choices?
Actually, not, since each alternative has a value that must be
separately stored (the tester would want to know that the testee
ranked GWB last, for instance).</li><li><font color="red">...</font></li>
</ul>
<h2><a name="section_display" id="section_display">Section
display</a></h2>

A section can be seen as a form with all the items within this
section making up the form. Depending on the type of assessment we
are talking about, the section can be displayed in various
ways.<br>

The section display page will be made up of the following
attributes:<br>
<ul>
<li>Name: text. Name of the section like "test view
sorted"</li><li>Number of questions per page: integer. THIS HAS TO BE CHANGED
IN THE DATAMODELL FROM PAGINATION_STYLE. How many questions shall
be displayed per page in this section. Usually the answer would be
"" for all questions on one page (default), or
"1" for one question per page (aka one question at a
time), but any number is imagineable.</li><li>
<span class="context"><span class="reg">ADP style: ADP to
choose from that will control the makeup of the section along with
the option to create a new one and a link to edit existing ones
that</span></span><span class="context"><span class="reg">Opens a
page with the current layout of the section in an textarea to be
edited</span></span><span class="context"><span class="reg">.
Deferred., was item_orientation, presentation_type, and
item_alignment and item_labels_as_headers_p<br>
</span></span>
</li><li>Sort questions: Select (random, manual, alphabetic,
numerical)&lt;&gt;</li><li>&lt;&gt;Back button allowed: boolean (back_button_p). Is the
use of the back button allowed? If not, the back button should be
broken on purpose and result in an error.<br>
</li><li>Submit Answer seperately: boolean. Shall each answer be
answered seperately, even if we display multiple answers? If yes,
display a "save" button next to each answer along with
green "V" if the answer has been already submitted. To
finish the section, you still have to click on the OK button at the
buttom. Once the section is finished all answers that have not been
seperatly submitted will be treated as not being submitted at
all.<br>
</li>
</ul>

Additionally each section has certain parameters that determine the
look and feel of the section itself. Luckily it is not necessary to
have differing attributes for the sections, therefore all these
display attributes can be found with the <a href="grouping">section and assessment specification</a>
