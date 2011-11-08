# ColdFusion Sprite Generator
A sprite generator that runs on ColdFusion.

## Author
Bradley Moore

orangexception.com  
@orangexception on Twitter

## Description
This application works as a standalone ColdFusion application or you can tie it into existing applications. 

The SpriteService generates a sprite image file and CSS file. 

The most basic approach sends a zip file of images into the SpriteService and it sends back a zip file of the sprite.

You can also send in parameters for the filename of the sprite and whether you want to include a minified copy of the CSS.

For use within your application, the SpriteService also will generate a sprite from a directory available to ColdFusion. You can specify the output directory as well, which allows you to keep your true images hidden.

## Installation
The simplest install method is to create a new application and try out the index.html.

The components use relative paths, so you can store and call them however you like.

The SpriteService.cfc has two `access=	"remote"` functions `generate()` and `generateFromDirectory()`. You may want to change the access type of these functions, if you use it within an existing application.

## Language Support
ColdFusion 8

I imagine it works in Railo and ColdFusion 9.

## Usage
The sprite is built upon shifting the background position of a common image. This reduces the number of http requests, which will allow your page to load faster.

To display a sprite image on your page, use the following format:
```
    <div	id=		"{image-name-minus-extension}"
			class=	"icon"></div>
```

The id is the filename of your target image minus the extension. You must include the `class=	"icon"` for the CSS to match.
    
For a working example, view source at [http://your-achievements.com/orangexception](http://your-achievements.com/orangexception)