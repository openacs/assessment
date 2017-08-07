
<property name="context">{/doc/assessment {Assessment}} {Page Flow}</property>
<property name="doc(title)">Page Flow</property>
<master>
<h2>Overview</h2>
<p>Through the OpenACS templating system, the UI look&amp;feel will
be modifiable by specific sites, so we needn&#39;t address page
layout and graphical design issues here. Other than to mention that
the Assessment package will use these OpenACS standards:</p>
<ul>
<li>"trail of breadcrumb" navigational links</li><li>context-aware (via user identity =&gt; permissions) menu
options (whether those "menus" are literally menus or
some other interface widget like toolbars)</li><li>in-place, within-form user feedback (eg error messages about a
form field directly next to that field, not in an "error
page")</li>
</ul>
<p>Furthermore, the set of necessary pages for Assessment are not
all that dissimilar to the set required by any other OpenACS
package. We need to be able to create, edit and delete all the
constituent entities in the Package. The boundary between the pages
belonging specifically to Assessment and those belonging to
"calling" packages (eg dotLRN, clinical trials packages,
financial management packages, etc etc) will necessarily be
somewhat blurred.</p>
<h2>Proposed Page Flow</h2>
<p>Nevertheless, here is a proposed set of pages along with very
brief descriptions of what happens in each. This organization is
actually derived mostly from the existing Questionnaire module
which can be examined <a href="http://www.epimetrics.com/">here</a>
in the "Bay Area OpenACS Users Group (add yourself to the
group and have a look).</p>
<p>The UI for Assessment divides into a number of primary
functional areas, as diagrammed below. These include:</p>
<ul>
<li>the "Home" area (for lack of a better term). These
are the main index pages for the user and admin sections</li><li>
<a href="user_interface/assessment_creation">Assessment
Authoring</a>: all the pages involved in creating, editing, and
deleting the Assessments themselves; these are all admin pages</li><li>Assessment Delivery: all the pages involved in deploying a
given Assessment to users for completion, processing those results,
etc; these are user pages</li><li>Assessment Review: all the pages involved in select data
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
Management mechanisms reside.</li><li>Site Management: pages involved in setting up who does
Assessments. These are admin pages and actually fall outside the
Assessment package per se. How dotLRN wants to interact with
Assessment is probably going to be different from how a Clinical
Trials Management CTM system would. But we include this in our
diagram as a placeholder.</li>
</ul>

In addition to the page flow we have two types of portlets for
.LRN:<span class="context"><span class="reg"><br></span></span>
<ul>
<li><span class="context">Portlet for the respondee with all
assessments that have to be answered and their
deadlines.</span></li><li><span class="context">Portlet for staff with all assessments
that have to be reviewed with review deadline and number of
responses still to look at.</span></li>
</ul>

More Ideas:<span class="reg"><br></span>
<ul>
<li><span class="reg">Possibility to browse assessments and
sections by category.</span></li><li><span class="reg"><br></span></li>
</ul>
<ul>
<li><span class="reg"><br></span></li><li style="list-style: none">
<br>
So this is how we currently anticipate this would all
interrelate:</li>
</ul>
<center>
<a href="http://openacs.org/storage/download/assessment-page-flow.graffle?version_id=166250"></a><p><img alt="data modell" src="images/assessment-page-flow.jpg" style="width: 950px; height: 1058px;"></p>
</center>
