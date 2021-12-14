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
	var isSenpai:Bool = false;
	var isCorrupt:Bool = false;

	public function new(x:Float, y:Float)
	{
		var daCharacter = PlayState.boyfriend.curCharacter;
		var daBf:String = '';

		isCorrupt = false;
		isSenpai = false;

		switch (daCharacter)
		{
			case 'bf-pixel' | 'bf-pixeld4' | 'bf-pixeld4BSide':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'bf-tankman-pixel' | 'bf-pico-pixel' | 'bf-rico-pixel' | 'bf-tom-pixel' | 'bf-sonic-pixel' | 'bf-gf-pixel' | 'bf-wright-pixel' | 'bf-sans-pixel':
				stageSuffix = '-pixel';
				daBf = daCharacter + '-dead';
			case 'bf-aloe' | 'bf-aloe-confused' | 'bf-aloe-car' | 'bf1':	
				daBf = 'bf-aloe';
			case 'bf-aloe-corrupt':
				daBf = daCharacter;
				isCorrupt = true;
			case 'bf-nene' | 'bf-nene-scream':
				daBf = 'bf-nene';
			case 'bf-pixel-neon':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'bf-gf' | 'bf-gf-demon':	
				daBf = 'bf-gf';	
			case 'bf-senpai-pixel' | 'bf-senpai-angry-pixel':
				stageSuffix = '-senpai';
				daBf = 'bf-senpai-pixel-dead';
				isSenpai = true;
			case 'bf-senpai-tankman':
				stageSuffix = '-senpaitankman';
				daBf = 'bf-senpai-tankman-pixel-dead';
				isSenpai = true;
			default:	
				if (PlayState.boyfriend.animOffsets.exists('firstDeath'))
					daBf = daCharacter;
				else
					daBf = 'bf';	
		}

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'epiphany':
				stageSuffix = '-bigmonika';
				daBf = 'bf-bigmonika-dead';
		}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		add(bf);

		if (isSenpai)
			camFollow = new FlxObject(bf.getMidpoint().x - 300, bf.getMidpoint().y - 500, 1, 1);
		else
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

			if (PlayState.upScrollEvent || PlayState.downScrollEvent)
			{
				FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
				PlayState.upScrollEvent = false;
				PlayState.downScrollEvent = false;
			}

			if (PlayState.isPixel)
			{
				PlayState.isPixel = false;
			}

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else if (PlayState.isBETADCIU)
				if (PlayState.storyDifficulty == 5)
					FlxG.switchState(new GuestBETADCIUState());
				else
					FlxG.switchState(new BETADCIUState());
			else if (PlayState.isBonus)
				FlxG.switchState(new BonusSongsState());
			else if (PlayState.isNeonight)
				FlxG.switchState(new NeonightState());
			else if (PlayState.isVitor)
				FlxG.switchState(new VitorState());
			else
				FlxG.switchState(new FreeplayState());
			PlayState.loadRep = false;
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished && !isCorrupt)
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
			if (PlayState.upScrollEvent || PlayState.downScrollEvent)
			{
				FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
				PlayState.upScrollEvent = false;
				PlayState.downScrollEvent = false;
			}

			if (PlayState.isPixel)
			{
				PlayState.isPixel = false;
			}
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
