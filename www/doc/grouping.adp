
<property name="context">{/doc/assessment/ {Assessment}} {Assessment}</property>
<property name="doc(title)">Assessment</property>
<master>
<style>
div.sect2 > div.itemizedlist > ul.itemizedlist > li.listitem {margin-top: 16px;}
div.sect3 > div.itemizedlist > ul.itemizedlist > li.listitem {margin-top: 6px;}
</style>              
<p>Here is a graphical overview of the subsystem in the Assessment
package that organizes Items into Sections and whole
Assessments:<br>
</p>
<center><p><img alt="Data model graphic" src="images/assessment-groupingfocus.jpg" style="width: 797px; height: 565px;"></p></center>
<h2>Review of Specific Entities</h2>
<ul>
<li>Assessments (as_assessments) are the highest-level container in
the hierarchical structure. They define the key by which all other
entities are assembled into meaningful order during display,
processing, retrieval and display of Assessment information.
<p>The primary key assessment_id is a revision_id inherited from
cr_revisions. Note, the CR provides two main types of entities --
cr_items and cr_revisions. The latter are where sequential versions
of the former go, while cr_items is where the "current"
version of an entity can be stored, where unchanging elements of an
entity are kept, or where data can be cached. This is particularly
useful if the system needs a single "live" version, but
it isn&#39;t appropriate in situations where all versions
potentially are equally-important siblings. In the case of the
Assessment package, it seems likely that in some applications,
users would indeed want to designate a single "live"
version, while in many others, they wouldn&#39;t. </p><p>Attributes of Assessments will include those previously included
in Surveys plus some others:</p><ul>
<li>assessment_id</li><li>cr:name - a curt name appropriate for URLs<br>
</li><li>cr:title - a formal title to use in page layouts etc</li><li>creator_id - Who is the "main" author and creator of
this assessment</li><li>cr:description - text that can appear in introductory web
pages</li><li>instructions - text that explains any specific steps the
subject needs to follow</li><li>mode - whether this is a standalone assessment (like current
surveys), or if it provides an "assessment service" to
another OpenACS app, or a "web service" via SOAP etc</li><li>editable_p - whether the response to the assessment is editable
once an item has been responded to by the user.</li><li><span class="context"><span class="reg">anonymous_p - This
shows whether the creator of the assessment will have the
possibility to see the personal details of the respondee or not. In
particular this will exclude the user_id from the CSV files. It
shall still be possible to see the user that have not finished the
survey though.</span></span></li><li><span class="context"><span class="reg">secure_access_p - The
assessment can only be taken if a secure connection (https) is
used.</span></span></li><li><span class="context"><span class="reg">reuse_responses_p - If
yes, the system will look for previous responses to the questions
and prefill the last answer the respondee has given in the
assessment form of the respondee</span></span></li><li><span class="context"><span class="reg">show_item_name_p - If
yes, the respondee will see the name of the item in addition to the
item itself when taking the survey.</span></span></li><li>entry_page - The customizable entry page that will be displayed
before the first response. </li><li>exit_page - Customizable exit / thank you page that will be
displayed once the assessment has been responded.</li><li>consent_page -<br>
</li><li>return_url - URL the respondee will be redirected to after
finishing the assessment. Should be redirected directly if no Thank
you page is there. Otherwise the return_url should be set in the
thank you page context, so we can have a "continue"
URL.</li><li>start_time - At what time shall the assessment become available
to the users (remark: It will only become available to the users
who have at least the "respond" privilege.</li><li>end_time - At what time the assessment becomes unavailable.
This is a hard date, any response given after this time will be
discarded.</li><li>number_tries - Number of times a respondee can answer the
assessment</li><li>wait_between_tries - Number of minutes a respondee has to wait
before he can retake the assessment.</li><li>time_for_response - How many minutes has the respondee to
finish the assessment (taken from the start_time in
as_sessions).</li><li>show_feedback - Which feedback_text stored with the item_type
shall be displayed to the respondee (All, none, correct,
incorrect). Correct and Incorrect will only show the feedback_text
if the response was correct or incorrect.</li><li><span class="context"><span class="reg"><span class="reg">section_navigation - How shall the navigation
happen<br>
</span></span></span></li><li style="list-style: none; display: inline"><ul>
<li><span class="context"><span class="reg"><span class="reg">default path - Order given by the relationship between
assessment and section (the order value in cr_rels, if this is
used).<br>
</span></span></span></li><li><span class="context"><span class="reg"><span class="reg">randomized - Sections will be displayed
randomly</span></span></span></li><li><span class="context"><span class="reg"><span class="reg">rule-based branching - Sections will be displayed according
to inter-item-checks. This should be
default.</span></span></span></li>
</ul></li>
</ul><br>
</li><li>Style Options (as_assessment_styles): Each assessment has a
special style associated with it. As styles can be reused (e.g.
within a department) they are covered in the
as_assessment_styles:</li>
</ul>
<ul>
<li style="list-style: none; display: inline">
<ul>
<li>custom_header - Custom header (and footer) that will be
displayed to the respondee when answering an assessment.
Possibility to include system variables (e.g. first name).<br>
</li><li>custom_footer<br>
</li><li>form_template - Style (form_template) that will be used for
this assessment. You can either select an existing one or upload a
new style as well as edit the currently chosen one (no data model
but UI thought).<br>
</li><li>
<span class="context"><span class="reg">progress_bar: What kind
of progress bar shall be displayed to the respondee while taking
the assessment</span></span><span class="context"><span class="reg">(no progress bar, different styles).</span></span>
</li><li>
<span class="context"><span class="reg">presentation_style:
These options allow the respondee to select between different
presentation styles. At least one of the checkboxes mentioned below
has to be selected.</span></span><ul>
<li><span class="context">All questions at once</span></li><li><span class="context">One question per page. If you have
selected respondee may not edit their responses, it will not be
possible for them to go back and choose another answer to that
question.</span></li><li><span class="context">Sectioned</span></li>
</ul>
</li><li style="list-style: none">&lt;&gt;&lt;/&gt;</li>
</ul><p>Permissions / Scope: Control of reuse previously was through a
shareable_p boolean. As with Items and Sections, we instead will
use the acs permission system:</p><ul>
<li>Read: An assessment author (who is granted this permission) can
reuse this assessment (NB: Usually, the original author has admin
privileges.)</li><li>Write: Author can reuse and change this assessment.</li><li>Admin: Author can reuse, change and give permission on this
assessment</li><li>Respond: The user can respond to the survey.<br>
</li>
</ul>
</li><li>Sections (as_sections) represent logically-grouped set of Items
that always need to be present or absent together in the
Assessment. Sections thus divide at logical branch points. These
branch points are configured during Assessment creation to
determine movement among Sections based on one of various
mechanisms: pre-set criteria specified by the Assessment author, or
criteria based on user-submitted data up to the point of branching.
Note that Items within a single Section may be presented one-by-one
in different pages; pagination is thus related but not equivalent
to Section definitions and in fact is an attribute of a Section.
Well, more accurately, of a Section Display Type (see below).
Attributes of Sections themselves include</li><li>e:
<ul>
<li>section_id</li><li>section_display_type_id - references
as_section_display_types</li><li>name - used for page display</li><li>definition - text used for identification and selection in
admin pages, not for end-user pages</li><li>instructions - text displayed on user pages</li><li>enabled_p - good to go?</li><li>required_p - probably not as useful as per-Item required_p but
maybe worth having here; what should it mean, though? All Items in
a required section need to be required? At least one? Maybe this
isn&#39;t really useful.</li><li>content_value - references cr_revisions: for an image, audio
file or video file</li><li>numeric_value - optional "number of points" for
section</li><li>feedback_text - optional preset text to show user</li><li>max_time_to_complete - optional max number of seconds to
perform Section</li>
</ul><p>Permissions / Scope: Control of reuse previously was through a
shareable_p boolean. As with Items and Assessments, we instead will
use the acs permission system:</p><ul>
<li>Read: A section author (who is granted this permission) can
reuse this section (NB: Usually, the original author has admin
privileges.)</li><li>Write: Author can reuse and change this section.</li><li>Admin: Author can reuse, change and give permission on this
section</li>
</ul>
</li><li>Section Display Types (as_section_display_types) define types
of display for an groups of Items. Examples are a "compound
question" such as "What is your height" where the
response needs to include a textbox for "feet" and one
for "inches". Other examples are "grids" of
radiobutton multiple-choice Items in which each row is another Item
and each column is a shared radiobutton, with the labels for the
radiobutton options only displayed at the top of the grid (see
<a href="http://www.epimetrics.com/demos">the SAQ</a> for an
illustration of this).
<p>This entity is directly analogous in purpose and design to
as_item_display_types.</p><ul>
<li>section_display_type_id</li><li>section_type_name - name like "Vertical Column" or
"Depth-first Grid" or "Combo Box"</li><li>pagination_style - all-items; one-item-per-page; variable (get
item groups from mapping table)</li><li>branched_p - whether this Section defines a branch point (so
that the navigation procs should look for the next step) or whether
this Section simply transitions to the next Section in the
sort_order (it may be better not to use this denormalization and
instead always look into the Sequencing mechanism for navigation --
we&#39;re still fuzzy on this)</li><li>item_orientation - the pattern by which 2..n Items are laid out
when displayed. Note that this isn&#39;t a purely stylistic issue
better left to the .adp templates or css; the patterns have
semantic implications that the Assessment author appropriately
should control here.
<ol>
<li>horizontal - all Items are in one line</li><li>vertical - all Items are in one column</li><li>matrix_col-row - Items are laid out in matrix, filling first
col then row</li><li>matrix_row-col -Items are laid out in matrix, filling first row
then col</li>
</ol>
</li><li>item_labels_as headers_p - whether to display labels of the
Items; if not, a "grid of radiobuttons" gets displayed.
See discussion of Items and Item Choices <a href="http://openacs.org/projects/openacs/packages/assessment/design/as_items">
here</a>. There are contexts where a Section of Items all share the
same Choices and should be laid out with the Items'
item_subtexts as row headers and the radiobuttons (or checkboxes)
only -- without their labels -- displayed in a grid (see <a href="http://www.cvoutcomes.org/questionnaires/one-questionnaire?questionnaire_id=5">
this example</a>).</li><li>presentation_type - may actually be superfluous...gotta think
more about this, but there&#39;s at least one example:
<ol>
<li>ranking - a set of alternatives each need to be assigned an
exclusive rank ("Indicate the order of US Presidents from bad
to worse"). Is this one Item with multiple Item Choices?
Actually, not, since each alternative has a value that must be
separately stored (the tester would want to know that the testee
ranked GWB last, for instance).</li><li>what others?</li>
</ol>
</li><li>item_alignment - the orientation between the "section
description part" of the Section (if any) and the group of
Items. Alternatives accommodate L-&gt;R and R-&gt;L alphabets (or
is this handled automagically be Internationalization?) and
include:
<ol>
<li>beside_left - the Items are left of the
"heading"</li><li>beside_right - the Items are right of the
"heading"</li><li>below - the Items are below the "heading"</li><li>above - the Items are above the "heading"</li>
</ol>
</li><li>display_options - field to specify other stuff like the grid
dimensions ("rows=10 cols=50" eg)</li>
</ul>
</li><li>Item Section map (as_item_section_map) defines 1..n Items to a
Section, caches display code, and contains optional overrides for
Section and Item attributes:
<ul>
<li>item_id</li><li>section_id</li><li>enabled_p</li><li>required_p - whether Item must be answered</li><li>item_default</li><li>content_value - references CR</li><li>numeric_value - where optionally the "points" for the
Item can be stored</li><li>feedback_text</li><li>max_time_to_complete</li><li>adp_chunk - display code</li><li>sort_order</li>
</ul>
</li><li>Section Assessment Map (as_assessment_section_map) basically is
a standard map, though we can override a few Section attributes
here if desired:
<ul>
<li>assessment_id</li><li>section_id</li><li>feedback_text</li><li>max_time_to_complete</li><li>sort_order</li>
</ul>
</li>
</ul>
