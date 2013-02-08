﻿component extends="org.corfield.framework" {
	// FW/1 - configuration for introduction application:
	// controllers/layouts/services/views are in this folder (allowing for non-empty context root):
	variables.framework=	{
		base=	getDirectoryFromPath( CGI.SCRIPT_NAME ).replace( getContextRoot(), '' ) & 'app'
	};

}