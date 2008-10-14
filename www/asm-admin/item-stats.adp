<master>
  <property name="title">#assessment.Question_Statistics#</property>

  <p><a href="@return_url;noquote@" class="button">#assessment.Back_to_Sessions#</a></p>
    <multiple name="items">
      <p><b>@items.rownum@. @items.title;noquote@</b></p>
      <p>
	@items.stats;noquote@
      </p>
    </multiple>

