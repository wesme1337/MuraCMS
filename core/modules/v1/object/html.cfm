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
				<textarea style="display:none" name="#esapiEncode('html_attr',$.event('target'))#" id="#esapiEncode('html_attr',$.event('target'))#" class="objectParam htmlEditor" data-width="100%"></textarea>
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
    Mura(function(m){
		var target='#esapiEncode('javascript',$.event('target'))#';

        siteManager.setDisplayObjectModalWidth(800);
        siteManager.requestDisplayObjectParams(function(params){});

        m("##updateBtn").click(function(){
            var params={};
        	params[target]=CKEDITOR.instances[target].getData();
            siteManager.updateDisplayObjectParams(params,false);
        });
    });
   </script>
</cfoutput>
