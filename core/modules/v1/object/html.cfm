<cfsilent>
<cfset $=application.serviceFactory.getBean("muraScope").init(rc.siteID)>
<cfif not len($.event('target'))>
    <cfset $.event('target','html')>
</cfif>
<cfif not len($.event('label'))>
    <cfset $.event('label','Edit ' & $.event('target'))>
</cfif>
</cfsilent>
<cfinclude template="/murawrm/admin/core/views/carch/js.cfm">
<cfoutput>
<div class="mura-header">
	<h1>#esapiEncode('html',$.event('label'))#</h1>
</div> <!-- /.mura-header -->

<div class="block block-constrain">
	<div class="block block-bordered">
	  	<div class="block-content">
		  	<div class="mura-control-group">
				<textarea style="display:none" name="#esapiEncode('html_attr',$.event('target'))#" id="#esapiEncode('html_attr',$.event('target'))#" class="htmlEditor" data-width="100%"></textarea>
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
    var target='#esapiEncode('javascript',$.event('target'))#';

	$('##updateBtn').click(function(){
        params={};
        params[target]=CKEDITOR.instances[target].getData();

		frontEndProxy.post({
			cmd:'setObjectParams',
			reinit:true,
			instanceid:'#esapiEncode("javascript",rc.instanceid)#',
			params:params,
			complete:false
			});
	});

	function initConfiguratorProxy(){

		function onFrontEndMessage(messageEvent){

			var parameters=messageEvent.data;
		
			if (parameters["cmd"] == "setObjectParams") {
				if(typeof CKEDITOR.instances[target] != 'undefined'){
					CKEDITOR.instances[target].setData(parameters["params"][target]);
				}
			}

			frontEndProxy.addEventListener(onFrontEndMessage);
			frontEndProxy.post({cmd:'setWidth',width:800});
			frontEndProxy.post({
				cmd:'requestObjectParams',
				instanceid:'#esapiEncode("javascript",rc.instanceid)#',
				targetFrame:'modal'
				}
			);

		}

	}

	if($("##ProxyIFrame").length){
		$("##ProxyIFrame").load(initConfiguratorProxy);
	} else {
		initConfiguratorProxy();
	}

});
</script>
</cfoutput>
