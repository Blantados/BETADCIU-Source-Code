package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";

	public function new(x:Float, y:Float)
	{
		var daCharacter = PlayState.boyfriend.curCharacter;
		var daBf:String = '';
		switch (daCharacter)
		{
			case 'bf-pixel' | 'bf-pixeld4' | 'bf-pixeld4BSide':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'bf-tankman-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-tankman-pixel-dead';
			case 'bf-pico-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-pico-pixel-dead';
			case 'bf-sonic-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-sonic-pixel-dead';
			case 'bf-tom-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-tom-pixel-dead';
			case 'bf-rico-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-rico-pixel-dead';
			case 'bf-gf-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-gf-pixel-dead';
			case 'bf-wright-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-wright-pixel-dead';
			case 'bf-sans-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-sans-pixel-dead';
			case 'bf1':	
				daBf = 'bf1';
			case 'bf2':	
				daBf = 'bf2';
			case 'bf3':	
				daBf = 'bf3';
			case 'bf4':	
				daBf = 'bf4';
			case 'bf5':	
				daBf = 'bf5';
			case 'bf-aloe':	
				daBf = 'bf-aloe';
			case 'bf-gf' | 'bf-gf-demon':	
				daBf = 'bf-gf';	
			default:	
				daBf = 'bf';
		}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else if (PlayState.isBETADCIU)
				FlxG.switchState(new BETADCIUState());
			else if (PlayState.isBonus)
				FlxG.switchState(new BonusSongsState());
			else
				FlxG.switchState(new FreeplayState());
			PlayState.loadRep = false;
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
