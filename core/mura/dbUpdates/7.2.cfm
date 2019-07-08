<cfscript>
	try{
		dbUtility.setTable("tcontent").alterColumn(column='inheritObjects',dataType='varchar',length='50');
	} catch(any e){};

	dbUtility.setTable("tcontent").addColumn(column="canonicalURL",dataType="varchar",length=255)
</cfscript>
