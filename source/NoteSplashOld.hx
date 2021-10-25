package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import Paths;
import Song;
import Conductor;
import Math;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import lime.utils.Assets;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import flixel.animation.FlxAnimation;

import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;

#if cpp
import Sys;
import sys.FileSystem;
#end


using StringTools;

class NoteSplash extends FlxSprite
{
	

    override public function new()
    {
    	super();
		switch (PlayState.SONG.noteStyle)
		{
			case '1930' | 'fever' | 'kapi':
				frames = (Paths.getSparrowAtlas("notestuff/noteSplashes-"+PlayState.SONG.noteStyle));
			default:
				if (PlayState.changeArrows) {
					frames =  Paths.getSparrowAtlas("notestuff/noteSplashes"+PlayState.splashSkin);
				}
				else {
					frames = Paths.getSparrowAtlas("notestuff/noteSplashes");
				}			
		}
    	
    	//impact 1
    	animation.addByPrefix("note1-0", "note impact 1 blue", 24, false);
    	animation.addByPrefix("note2-0", "note impact 1 green", 24, false);
    	animation.addByPrefix("note0-0", "note impact 1 purple", 24, false);
    	animation.addByPrefix("note3-0", "note impact 1 red", 24, false);
    	//impact 2
    	animation.addByPrefix("note1-1", "note impact 2 blue", 24, false);
    	animation.addByPrefix("note2-1", "note impact 2 green", 24, false);
    	animation.addByPrefix("note0-1", "note impact 2 purple", 24, false);
    	animation.addByPrefix("note3-1", "note impact 2 red", 24, false);
    }

    public function setupNoteSplash(xPos:Float, yPos:Float, note:Int)
    {
    	if(note == 0)
    	{
    		note = 0;
    	}
    	x = xPos;
    	y = yPos;
    	alpha = 0.6;
    	animation.play("note" + note + "-" + FlxG.random.int(0, 1), true);
    	var a:FlxAnimation = animation.curAnim;
    	a.frameRate = a.frameRate + FlxG.random.int(-2, 2);
    	updateHitbox();
    	offset.set(0.3 * width, 0.3 * height);
    }

    override public function update(elapsed:Float)
    {	
    	if(animation.curAnim.finished) kill();

    	super.update(elapsed);
    }
}