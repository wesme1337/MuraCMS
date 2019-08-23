 <!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

	/admin/
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfsilent>
<cfset $=application.serviceFactory.getBean("muraScope").init(rc.siteID)>
<cfset feed=$.getBean("feed")>
<cfset feed.set(url)>

<cfset displayList=feed.getDisplayList()>
<cfset displayLabels=feed.getDisplayLabels(displayList)>
<cfset availableList=feed.getAvailableDisplayList()>
<cfset availableLabels=feed.getAvailableDisplayList(listCol="label")>
<cfset availListArr = listToArray(availableList)>
<cfset availLabelArr = listToArray(availableLabels)>

</cfsilent>
<cfinclude template="js.cfm">
<cfoutput>

<div class="mura-header">
	<h1>Select Fields</h1>
</div> <!-- /.mura-header -->
<div class="block block-constrain">
	<div class="block block-bordered">
	  <div class="block-content">
			<div class="mura-control-group" id="availableFields">
				<div id="sortableFields" class="mura-control justify">
					<p class="dragMsg">
						<!--- todo: rb keys for drag messages, here and other locations --->
						<span class="dragFrom half">Drag Fields from Here&hellip;</span><span class="half">&hellip;and Drop Them Here.</span>
					</p>

					<ul id="availableListSort" class="displayListSortOptions">
						<cfif arrayLen(availListArr)>
							<cfloop from="1" to="#arrayLen(availListArr)#" index="i">
								<cfif not listFind(displayList,availListArr[i])>
									<li class="ui-state-default" data-attributecol="#availListArr[i]#">#availLabelArr[i]#</li>
								</cfif>
							</cfloop>
						</cfif>
					</ul>

					<ul id="displayListSort" class="displayListSortOptions">
						<cfloop list="#displayList#" index="i">
								<cftry>
								<cfset attrLabel = listGetAt(displayLabels,listFind(displayList,i))>
									<cfcatch>
										<cfset attrLabel = i>
									</cfcatch>
								</cftry>
							<li class="ui-state-highlight" data-attributecol="#trim(i)#">#attrLabel#</li>
						</cfloop>
					</ul>
					<input type="hidden" id="displayList" class="objectParam" value="#displayList#" name="displayList"  data-displayobjectparam="displayList"/>
				</div>
			</div>
			<div class="mura-actions">
				<div class="form-actions">
					<button class="btn mura-primary" id="updateBtn"><i class="mi-check-circle"></i>Update</button>
				</div>
			</div>
		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.block-constrain -->

<script>

$(function(){
	if($("##ProxyIFrame").length){
		$("##ProxyIFrame").load(
			function(){
				frontEndProxy.post({cmd:'setWidth',width:600});
			}
		);
	} else {
		frontEndProxy.post({cmd:'setWidth',width:600});
	}

	$('##updateBtn').click(function(){
		frontEndProxy.post({
			cmd:'setObjectParams',
			reinit:true,
			instanceid:'#esapiEncode("javascript",rc.instanceid)#',
			params:{
				displayList:$('##displayList').val()
				}
			});
	});

	$("##availableListSort, ##displayListSort").sortable({
		connectWith: ".displayListSortOptions",
		update: function(event) {
			event.stopPropagation();
			$("##displayList").val("");
			$("##displayListSort > li").each(function() {
				var current = $("##displayList").val();

				if(current != '') {
					$("##displayList").val(current + "," + $(this).attr('data-attributecol'));
				} else {
					$("##displayList").val($(this).attr('data-attributecol'));
				}

			});

		}
	}).disableSelection();

});
</script>
</cfoutput>