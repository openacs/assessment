
<property name="context">{/doc/assessment {Assessment}} {As_Items}</property>
<property name="doc(title)">As_Items</property>
<master>
<h2><span class="context">Overview</span></h2>
<p><span class="context">The  As_Item and Section catalogues
are central parts of the assessment system. These repositories
support reuse of Assessment components by storing of the various
as_items (or questions if you like) and groups of as_items (e.g.
Sections) that can be used in an assessment. You are able to
add/edit/delete an as_item of a certain type to a certain scope.
Furthermore it allows you to search and browse for questions for
inclusion in your assessment as well as import and export multiple
questions using various formats.</span></p>
<p><span class="context">In this description here we will only
discuss the design implications for as_items. Green colored tables
have to be internationlized.</span></p>
<p><span class="context">Each as_item consists of a specific
as_item Type like "Multiple Choice Question" or
"Free Text". Each <a href="item_types">as_item
Type</a> adds additional Attributes to the as_item, thereby making
it pretty flexible. Additionally each as_item has a related
<a href="display_types">display type</a> storing information
on how to display this as_item. This way we can create an
adp-snippet which we can include to display a certain as_item (the
snippet is stored de-normalized in the as_items table and update on
every change to the as_item or the as_item_type).<br>
</span></p>
<p><span class="context">How is this achieved concretely? Each
as_item Type has it&#39;s own table with attributes useful for this
as_item type. All tables (as_items, as_item_type_*,
as_item_display_*) are controlled by the content repository. Each
as_item is linked using acs-relationships to the specific items of
the as_item_type_*  and as_item_display_* tables. Each as_item
can only be linked to one as_item_type instance and one
as_item_display instance.<br>
</span></p>
<p><span class="context">Categorization and internationalization
will make it into OpenACS 5.2, therefore we are not dealing with it
in Assessment separately but use the (to be) built in functionality
of OpenACS 5.2</span></p>
<p><span class="context">Additionally we have support functionality
for an as_item. This includes the help functionality. To give
Assessment authors flexibility in adapting as_item defaults, help
messages, etc for use in different Assessments, we abstract out a
number of attributes from as_items into mapping tables where
"override" values for these attributes can optionally be
set by authors. If they choose not to set overrides, then the
values originally created in the as_item supersede.</span></p>
<p><span class="context">Separately we will deal with Checks on
as_items. These will allow us to make checks on the input (is the
value given by the user actually a valid value??), branches (if we
display this as_item, which responses have to have been given) and
post-input checks (how many points does this answer
give).</span></p>
<p><span class="context">Here is the graphical schema for the
as_item-related subsystems, including the as_item Display subsystem
described <a style="font-family: monospace;" href="display_types">here</a>.<br>
</span></p>
<center><p><span class="context"><img alt="Data modell graphic" src="images/assessment-itemfocus.jpg" style="width: 752px; height: 1121px;"></span></p></center>
<h2><span class="context">Core Function: as_items<br>
</span></h2>
<ul><li>
<span class="context">
<strong>as_items</strong> are the
"questions" that constitute the atomic focus of the
Assessment package. Each as_item is of a certain type, that can
give the as_item additional attributes, making it really flexible.
The following attributes are common to all as_item types.</span><ul>
<li><span class="context">as_item_id</span></li><li><span class="context">cr::name - some phrase used in admin
UIs</span></li><li><span class="context">cr::title - the primary "label"
attached to an as_item&#39;s display</span></li><li><span class="context">cr::description - some descriptive
text</span></li><li><span class="context">subtext - a secondary label, needed for
many kinds of questions</span></li><li><span class="context">field_code - a short label for use in
data output header rows, etc</span></li><li><span class="context">required_p - whether as_item must be
answered (default value, can be overridden)</span></li><li>
<span class="context">data_type - This is the expected
data_type of the answer. Previously "abstract_data_type"
but omitting the superfluous "abstract" term; selected
from the data types supported in the RDBMS:</span><ol>
<li><span class="context">integer</span></li><li><span class="context">numeric</span></li><li><span class="context">exponential - stored in the db as a
varchar; of form 9.999e99</span></li><li><span class="context">varchar</span></li><li><span class="context">text</span></li><li><span class="context">date</span></li><li><span class="context">boolean (char(1) 't' 'f'
in Oracle)</span></li><li><span class="context">timestamp (should work for all coarser
granularities like date etc)</span></li><li><span class="context">content_type -- a derived type: something
in the CR (instead of a blob type since we use the CR for such
things now)</span></li>
</ol><span class="context"><font color="red"><br></font></span>
</li><li><span class="context">max_time_to_complete - optional max
number of seconds to perform as_item</span></li><li><span class="context">adp_chunk - a denormalization to cache
the generated "widget" for the as_item (NB: when any
change is made to an as_item_choice related to an as_item, this
will have to be updated!)</span></li>
</ul><p><span class="context">
<em>Permissions / Scope</em>: as_items
need a clearly defined scope, in which they can be reused. Instead
of defining a special scope variable we will use the acs permission
system to grant access rights to an as_item.</span></p><ul>
<li><span class="context">Read: An assessment author (who is
granted this permission) can reuse this as_item in one of his
sections. (NB: Usually the original author has admin privileges.).
This is a finer granulation than the previous "enabled_p"
as it allows specific access to an item.</span></li><li><span class="context">Write: Author can reuse and change this
as_item.</span></li><li><span class="context">Admin: Author can reuse, change and give
permission on this as_item</span></li>
</ul><span class="context"><br></span>
</li></ul>
<h2><span class="context"><span class="reg">As_item
Types</span></span></h2>
<span class="context"><span class="reg">
<strong><font color="green">as_item Types (as_item_type_*)</font></strong> define types
of as_items like "Open Question", "Calculation"
and others. The as_item type will also define in what format the
answer should be stored. For <span style="font-weight: bold;">each</span> as_item type a cr_as_item_type
will be generated. Each object of this type is linked to the
primary object of the as_item (see above) using relationships. This
has the benefit that we split the core attributes of an as_item
from the type specific ones and the display ones (see down below).
Using cr_as_item_type usage allows us to create and reuse standard
as_items (e.g. for the likert scale), by linking different
questions with the answer possibilities (and the same attributes)
to one as_item_type object. If we have objects that are linked this
way, we can generate the matrix for them easily.</span></span>
 A
functional list of all as_item types and their attributes can be
found in the <a href="http://openacs.org/projects/openacs/packages/assessment/requirements/item_types">
requirements section.</a>
<ul>
<li><span class="context"><span class="reg"><span class="context"><span class="reg"><strong><font color="green">Open
Question
(as_item_type_oq):</font></strong></span></span></span></span></li><li style="list-style: none; display: inline"><ul>
<li>as_item_type_id<br>
</li><li>cr::name - Identifier<br>
</li><li>default_value: The content of this field will be prefilled in
the response of the user taking the survey</li><li>feedback_text: The person correcting the answers will see the
contents of this box as correct answer for comparison with the user
response.</li>
</ul></li><li><span class="context"><span class="reg"><span class="context"><span class="reg"><strong><font color="green">Short
Answer
(as_item_type_sa):</font></strong></span></span></span></span></li><li style="list-style: none; display: inline"><ul>
<li>as_item_type_id<br>
</li><li>cr::name - Identifier</li><li>increasing_p:  Increasing will give (number of correct
matches / number of total matches) *100% points. All or nothing
will either give 100%, if all correct answers are given, or 0%
else.</li><li>allow_negative_p: This will allow a negative percentage as well
(as the total result).</li>
</ul></li>
</ul>
<ul>
<li><span class="context"><span class="reg"><span class="context"><span class="reg"><strong><font color="green">Short
Answer Answers
(as_item_sa_answers):</font></strong></span></span></span></span></li><li style="list-style: none; display: inline"><ul>
<li>answer_id<br>
</li><li>cr::name - Identifier</li><li>cr::title - Answer string that will be matched against the
response</li><li>data_type - Integer vs. real number vs. text</li><li>case_sensitive_p - Shall the match be case sensitive</li><li>percent_score - Percentage a correct match gives<br>
</li><li>compare_by - How is the comparison done (equal, contains,
regexp)</li><li>regexp_text: If the compare_by is a "regexp", this
field contains the actual regexp.</li><li>allowed_answerbox_list - list with all answerbox ids (1 2 3 ...
n) whose response will be tried to match against this answer. An
empty field indicates the answer will be tried to match against all
answers</li><li>NOTE: These answers are reusable, that&#39;s why we have a
relationship.<br>
</li>
</ul></li>
</ul>
<ul>
<li><span class="context"><span class="reg"><span class="context"><span class="reg"><strong><font color="green">Multiple
Choice Item
(as_item_type_mc)<br>
</font></strong></span></span></span></span></li><li style="list-style: none; display: inline"><ul>
<li>cr::name - Identifier<br>
</li><li>increasing_p:  Increasing will give (number of correct
matches / number of total matches) *100% points. All or nothing
will either give 100%, if all correct answers are given, or 0%
else.</li><li>allow_negative_p: This will allow a negative percentage as well
(as the total result).</li><li>num_correct_answers: How many correct options have to be
displayed. Check if enough correct choices have been defined.</li><li>num_answers: How many options shall be displayed in total
(correct and incorrect). Check if enough choices are
available.</li>
</ul></li>
</ul>
<ul>
<li>
<span class="context">
<strong><font color="green">Multiple
Choices (as_item_choices)</font></strong> contain additional
information for all multiple choice as_item_types. Obvious examples
are radiobutton and checkbox as_items, but pop-up_date, typed_date
and image_map as_items also are constructed via as_item Choices.
Each choice is a child to an as_item_type Object. Note the
difference. <span style="font-weight: bold;">A choice does not
belong to an as_item, but to the instance of the
as_item_type!</span> This way we can reuse multiple choice answers
easier. It is debatable if we should allow n:m relationships
between choices and as_item_types (thereby allowing the same choice
been reused). In my opinion this is not necessary, therefore we
relate this using the parent_id (which will be treated as a
relationship in cr_child_rels by the content repository
internally). Following the Lars Skinny Table approach of conflating
all the different potential data types into one table, we provide
columns to hold values of the different types and another field to
determine which of them is used. as_item Choices have these
attributes:</span><ul>
<li>choice_id</li><li>cr::parent_id (belonging to an as_item_type_mc object).</li><li>cr::name - Identifier<br>
</li><li>cr::title - what is displayed in the choice&#39;s
"label"</li><li>data_type - which of the value columns has the information this
Choice conveys</li><li>numeric_value - we can stuff both integers and real numbers
here<br>
</li><li>text_value</li><li>boolean_value</li><li>timestamp_value<br>
</li><li>content_value - references an as_item in the CR -- for an
image, audio file, or video file</li><li>feedback_text - where optionally some preset feedback can be
specified by the author</li><li>selected_p - Is this choice selected by default (when the item
is presented to the user)</li><li>correct_answer_p - Is this choice the correct answer<br>
</li><li>sort_order - In which order shall this choice appear with
regards to the MC item. Note, this can be overridden by the display
type.<br>
</li><li>percent_score - Score given to the user if this choice is
selected (in percent).<br>
</li>
</ul><p>NB: In earlier versions (surveys/questionnaire), each Choice
definition carried with it any range-checking or text-filtering
criteria; these are now abstracted to the as_item-Checks and
Inter-as_item Checks.</p>
</li><li><span class="context"><span class="reg"><span class="context"><span class="reg"><strong><font color="green">Image Map
Multiple Choice Item
(as_item_type_im):<br>
</font></strong></span></span></span></span></li><li style="list-style: none; display: inline"><ul>
<li>cr::name - Identifier</li><li>cr::title - Title of the image map.<br>
</li><li>increasing_p:  Increasing will give (number of correct
matches / number of total matches) *100% points. All or nothing
will either give 100%, if all correct answers are given, or 0%
else.</li><li>allow_negative_p: This will allow a negative percentage as well
(as the total result).</li><li><span class="context"><span class="reg">image_item_id -
cr_revision_id of the image, references
cr_revisions<br>
</span></span></li>
</ul></li>
</ul>
<ul>
<li><span class="context"><span class="reg"><span class="context"><span class="reg"><strong><font color="green">Image Map
Choices
(as_item_image_choices):<br>
</font></strong></span></span></span></span></li><li style="list-style: none; display: inline"><ul>
<li>choice_id</li><li>cr::parent_id (belonging to an as_item_type_im object).</li><li>cr::name - Identifier<br>
</li><li>cr::title - what is displayed in the choice&#39;s
"label"</li><li>data_type - which of the value columns has the information this
Choice conveys</li><li>numeric_value - we can stuff both integers and real numbers
here<br>
</li><li>text_value</li><li>boolean_value</li><li>content_value - references an as_item in the CR -- for an
image, audio file, or video file</li><li>feedback_text - where optionally some preset feedback can be
specified by the author</li><li>selected_p - Is this choice selected by default (when the item
is presented to the user)</li><li>correct_answer_p<br>
</li><li>percent_score</li><li><span class="context"><span class="reg">area_type - Type of the
area that uses the coordinates_string</span></span></li><li><span class="context"><span class="reg">coordinates_string -
String that defines the html area coordinates if this choice is
used in an image_map question.</span></span></li>
</ul></li>
</ul>
<h2><span class="context">Item Display Types</span></h2>
<span class="context">Each item has an item_display_type object
associated with it, that defines how to display the item. Each
item_display_type has a couple of attributes, that can be passed to
the formbuilder for the creation of the widget. Each widget has at
least one item_display_type associated with it. In the long run I
think this system has the potential to become a part of OpenACS
itself (storing additional display information for each
acs_object), but we are not there yet :). Obviously we are talking
cr_item_types here as well.</span>
<p><span class="context">Each item_display_type has a couple of
attributes in common.</span></p>
<ul>
<li><span class="context">item_display_id</span></li><li><span class="context">cr::name - name like "Select box,
aligned right", stored in the name field of
CR.<br>
</span></li><li><span class="context">html_display_options - field to specify
other stuff like textarea dimensions ("rows=10 cols=50"
eg)</span></li>
</ul>
<p><span class="context">Depending on the presentation_types
<font color="red">additional attributes (presentation_type
attributes)</font> come into play (are added as attributes to the
CR item type) (mark: this is not feature complete. It really is up
to the coder to decide what attributes each widget should have,
down here are only *suggestions*). Additionally we&#39;re not
mentioning all HTML possibilities associated with each type (e.g. a
textarea has width and height..) as these can be parsed in via the
html_display_options.<br>
</span></p>
<ul>
<li>
<span class="context">textbox (as_item_display_tb) -
single-line typed entry</span><ul>
<li><span class="context">abs_size - An abstraction of the real
size value in
"small","medium","large". Up to the
developer how this translates.</span></li><li>
<span class="context"><span class="context"><span class="reg"><span class="context"><span class="reg">item_answer_alignment
- the orientation between the "question part" of the Item
(the title/subtext) and the "answer part" -- the native
Item widget (eg the textbox) or the 1..n choices. Alternatives
accommodate L-&gt;R and R-&gt;L alphabets (or is this handled
automagically be Internationalization?) and
include:</span></span></span></span></span><ol>
<li><span class="context">beside_left - the "answers" are
left of the "question"</span></li><li><span class="context">beside_right - the "answers"
are right of the "question"</span></li><li><span class="context">below - the "answers" are below
the "question"</span></li><li><span class="context">above - the "answers" are above
the "question"</span></li>
</ol><span class="context"><br></span>
</li>
</ul>
</li><li>short_answer (as_item_display_sa) - Multiple textboxes in one
item.</li><li style="list-style: none; display: inline"><ul>
<li><span class="context"><span class="reg">abs_size - An
abstraction of the real size value in
"small","medium","large". Up to the
developer how this translates.</span></span></li><li>box_orientation - the pattern by which 2..n answer boxes are
laid out when displayed. Note that this isn&#39;t a purely
stylistic issue better left to the .adp templates or css; the
patterns have semantic implications that the Assessment author
appropriately should control here.
<ol>
<li>horizontal - all answerboxes are in one continuous
line.<br>
</li><li>vertical - all answerboxes are in one column</li>
</ol><br>
</li>
</ul></li><li>text area (as_item_display_ta) - multiple-line typed entry
<ul>
<li>abs_size - An abstraction of the real size value in
"small","medium","large". Up to the
developer how this translates.</li><li>acs_widget - the type of "widget" displayed when the
Item is output in html. There are many types we should support
beyond the stock html types. We are talking <a href="../../../acs-templating/www/doc/widgets/index">ACS Templating
widgets</a> here.<br>
</li><li>item_answer_alignment - the orientation between the
"question part" of the Item (the title/subtext) and the
"answer part" -- the native Item widget (eg the textbox)
or the 1..n choices. Alternatives accommodate L-&gt;R and R-&gt;L
alphabets (or is this handled automagically be
Internationalization?) and include:
<ol>
<li>beside_left - the "answers" are left of the
"question"</li><li>beside_right - the "answers" are right of the
"question"</li><li>below - the "answers" are below the
"question"</li><li>above - the "answers" are above the
"question"</li>
</ol><br>
</li>
</ul>
</li><li>radiobutton (as_item_display_rb) - single-choice
multiple-option
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
<li>horizontal - all Choices are in one line</li><li>vertical - all Choices are in one column</li>
</ol>
</li><li>choice_label_orientation - how shall the label be positioned in
relation to the choice (top, left, right, buttom).<br>
</li><li>sort_order_type: Numerical, alphabetic, randomized or by order
of entry (sort_order field).</li><li>
<span class="context"><span class="reg"><span class="context"><span class="reg">item_answer_alignment - the orientation
between the "question part" of the Item (the
title/subtext) and the "answer part" -- the native Item
widget (eg the textbox) or the 1..n choices. Alternatives
accommodate L-&gt;R and R-&gt;L alphabets (or is this handled
automagically be Internationalization?) and
include:</span></span></span></span><ol>
<li><span class="context">beside_left - the "answers" are
left of the "question"</span></li><li><span class="context">beside_right - the "answers"
are right of the "question"</span></li><li><span class="context">below - the "answers" are below
the "question"</span></li><li><span class="context">above - the "answers" are above
the "question"</span></li>
</ol><span class="context"><br></span>
</li>
</ul>
</li><li>checkbox (as_item_display_cb) - multiple-choice multiple-option
<ul>
<li>choice_orientation (see above)</li><li>choice_label_orientation<br>
</li><li>allow_multiple_p - Is it allow one to select multiple values ?</li><li>sort_order_type: Numerical, alphabetic, randomized or by order
of entry (sort_order field).</li><li>
<span class="context"><span class="reg"><span class="context"><span class="reg">item_answer_alignment - the orientation
between the "question part" of the Item (the
title/subtext) and the "answer part" -- the native Item
widget (eg the textbox) or the 1..n choices. Alternatives
accommodate L-&gt;R and R-&gt;L alphabets (or is this handled
automagically be Internationalization?) and
include:</span></span></span></span><ol>
<li><span class="context">beside_left - the "answers" are
left of the "question"</span></li><li><span class="context">beside_right - the "answers"
are right of the "question"</span></li><li><span class="context">below - the "answers" are below
the "question"</span></li><li><span class="context">above - the "answers" are above
the "question"</span></li>
</ol><span class="context"><br></span>
</li>
</ul>
</li><li>select (as_item_display_sb) - multiple-option displayed in
"popup menu" (select box)<br>
</li><li style="list-style: none; display: inline"><ul>
<li>sort_order_type: Numerical, alphabetic, randomized or by order
of entry (sort_order field).</li><li><span class="context"><span class="reg">allow_multiple_p - Is
it allow one to select multiple values ?</span></span></li><li>
<span class="context"><span class="reg"><span class="context"><span class="reg">item_answer_alignment - the orientation
between the "question part" of the Item (the
title/subtext) and the "answer part" -- the native Item
widget (eg the textbox) or the 1..n choices. Alternatives
accommodate L-&gt;R and R-&gt;L alphabets (or is this handled
automagically be Internationalization?) and
include:</span></span></span></span><ol>
<li><span class="context">beside_left - the "answers" are
left of the "question"</span></li><li><span class="context">beside_right - the "answers"
are right of the "question"</span></li><li><span class="context">below - the "answers" are below
the "question"</span></li><li><span class="context">above - the "answers" are above
the "question"</span></li>
</ol><span class="context"><br></span>
</li>
</ul></li><li>image map (as_item_display_im) - Title with picture</li><li style="list-style: none; display: inline"><ul>
<li>
<span class="context"><span class="reg">allow_multiple_p - Is
it allow one to select multiple values ?</span></span><br>
</li><li>
<span class="context"><span class="reg"><span class="context"><span class="reg"><span class="context"><span class="reg">item_answer_alignment - the orientation between the
"question part" of the Item (the title/subtext) and the
"answer part" -- the native Item widget (eg the textbox)
or the 1..n choices. Alternatives accommodate L-&gt;R and R-&gt;L
alphabets (or is this handled automagically be
Internationalization?) and
include:</span></span></span></span></span></span><ol>
<li><span class="context">beside_left - the "answers" are
left of the "question"</span></li><li><span class="context">beside_right - the "answers"
are right of the "question"</span></li><li><span class="context">below - the "answers" are below
the "question"</span></li><li><span class="context">above - the "answers" are above
the "question"</span></li>
</ol><span class="context"><br></span>
</li>
</ul></li><li>multiple-choice-other (as_item_display_mco): Consider, for
instance, a combo box that consists of a radiobutton plus a textbox
-- used for instance when you need a check "other" and
then fill in what that "other" datum is. In effect this
is a single Item but it has two different forms: a radiobutton and
a textbox. The answer will NOT be stored in the answer choice
table. There is no item_type "multiple-choice-other".
<ul>
<li>widget_choice - Type of the widget for the multiple choice
part</li><li>sort_order_type: Numerical, alphabetic, randomized or by order
of entry (sort_order field).</li><li>other_size: size of the other text field.</li><li>other_label: label (instead of "other").</li><li>
<span class="context"><span class="reg"><span class="context"><span class="reg"><span class="context"><span class="reg">item_answer_alignment - the orientation between the
"question part" of the Item (the title/subtext) and the
"answer part" -- the native Item widget (eg the textbox)
or the 1..n choices. Alternatives accommodate L-&gt;R and R-&gt;L
alphabets (or is this handled automagically be
Internationalization?) and
include:</span></span></span></span></span></span><ol>
<li><span class="context">beside_left - the "answers" are
left of the "question"</span></li><li><span class="context">beside_right - the "answers"
are right of the "question"</span></li><li><span class="context">below - the "answers" are below
the "question"</span></li><li><span class="context">above - the "answers" are above
the "question"</span></li>
</ol>
</li>
</ul><br>
</li><li>pop-up_date - a widget with month-day-year select elements that
resets the day element based on year and month (ie include Feb 29
during leap years -- via Javascript) and tests for valid dates</li><li style="list-style: none; display: inline"><ul><li><br></li></ul></li><li>typed_date - similar to pop-up_date but month-day-year elements
are textboxes for all-keyboard entry; needs no resetting scripts
but does need date validity check</li><li style="list-style: none; display: inline"><ul><li><br></li></ul></li><li>file_upload - present a File box (browse button, file_name
textbox, and submit button together) so user can upload a file</li>
</ul>
<h2><span class="context">Help System</span></h2>
<span class="context">The help system should allow a small
"?" appear next to an object&#39;s title that has a help
text identified with it. Help texts are to be displayed in the nice
bar that Lars created for OpenACS in the header. Each object can
have multiple help texts associated with it (which will be
displayed in sort order with each hit to the "?".) and we
can reuse the help text, making this an n:m relationship (using
cr_rels). E.g. you might want to have a default help text for
certain cr_as_item_types, that&#39;s why I was thinking about
reuse...</span>
<p><span class="context">Relationship attributes:</span></p>
<ul>
<li><span class="context">as_item_id</span></li><li><span class="context">message_id - references
as_messages</span></li><li><span class="context">sort_order (in which order do the
messages appear)</span></li>
</ul>
<p><span class="context">
<strong>Messages (as_messages)</strong>
abstracts out help messages (and other types of messages) for use
in this package. Attributes include:</span></p>
<ul>
<li><span class="context">message_id</span></li><li><span class="context">message</span></li>
</ul>
