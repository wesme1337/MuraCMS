<cfscript>
	try{
		dbUtility.setTable("tcontent").alterColumn(column='inheritObjects',dataType='varchar',length='50');
	} catch(any e){};
</cfscript>
