<cffunction	name=	"DirectoryToArray">
	<cfargument	name=	"directory" />
	<cfargument	name=	"filter" />

	<cfset	var	qDirectoryFiles=	"" />
	<cfset	var	asDirectoryFiles=	[] />

	<cfif Len( filter )>
		<cfset	filter=	"*.#filter#" />

	</cfif>

	<cfdirectory	action=		"list"
					directory=	"#directory#"
					name=		"qDirectoryFiles"
					filter=		"#filter#"
					type=		"file" />

	<cfloop	query=	"qDirectoryFiles">
		<cfset	ArrayAppend( asDirectoryFiles , directory & "/" & name ) />

	</cfloop>

	<cfreturn	asDirectoryFiles />
</cffunction>