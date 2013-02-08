component	name=	"sprite" {
	function new () {

		return	new	lib.orangexception.sprite.sprite( argumentCollection=	arguments );
	}

	function create (	inputDirectory=		ExpandPath( "/example/app/assets/images/icons/" ) ,
						outputDirectory=	ExpandPath( "/example/app/assets/images/" ) ) {
		var	oSprite=	new( argumentCollection=	arguments );

		return	oSprite.create( argumentCollection=	arguments );
	}

}