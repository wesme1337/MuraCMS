<cfoutput>
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/dist/bootstrap.bundle.js?coreversion=#application.coreversion#"></script>
	<cfif application.configBean.getValue("htmlEditorType") eq "markdown">
		<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/dist/toast.bundle.js?coreversion=#application.coreversion#"></script>
	</cfif>
</cfoutput>