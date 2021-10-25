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

class GoFindTheSecretState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var lolText:FlxText;
	var lolText2:FlxText;
	var sonicBG:FlxSprite;

	override public function create():Void
	{
		FlxG.sound.playMusic(Paths.music('nexus_bf'));

		sonicBG = new FlxSprite(-100, -100).loadGraphic(Paths.image('exe/sonicBG'));
		sonicBG.setGraphicSize(Std.int(sonicBG.width * 1));
		add(sonicBG);

		lolText = new FlxText(0, 0, FlxG.width, 48);
		lolText.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.WHITE, CENTER);
		lolText.text = 'You are here because you tried to access one'
		+ '\n of the hidden songs without first finding the hidden menu! Go find the menu if you wanna play these songs!';
		lolText.borderColor = FlxColor.BLACK;
		lolText.borderSize = 4;
		lolText.borderStyle = FlxTextBorderStyle.OUTLINE;
		lolText.screenCenter();
		add(lolText);

		lolText2 = new FlxText(0, 200, FlxG.width, 32);
		lolText2.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		lolText2.text = '\n \n \n \n \n \n \n \n \nPress Enter to go back to the Main Menu.';
		lolText2.borderColor = FlxColor.BLACK;
		lolText2.borderSize = 3;
		lolText2.borderStyle = FlxTextBorderStyle.OUTLINE;
		lolText2.screenCenter();
		add(lolText2);

		blackScreen = new FlxSprite(-100, -100).makeGraphic(Std.int(FlxG.width * 100), Std.int(FlxG.height * 100), FlxColor.BLACK);
		blackScreen.scrollFactor.set();
		add(blackScreen);

		new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				blackScreen.alpha -= 0.05;

					if (blackScreen.alpha > 0)
					{
						tmr.reset(0.03);
					}
			});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.sound.music.stop();
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			FlxG.switchState(new MainMenuState());
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if(curBeat % 2 == 1)
		{
			lolText2.alpha = 0;
		}
		else if(curBeat % 2 == 2)
		{
			lolText2.alpha = 1;
		}
	}
}
