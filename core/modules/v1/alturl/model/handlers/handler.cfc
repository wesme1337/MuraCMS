<cfcomponent output="false" extends="mura.cfobject">
	<!--- This is set to allow the tab in the admin to read the correct name --->
	<cfset this.pluginName = "Alternate URLs">

	<cfscript>

		public any function onRenderStart(m) {
			// no Mura Content
			if (m.content().exists()) {
				var altURLit = m.getFeed('alturl')
					.where()
					.prop('contenthistid').isEQ(m.content('contenthistid'))
					.andProp('ismuracontent').isEQ(1)
					.getIterator();

				// have Mura content with redirect -- temporary "link"
				if (isStruct(altURLit) && altURLit.hasNext()) {
					item = altURLit.next();
						//WriteDump(altURLit.getQuery());abort;
						if (item.get('ismuracontent')) {
						var content = m.getBean('content').loadBy(filename=item.get('alturl'));
						if(len(item.get('statuscode')) && listFind('301,302',item.get('statuscode'))) {
							if(content.get('type') == 'Link'){
								m.redirect(location=content.get('body'),addToken=false,statusCode=item.getstatuscode());
							} else {
								m.redirect(location=content.getURL(complete=true),addToken=false,statusCode=item.getstatuscode());
							}
						} else {
							content.set('canonicalURL',content.getURL(complete=true));
							m.event('muraForceFilename',false);
							m.event('contentBean',content);
						}
					}
				}
			}
		}

		public any function onSiteRequestStart(m) {

			// (from URL to Mura Bean)
			var altURLit = m.getFeed('alturl')
				.where()
				.prop('alturl').isEQ(request.currentfilename)
				.andProp('ismuracontent').isEQ(0)
				.getIterator();

			if (altURLit.hasNext()) {
				var altURL=altURLit.next();

				var content=m.getBean('content').loadBy(contentid=altURL.get('contentid'));
				if(len(altURL.get('statuscode')) && listFind('301,302',altURL.get('statuscode'))) {
					m.redirect(location=content.getURL(complete=true),addToken=false,statusCode=altURL.getstatuscode());
				} else {
					content.set('canonicalURL',content.getURL(complete=true));
					m.event('muraForceFilename',false);
					m.event('contentBean',content);
				}
			}
		}

	</cfscript>

	<cffunction name="onContentEdit">
		<cfargument name="$">
			<cfset var alturlTool="">
			<cfsavecontent variable="alturlTool" >
				<cfoutput>
					<div class="redirects block block-bordered">
						<!--- Get Redirect Bean --->
						<!--- Load up redirect iterator --->
						<cfset var altURLit = $.content().getalturlIterator() />
						<!--- Set up helper to display path --->
						<cfset var httpProtocol = len(cgi.https) ? 'https://' : 'http://' />
						<cfset var altURLHelper = httpProtocol & cgi.server_name & '/' />
						<!--- Begin check for ismuracontent --->
						<!--- set isMuraContentCheck variable to set radio buttons --->
						<cfset var isMuraContentCheck = 0 />
						<!--- we need to check the redirect iterator for the value of ismuracontent
									there can only be one redirect to Mura Content so we don't need to loop to get the 1 or 0
						 --->
						<cfif altURLit.hasNext()>
							<cfset var muracheck = altURLit.next()>
							<cfif muracheck.get('ismuracontent') >
								<cfset isMuraContentCheck = 1 />
							</cfif>
						</cfif>
						<!--- reset the iterator for use below. --->
						<cfset altURLit.reset() />


						<div class="help-block-inline">
							<span>Here you can add urls that will be directed to this content or define a redirect from this content to a Mura Content node.</span>
						</div>
						<div class="mura-control-group">
						<label>
							<span data-toggle="popover" title="" data-placement="right" data-content="For an alternate url that redirects to this content from a url that doesn't exist, select From New Link.  For a redirect to existing Mura content select Mura Link (only one per content node)" data-original-title="Altermate URL Direction">
								URL Direction <i class="mi-question-circle"></i></span>
						</label>

						<label for="notMura" class="radio inline">
						<input type="radio" name="ismuracontent" id="notMura" <cfif isMuraContentCheck == 0>checked</cfif> value="0">
							Alternate URL(s) for this content node
						</label>
						<label for="isMura" class="radio inline">
						<input type="radio" name="ismuracontent" id="isMura" <cfif isMuraContentCheck == 1>checked</cfif> value="1">
							Redirect from this content node to alternate url
						</label>
						</div>
						<div class="mura-control-group">
							<label class="sr-only">Alternate URL</label>
							<button class="add_field_button btn"><i class="fa fa-plus"></i> Add Alternate URL</button>
							<div class="input_fields_wrap">


							<cfif altURLit.hasNext()>
								<cfloop condition="altURLit.hasNext()">
									<cfset item = altURLit.next() />
									<div class="mura-control-group <cfif altURLit.getCurrentIndex() eq 1>first</cfif>">
										<span class="" style="color:##999">#altURLHelper#</span>
										<input style="width:200px" type="text" name="alturl_#item.get('alturlid')#" value="#item.get('alturl')#" placeholder="your-new/redirect/here">
										<div class="altstatuscode">
											<select class="altstatuscode" name="altstatuscode_#item.get('alturlid')#">
												<option value="302"<cfif item.get('statuscode') eq 302> selected</cfif>>Temporary redirect</option>
												<option value="301"<cfif item.get('statuscode') eq 301> selected</cfif>>Permanent redirect</option>
												<option value=""<cfif not listFind('301,302',item.get('statuscode'))> selected</cfif>>Do not redirect</option>
											</select>
										</div>
										<cfif altURLit.getCurrentIndex() gt 1>
											<button class="btn remove_field" title="Remove Alternate URL">
												<i class="fa fa-trash"></i>
											</button>
										</cfif>
									</div>
								</cfloop>
							<cfelse>
								<div class="mura-control-group first">
									<span class="" style="color:##999">#altURLHelper#</span>
									<cfset var newid=createUUID()>
									<input style="width:200px" type="text" name="alturl_#newid#" placeholder="your-new/redirect/here">
									<div class="altstatuscode">
										<select  name="altstatuscode_#newid#">
											<option value="302">Temporary redirect</option>
											<option value="301">Permanent Redirect</option>
											<option value="">Do not redirect</option>
										</select>
									</div>
								</div>
							</cfif>

							</div>
							<input type="hidden" name="numberOfAltURLs" class="numberOfAltURLs" value="1"/>
							<input type="hidden" name="alturluiid" value="#$.content().getContentID()#"/>
						</div>

					</div>
					<script>

					 Mura(function (m) {

									var max_fields = 10; //maximum input boxes allowed
									var wrapper = $(".input_fields_wrap"); //Fields wrapper
									var add_button = $(".add_field_button"); //Add button ID
									var totalAltURLs = $(".numberOfAltURLs"); //hidden for count
									var ismuracontent = $("input[name='ismuracontent']");

									var x = 1; //initlal text box count


									if ($("input[name='ismuracontent']:checked").val() == 1 ) {
										$(add_button).attr('disabled','disabled');
									}

									$(ismuracontent).on('change',function(e){
										if ($(this).val() == 1) {
											console.log('ismura')
											max_fields = 1;
											//$('.altstatuscode').hide();
											$(add_button).attr('disabled','disabled');
											$(wrapper).find('input[name^="alturl_"]').each(function(){
												$(this).val('');
											});
											$(wrapper).find('div.mura-control-group').not('.first').remove();
										} else {
											console.log('isnotmura')
											max_fields = 10;
											//$('.altstatuscode').show();
											$(add_button).removeAttr('disabled');
											$(wrapper).find('input[name^="alturl_"]').each(function(){
												$(this).val('');
											});
										}
									})

									$(add_button).click(function(e){ //on add input button click
										e.preventDefault();
										if (x == max_fields) {
											$(add_button).attr('disabled','disabled');
										}
										if(x < max_fields){ //max input box allowed
											x++; //text box increment
											totalAltURLs.val(x);
											var newID=m.createUUID();
											newForm = '<div class="mura-control-group"><span class="pull-left mura-control-inline" style="color:##999">#altURLHelper#</span> <input style="width:200px" type="text" name="alturl_'+ newID +'" placeholder="your-new/redirect/here"/> <div class="altstatuscode"><select  name="altstatuscode_' + newID +'"><option value="302">Temporary redirect</option><option value="301">Permanent redirect</option><option value="">Do not redirect</option></select></div> <button class="btn remove_field" title="Remove Alternate URL"> <i class="fa fa-trash"></i> </button></div>';
											$(wrapper).append(newForm); //add input box
											$('[name="altstatuscode_' + newID +'"]').niceSelect();
										}
									});

									$(wrapper).on("click",".remove_field", function(e){ //user click on remove text
										e.preventDefault();
										var parent=$(this).parent('div');
										if($(".input_fields_wrap").children('div:visible').length > 1){
											parent.hide();
										}
										parent.find('input[name^="alturl_"]').val('');

										x--;
										if(x > 1){
											totalAltURLs.val(x);
										}
									})

								});

					</script>
				</cfoutput>
			</cfsavecontent>
			<cfreturn alturlTool />
	</cffunction>

	<cffunction name="onBeforeContentSave" >
		<cfargument name="$">
		<cfif StructKeyExists(form, "fieldnames")>
			<cfset var contentBean = $.event('newBean') />
			<cfset var redirectErrors = contentBean.getErrors() />
			<!--- get a list of the field names --->
			<cfset var sortedFormFields = ListSort(form.fieldnames, "Text")>
				<!--- loope that list field names --->
				<cfloop index="thefield" list="#sortedFormFields#">
					<!--- filter by the "alturl_" for each redirect added--->
					<cfif FindNoCase("alturl_", thefield) NEQ 0>
						<cfoutput>
							<cfscript>
								// if we find a match above an it has a value set it to the redirect bean
								if(len(m.event('#thefield#'))){
									// load the bean by the redirect id portion of the input name
									var alturlid=listLast(#thefield#,'_');


									var theAltURL = $.getBean('alturl');
									// set the form value as a var for replacing logic below
									var	altURLFormValue = trim(form['#thefield#']);

									var altstatuscode='';

									if(structKeyExists(form,'altstatuscode_#alturlid#')){
										altstatuscode=form['altstatuscode_#alturlid#'];
									}

									// If the user added a trailing slash remove it
									if (right(altURLFormValue,1) == '/') {
										altURLFormValue = left(altURLFormValue,len(altURLFormValue)-1);
									}

									// If the user added a preceeding slash remove it
									if (left(altURLFormValue,1) == '/') {
										altURLFormValue = right(altURLFormValue,len(altURLFormValue)-1);
									}
									//replace any html and replace spaces with hyphens
									altURLFormValue = $.stripHTML(altURLFormValue);
									altURLFormValue = replaceNoCase(altURLFormValue,' ', '-','ALL');

									theAltURL.set(	{
											alturlid=listLast(#thefield#,'_'),
											alturl= altURLFormValue,
											ismuracontent= $.event('ismuracontent'),
											statuscode=altstatuscode,
											datecreated= createODBCDateTime(now()),
											lastUpdateById=$.currentUser('userid')
										});

									contentBean.addObject(theAltURL);

									theAltURL.validate();

									if(theAltURL.hasErrors()){
										structAppend(contentBean.getErrors(),theAltURL.getErrors());
									}
								}
							</cfscript>
						</cfoutput>
					</cfif>
				</cfloop>
				</cfif>
	</cffunction>

</cfcomponent>
