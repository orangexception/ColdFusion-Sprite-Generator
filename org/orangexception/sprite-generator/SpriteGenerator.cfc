<cfcomponent	name=	"SpriteService"
				output=	"false">

	<cffunction	name=	"init"
				output=	"false"
				hint=	"I the constructor for the SpriteService.">
		
		<cfset	variables.oFileService=	createObject( "component" , "FileService" ).init() />

		<cfreturn this />		
	</cffunction>

	<cffunction	name=			"generateFromDirectory"
				output=			"true"
				returnType=		"string"
				returnFormat=	"plain"
				access=			"remote"
				hint=			"I create a sprite from a directory.">

		<cfargument	name=		"sImagePath"
					required=	"true"
					hint=		"I am the path to the images." />
		
		<cfargument	name=		"sImageStorageLocation"
					required=	"false"
					default=	"#GetTempDirectory()#"
					hint=		"I am the destination of the sprite image." />
		
		<cfargument	name=		"sStylesheetStorageLocation"
					required=	"false"
					default=	"#GetTempDirectory()#"
					hint=		"I am the destination of the sprite stylesheet(s)." />
		
		<cfargument	name=		"sName"
					required=	"false"
					default=	"sprite"
					hint=		"I am the name of the sprite." />
		
		<cfargument	name=		"bMinifyCSS"
					required=	"false"
					default=	"false"
					hint=		"I determine if I create a minified CSS file." />
		
		<cfargument	name=		"bOneRow"
					required=	"false"
					default=	"false"
					hint=		"I determine if the sprite is limited to one row." />
		
		<cfargument	name=		"bOneColumn"
					required=	"false"
					default=	"false"
					hint=		"I determine if the sprite is limited to one column." />


		<cfscript>
		var	lsFilesToZip=	"";
		var	oSprite=		"";
		var	sImageFilename=	"";
		var	SpriteZipPath=	"";

		var	stImageFiles=	{};
		var	stZipResult=	{};
		init();

		oSprite=	createObject( "component" , "Sprite" ).init(
			sStorageLocation=	arguments.sImageStorageLocation ,
			argumentCollection=	arguments );
		oSprite.sImagePath=	sImagePath;

		stImageFiles=	oFileService.getFiles( sImagePath );

		for( sImageFilename in stImageFiles.stFiles )
			oSprite.addImage( sImageFilename=	sImageFilename );

		oSprite.save();

		FileMove(	"#sImageStorageLocation##oSprite.sName#.css" ,
					"#sStylesheetStorageLocation##oSprite.sName#.css" );

		if( bMinifyCSS )
			oFileService.minifyCSS( sStorageLocation=	"#sStylesheetStorageLocation##oSprite.sName#.css" );

		return	"#oSprite.sName# stored at #oSprite.sStorageLocation#";
		</cfscript>

	</cffunction>

	<cffunction	name=			"generate"
				output=			"true"
				returnType=		"string"
				returnFormat=	"plain"
				access=			"remote"
				hint=			"I create a sprite from a zip file of images.">
		
		<cfargument	name=		"ImagesZipFile"
					required=	"true"
					hint=		"I am a zip file of images" />
		
		<cfargument	name=		"sName"
					required=	"false"
					default=	"sprite"
					hint=		"I am the name of the sprite." />
		
		<cfargument	name=		"bMinifyCSS"
					required=	"false"
					default=	"false"
					hint=		"I determine if I create a minified CSS file." />
		
		<cfargument	name=		"bOneRow"
					required=	"false"
					default=	"false"
					hint=		"I determine if the sprite is limited to one row." />
		
		<cfargument	name=		"bOneColumn"
					required=	"false"
					default=	"false"
					hint=		"I determine if the sprite is limited to one column." />
		
		<cfscript>
		var	lsFilesToZip=	"";
		var	oSprite=		"";
		var	sImageFilename=	"";
		var	SpriteZipPath=	"";

		var	stUnzipResult=	{};
		var	stZipResult=	{};
		var	stRemoveDirectoryResult=	{};

		init();

		oSprite=	createObject( "component" , "Sprite" ).init(
			sName=		sName ,
			bOneRow=	bOneRow ,
			bOneColumn=	bOneColumn );

		stUnzipResult=	oFileService.unzipFile( 
			sImagesZipFile=		ImagesZipFile , 
			sStorageLocation=	oSprite.sStorageLocation );
			
		if( len( stUnzipResult.sError ) )
			return stUnzipResult.sError;
		
		oSprite.sImagePath=	stUnzipResult.sImagePath;
		
		for( sImageFilename in stUnzipResult.stFiles )
			oSprite.addImage( sImageFilename=	sImageFilename );

		oSprite.save();

		lsFilesToZip=	oSprite.getFilePaths();
		if( bMinifyCSS ) {
			oFileService.minifyCSS( sStorageLocation=	"#oSprite.sStorageLocation##oSprite.sName#.css" );
			lsFilesToZip=	ListAppend( lsFilesToZip , "#oSprite.sStorageLocation##oSprite.sName#.min.css" );
			
		}

		sSpriteZipPath=	REReplace(	oSprite.sStorageLocation ,
									"\\$" ,
									".zip" );

		stZipResult=	oFileService.zipFiles(	
			sStorageLocation=	sSpriteZipPath ,
			lsFilesToZip=		lsFilesToZip );

		if( len( stZipResult.sError ) )
			return stZipResult.sError;

		stRemoveDirectoryResult=	oFileService.removeDirectory( oSprite.sStorageLocation );

		if( len( stRemoveDirectoryResult.sError ) )
			return stRemoveDirectoryResult.sError;
		
		streamFile( sSpriteZipPath );

		</cfscript>

	</cffunction>

	<cffunction	name=	"streamFile"
				output=	"true"
				hint=	"I stream the generated Sprite Zip file">

		<cfargument	name=		"sSpriteZipPath"
					required=	"true"
					hint=		"I am the path to the Sprite Zip file." />
		
		<cfheader	name=	"Content-Disposition" 
					value=	"attachment; filename=sprite.zip">
		<cfcontent	file=		"#sSpriteZipPath#"
					deletefile=	"true" 
					type=		"application/zip">

	</cffunction>
	
</cfcomponent>