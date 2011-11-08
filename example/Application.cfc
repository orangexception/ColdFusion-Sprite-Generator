<cfcomponent output=    "false">
	
	<cfset this.name=	"Sprite Generator - Example" />

	<cffunction	name=	"onApplicationStart"
				hint=	"I run at the start of the application or upon reinitialization requests.">
		
		<cfset	var	SpriteGenerator=	
			CreateObject(	"component" ,	
							"org.orangexception.sprite-generator.SpriteGenerator" 
							).init() />

		<cfset	var	stSpriteSettings=	{
			sImagePath=					ExpandPath( "/example/assets/images/icons/" ) ,
			sImageStorageLocation=		ExpandPath( "/example/assets/images/" ) ,
			sStylesheetStorageLocation=	ExpandPath( "/example/assets/stylesheets/" ) ,
			sName=		"icons-sprite" ,
			bMinifyCSS=	true ,
			bOneRow=	false ,
			bOneColumn=	false } />

		<cfset	var	sResult=	SpriteGenerator.generateFromDirectory( 
									argumentCollection=	stSpriteSettings ) />

	</cffunction>
	
	<cffunction name= 	"onRequestStart"
				hint= 	"I run at the start of requests (how clever).">
					
		<!--- Run Request Scrubber Before Anything Else --->
		<cfset scrubRequest() />
		
		<!--- Application Related Stuff --->
		<cfif	StructKeyExists( url , "reinit" )>
			<cfset	onApplicationStart() />

		</cfif>
		
		<!--- AJAX Headers --->
		<cfif isAJAXRequest()>
			<cfheader	name= "Expires"	value= "#now()#" />
			<cfheader	name= "Pragma"	value= "no-cache" />

		</cfif>
			
		<!--- Cleanup Whitespace | Do not add space between cfcontent and cfreturn. --->
		<cfcontent	reset=	"true" /><cfreturn	true />		
		
	</cffunction>

	<cffunction name= 		"onRequestEnd"
				returnType= "void"
				hint= 		"I run on the end of requests (how clever).">
					
		<cfif isAJAXRequest()>
			<cfsetting	showDebugOutput=	"false"	
						enableCFOutputOnly=	"true" />

			<!--- If AJAXResponse is not set, then generated content is response. --->
			<cfparam	name=		"request.AJAXResponse"
						default=	"#getPageContext().getOut().getString()#" />

			<cfcontent	reset= "true" />
			<cfoutput>#trim( request.AJAXResponse )#</cfoutput>
			<cfabort />

		</cfif>
		
	</cffunction>
	
	
	<!--- User Defined Functions --->
	<cffunction name=	"scrubRequest"
				output=	"false"	access= "private"
				hint=	"I attempt to remove attacks and setup the request">
			
		<cfscript>
		var sKey=	"";

		if( isDefined( "form" ) ) {
			for ( sKey in form ) {
				form[ sKey ]=	htmlEditFormat( form[ sKey ] );
				form[ sKey ]=	reReplaceNoCase( form[ sKey ] ,
					"<[^>]*>" , "" ,
					"all" );
			
			}

		}

		for ( sKey in url ) {
			url[ sKey ]=	htmlEditFormat( url[ sKey ] );
			url[ sKey ]=	reReplaceNoCase( url[ sKey ] ,
				"<[^>]*>" , "" ,
				"all" );

		}
			
		</cfscript>

	</cffunction>
	
	<cffunction name= 	"isAJAXRequest" 
				output=	"false"
				access=	"private"
				hint=	"I check to see if the request came across with ajax headers">

		<cfif structKeyExists( getHTTPRequestData().headers , "X-Requested-With" )>
			<cfreturn true />

		</cfif>

		<cfreturn false />
		
	</cffunction>
	
</cfcomponent>
