component	name=		"Sprite"
			output=		"false"
			accessors=	"true"
			hint=		"I am a Sprite." {

	//	Characteristics
	property	name=	"name";				//	The Output File Name. The File Extension will be the same as fileExtension.
	property	name=	"rowLimit";			//	Limit the Number of Rows in Sprite. 0 = no limit.
	property	name=	"columnLimit";		//	Limit the Number of Columns in Sprite. 0 = no limit.
	property	name=	"fileExtension";	//	File Extension of Images in Sprite (There can be only one.) Default uses first image in directory.

	//	Properties
	property	name=	"images";			//	Array of File Names
	property	name=	"grid";				//	2 Dimensional Array of Images and Dimensions
	property	name=	"unitHeight";		//	Maximum Height of Images
	property	name=	"unitWidth";		//	Maximum Width of Images
	property	name=	"height";			//	Height of Sprite
	property	name=	"width";			//	Width of Sprite
	property	name=	"rows";				//	Rows of Sprite
	property	name=	"columns";			//	Columns of Sprite

	include	"spriteHelper.cfm";

	//	Define Characteristics for Sprite
	function init (	name=			"" ,
					rowLimit=		0 ,
					columnLimit=	0 ,
					fileExtension=	"" ) {
		setName( name );
		setRowLimit( rowLimit );
		setColumnLimit( columnLimit );
		setFileExtension( fileExtension );
		setImages( [] );
		setGrid( ArrayNew( 2 ) );
		setUnitHeight( 0 );
		setUnitWidth( 0 );
		setHeight( 0 );
		setWidth( 0 );
		setRows( 0 );
		setColumns( 0 );

		return	this;
	}

	function create (	inputDirectory ,
						outputDirectory ) {
		var	asImages=	DirectoryToArray(	directory=	inputDirectory ,
											filter=		getFileExtension() );

		if( Len( getFileExtension() ) == 0 ) {
			//	Use First File Extension
			setFileExtension(	REReplaceNoCase(	asImages[ 1 ] ,
													"^.*\.(\w+)$" ,
													"\1" ) );
			//	Requery with Filter
			asImages=	DirectoryToArray(	directory=	inputDirectory ,
											filter=		getFileExtension() );

		}

		//	Add Images to Sprite
		for( var sImage in asImages ) {
			addImage( sImage );

		}

		//	Construct Grid
		constructGrid();

		//	Create Sprite Image
		return	save( outputDirectory );
	}

	//	Private Functions
	private function addImage ( image ) {
		var	oImage=		ImageRead( image );
		var	stImage=	{	image=	image ,
							height=	oImage.height ,
							width=	oImage.width };

		ArrayAppend( images , Duplicate( stImage ) );

		//	Maximum Unit Height Check
		if( oImage.height > unitHeight ) {
			unitHeight=	oImage.height;

		}
		//	Maximum Unit Width Check
		if( oImage.width > unitWidth ) {
			unitWidth=	oImage.width;

		}

	}

	private function constructGrid () {
		//	Reset Grid
		grid=		[[]];
		columns=	1;
		rows=		1;

		//	Available Positions
		var	available=	[	{	row=	1 ,
								column=	1 } ];
		var	position=	{};

		//	Add Images to Grid
		for( var image in images ) {
			//	Increase Grid Size
			if( ArrayLen( available ) == 0 ) {
				var	bColumnsWithinLimit=	columnLimit == 0
											||	columns < columnLimit;
				var	bRowsWithinLimit=	rowLimit == 0
										||	rows < rowLimit;

				//	Increase Columns within Column Limit
				if(	bColumnsWithinLimit
				&&	(	columns < rows
					||	rows >= rowLimit ) ) {
					//	Increase Columns
					columns++;
					//	Set Available Positions
					for(	var	row=	1;
							row <= rows;
							row++ ) {
						position=	{	row=	row ,
										column=	columns };
						ArrayAppend( available , Duplicate( position ) );

					}

				}
				//	Increase Rows within Row Limit
				else if ( bRowsWithinLimit ) {
					//	Increase Rows
					rows++;

					//	Set Available Positions
					for(	var	column=	1;
							column <= columns;
							column++ ) {
						position=	{	row=	rows ,
										column=	column };
						ArrayAppend( available , Duplicate( position ) );

					}

				}
				//	Increase Columns ( Column and Row Limit Both Reached )
				else if ( columns <= rows ) {
					columns++;
					//	Set Available Positions
					for(	var	row=	1;
							row <= rows;
							row++ ) {
						position=	{	row=	row ,
										column=	columns };
						ArrayAppend( available , Duplicate( position ) );

					}

				}
				//	Increase Rows ( Column and Row Limit Both Reached )
				else {
					rows++;
					//	Set Available Positions
					for(	var	column=	1;
							column <= columns;
							column++ ) {
						position=	{	row=	rows ,
										column=	column };
						ArrayAppend( available , Duplicate( position ) );

					}

				}

			}

			//	Claim Position
			position=	Duplicate( available[ 1 ] );

			//	Add Image to Grid
			grid[ position.column ][ position.row ]=	image;

			//	Remove Position
			ArrayDeleteAt( available , 1 );

		}

		//	Sprite Dimensions
		height=	unitHeight * rows;
		width=	unitWidth * columns;

	}

	private function save ( outputDirectory ) {
		var	row=	1;
		var	column=	1;

		var	offsetX=	0;
		var	offsetY=	0;

		var	oSpriteImage=	ImageNew(	"" ,
										width ,
										height ,
										"argb" );

		for(	var	column=	1;
				column <= columns;
				column++ ) {
			//	Update Left Offset
			offsetX=	( column - 1 ) * unitWidth;

			for(	var	row=	1;
					row <= ArrayLen( grid[ column ] );
					row++ ) {
				//	Update Top Offset
				offsetY=	( row - 1 ) * unitHeight;

				//	Read Image
				var	oImage=	ImageRead( grid[ column ][ row ].image );

				//	Add Image to Sprite
				ImagePaste(	oSpriteImage ,
							oImage ,
							offsetX ,
							offsetY );

			}

		}

		//	Output File
		var	outputFile=	outputDirectory & "/" & name & "." & fileExtension;

		//	Write Sprite to Disk
		ImageWrite( oSpriteImage , outputFile );

		//	Create CSS
		createCSS( argumentCollection=	arguments );

		return	ExpandPath( outputFile );
	}

	function createCSS ( outputDirectory ) {
		//	Localize Variables
		var	row=	1;
		var	column=	1;

		var	css=	"";
		var	cssID=	"";

		var	offsetX=	0;
		var	offsetY=	0;

		//	Build CSS
		savecontent	variable=	"css" {
			include	"spriteCSS.cfm";

		}

		//	Output File
		var	outputFile=	outputDirectory & "/" & name;

		//	Bloated CSS
		FileWrite( outputFile & ".css" , css );

		//	Minified CSS
		css=	REReplaceNoCase(	css ,
									"(?s)\s|/\*.*?\*/" ,
									"" ,
									"all" );
		FileWrite( outputFile & ".min.css" , css );

	}

	//	Accessor Overrides
	function setName ( name ) {
		if( Len( name ) == 0 ) {
			name=	"sprite-#createUUID()#";

		}

		variables.name=	name;

	}

}