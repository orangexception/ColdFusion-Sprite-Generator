<cfcomponent    name=	"FileService"
				output=	"false">

	<cffunction	name=	"init"
				output=	"false"
				hint=	"I the constructor for a Sprite.">
		
		<cfreturn	this />
	</cffunction>

	<cffunction	name=	"unzipFile"
				output=	"false"
				hint=	"I unzip a file of images.">
		
		<cfargument	name=		"sImagesZipFile"
					required=	"true"
					hint=		"I am a zip file of images" />
		
		<cfargument	name=		"sStorageLocation"
					required=	"true"
					hint=		"I am the storage location" />
		
		<cfscript>
		var	stUploadResult=			{};
		var	stUnzipToPathResult=	{};
		var	stFilesResult=			{};
		var	stResult=	{	sError=		"" ,
							sSuccess=	"" };

		stUploadResult=	uploadFile( argumentCollection=	arguments );

		if( len( stUploadResult.sError ) )
			return	stUploadResult;
		
		stUnzipToPathResult=	unzipFileToPath( 
			sZipFilename=		stUploadResult.sZipFilename ,
			sStorageLocation=	sStorageLocation );

		if( len( stUnzipToPathResult.sError ) )
			return	stUnzipToPathResult;
		
		stFilesResult= 		getFiles( sStorageLocation=	stUnzipToPathResult.sUnzippedPath );

		if( len( stFilesResult.sError ) )
			return	stFilesResult;

		stResult.sImagePath=	stUnzipToPathResult.sUnzippedPath;
		stResult.stFiles=		stFilesResult.stFiles;

		return stResult;
		</cfscript>

	</cffunction>

	<cffunction	name=	"uploadFile"
				output=	"false"
				hint=	"I upload a file to the server.">
		
		<cfargument	name=		"sImagesZipFile"
					required=	"true"
					hint=		"I am a zip file of images" />
		
		<cfargument	name=		"sStorageLocation"
					required=	"true"
					hint=		"I am the storage location" />
		
		<cfset	var	stFileResult=	{} />
		<cfset	var	stResult=	{	sError=		"" ,
									sSuccess=	"" } />

		<cftry>
			<cfif DirectoryExists( sStorageLocation ) eq false>
				<cfdirectory	action=		"create"
								directory=	"#sStorageLocation#" />

			</cfif>

			<cffile	action= 		"upload"
					accept=			"application/zip,application/x-zip-compressed"
					filefield=		"ImagesZipFile"
					nameconflict=	"overwrite"
					destination=	"#sStorageLocation#"
					result=			"stFileResult" />

			<cfif	listFindNoCase( "zip" , stFileResult.ClientFileExt ) eq 0>
				<cffile	action=	"delete"
						file=	"#sImagesZipFile#" />

				<cfset	stResult.sError=	"Invalid file extension. Upload a zip file of images." />

				<cfreturn	stResult />
				
			</cfif>

			<cfset	stResult.sZipFilename=	stFileResult.ClientFile />
			<cfset	stResult.sSuccess=		"File uploaded." />

			<cfcatch>
				<cfset	stResult.sError=	"Unable to upload file. #cfcatch.message#" />

			</cfcatch>

		</cftry>
		
		<cfreturn	stResult />
	</cffunction>

	<cffunction	name=	"unzipFileToPath"
				output=	"false"
				hint=	"I unzip a file to a path.">
		
		<cfargument	name=		"sZipFilename"
					required=	"true"
					hint=		"I am a zip file of images" />
		
		<cfargument	name=		"sStorageLocation"
					required=	"true"
					hint=		"I am the storage location" />

		<cfset	var	stResult=	{	sError=		"" ,
									sSuccess=	"" } />

		<cftry>
			<cfset	stResult.sUnzippedPath=	"#sStorageLocation##REReplace( sZipFilename , "\.zip$" , "" )#\" />

			<cfif DirectoryExists( stResult.sUnzippedPath ) eq false>
				<cfdirectory	action=		"create"
								directory=	"#stResult.sUnzippedPath#" />

			</cfif>

			<cfzip	action=			"unzip"
					file=			"#sStorageLocation##sZipFilename#"
					destination=	"#stResult.sUnzippedPath#" />
			
			<cfset	stResult.sSuccess=	"Unzipped file(s)." />

			<cfcatch>
				<cfset	stResult.sError=	"Unable to unzip file. #cfcatch.message#" />

			</cfcatch>

		</cftry>

		<cfreturn	stResult />
	</cffunction>

	<cffunction	name=	"getFiles"
				output=	"false"
				hint=	"I get files at a storage location.">
		
		<cfargument	name=		"sStorageLocation"
					required=	"true"
					hint=		"I am the storage location" />

		<cfset	var	qFiles=		"" />
		<cfset	var	stResult=	{	sError=		"" ,
									sSuccess=	"" } />
		<cfset	stResult.stFiles=	{} />

		<cftry>
			<cfdirectory	directory=	"#sStorageLocation#"
							action=		"list" 
							name=		"qFiles" />

			<cfquery	name=	"qFiles"
						dbtype=	"query">
			select
				name

			from
				qFiles

			where
					name like '%.png'
				or	name like '%.jpg'
				or	name like '%.gif'
				or	name like '%.jpeg'
				or	name like '%.tiff'

			</cfquery>
			
			<cfloop	query=	"qFiles">
				<cfset	stResult.stFiles[ name ]=	"" />
			
			</cfloop>

			<cfcatch>
				<cfset	stResult.sError=	"Unable to get files from path. #cfcatch.message#" />

			</cfcatch>
		</cftry>
		
		<cfreturn	stResult />
	</cffunction>

	<cffunction	name=	"zipFiles"
				output=	"false"
				hint=	"I zip files.">
		
		<cfargument	name=		"sStorageLocation"
					required=	"true"
					hint=		"I am the storage location" />
		
		<cfargument	name=		"lsFilesToZip"
					required=	"true"
					hint=		"I am a list of files to zip." />
		
		<cfset	var	sFilePath=	"" />
		<cfset	var	stResult=	{	sError=		"" ,
									sSuccess=	"" } />

		<cftry>
			<cfzip	file=	"#sStorageLocation#">
				<cfloop	list=	"#lsFilesToZip#"
						index=	"sFilePath">
					<cfzipparam	source=	"#sFilePath#" />

				</cfloop>

			</cfzip>

			<cfcatch>
				<cfset	stResult.sError=	"Unable to zip files. #cfcatch.message#" />

			</cfcatch>

		</cftry>

		<cfreturn	stResult />
	</cffunction>

	<cffunction	name=	"removeDirectory"
				output=	"false"
				hint=	"I remove a directory.">
		
		<cfargument	name=		"sStorageLocation"
					required=	"true"
					hint=		"I am the storage location" />

		<cfset	var	stResult=	{	sError=		"" ,
									sSuccess=	"" } />

		<cftry>		
			<cfdirectory	action=		"delete"
							directory=	"#sStorageLocation#"
							recurse=	"yes" />

			<cfcatch>
				<cfset	stResult.sError=	"Unable to remove directory. #cfcatch.message#" />

			</cfcatch>

		</cftry>

		<cfreturn	stResult />		
	</cffunction>

	<cffunction	name=	"minifyCSS"
				output=	"false"
				hint=	"I minify a CSS file.">
		
		<cfargument	name=		"sStorageLocation"
					required=	"true"
					hint=		"I am the storage location" />

		<cfset	var	stResult=	{	sError=		"" ,
									sSuccess=	"" } />
		<cfset	var	sContent=	"" />
	
			<cffile	action=		"read"
					file=		"#sStorageLocation#"
					variable=	"sContent" />
	
			<cfset	sContent.ReplaceAll( "(?s)\s|/\*.*?\*/" , "" ) />
				
			<cffile	action=	"write"
					file=	"#REReplace( sStorageLocation , "\.css$" , ".min.css" )#"
					output=	"#sContent#" />

		<cfreturn	stResult />		
	</cffunction>
	
</cfcomponent>