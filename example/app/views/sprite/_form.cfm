<cfoutput>
<form	action=	"?action=sprite"
		method=	"post">
	<input	type=	"hidden"
			name=	"_method"
			value=	"#rc.method#" />

	<h2>Required Fields</h2>
	<p>
		<label	for=	"inputDirectory">
			Input Directory
			<span	class=	"required-asterisk">*</span>

		</label>
		<input	type=	"text"
				name=	"inputDirectory"
				value=	"#ExpandPath( "/example/app/assets/images/icons/" )#"
				style=	"width:	400px;" />

	</p>
	<p>
		Files in this directory will be used as images in the sprite.

	</p>
	<p>
		<label	for=	"outputDirectory">
			Output Directory
			<span	class=	"required-asterisk">*</span>

		</label>
		<input	type=	"text"
				name=	"outputDirectory"
				value=	"#ExpandPath( "/example/app/assets/images/" )#"
				style=	"width:	400px;" />

	</p>
	<p>
		The sprite will be saved to this directory.

	</p>

	<h2>Optional Fields</h2>

	<p>
		<label	for=	"name">
			Sprite Name

		</label>
		<input	type=	"text"
				name=	"name"
				value=	"" />

	</p>
	<p>
		The Output File Name. The File Extension will be the same as fileExtension.

	</p>
	<p>
		<label	for=	"rowLimit">
			Row Limit

		</label>
		<input	type=	"text"
				name=	"rowLimit"
				value=	"" />

	</p>
	<p>
		Limit the Number of Rows in Sprite. 0 = no limit.

	</p>
	<p>
		<label	for=	"columnLimit">
			Column Limit

		</label>
		<input	type=	"text"
				name=	"columnLimit"
				value=	"" />

	</p>
	<p>
		Limit the Number of Columns in Sprite. 0 = no limit.

	</p>
	<p>
		<label	for=	"fileExtension">
			File Extension

		</label>
		<input	type=	"text"
				name=	"fileExtension"
				value=	"" />

	</p>
	<p>
		File Extension of Images in Sprite (There can be only one.) Default uses first image in directory.

	</p>

	<input	type=	"submit"
			name=	"submit"
			value=	"Create" />

</form>
</cfoutput>