package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Cloud2 extends FlxSprite
{
    public function new()
    {
        super(Paths.image("holofunk/limoholo/cloud"));
		super.setGraphicSize(Std.int(super.width * 0.65));
        kill();
    }

    override public function revive()
    {
        x = -width * 1.3;
        y = FlxG.random.int(-8850, -9250);
        velocity.x = 700;
        super.revive();
    }

    override public function update(elapsed:Float)
    {
        if (x > FlxG.width * 20)
            kill();
        super.update(elapsed);
    }
}