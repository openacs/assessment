<master>
  <property name="doc(title)">#assessment.Question_Statistics#</property>

  <p><a href="@return_url@" class="button">#assessment.Back_to_Sessions#</a></p>
    <multiple name="items">
	<h2>@items.section_title@</h2>
	<group column="section_id">
      <p><strong>@items.rownum@. @items.title;noquote@</strong></p>
      <p>
	@items.stats;noquote@
	</group>
      </p>
    </multiple>

