package;

import GroovinClasses.ModWeekData;
import GroovinShaders.PlaneRaymarcher;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.filters.ShaderFilter;
import openfl.utils.Function;

class BRStageEvent
{
	public var callback:Function;
	public var time:Float;
	public var dirty:Bool;

	public function new(callback:Function, time:Float)
	{
		this.callback = callback;
		this.time = time;
	}
}

class BopeeboRumbleModInstance
{
	public var vinceKaichan:FlxSprite;
	public var kawaiSprite:FlxSprite;
	public var me:FlxSprite;
	public var ps:PlayState;
	public var heyEvents:List<BRStageEvent>;
	public var camFake:FlxCamera;
	public var camArrows:FlxCamera;
	public var camSus:FlxCamera;
	public var bounceCam:Bool;
	public var tempSwagCounter:Int = 0;
	public var wobble:Float = 0;
	public var spin:Float = 1;
	public var staticArrowWave:Float = 0;
	public var spinAmp:Float = 1;
	public var spinOff:Float = 1;
	public var doSpin:Bool = false;
	public var staticArrows:Array<FlxSprite> = new Array<FlxSprite>();
	public var susWiggleEffect:WiggleEffect;
	public var planeRaymarcher:PlaneRaymarcher;

	public function new() {}
}

class BopeeboRumbleMod extends Mod
{
	public function new() {}

	var i:BopeeboRumbleModInstance;

	function StageName():String
	{
		return PlayState.curStage;
	}

	override function ShouldRun():Bool
	{
		if (Type.getClass(FlxG.state) == PlayState)
		{
			return PlayState.curMod == this && PlayState.isModdedStage;
		}
		return false;
	}

	function AddEvent(callback:Function, time:Float)
	{
		i.heyEvents.add(new BRStageEvent(callback, time * 1000));
	}

	function AddHey(time:Float)
	{
		AddEvent((state:PlayState) ->
		{
			trace("HEY");
			state.boyfriend.playAnim('hey', true);
		}, time + 0.02);
		// 20 ms ahead to go after idle play
	}

	function AddHeys()
	{
		AddHey(9.12);
		AddHey(16.8);
		AddHey(32.16);
		AddHey(39.84);
		AddHey(47.52);
		AddHey(93.6);
		AddHey(93.84);
	}

	public function DebugModCall(s:String, args:Array<Dynamic>)
	{
		switch (s)
		{
			case "RefreshEvents":
				for (event in i.heyEvents)
				{
					if (event.time > args[0] && event.dirty)
					{
						Conductor.songPosition = args[0];
						i.ps.vocals.time = Conductor.songPosition;
						event.dirty = false;
						trace(event, args[0]);
					}
				}
		}
	}

	override function GetName():String
	{
		return Type.getClassName(Type.getClass(this));
	}

	function Credits()
	{
		var state = i.ps;
		var origVisibility:Bool;
		AddEvent(() ->
		{
			origVisibility = FlxG.mouse.visible;
			FlxG.mouse.visible = true;
			i.vinceKaichan = new FlxSprite().loadGraphic('modweeks:mod_assets/weeks/${GetName()}/bopeebo rumble/images/vincekaichan.png');
			i.kawaiSprite = new FlxSprite().loadGraphic('modweeks:mod_assets/weeks/${GetName()}/bopeebo rumble/images/kawaisprite.png');
			i.me = new FlxSprite().loadGraphic('modweeks:mod_assets/weeks/${GetName()}/bopeebo rumble/images/me.png');
			i.vinceKaichan.updateHitbox();
			i.kawaiSprite.updateHitbox();
			i.me.updateHitbox();
			i.vinceKaichan.cameras = [state.camHUD];
			i.kawaiSprite.cameras = [state.camHUD];
			i.me.cameras = [state.camHUD];
			i.vinceKaichan.setPosition(-i.vinceKaichan.width, 405);
			i.kawaiSprite.setPosition(FlxG.width, 497);
			i.me.setPosition(-i.me.width, 497);
			state.add(i.vinceKaichan);
			state.add(i.kawaiSprite);
			state.add(i.me);
			FlxTween.tween(i.vinceKaichan, {x: 0}, 0.5, {ease: FlxEase.sineOut});
			FlxTween.tween(i.kawaiSprite, {x: FlxG.width - i.kawaiSprite.width}, 0.5, {ease: FlxEase.sineOut});
			FlxTween.tween(i.me, {x: 0}, 0.5, {ease: FlxEase.sineOut});
		}, -2);
		AddEvent(() ->
		{
			FlxG.mouse.visible = origVisibility;
			FlxTween.tween(i.vinceKaichan, {x: -i.vinceKaichan.width}, 0.5, {ease: FlxEase.sineInOut});
			FlxTween.tween(i.me, {x: -i.me.width}, 0.5, {ease: FlxEase.sineInOut});
			FlxTween.tween(i.kawaiSprite, {x: FlxG.width}, 0.5, {
				ease: FlxEase.sineInOut,
				onComplete: (t) ->
				{
					state.remove(i.vinceKaichan);
					state.remove(i.kawaiSprite);
					state.remove(i.me);
				}
			});
		}, 1.82);
	}

	override function OverrideCountdown(state:PlayState):Bool
	{
		state.dad.dance();
		state.gf.dance();
		state.boyfriend.playAnim('idle');

		var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
		introAssets.set('default', ['ready', "set", "go"]);

		switch (i.tempSwagCounter)
		{
			case 0:
				FlxG.sound.play(Paths.sound('intro3'), 0.6);
			case 1:
				var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image("ready"));
				ready.scrollFactor.set();
				ready.updateHitbox();
				ready.screenCenter();
				ready.cameras = [i.camArrows];
				state.add(ready);
				FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
					ease: FlxEase.cubeInOut,
					onComplete: function(twn:FlxTween)
					{
						ready.destroy();
					}
				});
				FlxG.sound.play(Paths.sound('intro2'), 0.6);
			case 2:
				var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image("set"));
				set.scrollFactor.set();
				set.updateHitbox();
				set.screenCenter();
				set.cameras = [i.camArrows];
				state.add(set);
				FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
					ease: FlxEase.cubeInOut,
					onComplete: function(twn:FlxTween)
					{
						set.destroy();
					}
				});
				FlxG.sound.play(Paths.sound('intro1'), 0.6);
			case 3:
				var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image("go"));
				go.scrollFactor.set();
				go.updateHitbox();
				go.screenCenter();
				go.cameras = [i.camArrows];
				state.add(go);
				FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
					ease: FlxEase.cubeInOut,
					onComplete: function(twn:FlxTween)
					{
						go.destroy();
					}
				});
				FlxG.sound.play(Paths.sound('introGo'), 0.6);
			case 4:
		}

		i.tempSwagCounter += 1;
		return true;
	}

	function ScreenRotates()
	{
		AddEvent(() ->
		{
			FlxTween.tween(i.camFake, {angle: -30}, 0.5, {ease: FlxEase.sineInOut});
			FlxTween.tween(i.camArrows, {angle: 30}, 0.5, {ease: FlxEase.sineInOut});
		}, 78.2);
		AddEvent(() ->
		{
			FlxTween.tween(i.ps.camera, {zoom: 2}, 0.1, {ease: FlxEase.sineOut});
			FlxTween.tween(i.camFake, {angle: 360 * 4}, 3.7, {ease: FlxEase.sineOut});
			FlxTween.tween(i.camArrows, {angle: -360 * 4}, 3.7, {
				ease: FlxEase.sineOut,
				onComplete: (t) ->
				{
					i.camFake.angle = 0;
					i.camArrows.angle = 0;
				}
			});
		}, 78.72);
		AddEvent(() ->
		{
			FlxTween.tween(i.ps.camera, {zoom: 1}, 3, {
				ease: FlxEase.sineInOut
			});
		}, 78.92);
	}

	function TheFunny()
	{
		var funny;
	}

	function Wobbles()
	{
		for (e in 0...32)
		{
			var negate = (e % 2 == 0) ? 1 : -1;
			var start = 33.12;
			var sync = -0.03;
			AddEvent(() ->
			{
				FlxTween.tween(i, {wobble: 250 * negate}, 0.05, {ease: FlxEase.circIn});
			}, start + sync + 0.96 * e);
			AddEvent(() ->
			{
				FlxTween.tween(i, {wobble: 0}, 0.8, {ease: FlxEase.circOut});
			}, start + sync + 0.06 + 0.96 * e);
		}
		for (e in 0...32)
		{
			var negate = (e % 2 == 0) ? 1 : -1;
			var start = 63.84;
			var sync = -0.03;
			AddEvent(() ->
			{
				FlxTween.tween(i, {wobble: 250 * negate}, 0.05, {ease: FlxEase.circIn});
			}, start + sync + 0.96 * e);
			AddEvent(() ->
			{
				FlxTween.tween(i, {wobble: 0}, 0.8, {ease: FlxEase.circOut});
			}, start + sync + 0.06 + 0.96 * e);
		}
	}

	function TwistsAndShifts()
	{
		function TweenPlayfield(x:Float, t:Float)
		{
			AddEvent(() ->
			{
				FlxTween.tween(i.camArrows, {x: x}, 0.2, {ease: FlxEase.circOut});
			}, t);
		}
		for (b in 0...2)
		{
			for (a in 0...2)
			{
				var nextMeasure = a * 3.84 + b * 30.72;
				TweenPlayfield(-100, 11.76 + nextMeasure);
				TweenPlayfield(100, 12.00 + nextMeasure);
				TweenPlayfield(-100, 12.24 + nextMeasure);
				TweenPlayfield(0, 12.48 + nextMeasure);
			}
		}
		for (b in 0...2)
		{
			for (a in 0...2)
			{
				var nextMeasure = a * 7.68 + b * 30.72;
				AddEvent(() ->
				{
					FlxTween.tween(i, {spin: 0.8}, 0.2, {ease: FlxEase.circOut});
					FlxTween.tween(i.camFake, {angle: -10}, 0.2, {ease: FlxEase.circOut});
					FlxTween.tween(i.camArrows, {angle: 10}, 0.2, {ease: FlxEase.circOut});
				}, 20.40 + nextMeasure);
				AddEvent(() ->
				{
					FlxTween.tween(i, {spin: 1.1}, 0.2, {ease: FlxEase.circInOut});
					FlxTween.tween(i.camFake, {angle: 10}, 0.2, {ease: FlxEase.circInOut});
					FlxTween.tween(i.camArrows, {angle: -10}, 0.2, {ease: FlxEase.circInOut});
				}, 20.64 + nextMeasure);
				AddEvent(() ->
				{
					FlxTween.tween(i, {spin: 0.8}, 0.2, {ease: FlxEase.circInOut});
					FlxTween.tween(i.camFake, {angle: -10}, 0.2, {ease: FlxEase.circInOut});
					FlxTween.tween(i.camArrows, {angle: 10}, 0.2, {ease: FlxEase.circInOut});
				}, 20.88 + nextMeasure);
				AddEvent(() ->
				{
					FlxTween.tween(i, {spin: 1}, 0.2, {ease: FlxEase.circOut});
					FlxTween.tween(i.camFake, {angle: 0}, 0.2, {ease: FlxEase.circOut});
					FlxTween.tween(i.camArrows, {angle: 0}, 0.2, {ease: FlxEase.circOut});
				}, 21.12 + nextMeasure);
			}
		}
	}

	function IntroPerc()
	{
		function TweenReceptors(invFreq:Float, amp:Float, t:Float)
		{
			AddEvent(() ->
			{
				for (staticArrow in i.staticArrows)
				{
					staticArrow.y = i.ps.strumLine.y + Math.sin(staticArrow.x / invFreq) * amp;
					FlxTween.tween(staticArrow, {y: i.ps.strumLine.y}, 0.2, {ease: FlxEase.circOut});
				}
			}, t);
		}
		function SetReceptors(invFreq:Float, off:Float, amp:Float, t:Float)
		{
			AddEvent(() ->
			{
				for (staticArrow in i.staticArrows)
				{
					staticArrow.y = i.ps.strumLine.y + Math.sin(staticArrow.x / invFreq + off) * amp;
				}
			}, t);
		}
		TweenReceptors(100, 50, 0);
		TweenReceptors(100, 50, .36);
		TweenReceptors(100, 50, .72);
		SetReceptors(80, 1, 30, .96);
		SetReceptors(60, 2, -30, 1.08);
		SetReceptors(50, 3, 30, 1.2);
		SetReceptors(40, 4, -30, 1.44);

		for (z in 0...4)
		{
			AddEvent(() ->
			{
				var alt = z % 2 == 0 ? 1 : -1;
				for (staticArrow in i.staticArrows)
				{
					staticArrow.y = i.ps.strumLine.y + Math.sin(staticArrow.x / 50 + 5 + z) * 40 * alt;
				}
			}, 1.68 + z * 0.06);
		}
		AddEvent(() ->
		{
			for (staticArrow in i.staticArrows)
			{
				FlxTween.tween(staticArrow, {y: i.ps.strumLine.y}, 0.2, {ease: FlxEase.circOut});
			}
		}, 1.92);
	}

	function AddModEvents()
	{
		TheFunny();
		Credits();
		IntroPerc();
		AddEvent(() ->
		{
			i.bounceCam = true;
		}, 1.92);
		TwistsAndShifts();
		Wobbles();
		AddEvent(() ->
		{
			i.spinAmp = 0;
			FlxTween.tween(i, {spinAmp: 1}, 0.5, {ease: FlxEase.sineInOut});
			FlxTween.tween(i, {spinOff: 0}, 0.5, {ease: FlxEase.sineInOut});
			i.doSpin = true;
		}, 63.36);
		AddEvent(() ->
		{
			FlxTween.tween(i, {spinAmp: 0}, 0.5, {ease: FlxEase.sineInOut});
			FlxTween.tween(i, {spinOff: 1}, 0.5, {ease: FlxEase.sineInOut});
		}, 72.72);
		AddEvent(() ->
		{
			i.doSpin = false;
		}, 73.22);
		ScreenRotates();
		ChorusTwists();
	}

	function ChorusTwists()
	{
		for (x in 0...8)
		{
			var off = 1.92 * x;
			AddEvent(() ->
			{
				i.staticArrowWave = 90;
				i.camFake.angle = -10;
				i.camArrows.angle = 10;
				FlxTween.tween(i, {staticArrowWave: 0}, 0.7, {ease: FlxEase.circOut});
				FlxTween.tween(i.camFake, {angle: 0}, 0.5, {ease: FlxEase.circOut});
				FlxTween.tween(i.camArrows, {angle: 0}, 0.5, {ease: FlxEase.circOut});
			}, 63.36 + off);
			AddEvent(() ->
			{
				i.staticArrowWave = 90;
				i.camFake.angle = 10;
				i.camArrows.angle = -10;
				FlxTween.tween(i, {staticArrowWave: 0}, 0.3, {ease: FlxEase.circOut});
				FlxTween.tween(i.camFake, {angle: 0}, 0.5, {ease: FlxEase.circOut});
				FlxTween.tween(i.camArrows, {angle: 0}, 0.5, {ease: FlxEase.circOut});
			}, 64.56 + off);
		}
		for (x in 0...8)
		{
			var off = 1.92 * x;
			AddEvent(() ->
			{
				i.staticArrowWave = 90;
				i.camFake.angle = -10;
				i.camArrows.angle = 10;
				FlxTween.tween(i, {staticArrowWave: 0}, 0.7, {ease: FlxEase.circOut});
				FlxTween.tween(i.camFake, {angle: 0}, 0.5, {ease: FlxEase.circOut});
				FlxTween.tween(i.camArrows, {angle: 0}, 0.5, {ease: FlxEase.circOut});
			}, 82.56 + off);
			AddEvent(() ->
			{
				i.staticArrowWave = 90;
				i.camFake.angle = 10;
				i.camArrows.angle = -10;
				FlxTween.tween(i, {staticArrowWave: 0}, 0.3, {ease: FlxEase.circOut});
				FlxTween.tween(i.camFake, {angle: 0}, 0.5, {ease: FlxEase.circOut});
				FlxTween.tween(i.camArrows, {angle: 0}, 0.5, {ease: FlxEase.circOut});
			}, 83.76 + off);
		}
	}

	function UpdateEvents(elapsed:Float, list:List<BRStageEvent>)
	{
		for (event in list)
		{
			if (Conductor.songPosition >= event.time && !event.dirty)
			{
				event.callback(i.ps);
				event.dirty = true;
			}
		}
	}

	function UpdateButton(elapsed:Float)
	{
		if (FlxG.mouse.justPressed && i.me != null)
		{
			if (FlxG.mouse.overlaps(i.vinceKaichan))
			{
				FlxG.openURL('https://soundcloud.com/vincmg');
			}
			else if (FlxG.mouse.overlaps(i.kawaiSprite))
			{
				FlxG.openURL('https://open.spotify.com/artist/19nnKeOt6Vo1g0ijPcFxdu');
			}
			else if (FlxG.mouse.overlaps(i.me))
			{
				FlxG.openURL('https://www.youtube.com/channel/UCez-Erpr0oqmC71vnDrM9yA');
			}
		}
	}

	override function Update(elapsed:Float)
	{
		UpdateEvents(elapsed, i.heyEvents);
		UpdateCamera(elapsed);
		UpdateStaticArrows(elapsed);
	}

	function UpdateStaticArrows(elapsed:Float)
	{
		if (i.doSpin)
		{
			i.spin = Math.sin(Conductor.songPosition / Conductor.crochet * Math.PI) * i.spinAmp + i.spinOff;
		}
		var staticNoteNum = 0;
		i.ps.strumLineNotes.forEach((staticNote) ->
		{
			// For convenience
			i.staticArrows[staticNoteNum] = staticNote;

			var player:Int = staticNoteNum >= 4 ? 1 : 0;
			staticNote.x = staticNoteNum % 4 * Note.swagWidth + FlxG.width / 2 * player + 80;
			if (i.staticArrowWave != 0)
			{
				staticNote.y = i.ps.strumLine.y
					+ Math.sin(Conductor.songPosition / Conductor.crochet + staticNote.x) * i.staticArrowWave
					+ i.staticArrowWave * 0.5;
			}
			var center = FlxG.width / 2 - Note.swagWidth / 2;
			var distFromCenter = staticNote.x - center;
			staticNote.x = center + distFromCenter * i.spin;
			staticNoteNum++;
		});
	}

	override function ModWeekData():Array<ModWeekData>
	{
		return [
			new ModWeekData(["Bopeebo Rumble"], "clearly you've never played NotITG", ["dad", "bf", "gf"])
		];
	}

	override function GetDisplayName():String
	{
		return "Bopeebo Rumble (Demo) by 4mbr0s3 2";
	}

	// After camera is tracked to camFollow
	override function PreUI(state:PlayState)
	{
		i.camFake.targetOffset.set(-FlxG.width / 2, -FlxG.height / 2);
		i.camFake.follow(state.camFollow, LOCKON, 0.04);
		state.add(i.camFake);

		// After strumLine is defined
		i.susWiggleEffect = new WiggleEffect();
		i.susWiggleEffect.effectType = WiggleEffectType.DREAMY;
		i.susWiggleEffect.waveSpeed = 1;
		// Subtract 4 x note width phase shift cuz sine ain't 0 at strumLine for some reason??

		var downscrollNegator = ModHooks.mods.filter(e -> e.GetName() == "KadeDownscroll").length > 0;

		i.susWiggleEffect.shader.uTime.value = [(-state.strumLine.y - Note.swagWidth * 0.5) / FlxG.height];
		if (downscrollNegator)
		{
			i.susWiggleEffect.shader.uTime.value = [(-state.strumLine.y - Note.swagWidth * 10.3) / FlxG.height];
		}
		i.susWiggleEffect.waveFrequency = Math.PI * 3;

		i.planeRaymarcher = new PlaneRaymarcher();
		i.camArrows.setFilters([new ShaderFilter(i.planeRaymarcher.shader),]);
		i.camSus.setFilters([
			new ShaderFilter(i.susWiggleEffect.shader),
			new ShaderFilter(i.planeRaymarcher.shader)
		]);
	}

	function UpdateCamera(elapsed:Float)
	{
		i.ps.camGame.angle = i.camFake.angle;
		if (i.bounceCam)
		{
			i.ps.camGame.scroll.set(i.camFake.scroll.x, i.camFake.scroll.y + -Math.abs(Math.sin(Conductor.songPosition / Conductor.crochet * Math.PI) * 30));
			i.camArrows.setPosition(i.camArrows.x, Math.abs(Math.sin(Conductor.songPosition / Conductor.crochet * Math.PI) * 50));
		}
		i.camSus.scroll = i.camArrows.scroll;
		i.camSus.setPosition(i.camArrows.x, i.camArrows.y);
		i.camSus.angle = i.camArrows.angle;

		i.susWiggleEffect.waveAmplitude = i.wobble / FlxG.width;

		i.planeRaymarcher.update(elapsed);
	}

	override function PostNotePosition(state:PlayState, strumLine:FlxSprite, daNote:Note, SONG:SwagSong)
	{
		// daNote.y = (state.strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
		var columnX = 50
			+ daNote.noteData * Note.swagWidth
			+ (daNote.mustPress ? (FlxG.width / 2) : 0)
			+ (daNote.isSustainNote ? Note.swagWidth / 2 - daNote.width / 2 : 0);

		var firstFourDad = 0;
		if (!daNote.mustPress)
		{
			state.strumLineNotes.forEach((staticNote) ->
			{
				firstFourDad++;
				if (firstFourDad > 4)
					return;
				if (daNote.noteData == staticNote.ID)
				{
					columnX = staticNote.x;
					daNote.y += staticNote.y - state.strumLine.y;
					return;
				}
			});
		}
		else
		{
			state.playerStrums.forEach((staticNote) ->
			{
				if (daNote.mustPress && daNote.noteData == staticNote.ID)
				{
					columnX = staticNote.x;
					daNote.y += staticNote.y - state.strumLine.y;
					return;
				}
			});
		}
		columnX += (daNote.isSustainNote ? Note.swagWidth / 2 - daNote.width / 2 : 0);
		var time = (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)) / FlxG.height;
		daNote.x = columnX;
		if (!daNote.isSustainNote)
		{
			daNote.x = columnX + Math.sin(time * Math.PI * 3) * i.wobble;
		}
	}

	override function Initialize()
	{
		trace("Successfully initialized Bopeebo Rumble mod! Switching to Freeplay...");
		var fp = new BonusSongsState();
		// new FlxTimer().start(1, function(tmr:FlxTimer)
		// {
		// 	fp.curSelected = fp.songs.length - 1;
		// 	FlxG.switchState(fp);
		// });
	}

	override function PreCameras(state:PlayState)
	{
		i = new BopeeboRumbleModInstance();

		i.camFake = new FlxCamera();

		i.ps = state;
		i.heyEvents = new List<BRStageEvent>();

		i.camSus = new FlxCamera();
		i.camSus.bgColor.alpha = 0;

		i.camArrows = new FlxCamera();
		i.camArrows.bgColor.alpha = 0;

		AddHeys();
		AddModEvents();
	}

	override function PostUI(state:PlayState)
	{
		state.strumLineNotes.cameras = [i.camArrows];
	}

	override function AfterCameras(camGame:FlxCamera, camHUD:FlxCamera)
	{
		camGame.width = FlxG.width * 2;
		camGame.height = FlxG.height * 2;
		camGame.setPosition(-FlxG.width / 2, -FlxG.height / 2);
		FlxG.cameras.add(i.camSus);
		FlxG.cameras.add(i.camArrows);
	}

	override function OnSpawnNote(state:PlayState, note:Note)
	{
		if (note.isSustainNote)
		{
			note.cameras = [i.camSus];
		}
		else
		{
			note.cameras = [i.camArrows];
		}
	}

	override function SetupStage(stageName:String)
	{
		i.ps.transIn = null;
		i.ps.transOut = null;
		AddBackground();
	}

	function AddBackground()
	{
		i.ps.defaultCamZoom = 0.9;
		PlayState.curStage = 'stage';
		var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.9, 0.9);
		bg.active = false;
		i.ps.add(bg);

		var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		stageFront.antialiasing = true;
		stageFront.scrollFactor.set(0.9, 0.9);
		stageFront.active = false;
		i.ps.add(stageFront);

		var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
		stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		stageCurtains.updateHitbox();
		stageCurtains.antialiasing = true;
		stageCurtains.scrollFactor.set(1.3, 1.3);
		stageCurtains.active = false;

		i.ps.add(stageCurtains);
	}

	override function AddToBonus(addWeek:(Array<String>, Int, Array<String>) -> Void, weekNum:Int)
	{
		addWeek(["Bopeebo Rumble"], weekNum, ['dad']);
	}
}