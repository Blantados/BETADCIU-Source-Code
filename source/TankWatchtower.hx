package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class TankWatchtower extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		frames = Paths.getSparrowAtlas('tank/tankWatchtower');

		animation.addByPrefix('idle', 'watchtower gradient color', 24, false);

		animation.play('idle');
	}

	var danceDir:Bool = false;

	public function dance():Void
	{
			animation.play('idle', true);
	}
}
