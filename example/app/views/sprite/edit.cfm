<cfoutput>
<h1>Sprite Created</h1>
<p>
	#rc.sprite#

</p>

<cfset	rc.relativeSprite=	REReplaceNoCase(	rc.sprite ,
												REReplaceNoCase( ExpandPath( "/" ) , "\\" , "\\" , "all" ) & "(.*)"  ,
												"/\1" ) />

<img	src=	"#ExpandPath( rc.relativeSprite )#" />
#REReplaceNoCase( ExpandPath( "/" ) , "\\" , "\\" , "all" )#
</cfoutput>