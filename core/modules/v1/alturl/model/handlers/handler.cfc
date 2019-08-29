<cfcomponent output="false" extends="mura.cfobject">
	<!--- This is set to allow the tab in the admin to read the correct name --->
	<cfset this.pluginName = "Alternate URLs">

	<cfscript>

		public any function onRenderStart(m) {
			// no Mura Content
			if (m.content().exists() && m.content().getIsOnDisplay()) {
				var altURLit = m.getFeed('alturl')
					.where()
					.prop('contenthistid').isEQ(m.content('contenthistid'))
					.andProp('ismuracontent').isEQ(1)
					.getIterator();

				// have Mura content with redirect -- temporary "link"
				if (isStruct(altURLit) && altURLit.hasNext()) {
					item = altURLit.next();
						
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

		public any function onSiteRequestStart(m) {

			// (from URL to Mura Bean)
			var altURLit = m.getFeed('alturl')
				.where()
				.prop('alturl').isEQ(request.currentfilename)
				.andProp('ismuracontent').isEQ(0)
				.addJoin('inner','tcontent','tcontentalturl.contenthistid=tcontent.contenthistid')
				.andProp('content.active').isEQ(1)
				.getIterator();

			if (altURLit.hasNext()) {
				var altURL=altURLit.next();
				var content=m.getBean('content').loadBy(contenthistid=altURL.get('contenthistid'));
				if(content.getIsOnDisplay()){
					if(len(altURL.get('statuscode')) && listFind('301,302',altURL.get('statuscode'))) {
						m.redirect(location=content.getURL(complete=true),addToken=false,statusCode=altURL.getstatuscode());
					} else {
						content.set('canonicalURL',content.getURL(complete=true));
						m.event('muraForceFilename',false);
						m.event('contentBean',content);
					}
				}
			}
		}

	</cfscript>

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
					<cfif FindNoCase("alturl_", thefield)>
						<cfoutput>
							<cfscript>

								// if we find a match above, and it has a value
								// set it to the redirect bean
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

									theAltURL.set({
											alturlid=alturlid,
											alturl=altURLFormValue,
											ismuracontent=$.event('ismuracontent'),
											statuscode=altstatuscode,
											datecreated=createODBCDateTime(now()),
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
