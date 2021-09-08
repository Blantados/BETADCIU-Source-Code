package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Cloud extends FlxSprite
{
    public function new()
    {
        super(Paths.image("holofunk/limoholo/cloud"));
		super.setGraphicSize(Std.int(super.width * 0.8));
        kill();
    }

    override public function revive()
    {
        x = -width * 1.3;
        y = FlxG.random.int(-8600, -9200);
        velocity.x = 1400;
        super.revive();
    }

    override public function update(elapsed:Float)
    {
        if (x > FlxG.width * 20)
            kill();
        super.update(elapsed);
    }
}