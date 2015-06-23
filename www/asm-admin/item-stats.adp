<master>
  <property name="title">#assessment.Question_Statistics#</property>

  <p><a href="@return_url@" class="button">#assessment.Back_to_Sessions#</a></p>
    <multiple name="items">
	<h2>@items.section_title@</h2>
	<group column="section_id">
      <p><b>@items.rownum@. @items.title;noquote@</b></p>
      <p>
	@items.stats;noquote@
	</group>
      </p>
    </multiple>

