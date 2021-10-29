package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class SecretState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var lolText:FlxText;
	var lolText2:FlxText;
	var bg:FlxSprite;

	override public function create():Void
	{
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGGray'));
		add(bg);

		lolText = new FlxText(0, 0, FlxG.width - 100, 32);
		lolText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		lolText.text = "Alright, Update 9! Skipped over Hunger for now because of a few coloring problems. Also skipped over Diva while I'm B3-ifying all the characters used. Also added a few of Neonight and Vitor0502's covers.
		For Neonight's covers, there is an option to toggle stage switching so just head to the options for that.
		 Oh and I err.. removed some more stuff that will be ported to the Senpai and Tankman Mod coming soon! So yeah mostly songs that relate to that group. Hope you enjoy!";
		lolText.borderColor = FlxColor.BLACK;
		lolText.borderSize = 3;
		lolText.borderStyle = FlxTextBorderStyle.OUTLINE;
		lolText.screenCenter();
		add(lolText);

		lolText2 = new FlxText(0, 200, FlxG.width, 48);
		lolText2.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.WHITE, CENTER);
		lolText2.text = '\n \n \n \n \n \n \n \n \nPress Enter to continue.';
		lolText2.borderColor = FlxColor.BLACK;
		lolText2.borderSize = 3;
		lolText2.borderStyle = FlxTextBorderStyle.OUTLINE;
		lolText2.screenCenter();
		lolText2.y += 50;
		add(lolText2);

		blackScreen = new FlxSprite(-100, -100).makeGraphic(Std.int(FlxG.width * 100), Std.int(FlxG.height * 100), FlxColor.BLACK);
		blackScreen.scrollFactor.set();
		add(blackScreen);

		new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				blackScreen.alpha -= 0.05;

					if (blackScreen.alpha > 0)
					{
						tmr.reset(0.03);
					}
			});

		new FlxTimer().start(0.5, function(tmr2:FlxTimer)
			{
				lolText2.alpha = 1;

					if (lolText2.alpha == 1)
					{
						new FlxTimer().start(0.5, function(tmr3:FlxTimer)
						{
							lolText2.alpha = 0;
			
								if (lolText2.alpha == 0)
								{
									tmr2.reset(0.5);
								}
						});
					}
			});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.switchState(new MainMenuState());
		}
	}

	override function beatHit()
	{
		super.beatHit();
	}
}
