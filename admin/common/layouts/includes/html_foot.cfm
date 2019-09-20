<cfoutput>
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/dist/bootstrap.bundle.js?coreversion=#application.coreversion#"></script>
	<cfif not(isDefined('url.muraAction') and url.muraAction eq 'cArch.frontEndConfigurator')><script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/dist/toast.bundle.js?coreversion=#application.coreversion#"></script></cfif>
</cfoutput>