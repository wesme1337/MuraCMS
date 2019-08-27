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
<cfset started=false>
<cfset tabList=listAppend(tabList,"tabBasic")>

<!--- AltURLs --->
<!--- Load up redirect iterator --->
<cfset altURLit = $.content().getalturlIterator() />
<!--- Set up helper to display path --->
<cfset httpProtocol = len(cgi.https) ? 'https://' : 'http://' />
<cfset altURLHelper = httpProtocol & cgi.server_name & '/' />
<!--- Begin check for ismuracontent --->
<!--- set isMuraContentCheck variable to set radio buttons --->
<cfset isMuraContentCheck = 0 />
<!--- we need to check the redirect iterator for the value of ismuracontent
			there can only be one redirect to Mura Content so we don't need to loop to get the 1 or 0
 --->
<cfif altURLit.hasNext()>
	<cfset muracheck = altURLit.next()>
	<cfif muracheck.get('ismuracontent') >
		<cfset isMuraContentCheck = 1 />
	</cfif>
</cfif>
<!--- reset the iterator for use below. --->
<cfset altURLit.reset() />
<!--- /end AltURLs --->

<cfoutput>
<div class="mura-panel panel" id="tabBasic">
	<div class="mura-panel-heading" role="tab" id="heading-basic">
		<h4 class="mura-panel-title">
			<a class="collapse collapsed" role="button" data-toggle="collapse" data-parent="##content-panels" href="##panel-basic" aria-expanded="true" aria-controls="panel-basic">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.basic")#</a>
		</h4>
	</div>
	<div id="panel-basic" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-basic" aria-expanded="false" style="height: 0px;">
		<div class="mura-panel-body">

				<span id="extendset-container-tabbasictop" class="extendset-container"></span>

				<!--- type/subtype --->
				<cfinclude template="dsp_type_selector.cfm">

				<!--- title --->
				<cfswitch expression="#rc.type#">
					<cfcase value="Page,Folder,Calendar,Gallery,File,Link">
						<div class="mura-control-group">
							<label>
						    	<span data-toggle="popover" title="" data-placement="right"
						    	data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.pageTitle"))#"
						    	data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.title"))#"
						    	>
						    	#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.title")# <i class="mi-question-circle"></i></span>
						    </label>
							<input type="text" id="title" name="title" value="#esapiEncode('html_attr',rc.contentBean.gettitle())#"  maxlength="255" required="true" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.titlerequired')#" <cfif not rc.contentBean.getIsNew()>onkeypress="openDisplay('editAdditionalTitles','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.close')#');"</cfif>>
							<div id="alertTitleSuccess" class="help-block" style="display:none;">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.seotitlescleared')# </div>

								<div class="help-block" id="editAdditionalTitles" style="display:none;">
									<p>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.AdditionalTitlesnote")#</p><br />
									<button type="button" id="resetTitles" name="resetTitles" class="btn">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.clearseotitles')#</button>
								</div>

						 </div>

							<div id="mura-seo-titles">
								<div class="mura-control-group">
									<label>
								  	<span data-toggle="popover" title="" data-placement="right"
								    	data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.navigationTitle"))#"
								    	data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.menutitle"))#"
								    	>
								    				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.menutitle")#
									 <i class="mi-question-circle"></i>
									</span>
									</label>
									<input type="text" id="menuTitle" name="menuTitle" value="#esapiEncode('html_attr',rc.contentBean.getmenuTitle())#"  maxlength="255">
								</div>

								<div class="mura-control-group">
									<label>
								  	<span data-toggle="popover" title="" data-placement="right"
								    	data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.urlTitle"))#"
								    	data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.urltitle"))#"
								    	>
								    				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.urltitle")#
										 <i class="mi-question-circle"></i>
										</span>
									</label>
									<input type="text" id="urlTitle" name="urlTitle" value="#esapiEncode('html_attr',rc.contentBean.getURLTitle())#"  maxlength="255">
								</div>

								<div class="mura-control-group">
									<label>
								  	<span data-toggle="popover" title="" data-placement="right"
								    	data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.htmlTitle"))#"
								    	data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.htmltitle"))#"
								    	>
								    				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.htmltitle")#
										 <i class="mi-question-circle"></i>
										</span>
									</label>
									<input type="text" id="htmlTitle" name="htmlTitle" value="#esapiEncode('html_attr',rc.contentBean.getHTMLTitle())#"  maxlength="255">
								</div>

							</div><!-- /mura-seo-titles -->

					</cfcase>
					<cfdefaultcase>
						<div class="mura-control-group">
				      		<label>
			      				#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.title')#
			      			</label>
				     		<input type="text" id="title" name="title" value="#esapiEncode('html_attr',rc.contentBean.getTitle())#"  maxlength="255" required="true" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.titlerequired')#"<cfif rc.contentBean.getIsLocked()> disabled="disabled"</cfif>>
			     		 	<input type="hidden" id="menuTitle" name="menuTitle" value="">
			     		</div>
					</cfdefaultcase>
				</cfswitch>
				<!--- /title --->


				<!--- AltURLs --->
				<!--- todo: rb keys --->
				<div class="mura-control-group">
					<label>URL Redirection</label>
					<div class="mura-control justify">
						
						<div class="bigui__preview">
							<div id="alturls__selected"><span>No alternate URLs defined</span></div>
						</div>
						<!--- 'big ui' flyout panel --->
						<!--- todo: resource bundle key for 'manage related content' --->
						<div class="bigui" id="bigui__alturl" data-label="Manage Redirects">
							<div class="bigui__title">Alternate URL Redirection</div>
							<div class="bigui__controls">

								<div class="mura-control-group">
									<label>
										<span data-toggle="popover" title="" data-placement="right" data-content="Define multiple URLs that will redirect to this content, or redirect from this content to a single URL of another page or Mura content node." data-original-title="Altermate URL Direction">
									URL Direction <i class="mi-question-circle"></i></span>
									</label>
									<div class="radio-group">
										<label for="isMura" class="radio">
											<input type="radio" name="ismuracontent" id="isMura" <cfif isMuraContentCheck == 1>checked</cfif> value="1">
										Redirect from this content node to an alternate content node
										</label>
										<label for="notMura" class="radio">
											<input type="radio" name="ismuracontent" id="notMura" <cfif isMuraContentCheck == 0>checked</cfif> value="0">
										Allow alternate URLs for this content node
										</label>
									</div>
								</div>

								<div class="mura-control-group">
									<div class="input_fields_wrap">
										<cfif altURLit.hasNext()>
											<cfloop condition="altURLit.hasNext()">
												<cfset item = altURLit.next() />
												<div class="mura-control-group <cfif altURLit.getCurrentIndex() eq 1>first</cfif>">
													<span>#altURLHelper#</span>
													<input type="text" name="alturl_#item.get('alturlid')#" value="#item.get('alturl')#" placeholder="url-here">
													<span class="altstatuscode">
														<select class="altstatuscode" name="altstatuscode_#item.get('alturlid')#">
															<option value="302"<cfif item.get('statuscode') eq 302> selected</cfif>>Temporary (302)</option>
															<option value="301"<cfif item.get('statuscode') eq 301> selected</cfif>>Permanent (301)</option>
															<option value=""<cfif not listFind('301,302',item.get('statuscode'))> selected</cfif>>No redirection</option>
														</select>
														<cfif altURLit.getCurrentIndex() gt 1>
															<button class="btn remove_field" title="Remove Alternate URL">
																<i class="fa fa-trash"></i>
															</button>
														</cfif>
													</span>
												</div>
											</cfloop>
										<cfelse>
											<cfset newid=createUUID()>
											<div class="mura-control-group first">
												<span>#altURLHelper#</span>
												<input type="text" name="alturl_#newid#" placeholder="url-here">
												<span class="altstatuscode">
													<select  name="altstatuscode_#newid#">
														<option value="302">Temporary (302)</option>
														<option value="301">Permanent (301)</option>
														<option value="">No redirection</option>
													</select>
												</span>
											</div>
										</cfif>
									</div> <!--- /.input_fields_wrap --->

									<input type="hidden" name="numberOfAltURLs" class="numberOfAltURLs" value="1"/>
									<input type="hidden" name="alturluiid" value="#$.content().getContentID()#"/>
								</div> <!--- /.mura-control-group --->

								<div class="mura-control-group" id="add_field_button_wrapper">
									<label class="sr-only">Alternate URL</label>
									<button class="add_field_button btn"><i class="fa fa-plus"></i> Add Alternate URL</button>
								</div>

							</div> <!--- /.bigui__controls --->
						</div> <!--- /.bigui --->
					</div> <!--- /end mura-control .justify --->
				</div> <!--- /end mura-control-group --->
				<!--- /AltURLs --->

				<!--- content parent --->
				<cfif ((rc.parentid neq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all') or (rc.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() eq 'none')) and rc.contentid neq '00000000000000000000000000000000001'>

					<cfif application.settingsManager.getSite(rc.siteid).getlocking() neq 'all'>
						<div class="mura-control-group">
			      		<label>
				  			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentparent')#
		      			</label>
		      			<div class="mura-control justify">
			  				<cfif arrayLen(rc.crumbData)>
			  					<div class="bigui__preview">
				  					<div id="newparent-label">
					      			"<span><cfif rc.contentBean.getIsNew()>#rc.crumbData[1].menutitle#<cfelse>#rc.crumbData[2].menutitle#</cfif></span>"
					  				</div>
			  					</div>
			  				</cfif>

								<!--- 'big ui' flyout panel --->
								<div class="bigui" id="bigui__selectparent" data-label="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectnewparent'))#">
									<div class="bigui__title">#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectnewparent'))#</div>
									<div class="bigui__controls">
										<!--- new parent UI gets loaded here --->
								    <span id="mover2" style="display:none"><input type="hidden" name="parentid" value="#esapiEncode('html_attr',rc.parentid)#"></span>
									</div>
								</div> <!--- /.bigui --->

								<script>
									jQuery(document).ready(function(){
										siteManager.loadSiteParents(
											'#esapiEncode('javascript',rc.siteid)#'
											,'#esapiEncode('javascript',rc.contentid)#'
											,'#esapiEncode('javascript',rc.parentid)#'
											,''
											,1
										);

										// populate current parent text when changed
										jQuery(document).on('click', '##mover2 input[name="parentid"]',function(){
											var newparent = jQuery(this).parents('tr').find('ul.navZoom li:last-child').text().trim();
											jQuery('##newparent-label > span').html(newparent);
										})
										jQuery(document).on('click', '##mover2 td.var-width',function(){
											var parentradio = jQuery(this).parents('tr').find('td.actions input[name="parentid"]');
											jQuery(parentradio).trigger('click');
										})
									});
								</script>
							</div> <!--- /end mura-control .justify --->
						</div> <!--- /end mura-control-group --->

					<cfelse>
					 	<input type="hidden" name="parentid" value="#esapiEncode('html_attr',rc.parentid)#">
					</cfif> <!--- /end content parent --->

				<cfelse>
					<input type="hidden" name="parentid" value="#esapiEncode('html_attr',rc.parentid)#">
				</cfif> <!--- /end content parent --->

				<!--- body --->
				<cfif listFindNoCase(rc.$.getBean('contentManager').HTMLBodyList,rc.type)>
					<cfset rsPluginEditor=application.pluginManager.getScripts("onHTMLEdit",rc.siteID)>

						<!--- set up body content --->
						<cfsavecontent variable="bodyContent">

					   <span id="extendset-container-tabprimarytop" class="extendset-container"></span>

							<div id="bodyContainer" class="body-container mura-control-group" style="display:none;">
								<label>
					      	#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.content")#
					      </label>
							<cfif rsPluginEditor.recordcount>
								#application.pluginManager.renderScripts("onHTMLEdit",rc.siteid,pluginEvent,rsPluginEditor)#
							<cfelse>

								<cfif application.configBean.getValue("htmlEditorType") eq "none">
									<textarea name="body" id="body">#esapiEncode('html',rc.contentBean.getBody())#</textarea>
								<cfelse>
									<textarea name="body" id="body"><cfif len(rc.contentBean.getBody())>#esapiEncode('html',rc.contentBean.getBody())#<cfelse><p></p></cfif></textarea>
									<script type="text/javascript">
									var loadEditorCount = 0;
									<cfif rc.preview eq 1>var previewLaunched= false;</cfif>

									hideBodyEditor=function(){
										if(typeof CKEDITOR.instances.body != 'undefined'){
											CKEDITOR.instances.body.updateElement();
											CKEDITOR.instances.body.destroy();
										}
										jQuery(".body-container").hide();
										jQuery(".no-body-container").show();
									}

									showBodyEditor=function(){
										if(typeof CKEDITOR.instances.body == 'undefined'){
											jQuery(".body-container").show();
											jQuery(".no-body-container").hide();

											jQuery('##body').ckeditor(
											{ toolbar:<cfif rc.type eq "Form">'Form'<cfelse>'Default'</cfif>,
											height:'calc(100vh - 380px)',
											customConfig : 'config.js.cfm'
											},
												function(editorInstance){
													htmlEditorOnComplete(editorInstance);
													showPreview();
													// custom global resize function fits to content window
													resizeBodyEditor();
												}
											);
										}
									}

									jQuery(document).ready(function(){
										<cfif not isExtended>
										showBodyEditor();
										</cfif>
										if (!hasSummary && !hasBody){
											setTimeout(function(){
												showPreview();
											}, 2000);
										}
									});

									function showPreview(){
										<cfif rc.preview eq 1>
											if(!previewLaunched){
										<cfif listFindNoCase("File",rc.type)>
											preview('#rc.contentBean.getURL(secure=rc.$.getBean("utility").isHTTPs(),complete=1,queryString="previewid=#rc.contentBean.getcontenthistid()#")#');
										<cfelse>
											preview('#rc.contentBean.getURL(secure=rc.$.getBean("utility").isHTTPs(),complete=1,queryString="previewid=#rc.contentBean.getcontenthistid()#")#');
										</cfif>
											previewLaunched=true;
											}
										</cfif>
									}
									</script>
								</cfif>
							</cfif>

					   <span id="extendset-container-primary" class="extendset-container"></span>
					   <span id="extendset-container-tabprimarybottom" class="extendset-container"></span>
						</div>
						<div id="noBodyContainer" class="no-body-container mura-control-group" style="display:none;">
						   <span id="extendset-container-tabprimarytop" class="extendset-container"></span>
								<div class="block">
									<div class="help-block-empty">
									Content body unavailable for type #$.content('type')#/#$.content('subtype')#
									</div>
								</div>
						   <span id="extendset-container-primary" class="extendset-container"></span>
						   <span id="extendset-container-tabprimarybottom" class="extendset-container"></span>
						</div>
					</cfsavecontent>

				<cfelseif rc.type eq 'Link'>
					<cfsavecontent variable="bodyContent">

			   <span id="extendset-container-tabprimarytop" class="extendset-container"></span>

					<div class="mura-control-group">
					     <h2>
				      		#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.url")#
				      	</h2>
			     	 	<cfif len(application.serviceFactory.getBean('settingsManager').getSite(session.siteid).getRazunaSettings().getHostname())>
			 	 			<input type="text" id="url" name="body" value="#esapiEncode('html_attr',rc.contentBean.getbody())#" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.urlrequired')#">
			 	 			<div class="mura-control justify">
			 	 				<div class="mura-input-set">
				 	 				<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
				     	 				 	<i class="mi-folder-open"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.browseassets')#
				 	 				</a>
				 	 				<ul class="dropdown-menu">
				 	 					<li><a href="##" type="button" data-completepath="false" data-target="body" data-resourcetype="user" class="mura-file-type-selector mura-finder" title="Select a File from Server">
				     	 						<i class="mi-folder-open"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.local')#</a></li>
				 	 					<li><a href="##" type="button" onclick="renderRazunaWindow('body');return false;" class="mura-file-type-selector btn-razuna-icon" value="URL-Razuna" title="Select a File from Razuna"><i></i> Razuna</a></li>
				 	 				</ul>
				 	 			</div>
			 	 			</div>
						<cfelse>
							<div class="mura-control justify">
								<div class="mura-input-set">
									<input type="text" id="url" name="body" value="#esapiEncode('html_attr',rc.contentBean.getbody())#" class="text mura-5" required="true" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.urlrequired')#">
				     	 			<button type="button" data-completepath="false" data-target="body" data-resourcetype="user" class="btn mura-file-type-selector mura-finder" title="Select a File from Server"><i class="mi-folder-open"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.browseassets')#</button>
					     	 	</div>
				     	 	</div>
						</cfif>

				   <span id="extendset-container-primary" class="extendset-container"></span>
				   <span id="extendset-container-tabprimarybottom" class="extendset-container"></span>

			     	</div>
			     </cfsavecontent>
				<cfelseif rc.type eq 'File'>
					<cfsavecontent variable="bodyContent">
						<cfinclude template="dsp_file_selector.cfm">
					</cfsavecontent>
				</cfif>
				<!--- /end body --->

				<!--- component module assignments --->
				<cfif rc.type eq 'Component'>
					<div class="mura-control-group">
					    <label>
				      		#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.componentassign')#
				      	</label>
						<label for="m1" class="checkbox inline">
							<input name="moduleAssign" type="CHECKBOX" id="m1" value="00000000000000000000000000000000000" <cfif listFind(rc.contentBean.getmoduleAssign(),'00000000000000000000000000000000000') or rc.contentBean.getIsNew()>checked </cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.content')#
						</label>

						<label for="m2" class="checkbox inline">
							<input name="moduleAssign" type="CHECKBOX" id="m2" value="00000000000000000000000000000000003" <cfif listFind(rc.contentBean.getmoduleAssign(),'00000000000000000000000000000000003')>checked </cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.components')#
						</label>

						<cfif application.settingsManager.getSite(rc.siteid).getdatacollection()>
							<label for="m3" class="checkbox inline">
								<input name="moduleAssign" type="CHECKBOX" id="m3" value="00000000000000000000000000000000004" <cfif listFind(rc.contentBean.getmoduleAssign(),'00000000000000000000000000000000004')>checked </cfif> class="checkbox">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.formsmanager')#
							</label>
						</cfif>

						<cfif application.settingsManager.getSite(rc.siteid).getemailbroadcaster()>
							<label for="m4" class="checkbox inline">
								<input name="moduleAssign" type="CHECKBOX" id="m4"  value="00000000000000000000000000000000005" <cfif listFind(rc.contentBean.getmoduleAssign(),'00000000000000000000000000000000005')>checked </cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.emailbroadcaster')#
							</label>
						</cfif>
					</div>
				</cfif>

				<!--- form confirmation, sendto --->
				<cfif rc.type eq 'Form'>
					<cfif application.configBean.getValue(property='formpolls',defaultValue=false)>
					<div class="mura-control-group">
						<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.formpresentation')#</label>
						<label for="rc" class="checkbox">
							<input name="responseChart" type="CHECKBOX" value="1" <cfif rc.contentBean.getresponseChart() eq 1>checked </cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.ispoll')#
						</label>
						</div>
					</cfif>
					<div class="mura-control-group body-container" style="display:none">
						<label>
						 	#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.confirmationmessage')#
						</label>
						<textarea name="responseMessage" rows="4">#esapiEncode('html',rc.contentBean.getresponseMessage())#</textarea>
					</div>
					<div class="mura-control-group">
						<label>
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.responsesendto')#
						</label>
						<input type="text" name="responseSendTo" value="#esapiEncode('html_attr',rc.contentBean.getresponseSendTo())#">
					</div>
				</cfif>

				<span id="extendset-container-basic" class="extendset-container"></span>

				<span id="extendset-container-tabbasicbottom" class="extendset-container"></span>

		</div>
	</div>
</div>

	<script>
		jQuery(document).ready(function(){

			$('##showTitles').click(function(e){
				$(this).parents('div.mura-control').hide();
				$('##alertTitleSuccess').hide();
				$('##mura-seo-titles').fadeIn();
			})

			$('##resetTitles').click(function(e){
				e.preventDefault();
				 $('##menuTitle,##urlTitle,##htmlTitle').val('');
				$('##editAdditionalTitles').hide();
				$('##alertTitleSuccess').fadeIn();
				return true;
			});
		});

		// altURLs
		 Mura(function (m) {

				var max_fields = 10; //maximum input boxes allowed
				var wrapper = $(".input_fields_wrap"); //fields wrapper
				var add_button = $(".add_field_button"); //add button ID
				var button_wrapper = $("##add_field_button_wrapper"); //add wrapper div
				var totalAltURLs = $(".numberOfAltURLs"); //hidden for count
				var ismuracontent = $("input[name='ismuracontent']");

				var x = 1; //initlal text box count
				
				if ($("input[name='ismuracontent']:checked").val() == 1 ) {
					$(add_button).attr('disabled','disabled');
					$(button_wrapper).hide();
				}

				$(ismuracontent).on('change',function(e){
					if ($(this).val() == 1) {
						max_fields = 1;
						//$('.altstatuscode').hide();
						$(add_button).attr('disabled','disabled');
						$(button_wrapper).hide();
						$(wrapper).find('input[name^="alturl_"]').each(function(){
							$(this).val('');
						});
						$(wrapper).find('div.mura-control-group').not('.first').remove();
					} else {
						max_fields = 10;
						//$('.altstatuscode').show();
						$(add_button).removeAttr('disabled');
						$(button_wrapper).show();
						$(wrapper).find('input[name^="alturl_"]').each(function(){
							$(this).val('');
						});
					}
				})

				$(add_button).click(function(e){ //on add input button click
					e.preventDefault();
					if(x < max_fields){ //max input box allowed
						var newID=m.createUUID();
						newForm = '<div class="mura-control-group">#altURLHelper# <input type="text" name="alturl_'+ newID +'" placeholder="url-here"/> <span class="altstatuscode"><select  name="altstatuscode_' + newID +'"><option value="302">Temporary (302)</option><option value="301">Permanent (301)</option><option value="">No redirection</option></select> <button class="btn remove_field" title="Remove Alternate URL"> <i class="fa fa-trash"></i> </button></span></div>';
						$(wrapper).append(newForm); //add input box
						x++; //text box increment
						totalAltURLs.val(x);
						$(add_button).removeAttr('disabled');
						// $('[name="altstatuscode_' + newID +'"]').niceSelect();
						if (x == max_fields) {
							$(add_button).attr('disabled','disabled');
						}
					}
				});

				$(wrapper).on("click",".remove_field", function(e){ 
					e.preventDefault();
					var parent=$(this).closest('div.mura-control-group');
					if($(".input_fields_wrap").children('div:visible').length > 1){
						parent.hide();
						$(add_button).removeAttr('disabled');
					}
					parent.find('input[name^="alturl_"]').val('');
					x--;
					if(x > 1){
						totalAltURLs.val(x);
					}
				});
			}); // end Mura function(m)

	</script>

</cfoutput>