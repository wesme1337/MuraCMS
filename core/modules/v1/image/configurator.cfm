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
	<cfparam name="objectParams.src" default="">
	<cfparam name="objectParams.alt" default="">
	<cfparam name="objectParams.caption" default="">
</cfsilent>
<cf_objectconfigurator params="#objectParams#">
<cfoutput>
	<div>
		<div class="mura-layout-row">
			<div class="mura-control-group">
				<label class="mura-control-label">Image Src</label>
				<input type="text" placeholder="URL" name="src" class="objectParam" value="#esapiEncode('html_attr',objectparams.src)#"/>
				<button type="button" class="btn mura-finder" data-target="src" data-completepath="false"><i class="mi-image"></i> Select Image</button>
			</div>
			<div class="mura-control-group">
				<label class="mura-control-label">Alt Text</label>
				<input type="text" name="alt" class="objectParam" value="#esapiEncode('html_attr',objectparams.alt)#"/>
			</div>
			<div class="mura-control-group">
				<label class="mura-control-label">Caption Text</label>
				<!---<div class="alert" id="captiondemo"><cfif objectparams.caption eq '' or objectparams.caption eq '<p></p>'>N/A<cfelse>#objectparams.caption#</cfif></div>--->
				<button type="button" class="btn mura-html" data-target="caption" data-label="Edit Caption"><i class="mi-pencil"></i> Edit Caption</button>
 				<input type="hidden" class="objectParam" name="caption" value="#esapiEncode('html_attr',objectparams.caption)#">
				<!---<script>
				$('input[name="caption"]').on('change',
					function(){
						if(!this.value || this.value=='<p></p>'){
							getElementById('captiondemo').innerHTML='N/A'
						} else {
							getElementById('captiondemo').innerHTML=this.value
						}
					}
				)
				</script>--->
			</div>
		</div>
		<input type="hidden" class="objectParam" name="async" value="false">
		<input type="hidden" class="objectParam" name="render" value="client">
	</div>
	<!--- Include global config object options --->
	<cfinclude template="#$.siteConfig().lookupDisplayObjectFilePath('object/configurator.cfm')#">

</cfoutput>
</cf_objectconfigurator>

