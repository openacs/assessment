
<property name="context">{/doc/assessment/ {Assessment}} {Assessment Overview}</property>
<property name="doc(title)">Assessment Overview</property>
<master>
<style>
div.sect2 > div.itemizedlist > ul.itemizedlist > li.listitem {margin-top: 16px;}
div.sect3 > div.itemizedlist > ul.itemizedlist > li.listitem {margin-top: 6px;}
</style>              
<h2>Introduction</h2>
<p>The Assessment Package unites the work and needs of various
members of the OpenACS community for data collection functionality
within the OpenACS framework. We&#39;re using the term
"Assessment" instead of "Survey" or
"Questionnaire" (or "Case Report Form" aka CRF,
the term used in clinical trials) because it is a term used by IMS
and because it connotes the more generic nature of the data
collection system we&#39;re focusing on.</p>
<p>There has been considerable recent interest in expanding the
capabilities of generic data collection packages within OpenACS.
Identified applications include:</p>
<ul>
<li>Educational settings. The dotLRN project has updated the
Simple-Survey package to the Survey package now in the current
distribution. A number of groups in the OpenACS community are
interested in adding capabilities defined in the <a href="http://www.imsglobal.org/" target="_blank">IMS Global Learning
Consortium</a>'s specs for <a href="http://www.imsglobal.org/question/index.cfm" target="_blank">Question and Test Interoperability</a> and <a href="http://www.imsglobal.org/simpleasequencing/index.cfm" target="_blank">Simple Sequencing</a>.</li><li>Clinical research settings. <a href="http://www.epimetrics.com/">The Epimetrics Group</a> has created
an enhanced version of the Simple-Survey package that adds a
variety of scoring and scheduling tools for use in health-related
quality-of-life assessments. This Questionnaire package has not
been ported to OpenACS 4.x yet, however, and it also lacks a wide
variety of other features that are necessary for use in formal
clinical trial data collection applications, certainly for those
that intend to create data sets acceptable for new drug
applications to the US Food and Drug Administration and equivalent
European regulatory agencies.
<p>Of note, there are large and well-funded vendors of clinical
trials data management systems. <a href="http://www.phaseforward.com/%20target=">Phase Forward</a>,
<a href="http://www.outcomesciences.com/home/frame.html" target="_blank">Outcome Sciences</a>, and <a href="http://www.phtcorp.com/" target="_blank">PHT Corporation</a> among
others. A standards body called <a href="http://www.cdisc.org/%20target=">CDISC</a> (Clinical Data
Interchange Standards Consortium) formed a few years ago and is
developing data models for clinical trials data derived from schema
contributed primarily by Phase Forward and PHT. These vendors
provide "electronic data capture" (EDC) services at
considerable cost -- a 18 month study of 2500 patients including
about 500 data elements costs nearly $500,000. There is clearly
interest and opportunity to craft systems that bring such costs
"in house" for organizations doing clinical research.</p>
</li><li><p>Data collection services for other OpenACS packages. Most other
OpenACS packages invoke some form of data collection from users.
While developments such as ad_form and the templating system in
OpenACS 4.x ease the construction of data collection forms, it may
be possible to expose a focused data collection package via
acs_service_contract mechanisms to other packages. In particular,
incorporating Workflow and a new data collection package would be
key to creation of new vertical-application tools like dotWRK. Such
integration would also be immensely useful for a clinical trials
management toolkit.</p></li>
</ul>
<h2>Historical Considerations (Work Done So Far)</h2>
<p>Several OpenACS efforts form the context for any future work.
These include:</p>
<ul>
<li>Survey. This package (largely written/revised by <a href="http://openacs.org/shared/community-member?user_id=2956" target="_blank">Dave Bauer</a>) doesn&#39;t currently have any
documentation in the <a href="http://openacs.org/doc/openacs-4/" target="_blank">documentation section of the OpenACS.org site</a>,
but it is in any current OpenACS installation at /doc/survey/. Dave
has added internationalization capabilities (in the version of
Survey in CVS HEAD) and cleaned up the administrative UIs very
nicely. This package was thoroughly debugged prior to the 4.6.1
release. It supports simple one-section surveys, though the data
model has as-yet unimplemented provisions for multiple sections
within a survey.</li><li>Exam. This package (written by <a href="http://openacs.org/shared/community-member?user_id=48938" target="_blank">Ernie Ghiglione</a> and <a href="http://openacs.org/shared/community-member?user_id=7797" target="_blank">Malte Sussdorff</a>) is currently an Oracle-only tool with
capabilities not much different from Survey.</li><li>Surveys. This package was written a while ago by Buddy Dennis,
and the source code package has dropped from view. However,
we&#39;ve posted it <a href="http://openacs.org/storage/download/surveys.tar.gz?version_id=149483" target="_blank">here</a>. Presumably this package has been further
developed, since it appears to be in use at the <a href="http://surveys.crump.ucla.edu/" target="_blank">iQ&amp;A</a> site,
though current source doesn&#39;t appear to be available there.
Surveys included several important enhancements to the data model:
<ul>
<li>Conditional branching within a survey (though how well worked
out this is remains unclear)</li><li>"Folder" based repositories of questions and
sections</li>
</ul><p>However, Surveys has some important limitations:</p><ul>
<li>Surveys are "published" as static HTML files which
are served out to users when they complete the survey</li><li>The package doesn&#39;t use a templating system</li><li>Oracle-only</li>
</ul><p>Still, this package adopts some naming conventions consistent
with the IMS spec and definitely represents the closest effort to a
"complex survey" done to date.</p>
</li><li>"Complex Survey". This is the descendant of
"Survey" and Buddy&#39;s "Surveys" written by
Malte Sussdorf. It currently is in the /contrib branch of the
OpenACS 5 distro and represents the currently most advanced package
for OpenACS 5+. If you want to start looking at surveys in OpenACS
right now, this is the package to get. It incorporates a number of
the features of Surveys. We discuss it in greater detail <a href="http://openacs.org/projects/openacs/packages/assessment/specs/survey-review">
here</a>.</li><li>Questionnaire. This is a 3.2.5 module developed by <a href="http://openacs.org/shared/community-member?user_id=6569">Stan
Kaufman</a> at <a href="http://www.epimetrics.com/">The Epimetrics
Group</a> in order to support complex scoring of a particular type
of clinical measure. (You can see a demo of this <a href="http://www.epimetrics.com/questionnaires/one-questionnaire?questionnaire_id=1" target="_blank">here</a>, and if you register at the site and join
the Bay Area OpenACS Users Group, you can play with the intuitive
administrative pages for creating and editing questionnaires,
defining scoring mechanisms, setting up user scheduling and
reminder features, and configuring results reporting/graphing
capabilities.) This module runs within OpenACS 3.2.5, though, and
will need a substantial rewrite to work within the new 5.x
infrastructure.</li><li>Simple-survey. This package remains in the OpenACS distribution
but it is now obsolete, supplanted by Survey</li>
</ul>
<h2>Competitive Analysis</h2>

The number of competing products in this area is *huge*. Starting
with the usual suspects Blackboard and WebCT you can go on to
clinical trial software like Oracle Clinical or specialised survey
systems. When writing the specifications we tried to incorporate as
many ideas as possible from the various systems we had a look at
and use that experience. A detailed analysis would be too much for
the moment.<br>
<h2>Functional Requirements</h2>

An overview of the functional requirements can be found <a href="requirements">here</a>
. It is highly encouraged to be read
first, as it contains the use cases along with a global overview of
the functionality contained within assessment. Additional
requirements can be found in the specific pages for the user
interface.<br>
<h2>Design Tradeoffs</h2>

The assessment system has been designed with a large flexibility
and reuse of existing functionality in mind. This might result in
larger complexity for simple uses (e.g. a plain poll system on
it&#39;s own will be more performant than running a poll through
assessment), but provides the chance to maintain one code base for
all these separate modules.<br>
<h2>API</h2>

The API will be defined during the development phase.<br>
<h2>Data model</h2>

The data model is described in detail in the <a href="data-model">design descriptions</a>
.<br>
<h2><a href="user_interface/index">User Interface</a></h2>

The UI for Assessment divides into a number of primary functional
areas, with the entry page located <a href="user_interface/index">here</a>
. It is split up into multiple
sections:<br>
<ul>
<li>
<a href="user_interface/assessment_creation">Assessment
Authoring</a>: all the pages involved in creating, editing, and
deleting the Assessments themselves</li><li>
<a href="user_interface/section_creation">Section
Authoring</a>: all the pages involved in creating, editing, and
deleting the Sections themselves. Includes the page to browse for
items to include in sections</li><li>
<a href="user_interface/item_creation">Item Authoring and
Catalogue</a>: all the pages involving the item creation and the
item catalogue.</li><li>
<a href="user_interface/user_experience">Assessment
Delivery</a>: all the pages involved in deploying a given
Assessment to users for completion, processing those results, etc;
these are user pages</li><li>
<a href="user_interface/tests">Section on Tests</a>:
Currently still split away, some notes on additional user interface
for test. Shall be integrated with the rest of the pages.</li><li>Assessment Review: all the pages involved in select data
extracts and displaying them in whatever formats indicated; this
includes "grading" of an Assessment -- a special case of
data review; these are admin pages, though there also needs to be
some access to data displays for general users as well (eg for
anonymous surveys etc). Also, this is where mechanisms that return
information to "client" packages that embed an Assessment
would run.</li><li>Session Management: pages that set up the timing and other
"policies" of an Assessment. This area needs to interact
with the next one in some fashion, though exactly how this occurs
needs to be further thought through, depending on where the Site
Management mechanisms reside.</li><li><a href="asm_trigger_doc/">Triggers and Action
Execution</a></li>
</ul>
<br>

The  <a href="page_flow">Page Flow</a>
 page is diagrammed
below and should give a very rough and outdated overview, but still
good for getting an impression.<br>
<br>
<h2>Authors</h2>

The specifications for the assessment system have been written by
<a href="http://openacs.org/shared/community-member?user_id=6569">Stan
Kaufman</a>
 and <a href="http://openacs.org/shared/community-member?user_id=7797">Malte
Sussdorff</a>
 with help from numerous people within and outside the
OpenACS community.<br>
<br>
