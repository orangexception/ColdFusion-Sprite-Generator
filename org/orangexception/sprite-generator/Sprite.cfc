<cfcomponent	name=	"Sprite"
				output=	"false">

	<cffunction	name=	"init"
				output=	"false"
				hint=	"I the constructor for a Sprite.">
		
		<cfargument	name=		"sStorageLocation"
					required=	"false"
					default=	"#GetTempDirectory()#"
					hint=		"I am the storage location" />
		
		<cfargument	name=		"sName"
					required=	"false"
					default=	"sprite"
					hint=		"I am the name of the sprite." />
		
		<cfargument	name=		"bOneRow"
					required=	"false"
					default=	"false"
					hint=		"I force the sprite to generate as a single row." />
		
		<cfargument	name=		"bOneColumn"
					required=	"false"
					default=	"false"
					hint=		"II force the sprite to generate as a single column." />

		
		<cfscript>

		// Public
		this.bCreated=			false;
		this.sUUID=				createUUID();
		this.sImagePath=		"";
		this.sName=				sName;
		if( len( this.sName ) == 0 )
			this.sName=			"sprite";
		this.sStorageLocation=	sStorageLocation;
		if( REFind( "\w$" , this.sStorageLocation ) )
			this.sStorageLocation &= "\";	
		if( this.sStorageLocation eq GetTempDirectory() )
			this.sStorageLocation=	sStorageLocation & this.sUUID & "\";

		// Private
		variables.bOneRow=				arguments.bOneRow;
		variables.bOneColumn=			arguments.bOneColumn;
		variables.bSameHeight=			true;
		variables.bSameWidth=			true;
		variables.bSameExtension=		true;
		variables.sExtension=			"";
		variables.asImages=				[];
		variables.asGridImages=			ArrayNew( 2 );
		variables.asGridImages[ 1 ][ 1 ]=	"";
		variables.stSpriteDimensions=	{	rows=		1 ,
											columns=	1 ,
											width=		0 ,
											height=		0 };
		variables.stUnitDimensions=		{	width=	0 , 
											height=	0 };
			
		return	this;
		</cfscript>

	</cffunction>

	<cffunction	name=	"addImage"
				output=	"false"
				hint=	"I add an image to myself">

		<cfargument	name=		"sImageFilename"
					required=	"true"
					hint=		"I am the name of the file to add to myself." />

		<cfscript>
		var sImagePath=	"#this.sImagePath##sImageFilename#";

		var	imgNext=	ImageRead( sImagePath );

		var	stImageDetails=	{	sImageFilename=	sImageFilename ,
									height=			imgNext.height ,
									width=			imgNext.width };

		ArrayAppend( asImages , stImageDetails );

		if(	len( sExtension ) == 0 )
			sExtension=	sImagePath.ReplaceAll( "^.*(\.\w{3})$" , "$1" );

		if( sExtension != sImagePath.ReplaceAll( "^.*(\.\w{3})$" , "$1" ) )
			bSameExtension=	false;

		if(	stUnitDimensions.height == 0 )
			stUnitDimensions.height=	imgNext.height;
		if(	stUnitDimensions.width == 0 )
			stUnitDimensions.width=		imgNext.width;

		if(	bSameHeight
			&& stUnitDimensions.height != imgNext.height )
			bSameHeight=	false;
		if(	bSameWidth
			&& stUnitDimensions.width != imgNext.width )
			bSameWidth=		false;

		if(	stUnitDimensions.height < imgNext.height )
			stUnitDimensions.height=	imgNext.height;
		if(	stUnitDimensions.width < imgNext.width )
			stUnitDimensions.width=		imgNext.width;

		</cfscript>

	</cffunction>

	<cffunction	name=	"save"
				output=	"false"
				hint=	"I save myself from impending doom.">
		
		<cfif	hasImages() eq false>
			<cfthrow	message=	"Sprite has no images. Cannot create Sprite." />

		</cfif>

		<cfif DirectoryExists( this.sStorageLocation ) eq false>
			<cfdirectory	action=		"create"
							directory=	"#this.sStorageLocation#" />

		</cfif>
		
		<cfset	constructGrid() />
		<cfset	createImage() />
		<cfset	createCSS() />
		<cfset	this.bCreated=	true />

	</cffunction>

	<cffunction	name=	"getFilePaths"
				output=	"false"
				hint=	"I get a list of the files I created.">
		
		<cfset	var	lsFilePaths=	"" />
		
		<cfif this.bCreated eq false>
			<cfreturn	lsFilePaths />

		</cfif>

		<cfset	lsFilePaths=	ListAppend(	lsFilePaths ,
											"#this.sStorageLocation##this.sName##sExtension#" ) />
		<cfset	lsFilePaths=	ListAppend(	lsFilePaths ,
											"#this.sStorageLocation##this.sName#.css" ) />
		
		<cfreturn	lsFilePaths />
	
	</cffunction>

	<cffunction	name=	"hasImages"
				output=	"false"
				access=	"private"
				hint=	"I determine if I have images.">

		<cfif	ArrayLen( asImages )
				and IsStruct( asImages[ 1 ] )>
			<cfreturn	true />
		
		</cfif>

		<cfreturn	false />
	</cffunction>

	<cffunction	name=	"createImage"
				ouput=	"false"
				access=	"private"
				hint=	"I create an image of myself.">
		
		<cfscript>
		var	currentRow=		1;
		var	currentColumn=	1;

		var	rowWidth=		0;
		var	columnHeight=	0;

		var	sImagePath=	"";
		var	imgSprite=	ImageNew(	"" ,
									stSpriteDimensions.width ,
									stSpriteDimensions.height ,
									"argb" );

		stSpriteDimensions.height=	0;
		stSpriteDimensions.width=	0;

		for(	currentRow=	1;
				currentRow <= stSpriteDimensions.rows;
				currentRow++ ) {
			rowWidth=	0;

			for(	currentColumn=	1;
					currentColumn <= stSpriteDimensions.columns;
					currentColumn++ ) {
				if( IsStruct( asGridImages[ currentColumn ][ currentRow ] ) ) {
					sImagePath=	"#this.sImagePath#\#asGridImages[ currentColumn ][ currentRow ].sImageFilename#";
					imgNext=	ImageRead( sImagePath );

					asGridImages[ currentColumn ][ currentRow ].x=	rowWidth;

					asGridImages[ currentColumn ][ currentRow ].y=	stSpriteDimensions.height;
					if( currentRow == 1 )
						asGridImages[ currentColumn ][ currentRow ].y=	0;

					if(	!bSameHeight && !bSameWidth
						&& !bOneRow
						&& !bOneColumn ) {
						asGridImages[ currentColumn ][ currentRow ].x=  
						( currentColumn  - 1 ) * stUnitDimensions.width;
						asGridImages[ currentColumn ][ currentRow ].y=  ( currentRow  - 1 ) * stUnitDimensions.height;

					}

					ImagePaste(	imgSprite ,
								imgNext ,
								asGridImages[ currentColumn ][ currentRow ].x ,
								asGridImages[ currentColumn ][ currentRow ].y );

					if( currentColumn == stSpriteDimensions.columns ) {
						stSpriteDimensions.height+=	imgNext.height;

					}

					if( currentRow == 1 )
						stSpriteDimensions.width+=	imgNext.width;

					rowWidth+=	imgNext.width;
					
				}

			}

		}

		if(	!bSameWidth && bOneColumn )
			stSpriteDimensions.width=	stUnitDimensions.width;

		if(	!bSameHeight && bOneRow )
			stSpriteDimensions.height=	stUnitDimensions.height;

		if(	bSameHeight || bSameWidth
			|| bOneRow
			|| bOneColumn ) {
			ImageCrop(	imgSprite ,
						0 ,
						0 ,
						stSpriteDimensions.width ,
						stSpriteDimensions.height );
						
		}

		if( bSameExtension == false )
			sExtension=	".png";

		ImageWrite(	imgSprite ,
					"#this.sStorageLocation##this.sName##sExtension#" );
		
		</cfscript>

	</cffunction>

	<cffunction	name=	"constructGrid"
				output=	"false"
				access=	"private"
				hint=	"I create a grid sprite">
		<cfscript>
		var	iPosition=	1;
		var	stNextSlot=	{};

		for(	iPosition=	1;
				iPosition <= ArrayLen( asImages );
				iPosition++ ) {
			stNextSlot=	getNextSlot();
			asGridImages[ stNextSlot.column ][ stNextSlot.row ]=	asImages[ iPosition ];

		}

		stSpriteDimensions.width=	stUnitDimensions.width * stSpriteDimensions.columns;
		stSpriteDimensions.height=	stUnitDimensions.height * stSpriteDimensions.rows;

		</cfscript>

	</cffunction>

	<cffunction	name=	"getNextSlot"
				output=	"false"
				access=	"private"
				hint=	"I get the next free spot.">
		
		<cfscript>
		var	currentRow=		1;
		var	currentColumn=	1;

		for(	currentRow=	1;
				currentRow <= stSpriteDimensions.rows;
				currentRow++ ) {
			for(	currentColumn=	1;
					currentColumn <= stSpriteDimensions.columns;
					currentColumn++ ) {
				if( IsStruct( asGridImages[ currentColumn ][ currentRow ] ) == false ) {
					stResult.row=		currentRow;
					stResult.column=	currentColumn;
					return	stResult;
					
				}

			}
		
		}

		increaseDimensions();

		return getNextSlot();

		</cfscript>

	</cffunction>

	<cffunction	name=	"increaseDimensions"
				output=	"false"
				access=	"private"
				hint=	"I increase my dimensions">
		
		<cfscript>
		var	currentColumn=	1;

		if(	bSameHeight && bSameWidth
			&& !bOneRow
			&& !bOneColumn ) {
			if( stSpriteDimensions.columns > stSpriteDimensions.rows ) {
				stSpriteDimensions.rows++;
				for(	currentColumn;
						currentColumn <= stSpriteDimensions.columns;
						currentColumn++ )
					asGridImages[ currentColumn ][ stSpriteDimensions.rows ]=	"";

			}
			else {
				stSpriteDimensions.columns++;
				asGridImages[ stSpriteDimensions.columns ]=	[];
				ArraySet(	asGridImages[ stSpriteDimensions.columns ] ,
							1 ,
							stSpriteDimensions.rows ,
							"" );
				
			}
			
		}
		else if(	bSameHeight
					|| bOneRow ) {
			stSpriteDimensions.columns++;
			asGridImages[ stSpriteDimensions.columns ]=	[];
			ArraySet(	asGridImages[ stSpriteDimensions.columns ] ,
						1 ,
						stSpriteDimensions.rows ,
						"" );
			
		}
		else if(	bSameWidth
					|| bOneColumn ) {
			stSpriteDimensions.rows++;
			for(	currentColumn;
					currentColumn <= stSpriteDimensions.columns;
					currentColumn++ )
				asGridImages[ currentColumn ][ stSpriteDimensions.rows ]=	"";

		}
		else {
			// Need to refactor using optimal method. NP-Complete problem? Same as grid for now.
			if( stSpriteDimensions.columns > stSpriteDimensions.rows ) {
				stSpriteDimensions.rows++;
				for(	currentColumn;
						currentColumn <= stSpriteDimensions.columns;
						currentColumn++ )
					asGridImages[ currentColumn ][ stSpriteDimensions.rows ]=	"";

			}
			else {
				stSpriteDimensions.columns++;
				asGridImages[ stSpriteDimensions.columns ]=	[];
				ArraySet(	asGridImages[ stSpriteDimensions.columns ] ,
							1 ,
							stSpriteDimensions.rows ,
							"" );
				
			}			

		}

		</cfscript>

	</cffunction>

	<cffunction	name=	"createCSS"
				ouput=	"false"
				access=	"private"
				hint=	"I create a CSS file of myself.">
		
		<cfset	var	currentRow=		1 />
		<cfset	var	currentColumn=	1 />

		<cfset	var	sSpriteCSS=	"" />
		<cfset	var	sImageName=	"" />

		<cfset	var	x=	0 />
		<cfset	var	y=	0 />

		<cfoutput>
<cfsavecontent	variable=	"sSpriteCSS">
.#this.sName# {
	position:	absolute;
	top:		0;
	left:		0;

	width:	#stUnitDimensions.width#px;
	height:	#stUnitDimensions.height#px;
	
	background:	url( "#this.sName##sExtension#" ) no-repeat;

}
</cfsavecontent>
		</cfoutput>

		<cfloop	from=	"1"
				to=		"#stSpriteDimensions.rows#"
				index=	"currentRow">
			<cfloop	from=	"1"
					to=		"#stSpriteDimensions.columns#"
					index=	"currentColumn">
				<cfif IsStruct( asGridImages[ currentColumn ][ currentRow ] )>
					<cfset	x=	-1 * asGridImages[ currentColumn ][ currentRow ].x />
					<cfset	y=	-1 * asGridImages[ currentColumn ][ currentRow ].y />
					<cfset	sImageName=	REReplace( 
						asGridImages[ currentColumn ][ currentRow ].sImageFilename ,
						"^(.*)\.\w+$" ,
						"\1" ) />

					<cfif len( sImageName )>
						<cfoutput>
<cfsavecontent	variable=	"sSpriteCSS">#sSpriteCSS#
	###sImageName#.#this.sName# {<cfif asGridImages[ currentColumn ][ currentRow ].height neq stUnitDimensions.height>
		height:	#asGridImages[ currentColumn ][ currentRow ].height#px;</cfif><cfif asGridImages[ currentColumn ][ currentRow ].width neq stUnitDimensions.width>
		width:	#asGridImages[ currentColumn ][ currentRow ].width#px;</cfif>
		background-position:	#x#px #y#px;

	}
</cfsavecontent>
						</cfoutput>

					</cfif>

				</cfif>
							
			</cfloop>
		
		</cfloop>

		<cfset	sSpriteCSS=	trim( sSpriteCSS ) />

		<cffile	action=	"write"
				file=	"#this.sStorageLocation##this.sName#.css"
				output=	"#sSpriteCSS#" />

	</cffunction>
	
</cfcomponent>