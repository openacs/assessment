<master>
<property name="title">Assessment</property>
<property name="context">@context;noquote@</property>
<formtemplate id="show_item_form">

<table>
		<br>&nbsp;&nbsp;<b>Items</b>

	     <multiple name="items">
		<tr>
		   <td valign="top">@items.rownum@.</td>	
		   <td colspan="3">
		       <blockquote>@items.item_text;noquote@
			<if @items.presentation_type@ in radiobutton checkbox>
				<br/><br/>
				<formgroup id="response_to_item.@items.item_id@">
					@formgroup.widget;noquote@
					@formgroup.label;noquote@<br/>
				</formgroup>
			 </if>
			 <else>
			        	<formwidget id="response_to_item.@items.item_id@">
			        
			 </else>
		       </blockquote>
		    </td>
			
		</tr>
	     </multiple>

	   </table>


</formtemplate>
</master>
