component extends="mura.bean.beanORMVersioned" table="tcontentalturl" entityname="alturl" bundleable="true" displayname="alturl" {

	// primary key
		property name="alturlid" fieldtype="id";
		property name="ismuracontent" datatype="tinyint" default="0";
		property name="statuscode" datatype="string" deafult="302";
		property name="alturl" fieldtype="index" datatype="varchar" length="255";
		property name="datecreated" datatype="datetime";
		property name="lastmodifiedby" fieldtype="many-to-one" relatesto="user" fkcolumn="lastUpdateById" ;


		function validate(){

			super.validate();

			if(!get('ismuracontent')){
				var redirectCheck = getBean('alturl').loadBy(alturl=get('alturl'),siteid=get('siteid'));
				var contentCheck = getBean('content').loadBy(filename=get('alturl'),siteid=get('siteid'));
			}

			// if it doesnt exist or it's a redirect from a mura node to a mura node add it
			if(!get('ismuracontent')
				&& (
					(
						redirectCheck.exists() && redirectCheck.get('alturlid') == get('alturlid')
					)
					|| contentCheck.exists()
				)
			) {

				// else set the custom error to display
				var errors=getErrors();
				
				errors["alturl_#get('alturlid')#"]="This alternative url is in use elsewhere '" & get('alturl') & "'";
			}

			return this;

		}

		function persistToVersion(previousBean,newBean,$){
			if(getIsNew() || (arguments.newBean.getContentID() != arguments.$.event('alturluiid'))){
				return true;
			} else {
				return false;
			}
		}

}
