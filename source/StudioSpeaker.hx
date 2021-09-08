package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class StudioSpeaker extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		frames = Paths.getSparrowAtlas("studio/studio_speaker");
		animation.addByPrefix('bump', 'speaker', 24);
		animation.play('bump');
		antialiasing = true;
	}

	public function dance():Void
	{
		animation.play('bump', true);
	}
}