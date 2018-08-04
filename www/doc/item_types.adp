
<property name="context">{/doc/assessment {Assessment}} {AS_item Types}</property>
<property name="doc(title)">AS_item Types</property>
<master>
<h2>Overview</h2>

This is a list of item types and <span style="font-weight: bold;">some of</span>
 their attributes we want to
support (a full list is stored with the design specifications). At
a later stage we are going to add the checks for each item_type to
this page as well. This does not mean we are going to create all of
them in the first shot. The attributes are *ONLY* those which are
not already part of as_items and therefore should be dealt with in
as_item_type_attributes (see <a href="as_items">Item Data
Model</a>
 for reference).
<h2>Specific Item Types</h2>
<ul>
<li>Open Question
<p>Open questions are text input questions for free text. For
obvious reasons they cannot be auto corrected. The difference
between an "Open Question" and a "Short Answer"
Item is that Open Questions accept alphanumeric data from a user
and only undergo manual "grading" by an admin user
through comparison with "correct" values configured
during Assessment authoring. Open Questions can either be short
(textbox) or long (text area) elements in the html form. Here are
several configuration options the authoring environment will
support (in addition to many others, such as alignment/orientation,
required/not required, etc etc):</p><ul>
<li>Size of the reply box: Radio buttons to set size of textbox:
small/medium/large; or text area</li><li>Prefilled Answer Box: richtext widget. The content of this
field will be prefilled in the response of the user taking the
survey -&gt; stored as item_default</li><li>Correct Answer Box: richtext widget. The person correcting the
answers will see the contents of this box as correct answer for
comparison with the user response. -&gt; stored as
feedback_text</li><li>[NTH nice to have?]: Button to add predefined comments next to
the correct answer box. This would be shown to the manual corrector
to quickly choose from when manually scoring the answer. What kind
of comments would these be? Should they be categorized entries in
the "message" system that admin users would populate over
time, that would be stuck into the authoring UI dynamically during
Assessment creation?</li>
</ul>
</li><li>Short Answer Item:
<p>Short Answer Items allow the user to give a short answer to an
answer box, which could be automatically corrected. The questioneer
can define what values are valid in each answer box and use various
compare functions to compare the output. The creation of a short
answer question will trigger entries into the as_item check tables.
In addition to supporting automated validation/grading, this item
type differs from "Open Questions" in that only textboxes
are supported -- meaning short answers, no text area essays.</p><ul>
<li>Intro_label: textarea. This contains the leading text that will
be presented before the first answerbox.</li><li>Extro_label: textarea. This contains the trailing text.</li><li>Number of Answerboxes: integer. Number of answerboxes presented
to the user.<br>
</li><li>The questioneer has the option to define multiple possible
correct answers that will be matched with the response of the user
in various ways. For each of the possible answers the following
fields are given (among others):
<ul>
<li>Answer: short_text. This contains the answer string that will
be matched against the response</li><li>Data type: integer vs real number vs. text<br>
</li><li>Upper/Lowercase: Radio boolean. This will control, whether we
treat the response case sensitive when comparing it to the correct
answers or not.</li><li>Value in %: short integer: How many percentage points a match
will awarded.</li><li>Size: Integer Select: size of the input box (small, medium,
large)</li><li>Compare by: Select (equal, contains, regexp). This defines how
the comparison between the answer string and the response shall
happen.</li><li>Regexp: Textarea. If the compare by is a "regexp",
this field contains the actual regexp.</li><li>sort_order<br>
</li><li>Allow in answerbox: This defines to which answerbox the answer
check of the short_answer is compared to. If we have four
answerboxes and the question was "Name four  European
Capitals of EU members", then you would 25 correct answers
which could be given in all answerboxes. If the question was
"Name four European Capitals of EU members ordered by
Name", then you&#39;d only have four answers "Athen,
Berlin, Copenhagen,<br>
</li>
</ul>
</li>
</ul>
</li><li>Matching Item:
<p>Matching questions are useful for matching some items on the
left with pull down menues on the right hand side of a survey. The
number of the items is identical to the number of items on the
right hand side. This also appears to be a Section of Items; each
Item consists of a single "phrase" against which it is to
be associated with one of a set of potential choices (displayed via
a select widget; could be radiobutton though too). If there are
several such matchings (three phrases &lt;-&gt; three items in the
popup select) then this is a Section with three Items. The UI for
this needs to be in section-edit, not item-edit.</p><ul>
<li>Settings:
<ul>
<li>Distribution of points: boolean (all or nothing / increasing).
All or nothing will either give 100%, if all correct answers are
given, or 0% else. Increasing will give (number of correct matches
/ number of total matches) *100% points.</li><li>Allow negative: boolean (yes/no). This will allow a negative
percentage as well (as the total result).</li>
</ul>
</li><li>A couple of match entries will be presented below the settings.
Each one will consist of:
<ul>
<li>Match item: This is the item which will be displayed on the
left side of the question presented to the respondee.</li><li>Matched item: This is the correct item from the select box on
the right side. For each match item on the left there will be a
select box on the right with ALL the matched items (when taking the
survey, that is...)</li>
</ul>
</li><li>In addition to submit, there is another button to allow further
answers to be filled in. Typed in values shall be remembered and 4
more answerboxes be shown.</li>
</ul>
</li><li>File upload item:
<p>A file upload question will allow the respondent to upload a
file. No additional attributes but the usual for every
question.</p>
</li><li>Multiple Choice items:
<p>Multiple Choice questions allow the respondee to choose from
multiple alternatives with the possibility to answer more than one
at a time. This will also deal with True/False and Multiple
response items.</p><ul>
<li>Settings:
<ul>
<li>Allow Multiple: boolean (yes/no). This will determine if the
respondee has the option to choose multiple possible answers for
his response. In the datamodell this information is stored with the
as_item_display_* object (e.g. along with the checkbox /
select).</li><li>Increasing: boolean (all or nothing / increasing). All or
nothing will either give 100%, if all correct answers are given, or
0% else. Increasing will give (number of correct matches / number
of total matches) *100% points.</li><li>Allow negative: boolean (yes/no). This will allow a negative
percentage as well (as the total result).</li>
</ul>
For each (possible) answer we have a couple of fields
(as_item_choices):
<ul>
<li>Correct answer: boolean, radio with grafik (red x, green y)
(yes/no). This marks if the current answer is a correct one.</li><li>Answer: Richtext widget. Need option to associate both/either a
numeric value and a text value to each choice.</li><li>Value: percentage value this answer gives to the respondee --
this is different from the "answer"</li><li>Feedback_text: richtext widget. This is a reply the student can
see at the end of the test giving him some more information on the
question he choose.</li><li>content_value: cr_item. If we have an image it will be shown
instead of the answer text. If we have a sound item, we will
generate audio includes.</li>
</ul>
</li><li>In addition to submit, there is another button to allow further
answers to be filled in. Typed in values shall be remembered and 4
more answerboxes be shown.</li><li>[Additional Feature]: Possibility to randomly choose from the
options. This would add a couple of fields:
<ul>
<li>To each answer: Fixed position: Select Box, Choose the
mandatory position when displaying the option (e.g. "none of
the above").</li><li>Number of correct answers: integer, defining how many correct
options have to be displayed. Check if enough correct answers have
been defined.</li><li>Number of answers: integer, defining how many options shall be
displayed in total (correct and incorrect). Check if enough answers
are available.</li><li>Display of options: Numerical, alphabetic, randomized or by
order of entry.</li><li>All radio button Items must have a "clear" button
that unsets all the radiobuttons for the item. (For that matter,
every Section and every Assessment also must have "clear"
buttons. Fairly trivial with Javascript.)</li>
</ul>
</li>
</ul>
Note that one special type of "multiple choice" question
consists of choices that are created by a database select. For
instance: a question like "Indicate your state" will have
a select widget that displays all state names obtained from the
states table in OpenACS.</li><li>Rank question:
<p>Rank questions ask for the answers to be ranked. This appears to
me to be a special case of the "matching question" in
which the select options are ordinal values, not arbitrary
strings.</p><ul>
<li>Rank Type: Boolean (alphabetic, numeric). Shall the rank be
from a to z or from 1 to n.</li><li>Only unique rank: Boolean (yes/no). Shall the ranking only
allow unique ranks (like 1,2,3,5,6 instead of 1,2,2,4,5)</li><li>Straight order: Boolean (alphabetic, numeric). Shall the rank
be in a straight order or is it allowed to skip values (1,2,3 vs.
1,3,4)</li><li>For each answer we ask the following questions:
<ul>
<li>Answer: Richtext widget.</li><li>Rank: correct rank</li>
</ul>
</li><li>In addition to submit, there is another button to allow further
answers to be filled in. Typed in values shall be remembered and 4
more answerboxes be shown.</li>
</ul>
</li><li>Matrix table (blocked questions):
<p>The idea here is a "question" consisting of a group of
questions. We include it here because to many users, this does
appear to be a "single" question.</p><p>However, it is actually more appropriately recognized to be a
"section" because it is a group of questions, a response
to each of which will need to be separately stored by the system.
Further, this is in fact a display option for the section that
could reasonably be used for any Item Type. For instance, there are
situations where an Assessment author may want to group a set of
selects, or radiobuttons, or small textboxes, etc.</p>
</li><li>Composite matrix-based multiple response item:
<p>Same as the matrix table, but you have different choices that
are displayed in each column.</p>
</li><li>Composite multiple choice with Fill-in-Blank item:
<p>Multiple Choice question with an additional short_text input
field. Usually used for the "Other" thing</p>
</li><li>Calculation:
<p>This type of question will not be supported. But we should make
sure we can take care of that type while importing the data from
WebCT. Therefore we have to know the values. At a later stage, we
will add more info on this.</p><ul>
<li>Formula: string</li><li>Units</li><li>Value (in %): integer</li><li>Required (boolean)</li><li>Ignore Space (boolean)</li><li>Ignore spell checking (boolean)</li><li>General Feedback: richtext</li>
</ul>
</li>
</ul>

Only site wide admins will get to see the following question types:
<ul><li>Database question:
<p>The answer to this question will be stored in the database. The
concept here is to support bidirectional interchange of data
between Assessment package tables and other package tables. Thus,
while assembling an Assessment to send to a user, data may be
pulled from some other table (eg users) to populate the Assessment
form. And similarly, when the user submits the Assessment form,
response data will be stored not only in Assessment entities
(as_item_data eg) but also back in the other table (eg users). The
question has the following additional fields:</p><ul>
<li>Table Name: short_string. This is the name of the table that is
being used for storing the responses.</li><li>Column: short_string. This is the column of the table that is
used for storing the responses.</li><li>Key Column: short_string. This is the column of the table that
matches the user_id of the respondee.</li>
</ul>
</li></ul>
