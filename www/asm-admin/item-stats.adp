<master>
  <property name="title">#assessment.Question_Statistics#</property>

  <p><a href="@return_url;noquote@" class="button">#assessment.Back_to_Sessions#</a></p>
  <p>
    <multiple name="items">
	<h2>@items.section_title@</h2>
	<group column="section_id">
      <p><b>@items.rownum@. @items.title;noquote@</b></p>
      <blockquote>
	@items.stats;noquote@
      </blockquote>
	</group>
    </multiple>
  </p>
