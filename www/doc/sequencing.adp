
<property name="context">{/doc/assessment {Assessment}} {Assessment Item Checks}</property>
<property name="doc(title)">Assessment Item Checks</property>
<master>
<h2>Sequencing</h2>
<p>Along with Data Validation and Versioning, probably the most
vexing problem confronting the Assessment package is how to handle
conditional navigation through an Assessment guided by user input.
Simple branching has already been accomplished in the "complex
survey" package via hinge points defined by responses to
single items. But what if branching/skipping needs to depend on
combinations of user responses to multiple items? And how does this
relate to management of data validation steps? If
branching/skipping depends not merely on what combination of
"correct" or "in range" data the user submits,
but also on combinations of "incorrect" or "out of
range" data, how the heck do we do this?</p>
<p>One basic conceptual question is whether Data Validation is a
distinct process from Navigation Control or not. Initially we
thought it was and that there should be a datamodel and set of
procedures for checking user input, the output of which would pipe
to a separate navigation datamodel and set of procedures for
determining the user&#39;s next action. This separation is made
(along with quite a few other distinctions/complexities) in the IMS
"simple sequencing" model diagrammed below). But to jump
the gun a bit, we think that actually it makes sense to combine
these two processes into a common "post-submission user input
processing" step we&#39;ll refer to here as Sequencing. (Note:
we reviewed several alternatives in the archived prior discussions
<a href="http://openacs.org/projects/openacs/packages/assessment/specs/sequencing">
here</a>.</p>

So here is our current approach. We note that there are two scopes
over which Sequencing needs to be handled:
<ul>
<li>intra-item: checks pertaining to user responses to a single
item</li><li>inter-item : checks pertaining to user responses to more than
one item; checks among multiple items will be built up
pairwise</li>
</ul>
<p>So how might we implement this in our datamodel? Consider the
"sequencing" subsystem of the Assessment package:<br>
</p>
<center><p><img alt="Data Modell Graphic" src="images/assessment-sequencefocus.jpg" style="width: 711px; height: 707px;"></p></center>
<h2>Specific Entities</h2>
<ul>
<li>Item-checks (as_item_checks) define 1..n ordered evaluations of
a user&#39;s response to a single Item. These can occur either via
client-side Javascript when the user moves focus from the Item, or
server-side once the entire html form comes back. They are
associated (related) to as_items.
<p>The goal is to have a flexible, expressive grammar for these
checks to support arbitrary types of checks, which will be input
validation ("Is the user&#39;s number within bounds?";
"Is that a properly formatted phone number?"). One notion
on check_sql. Instead of using comparators we store the whole SQL
command that makes up this check with a predefined variable
"value" that contains the response of the user to the
item the item_check is related to. If we want to make sure the
value is between 0 and 1 we store "0 &lt; :value &lt; 1"
with the check. Once an item is submitted, the system looks up the
related checks for this item and replaces in each of them
":value" with the actual response.<br>
</p><p>Item Checks thus will have these attributes:</p><ul>
<li>item_check_id</li><li>cr:name - identifier</li><li>cr:description - Explanation what this check does<br>
</li><li>check_location - client-side or server-side</li><li>javascript_function - name of function that gets called when
focus moves</li><li>user_message - optional text to return to user if check is
true<br>
</li><li>check_sql - The sql that contains the check</li>
</ul>
</li><li>Inter-Item-checks (as_inter_item_checks) are similar to
Item-Checks but operate over multiple Items. They are server sided
checks that are associated with as_sections defining if a section
should be displayed or with as_items, defining if an item should be
displayed.<br><br>
The goal is to have a way of telling if a section (or an item
within a section) shall be displayed or not depending on the
section-checks. This way you could say that you only display this
section if the response to item(1234) "Color of your eye"
was "blue" and the response to item(4231) "Color of
your hair" was "red". Sadly we can&#39;t use such an
easy way of checking the ":value" as we do with
item_checks, as we do not know which item this refers to. Instead
we store the item_id like this ":item_1234". This way the
check_sql would look like ":item_1234 == 'blue' AND
:item_4231 == 'red'". Additionally other variables
might be defined by the API at a later stage,  e.g.
":percent_score", which would be replaced by the current
percentage value (aka score) that subject had in the test so far
(taken from the as_session_table). It might be interesting to pass
these variables along in the API, this remains to be seen when
actually implementing the system.<br><br>
The Inter Item Checks also allow post section navigation (in
contrast to the pre section / item navigation mentioned above). If
post_check_p is true, the check will be done *after* the user has
hit the submit button. Depending on the result of the check (if it
is true) the user will be taken to the section given by section_id
or to the item given by item_id, depending whether this assessment
is section based (questions are displayed in sections) or item
based (each item will be displayed on a seperate page). If there
are multiple post checks for a given section/item the order will be
defined by the relationship (which means this relationship has to
have a sort_order attribute).<br><ul>
<li>inter_item_check_id</li><li>cr:name - identifier</li><li>cr:description - Explanation what this check does</li><li>user_message - optional text to return to user</li><li>check_sql - The sql that contains the check<br>
</li><li>post_check_p - Is this a check that should be executed after
the user hit the submit button while answering the item /
section.<br>
</li><li>section_id - Section to call if we are in a section mode (all
items will be displayed in sections) and it is a
post_check.<br>
</li><li>item_id - Item to call if we are in "per item" mode
(all items will be displayed on a seperate page) and it is a
post_check.</li><li>Potential extension: item_list - list of item_ids that are used
in the check_sql to speed up the check.<br>
</li>
</ul><br>
</li>
</ul>
