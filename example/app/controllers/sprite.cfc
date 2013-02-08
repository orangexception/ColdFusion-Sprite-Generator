component {
	function init ( fw ) {
		variables.fw=	fw;

	}

	function default ( rc ) {
		if( StructKeyExists( rc , "_method" ) ) {

			return	create( rc );
		}

		return	new( rc );
	}

	function new ( rc ) {
		fw.service( "sprite.new" , "sprite" );

		fw.setView( "sprite.new" );

	}

	function create ( rc ) {
		fw.service( "sprite.create" , "sprite" );
		fw.setView( "sprite.edit" );

	}

}