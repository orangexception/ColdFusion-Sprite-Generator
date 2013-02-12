<cfoutput>
.#name# {
	position:	absolute;
	top:		0;
	left:		0;

	width:	#unitWidth#px;
	height:	#unitHeight#px;

	background:	url( "#name#.#fileExtension#" ) no-repeat;

}

	<cfloop	from=	"1"
			to=		"#columns#"
			index=	"column">
		<!---	Update Left Offset	--->
		<cfset	offsetX=	( column - 1 ) * unitWidth />

		<cfloop	from=	"1"
				to=		"#ArrayLen( grid[ column ] )#"
				index=	"row">
			<!---	Update Top Offset	--->
			<cfset	offsetY=	( row - 1 ) * unitHeight />

			<!---	Image Name without Extension is the CSS ID	--->
			<cfset	cssID=	REReplace(	grid[ column ][ row ].image ,
										"^.*[\\\/](\w.*)\.\w+$" ,
										"\1" ) />
	###cssID#.#name# {
		<cfif grid[ column ][ row ].height neq unitHeight>
		height:	#grid[ column ][ row ].height#px;

		</cfif>
		<cfif grid[ column ][ row ].width neq unitWidth>
		width:	#grid[ column ][ row ].width#px;

		</cfif>

		background-position:	#offsetX#px #offsetY#px;

	}

		</cfloop>

	</cfloop>

</cfoutput>