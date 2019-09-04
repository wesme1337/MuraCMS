<cfsilent>
	<cfparam name="objectparams.fileid" default="">
	<cfparam name="objectparams.size" default="medium">
	<cfparam name="objectparams.height" default="AUTO">
	<cfparam name="objectparams.width" default="AUTO">
</cfsilent>
<cf_objectconfigurator>
	<cfoutput>

		<div id="emptyMediaContainer" class="mediaContainer" style='display:none'>
			<div class="mura-control-group">
				<button class="btn" id="selectMediaEmpty"><i class="mi-image"></i> Select Image</button>
			</div>
		</div>
		<div id="mediaContainer" class="mediaContainer" style='display:none'>
			<div class="mura-control-group">
				<img id="selectMedia" src="#$.getURLForImage(fileid=objectparams.fileid,size='small')#"/>
			</div>
			<div class="mura-control-group">
				<label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'collections.imagesize')#</label>
				<select name="size" data-displayobjectparam="size" class="objectParam">

					<cfloop list="Small,Medium,Large" index="i">
						<option value="#lcase(i)#"<cfif i eq objectparams.size> selected</cfif>>#I#</option>
					</cfloop>

					<cfset imageSizes=application.settingsManager.getSite(rc.siteid).getCustomImageSizeIterator()>

					<cfloop condition="imageSizes.hasNext()">
						<cfset image=imageSizes.next()>
						<option value="#lcase(image.getName())#"<cfif image.getName() eq objectparams.size> selected</cfif>>#esapiEncode('html',image.getName())#</option>
					</cfloop>
				</select>
			</div>
		</div>

		<input class="objectParam" name="fileid" type="hidden" value="#esapiEncode('html_attr',objectparams.fileid)#" />
		<script>
			$(function(){
				
				
				function getImageHREF(){
					var size=$('select[name="size"]').val() || 'Medium';
					var fileid=$('input[name="fileid"]').val();
					var assetPath='#esapiEncode('javascript',rc.$.siteConfig().getFileAssetPath(complete=true))#';
					var url=''
					if(fileid){
						Mura.getEntity('file').loadBy('fileid',fileid).then(function(file){
							url=assetPath + "/cache/file/" + fileid + '_' + size.toLowerCase() + '.' + file.get('fileext');
							$('##selectMedia').attr('src', assetPath + "/cache/file/" + fileid + '_medium.' + file.get('fileext'));
						});
					}
				}

				function onSizeChange(){
					$('.mediaContainer').hide();
					if($('input[name="fileid"').val()){
						$('##mediaContainer').show();
						getImageHREF();
					} else {
						$('##emptyMediaContainer').show();
					}
					
				}

				$('select[name="size"], input[name="fileid"]').change(onSizeChange);

				$('##selectMedia, ##selectMediaEmpty').click(function(){
					frontEndProxy.post({
						cmd:'openModal',
						src:'?muraAction=cArch.selectmedia&siteid=#esapiEncode("url",rc.siteid)#&contenthistid=#esapiEncode("url",rc.contenthistid)#&contentid=#esapiEncode("url",rc.contentid)#&instanceid=#esapiEncode("url",rc.instanceid)#&compactDisplay=true&fileid=#esapiEncode("url",objectparams.fileid)#'
						}
					);

				});

				onSizeChange();

			})
		</script>
	</cfoutput>
	<!--- Include global config object options --->
	<cfinclude template="#$.siteConfig().lookupDisplayObjectFilePath('object/configurator.cfm')#">
</cf_objectconfigurator>
