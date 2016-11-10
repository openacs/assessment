<master src="admin-master">
<property name="doc(title)">#assessment.Request# #assessment.Administration#</property>
<property name="context_bar">@context;literal@</property>

<script type="text/javascript" <if @::__csp_nonce@ not nil> nonce="@::__csp_nonce;literal@"</if>>

function get_interval() {
        interval=document.interval.date.value; 
        destination = "admin-request?assessment=@d_assessment@&state=@d_state@&interval="+interval;
        if (destination) location.href=destination;

}

function get_assessment() {
        assessment=document.assessments.assessment.value; 
        destination = "admin-request?interval=@d_interval@&date=@d_date@&state=@d_state@&assessment="+assessment;
        if (destination) location.href=destination;
}

function get_state() {
        state=document.assessments.state.value; 
        destination = "admin-request?interval=@d_interval@&date=@d_date@&assessment=@d_assessment@&state="+state;
        if (destination) location.href=destination;
}

function get_specific_date() {
        date=document.specific_date_form.specific_date.value; 
        destination = "admin-request?state=@d_state@&assessment=@d_assessment@&date="+date;
        if (destination) location.href=destination;
}

</script>
      <table style="background-color: #cccccc;" cellpadding="5" width="95%">
	<tr style="background-color: #eeeeee;">
       	  <th align="left" style="width:50%">
           <formtemplate id="assessments"></formtemplate>
          </th>
          <th>
           <formtemplate id="interval"></formtemplate>
           <formtemplate id="specific_date_form"></formtemplate>
          </th>
        </tr>
      </table>
      
<listtemplate name="actions_log"></listtemplate>
<br>



