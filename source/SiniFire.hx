package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.graphics.frames.FlxAtlasFrames;

class SiniFire extends FlxSprite
{
	public function new(xPos:Float, yPos:Float, looped:Bool = false, glow:Bool = false, fps:Int = 24, frameOffset:Int = 0, maxFrames:Int = 0, flippedX:Bool = false, flippedY:Bool = false)
	{
		super(xPos, yPos);
		
		var toUseString:String = 'tabi/fire/FireStage';

		if (glow)
		{
			toUseString = 'tabi/fire/fireglow';
		}
		
		frames = Paths.getSparrowAtlas(toUseString);
		var frameShit:Array<Int> = [];

		for (i in 0...maxFrames)
		{
			var ourI:Int = i + frameOffset;
			if (ourI > maxFrames - 1)
			{
				ourI = ourI - (maxFrames - 1);
			}
			frameShit.push(i);
		}

		if (frameShit.length == 0)
		{
			for (i in 0...frames.frames.length)
			{
				var ourI:Int = i + frameOffset;
				if (ourI > maxFrames - 1)
				{
					ourI = ourI - (maxFrames - 1);
				}
				frameShit.push(i);
			}
		}

		animation.addByIndices('fire', 'FireStage', frameShit, "", fps, looped, flippedX, flippedY);
		animation.play('fire', true);
	}
	
	public function playAnim(forced:Bool = false):Void
	{
		animation.play('fire', forced);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}