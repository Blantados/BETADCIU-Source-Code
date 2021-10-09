package;

import webm.WebmPlayer;
import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;

import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import flixel.addons.display.FlxBackdrop;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

#if sys
import lime.media.AudioBuffer;
import flash.media.Sound;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var camFollowIsOn:Bool = true;
	public static var defaultCamFollow:Bool = true;
	public static var isBETADCIU:Bool = false;
	public static var isBonus:Bool = false;
	public static var showCutscene:Bool = false;
	public static var downScrollEvent:Bool = false;
	public static var isPixel:Bool = false;
	public static var upScrollEvent:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	var camMovement:Float = 0.09;
	private var shakeCam:Bool = false;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	//weird icon shenanigans
	var p1Icon:String;
	var p2Icon:String;

	var evilTrail:FlxTrail;

	var shootStepsBallistic:Array<Int> = [284, 368, 384, 422, 430, 454, 462, 542, 656, 686, 750, 846, 878, 894, 910, 926, 976, 977, 1024, 1025, 1056, 1120, 1198, 1230, 1262, 1294, 1574, 1606, 1696, 1712, 1760, 1776, 1832, 1848, 1906, 1952, 2018, 2036, 2078];
	var bfTransformSteps:Array<Int> = [368, 369, 371, 372, 374, 375, 378, 379, 382, 383, 624, 625, 628, 629, 632, 633, 636, 637, 752, 753, 756, 757, 760, 761, 764, 765, 1008, 1009, 1012, 1013, 1016, 1017, 1020, 1021, 1024];
	var ughStepsDad:Array<Int> = [60, 444, 524, 540, 541, 572, 574, 575, 590, 591, 636, 1036, 1038, 1039];
	var ughStepsBF:Array<Int> = [124, 700, 1100];

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	public var minusHealth:Bool = false;
	public var tabiZoom:Bool = false;

	public var tordCam:Array<FlxPoint> = [new FlxPoint(391.2,-1094.15),new FlxPoint(290.9,-1094.15),new FlxPoint(450.9,-1094.15),new FlxPoint(374.9,-1174.15),new FlxPoint(570.9,-974.15)];

	public var cjCloneLinesSing:Array<String> = ["SUFFER","INCORRECT", "INCOMPLETE", "INSUFFICIENT", "INVALID", "CORRECTION", "MISTAKE", "REDUCE", "ERROR", "FAULTY", "IMPROBABLE", "IMPLAUSIBLE", "MISJUDGED", "ABUSE"];

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;

	var walked:Bool = false;
	public static var picoCutscene:Bool = false;
	var walkingRight:Bool = true;
	var stopWalkTimer:Int = 0;
	var mini:FlxSprite;
	var mordecai:FlxSprite;

	//tankman shit
	var tankRolling:FlxSprite;
	var tankX:Int = 400;
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankAngle:Float = FlxG.random.float(-90, 45);

	//sunday shit
	var aaa:FlxSprite;
	var glowShit:FlxSprite = new FlxSprite(-255.15,186.55);
	var garage:FlxSprite;
	var speakers:FlxSprite;
	public var carolEnter:FlxSprite;
	public var fret:FlxSprite;
	public var ending:FlxSprite;

	//shit
	var modCrowdFront:FlxSprite;
	var modCrowd:FlxSprite;
	var modCrowdBig:FlxSprite;

	//sus
	var flashSprite:FlxSprite = new FlxSprite(-100, -100).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), 0xFFb30000);
	var _cb = 0;

	var wind:FlxSound = new FlxSound().loadEmbedded(Paths.sound('windLmao', 'shared'),true);
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	private var cy_spk1:FlxSprite;
	private var cy_spk2:FlxSprite;

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	//dialogue shenanigans
	var doof:DialogueBox;
	var doof2:DialogueBox;
	var doof3:DialogueBox;
	var doof4:DialogueBox;

	//dumb hands cutscene stuff
	public static var blantadBG:Character;
	var rotRateBl:Float;
	var bl_r:Float = 300;
	var upperSky:FlxSprite;
	var upperSky2:FlxSprite;
	var bgLimo:FlxSprite;
	var bgLimoOhNo:FlxSprite;
	var cloudGroup:FlxTypedGroup<Cloud>;
	var cloudGroup2:FlxTypedGroup<Cloud2>;
	var cloudTimer:Float = 0;
	var cloudTimer2:Float = 0;

	var moreDark:FlxSprite;
	var blantadBG2:FlxSprite;

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	var tstatic:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('tricky/TrickyStatic', 'shared'), true, 320, 180);

	var tStaticSound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("staticSound","preload"));

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	public static var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var iconBG:HealthIcon;
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];
	public var extra2:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];
	public var extra3:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	// all the damn sprites
	var halloweenBG:FlxSprite;
	var normbg:FlxSprite;
	var oldspace:FlxSprite;
	var space:FlxBackdrop;
	var whiteflash:FlxSprite;
	var blackScreen:FlxSprite;
	var justMonika:FlxSprite;
	var monikaBG:FlxSprite;
	var monikaStillBG:FlxSprite;
	var wireBG:FlxSprite;
	var glitcherBG:FlxSprite;
	var glitcherFront:FlxSprite;
	var glitchBG:FlxSprite;
	var manifestBG:FlxSprite;
	var manifestFloor:FlxSprite;
	var isHalloween:Bool = false;
	var scope:FlxSprite;
	var stageFront:FlxSprite;
	var stageFront2:FlxSprite;
	var bg2:FlxSprite;
	var bg:FlxSprite;
	var stageCurtains:FlxSprite;
	var babyArrow:FlxSprite;
	var daSign:FlxSprite;
	var headlight:FlxSprite;
	var fac_bg:FlxSprite;
	var manifestHole:FlxSprite;
	var tv:FlxSprite;
	var wBg:FlxSprite;
	var nwBg:FlxSprite;
	var wstageFront:FlxSprite;
	var zardyBackground:FlxSprite;

	public var dust:FlxSprite;
	public var car:FlxSprite;

	public var circ0:FlxSprite;
	public var circ1:FlxSprite;
	public var circ2:FlxSprite;
	public var circ1new:FlxSprite;

	//for gospel sarv floating
	var tween:FlxTween;
	var doingFloatShit:Bool = false;
	var doingBoyfriendFloatShit:Bool = false;
	var shouldFloat:Bool = false;

	var removedTrail:Bool = false;

	//for pom-pomeranian
	var bgcrowd:FlxSprite;
	var smallbgcrowd:FlxSprite;
	var bgcrowdjump:FlxSprite;
	var alya:FlxSprite;
	var anchor:FlxSprite;
	var tricky:FlxSprite;

	var curcol:FlxColor;
	var curcol2:FlxColor;
	var dadHealthBarColor:FlxColor;
	var bfHealthBarColor:FlxColor;
	
	var bgwire:FlxSprite;
	var citywire:FlxSprite;
	var lightwire:FlxSprite;
	var streetBehindwire:FlxSprite;
	var streetwire:FlxSprite;

	var bobmadshake:FlxSprite;
	var bobsound:FlxSound;

	var shut:FlxSound;
	var giggle:FlxSound;

	//Weeb shit
	var bgSky:FlxSprite;
	public static var bgSkyEvil:FlxSprite;
	var bgSchool:FlxSprite;
	var bgSchoolEvil:FlxSprite;
	var fgTrees:FlxSprite;
	var fgTreesEvil:FlxSprite;
	var bgStreet:FlxSprite;
	var bgStreetEvil:FlxSprite;
	var bgTrees:FlxSprite;
	var bgSkyUT:FlxSprite;
	var bgSchoolUT:FlxSprite;
	var bgStreetUT:FlxSprite;
	var bgSkyEdd:FlxSprite;
	var bgSchoolEdd:FlxSprite;
	var bgStreetEdd:FlxSprite;
	var bgTreesEdd:FlxSprite;
	var treeLeaves:FlxSprite;
	var treeLeavesEdd:FlxSprite;
	var bgSkyNeon:FlxSprite;
	var bgStreetNeon:FlxSprite;
	var bgSkyMario:FlxSprite;
	var bgSchoolMario:FlxSprite;
	var bgStreetMario:FlxSprite;
	var fgStreetMario:FlxSprite;
	var bgSkyBaldi:FlxSprite;
	var bgSchoolBaldi:FlxSprite;
	var bgStreetBaldi:FlxSprite;

	//Those character that dance in the bg
	var tank0:FlxSprite;
	var tank1:FlxSprite;
	var tank2:FlxSprite;
	var tank3:FlxSprite;
	var tank4:FlxSprite;
	var tank5:FlxSprite;
	var tankWatchtower:FlxSprite;
	var tordBG:FlxSprite;
	var bfPixelBG:FlxSprite;
	var gfCrazyBG:FlxSprite;
	var mattBG:FlxSprite;
	var tomBG:FlxSprite;
	var bfBG:FlxSprite;
	var monikaFinaleBG:FlxSprite;
	var zero16:FlxSprite;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyCityLightswire:FlxTypedGroup<FlxSprite>;
	var prologueLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var limoOhNo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	public static var grpLimoDancersHolo:FlxTypedGroup<BackgroundDancerHolo>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var momDadBG:FlxSprite;
	var softBFBG:FlxSprite;
	var tabiTrail:FlxTrail;
	var pillarbroke:FlxSprite;
	var altAnim:String = "";
	var bfAltAnim:String = "";

	var fc:Bool = true;
	var comboSpr:FlxSprite;

	var rock:FlxSprite;
	var dadrock:FlxSprite;
	var gf_rock:FlxSprite;
	var burst:FlxSprite;

	public static var isTakeover:Bool = false;

	//Those that need other files to work
	var bgGirls:BackgroundGirls;
	var bgGirls2:BackgroundGirlsSwitch;
	var bgGirlsUTMJ:BackgroundGirlsSwitch;
	var bgGirlsSFNAF:BackgroundGirlsSwitch;
	var bgGirlsBSAA:BackgroundGirlsSwitch;
	var bgGirlsEdd:BackgroundGirlsSwitch;
	var gfBG:GirlfriendBG;
	var gfBG2:GirlfriendBG;
	var amyPixelBG:GirlfriendBG;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	public static var campaignScore:Int = 0;

	public static var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;
	private var floatshit:Float = 0;

	var kCool:Bool = false;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// Replay shit
	private var saveNotes:Array<Float> = [];

	private var executeModchart = false;
	private var executePreload = false;
	private var bopeeboRumble = false;

	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }
	public function destroyObject(object:FlxBasic) { object.destroy(); }


	override public function create()
	{
		ModCharts.autoStrum = true;
		ModCharts.dadNotesVisible = true;
		ModCharts.bfNotesVisible = true;

		minusHealth = false;
		picoCutscene = false;

		var cover:FlxSprite = new FlxSprite(-180,755).loadGraphic(Paths.image('tricky/fourth/cover'));
		var hole:FlxSprite = new FlxSprite(50,530).loadGraphic(Paths.image('tricky/fourth/Spawnhole_Ground_BACK'));
		var converHole:FlxSprite = new FlxSprite(7,578).loadGraphic(Paths.image('tricky/fourth/Spawnhole_Ground_COVER'));

		isTakeover = (SONG.song.toLowerCase() == 'takeover');

		instance = this;

		FlxG.mouse.visible = false;
		
		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		resetSpookyText = true;

		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}
		
		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase  + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		if (isBETADCIU)
		{
			detailsText = SONG.song + "But Every Turn A Different Cover is Used";
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		var noteSplash0:NoteSplash = new NoteSplash();
		noteSplash0.setupNoteSplash(100, 100, 0);
		grpNoteSplashes.add(noteSplash0);

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial', 'tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		cjCloneLinesSing = CoolUtil.coolTextFile(Paths.txt('cjCloneSingStrings'));

		whiteflash = new FlxSprite(-100, -100).makeGraphic(Std.int(FlxG.width * 100), Std.int(FlxG.height * 100), FlxColor.WHITE);
		whiteflash.scrollFactor.set();

		blackScreen = new FlxSprite(-100, -100).makeGraphic(Std.int(FlxG.width * 100), Std.int(FlxG.height * 100), FlxColor.BLACK);
		blackScreen.scrollFactor.set();

		justMonika = new FlxSprite(-100, -100).loadGraphic(Paths.image('monika/justmonika'));
		justMonika.setGraphicSize(Std.int(justMonika.width * 1.26));
		justMonika.scrollFactor.set();
		justMonika.updateHitbox();
		justMonika.screenCenter();

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + FlxG.save.data.botplay);
	
		//dialogue shit
		switch (songLowercase)
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
			case 'whittyvssarv':
				dialogue = CoolUtil.coolTextFile(Paths.txt('whittyvssarv/whittyvssarvDialogue'));
			case 'gun-buddies':
				dialogue = CoolUtil.coolTextFile(Paths.txt('gun-buddies/gun-buddiesDialogue'));
			case 'battle':
				dialogue = CoolUtil.coolTextFile(Paths.txt('battle/battleDialogue'));
			case 'ballistic':
				dialogue = CoolUtil.coolTextFile(Paths.txt('ballistic/startDialogue'));
				extra2 = CoolUtil.coolTextFile(Paths.txt('ballistic/afterCutsceneDialogue'));	
				extra3 = CoolUtil.coolTextFile(Paths.txt('ballistic/endDialogue'));				
		}

		//defaults if no stage was found in chart
		var stageCheck:String = 'stage';
		
		if (SONG.stage == null) {
			switch(storyWeek)
			{
				case 2: stageCheck = 'halloween';
				case 3: stageCheck = 'philly';
				case 4: stageCheck = 'limo';
				case 5: if (songLowercase == 'winter-horrorland') {stageCheck = 'mallEvil';} else {stageCheck = 'mall';}
				case 6: if (songLowercase == 'thorns') {stageCheck = 'schoolEvil';} else {stageCheck = 'school';}
				case 7: stageCheck = 'tank';
				//i should check if its stage (but this is when none is found in chart anyway)
			}
		} else {stageCheck = SONG.stage;}

		switch(stageCheck)
		{
			case 'halloween':
			{
				curStage = "halloween";
				halloweenLevel = true;
				defaultCamZoom = 1.05;

				var hallowTex = Paths.getSparrowAtlas('halloween_bg', 'week2');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

				isHalloween = true;
			}

			case 'takiStage': 
			{
				curStage = 'takiStage';
				defaultCamZoom = 0.6;
				halloweenLevel = true;

				var bg:FlxSprite = new FlxSprite(-200, -100).loadGraphic(Paths.image('fever/week2bgtaki'));
				bg.antialiasing = true;
				add(bg);
			}

			case 'studio':
			{
				defaultCamZoom = 0.9;
				curStage = 'studio';

				var speakerScale:Float = 0.845;

				var bg_back:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('studio/studio_evenfurtherback'));
				bg_back.setGraphicSize(Std.int(bg_back.width * 0.845));
				bg_back.screenCenter();
				bg_back.antialiasing = true;
				bg_back.scrollFactor.set(0.85, 0.85);
				bg_back.active = false;
				bg_back.x += 32;
				add(bg_back);

				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('studio/studio_back'));
				bg.setGraphicSize(Std.int(bg.width * 0.845));
				bg.screenCenter();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				cy_spk1 = new FlxSprite(0, 0);
				cy_spk1.frames = Paths.getSparrowAtlas("studio/studio_speaker");
				cy_spk1.animation.addByPrefix('bump', 'speaker', 24);
				cy_spk1.animation.play('bump');
				cy_spk1.antialiasing = true;
				cy_spk1.scale.x = speakerScale;
				cy_spk1.scale.y = speakerScale;
				cy_spk1.screenCenter();
				cy_spk1.scrollFactor.set(0.9, 0.9);
				cy_spk1.x += -672;
				cy_spk1.y += -32;
				add(cy_spk1);

				cy_spk2 = new FlxSprite(0, 0);
				cy_spk2.frames = Paths.getSparrowAtlas("studio/studio_speaker");
				cy_spk2.animation.addByPrefix('bump', 'speaker', 24);
				cy_spk2.animation.play('bump');
				cy_spk2.antialiasing = true;
				cy_spk2.scale.x = speakerScale;
				cy_spk2.scale.y = speakerScale;
				cy_spk2.screenCenter();
				cy_spk2.scrollFactor.set(0.9, 0.9);
				cy_spk2.x += 640;
				cy_spk2.y += -32;
				cy_spk2.flipX = true;
				add(cy_spk2);

				var bg_fx:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('studio/studio_fx'));
				bg_fx.setGraphicSize(Std.int(bg.width * 0.845));
				bg_fx.screenCenter();
				bg_fx.antialiasing = true;
				bg_fx.scrollFactor.set(0.9, 0.9);
				bg_fx.active = false;
				add(bg_fx);
			}

			case 'sunshine' :
			{
				curStage = "sunshine";
				defaultCamZoom = 1.05;

				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('bob/happysky'));
				bg.updateHitbox();
				bg.active = false;
				bg.antialiasing = true;
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);
				
				var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(Paths.image('bob/happyground'));
				ground.updateHitbox();
				ground.active = false;
				ground.antialiasing = true;
				add(ground);
			}

			case 'withered' :
			{
				curStage = "withered";
				defaultCamZoom = 1.05;

				var bg:FlxSprite = new FlxSprite( -100).loadGraphic(Paths.image('bob/slightlyannoyed_sky'));
				bg.updateHitbox();
				bg.active = false;
				bg.antialiasing = true;
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);
				
				var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(Paths.image('bob/slightlyannoyed_ground'));
				ground.updateHitbox();
				ground.active = false;
				ground.antialiasing = true;
				add(ground);
			}

			case 'garage':
			{
				camZooming = true;
				aaa = new FlxSprite( -422.05, 284.05);
				aaa.frames = Paths.getSparrowAtlas('sunday/aaa');
				aaa.animation.addByIndices("none", "aaaa",[4],"", 24, false);
				aaa.animation.addByIndices("idle", "aaaa",[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,4],"", 24, false);
				aaa.animation.play("none");

				defaultCamZoom = 1;
				curStage = 'garage';
				garage = new FlxSprite( -316, -209);
				speakers = new FlxSprite( -298, 197);
			
				if (SONG.song.toLowerCase() == 'bi-nb')
				{
					garage.frames = Paths.getSparrowAtlas('sunday/bg_binb');
					garage.animation.addByPrefix("idle", "Background");
					garage.animation.addByPrefix("crazy", "bg_binb");
					garage.animation.addByPrefix("notcrazy", "bg_binb_calm",10);
					speakers.frames = Paths.getSparrowAtlas('sunday/rig');
					speakers.animation.addByIndices("idle", "amp",[0],"", 24,true);
					speakers.animation.addByPrefix("boom", "amp boom", 24,true);
					speakers.setPosition(-260.75,243.95);
				add(garage);
				}
				else if (SONG.song.toLowerCase() == 'marx')
				{
					garage.frames = Paths.getSparrowAtlas('sunday/bg_marx');
					garage.animation.addByPrefix("idle", "Background");
					garage.animation.addByPrefix("crazy", "bg_radicalLeft");
					garage.animation.addByPrefix("notcrazy", "bg_moderateLeft");
					add(garage);
					speakers.frames = Paths.getSparrowAtlas('sunday/rig');
					speakers.animation.addByIndices("idle", "amp",[0],"", 24,true);
					speakers.animation.addByPrefix("boom", "amp boom", 24, true);
					speakers.setPosition( -260.75, 243.95);
					glowShit.loadGraphic(Paths.image('sunday/shiny'));
					glowShit.blend = "add";
					glowShit.visible = false;
					carolEnter = new FlxSprite(795.25-193.95-37, 45.35-237+173);
					carolEnter.frames = Paths.getSparrowAtlas("sunday/carol_enter");
					carolEnter.animation.addByPrefix("wait", "carol interupt", 0, false);
					carolEnter.animation.addByPrefix("enter", "carol interupt", 24, false);
					carolEnter.animation.play("wait");
					add(carolEnter);
					FlxG.sound.cache(Paths.sound("carolTellsSundayToSTFU"));
					ending = new FlxSprite().loadGraphic(Paths.image("sunday/ending"));
					ending.scrollFactor.set();				
				}
				else
				{
					garage.frames = Paths.getSparrowAtlas('sunday/bg');
					garage.animation.addByPrefix("idle", "Background");
					garage.animation.addByPrefix("crazy", "bg_with_seizures");
					garage.animation.addByPrefix("notcrazy", "bg_withought_seizures");
					speakers.frames = Paths.getSparrowAtlas('sunday/bigspeakers');
					speakers.animation.addByIndices("idle", "speakers",[0],"", 24,true);
					speakers.animation.addByPrefix("boom", "speakers", 24,true);
					add(garage);
				}
				fret = new FlxSprite().loadGraphic(Paths.image("sunday/fret"));
				fret.alpha = 0;
				fret.scrollFactor.set();
				garage.antialiasing = true;
				garage.active = true;
				garage.animation.play("idle");

				add(aaa);
				speakers.antialiasing = true;
				speakers.active = true;
				add(speakers);
				speakers.animation.play("idle");
			}

			case 'shaggy-mansion':
			{
				curStage = "shaggy-mansion";
				defaultCamZoom = 0.9;

				var sky = new FlxSprite(-850, -850);
				sky.frames = Paths.getSparrowAtlas('shaggy/god_bg');
				sky.animation.addByPrefix('sky', "bg", 30);
				sky.setGraphicSize(Std.int(sky.width * 0.8));
				sky.animation.play('sky');
				sky.scrollFactor.set(0.1, 0.1);
				sky.antialiasing = true;
				add(sky);

				var bgcloud = new FlxSprite(-850, -1250);
				bgcloud.frames = Paths.getSparrowAtlas('shaggy/god_bg');
				bgcloud.animation.addByPrefix('c', "cloud_smol", 30);
				bgcloud.animation.play('c');
				bgcloud.scrollFactor.set(0.3, 0.3);
				bgcloud.antialiasing = true;
				add(bgcloud);

				add(new MansionDebris(300, -800, 'norm', 0.4, 1, 0, 1));
				add(new MansionDebris(600, -300, 'tiny', 0.4, 1.5, 0, 1));
				add(new MansionDebris(-150, -400, 'spike', 0.4, 1.1, 0, 1));
				add(new MansionDebris(-750, -850, 'small', 0.4, 1.5, 0, 1));

				add(new MansionDebris(-300, -1700, 'norm', 0.75, 1, 0, 1));
				add(new MansionDebris(-1000, -1750, 'rect', 0.75, 2, 0, 1));
				add(new MansionDebris(-600, -1100, 'tiny', 0.75, 1.5, 0, 1));
				add(new MansionDebris(900, -1850, 'spike', 0.75, 1.2, 0, 1));
				add(new MansionDebris(1500, -1300, 'small', 0.75, 1.5, 0, 1));
				add(new MansionDebris(-600, -800, 'spike', 0.75, 1.3, 0, 1));
				add(new MansionDebris(-1000, -900, 'small', 0.75, 1.7, 0, 1));

				var fgcloud = new FlxSprite(-1150, -2900);
				fgcloud.frames = Paths.getSparrowAtlas('shaggy/god_bg');
				fgcloud.animation.addByPrefix('c', "cloud_big", 30);
				fgcloud.animation.play('c');
				fgcloud.scrollFactor.set(0.9, 0.9);
				fgcloud.antialiasing = true;
				add(fgcloud);

				var techo = new FlxSprite(0, -20);
				techo.frames = Paths.getSparrowAtlas('shaggy/god_bg');
				techo.animation.addByPrefix('r', "broken_techo", 30);
				techo.setGraphicSize(Std.int(techo.frameWidth * 1.5));
				techo.animation.play('r');
				techo.scrollFactor.set(0.95, 0.95);
				techo.antialiasing = true;
				add(techo);

				gf_rock = new FlxSprite(20, 20);
				gf_rock.frames = Paths.getSparrowAtlas('shaggy/god_bg');
				gf_rock.animation.addByPrefix('rock', "gf_rock", 30);
				gf_rock.animation.play('rock');
				gf_rock.scrollFactor.set(0.8, 0.8);
				gf_rock.antialiasing = true;
				gf_rock.alpha = 0;
				add(gf_rock);

				rock = new FlxSprite(20, 20);
				rock.frames = Paths.getSparrowAtlas('shaggy/god_bg');
				rock.animation.addByPrefix('rock', "rock", 30);
				rock.animation.play('rock');
				rock.scrollFactor.set(1, 1);
				rock.antialiasing = true;
				rock.alpha = 0;
				add(rock);

				dadrock = new FlxSprite(20, 20);
				dadrock.frames = Paths.getSparrowAtlas('shaggy/god_bg');
				dadrock.animation.addByPrefix('rock', "rock", 30);
				dadrock.animation.play('rock');
				dadrock.scrollFactor.set(1, 1);
				dadrock.antialiasing = true;
				dadrock.alpha = 0;
				dadrock.flipX = true;
				add(dadrock);

				normbg = new FlxSprite(-400, -160).loadGraphic(Paths.image('shaggy/bg_lemon'));
				normbg.setGraphicSize(Std.int(normbg.width * 1.5));
				normbg.antialiasing = true;
				normbg.scrollFactor.set(0.95, 0.95);
				normbg.active = false;
				add(normbg);

				burst = new FlxSprite(-1110, 0).loadGraphic(Paths.image('shaggy/redburst'));
				burst.antialiasing = true;
				add(burst);
				remove(burst);
			}

			case 'halloweenmanor':
			{
				curStage = "halloweenmanor";
				halloweenLevel = true;
				defaultCamZoom = 1.05;

				var hallowTex = Paths.getSparrowAtlas('manor_bg', 'week2');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

				isHalloween = true;
			}

			case 'hungryhippo' | 'hungryhippo-blantad':
			{		
				defaultCamZoom = 0.6;
				switch (SONG.stage)
				{
					case 'hungryhippo':
						curStage = 'hungryhippo';
						bg = new FlxSprite(-800, -600).loadGraphic(Paths.image('rebecca/hungryhippo_bg'));
					case 'hungryhippo-blantad':
						curStage = 'hungryhippo-blantad';
						bg = new FlxSprite(-800, -600).loadGraphic(Paths.image('rebecca/hungryhippo_bg_blantad'));
				}
				
				bg.scrollFactor.set(1.0, 1.0);
				add(bg);
			}

			case 'manifest':
			{
				curStage = "manifest";

				defaultCamZoom = 0.9;

				manifestBG = new FlxSprite(-388, -232);
				manifestBG.frames = Paths.getSparrowAtlas('sky/bg_manifest');
				manifestBG.animation.addByPrefix('idle', 'bg_manifest0', 24, false);
				manifestBG.animation.addByPrefix('noflash', 'bg_noflash0', 24, false);		
				manifestBG.scrollFactor.set(0.4, 0.4);
				manifestBG.antialiasing = true;
				manifestBG.animation.play('noflash');
				add(manifestBG);

				manifestFloor = new FlxSprite(-1053, -465);
				manifestFloor.frames = Paths.getSparrowAtlas('sky/floorManifest');
				manifestFloor.animation.addByPrefix('idle', 'floorManifest0', 24, false);
				manifestFloor.animation.addByPrefix('noflash', 'floornoflash0', 24, false);
				manifestFloor.antialiasing = true;
				manifestFloor.animation.play('noflash');
				manifestBG.scrollFactor.set(0.9, 0.9);
				add(manifestFloor);

				gfCrazyBG = new FlxSprite(-300, 120);
				gfCrazyBG.frames = Paths.getSparrowAtlas('characters/crazyGF');
				gfCrazyBG.animation.addByPrefix('idle', 'gf Idle Dance', 24, false);
				gfCrazyBG.antialiasing = true;
				gfCrazyBG.setGraphicSize(Std.int(gfCrazyBG.width * 1.1));
				gfCrazyBG.updateHitbox();
				gfCrazyBG.scrollFactor.set(0.9, 0.9);
				gfCrazyBG.flipX = true;
				add(gfCrazyBG);
			}

			case 'skybroke':
			{
				curStage = "skybroke";

				defaultCamZoom = 0.9;

				manifestBG = new FlxSprite(-388, -232);
				manifestBG.frames = Paths.getSparrowAtlas('sky/bg_annoyed');
				manifestBG.animation.addByPrefix('idle', 'bg2', 24, false);
				manifestBG.animation.addByIndices('noflash', "bg2", [5], "", 24, false);
				manifestBG.scrollFactor.set(0.4, 0.4);
				manifestBG.antialiasing = true;
				manifestBG.animation.play('noflash');
				add(manifestBG);

				manifestHole = new FlxSprite (160, -70);
				manifestHole.frames = Paths.getSparrowAtlas('sky/manifesthole');
				manifestHole.animation.addByPrefix('idle', 'manifest hole', 24, false);
				manifestHole.animation.addByIndices('noflash', "manifest hole", [5], "", 24, false);
				manifestHole.scrollFactor.set(0.7, 1);
				manifestHole.setGraphicSize(Std.int(manifestHole.width * 0.9));
				manifestHole.updateHitbox();
				manifestHole.animation.play('noflash');
				manifestHole.antialiasing = true;
				add(manifestHole);
					
			}

			case 'alleysoft':
			{
				defaultCamZoom = 0.8;
				curStage = 'alleysoft';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('soft/alleybg'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-630,-200).loadGraphic(Paths.image('soft/alleyfloor'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(1, 1);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-200, -100).loadGraphic(Paths.image('soft/alleycat'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				add(stageCurtains);
			}

			case 'philly' | 'phillyannie':
			{
				var phillyShit:String = '';

				if (SONG.stage == 'phillyannie')
				{
					curStage = 'phillyannie';
					phillyShit = 'annie';
				}	
				else
				{
					curStage = 'philly';
					phillyShit = 'philly';
				}			
				
				defaultCamZoom = 1.05;

				bg = new FlxSprite(-100).loadGraphic(Paths.image(phillyShit+'/sky', 'week3'));
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image(phillyShit+'/city', 'week3'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				add(phillyCityLights);

				for (i in 0...5)
				{
					var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image(phillyShit+'/win' + i, 'week3'));
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
				}

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image(phillyShit+'/behindTrain', 'week3'));
				add(streetBehind);

				phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image(phillyShit+'/train', 'week3'));
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image(phillyShit+'/street', 'week3'));
				add(street);
			}

			case 'throne':
			{
				curStage = 'throne';		
				defaultCamZoom = 0.69;

				bg = new FlxSprite(-550, -243).loadGraphic(Paths.image('anchor/watah'));
				bg.scrollFactor.set(0.1, 0.1);
				bg.setGraphicSize(Std.int(bg.width * 1.5));
				bg.updateHitbox();
				bg.antialiasing = true;
				add(bg);

				bg2 = new FlxSprite(-1271, -724).loadGraphic(Paths.image('anchor/throne'));
				bg2.scrollFactor.set(0.9, 0.9);
				bg2.setGraphicSize(Std.int(bg2.width * 1.95));
				bg2.updateHitbox();
				bg2.antialiasing = true;
				add(bg2);

				bottomBoppers = new FlxSprite(-564, 2);
				bottomBoppers.frames = Paths.getSparrowAtlas('anchor/feesh3');
				bottomBoppers.animation.addByPrefix('bop', 'ikan', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 0.95));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);
						
				bgcrowd = new FlxSprite(-1020, 460);
				bgcrowd.frames = Paths.getSparrowAtlas('anchor/front');
				bgcrowd.animation.addByPrefix('bop', 'ikan', 24, false);
				bgcrowd.antialiasing = true;
				bgcrowd.setGraphicSize(Std.int(bgcrowd.width * 1.2));
				bgcrowd.updateHitbox();
			}

			case 'philly-wire':
			{
				curStage = 'philly-wire';
				defaultCamZoom = 1.05;

				bg = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				bgwire = new FlxSprite(-100).loadGraphic(Paths.image('wire/sky', 'week3'));
				bgwire.scrollFactor.set(0.1, 0.1);
				add(bgwire);

				var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				citywire = new FlxSprite(-10).loadGraphic(Paths.image('wire/city', 'week3'));
				citywire.scrollFactor.set(0.3, 0.3);
				citywire.setGraphicSize(Std.int(citywire.width * 0.85));
				citywire.updateHitbox();
				add(citywire);

				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				add(phillyCityLights);

				for (i in 0...5)
				{
					var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
				}

				phillyCityLightswire = new FlxTypedGroup<FlxSprite>();
				add(phillyCityLightswire);

				for (i in 0...1)
				{
					lightwire = new FlxSprite(city.x).loadGraphic(Paths.image('wire/win' + i, 'week3'));
					lightwire.scrollFactor.set(0.3, 0.3);
					lightwire.visible = false;
					lightwire.setGraphicSize(Std.int(lightwire.width * 0.85));
					lightwire.updateHitbox();
					lightwire.antialiasing = true;
					phillyCityLightswire.add(lightwire);
				}

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain', 'week3'));
				add(streetBehind);

				streetBehindwire = new FlxSprite(-40, 50).loadGraphic(Paths.image('wire/behindTrain', 'week3'));
				add(streetBehindwire);

				phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train', 'week3'));
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street', 'week3'));
				add(street);

				streetwire = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('wire/street', 'week3'));
				add(streetwire);

				gfBG = new GirlfriendBG(300, 210, 'characters/gfBana', 'GF Dancing Beat Bana');
				gfBG.scrollFactor.set(0.95, 0.95);
				gfBG.setGraphicSize(Std.int(gfBG.width * 0.8));
				gfBG.updateHitbox();

				gfBG2 = new GirlfriendBG(300, 210, 'characters/gfBana_WIRE', 'GF Dancing Beat Bana');
				gfBG2.scrollFactor.set(0.95, 0.95);
				gfBG2.setGraphicSize(Std.int(gfBG2.width * 0.8));
				gfBG2.updateHitbox();
			}

			case 'limo':
			{
				curStage = 'limo';
				defaultCamZoom = 0.9;

				var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset', 'week4'));
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);

				var bgLimo:FlxSprite = new FlxSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo', 'week4');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				add(bgLimo);

				grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
				add(grpLimoDancers);

				for (i in 0...5)
				{
					var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					grpLimoDancers.add(dancer);
				}

				var limoTex = Paths.getSparrowAtlas('limo/limoDrive', 'week4');

				limo = new FlxSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;

				fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol', 'week4'));
				// add(limo);
			}

			case 'limoholo':
			{
				curStage = 'limoholo';
				defaultCamZoom = 0.9;
	
				var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('holofunk/limoholo/limoSunset'));
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);
				
				var bgLimo:FlxSprite = new FlxSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('holofunk/limoholo/bgLimo');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				add(bgLimo);

				grpLimoDancersHolo = new FlxTypedGroup<BackgroundDancerHolo>();
				add(grpLimoDancersHolo);

				for (i in 0...5)
				{
					var dancer:BackgroundDancerHolo = new BackgroundDancerHolo((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					grpLimoDancersHolo.add(dancer);
				}

				var limoTex = Paths.getSparrowAtlas('holofunk/limoholo/limoDrive');

				limo = new FlxSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;

				fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('holofunk/limoholo/fastCarLol'));
				// add(limo);
			}

			case 'limoholo-night':
			{
				curStage = 'limoholo-night';
				defaultCamZoom = 0.9;

				upperSky = new FlxSprite(-250, -1100).loadGraphic(Paths.image('holofunk/limoholo/upperSky'));
				upperSky.scrollFactor.set(0.1, 0.1);
				upperSky.setGraphicSize(Std.int(upperSky.width * 1.4));
				upperSky.updateHitbox();
				add(upperSky);
				
				upperSky2 = new FlxSprite(-2000, -1100).loadGraphic(Paths.image('holofunk/limoholo/upperSky'));
				upperSky2.scrollFactor.set(0.1, 0.1);
				upperSky2.setGraphicSize(Std.int(upperSky2.width * 1.4));
				upperSky2.updateHitbox();
				add(upperSky2);

				var skyBG:FlxSprite = new FlxSprite(-120, -100).loadGraphic(Paths.image('holofunk/limoholo/limoNight'));
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);

				cloudGroup2 = new FlxTypedGroup<Cloud2>(12);
				add(cloudGroup2);
		
				bgLimo = new FlxSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('holofunk/limoholo/bgLimo');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				add(bgLimo);

				if (SONG.song.toLowerCase() == 'hands')
				{
					bgLimoOhNo = new FlxSprite(-380, 390);
					bgLimoOhNo.frames = Paths.getSparrowAtlas('holofunk/limoholo/bgLimoOhNo');
					bgLimoOhNo.animation.addByPrefix('drive', "BG limo PINK", 24);
					bgLimoOhNo.animation.play('drive');
					bgLimoOhNo.scrollFactor.set(0.4, 0.4);
					add(bgLimoOhNo);
				}
				
				grpLimoDancersHolo = new FlxTypedGroup<BackgroundDancerHolo>();
				add(grpLimoDancersHolo);

				for (i in 0...5)
				{
					var dancer:BackgroundDancerHolo = new BackgroundDancerHolo((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					grpLimoDancersHolo.add(dancer);
				}

				if (SONG.song.toLowerCase() == 'hands')
				{
					blantadBG = new Character(100, -100, 'blantad-handscutscene2');
					blantadBG.scrollFactor.set(0.9, 0.9);
					blantadBG.antialiasing = true;
					add(blantadBG);
				}	

				var limoTex = Paths.getSparrowAtlas('holofunk/limoholo/limoDrive');

				limo = new FlxSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;

				limoOhNo = new FlxSprite(-225, 370);
				limoOhNo.frames = Paths.getSparrowAtlas('holofunk/limoholo/limoDriveOhNo');
				limoOhNo.animation.addByPrefix('drive', "BeforeFly", 24);
				limoOhNo.animation.addByPrefix('driveFlying', "Flying", 24);
				limoOhNo.animation.play('drive');
				limoOhNo.antialiasing = true;

				fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('holofunk/limoholo/fastCarLol'));
				// add(limo);

				if (SONG.song.toLowerCase() == 'hands')
				{
					gfBG = new GirlfriendBG(475, 525, 'holofunk/limoholo/shoppingCartBottom', 'GF Dancing Beat Hair blowing CAR');
					gfBG.antialiasing = true;
					gfBG.scrollFactor.set(0.95, 0.95);
					add(gfBG);
				}						
			}

			case 'mall':
			{
				curStage = 'mall';

				defaultCamZoom = 0.80;

				bg = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls', 'week5'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				upperBoppers = new FlxSprite(-240, -90);
				if (SONG.song.toLowerCase() == 'cursed-cocoa')
				{
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBopNoPico', 'week5');
				}
				else
				{	
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop', 'week5');
				}
				
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				add(upperBoppers);

				var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator', 'week5'));
				bgEscalator.antialiasing = true;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				add(bgEscalator);

				var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree', 'week5'));
				tree.antialiasing = true;
				tree.scrollFactor.set(0.40, 0.40);
				add(tree);

				bottomBoppers = new FlxSprite(-300, 140);
				bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop', 'week5');
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);

				var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow', 'week5'));
				fgSnow.active = false;
				fgSnow.antialiasing = true;
				add(fgSnow);

				santa = new FlxSprite(-840, 150);
				santa.frames = Paths.getSparrowAtlas('christmas/santa', 'week5');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = true;
				add(santa);
			}

			case 'mallSoft':
			{
				curStage = 'mallSoft';

				defaultCamZoom = 0.80;

				bg = new FlxSprite(-1000, -500).loadGraphic(Paths.image('soft/christmas/bgWalls'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				upperBoppers = new FlxSprite(-240, -90);

				if (SONG.song.toLowerCase() == 'ugh-remix' || SONG.song.toLowerCase() == 'hope')
				{
					upperBoppers.frames = Paths.getSparrowAtlas('soft/christmas/angrybogosbinted');
				}
				else
				{	
					upperBoppers.frames = Paths.getSparrowAtlas('soft/christmas/normalfuckerspng');	
				}
				
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				add(upperBoppers);

				var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('soft/christmas/bgEscalator'));
				bgEscalator.antialiasing = true;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				add(bgEscalator);

				var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('soft/christmas/christmasTree'));
				tree.antialiasing = true;
				tree.scrollFactor.set(0.40, 0.40);
				add(tree);

				bottomBoppers = new FlxSprite(-150, 0);

				if (SONG.song.toLowerCase() == 'ugh-remix' || SONG.song.toLowerCase() == 'hope')
				{
					bottomBoppers.frames = Paths.getSparrowAtlas('soft/christmas/bopit');
				}
				else
				{	
					bottomBoppers.frames = Paths.getSparrowAtlas('soft/christmas/bop1');		
				}

				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();			
				add(bottomBoppers);

				if (SONG.song.toLowerCase() == 'ugh-remix')
				{
					blantadBG2 = new FlxSprite(-300, 120);
					blantadBG2.frames = Paths.getSparrowAtlas('soft/christmas/allAloneRIP');
					blantadBG2.animation.addByPrefix('bop', 'blantad', 24, false);
					blantadBG2.antialiasing = true;
					blantadBG2.scrollFactor.set(0.9, 0.9);
					add(blantadBG2);
				}

				var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('soft/christmas/fgSnow'));
				fgSnow.active = false;
				fgSnow.antialiasing = true;
				add(fgSnow);

				santa = new FlxSprite(-840, 150);
				santa.frames = Paths.getSparrowAtlas('soft/christmas/santa1');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = true;
				
				if (SONG.song.toLowerCase() == 'ugh-remix')
				{
					gfBG = new GirlfriendBG(1164, 426, 'characters/softPico_Christmas', 'GF Dancing Beat');
					gfBG.antialiasing = true;
					gfBG.scrollFactor.set(0.9, 0.9);
					gfBG.setGraphicSize(Std.int(gfBG.width * 0.8));
					gfBG.updateHitbox();
					add(gfBG);

					momDadBG = new FlxSprite(-400, 110);
					momDadBG.frames = Paths.getSparrowAtlas('characters/parents_xmas_soft');
					momDadBG.animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
					momDadBG.antialiasing = true;
					add(momDadBG);

					softBFBG = new FlxSprite (1594, 440);
					softBFBG.frames = Paths.getSparrowAtlas('characters/softie_crimmus2');
					softBFBG.animation.addByPrefix('idle', 'BF idle dance', 24, false);
					softBFBG.setGraphicSize(Std.int(softBFBG.width * 0.9));
					softBFBG.updateHitbox();
					softBFBG.antialiasing = true;
					add(softBFBG);
				}
			}

			case 'mallEvil':
			{
				curStage = 'mallEvil';
				defaultCamZoom = 1.05;
				bg = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG', 'week5'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree', 'week5'));
				evilTree.antialiasing = true;
				evilTree.scrollFactor.set(0.2, 0.2);
				add(evilTree);

				var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow", 'week5'));
				evilSnow.antialiasing = true;
				add(evilSnow);
			}
			case 'mallAnnie':
			{
				curStage = 'mallAnnie';
				defaultCamZoom = 1.05;
				bg = new FlxSprite(-400, -500).loadGraphic(Paths.image('annie/evilBG', 'week3'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);
	
				var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('annie/evilTree', 'week3'));
				evilTree.antialiasing = true;
				evilTree.scrollFactor.set(0.2, 0.2);
				add(evilTree);
	
				var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("annie/evilSnow", 'week3'));
				evilSnow.antialiasing = true;
				add(evilSnow);
			}
			case 'eddhouse':
			{
				curStage = 'eddhouse';
				var sky:FlxSprite = new FlxSprite( -162.1, -386.1);
				sky.frames = Paths.getSparrowAtlas("tord/sky");
				sky.animation.addByPrefix("bg_sky1", "bg_sky1");
				sky.animation.addByPrefix("bg_sky2", "bg_sky2");
				if(SONG.song.toLowerCase() == 'norway' ){
				sky.animation.play("bg_sky1");
				}else{
				sky.animation.play("bg_sky2");
				}
							
				bg = new FlxSprite( -162.1, -386.1);
				bg.frames = Paths.getSparrowAtlas("tord/bgFront");
				bg.animation.addByPrefix("bg_normal", "bg_normal");
				bg.animation.addByPrefix("bg_destroy", "bg_destroy");
				if(SONG.song.toLowerCase() == 'norway'){
				bg.animation.play("bg_normal");
				}else{
				bg.animation.play("bg_destroy");
				}

				if(SONG.song.toLowerCase() == 'norway')
				{
					tomBG = new FlxSprite(1250, 0);
					tomBG.frames = Paths.getSparrowAtlas('characters/tom_assets');
					tomBG.animation.addByPrefix('idle', "tord idle", 24, false);
					tomBG.scrollFactor.set(0.9, 0.9);
					tomBG.antialiasing = true;
					tomBG.setGraphicSize(Std.int(tomBG.width * 0.8));
					tomBG.flipX = true;

					bfBG = new FlxSprite(-200, 250);
					bfBG.frames = Paths.getSparrowAtlas('characters/BOYFRIEND');
					bfBG.animation.addByPrefix('idle', "BF idle dance", 24, false);
					bfBG.scrollFactor.set(0.9, 0.9);
					bfBG.antialiasing = true;
					bfBG.setGraphicSize(Std.int(bfBG.width * 0.8));
					bfBG.flipX = true;

					tordBG = new FlxSprite(25, 100);
					tordBG.frames = Paths.getSparrowAtlas('characters/tord_assets');
					tordBG.animation.addByPrefix('idle', 'tord idle', 24, false);
					tordBG.antialiasing = true;
					tordBG.scrollFactor.set(0.9, 0.9);
					tordBG.setGraphicSize(Std.int(tordBG.width * 0.7));
					tordBG.updateHitbox();

					mattBG = new FlxSprite(250, -100);
					mattBG.frames = Paths.getSparrowAtlas('characters/matt');
					mattBG.animation.addByPrefix('idle', 'Senpai Idle', 24, false);
					mattBG.scrollFactor.set(0.9, 0.9);
					mattBG.setGraphicSize(Std.int(mattBG.width * 4.5));
					mattBG.updateHitbox();

					gfBG = new GirlfriendBG(750, 20, 'characters/GFBG_assets', 'GF Dancing Beat');
					gfBG.antialiasing = true;
					gfBG.scrollFactor.set(0.9, 0.9);
					gfBG.setGraphicSize(Std.int(gfBG.width * 0.8));
					gfBG.updateHitbox();
				}
				
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				if (curSong == 'Norway'){sky.scrollFactor.set(0.5, 0);}
				else {sky.scrollFactor.set();}
				bg.active = false;
				sky.active = false;
				//bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				sky.updateHitbox();
				add(sky);
				add(bg);
				if(SONG.song.toLowerCase() == 'norway')
				{
					add(tordBG);
					add(bfBG);	
					add(gfBG);
					add(mattBG);
				}
				
			}

			case 'school':
			{
				curStage = 'school';

				defaultCamZoom = 1.05;

				var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky', 'week6'));
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);

				var repositionShit = -200;

				var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool', 'week6'));
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);

				var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet', 'week6'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);

				var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack', 'week6'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('weeb/weebTrees', 'week6');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);

				var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals', 'week6');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				add(treeLeaves);

				var widShit = Std.int(bgSky.width * 6);

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);

				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();

				bgGirls = new BackgroundGirls(-100, 190);
				bgGirls.scrollFactor.set(0.9, 0.9);

				if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'roses-remix-senpai')
				{
					bgGirls.getScared();
				}

				bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
				bgGirls.updateHitbox();
				add(bgGirls);
			}

			case 'school-monika':
			{
				curStage = 'school-monika';

				defaultCamZoom = 1.05;

				var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/monika/weebSky'));
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);

				var repositionShit = -200;

				var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/monika/weebSchool'));
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);

				var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/monika/weebStreet'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);

				var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/monika/weebTreesBack'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('weeb/monika/weebTrees');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);

				var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('weeb/monika/petals');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				add(treeLeaves);

				var widShit = Std.int(bgSky.width * 6);

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);

				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();

				if (SONG.song.toLowerCase() == "dreams of roses" || SONG.song.toLowerCase() == "shinkyoku" || SONG.song.toLowerCase() == "bara no yume")
				{
					bgGirls2 = new BackgroundGirlsSwitch(-600, 190, 'weeb/monika/bgFreaks');
					bgGirls2.scrollFactor.set(0.9, 0.9);
		
					bgGirls2.setGraphicSize(Std.int(bgGirls2.width * daPixelZoom));
					bgGirls2.updateHitbox();
						
					add(bgGirls2);
					bgGirls2.dance();
				}
			}

			case 'school-switch':
			{
				curStage = 'school-switch';

				defaultCamZoom = 1.05;

				bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky', 'week6'));
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);

				bgSkyMario = new FlxSprite().loadGraphic(Paths.image('weeb/mario/weebSky'));
				bgSkyMario.scrollFactor.set(0.1, 0.1);

				bgSkyEdd = new FlxSprite().loadGraphic(Paths.image('weeb/matt/weebSky'));
				bgSkyEdd.scrollFactor.set(0.1, 0.1);

				bgSkyUT = new FlxSprite().loadGraphic(Paths.image('weeb/weebSkyUT'));
				bgSkyUT.scrollFactor.set(0.1, 0.1);
				
				bgSkyBaldi = new FlxSprite().loadGraphic(Paths.image('weeb/baldi/weebSky'));
				bgSkyBaldi.scrollFactor.set(0.1, 0.1);

				bgSkyNeon = new FlxSprite().loadGraphic(Paths.image('weeb/weebSkyNeon'));
				bgSkyNeon.scrollFactor.set(0.1, 0.1);

				var repositionShit = -200;

				bgSchool = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool', 'week6'));
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);

				bgSchoolMario = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/mario/weebSchool'));
				bgSchoolMario.scrollFactor.set(0.6, 0.90);

				bgSchoolEdd = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/matt/weebSchool'));
				bgSchoolEdd.scrollFactor.set(0.6, 0.90);

				bgSchoolUT = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchoolUT'));
				bgSchoolUT.scrollFactor.set(0.6, 0.90);

				bgSchoolBaldi = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/baldi/weebSchool'));
				bgSchoolBaldi.scrollFactor.set(0.6, 0.90);

				bgStreet = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet', 'week6'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);

				bgStreetMario = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/mario/weebStreet'));
				bgStreetMario.scrollFactor.set(0.95, 0.95);

				bgStreetEdd = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/matt/weebStreet'));
				bgStreetEdd.scrollFactor.set(0.95, 0.95);

				bgStreetUT = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreetUT'));
				bgStreetUT.scrollFactor.set(0.95, 0.95);

				bgStreetBaldi = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/baldi/weebStreet'));
				bgStreetBaldi.scrollFactor.set(0.95, 0.95);

				bgStreetNeon = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreetNeon'));
				bgStreetNeon.scrollFactor.set(0.95, 0.95);

				fgTrees = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack', 'week6'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);

				bgTrees = new FlxSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('weeb/weebTrees', 'week6');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);

				bgTreesEdd = new FlxSprite(repositionShit - 380, -800);
				var treetexEdd = Paths.getPackerAtlas('weeb/matt/weebTrees');
				bgTreesEdd.frames = treetexEdd;
				bgTreesEdd.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTreesEdd.animation.play('treeLoop');
				bgTreesEdd.scrollFactor.set(0.85, 0.85);

				treeLeaves = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals', 'week6');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				add(treeLeaves);

				treeLeavesEdd = new FlxSprite(repositionShit, -40);
				treeLeavesEdd.frames = Paths.getSparrowAtlas('weeb/matt/petals');
				treeLeavesEdd.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeavesEdd.animation.play('leaves');
				treeLeavesEdd.scrollFactor.set(0.85, 0.85);

				var monikaTex = Paths.getSparrowAtlas('weeb/monika_bg');

				monikaStillBG = new FlxSprite(-400, 0);
				monikaStillBG.frames = monikaTex;
				monikaStillBG.animation.addByPrefix('idle', 'monika bg0', 24, false);
				monikaStillBG.animation.play('idle');
				monikaStillBG.antialiasing = true;

				var widShit = Std.int(bgSky.width * 6);

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);
				bgSkyUT.setGraphicSize(widShit);
				bgSchoolUT.setGraphicSize(widShit);
				bgStreetUT.setGraphicSize(widShit);
				bgSkyEdd.setGraphicSize(widShit);
				bgSchoolEdd.setGraphicSize(widShit);
				bgStreetEdd.setGraphicSize(widShit);
				bgTreesEdd.setGraphicSize(Std.int(widShit * 1.4));
				treeLeavesEdd.setGraphicSize(widShit);
				bgSkyNeon.setGraphicSize(widShit);
				bgStreetNeon.setGraphicSize(widShit);
				bgSkyMario.setGraphicSize(widShit);
				bgSchoolMario.setGraphicSize(widShit);
				bgStreetMario.setGraphicSize(widShit);
				bgSkyBaldi.setGraphicSize(widShit);
				bgSchoolBaldi.setGraphicSize(widShit);
				bgStreetBaldi.setGraphicSize(widShit);

				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();
				bgSkyUT.updateHitbox();
				bgSchoolUT.updateHitbox();
				bgStreetUT.updateHitbox();
				bgSkyEdd.updateHitbox();
				bgSchoolEdd.updateHitbox();
				bgStreetEdd.updateHitbox();
				bgTreesEdd.updateHitbox();
				treeLeavesEdd.updateHitbox();
				bgSkyNeon.updateHitbox();
				bgStreetNeon.updateHitbox();
				bgSkyMario.updateHitbox();
				bgSchoolMario.updateHitbox();
				bgStreetMario.updateHitbox();
				bgSkyBaldi.updateHitbox();
				bgSchoolBaldi.updateHitbox();
				bgStreetBaldi.updateHitbox();

				bgGirls = new BackgroundGirls(-100, 190);
				bgGirls.scrollFactor.set(0.9, 0.9);

				bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
				bgGirls.updateHitbox();
				add(bgGirls);

				bgGirlsUTMJ = new BackgroundGirlsSwitch(-100, 190, 'weeb/bgFreaksUTMJ');
				bgGirlsUTMJ.scrollFactor.set(0.9, 0.9);
				bgGirlsUTMJ.setGraphicSize(Std.int(bgGirlsUTMJ.width * daPixelZoom));
				bgGirlsUTMJ.updateHitbox();

				bgGirlsEdd = new BackgroundGirlsSwitch(-100, 190, 'weeb/bgFreaksEdd');
				bgGirlsEdd.scrollFactor.set(0.9, 0.9);
				bgGirlsEdd.setGraphicSize(Std.int(bgGirlsEdd.width * daPixelZoom));
				bgGirlsEdd.updateHitbox();

				bgGirlsBSAA = new BackgroundGirlsSwitch(-100, 190, 'weeb/bgFreaksBSAA');
				bgGirlsBSAA.scrollFactor.set(0.9, 0.9);
				bgGirlsBSAA.setGraphicSize(Std.int(bgGirlsBSAA.width * daPixelZoom));
				bgGirlsBSAA.updateHitbox();

				bgGirlsSFNAF = new BackgroundGirlsSwitch(-100, 190, 'weeb/bgFreaksSFNAF');
				bgGirlsSFNAF.scrollFactor.set(0.9, 0.9);
				bgGirlsSFNAF.setGraphicSize(Std.int(bgGirlsSFNAF.width * daPixelZoom));
				bgGirlsSFNAF.updateHitbox();

				bfPixelBG = new FlxSprite(1050, 400);
				bfPixelBG.frames = Paths.getSparrowAtlas('characters/bfPixelNeon');
				bfPixelBG.animation.addByPrefix('idle', 'BF IDLE', 24, false);
				bfPixelBG.antialiasing = false;
				bfPixelBG.scrollFactor.set(0.9, 0.9);
				bfPixelBG.setGraphicSize(Std.int(bfPixelBG.width * 5.75));
				bfPixelBG.updateHitbox();

				fgStreetMario = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/mario/weebFG'));
				fgStreetMario.scrollFactor.set(0.95, 0.95);
				fgStreetMario.setGraphicSize(widShit);
				fgStreetMario.updateHitbox();

				var glitchTex = Paths.getSparrowAtlas('weeb/monika_bg');

				glitchBG = new FlxSprite(-400, 0);
				glitchBG.frames = glitchTex;
				glitchBG.animation.addByPrefix('idle', 'glitch bg0', 24, false);
				glitchBG.animation.play('idle');
				glitchBG.antialiasing = true;

				amyPixelBG = new GirlfriendBG(500, 150, 'characters/amyPixelMario', 'GF IDLE');
				amyPixelBG.scrollFactor.set(0.9, 0.9);
				amyPixelBG.antialiasing = false;
				amyPixelBG.setGraphicSize(Std.int(amyPixelBG.width * 5.5));
				amyPixelBG.updateHitbox();

				monikaBG = new FlxSprite(-300, 100);
				monikaBG.frames = monikaTex;
				monikaBG.animation.addByPrefix('idle', 'monika bg0', 24, false);
				monikaBG.animation.addByPrefix('still', 'monika bg still0', 24, false);
				monikaBG.animation.addByPrefix('jumpscare', 'monika jumpscare0', 24, false);
				monikaBG.animation.addByPrefix('ghost', 'ghost bg0', 24, false);
				monikaBG.animation.addByPrefix('just-monika', 'just monika bg0', 24, false);
				monikaBG.animation.play('still');
				monikaBG.antialiasing = true;
				monikaBG.alpha = 0;
				monikaBG.setGraphicSize(Std.int(monikaBG.width * 0.8));
				monikaBG.updateHitbox();
				add(monikaBG);
			}

			case 'schoolEvil':
			{
				curStage = 'schoolEvil';

				defaultCamZoom = 1.05;

				var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
				var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

				var posX = 400;
				var posY = 200;

				bg = new FlxSprite(posX, posY);
				bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool');
				bg.animation.addByPrefix('idle', 'background 2', 24);
				bg.animation.play('idle');
				bg.scrollFactor.set(0.8, 0.9);
				bg.scale.set(6, 6);
				add(bg);
			}
			
			case 'schoolEvild4':
			{
				curStage = 'schoolEvild4';

				defaultCamZoom = 1.05;

				var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
				var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

				var posX = 400;
				var posY = 220;

				bg = new FlxSprite(posX, posY);
				bg.frames = Paths.getSparrowAtlas('corruption/weeb/animatedEvilSchool');
				bg.animation.addByPrefix('idle', 'background 2', 24);
				bg.animation.play('idle');
				bg.scrollFactor.set(0.8, 0.9);
				bg.scale.set(6, 6);
				add(bg);
			}

			case 'tank':
			{
				defaultCamZoom = 0.9;
				curStage = "tank";
				
				var tankSky:FlxSprite = new FlxSprite(-400, -400).loadGraphic(Paths.image('tank/tankSky'));
				tankSky.antialiasing = true;
				tankSky.scrollFactor.set(0, 0);
				add(tankSky);
				
				var tankClouds:FlxSprite = new FlxSprite(-700, -100).loadGraphic(Paths.image('tank/tankClouds'));
				tankClouds.antialiasing = true;
				tankClouds.scrollFactor.set(0.1, 0.1);
				add(tankClouds);
				
				var tankMountains:FlxSprite = new FlxSprite(-300, -20).loadGraphic(Paths.image('tank/tankMountains'));
				tankMountains.antialiasing = true;
				tankMountains.setGraphicSize(Std.int(tankMountains.width * 1.1));
				tankMountains.scrollFactor.set(0.2, 0.2);
				tankMountains.updateHitbox();
				add(tankMountains);
				
				var tankBuildings:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('tank/tankBuildings'));
				tankBuildings.antialiasing = true;
				tankBuildings.setGraphicSize(Std.int(tankBuildings.width * 1.1));
				tankBuildings.scrollFactor.set(0.3, 0.3);
				tankBuildings.updateHitbox();
				add(tankBuildings);
				
				var tankRuins:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('tank/tankRuins'));
				tankRuins.antialiasing = true;
				tankRuins.setGraphicSize(Std.int(tankRuins.width * 1.1));
				tankRuins.scrollFactor.set(0.35, 0.35);
				tankRuins.updateHitbox();
				add(tankRuins);

				var smokeLeft:FlxSprite = new FlxSprite(-200, -100).loadGraphic(Paths.image('tank/smokeLeft'));
				smokeLeft.frames = Paths.getSparrowAtlas('tank/smokeLeft');
				smokeLeft.animation.addByPrefix('idle', 'SmokeBlurLeft', 24, true);
				smokeLeft.animation.play('idle');
				smokeLeft.scrollFactor.set (0.4, 0.4);
				smokeLeft.antialiasing = true;
				add(smokeLeft);

				var smokeRight:FlxSprite = new FlxSprite(1100, -100).loadGraphic(Paths.image('tank/smokeRight'));
				smokeRight.frames = Paths.getSparrowAtlas('tank/smokeRight');
				smokeRight.animation.addByPrefix('idle', 'SmokeRight', 24, true);
				smokeRight.animation.play('idle');
				smokeRight.scrollFactor.set (0.4, 0.4);
				smokeRight.antialiasing = true;
				add(smokeRight);
				
				tankWatchtower = new FlxSprite(100, 50);
				tankWatchtower.frames = Paths.getSparrowAtlas('tank/tankWatchtower');
				tankWatchtower.animation.addByPrefix('idle', 'watchtower gradient color', 24, false);
				tankWatchtower.animation.play('idle');
				tankWatchtower.scrollFactor.set(0.5, 0.5);
				tankWatchtower.antialiasing = true;
				add(tankWatchtower);
				
				tankRolling = new FlxSprite(300,300);
				tankRolling.frames = Paths.getSparrowAtlas('tank/tankRolling');
				tankRolling.animation.addByPrefix('idle', 'BG tank w lighting ', 24, true);
				tankRolling.scrollFactor.set(0.5, 0.5);
				tankRolling.antialiasing = true;
				tankRolling.animation.play('idle');
					
				add(tankRolling);	
				
				var tankGround:FlxSprite = new FlxSprite(-420, -150).loadGraphic(Paths.image('tank/tankGround'));
				tankGround.setGraphicSize(Std.int(tankGround.width * 1.15));
				tankGround.updateHitbox();
				tankGround.antialiasing = true;
				add(tankGround);

				tank0 = new FlxSprite(-500, 650);
				tank0.frames = Paths.getSparrowAtlas('tank/tank0');
				tank0.animation.addByPrefix('idle', 'fg tankhead far right', 24, false);
				tank0.scrollFactor.set(1.7, 1.5);
				tank0.antialiasing = true;

				tank1 = new FlxSprite(-300, 750);
				tank1.frames = Paths.getSparrowAtlas('tank/tank1');
				tank1.animation.addByPrefix('idle', 'fg', 24, false);
				tank1.scrollFactor.set(2, 0.2);
				tank1.antialiasing = true;

				tank2 = new FlxSprite(450, 940);
				tank2.frames = Paths.getSparrowAtlas('tank/tank2');
				tank2.animation.addByPrefix('idle', 'foreground', 24, false);
				tank2.scrollFactor.set(1.5, 1.5);
				tank2.antialiasing = true;

				tank4 = new FlxSprite(1300, 900);
				tank4.frames = Paths.getSparrowAtlas('tank/tank4');
				tank4.animation.addByPrefix('idle', 'fg', 24, false);
				tank4.scrollFactor.set(1.5, 1.5);
				tank4.antialiasing = true;

				tank5 = new FlxSprite(1620, 700);
				tank5.frames = Paths.getSparrowAtlas('tank/tank5');
				tank5.animation.addByPrefix('idle', 'fg', 24, false);
				tank5.scrollFactor.set(1.5, 1.5);
				tank5.antialiasing = true;

				tank3 = new FlxSprite(1300, 1200);
				tank3.frames = Paths.getSparrowAtlas('tank/tank3');
				tank3.animation.addByPrefix('idle', 'fg', 24, false);
				tank3.scrollFactor.set(1.5, 1.5);
				tank3.antialiasing = true;

			}

			case 'garStage':
			{
				defaultCamZoom = 0.9;
				curStage = 'garStage';
				bg = new FlxSprite(-500, -170).loadGraphic(Paths.image('garcello/garStagebg'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('garcello/garStage'));
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);
			}

			case 'eddhouse2':
			{
				defaultCamZoom = 0.9;
				curStage = 'eddhouse2';
				bg = new FlxSprite(-500, -170).loadGraphic(Paths.image('tord/garStagebg'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('tord/garStage'));
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);
			}

			case 'garStageRise':
			{
				defaultCamZoom = 0.9;
				curStage = 'garStageRise';
				bg = new FlxSprite(-500, -170).loadGraphic(Paths.image('garcello/garStagebgRise'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('garcello/garStageRise'));
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);
			}

			case 'garStageDead':
			{
					defaultCamZoom = 0.9;
					curStage = 'garStageDead';

					var bg:FlxSprite = new FlxSprite(-500, -170).loadGraphic(Paths.image('garcello/garStagebgAlt'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.7, 0.7);
					bg.active = false;
					add(bg);

					var smoker:FlxSprite = new FlxSprite(0, -290);
					smoker.frames = Paths.getSparrowAtlas('garcello/garSmoke');
					smoker.setGraphicSize(Std.int(smoker.width * 1.7));
					smoker.alpha = 0.3;
					smoker.animation.addByPrefix('garsmoke', "smokey", 13);
					smoker.animation.play('garsmoke');
					smoker.scrollFactor.set(0.7, 0.7);
					add(smoker);

					var bgAlley:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('garcello/garStagealt'));
					bgAlley.antialiasing = true;
					bgAlley.scrollFactor.set(0.9, 0.9);
					bgAlley.active = false;
					add(bgAlley);

					var corpse:FlxSprite = new FlxSprite(-230, 540).loadGraphic(Paths.image('garcello/gardead'));
					corpse.antialiasing = true;
					corpse.scrollFactor.set(0.9, 0.9);
					corpse.active = false;
					add(corpse);

			}

			case 'acrimony':
			{
				curStage = 'acrimony';

				defaultCamZoom = 0.98;

				var schoolBg:FlxSprite = new FlxSprite(-550, -900).loadGraphic(Paths.image('maginage/Schoolyard'));
				schoolBg.antialiasing = true;
				schoolBg.scrollFactor.set(0.85, 0.98);
				schoolBg.setGraphicSize(Std.int(schoolBg.width * 0.65));
				schoolBg.updateHitbox();
				add(schoolBg);

				modCrowdBig = new FlxSprite(-290, 55);
				modCrowdBig.frames = Paths.getSparrowAtlas('maginage/Crowd2');
				modCrowdBig.animation.addByPrefix('bop', 'Crowd2_Idle', 24, false);
				modCrowdBig.antialiasing = true;
				modCrowdBig.scrollFactor.set(0.9, 0.95);
				modCrowdBig.updateHitbox();
				add(modCrowdBig);
			}

			case 'churchruv':
			{
				defaultCamZoom = 0.7;
				curStage = 'churchruv';
				bg = new FlxSprite(-500, -850).loadGraphic(Paths.image('sacredmass/churchruv/bg'));
				bg.setGraphicSize(Std.int(bg.width * 1.2));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var floor:FlxSprite = new FlxSprite(-500, -850).loadGraphic(Paths.image('sacredmass/churchruv/floor'));
				floor.setGraphicSize(Std.int(floor.width * 1.2));
				floor.updateHitbox();
				floor.antialiasing = true;
				floor.scrollFactor.set(0.9, 0.9);
				floor.active = false;
				add(floor);

				var pillars:FlxSprite = new FlxSprite(-500, -850).loadGraphic(Paths.image('sacredmass/churchruv/pillars'));
				pillars.setGraphicSize(Std.int(pillars.width * 1.2));
				pillars.updateHitbox();
				pillars.antialiasing = true;
				pillars.scrollFactor.set(0.9, 0.9);
				pillars.active = false;
				add(pillars);

				pillarbroke = new FlxSprite(-500, -800).loadGraphic(Paths.image('sacredmass/churchruv/pillarbroke'));
				pillarbroke.setGraphicSize(Std.int(pillarbroke.width * 1.2));
				pillarbroke.updateHitbox();
				pillarbroke.antialiasing = true;
				pillarbroke.scrollFactor.set(0.9, 0.9);
				pillarbroke.active = false;
			}

			case 'churchselever':
			{
				defaultCamZoom = 0.8;
				curStage = 'churchselever';
				bg = new FlxSprite(-500, -850).loadGraphic(Paths.image('sacredmass/churchselever/bg'));
				bg.setGraphicSize(Std.int(bg.width * 1.2));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var floor:FlxSprite = new FlxSprite(-500, -850).loadGraphic(Paths.image('sacredmass/churchselever/floor'));
				floor.setGraphicSize(Std.int(floor.width * 1.2));
				floor.updateHitbox();
				floor.antialiasing = true;
				floor.scrollFactor.set(0.9, 0.9);
				floor.active = false;
				add(floor);

				var pillars:FlxSprite = new FlxSprite(-500, -850).loadGraphic(Paths.image('sacredmass/churchselever/pillars'));
				pillars.setGraphicSize(Std.int(pillars.width * 1.2));
				pillars.updateHitbox();
				pillars.antialiasing = true;
				pillars.scrollFactor.set(0.9, 0.9);
				pillars.active = false;
				add(pillars);
			}

			case 'churchsarv':
			{
				defaultCamZoom = 0.7;
				curStage = 'churchsarv';
				bg = new FlxSprite(-500, -850).loadGraphic(Paths.image('sacredmass/churchsarv/bg'));
				bg.setGraphicSize(Std.int(bg.width * 1.2));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var floor:FlxSprite = new FlxSprite(-500, -850).loadGraphic(Paths.image('sacredmass/churchsarv/floor'));
				floor.setGraphicSize(Std.int(floor.width * 1.2));
				floor.updateHitbox();
				floor.antialiasing = true;
				floor.scrollFactor.set(0.9, 0.9);
				floor.active = false;
				add(floor);

				var pillars:FlxSprite = new FlxSprite(-500, -850).loadGraphic(Paths.image('sacredmass/churchsarv/pillars'));
				pillars.setGraphicSize(Std.int(pillars.width * 1.2));
				pillars.updateHitbox();
				pillars.antialiasing = true;
				pillars.scrollFactor.set(0.9, 0.9);
				pillars.active = false;
				add(pillars);

				if (SONG.song.contains('Worship') || SONG.song == 'Lament')
				{
					pillars.color = 0xFFD6ABBF;
					floor.color = 0xFFD6ABBF;
					bg.color = 0xFFD6ABBF;
				}
			}

			case 'churchgospel':
			{
				defaultCamZoom = 0.7;
				curStage = 'churchgospel';

				var blackbg:FlxSprite = new FlxSprite(-500, -850).loadGraphic(Paths.image('sacredmass/churchgospel/blackbg'));
				blackbg.setGraphicSize(Std.int(blackbg.width * 1.2));
				blackbg.updateHitbox();
				blackbg.antialiasing = true;
				blackbg.scrollFactor.set(0.9, 0.9);
				blackbg.active = false;
				add(blackbg);

				circ0 = new FlxSprite(-500, -850).loadGraphic(Paths.image('sacredmass/churchgospel/circ0'));
				circ0.setGraphicSize(Std.int(circ0.width * 1.2));
				circ0.updateHitbox();
				circ0.antialiasing = true;
				circ0.scrollFactor.set(0.9, 0.9);
				circ0.active = false;
				add(circ0);

				circ1new = new FlxSprite(288, -459).loadGraphic(Paths.image('sacredmass/churchgospel/circ1new'));
				circ1new.setGraphicSize(Std.int(circ1new.width * 1.2));
				circ1new.updateHitbox();
				circ1new.antialiasing = true;
				circ1new.scrollFactor.set(0.9, 0.9);
				circ1new.active = false;	
				add(circ1new);

				circ2 = new FlxSprite(-500, -850).loadGraphic(Paths.image('sacredmass/churchgospel/circ2'));
				circ2.setGraphicSize(Std.int(circ2.width * 1.2));
				circ2.updateHitbox();
				circ2.antialiasing = true;
				circ2.scrollFactor.set(0.9, 0.9);
				circ2.active = false;
				add(circ2);

				bg = new FlxSprite(-500, -850).loadGraphic(Paths.image('sacredmass/churchgospel/bg'));
				bg.setGraphicSize(Std.int(bg.width * 1.2));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var floor:FlxSprite = new FlxSprite(-500, -850).loadGraphic(Paths.image('sacredmass/churchgospel/floor'));
				floor.setGraphicSize(Std.int(floor.width * 1.2));
				floor.updateHitbox();
				floor.antialiasing = true;
				floor.scrollFactor.set(0.9, 0.9);
				floor.active = false;
				add(floor);

				var pillars:FlxSprite = new FlxSprite(-500, -850).loadGraphic(Paths.image('sacredmass/churchgospel/pillars'));
				pillars.setGraphicSize(Std.int(pillars.width * 1.2));
				pillars.updateHitbox();
				pillars.antialiasing = true;
				pillars.scrollFactor.set(0.9, 0.9);
				pillars.active = false;
				add(pillars);
			}

			case 'kapistage':
			{
				defaultCamZoom = 0.9;
				curStage = 'kapistage';
				bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('kapistageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('kapistagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);
			}

			case 'glitcher':
			{
				defaultCamZoom = 0.9;
				curStage = 'glitcher';

				glitcherBG = new FlxSprite(-600, -200).loadGraphic(Paths.image('hex/stageback_glitcher'));
				glitcherBG.antialiasing = true;
				glitcherBG.scrollFactor.set(0.9, 0.9);
				glitcherBG.active = false;
				add(glitcherBG);

				var glitcherFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('hex/stagefront_glitcher'));
				glitcherFront.setGraphicSize(Std.int(glitcherFront.width * 1.1));
				glitcherFront.updateHitbox();
				glitcherFront.antialiasing = true;
				glitcherFront.scrollFactor.set(0.9, 0.9);
				glitcherFront.active = false;
				add(glitcherFront);

				wireBG = new FlxSprite(-600, -200).loadGraphic(Paths.image('hex/WIREStageBack'));
				wireBG.antialiasing = true;
				wireBG.scrollFactor.set(0.9, 0.9);
				wireBG.active = false;
				wireBG.alpha = 1;
				add(wireBG);
				
			}
			case 'curse':
			{
				defaultCamZoom = 0.8;
				curStage = 'curse';
				bg = new FlxSprite(-600, -300).loadGraphic(Paths.image('tabi/normal_stage'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);
			}
			case 'schoolnoon':
			{
				curStage = 'schoolnoon';

				defaultCamZoom = 1.05;

				bgSky = new FlxSprite().loadGraphic(Paths.image('corruption/weeb/weebSkynoon'));
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);

				bgSkyEvil = new FlxSprite().loadGraphic(Paths.image('corruption/weeb/weebSkyEvil'));
				bgSkyEvil.scrollFactor.set(0.1, 0.1);
				bgSkyEvil.alpha = 0;
				add(bgSkyEvil);

				var repositionShit = -200;

				bgSchool = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('corruption/weeb/weebSchoolnoon'));
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);

				bgSchoolEvil = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('corruption/weeb/weebSchoolEvil'));
				bgSchoolEvil.scrollFactor.set(0.6, 0.90);
				bgSchoolEvil.alpha = 0;
				add(bgSchoolEvil);


				bgStreet = new FlxSprite(repositionShit).loadGraphic(Paths.image('corruption/weeb/weebStreetnoon'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);

				bgStreetEvil = new FlxSprite(repositionShit).loadGraphic(Paths.image('corruption/weeb/weebStreetEvil'));
				bgStreetEvil.scrollFactor.set(0.95, 0.95);
				bgStreetEvil.alpha = 0;
				add(bgStreetEvil);

				fgTrees = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('corruption/weeb/weebTreesBacknoon'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);

				fgTreesEvil = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('corruption/weeb/weebTreesBackEvil'));
				fgTreesEvil.scrollFactor.set(0.9, 0.9);
				fgTreesEvil.alpha = 0;
				add (fgTreesEvil);

				bgTrees = new FlxSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('corruption/weeb/weebTreesnoon');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);

				var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('corruption/weeb/petalsnoon');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				add(treeLeaves);

				var widShit = Std.int(bgSky.width * 6);

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);
				bgSkyEvil.setGraphicSize(widShit);
				bgSchoolEvil.setGraphicSize(widShit);
				fgTreesEvil.setGraphicSize(Std.int(widShit * 0.8));
				bgStreetEvil.setGraphicSize(widShit);

				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();
				fgTreesEvil.updateHitbox();
				bgSkyEvil.updateHitbox();
				bgSchoolEvil.updateHitbox();
				bgStreetEvil.updateHitbox();
			}

			case 'koustage':
			{
				defaultCamZoom = 0.85;
				curStage = 'koustage';
				bg = new FlxSprite(-345, -265).loadGraphic(Paths.image('kou/koustage'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				iconBG = new HealthIcon(SONG.player2, false);
				iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
				iconBG.updateHitbox();
				iconBG.x = 200;
				iconBG.y = 200;
				iconBG.scrollFactor.set(0.9, 0.9);

				scope = new FlxSprite(-345, -265).loadGraphic(Paths.image('kou/kouscope'));
				scope.antialiasing = true;
				scope.scrollFactor.set(0.9, 0.9);
				scope.active = false;
				add(scope);
			}

			case 'auditorHell':
			{
				defaultCamZoom = 0.55;
				curStage = 'auditorHell';

				tstatic.antialiasing = true;
				tstatic.scrollFactor.set(0,0);
				tstatic.setGraphicSize(Std.int(tstatic.width * 8.3));
				tstatic.animation.add('static', [0, 1, 2], 24, true);
				tstatic.animation.play('static');

				tstatic.alpha = 0;

				var bg:FlxSprite = new FlxSprite(-10, -10).loadGraphic(Paths.image('tricky/fourth/bg'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 4));
				add(bg);

				hole.antialiasing = true;
				hole.scrollFactor.set(0.9, 0.9);
						
				converHole.antialiasing = true;
				converHole.scrollFactor.set(0.9, 0.9);
				converHole.setGraphicSize(Std.int(converHole.width * 1.3));
				hole.setGraphicSize(Std.int(hole.width * 1.55));

				cover.antialiasing = true;
				cover.scrollFactor.set(0.9, 0.9);
				cover.setGraphicSize(Std.int(cover.width * 1.55));
				add(cover);

				var energyWall:FlxSprite = new FlxSprite(1350,-690).loadGraphic(Paths.image("tricky/fourth/Energywall"));
				energyWall.antialiasing = true;
				energyWall.scrollFactor.set(0.9, 0.9);
				add(energyWall);
				
				var stageFront:FlxSprite = new FlxSprite(-350, -355).loadGraphic(Paths.image('tricky/fourth/daBackground'));
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.55));
				add(stageFront);

				daSign = new FlxSprite(0,0);

				daSign.frames = Paths.getSparrowAtlas('tricky/fourth/mech/Sign_Post_Mechanic');

				daSign.setGraphicSize(Std.int(daSign.width * 0.67));
				add(daSign);
				remove(daSign);
			}

			case 'stage' | 'holostage' | 'FNAFstage' | 'holostage-corrupt':
			{
				var stageShit:String ='';
				defaultCamZoom = 0.9;

				switch (SONG.stage)
				{
					case 'stage':
						curStage = 'stage';
						stageShit = '';
					case 'holostage':
						curStage = 'holostage';
						stageShit = 'holofunk/stage/';
					case 'FNAFstage':
						curStage = 'stage';
						stageShit = 'FNAF/';
					case 'holostage-corrupt':
						curStage = 'holostage-corrupt';
						stageShit = 'holofunk/stage/corrupt';
				}

				if (SONG.stage == 'holostage-corrupt')
				{
					bg2 = new FlxSprite(-600, -200).loadGraphic(Paths.image('holofunk/stage/eyes'));
					bg2.antialiasing = true;
					bg2.scrollFactor.set(0.9, 0.9);
					bg2.active = false;
					add(bg2);
				}
				
				bg = new FlxSprite(-600, -200).loadGraphic(Paths.image(stageShit+'stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image(stageShit+'stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image(stageShit+'stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				add(stageCurtains);
			}

			case 'cg5stage':
			{
				defaultCamZoom = 0.9;
				curStage = 'cg5stage';

				bg = new FlxSprite(-535, -166).loadGraphic(Paths.image('cg5/mixroom', 'week1'));
				bg.antialiasing = true;
				bg.setGraphicSize(Std.int(bg.width * 0.9));
				bg.updateHitbox();
				bg.scrollFactor.set(1, 0.9);
				bg.active = false;
				add(bg);
			}

			case 'staged2' | 'staged3':
			{
				var stageShit:String = '';
				
				if (SONG.stage == 'staged2')
				{
					stageShit = 'staged2';
					curStage = 'staged2';
				}
				else if (SONG.stage == 'staged3')
				{
					stageShit = 'staged3';
					curStage = 'staged3';
				}

				defaultCamZoom = 0.9;
				
				if (SONG.stage == 'staged3')
				{
					bg = new FlxSprite(-260, -220);
					bg.frames = Paths.getSparrowAtlas('corruption/staged3/stageback');
					bg.animation.addByPrefix('idle', 'stageback animated', 24, true);
					bg.setGraphicSize(Std.int(bg.width * 1.1));
					bg.updateHitbox();
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.animation.play('idle');
					add(bg);
				}	

				if (SONG.stage == 'staged2')
				{
					bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('corruption/staged2/stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var ladder:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('corruption/staged2/ladder'));
					ladder.antialiasing = true;
					ladder.scrollFactor.set(0.9, 0.9);
					ladder.active = false;
					add(ladder);
				}
				
				stageFront = new FlxSprite(-650, 600).loadGraphic(Paths.image('corruption/'+stageShit+'/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				stageCurtains = new FlxSprite(-500, -300).loadGraphic(Paths.image('corruption/'+stageShit+'/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
			}

			case 'ballisticAlley':
			{
				defaultCamZoom = 0.9;
				curStage = 'ballisticAlley';
				wBg = new FlxSprite(-500, -300).loadGraphic(Paths.image('whitty/whittyBack'));

				wBg.antialiasing = true;
				var bgTex = Paths.getSparrowAtlas('whitty/BallisticBackground');
				nwBg = new FlxSprite(-600, -200);
				nwBg.frames = bgTex;
				nwBg.antialiasing = true;
				nwBg.scrollFactor.set(0.9, 0.9);
				nwBg.active = true;
				nwBg.animation.addByPrefix('start', 'Background Whitty Start', 24, false);
				nwBg.animation.addByPrefix('gaming', 'Background Whitty Startup', 24, false);
				nwBg.animation.addByPrefix('gameButMove', 'Background Whitty Moving', 16, true);		
				add(nwBg);
				add(wBg);
				nwBg.alpha = 0;
				wstageFront = new FlxSprite(-650, 600).loadGraphic(Paths.image('whitty/whittyFront'));
				wstageFront.setGraphicSize(Std.int(wstageFront.width * 1.1));
				wstageFront.updateHitbox();
				wstageFront.antialiasing = true;
				wstageFront.scrollFactor.set(0.9, 0.9);
				wstageFront.active = false;
				add(wstageFront);
			}

			case 'day':
			{
					defaultCamZoom = 0.75;
					curStage = 'day';
					var bg1:FlxSprite = new FlxSprite(-970, -580).loadGraphic(Paths.image('day/BG1', 'shared'));
					bg1.antialiasing = true;
					bg1.scale.set(0.8, 0.8);
					bg1.scrollFactor.set(0.3, 0.3);
					bg1.active = false;
					add(bg1);

					var bg2:FlxSprite = new FlxSprite(-1240, -650).loadGraphic(Paths.image('day/BG2', 'shared'));
					bg2.antialiasing = true;
					bg2.scale.set(0.5, 0.5);
					bg2.scrollFactor.set(0.6, 0.6);
					bg2.active = false;
					add(bg2);

					mini = new FlxSprite(849, 189);
					mini.frames = Paths.getSparrowAtlas('day/mini','shared');
					mini.animation.addByPrefix('idle', 'mini', 24, false);
					mini.animation.play('idle');
					mini.scale.set(0.4, 0.4);
					mini.scrollFactor.set(0.6, 0.6);
					add(mini);

					mordecai = new FlxSprite(130, 160);
					mordecai.frames = Paths.getSparrowAtlas('day/bluskystv','shared');
					mordecai.animation.addByIndices('walk1', 'bluskystv', [29, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13] , '', 24, false);
					mordecai.animation.addByIndices('walk2', 'bluskystv', [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28] , '', 24, false);
					mordecai.animation.play('walk1');
					mordecai.scale.set(0.4, 0.4);
					mordecai.scrollFactor.set(0.6, 0.6);
					add(mordecai);

					var bg3:FlxSprite = new FlxSprite(-630, -330).loadGraphic(Paths.image('day/BG3', 'shared'));
					bg3.antialiasing = true;
					bg3.scale.set(0.8, 0.8);
					bg3.active = false;
					add(bg3);					
			}

			case 'room':
			{
				defaultCamZoom = 0.9;
				curStage = 'room';

				var sky:FlxSprite = new FlxSprite(100, 100).loadGraphic(Paths.image('philly/sky', 'week3'));
				sky.scrollFactor.set(1, 1);
				sky.setGraphicSize(Std.int(sky.width * 0.7));
				sky.updateHitbox();
				add(sky);

				var city:FlxSprite = new FlxSprite(190, 100).loadGraphic(Paths.image('philly/city', 'week3'));
				city.scrollFactor.set(1, 1);
				city.setGraphicSize(Std.int(city.width * 0.55));
				city.updateHitbox();
				add(city);

				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				add(phillyCityLights);

				for (i in 0...5)
				{
					var light:FlxSprite = new FlxSprite(city.x, city.y).loadGraphic(Paths.image('philly/win' + i, 'week3'));
					light.scrollFactor.set(1, 1);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.55));
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
				}

				bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('RoomBG'));
				bg.setGraphicSize(Std.int(bg.width * 1.8));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				tv = new FlxSprite(-370, 148).loadGraphic(Paths.image('tvLight'));
				tv.setGraphicSize(Std.int(tv.width * 1.8));
				tv.updateHitbox();
				tv.antialiasing = true;
				tv.scrollFactor.set(0.9, 0.9);
				tv.active = false;
				add(tv);
			}

			case 'gamer':
			{
				defaultCamZoom = 0.9;
				curStage = 'gamer';
				bg = new FlxSprite(-1130, -380).loadGraphic(Paths.image('liz/bgamser'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-730, -2012).loadGraphic(Paths.image('liz/bgMain'));
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				//stageFront.setGraphicSize(Std.int(stageFront.width * 0.95));
				//stageFront.updateHitbox();
				add(stageFront);

				zero16 = new FlxSprite(-387, 173);
				zero16.frames = Paths.getSparrowAtlas("liz/016_Assets");
				zero16.animation.addByPrefix("idle", "016 idle", 24, false);
				add(zero16);
			}

			case 'facility':
			{
				defaultCamZoom = 0.9;
				curStage = 'facility';
						
				fac_bg = new FlxSprite( -104.35, -108.25).loadGraphic(Paths.image("updike/wallbg"),true,2781,1631);
				fac_bg.animation.add("shitfart", [0], 0);
				fac_bg.animation.add("shitfartflip", [1], 1);
				fac_bg.animation.play("shitfart");
				headlight = new FlxSprite( 891.2, 166.75).loadGraphic(Paths.image("updike/light"));
				headlight.blend = "add";
						
				add(fac_bg);
				add(headlight);
			}

			case 'emptystage':
			{
				defaultCamZoom = 0.8;
				curStage = 'emptystage';
				bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('emptystageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var posX = 50;
				var posY = 200;

				//finalebgmybeloved
				space = new FlxBackdrop(Paths.image('monika/FinaleBG_1'));
				space.velocity.set(-10, 0);
				space.antialiasing = false;
				space.scrollFactor.set(0.1, 0.1);
				space.scale.set(1.65, 1.65);
				space.alpha = 0;
				add(space);

				bg2 = new FlxSprite(posX, posY).loadGraphic(Paths.image('monika/FinaleBG_2'));
				bg2.antialiasing = false;
				bg2.scale.set(2.3, 2.3);
				bg2.scrollFactor.set(0.4, 0.6);
				bg2.alpha = 0;
				add(bg2);

				stageFront2 = new FlxSprite(posX - 50, posY).loadGraphic(Paths.image('monika/FinaleFG'));
				stageFront2.antialiasing = false;
				stageFront2.scale.set(1.5, 1.5);
				stageFront2.scrollFactor.set(1, 1);
				stageFront2.alpha = 0;
				add(stageFront2);

				monikaFinaleBG = new FlxSprite(165, 0);
				monikaFinaleBG.frames = Paths.getSparrowAtlas('monika/Monika_Finale_BG');
				monikaFinaleBG.animation.addByPrefix('idle', 'MONIKA IDLE', 24, false);
				monikaFinaleBG.antialiasing = false;
				monikaFinaleBG.setGraphicSize(Std.int(monikaFinaleBG.width * 7));
				monikaFinaleBG.updateHitbox();
				monikaFinaleBG.scrollFactor.set(1, 1);
				monikaFinaleBG.alpha = 0;
				add(monikaFinaleBG);

				bobmadshake = new FlxSprite( -198, -118);
				bobmadshake.frames = Paths.getSparrowAtlas('bobscreen');
				bobmadshake.animation.addByPrefix('idle', 'BobScreen', 24);
				bobmadshake.scrollFactor.set(0, 0);
				bobmadshake.visible = false;
				
				bobsound = new FlxSound().loadEmbedded(Paths.sound('bobscreen'));
				FlxG.sound.list.add(bobsound);
				shut = new FlxSound().loadEmbedded(Paths.sound('Lights_Shut_off_new'));
				FlxG.sound.list.add(shut);
				giggle = new FlxSound().loadEmbedded(Paths.sound('monikagiggle')); 
				FlxG.sound.list.add(giggle);
			}

			case 'school-monika-finale':
			{
				curStage = 'school-monika-finale';

				defaultCamZoom = 0.9;

				var posX = 50;
				var posY = 200;

				space = new FlxBackdrop(Paths.image('monika/FinaleBG_1'));
				space.velocity.set(-10, 0);
				space.antialiasing = false;
				space.scrollFactor.set(0.1, 0.1);
				space.scale.set(1.65, 1.65);
				add(space);

				bg2 = new FlxSprite(70, posY).loadGraphic(Paths.image('monika/FinaleBG_2'));
				bg2.antialiasing = false;
				bg2.scale.set(2.3, 2.3);
				bg2.scrollFactor.set(0.4, 0.6);
				add(bg2);

				stageFront2 = new FlxSprite(posX, posY).loadGraphic(Paths.image('monika/FinaleFG'));
				stageFront2.antialiasing = false;
				stageFront2.scale.set(1.5, 1.5);
				stageFront2.scrollFactor.set(1, 1);
				add(stageFront2);
			}

			case 'mind':
            {
        		defaultCamZoom = 0.8;
				curStage = 'mind';

				var bg:FlxSprite = new FlxSprite(-600, -145).loadGraphic(Paths.image('corruption/tormentor/TormentorBG'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var funnytv:FlxSprite = new FlxSprite(120, 145);
				funnytv.frames = Paths.getSparrowAtlas('corruption/tormentor/TormentorStatic');
				funnytv.animation.addByPrefix('idle', 'Tormentor Static', 24);
				funnytv.animation.play('idle');
				funnytv.scrollFactor.set(0.9, 0.9);
				funnytv.setGraphicSize(Std.int(funnytv.width * 1.3));
				add(funnytv);
            }

			case 'emptystage2':
			{
				defaultCamZoom = 0.8;
				curStage = 'emptystage2';
				bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('emptystageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);
			}

			case 'polus':
			{
				defaultCamZoom = 0.9;
				curStage = 'polus';

				var sky:FlxSprite = new FlxSprite(-834.3, -620.5).loadGraphic(Paths.image('polus/polusSky'));
				sky.antialiasing = true;
				sky.scrollFactor.set(0.5, 0.5);
				sky.active = false;
				add(sky);		

				var rocks:FlxSprite = new FlxSprite(-915.8, -411.3).loadGraphic(Paths.image('polus/polusrocks'));
				rocks.updateHitbox();
				rocks.antialiasing = true;
				rocks.scrollFactor.set(0.6, 0.6);
				rocks.active = false;
				add(rocks);	
				
				var hills:FlxSprite = new FlxSprite(-1238.05, -180.55).loadGraphic(Paths.image('polus/polusHills'));
				hills.updateHitbox();
				hills.antialiasing = true;
				hills.scrollFactor.set(0.9, 0.9);
				hills.active = false;
				add(hills);

				var warehouse:FlxSprite = new FlxSprite(-458.35, -315.6).loadGraphic(Paths.image('polus/polusWarehouse'));
				warehouse.updateHitbox();
				warehouse.antialiasing = true;
				warehouse.scrollFactor.set(0.9, 0.9);
				warehouse.active = false;
				add(warehouse);

				var ground:FlxSprite = new FlxSprite(-580.9, 241.85).loadGraphic(Paths.image('polus/polusGround'));
				ground.updateHitbox();
				ground.antialiasing = true;
				ground.scrollFactor.set(1, 1);
				ground.active = false;
				add(ground);
			}		

			case 'momiStage':
			{
				defaultCamZoom = 0.9;
				curStage = 'momiStage';
				var bg:FlxSprite = new FlxSprite(-175.3, -225.95).loadGraphic(Paths.image('momi/bg'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 1);
				bg.active = false;
				add(bg);
				FlxG.sound.cache(Paths.sound("carPass1"));
					
				dust = new FlxSprite( -238.3, 371.55);
				dust.frames = Paths.getSparrowAtlas("momi/dust");
				dust.animation.addByPrefix("bop", "dust", 24, false);
				dust.scrollFactor.set(1.2, 1.2);
				dust.visible = false;
				dust.animation.play("bop");
					
				car = new FlxSprite( -1514.4, 199.8);
				car.scrollFactor.set(1.2,1.2);
				car.frames = Paths.getSparrowAtlas("momi/car");
				car.animation.addByPrefix("go", "car", 24, false);
				car.visible = true;
				car.animation.play("go");
				if(SONG.song.toLowerCase() == "gura-nazel")dust.visible = true;
			}

			case 'prologue':
			{
				curStage = 'prologue';

				defaultCamZoom = 0.9;

				var bg:FlxSprite = new FlxSprite(-100, -100).loadGraphic(Paths.image('prologue/rooftopsky'));
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('prologue/distantcity'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				prologueLights = new FlxTypedGroup<FlxSprite>();
				add(prologueLights);

				for (i in 0...5)
				{
						var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('prologue/win' + i));
						light.scrollFactor.set(0.3, 0.3);
						light.visible = false;
						light.setGraphicSize(Std.int(light.width * 0.85));
						light.updateHitbox();
						light.antialiasing = true;
						prologueLights.add(light);
				}

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('prologue/poll'));
				add(streetBehind);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);
					
				var street:FlxSprite = new FlxSprite(-130, streetBehind.y).loadGraphic(Paths.image('prologue/rooftop'));
						add(street);
				}	
				  
			case 'mackiestage':
			{
				curStage = 'mackiestage';

				defaultCamZoom = 0.60;

				var mackiebg:FlxSprite = new FlxSprite(-2150, -1000).loadGraphic(Paths.image('mackie/citybgtwo'));
				mackiebg.antialiasing = true;
				mackiebg.active = false;
				mackiebg.updateHitbox();
				mackiebg.scrollFactor.set(0.1, 0.1);
				mackiebg.scale.set(0.8, 0.8);
				add(mackiebg);

				var mackiemid:FlxSprite = new FlxSprite(-600, -40).loadGraphic(Paths.image('mackie/citymid'));
				mackiemid.antialiasing = true;
				mackiemid.active = false;
				mackiemid.updateHitbox();
				mackiemid.scrollFactor.set(0.8, 0.8);
				add(mackiemid);

				var mackieinterior:FlxSprite = new FlxSprite(-1300, -400).loadGraphic(Paths.image('mackie/interior'));
				mackieinterior.antialiasing = true;
				mackieinterior.active = false;
				mackieinterior.updateHitbox();
				mackieinterior.scrollFactor.set(0.95, 0.95);
				add(mackieinterior);

				alya = new FlxSprite(-900, 150);
				alya.frames = Paths.getSparrowAtlas('mackie/alyabob');
				alya.animation.addByPrefix('alyabob', 'alya bob', 24, false);
				alya.antialiasing = true;
				alya.scrollFactor.set(0.95, 0.95);
				add(alya);

				var mackiecity:FlxSprite = new FlxSprite(-2470, -1140).loadGraphic(Paths.image('mackie/mackiecity'));
				mackiecity.antialiasing = true;
				mackiecity.active = false;
				mackiecity.updateHitbox();
				add(mackiecity);

				tricky = new FlxSprite(1400, 722);
				tricky.frames = Paths.getSparrowAtlas('mackie/sewertricky');
				tricky.animation.addByPrefix('trickybob', 'sewertricky', 24, false);
				tricky.antialiasing = true;
				add(tricky);

				bgcrowd = new FlxSprite(-1020, 460);
				bgcrowd.frames = Paths.getSparrowAtlas('mackie/crowdbob');
				bgcrowd.animation.addByPrefix('bob', 'crowd bob', 24, false);
				bgcrowd.antialiasing = true;
				add(bgcrowd);

				bgcrowdjump = new FlxSprite(-1020, 460);
				bgcrowdjump.frames = Paths.getSparrowAtlas('mackie/crowdjump');
				bgcrowdjump.animation.addByPrefix('jump', 'crowd jump', 24, false);
				bgcrowdjump.antialiasing = true;

				anchor = new FlxSprite(-720, 22);
				anchor.frames = Paths.getSparrowAtlas('mackie/anchor');
				anchor.animation.addByPrefix('anchorbob', 'anchorbob', 24, false);
				anchor.antialiasing = true;
				add(anchor);
			}

			case 'FMMstage' | 'FMMstagedusk' | 'FMMstagenight':
			{
				var time:String = '';

				defaultCamZoom = 0.6;
				curStage = 'FMMstage';

				switch (SONG.stage)
				{
					case 'FMMstage':
						time = 'Day';
					case 'FMMstagedusk':
						time = 'Dusk';
					case 'FMMstagenight':
						time = 'Night';
				}
				var bg:FlxSprite = new FlxSprite(-1000, -350).loadGraphic(Paths.image('FMMStage/FMM'+time+'BG'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				add(bg);

				var FMMBuildings:FlxSprite = new FlxSprite(-1290, -380).loadGraphic(Paths.image('FMMStage/FMM'+time+'Buildings'));
				FMMBuildings.setGraphicSize(Std.int(FMMBuildings.width * 1.1));
				FMMBuildings.updateHitbox();
				FMMBuildings.antialiasing = true;
				FMMBuildings.scrollFactor.set(0.7, 0.7);
				FMMBuildings.active = false;
				add(FMMBuildings);	

				var FMMRail:FlxSprite = new FlxSprite(-1290, -490).loadGraphic(Paths.image('FMMStage/FMM'+time+'Rail'));
				FMMRail.setGraphicSize(Std.int(FMMRail.width * 1.1));
				FMMRail.updateHitbox();
				FMMRail.antialiasing = true;
				FMMRail.scrollFactor.set(0.8, 0.8);
				FMMRail.active = false;
				add(FMMRail);	

				var FMMFront:FlxSprite = new FlxSprite(-1290, -475).loadGraphic(Paths.image('FMMStage/FMM'+time+'Front'));
				FMMFront.setGraphicSize(Std.int(FMMFront.width * 1.1));
				FMMFront.updateHitbox();
				FMMFront.antialiasing = true;
				FMMFront.scrollFactor.set(0.9, 0.9);
				FMMFront.active = false;
				add(FMMFront);	
			}

			case 'zardymaze':
			{
				defaultCamZoom = 0.9;
				curStage = 'zardymaze';
				zardyBackground = new FlxSprite(-600, -200);
				zardyBackground.frames = Paths.getSparrowAtlas('zardy/Maze', 'shared');
				zardyBackground.animation.addByPrefix('Maze','Stage', 16);
				zardyBackground.antialiasing = true;
				zardyBackground.scrollFactor.set(0.9, 0.9);
				zardyBackground.animation.play('Maze');
				add(zardyBackground);
			}
			default:
			{
				defaultCamZoom = 0.9;
				curStage = 'stage';
				bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				add(stageCurtains);
			}
		}

		//defaults if no gf was found in chart
		var gfCheck:String = 'gf';
		
		if (SONG.gfVersion == null) {
			switch(storyWeek)
			{
				case 4: gfCheck = 'gf-car';
				case 5: gfCheck = 'gf-christmas';
				case 6: gfCheck = 'gf-pixel';
			}
		} else {gfCheck = SONG.gfVersion;}

		var gfVersion:String = 'gf';

		switch (SONG.gfVersion)
		{
			default:
				gfVersion = SONG.gfVersion;
		}

		if (FileSystem.exists(Paths.txt(songLowercase  + "/preload")))
		{
			var characters:Array<String> = CoolUtil.coolTextFile2(Paths.txt(songLowercase  + "/preload"));

			for (i in 0...characters.length)
			{
				var data:Array<String> = characters[i].split(' ');
				dad = new Character (0, 0, data[0]);
				trace ('found ' + data[0]);
			}
		}

		trace("my good sir your problem is in character.hx");
		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);
		
		trace("maybe not");

		switch(SONG.gfVersion)
		{
			case 'gf-peri-whitty':
				gf.y -= 80;
				gf.x -= 230;
			case 'gf-tankman':
				gf.x -= 190;
			case 'gf-sarv':
				gf.x -= 150;
				gf.y -= 150;
			case 'gf-bf-radio':
				gf.x -= 20;
		}

		switch (curStage)
		{
			case 'alleysoft':
				gf.y -= 50;
		}

		dad = new Character(100, 100, SONG.player2);
		trace('found dad character');

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf' | 'gf-crucified' | 'gf1' | 'gf2' | 'gf3' | 'gf4' | 'gf5':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case "spooky" | "gura-amelia" | "sunday":
				dad.y += 200;
			case "mia" | 'mia-lookstraight' | 'mia-wire':
				dad.x += 100;
				dad.y += 150;
			case 'duet-sm':
				dad.x += 150;
				dad.y += 380;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'cj-ruby' | 'cj-ruby-both':
				dad.x -= 50;
			case 'isa':
				dad.x += 20;
				dad.y -= 50;
				camPos.set(dad.getMidpoint().x + 170, dad.getMidpoint().y - 100);
			case 'tordbot':
				dad.x += 330;
				dad.y -= 1524.75;
				camPos.set(391.2, -1094.15);
			case "hex-virus" | "agoti-wire" | 'agoti-glitcher' | 'agoti-mad' | 'haachama':
				dad.y += 100;
			case "rebecca":
				if (!curStage.contains('hungryhippo'))
				{	
					dad.y += 100;
				}
				camPos.y += 500;
				camPos.set(dad.getMidpoint().x + 150, dad.getMidpoint().y + 100);
			case "whittyCrazy":
				dad.x -= 25;
			case "tankman":
				dad.y += 180;
			case "sarvente-dark" | 'sarvente' | 'ruv':
				dad.y -= 70;
			case 'monster-christmas' | 'monster' | 'drunk-annie' | 'taki':
				dad.y += 130;
			case 'dad' | 'shaggy' | 'hd-senpai' | 'lila':
				camPos.x += 400;
			case 'dad-mad':
				dad.x -= 30;
				dad.y -= 10;
				camPos.x += 400;
			case 'bf-blantad':
				dad.y -= 75;
			case 'pico' | 'annie-bw' | 'phil' | 'alya' | 'picoCrazy':
				camPos.x += 600;
				dad.y += 300;
				camPos.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			case 'bob2' | 'peri':
				dad.y += 50;
			case 'bosip' | 'demoncass':
				dad.y -= 50;
			case 'botan':
				dad.y += 185;
				camPos.set(dad.getGraphicMidpoint().x, dad.getMidpoint().y);
			case 'neko-crazy':
                dad.x -= 50;
                dad.y += 230;
                camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'kou' | 'nene' | 'liz' | 'bf-annie' | 'bf-carol':
				camPos.x += 600;
				dad.y += 300;
			case 'bf' | 'bf-frisk' | 'bf-gf':
				camPos.x += 600;
				dad.y += 350;
			case 'parents-christmas' | 'parents-christmas-soft':
				dad.x -= 500;
			case 'bico-christmas':
				dad.x -= 500;
				dad.y += 100;
			case 'senpai' | 'monika' | 'senpai-angry' | 'kristoph-angry' | 'senpai-giddy' | 'baldi-angry ' | 'mangle-angry' | 'monika-angry' | 'green-monika' | 'neon' | 'matt-angry' | 'jackson' | 'mario-angry' | 'colt-angryd2' | 'colt-angryd2corrupted':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'monika-finale':
				dad.x += 15;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'lane-pixel':
				dad.x += 150;
				dad.y += 560;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y - 200);
			case 'bf-gf-pixel' | 'bf-pixel' | 'bf-botan-pixel':
				dad.x += 150;
				dad.y += 460;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'bf-sky':
				dad.x -= 100;
				dad.y += 400;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'bf-whitty-pixel':
				dad.x += 150;
				dad.y += 400;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'gura-amelia-pixel':
				dad.x += 140;
				dad.y += 400;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'bitdad' | 'bitdadBSide' | 'bitdadcrazy':
				dad.y += 75;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit' | 'spirit-glitchy':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y + 200);
			case 'sky-annoyed':
				dad.y -= 20;
			case 'impostor':
				camPos.y += -200;
				camPos.x += 400;
				dad.y += 390;
				dad.x -= 100;
			case 'updike':
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'bob' | 'angrybob':
				camPos.x += 600;
				dad.y += 280;	
			case 'cjClone':
				dad.x -= 250;
				dad.y -= 150;			
				if (SONG.song.toLowerCase() == 'expurgation')
				{
					dad.visible = false;
					gf.x += 300;
					gf.y -= 25;
				}			
			case 'momi':
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				dad.y += 50;
			case 'rosie' | 'rosie-angry' | 'rosie-furious':
				dad.y += 100;
			case 'sh-carol' | 'sarvente-lucifer':
				dad.x -= 70;
				dad.y -= 275;
			case 'garcello' | 'garcellotired' | 'garcellodead':
				dad.x -= 100;
			case 'lucian':
				dad.x -= 30;
				dad.y -= 60;
				camPos.x += 300;
				camPos.y -= 15;
			case 'abby':
				dad.x -= 157;
				dad.y += 202;
				camPos.x += 300;
				camPos.y -= 15;
			case 'abby-mad':
				dad.x -= 24;
				dad.y += 260;
				camPos.x += 300;
				camPos.y -= 15;
			case 'roro':
				dad.x -= 500;
			case 'zardy':
				camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 240);
				dad.x -= 80;
		}

		if (!curStage.contains('school'))
		{
			switch (SONG.player2)
			{
				case 'bf-pixel' | 'bf-pixeld4BSide' | 'bf-pixeld4':
					dad.x += 300;
					dad.y += 150;
				case 'senpai' | 'senpai-giddy' | 'senpai-angry' | 'monika' | 'monika-angry':
					dad.x += 150;
					dad.y -= 50;
					camPos.set(dad.getMidpoint().x - 100, dad.getMidpoint().y - 430);
			}
		}
		
		boyfriend = new Boyfriend(770, 450, SONG.player1);
		trace('found boyfriend character');

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'prologue':
				dad.y += 50;
				boyfriend.y += 80;

			case 'room':
				dad.x += 20;
				dad.y += 70;
				boyfriend.x += 120;
				boyfriend.y += 70;

			case 'limo' | 'limoholo' | 'limoholo-night':
				boyfriend.y -= 250;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall' | 'mallSoft':
				boyfriend.x += 230;

			case 'mallEvil' | 'mallAnnie':
				boyfriend.x += 320;
				dad.y -= 80;

			case 'school' | 'school-switch' | 'school-monika' | 'schoolnoon':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'tank':
				boyfriend.x += 40;
				gf.x += 10;
				gf.y -= 30;
				dad.x -= 80;
				dad.y += 60;
			case 'garStage' | 'eddhouse2' | 'garStageRise' | 'garStageDead':
				boyfriend.x += 100;
			case 'hungryhippo' | 'hungryhippo-blantad':
				dad.y += 150;
				if (SONG.song.toLowerCase() == 'hunger')
				{
					boyfriend.x += 100;
					boyfriend.y += 210;
				}
			case 'emptystage2':
				boyfriend.x += 100;
				dad.x -= 100;
			case 'throne':
				boyfriend.x += 100;
				dad.x -= 180;
				gf.x -= 107;
				gf.y -= 23;
			case 'eddhouse':
				boyfriend.x = 1096.1;
				boyfriend.y = 271.7;
				gf.x = 750;
				gf.y = 215;
			case 'manifest':
				dad.x += 20;
				dad.y -= 5;
				boyfriend.x += 60;
				boyfriend.y -= 185;
				gf.x += 80;
				gf.y -= 185;
			case 'glitcher':
				boyfriend.x += 150;
				dad.x -= 100;
			case 'momiStage':
				boyfriend.x += 160;
				boyfriend.y -= 100;
				gf.x += 60;
				gf.y -= 118;
				dad.x -= 33;
				dad.y -= 82;
			case 'day' | 'sunset':
				dad.x -= 150;
				dad.y -= 11;
				boyfriend.x += 191;
				boyfriend.y -= 20;
				gf.x -= 70;
				gf.y -= 50;
				camPos.x = 536.63;
				camPos.y = 449.94;
			
			case 'schoolEvil' | 'schoolEvild4':
				evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				add(evilTrail);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;

			case 'curse':
				boyfriend.setZoom(1.1);
				if (!dad.curCharacter.contains('tabi'))
				{
					dad.setZoom(1.1);
				}
				if (curSong == 'Their-Battle')
				{
					gf.setZoom(1.2);
				}
				else
				{
					gf.setZoom(1.1);
				}
				boyfriend.x += 300;
				dad.x -= 400;
				gf.y -= 110;
				gf.x -= 50;
			
			case 'skybroke':
				boyfriend.x += 60;
				boyfriend.y -= 145;
				dad.x -= 170;
				gf.x -= 40;
				gf.y -= 170;

			case 'polus':
				dad.x -= 270;
				dad.y -= 240;
				gf.x -= 200;
				gf.y -= 235;
				boyfriend.x -= 20;
				boyfriend.y -= 230;

			case 'auditorHell':
				boyfriend.y -= 160;
				boyfriend.x += 350;

			case 'shaggy-mansion':
				boyfriend.x += 100;

			case 'churchsarv' | 'churchruv' | 'churchselever' | 'churchgospel':
				gf.x -= 100;
				gf.y -= 70;
				dad.x -= 100;
				dad.y += 100;
				boyfriend.x += 100;
				boyfriend.y += 100;
				gf.scale.set(0.9, 0.9);

			case 'mind':
				boyfriend.x -= -200;
				boyfriend.y += 270;
				dad.x -= 120;
				dad.y += 220;

			case 'facility':
				boyfriend.x += 660;
				boyfriend.y += 230;
				gf.x += 575;
				gf.y += 430;
				dad.x += 310;
				dad.y += 250;
				gf.scrollFactor.set(1, 1);

			case 'garage':
				boyfriend.x = 799;
				boyfriend.y = 288;
				gf.x += 180;
				gf.y = -800;
				dad.x += 20;
				camPos.set(dad.getGraphicMidpoint().x + 200, dad.getGraphicMidpoint().y +20);

			case 'mackiestage':
				dad.x -= 300;
				boyfriend.x += 300;

			case 'takiStage':
				boyfriend.x += 500;
				boyfriend.y += 200;
				gf.x += 300;
				gf.y += 80;
				if (dad.curCharacter.startsWith('gf'))
				{
					dad.x += 300;
					dad.y += 80;
				}
				gf.scrollFactor.set(1.0, 1.0);
			case 'school-monika-finale':
				dad.y -= 69;
				dad.x += 300;
				boyfriend.x += 200;
				boyfriend.y += 260;
				gf.x += 180;
				gf.y += 300;
			case 'cg5stage':
				boyfriend.x += 100;
				boyfriend.y += 100;
				dad.x -= 50;
				dad.y += 100;
			case 'maginageAcrimony':
				boyfriend.x += 70;
				gf.x += 67;
				gf.y += 430;
				dad.x -= 40;
			case 'FMMstage':
				boyfriend.x += 280;
				boyfriend.y += 50;
				dad.x -= 315;
				dad.y += 50;
				gf.x -= 140;
				gf.y -= 50;	
			case 'zardymaze':
				dad.y += 140;
				gf.y += 140;
				boyfriend.x += 80;
				boyfriend.y += 140;			
		}

		switch (SONG.player1)
		{
			case 'mia' | 'mia-lookstraight' | 'mia-wire':
				boyfriend.x += 100;
				boyfriend.y -= 200;
			case 'impostor':
				camPos.y += -200;
				camPos.x -= 400;
				boyfriend.y += 40;
				boyfriend.x -= 100;
			case 'pico' | 'annie-bw' | 'kou' | 'phil' | 'nene':
				boyfriend.x += 40;
				boyfriend.y -= 75;
			case 'bf-demoncesar':
				boyfriend.x += 60;
				boyfriend.y  -= 50;
			case 'bf-cesar':
				boyfriend.x += 105;
				boyfriend.y -= 50;
			case 'monster' | 'monster-christmas':
				boyfriend.x += 100;
				boyfriend.y -= 250;
				camPos.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			case 'haachama' | 'opheebop':
				boyfriend.x += 50;
				boyfriend.y -= 250;
			case 'senpai' | 'senpai-giddy' | 'monika' | 'senpai-angry' | 'colt-angry' | 'miku-pixel' | 'mangle-angry' | 'monika-angry' | 'mario-angry' | 'jackson' | 'matt-angry' | 'monster-pixel':
				boyfriend.y -= 200;
			case 'bf-whitty-pixel':
				boyfriend.y -= 170;
			case "gura-amelia" | "spooky":
				boyfriend.y -= 150;
			case 'bf-mom' | 'blantad-new' | 'blantad-watch' | 'bf-mom-car' | 'blantad-blue':
				boyfriend.y -= 350;
			case 'bana':
				boyfriend.y -= 260;
			case 'cassandra':
				boyfriend.y -= 330;
			case 'anchor':
				boyfriend.y -= 400;
			case 'tom2' | 'tord2' | 'matt2' | 'edd2' | 'garcello' | 'garcellotired' | 'garcellodead':
				boyfriend.x -= 100;
				boyfriend.y -= 350;
			case 'tabi-wire' | 'tabi-glitcher' | 'tabi':
				boyfriend.y -= 350;
			case 'bf-exgf':
				boyfriend.x += 50;
				boyfriend.y -= 400;
			case 'bf-blantad' | 'bb':
				boyfriend.y -= 400;
			case 'mom-car' | 'dad' | 'mom' | 'hex' | 'hd-senpai' | 'hd-senpaiangry' | 'bf-senpai-worried' | 'parents-christmas' | 'henry-blue' | 'whitty':
				boyfriend.y -= 350;
			case 'sarvente' | 'ruv':
				boyfriend.y -= 350;
			case 'sarv-ruv' | 'sarv-ruv-both':
				boyfriend.y -= 350;
				boyfriend.x -= 100;
			case 'sky-mad':
				boyfriend.x -= 50;
				boyfriend.y -= 180;
			case 'botan':
				boyfriend.x += 40;
				boyfriend.y -= 75;
			case 'bob':
				boyfriend.y -= 300;
			case 'henry-angry':
				boyfriend.y -= 70;
			case 'bosip':
				boyfriend.y -= 400;
			case 'bf-botan-pixel':
				boyfriend.x += 40;
				boyfriend.y -= 90;
			case 'liz':
				boyfriend.x += 40;
				boyfriend.y -= 25;
			case 'selever':
				boyfriend.x += 40;
				boyfriend.y -= 375;
				camPos.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			case 'cj-ruby':
				boyfriend.y -= 350;
			case 'bf-pump':
				boyfriend.y += 50;
			case 'tord' | 'tom':
				boyfriend.y -= 200;
			case 'tankman' | 'bf-senpai-tankman':
				boyfriend.y -= 150;
			case 'ruby-worried':
				boyfriend.y -= 510;
				boyfriend.x += 200;
			case 'ruby' | 'ruby-worried-night':
				boyfriend.x += 100;
				boyfriend.y -= 350;
			case 'lucian':
				boyfriend.x += 30;
				boyfriend.y -= 410;
				camPos.x -= 300;
				camPos.y += 15;
			case 'sh-carol' | 'sarvente-lucifer':
				boyfriend.y -= 625;
		}

		if (!curStage.contains('school'))
		{
			switch (SONG.player1)
			{
				case 'bf-pixel' | 'bf-pixeld4BSide' | 'bf-pixeld4':
					boyfriend.x += 300;
					boyfriend.y += 150;
				case 'senpai' | 'senpai-giddy' | 'senpai-angry' | 'monika' | 'monika-angry':
					boyfriend.x += 100;
					boyfriend.y += 100;
			}
		}

		add(gf);

		switch (curStage)
		{
			case 'auditorHell':
				add(hole);
			case 'limo' | 'limoholo':
				add(limo);
			case 'limoholo-night':
				if (SONG.song.toLowerCase() == 'hands')
				{
					cloudGroup = new FlxTypedGroup<Cloud>(25);
					add(cloudGroup);
					add(limoOhNo);		
				}
				add(limo);				
			case 'churchruv':
				add(pillarbroke);
			case 'philly-wire':
				add(gfBG);
				add(gfBG2);
			case 'cg5stage':
				stageFront = new FlxSprite(-507, -117).loadGraphic(Paths.image('cg5/recordroom', 'week1'));
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(1, 0.9);
				stageFront.active = false;
				stageFront.setGraphicSize(Std.int(stageFront.width * 0.9));
				stageFront.updateHitbox();
				add(stageFront);

				stageFront2 = new FlxSprite(-507, -117).loadGraphic(Paths.image('cg5/room_lights', 'week1'));
				stageFront2.antialiasing = true;
				stageFront2.scrollFactor.set(1, 0.9);
				stageFront2.active = false;
				stageFront2.setGraphicSize(Std.int(stageFront2.width * 0.9));
				stageFront2.updateHitbox();
				add(stageFront2);
		}

		add(dad);
		add(boyfriend);

		switch (curStage)
		{
			case 'day':
				phillyTrain = new FlxSprite(200, 200).loadGraphic(Paths.image('day/PP_truck','shared'));
				phillyTrain.scale.set(1.2, 1.2);
				phillyTrain.visible = false;
				add(phillyTrain);
			case 'curse':
				var sumtable:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('tabi/sumtable'));
				sumtable.antialiasing = true;
				sumtable.scrollFactor.set(0.9, 0.9);
				sumtable.active = false;
				add(sumtable);
			case 'staged2' | 'staged3':
				add(stageCurtains);
			case 'momiStage':
				add(dust);
				add(car);
			case 'tank':
				add(tank0);
				add(tank1);
				add(tank2);
				add(tank4);
				add(tank5);
				add(tank3);
			case 'garage':
				add(glowShit);
				add(fret);
				if(fret != null)fret.cameras = [camHUD];
			case 'ballisticAlley':
				wBg.alpha = 0;
				nwBg.alpha = 1;
				funneEffect = new FlxSprite(-600, -200).loadGraphic(Paths.image('whitty/thefunnyeffect'));
				funneEffect.alpha = 0.5;
				funneEffect.scrollFactor.set();
				funneEffect.visible = true;
				add(funneEffect);
		
				funneEffect.cameras = [camHUD];

				trace('funne: ' + funneEffect);
				nwBg.animation.play("gameButMove");
				wstageFront.alpha = 0;
			case 'mallSoft':
				add(santa);
			case 'garStageDead':
				var smoke:FlxSprite = new FlxSprite(0, 0);
				smoke.frames = Paths.getSparrowAtlas('garcello/garSmoke');
				smoke.setGraphicSize(Std.int(smoke.width * 1.6));
				smoke.animation.addByPrefix('garsmoke', "smokey", 15);
				smoke.animation.play('garsmoke');
				smoke.scrollFactor.set(1.1, 1.1);
				add(smoke);
			case 'throne':
				add(bgcrowd);
			case 'polus':
				add(flashSprite);
				flashSprite.alpha = 0;
		}

		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			
			FlxG.save.data.botplay = true;
			FlxG.save.data.scrollSpeed = rep.replay.noteSpeed;
			FlxG.save.data.downscroll = rep.replay.isDownscroll;
			// FlxG.watch.addQuick('Queued',inputsQueued);
		}

		doof = new DialogueBox(false, dialogue);
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		doof2 = new DialogueBox(false, dialogue);
		doof2.scrollFactor.set();
		doof2.finishThing = doPicoCutscene;

		doof3 = new DialogueBox(false, extra2);
		doof3.scrollFactor.set();
		doof3.finishThing = startCountdown;

		doof4 = new DialogueBox(false, extra3);
		doof4.scrollFactor.set();
		doof4.finishThing = endSong;

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		add(grpNoteSplashes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		trace('generated');

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));	
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}
		switch (curSong.toLowerCase())
		{
			case 'storm':
				healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBarWhite'));
			case 'hunger' | 'aspirer':
				healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBarStarv'));
			case 'deathmatch-holo':
				healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBarCorrupt'));
			default:
				healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		}

		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();

		var changedBar:Bool = false;
		switch (curStage)
		{
			case 'garStage' | 'garStageDead' | 'garStageRise':
				healthBar.createFilledBar(0xFF8E40A5, 0xFF66FF33);
				changedBar = true;
			case 'hungryhippo' | 'hungryhippo-blantad':
				healthBar.createFilledBar(0xFF6495ED, 0xFF66FF33);
				changedBar = true;
			case 'emptystage':
				healthBar.createFilledBar(FlxColor.BLACK, 0xFFB7D855);
				changedBar = true;		
		}
		switch (curSong)
		{
			case 'Accidental-Bop':
				healthBar.createFilledBar(0xFFC11200, 0xFF265D86);
				changedBar = true;	
			case 'Storm':
				healthBar.createFilledBar(0xFF000000, 0xFF000000);
				changedBar = true;		
			case 'Dusk':
				if (SONG.player1.contains('mia') && SONG.player2.contains('b3-mom'))
				{
					healthBar.createFilledBar(0xFFB1439A, 0xFFFF68ED);
					changedBar = true;
				}								
		}
		if (changedBar == false)
		{
			healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		}			

		add(healthBar);

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;

		switch (curSong.toLowerCase())
		{
			case 'storm':
				scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.BLACK, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.WHITE);
			case 'hunger' | 'aspirer':
				scoreTxt.setFormat(Paths.font("starv.ttf"), 16, FlxColor.WHITE, CENTER);
			default:
				scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		}
		
		scoreTxt.scrollFactor.set();													  
		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu

		
		switch (boyfriend.curCharacter)
		{
			case 'tankman':
				switch(curSong.toLowerCase())
				{
					case 'fading-senpai':
						p1Icon = 'tankman-sad';
					default:
						p1Icon = 'tankman';
				}
			case 'monster-pixel':
				switch(curSong.toLowerCase())
				{
					case 'dead-pixel':
						p1Icon = 'monster-pixel-look';
					default:
						p1Icon = 'monster-pixel';
				}
			default:
				p1Icon = boyfriend.curCharacter;
		}
		iconP1 = new HealthIcon(p1Icon, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		if(curStage == 'takiStage')
		{
			moreDark = new FlxSprite(0, 0).loadGraphic(Paths.image('fever/effectShit/evenMOREdarkShit'));
			moreDark.cameras = [camHUD];
			add(moreDark);
		}
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		doof2.cameras = [camHUD];
		doof3.cameras = [camHUD];
		doof4.cameras = [camHUD];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		if (loadRep)
			replayTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (curStage == 'auditorHell')
		{	
			add(tstatic);
			tstatic.alpha = 0.1;
			tstatic.setGraphicSize(Std.int(tstatic.width * 12));
			tstatic.x += 600;
		}
		
		trace('starting');

		if (isStoryMode || showCutscene)
		{
			switch (StringTools.replace(curSong," ", "-").toLowerCase())
			{
				case "winter-horrorland":
					blackScreen = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'whittyvssarv' | 'battle' | 'gun-buddies':
					schoolIntro(doof);
				case 'tutorial' | 'bopeebo' | 'fresh' | 'dadbattle':
					schoolIntro(doof);	
				case 'ballistic':
					wBg.alpha = 1;
					wstageFront.alpha = 1;
					remove(funneEffect);
					changeDadCharacter(100, 400, 'pico');
					picoIntro(doof2);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				case 'expurgation':
					camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
					var spawnAnim = new FlxSprite(dad.x - 575, dad.y - 232);
					spawnAnim.frames = Paths.getSparrowAtlas('characters/CJCLONEENTER');

					spawnAnim.animation.addByPrefix('start','Entrance',24,false);

					add(spawnAnim);

					spawnAnim.animation.play('start');
					var p = new FlxSound().loadEmbedded(Paths.sound("tricky/fourth/Trickyspawn", 'shared'));
					var pp = new FlxSound().loadEmbedded(Paths.sound("tricky/fourth/TrickyGlitch", 'shared'));
					p.play();
					spawnAnim.animation.finishCallback = function(pog:String)
						{
							pp.fadeOut();
							dad.visible = true;
							remove(spawnAnim);
							startCountdown();
						}
					new FlxTimer().start(0.001, function(tmr:FlxTimer)
						{
							if (spawnAnim.animation.frameIndex == 24)
							{
								pp.play();
							}
							else
								tmr.reset(0.001);
						});
				case 'nerves':
					FlxG.sound.play(Paths.sound('garWeak'));
					startCountdown();
				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		switch (curStage)
		{
			case 'emptystage':
				add(bobmadshake);
		}

		super.create();
	}

	function doStopSign(sign:Int = 0, fuck:Bool = false)
	{
		trace('sign ' + sign);
		daSign = new FlxSprite(0,0);

		daSign.frames = Paths.getSparrowAtlas('tricky/fourth/mech/Sign_Post_Mechanic');

		daSign.setGraphicSize(Std.int(daSign.width * 0.67));

		daSign.cameras = [camHUD];

		switch(sign)
		{
			case 0:
				daSign.animation.addByPrefix('sign','Signature Stop Sign 1',24, false);
				daSign.x = FlxG.width - 650;
				daSign.angle = -90;
				daSign.y = -300;
			case 1:
				/*daSign.animation.addByPrefix('sign','Signature Stop Sign 2',20, false);
				daSign.x = FlxG.width - 670;
				daSign.angle = -90;*/ // this one just doesn't work???
			case 2:
				daSign.animation.addByPrefix('sign','Signature Stop Sign 3',24, false);
				daSign.x = FlxG.width - 780;
				daSign.angle = -90;
				if (FlxG.save.data.downscroll)
					daSign.y = -395;
				else
					daSign.y = -980;
			case 3:
				daSign.animation.addByPrefix('sign','Signature Stop Sign 4',24, false);
				daSign.x = FlxG.width - 1070;
				daSign.angle = -90;
				daSign.y = -145;
		}
		add(daSign);
		daSign.flipX = fuck;
		daSign.animation.play('sign');
		daSign.animation.finishCallback = function(pog:String)
			{
				trace('ended sign');
				remove(daSign);
			}
	}

	var totalDamageTaken:Float = 0;

	var shouldBeDead:Bool = false;

	var interupt = false;

	function addIconBG(character:String, x:Float, y:Float, angle:Float, redraw:Bool = false)
	{
		iconBG = new HealthIcon(character, false);
		iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
		iconBG.updateHitbox();
		iconBG.x = x;
		iconBG.y = y;
		iconBG.angle = angle;
		iconBG.scrollFactor.set(0.9, 0.9);
		remove(scope);
		remove(gf);

		if (redraw)
		{
			remove(dad);
			remove(boyfriend);			
		}

		add(iconBG);
		add(scope);
		add(gf);

		if (redraw)
		{
			add(dad);
			add(boyfriend);		
		}
	}

	function changeDadCharacter(x:Float, y:Float, character:String)
	{
		dad.destroy();
		dad = new Character(x, y, character);
		add(dad);
		iconP2.animation.play(character);
	}

	function changeGFCharacter(x:Float, y:Float, character:String)
	{
		gf.destroy();
		gf = new Character(x, y, character);
		gf.scrollFactor.set(0.95, 0.95);
		add(gf);
	}

	function changeBoyfriendCharacter(x:Float, y:Float, character:String)
	{
		boyfriend.destroy();
		boyfriend = new Boyfriend(x, y, character);
		add(boyfriend);
		iconP1.animation.play(character);
	}

	function changeStaticNotes(id:String)
	{
		remove(strumLineNotes);
		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		strumLineNotes.cameras = [camHUD];	
		generateStaticArrows(0, id, false);
		generateStaticArrows(1, id, false);
	}

	function corruptBG(id:String)
	{
		switch (id)
		{
			case 'corrupt':
				bgSkyEvil.alpha = 1;
				bgSchoolEvil.alpha = 1;
				fgTreesEvil.alpha = 1;
				bgStreetEvil.alpha = 1;
				bgTrees.alpha = 0;	
			case 'normal':
				bgSkyEvil.alpha = 0;
				bgSchoolEvil.alpha = 0;
				fgTreesEvil.alpha = 0;
				bgStreetEvil.alpha = 0;
				bgTrees.alpha = 1;			
		}
	}

	function doFloatShit()
	{
		doingFloatShit = true;
		
		tween = FlxTween.linearMotion(dad, dad.x, dad.y, dad.x, dad.y - 100, 2, true, {ease: FlxEase.quadInOut, type: FlxTweenType.PINGPONG});
	}

	function doBFFloatShit()
	{
		doingBoyfriendFloatShit = true;
		
		tween = FlxTween.linearMotion(boyfriend, boyfriend.x, boyfriend.y, boyfriend.x, boyfriend.y - 100, 2, true, {ease: FlxEase.quadInOut, type: FlxTweenType.PINGPONG});
	}

	function doPicoCutscene():Void
	{
		doof3 = new DialogueBox(false, extra2);
		doof3.scrollFactor.set();
		doof3.cameras = [camHUD];
		doof3.finishThing = startCountdown;

		wind.fadeIn();
		
		new FlxTimer().start(1.2, function(tmr:FlxTimer)
		{
			dad.playAnim('pissed');

			new FlxTimer().start(1, function(tmr:FlxTimer) {
				FlxG.sound.play(Paths.sound("shooters"), 1);
				FlxG.camera.flash(FlxColor.WHITE, 2, false);
				gf.playAnim('scared', true);
				boyfriend.playAnim('scared', true);
				wBg.alpha = 0;
			});

			new FlxTimer().start(3, function(tmr:FlxTimer) {
				picoIntroPart2(doof3);
			});
		});
	}

	function doGremlin(hpToTake:Int, duration:Int,persist:Bool = false)
	{
		interupt = false;

		grabbed = true;
		
		totalDamageTaken = 0;

		var gramlan:FlxSprite = new FlxSprite(0,0);

		gramlan.frames = Paths.getSparrowAtlas('tricky/fourth/mech/HP GREMLIN');

		gramlan.setGraphicSize(Std.int(gramlan.width * 0.76));

		gramlan.cameras = [camHUD];

		gramlan.x = iconP1.x;
		gramlan.y = healthBarBG.y - 325;

		gramlan.animation.addByIndices('come','HP Gremlin ANIMATION',[0,1], "", 24, false);
		gramlan.animation.addByIndices('grab','HP Gremlin ANIMATION',[2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24], "", 24, false);
		gramlan.animation.addByIndices('hold','HP Gremlin ANIMATION',[25,26,27,28],"",24);
		gramlan.animation.addByIndices('release','HP Gremlin ANIMATION',[29,30,31,32,33],"",24,false);

		gramlan.antialiasing = true;

		add(gramlan);

		if(FlxG.save.data.downscroll){
			gramlan.flipY = true;
			gramlan.y -= 150;
		}
		
		// over use of flxtween :)

		var startHealth = health;
		var toHealth = (hpToTake / 100) * startHealth; // simple math, convert it to a percentage then get the percentage of the health

		var perct = toHealth / 2 * 100;

		trace('start: $startHealth\nto: $toHealth\nwhich is prect: $perct');

		var onc:Bool = false;

		FlxG.sound.play(Paths.sound('tricky/fourth/GremlinWoosh'));

		gramlan.animation.play('come');
		new FlxTimer().start(0.14, function(tmr:FlxTimer) {
			gramlan.animation.play('grab');
			FlxTween.tween(gramlan,{x: iconP1.x - 140},1,{ease: FlxEase.elasticIn, onComplete: function(tween:FlxTween) {
				trace('I got em');
				gramlan.animation.play('hold');
				FlxTween.tween(gramlan,{
					x: (healthBar.x + 
					(healthBar.width * (FlxMath.remapToRange(perct, 0, 100, 100, 0) * 0.01) 
					- 26)) - 75}, duration,
				{
					onUpdate: function(tween:FlxTween) { 
						// lerp the health so it looks pog
						if (interupt && !onc && !persist)
						{
							onc = true;
							trace('oh shit');
							gramlan.animation.play('release');
							gramlan.animation.finishCallback = function(pog:String) { gramlan.alpha = 0;}
						}
						else if (!interupt || persist)
						{
							var pp = FlxMath.lerp(startHealth,toHealth, tween.percent);
							if (pp <= 0)
								pp = 0.1;
							health = pp;
						}

						if (shouldBeDead)
							health = 0;
					},
					onComplete: function(tween:FlxTween)
					{
						if (interupt && !persist)
						{
							remove(gramlan);
							grabbed = false;
						}
						else
						{
							trace('oh shit');
							gramlan.animation.play('release');
							if (persist && totalDamageTaken >= 0.7)
								health -= totalDamageTaken; // just a simple if you take a lot of damage wtih this, you'll loose probably.
							gramlan.animation.finishCallback = function(pog:String) { remove(gramlan);}
							grabbed = false;
						}
					}
				});
			}});
		});
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy', 'week6');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'ballistic')
		{
			camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
		}

		if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'roses' || StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'thorns')
		{
			remove(black);

			if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function picoIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		strumLineNotes.visible = false;
		scoreTxt.visible = false;
		healthBarBG.visible = false;
		healthBar.visible = false;
		iconP1.visible = false;
		iconP2.visible = false;

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);

		wind.fadeIn();

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;
					wind.fadeOut();
					add(dialogueBox);
				}
				else
				{
					doPicoCutscene();
				}
				remove(black);
			}
		});
	}

	function picoIntroPart2(?dialogueBox:DialogueBox):Void
	{
		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			if (dialogueBox != null)
			{
				inCutscene = true;
				wind.fadeOut();
				add(dialogueBox);
			}
			else
			{
				startCountdown();
			}
		});
	}

	function picoEnd(?dialogueBox:DialogueBox):Void
	{
		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		changeBoyfriendCharacter(875, 400, 'bf-cesar');

		camHUD.zoom = 0;

		var botan:FlxSprite = new FlxSprite(dad.x - 220, dad.y - 50);
		botan.frames = Paths.getSparrowAtlas('whitty/lmaoBotan');
		botan.animation.addByPrefix('idle', 'Pico Worried', 24, false);
		botan.flipX = true;
		add(botan);

		var pico:FlxSprite = new FlxSprite(dad.x + 220, dad.y - 20);
		pico.frames = Paths.getSparrowAtlas('whitty/lmaoPico');
		pico.animation.addByPrefix('idle', 'Pico Look Down', 24, false);
		add(pico);

		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		strumLineNotes.visible = false;
		scoreTxt.visible = false;
		healthBarBG.visible = false;
		healthBar.visible = false;
		iconP1.visible = false;
		iconP2.visible = false;
		dad.visible = false;
		picoCutscene = true;

		camZooming = false;
		inCutscene = true;
		startedCountdown = false;
		generatedMusic = false;
		canPause = false;

		wBg.alpha = 1;
		wstageFront.alpha = 1;

		camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);

		wind.fadeIn();

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				new FlxTimer().start(1, function(swagtmr:FlxTimer)
				{
					if (dialogueBox != null)
					{
						inCutscene = true;
						wind.fadeOut();
						add(dialogueBox);
					}
					else
					{
						endSong();
					}
				});
				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{
		inCutscene = false;
		camFollowIsOn = true;
		defaultCamFollow = true;

		if (curSong == 'Ballistic' && showCutscene == true)
		{
			strumLineNotes.visible = true;
			scoreTxt.visible = true;
			healthBarBG.visible = true;
			healthBar.visible = true;
			iconP1.visible = true;
			iconP2.visible = true;
		}

		if (dad.curCharacter == 'zardy')
		{
			new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				if (dad.alpha != 1)
				{
					dad.alpha += 0.1;
					tmr.reset(0.1);
				}
			});
		}
		
		generateStaticArrows(0, SONG.noteStyle);
		generateStaticArrows(1, SONG.noteStyle);

		#if windows
		// pre lowercasing the song name (startCountdown)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[songLowercase]);
		}
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.dance();

			switch (curSong)
			{
				case 'Norway':
					tomBG.animation.play('idle');
					bfBG.animation.play('idle');
					mattBG.animation.play('idle');
					tordBG.animation.play('idle');
					gfBG.dance();
				case 'Ugh-Remix':
					momDadBG.animation.play('idle');
					softBFBG.animation.play('idle');
					gfBG.dance();
				case 'Battle':
					zero16.animation.play('idle');
				case 'Hands':
					gfBG.dance();
			}

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('school-monika', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolnoon', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('school-switch', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvild4', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('emptystage2', [
				'bw/ready',
				'bw/set',
				'bw/go'
			]);
			introAssets.set('day', [
				'bb/2',
				'bb/1',
				'bb/go'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					switch (curStage)
					{
						case 'schoolnoon' | 'schoolEvild4':
							altSuffix = '-pixelcorrupted';
						case 'emptystage2':
							altSuffix = '';
						default:
							altSuffix = '-pixel';
					}
				}
			}

			switch (swagCounter)

			{
				case 0:
					switch (curStage) {
						case 'day':
							FlxG.sound.play(Paths.sound('bob/3', 'shared'), 0.6);
						case 'sunset':
							FlxG.sound.play(Paths.sound('bosip/3', 'shared'), 0.6);
						//case 'split':
							//FlxG.sound.play(Paths.sound('amor/3', 'shared'), 0.6);
						default:
							FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
					}
					switch (SONG.song.toLowerCase()) {
						case 'day' | 'sunset':
							var three:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bb/3', 'shared'));
							three.scrollFactor.set();
							three.screenCenter();
							add(three);
							FlxTween.tween(three, {y: three.y += 100, alpha: 0}, Conductor.crochet / 1000, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									three.destroy();
								}
							});
						default:
							'';
					}
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					switch (curStage) {
						case 'day':
							FlxG.sound.play(Paths.sound('bob/2', 'shared'), 0.6);
						case 'sunset':
							FlxG.sound.play(Paths.sound('bosip/2', 'shared'), 0.6);
						//case 'split':
							//FlxG.sound.play(Paths.sound('amor/2', 'shared'), 0.6);
						default:
							FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
					}
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					switch (curStage) {
						case 'day':
							FlxG.sound.play(Paths.sound('bob/1', 'shared'), 0.6);
						case 'sunset':
							FlxG.sound.play(Paths.sound('bosip/1', 'shared'), 0.6);
						//case 'split':
							//FlxG.sound.play(Paths.sound('amor/1', 'shared'), 0.6);
						default:
							FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
					}
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					switch (curStage) {
						case 'day':
							FlxG.sound.play(Paths.sound('bob/Go', 'shared'), 0.6);
						case 'sunset':
							FlxG.sound.play(Paths.sound('bosip/Go', 'shared'), 0.6);
						//case 'split':
							//FlxG.sound.play(Paths.sound('amor/Go', 'shared'), 0.6);
						default:
							FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
					}
				case 4:
					if (SONG.song.toLowerCase() == "takeover") 
					{
						for (note in 0...strumLineNotes.members.length) {
							ModCharts.circleLoop(strumLineNotes.members[note], 50, 3);
						}
					} 
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);

		if (SONG.song.toLowerCase() == 'expurgation')
		{
			new FlxTimer().start(25, function(tmr:FlxTimer) {
				if (curStep < 2400)
				{
					if (canPause && !paused && health >= 1.5 && !grabbed)
						doGremlin(40,3);
					trace('checka ' + health);
					tmr.reset(25);
				}
			});
		}
	}

	var grabbed = false;

	var theFunneNumber:Float = 1;
	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			if (FileSystem.exists(Paths.inst2(PlayState.SONG.song)))
				FlxG.sound.playMusic(Sound.fromFile(Paths.inst2(PlayState.SONG.song)), 1, false);
			else
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = songOutro;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly Nice' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}

		if (useVideo)
			GlobalVideo.get().resume();
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
		{
			if (FileSystem.exists(Paths.voices2(PlayState.SONG.song)))
				vocals = new FlxSound().loadEmbedded(Sound.fromFile(Paths.voices2(PlayState.SONG.song)));
			else
				vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		}		
		else
			vocals = new FlxSound();

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if windows
			// pre lowercasing the song name (generateSong)
			var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
				switch (songLowercase) {
					case 'dad-battle': songLowercase = 'dadbattle';
					case 'philly-nice': songLowercase = 'philly';
				}

			var songPath = 'assets/data/' + songLowercase + '/';
			
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);
			var playerNotes:Array<Int> = [0, 1, 2, 3, 8, 9, 10, 11];

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1]);

				var gottaHitNote:Bool = section.mustHitSection;

				if (!playerNotes.contains(songNotes[1]))
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function generateStaticArrows(player:Int,style:String,tweenShit:Bool = true):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			babyArrow = new FlxSprite(0, strumLine.y);

			//defaults if no noteStyle was found in chart
			var noteTypeCheck:String = 'normal';

			switch (style)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('notestuff/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
					}

				case 'pixel-corrupted':
					babyArrow.loadGraphic(Paths.image('notestuff/arrows-pixelscorrupted'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
					}

				case 'pixel-combined':
					babyArrow.loadGraphic(Paths.image('notestuff/arrows-pixelscombined'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
					}
				
				case 'normal' | 'auditor' | 'gray' | 'corrupted' | 'cross':
					switch (style)
					{
						case 'normal' | 'auditor':
							babyArrow.frames = Paths.getSparrowAtlas('notestuff/NOTE_assets');
						case 'gray':
							babyArrow.frames = Paths.getSparrowAtlas('notestuff/NOTE_assets_gray');
						case 'corrupted':
							babyArrow.frames = Paths.getSparrowAtlas('notestuff/NOTE_assets_Corrupted');
						case 'cross':
							babyArrow.frames = Paths.getSparrowAtlas('notestuff/cross_note_assets');
					}
					
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}

				case 'bw':
					babyArrow.frames = Paths.getSparrowAtlas('notestuff/NOTE_assets_BW');
					babyArrow.animation.addByPrefix('green', 'green0');
					babyArrow.animation.addByPrefix('blue', 'blue0');
					babyArrow.animation.addByPrefix('purple', 'purple0');
					babyArrow.animation.addByPrefix('red', 'red0');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'purple0');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'blue0');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'green0');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'red0');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}

				case 'taki':
					babyArrow.frames = Paths.getSparrowAtlas('notestuff/TakiNotes');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
					
				case 'empty':
					babyArrow.frames = Paths.getSparrowAtlas('notestuff/Note_Assets_withPixel');
					babyArrow.animation.addByPrefix('green', 'Up0');
					babyArrow.animation.addByPrefix('blue', 'Down0');
					babyArrow.animation.addByPrefix('purple', 'Left0');
					babyArrow.animation.addByPrefix('red', 'Right0');
					babyArrow.animation.addByPrefix('greenpixel', 'PixelUp0');
					babyArrow.animation.addByPrefix('bluepixel', 'PixelDown0');
					babyArrow.animation.addByPrefix('purplepixel', 'PixelLeft0');
					babyArrow.animation.addByPrefix('redpixel', 'PixelRight0');
		
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
					
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'LeftStatic');
							babyArrow.animation.addByPrefix('pressed', 'LeftPress', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'LeftConfirm', 24, false);
							babyArrow.animation.addByPrefix('static2', 'PixelLeftStatic');
							babyArrow.animation.addByPrefix('pressed2', 'PixelLeftPress', 24, false);
							babyArrow.animation.addByPrefix('confirm2', 'PixelLeftConfirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'DownStatic');
							babyArrow.animation.addByPrefix('pressed', 'DownPress', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'DownConfirm', 24, false);
							babyArrow.animation.addByPrefix('static2', 'PixelDownStatic');
							babyArrow.animation.addByPrefix('pressed2', 'PixelDownPress', 24, false);
							babyArrow.animation.addByPrefix('confirm2', 'PixelDownConfirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'UpStatic');
							babyArrow.animation.addByPrefix('pressed', 'UpPress', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'UpConfirm', 24, false);
							babyArrow.animation.addByPrefix('static2', 'PixelUpStatic');
							babyArrow.animation.addByPrefix('pressed2', 'PixelUpPress', 24, false);
							babyArrow.animation.addByPrefix('confirm2', 'PixelUpConfirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'RightStatic');
							babyArrow.animation.addByPrefix('pressed', 'RightPress', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'RightConfirm', 24, false);
							babyArrow.animation.addByPrefix('static2', 'PixelRightStatic');
							babyArrow.animation.addByPrefix('pressed2', 'PixelRightPress', 24, false);
							babyArrow.animation.addByPrefix('confirm2', 'PixelRightConfirm', 24, false);
					}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('notestuff/NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();
			
			if (!isStoryMode && tweenShit)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;
			
			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			
			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
		for (note in 0...strumLineNotes.members.length)
		{
			if (player == 1 && note >= 4)
			{
				if (!ModCharts.bfNotesVisible)
				{
					strumLineNotes.members[note].visible = false;
				}
			}
			else if (!ModCharts.dadNotesVisible)
			{
				strumLineNotes.members[note].visible = false;
			}
		}	
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var spookyText:FlxText;
	var spookyRendered:Bool = false;
	var spookySteps:Int = 0;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	public var stopUpdate = false;
	public var removedVideo = false;

	var shake:Bool = false;
	var health1:Bool = false;
	var pressedOnce:Bool = false;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (curStage == 'zardymaze' && zardyBackground.animation.finished)
		{
			zardyBackground.animation.play('Maze');
		}

		if(health1 && !pressedOnce)
		{
			if (FlxG.keys.justPressed.SPACE)
			{
				health += 0.7;
				pressedOnce = true;
			}
		}

		#if debug
		if (FlxG.keys.justPressed.FIVE)
		{
			FlxG.save.data.botplay = !FlxG.save.data.botplay;
		}
		#end

		if (SONG.song.toLowerCase() == 'hands')
		{
			cloudTimer += elapsed * 10;
			if (cloudTimer > 1)
			{
				cloudTimer--;
				cloudGroup.add(cloudGroup.recycle(Cloud.new));
			}

			cloudTimer2 += elapsed * 2;
			if (cloudTimer2 > 1)
			{
				cloudTimer2--;
				cloudGroup2.add(cloudGroup2.recycle(Cloud2.new));
			}
		}

		if ((dad.curCharacter == 'sarvente-lucifer' || dad.curCharacter == 'sh-carol') && !doingFloatShit)
		{
			doFloatShit();
		}

		if ((boyfriend.curCharacter == 'sarvente-lucifer' || boyfriend.curCharacter == 'sh-carol') && !doingBoyfriendFloatShit)
		{
			doBFFloatShit();
		}

		if (!dad.curCharacter.contains('spirit') && !removedTrail && curStage == 'schoolEvild4')
		{
			remove(evilTrail);
			removedTrail = true;
		}

		if (curSong == 'Senpai')
		{
			if (DialogueBox.curCharacter == 'senpai-angry' && dad.curCharacter != 'senpai-angry')
			{
				changeDadCharacter(250, 460, 'senpai-angry');
			}
			else if (DialogueBox.curCharacter == 'senpai' && dad.curCharacter != 'senpai')
			{
				changeDadCharacter(250, 460, 'senpai');
			}						
		}

		if (curSong == 'Ballistic')
		{
			if (DialogueBox.curCharacter == 'pico-dark' && dad.curCharacter != 'picoCrazy')
			{
				changeDadCharacter(100, 400, 'picoCrazy');
			}		
		}

		if (dad.curCharacter == "tordbot")
		{
			if (dad.animation.curAnim.name == "singLEFT") PlayState.camFollow.setPosition(tordCam[0].x, tordCam[0].y);
			if (dad.animation.curAnim.name == "singRIGHT") PlayState.camFollow.setPosition(tordCam[1].x, tordCam[1].y);
			if (dad.animation.curAnim.name == "singUP") PlayState.camFollow.setPosition(tordCam[2].x, tordCam[2].y);
			if (dad.animation.curAnim.name == "singDOWN") PlayState.camFollow.setPosition(tordCam[3].x, tordCam[3].y);
		}

		if (dad.curCharacter == 'gf1')
		{
			if (dad.animation.curAnim.name.startsWith('singLEFT'))
				iconP2.animation.play('momosuzu');
			if (dad.animation.curAnim.name.startsWith('singRIGHT'))
				iconP2.animation.play('gfandbf');
			if (dad.animation.curAnim.name.startsWith('singUP'))
				iconP2.animation.play('gf');
			if (dad.animation.curAnim.name.startsWith('singDOWN'))
				iconP2.animation.play('boygf');
			if (dad.animation.curAnim.name.startsWith('dance'))
				iconP2.animation.play('gfandbf');
		}
		if (dad.curCharacter == 'gf2')
		{
			if (dad.animation.curAnim.name.startsWith('singLEFT'))
				iconP2.animation.play('bf-senpai-flippin');
			if (dad.animation.curAnim.name.startsWith('singRIGHT'))
				iconP2.animation.play('bf-senpai-flippin');
			if (dad.animation.curAnim.name.startsWith('singUP'))
				iconP2.animation.play('gf-rincewind');
			if (dad.animation.curAnim.name.startsWith('singDOWN'))
				iconP2.animation.play('gf-lemon');
			if (dad.animation.curAnim.name.startsWith('dance'))
				iconP2.animation.play('bf-senpai-flippin');
		}
		if (dad.curCharacter == 'gf3')
		{
			if (dad.animation.curAnim.name.startsWith('singLEFT'))
				iconP2.animation.play('gf-lapis');
			if (dad.animation.curAnim.name.startsWith('singRIGHT'))
				iconP2.animation.play('gf-kanna');
			if (dad.animation.curAnim.name.startsWith('singUP'))
				iconP2.animation.play('gf-moony');
			if (dad.animation.curAnim.name.startsWith('singDOWN'))
				iconP2.animation.play('gf-kaity');
			if (dad.animation.curAnim.name.startsWith('dance'))
				iconP2.animation.play('gf-kanna');
		}
		if (dad.curCharacter == 'gf4')
		{
			if (dad.animation.curAnim.name.startsWith('singLEFT'))
				iconP2.animation.play('gf-aubrey');
			if (dad.animation.curAnim.name.startsWith('singRIGHT'))
				iconP2.animation.play('bf-carol');
			if (dad.animation.curAnim.name.startsWith('singUP'))
				iconP2.animation.play('gf-chara');
			if (dad.animation.curAnim.name.startsWith('singDOWN'))
				iconP2.animation.play('gf-drip');
			if (dad.animation.curAnim.name.startsWith('dance'))
				iconP2.animation.play('bf-carol');
		}
		if (dad.curCharacter == 'gf5')
		{
			if (dad.animation.curAnim.name.startsWith('singLEFT'))
				iconP2.animation.play('gf-troll');
			if (dad.animation.curAnim.name.startsWith('singRIGHT'))
				iconP2.animation.play('gf');
			if (dad.animation.curAnim.name.startsWith('singUP'))
				iconP2.animation.play('gf-fugo');
			if (dad.animation.curAnim.name.startsWith('singDOWN'))
				iconP2.animation.play('starzgf');
			if (dad.animation.curAnim.name.startsWith('dance'))
				iconP2.animation.play('starzgf');
		}
		if (boyfriend.curCharacter == 'bf1')
		{
			if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
				iconP1.animation.play('gfandbf');
			if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
				iconP1.animation.play('bf-aloe');
			if (boyfriend.animation.curAnim.name.startsWith('singUP'))
				iconP1.animation.play('girlbf');
			if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
				iconP1.animation.play('bf');
			if (boyfriend.animation.curAnim.name.startsWith('idle'))
				iconP1.animation.play('bf-aloe');
		}

		if (boyfriend.curCharacter == 'bf2')
		{
			if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
				iconP1.animation.play('bf-senpai-flippin');
			if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
				iconP1.animation.play('bf-senpai-flippin');
			if (boyfriend.animation.curAnim.name.startsWith('singUP'))
				iconP1.animation.play('bf-pico');
			if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
				iconP1.animation.play('bf-rincewind');
			if (boyfriend.animation.curAnim.name.startsWith('idle'))
				iconP1.animation.play('bf-senpai-flippin');
		}

		if (boyfriend.curCharacter == 'bf3')
		{
			if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
				iconP1.animation.play('bf-ryuko');
			if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
				iconP1.animation.play('bf-peridot');
			if (boyfriend.animation.curAnim.name.startsWith('singUP'))
				iconP1.animation.play('bf-chris');
			if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
				iconP1.animation.play('bf-ena');
			if (boyfriend.animation.curAnim.name.startsWith('idle'))
				iconP1.animation.play('bf-peridot');
		}

		if (boyfriend.curCharacter == 'bf4')
		{
			if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
				iconP1.animation.play('bf-omori');
			if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
				iconP1.animation.play('bf-smol-whitty');
			if (boyfriend.animation.curAnim.name.startsWith('singUP'))
				iconP1.animation.play('bf-frisk');
			if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
				iconP1.animation.play('bf-drip');
			if (boyfriend.animation.curAnim.name.startsWith('idle'))
				iconP1.animation.play('bf-smol-whitty');
		}

		if (boyfriend.curCharacter == 'bf5')
		{
			if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
				iconP1.animation.play('bf-troll');
			if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
				iconP1.animation.play('bf');
			if (boyfriend.animation.curAnim.name.startsWith('singUP'))
				iconP1.animation.play('bf-narancia');
			if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
				iconP1.animation.play('bf-starzchan');
			if (boyfriend.animation.curAnim.name.startsWith('idle'))
				iconP1.animation.play('bf-starzchan');
		}

		if (dad.curCharacter == 'eddsworld-switch')
		{
			if (dad.animation.curAnim.name.startsWith('singLEFT'))
				iconP2.animation.play('matt2');
			if (dad.animation.curAnim.name.startsWith('singRIGHT'))
				iconP2.animation.play('tord2');
			if (dad.animation.curAnim.name.startsWith('singUP'))
				iconP2.animation.play('edd2');
			if (dad.animation.curAnim.name.startsWith('singDOWN'))
				iconP2.animation.play('tom2');
			if (dad.animation.curAnim.name.startsWith('idle'))
				iconP2.animation.play('tord2');
		}

		if (boyfriend.curCharacter == 'bf-fnf-switch')
		{
			if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
				iconP1.animation.play('dad');
			if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
				iconP1.animation.play('gf');
			if (boyfriend.animation.curAnim.name.startsWith('singUP'))
				iconP1.animation.play('pico');
			if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
				iconP1.animation.play('bf');
			if (boyfriend.animation.curAnim.name.startsWith('idle'))
				iconP1.animation.play('bf');
		}


		if (useVideo && GlobalVideo.get() != null && !stopUpdate)
			{		
				if (GlobalVideo.get().ended && !removedVideo)
				{
					remove(videoSprite);
					removedVideo = true;
				}
			}

		if (isTakeover && minusHealth && dad.curCharacter == 'monika-finale')
		{
			if (health > 0)
			{
				health -= 0.001 * (elapsed / (1/ (cast (Lib.current.getChildAt(0), Main)).getFPS()));
			}
		}

		if (SONG.song.toLowerCase() == 'demon-training' && minusHealth && curStep >= 1024 && curStep < 1280)
		{
			if (health > 0)
			{
				health -= 0.001 * (elapsed / (1/(cast (Lib.current.getChildAt(0), Main)).getFPS()));
			}
		}

		if (dad.curCharacter == 'dad' && (boyfriend.curCharacter == 'bf-gf' || boyfriend.curCharacter == 'bf-gf-demon')  && curSong == 'Demon-Training')
		{
			iconP2.animation.play('dad-happy');
		}

		if (boyfriend.curCharacter == 'spooky')
		{
			iconP1.animation.play('bf-spooky');
		}
		
		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			var bfCharacter:String = boyfriend.curCharacter;

			if (iconP1.animation.curAnim.name != boyfriend.curCharacter)
				iconP1.animation.play(boyfriend.curCharacter);
			else
				if (boyfriend.curCharacter.contains('-car'))
					bfCharacter = boyfriend.curCharacter.split('-')[0];

				if (iconP1.animation.getByName(bfCharacter+'-old') != null)
					iconP1.animation.play(bfCharacter+'-old');
				else
					iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly' | 'phillyannie' | 'philly-wire':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
			case 'tank':
				moveTank();
			case 'limoholo-night':
				var rotRateBl = (curStep / 9.5) * 1.2;
				
				var bl_toy = -8500 + -Math.sin(rotRateBl * 2) * bl_r * 0.45;
				var bl_tox = 50 - Math.cos(rotRateBl) * bl_r;

				blantadBG.x += (bl_tox - blantadBG.x) / 12;
				blantadBG.y += (bl_toy - blantadBG.y) / 12;
		}

		super.update(elapsed);

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			if (useVideo)
				{
					GlobalVideo.get().stop();
					remove(videoSprite);
					removedVideo = true;
				}
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		floatshit += 0.03;

		switch(dad.curCharacter)
		{
			case 'nonsense-god' | 'pshaggy':
				shouldFloat = true;
			case 'bf-bw':
				if (dad.animation.curAnim.name == 'idle')
					shouldFloat = true;
				else
					shouldFloat = false;
			default:
				shouldFloat = false;
		}
		
		if (shouldFloat)
		{
			dad.y += Math.sin(floatshit);
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;
		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		if (curStage == 'ballisticAlley' && health != 2)
		{
			funneEffect.alpha = health - 0.3;
			if (theFunneNumber < 0.7)
				theFunneNumber = 0.7;
			else if (theFunneNumber > 1.2)
				theFunneNumber = 1.2;

			if (theFunneNumber < 1)
				funneEffect.y = -300;
			else
				funneEffect.y = -200;

			funneEffect.setGraphicSize(Std.int(funneEffect.width * theFunneNumber));
		}

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
		{
			if (useVideo)
				{
					GlobalVideo.get().stop();
					remove(videoSprite);
					removedVideo = true;
				}

			FlxG.switchState(new AnimationDebug(dad.curCharacter));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.TWO)
		{
				if (useVideo)
				{
					GlobalVideo.get().stop();
					remove(videoSprite);
					removedVideo = true;
				}

			FlxG.switchState(new AnimationDebug(boyfriend.curCharacter));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		#end


		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly Nice':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;

				if (curStage == 'curse')
				{
					offsetX = 430;
				}

				if (curSong == 'Gun-Buddies')
				{
					offsetY = 50;
				}

				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followDadXOffset", "float");
					offsetY = luaModchart.getVar("followDadYOffset", "float");
				}
				#end
				if(SONG.player2 != "tordbot" && camFollowIsOn)
				{
					camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
				}		
				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerTwoTurn', []);
				#end
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (curStage)
				{
					case 'day':
						camFollow.x = 536.63 + offsetX;
						camFollow.y = 449.94 + offsetY;
					case 'mind':
						camFollow.x = dad.getMidpoint().x + 350 + offsetX;
					case 'prologue':
						camFollow.x = dad.getMidpoint().x + 200 + offsetX;
				}

				switch (dad.curCharacter)
				{
					case 'mom' | 'b3-mom-sad' | 'b3-mom-mad' | 'rebecca':
						camFollow.y = dad.getMidpoint().y - 50 + offsetY;
					case 'duet-sm':
						camFollow.y = dad.getMidpoint().y - 400 + offsetY;
						camFollow.x = dad.getMidpoint().x + 0 + offsetX;
					case 'sayori-blue':
						camFollow.y = dad.getMidpoint().y - 400 + offsetY;
						camFollow.x = dad.getMidpoint().x + 100 + offsetX;
					case 'isa':
						camFollow.x = dad.getMidpoint().x + 170 + offsetX;
					case 'sh-carol':
						camFollow.x = dad.getMidpoint().x + 250 + offsetX;
						camFollow.y = dad.getMidpoint().y + offsetY;
					case 'bf-annie':
						camFollow.x = dad.getMidpoint().x + 250 + offsetX;
						camFollow.y = dad.getMidpoint().y - 150 + offsetY;
					case 'botan':
						camFollow.x = dad.getMidpoint().x + 50 + offsetX; 	
						camFollow.y = dad.getMidpoint().y - 100 + offsetY;	
					case 'annie-bw':
						camFollow.x = dad.getMidpoint().x + 200;	
						camFollow.y = dad.getMidpoint().y - 200;	
					case 'bf-whitty-pixel':
						camFollow.y = dad.getMidpoint().y - 300;
						camFollow.x = dad.getMidpoint().x + 60;
					case 'bitdad' | 'bitdadBSide':
						camFollow.y = dad.getMidpoint().y - 75;
						camFollow.x = dad.getMidpoint().x + 200;
					case 'bitdadcrazy':
						camFollow.y = dad.getMidpoint().y - 75;
						camFollow.x = dad.getMidpoint().x + 230;
					case 'senpai' | 'senpai-angry' | 'senpai-giddy' | 'monika' | 'monster-pixel' | 'monika-angry' | 'green-monika' | 'neon' | 'baldi-angry' | 'matt-angry' | 'mario-angry' | 'colt-angry' | 'kristoph-angry' | 'chara-pixel' | 'colt-angryd2' | 'colt-angryd2corrupted' | 'jackson':
						camFollow.y = dad.getMidpoint().y - 430 + offsetY;
						camFollow.x = dad.getMidpoint().x - 100 + offsetX;
					case 'cassandra' | 'cassandra-bw':
						camFollow.y = dad.getMidpoint().y + 75;
					case 'sunday':
						camFollow.y = dad.getMidpoint().y - 100 + offsetY;
					case 'bf-gf-pixel' | 'bf-botan-pixel':
						camFollow.x = dad.getMidpoint().x + 125;
						camFollow.y = dad.getMidpoint().y - 225;
					case 'lane-pixel':
						camFollow.x = dad.getMidpoint().x + 110;
						camFollow.y = dad.getMidpoint().y - 325;
					case 'gura-amelia-pixel':
						camFollow.x = dad.getMidpoint().x + 25;
						camFollow.y = dad.getMidpoint().y - 200;
					case 'pompom-mad':
						camFollow.y = dad.getMidpoint().y - 350;
					case 'shaggy':
						camFollow.y = dad.getMidpoint().y - 100;
						camFollow.x = dad.getMidpoint().x + 200;
					case 'monika-finale':
						camFollow.y = dad.getMidpoint().y - 390;
						camFollow.x = dad.getMidpoint().x - 250;
					case 'momi':
						camFollow.x = dad.getMidpoint().x + 200 + offsetX; 
					case 'bf-sky' | 'sky-annoyed' | 'sky-happy' | 'sky-mad':
						camFollow.y = boyfriend.getMidpoint().y - 200 + offsetY;
					case 'gf-crucified':
						camFollow.y = dad.getMidpoint().y + offsetY;
					case 'anchor-bowl':
						camFollow.y = dad.getMidpoint().y + 50 + offsetY;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial-remix' || SONG.player2 == 'tordbot')
				{
					tweenCamIn();
				}

				if (curStage == 'curse')
				{
					FlxTween.tween(FlxG.camera, {zoom: 0.6}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				var offsetX = 0;
				var offsetY = 0;

				if (curStage == 'curse')
				{
					offsetX = -330;
				}

				if (curSong == 'Gun-Buddies')
				{
					offsetY = 50;
				}

				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followBFXOffset", "float");
					offsetY = luaModchart.getVar("followBFYOffset", "float");
				}
				#end

				if (curStage == 'room')
				{
					offsetX = -200;

					if (boyfriend.curCharacter == 'tankman')
					{
						offsetY = -100;
					}
				}

				if (camFollowIsOn)
				{
					camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);
				}
				
				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);
				#end

				switch (curStage)
				{
					case 'limo' | 'limoholo' | 'limoholo-night':
						camFollow.x = boyfriend.getMidpoint().x - 300 + offsetX;
					case 'hungryhippo':
						camFollow.x = boyfriend.getMidpoint().x - 200 + offsetX;
					case 'mall' | 'mallSoft':
						camFollow.y = boyfriend.getMidpoint().y - 200 + offsetX;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school-switch':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school-monika':
						switch (curSong.toLowerCase())
						{
							case 'shinkyoku':
								camFollow.x = boyfriend.getMidpoint().x - 300 + offsetX;
								camFollow.y = boyfriend.getMidpoint().y - 200 + offsetY;
							default:
								camFollow.x = boyfriend.getMidpoint().x - 200 + offsetX;
								camFollow.y = boyfriend.getMidpoint().y - 200 + offsetY;
						}
					case 'schoolnoon':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil' | 'schoolEvild4' | 'school-monika-finale':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'day' | 'sunset':
						camFollow.x = 818.96 + offsetX;
						camFollow.y = 475.95 + offsetY;
					case 'garage':
						camFollow.x = boyfriend.getMidpoint().x - 220 + offsetX;
						camFollow.y = boyfriend.getMidpoint().y - 200 + offsetY;
					case 'churchsarv' | 'churchruv' | 'churchselever':
						camFollow.y = dad.getMidpoint().y - 100;
					case 'takiStage': 
						camFollow.x = boyfriend.getMidpoint().x - 250 + offsetX;
						camFollow.y = boyfriend.getMidpoint().y - 200 + offsetY;
				}

				if (SONG.song.toLowerCase() == 'tutorial-remix')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}

				switch (boyfriend.curCharacter)
				{
					case 'sky-mad':
						camFollow.y = boyfriend.getMidpoint().y - 70 + offsetY;
						camFollow.x = boyfriend.getMidpoint().x - 220 + offsetX;
					case 'piconjo':
						camFollow.y = boyfriend.getMidpoint().y - 300 + offsetY;
						camFollow.x = boyfriend.getMidpoint().x - 250 + offsetX;
					case 'bf-dad':
						camFollow.x = boyfriend.getMidpoint().x - 250 + offsetX;
					case 'mia' | 'mia-lookstraight':
						camFollow.x = boyfriend.getMidpoint().x - 150 + offsetX;
					case 'dad' | 'hex' | 'mom':
						camFollow.y = boyfriend.getMidpoint().y - 50 + offsetY;
						camFollow.x = boyfriend.getMidpoint().x - 250 + offsetX;
					case 'coco' | 'coco-car':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 20;
					case 'agoti' | 'bf-mom' | 'bf-mom-car':
						camFollow.x = boyfriend.getMidpoint().x - 250 + offsetX;
					case 'cassandra':
						camFollow.y = boyfriend.getMidpoint().y + 100 + offsetY;
						camFollow.x = boyfriend.getMidpoint().x - 200 + offsetX;
					case 'bana' | 'bana-wire':
						camFollow.y = boyfriend.getMidpoint().y + offsetY;
						camFollow.x = boyfriend.getMidpoint().x - 150 + offsetX;
					case 'pompom-mad':
						camFollow.y = boyfriend.getMidpoint().y - 150 + offsetY;
					case 'henry-angry':
						camFollow.x = boyfriend.getMidpoint().x - 250;
					case 'bf-annie':
						camFollow.x = boyfriend.getMidpoint().x - 200 + offsetX;	
					case 'pico' | 'annie-bw' | 'alya' | 'phil' | 'nene' | 'picoCrazy' | 'nene-bw' | 'pico-bw' | 'botan':
						camFollow.x = boyfriend.getMidpoint().x - 300 + offsetX;		
					case 'senpai' | 'blantad-pixel' | 'senpai-angry' | 'senpai-giddy' | 'miku-pixel' | 'mangle-angry' | 'monster-pixel' | 'jackson' | 'matt-angry' | 'mario-angry' | 'colt-angry' | 'colt-angryd2' | 'colt-angryd2corrupted' | 'bf-senpai-tankman':
						camFollow.x = boyfriend.getMidpoint().x - 400 + offsetX;
						camFollow.y = boyfriend.getMidpoint().y - 400 + offsetY;
					case 'monika' | 'monika-angry':
						camFollow.x = boyfriend.getMidpoint().x - 400 + offsetX;
						camFollow.y = boyfriend.getMidpoint().y - 430 + offsetY;
					case 'neon':
						camFollow.x = boyfriend.getMidpoint().x - 450 + offsetX;
						camFollow.y = boyfriend.getMidpoint().y - 400 + offsetY;
					case 'anchor' | 'anchor-bw':
						camFollow.y = boyfriend.getMidpoint().y + 25 + offsetY;
					case 'brother':
						camFollow.y = boyfriend.getMidpoint().y + 25;
					case 'spooky-pixel':
						camFollow.x = boyfriend.getMidpoint().x - 250;
						camFollow.y = boyfriend.getMidpoint().y - 100;
					case 'spooky':
						camFollow.x = boyfriend.getMidpoint().x - 200 + offsetX;
						camFollow.y = boyfriend.getMidpoint().y + offsetY;
					case 'bf-pico-pixel':
						camFollow.x = boyfriend.getMidpoint().x - 300;
						camFollow.y = boyfriend.getMidpoint().y - 250;
					case 'bf-botan-pixel':
						camFollow.x = boyfriend.getMidpoint().x - 300;
						camFollow.y = boyfriend.getMidpoint().y - 150;
					case 'bf-whitty-pixel':
						camFollow.x = boyfriend.getMidpoint().x - 350;
						camFollow.y = boyfriend.getMidpoint().y - 300;
					case 'whitty' | 'bf-exgf':
						camFollow.x = boyfriend.getMidpoint().x - 200 + offsetX;	
					case 'bf-gf' | 'bf-aloe' | 'garcello' | 'ruv' | 'tabi' | 'liz' | 'garcellodead':
						camFollow.x = boyfriend.getMidpoint().x - 200 + offsetX;
					case 'bf-senpai-worried':
						camFollow.x = boyfriend.getMidpoint().x - 300 + offsetX;	
					case 'bf-sky':
						camFollow.x = boyfriend.getMidpoint().x - 200 + offsetX;	
					case 'henry':
						camFollow.x = boyfriend.getMidpoint().x - 200;
					case 'tankman':
						camFollow.x = boyfriend.getMidpoint().x - 200 + offsetX;	
					case 'tabi-glitcher' | 'tabi-wire':
						camFollow.x = boyfriend.getMidpoint().x - 300 + offsetX;
					case 'bf-blantad':
						camFollow.y = boyfriend.getMidpoint().y + offsetY;
					case 'bf-senpai-pixel-angry':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'kou':
						camFollow.y = boyfriend.getMidpoint().y - 10 + offsetY;
					case 'gura-amelia' | 'gura-amelia-walfie':
						camFollow.x = boyfriend.getMidpoint().x - 200;
					case 'sarvente-lucifer':
						camFollow.x = boyfriend.getMidpoint().x - 101 + offsetX;
						camFollow.y = boyfriend.getMidpoint().y - 50 + offsetY;
				}

				if (!curStage.contains('school'))
				{
					switch (boyfriend.curCharacter)
					{
						case 'bf-pixel' | 'bf-pixeld4' | 'bf-pixeld4BSide':
							camFollow.x = boyfriend.getMidpoint().x - 300;
							camFollow.y = boyfriend.getMidpoint().y - 200;
					}	
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong.toLowerCase() == 'demon-training')
		{
			switch (curBeat)
			{
				case 447:
					var oldBFx = boyfriend.x;
					var oldBFy = boyfriend.y;
				case 448:
					var oldBFx = boyfriend.x;
					var oldBFy = boyfriend.y;
					boyfriend.destroy();
					boyfriend = new Boyfriend (oldBFx, oldBFy, 'bf-gf-demon');
					add(boyfriend);
					iconP1.animation.play('gf-demon');
					if (burst.y == 0)
					{
						FlxG.sound.play(Paths.sound('burst'));
						remove(burst);
						burst = new FlxSprite(boyfriend.getMidpoint().x - 600, boyfriend.getMidpoint().y - 300);
						burst.frames = Paths.getSparrowAtlas('shaggy/redburst');
						burst.animation.addByPrefix('burst', "burst", 30);
						burst.animation.play('burst');
						burst.antialiasing = true;
						add(burst);
					}
				case 450:
					burst.destroy();
			}
		}
				

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0 || FlxG.keys.justPressed.R)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (spookyRendered) // move shit around all spooky like
			{
				spookyText.angle = FlxG.random.int(-5,5); // change its angle between -5 and 5 so it starts shaking violently.
				//tstatic.x = tstatic.x + FlxG.random.int(-2,2); // move it back and fourth to repersent shaking.
				if (tstatic.alpha != 0)
					tstatic.alpha = FlxG.random.float(0.1,0.5); // change le alpha too :)
			}

		if (generatedMusic)
			{
				var leNotes:Int = 0;

				if (ModCharts.autoStrum && startedCountdown) { // wtf
					try {
						strumLine.y = strumLineNotes.members[4].y;
					} catch(hmm) {
						trace(hmm);
					}
				}
				notes.forEachAlive(function(daNote:Note)
				{	
					leNotes++;
					if (ModCharts.stickNotes == true)
					{
						var noteNum:Int = 0;
						if (daNote.mustPress)
						{
							noteNum += 4; // set to bfs notes instead
						}
						noteNum += daNote.noteData;
						if (!ModCharts.dadNotesVisible && !daNote.mustPress)
						{
							daNote.visible = false;
						}
						if (!ModCharts.bfNotesVisible && daNote.mustPress)
						{
							daNote.visible = false;
						}

						daNote.x = strumLineNotes.members[noteNum].x;
						if (daNote.isSustainNote && SONG.noteStyle.contains('pixel'))
						{
							daNote.x += daNote.width / 2 + 10;
						}
						else if (daNote.isSustainNote)
						{
							daNote.x += daNote.width / 2 + 20;
						}
						
					}

					if (!daNote.mustPress)
					{
						minusHealth = true;
					}

					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						// mag not be retarded challange(failed instantly)
						if (daNote.mustPress)
						{
							daNote.visible = ModCharts.bfNotesVisible;
							daNote.active = true;
						}
						else
						{
							daNote.visible = ModCharts.dadNotesVisible;
							daNote.active = true;
						}
					}
					
					if (!daNote.modifiedByLua)
						{
							if (FlxG.save.data.downscroll)
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									// Remember = minus makes notes go up, plus makes them go down
									if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
										daNote.y += daNote.prevNote.height;
									else
										daNote.y += daNote.height / 2;
	
									// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
	
											daNote.clipRect = swagRect;
										}
									}else if (!daNote.burning)
									{
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
	
										daNote.clipRect = swagRect;
									}
								}
							}else
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									daNote.y -= daNote.height / 2;
	
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
	
											daNote.clipRect = swagRect;
										}
									}else if (!daNote.burning)
									{
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
	
										daNote.clipRect = swagRect;
									}
								}
							}
						}

					#if windows
					if (luaModchart != null)
					{
						if (luaModchart.getVar("dadNotesInvisible",'bool'))
						{
							if (!daNote.mustPress)
								daNote.visible = false;
						}		
						else
						{
							if (!daNote.mustPress)
								daNote.visible = true;
						}					
					}
					#end
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						switch (curSong)
						{
							case 'Tutorial' | 'Tutorial-Remix' | 'Get Out' | 'Their-Battle':
								camZooming = false;
							default:
								camZooming = true;
						}

						dad.altAnim = "";

						#if windows
						if (luaModchart != null)
						{
							if (luaModchart.getVar("dadAltAnim",'bool'))
								dad.altAnim = '-alt';
							else
								dad.altAnim = "";
						}
						#end
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							{
								dad.altAnim = '-alt';
							}

							switch (curSong)
							{
								case 'Ugh':
									switch (curStep)
									{
										case 60 | 444 | 524 | 540 | 541 | 828 | 829 | 830 | 831 | 832 | 833 | 834 | 835 | 836:
											dad.altAnim = '-alt';
									}
								case 'Accidental-Bop':
									switch (curStep)
									{
										case 892:
											dad.altAnim = '-alt';
									}
								case 'Pom-Pomeranian':
									switch (curStep)
									{
										case 1294:
											dad.altAnim = '';
									}
								case 'Ugh-Remix':
									if (ughStepsDad.contains(curStep))
									{
										dad.altAnim = '-alt';
									}
								case 'Ballistic':
									if (shootStepsBallistic.contains(curStep) && !inCutscene  && dad.curCharacter == 'picoCrazy')
									{
										dad.altAnim = '-alt';
									}
								case 'Context':
									if (kCool) 
									{
										if (curStep >= 626)
										{
											dad.altAnim = '-alt';
										}	
									}
								case 'Roses-Remix':
									switch (curStep)
									{
										case 396 | 398 | 404 | 406 | 412 | 413:
											dad.altAnim = '-alt';
									}
							}					
						}
						
						if (!(curBeat >= 532 && curBeat < 536  && curSong.toLowerCase() == "expurgation") && !(curBeat == 548 && curSong.toLowerCase() == "hands"))
						{
							switch (Math.abs(daNote.noteData))
							{
								case 2:
									dad.playAnim('singUP' + dad.altAnim, true);
								case 3:
									dad.playAnim('singRIGHT' + dad.altAnim, true);
								case 1:
									dad.playAnim('singDOWN' + dad.altAnim, true);
								case 0:
									dad.playAnim('singLEFT' + dad.altAnim, true);
							}
						}

						switch(dad.curCharacter)
						{
							case 'cjClone': // 50% chance
								if (FlxG.random.bool(50) && !spookyRendered && !daNote.isSustainNote && curStage == 'auditorHell') // create spooky text :flushed:
									{
										createSpookyText(cjCloneLinesSing[FlxG.random.int(0,cjCloneLinesSing.length)]);
									}
							case 'b3-mom-mad':
								health -= 0.03;
							case 'taki':
								if (curSong.toLowerCase() != 'crucify')
								{
									health -= 0.02;
								}		
						}

						switch (curSong.toLowerCase())
						{
							case 'crucify':
								health -= 0.02;
								if (!dad.curCharacter.contains('gf'))
								{
									gf.playAnim('scared');
								}
							case 'hunger':
								health += 0.01;
						}

						switch (curStage)
						{
							case 'churchgospel':
								var spin:Int = FlxG.random.int(1,3);
								circ1new.angle += spin;
						}
						
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('dadNoteHit', []);
						#end

						cpuStrums.forEach(function(spr:FlxSprite)
						{
							if (isPixel)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm2', true);
								}

								spr.centerOffsets();
							}	

							else
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);

								}
								if (spr.animation.curAnim.name == 'confirm' && !SONG.noteStyle.contains('pixel'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							}				
						});
	
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
						#end

						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					
					

					if (daNote.isSustainNote && SONG.noteStyle.contains('pixel'))
					{
						daNote.x += daNote.width / 2 + 10;
					}
					else if (daNote.isSustainNote)
					{
						daNote.x += daNote.width / 2 + 20;
					}

					if (daNote.burning && curStage == 'auditorHell')
					{
						daNote.x -= 165;
					}
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if ((daNote.mustPress && daNote.tooLate && !FlxG.save.data.downscroll || daNote.mustPress && daNote.tooLate && FlxG.save.data.downscroll) && daNote.mustPress && !daNote.burning)
					{
							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
							}
							if (daNote.danger)
							{
								health -= 1;
								totalDamageTaken += 1;
								interupt = true;
								if (theFunne)
									noteMiss(daNote.noteData, daNote);
							}
							else
							{
								health -= 0.02;
								totalDamageTaken += 0.02;
								interupt = true;
								vocals.volume = 0;
								if (theFunne)
									noteMiss(daNote.noteData, daNote);
							}
		
							daNote.visible = false;
							daNote.kill();
							notes.remove(daNote, true);
						}
					
				});
				if (leNotes == 0)
				{
					minusHealth = false;
				}
			}

			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					if (isPixel)
					{
						spr.animation.play('static2');
						spr.centerOffsets();
					}
					else
					{
						spr.animation.play('static');
						spr.centerOffsets();

						if (spr.animation.curAnim.name == 'confirm' && !SONG.noteStyle.contains('pixel'))
						{
							spr.centerOffsets();
							spr.offset.x -= 13;
							spr.offset.y -= 13;
						}
						else
							spr.centerOffsets();
					}	
				}

				if (isPixel && spr.animation.curAnim.name == 'static')
				{
					spr.animation.play('static2');
					spr.centerOffsets();
				}
				else if (!isPixel && spr.animation.curAnim.name == 'static2')
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});

			if (FlxG.save.data.botplay)
			{
				playerStrums.forEach(function(spr:FlxSprite)
					{
						if (spr.animation.finished)
						{
							if (isPixel)
							{
								spr.animation.play('static2');
								spr.centerOffsets();
							}
							else
							{
								spr.animation.play('static');
								spr.centerOffsets();
		
								if (spr.animation.curAnim.name == 'confirm' && !SONG.noteStyle.contains('pixel'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							}	
						}
		
						if (isPixel && spr.animation.curAnim.name == 'static')
						{
							spr.animation.play('static2');
							spr.centerOffsets();
						}
						else if (!isPixel && spr.animation.curAnim.name == 'static2')
						{
							spr.animation.play('static');
							spr.centerOffsets();
						}
					});
			}

		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			songOutro();
		#end
	}

	function createSpookyText(text:String, x:Float = -1111111111111, y:Float = -1111111111111):Void
	{
		spookySteps = curStep;
		spookyRendered = true;
		tstatic.alpha = 0.5;
		FlxG.sound.play(Paths.sound('tricky/staticSound','shared'));
		spookyText = new FlxText((x == -1111111111111 ? FlxG.random.float(dad.x + 40,dad.x + 120) : x), (y == -1111111111111 ? FlxG.random.float(dad.y + 200, dad.y + 300) : y));
		spookyText.setFormat(Paths.font("impact.ttf"), 128, FlxColor.RED);
		spookyText.bold = true;
		spookyText.text = text;
		add(spookyText);
	}

	function songOutro():Void
	{
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		canPause = false;
		camFollowIsOn = true;
		defaultCamFollow = true;

		if (isStoryMode || showCutscene)
		{
			switch (curSong.toLowerCase())
			{
				case 'ballistic':
					picoEnd(doof4);
				default:
					endSong();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					endSong();
			}
		}
				
	}

	function endSong():Void
	{
		if (useVideo)
			{
				GlobalVideo.get().stop();
				PlayState.instance.remove(PlayState.instance.videoSprite);
			}

		if (!loadRep)
			rep.SaveReplay(saveNotes);
		else
		{
			FlxG.save.data.botplay = false;
			FlxG.save.data.scrollSpeed = 1;
			FlxG.save.data.downscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		isPixel = false;
		showCutscene = false;
		if (curSong == 'Ballistic')
		{
			picoCutscene = false;
		}	

		//if (curSong.toLowerCase == 'deathmatch' && storyDifficulty == 2 && songScore >= 160000)
		//	FlxG.save.data.hardBeaten = true;

		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			// adjusting the highscore song name to be compatible
			// would read original scores if we didn't change packages
			var songHighscore = StringTools.replace(PlayState.SONG.song, " ", "-");
			switch (songHighscore) {
				case 'Dad-Battle': songHighscore = 'Dadbattle';
				case 'Philly-Nice': songHighscore = 'Philly';
			}

			#if !switch
			Highscore.saveScore(songHighscore, Math.round(songScore), storyDifficulty);
			Highscore.saveCombo(songHighscore, Ratings.GenerateLetterRank(accuracy), storyDifficulty);
			#end
		}

			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					FlxG.switchState(new StoryMenuState());

					#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end

					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					
					// adjusting the song name to be compatible
					var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
					switch (songFormat) {
						case 'Dad-Battle': songFormat = 'Dadbattle';
						case 'Philly-Nice': songFormat = 'Philly';
					}

					var poop:String = Highscore.formatSong(songFormat, storyDifficulty);

					trace('LOADING NEXT SONG');
					trace(poop);

					if (StringTools.replace(PlayState.storyPlaylist[0], " ", "-").toLowerCase() == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;


					PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
			else if (isBETADCIU)
			{
				trace('WENT BACK TO BETADCIU MENU??');
				FlxG.switchState(new BETADCIUState());
			}
			else if (isBonus)
			{
				trace('WENT BACK TO Bonus Song MENU??');			
				FlxG.switchState(new BonusSongsState());
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				FlxG.switchState(new FreeplayState());
			}
		}

	function bobJumpscare():Void
	{
		camHUD.visible = false;
	}

	var endingSong:Bool = false;

	var hits:Array<Float> = [];

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
			var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				case 'shit':
					score = -300;
					combo = 0;
					misses++;
					health -= 0.0475;
					totalDamageTaken += 0.0475;
					ss = false;
					shits++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.25;
				case 'bad':
					daRating = 'bad';
					score = 0;
					health -= 0.02;
					totalDamageTaken += 0.02;
					ss = false;
					bads++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.50;
				case 'good':
					daRating = 'good';
					score = 200;
					ss = false;
					goods++;
					if (health < 2 && curSong != 'Hunger')
						health += 0.02;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.75;
				case 'sick':
					if (health < 2 && curSong != 'Hunger')
						health += 0.0475;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 1;
					sicks++;
			}

			if(FlxG.save.data.noteSplash && daRating == 'sick')
			{
				if (curSong != 'Storm')
				{
					var a:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
					a.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
					grpNoteSplashes.add(a);
				}		
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
			
			if (isPixel)
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}

			if (curSong == 'Storm')
			{
				pixelShitPart1 = 'bw/';
			}

			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y += 200;
			rating.x = coolText.x - 40;
			rating.y -= 60;
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			if (curSong == 'Demon-Training' && curStep >= 1024)
			{
				rating.x += 100;
				rating.y += -2500;
			}
			if (curStage == 'facility')
			{
				rating.x += 525;
				rating.y += 380;
			}
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(FlxG.save.data.botplay) msTiming = 0;							   
			
			comboSpr = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = coolText.x;
			comboSpr.y += 200;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			comboSpr.velocity.x += FlxG.random.int(1, 10);
			add(rating);
	
			if (!curStage.startsWith('school') && !isPixel)
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			comboSpr.updateHitbox();
			rating.updateHitbox();

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			// make sure we have 3 digits to display (looks weird otherwise lol)
			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = coolText.x + (43 * daLoop) - 90;
				numScore.y += 80 + 200;

				if (!curStage.startsWith('school') && !isPixel)
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				add(numScore);

				if (curSong == 'Demon-Training' && curStep >= 1024)
				{
					numScore.x += 100;
					numScore.y += -2500;
				}

				if (curSong == 'Remorse')
				{
					numScore.x += 525;
					numScore.y += 380;
				}
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
				#if windows
				if (luaModchart != null){
				if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
				if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
				if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
				if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
				};
				#end
		 
				// Prevent player input if botplay is on
				if(FlxG.save.data.botplay)
				{
					holdArray = [false, false, false, false];
					pressArray = [false, false, false, false];
					releaseArray = [false, false, false, false];
				} 
				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				}
		 
				// PRESSES, check for note hits
				if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					boyfriend.holdTimer = 0;
		 
					var possibleNotes:Array<Note> = []; // notes that can be hit
					var directionList:Array<Int> = []; // directions that can be hit
					var dumbNotes:Array<Note> = []; // notes to kill later
					var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
					
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
						{
							if (!directionsAccounted[daNote.noteData])
							{
								if (directionList.contains(daNote.noteData))
								{
									directionsAccounted[daNote.noteData] = true;
									for (coolNote in possibleNotes)
									{
										if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
										{ // if it's the same note twice at < 10ms distance, just delete it
											// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
											dumbNotes.push(daNote);
											break;
										}
										else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
										{ // if daNote is earlier than existing note (coolNote), replace
											possibleNotes.remove(coolNote);
											possibleNotes.push(daNote);
											break;
										}
									}
								}
								else
								{
									possibleNotes.push(daNote);
									directionList.push(daNote.noteData);
								}
							}
						}
					});

					trace('\nCURRENT LINE:\n' + directionsAccounted);
		 
					for (note in dumbNotes)
					{
						FlxG.log.add("killing dumb ass note at " + note.strumTime);
						note.kill();
						notes.remove(note, true);
						note.destroy();
					}
		 
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
		 
					var dontCheck = false;

					for (i in 0...pressArray.length)
					{
						if (pressArray[i] && !directionList.contains(i))
							dontCheck = true;
					}

					if (perfectMode)
						goodNoteHit(possibleNotes[0]);
					else if (possibleNotes.length > 0 && !dontCheck)
					{
						if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								{ // if a direction is hit that shouldn't be
									if (pressArray[shit] && !directionList.contains(shit))
									{
										interupt = true;
										noteMiss(shit, null);
									}		
								}
						}
						for (coolNote in possibleNotes)
						{
							if (pressArray[coolNote.noteData])
							{
								if (mashViolations != 0)
									mashViolations--;
								if (curSong == 'Storm')
								{
									scoreTxt.color = FlxColor.BLACK;
								}
								else
								{
									scoreTxt.color = FlxColor.WHITE;
								}
								if (coolNote.burning)
									{
										if (curStage == 'auditorHell')
										{
											// lol death
											health = 0;
											shouldBeDead = true;
											FlxG.sound.play(Paths.sound('tricky/death', 'shared'));
										}
									}
								else
									goodNoteHit(coolNote);
							}
						}
					}
					else if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								if (pressArray[shit])
								{
									interupt = true;
									noteMiss(shit, null);
								}		
						}

					if(dontCheck && possibleNotes.length > 0 && FlxG.save.data.ghost && !FlxG.save.data.botplay)
					{
						if (mashViolations > 8)
						{
							trace('mash violations ' + mashViolations);
							scoreTxt.color = FlxColor.RED;
							noteMiss(0,null);
						}
						else
							mashViolations++;
					}

				}
				
				notes.forEachAlive(function(daNote:Note)
				{
					if(FlxG.save.data.downscroll && daNote.y > strumLine.y ||
					!FlxG.save.data.downscroll && daNote.y < strumLine.y)
					{
						// Force good note hit regardless if it's too late to hit it or not as a fail safe
						if(FlxG.save.data.botplay && daNote.canBeHit && daNote.mustPress ||
						FlxG.save.data.botplay && daNote.tooLate && daNote.mustPress)
						{
							if(loadRep)
							{
								//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
								if(rep.replay.songNotes.contains(HelperFunctions.truncateFloat(daNote.strumTime, 2)))
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = 0;
								}
							}else 
							{
								if (!daNote.burning)
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = 0;
								}		
							}
						}
					}
				});
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || FlxG.save.data.botplay))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
					{		
						boyfriend.dance();
					}
				}
		 
				if (!FlxG.save.data.botplay)
				{
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (isPixel)
						{
							if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm2')
								spr.animation.play('pressed2');
							if (!holdArray[spr.ID])
								spr.animation.play('static2');

								spr.centerOffsets();
						}

						else
						{
							if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
								spr.animation.play('pressed');
							if (!holdArray[spr.ID])
								spr.animation.play('static');
				
							if (spr.animation.curAnim.name == 'confirm' && !SONG.noteStyle.contains('pixel'))
							{
								spr.centerOffsets();
								spr.offset.x -= 13;
								spr.offset.y -= 13;
							}
							else
								spr.centerOffsets();
						}	
					});
				}		
			}

			public var fuckingVolume:Float = 1;
			public var useVideo = false;

			public static var webmHandler:WebmHandler;

			public var playingDathing = false;

			public var videoSprite:FlxSprite;

			public function backgroundVideo(source:String) // for background videos
				{
					useVideo = true;
			
					var ourSource:String = "assets/videos/daWeirdVid/dontDelete.webm";
					var str1:String = "WEBM SHIT"; 
					webmHandler = new WebmHandler();
					webmHandler.source(ourSource);
					webmHandler.makePlayer();
					webmHandler.webm.name = str1;
			
					GlobalVideo.setWebm(webmHandler);

					GlobalVideo.get().source(source);
					GlobalVideo.get().clearPause();
					if (GlobalVideo.isWebm)
					{
						GlobalVideo.get().updatePlayer();
					}
					GlobalVideo.get().show();
			
					if (GlobalVideo.isWebm)
					{
						GlobalVideo.get().restart();
					} else {
						GlobalVideo.get().play();
					}
					
					var data = webmHandler.webm.bitmapData;
			
					videoSprite = new FlxSprite(-470,-30).loadGraphic(data);
			
					videoSprite.setGraphicSize(Std.int(videoSprite.width * 1.2));
			
					remove(gf);
					remove(boyfriend);
					remove(dad);
					add(videoSprite);
					 add(gf);
					add(boyfriend);
					add(dad);
			
					trace('poggers');
			
					if (!songStarted)
						webmHandler.pause();
					else
						webmHandler.resume();
				}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			interupt = true;
			minusHealth = true;
			health -= 0.05;
			totalDamageTaken += 0.05;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss' + boyfriend.bfAltAnim, true);
				case 1:
					boyfriend.playAnim('singDOWNmiss' + boyfriend.bfAltAnim, true);
				case 2:
					boyfriend.playAnim('singUPmiss' + boyfriend.bfAltAnim, true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss' + boyfriend.bfAltAnim, true);
			}

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end


			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff);

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
		{
				minusHealth = false;

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

				note.rating = Ratings.CalculateRating(noteDiff);

				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;

					boyfriend.bfAltAnim = '';

					#if windows
					if (luaModchart != null)
					{
						if (luaModchart.getVar("bfAltAnim",'bool'))
							boyfriend.bfAltAnim = '-alt';
						else
							boyfriend.bfAltAnim = "";
					}
					#end

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].bfAltAnim)
						{
							boyfriend.bfAltAnim = '-alt';	
						}
							
						switch (curSong)
						{
							case 'Guns':
								if (curStep >= 1374 && boyfriend.curCharacter == 'bf-sky')
								{
									boyfriend.bfAltAnim = '-alt';
								}
							case 'Ugh':
								switch (curStep)
								{
									case 124 | 588 | 604 | 605:
										boyfriend.bfAltAnim = '-alt';
								}
							case 'Nerves':
								switch (curStep)
								{
									case 443 | 444 | 445:
										boyfriend.bfAltAnim = '-alt';
								}
							case 'Pom-Pomeranian':
								switch (curStep)
								{
									case 1358:
										boyfriend.bfAltAnim = '';
								}
							case 'Ugh-Remix':
								if (ughStepsBF.contains(curStep))
								{
									boyfriend.bfAltAnim = '-alt';
								}
						}

						if (curSong == 'Treacherous-Dads')
						{
							if (bfTransformSteps.contains(curStep) && !inCutscene)
							{
								boyfriend.bfAltAnim = '-alt';
							}
						}
					}

					switch (note.noteData)
					{
						case 2:
							boyfriend.playAnim('singUP' + boyfriend.bfAltAnim, true);
						case 3:
							boyfriend.playAnim('singRIGHT' + boyfriend.bfAltAnim, true);
						case 1:
							boyfriend.playAnim('singDOWN' + boyfriend.bfAltAnim, true);
						case 0:
							boyfriend.playAnim('singLEFT' + boyfriend.bfAltAnim, true);
					}
						
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end


					if(!loadRep && note.mustPress)
						saveNotes.push(HelperFunctions.truncateFloat(note.strumTime, 2));

					switch (curSong.toLowerCase())
					{
						case 'hunger':
							health -= 0.01;
					}
					switch (curStage)
					{
						case 'churchgospel':
							var spin:Int = FlxG.random.int(1, 3);
							circ1new.angle -= spin;
					}
					
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (isPixel)
							{
								if (Math.abs(note.noteData) == spr.ID)
								{
									spr.animation.play('confirm2', true);
								}

								spr.centerOffsets();
							}	

							else
							{
								if (Math.abs(note.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);

								}
								if (spr.animation.curAnim.name == 'confirm' && !SONG.noteStyle.contains('pixel'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							}					
					});
					
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		

	var fastCarCanDrive:Bool = true;
	var resetSpookyText:Bool = true;

	function moveTank()
	{
		if(!inCutscene)
		{
			tankAngle += FlxG.elapsed * tankSpeed;
			tankRolling.angle = tankAngle - 90 + 15;
			tankRolling.x = tankX + 1500 * Math.cos(Math.PI / 180 * (1 * tankAngle + 180));
			tankRolling.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (1 * tankAngle + 180));
		}
	}

	function resetSpookyTextManual():Void
	{
		trace('reset spooky');
		spookySteps = curStep;
		spookyRendered = true;
		tstatic.alpha = 0.5;
		FlxG.sound.play(Paths.sound('tricky/staticSound','shared'));
		resetSpookyText = true;
	}

	function manuallymanuallyresetspookytextmanual()
	{
		remove(spookyText);
		spookyRendered = false;
		tstatic.alpha = 0;
	}

	function resetFastCar():Void
	{
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
	}

	var isbobmad:Bool = true;
	function shakescreen()
	{
		new FlxTimer().start(0.01, function(tmr:FlxTimer)
		{
			FlxG.camera.shake(0.1, 0.1);
		});
	}
	
	function resetBobismad():Void
	{
		camHUD.visible = true;
		bobsound.pause();
		bobmadshake.visible = false;
		bobsound.volume = 0;
		isbobmad = true;
	}

	function Bobismad()
	{
		camHUD.visible = false;
		bobmadshake.visible = true;
		bobsound.play();
		bobsound.volume = 1;
		isbobmad = false;
		shakescreen();
		new FlxTimer().start(0.5 , function(tmr:FlxTimer)
		{
			resetBobismad();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
			if (trainSound.time >= 4700)
				{
					startedMoving = true;
					gf.playAnim('hairBlow');
				}
		
				if (startedMoving)
				{
					phillyTrain.x -= 400;
		
					if (phillyTrain.x < -2000 && !trainFinishing)
					{
						phillyTrain.x = -1150;
						trainCars -= 1;
		
						if (trainCars <= 0)
							trainFinishing = true;
					}
		
					if (phillyTrain.x < -4000 && trainFinishing)
						trainReset();
				}
	}

	function trainReset():Void
	{
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		if (boyfriend.animOffsets.exists('scared'))
		{
			boyfriend.playAnim('scared', true);
		}

		if (gf.animOffsets.exists('scared'))
		{
			gf.playAnim('scared', true);
		}
	}

	function ruvShake():Void
	{
		FlxG.camera.shake(0.005, 0.1);
		ruvShakeBeat = curBeat;
	
		if (curSong == 'Ugh' && curBeat == 223)
		{
			FlxG.camera.shake(0.03, 0.1);
		}	
		
		if (gf.animOffsets.exists('scared'))
		{
			gf.playAnim('scared', true);
		}
	}

	function bgFlash():Void
	{
		if(!inCutscene)
		{
			flashSprite.alpha = 0.4;
			FlxTween.tween(flashSprite, {alpha: 0}, 0.2);
		}
			
	}

	var danced:Bool = false;

	var stepOfLast = 0;

	override function stepHit()
	{
		super.stepHit();

		dad.altAnim = "";

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].altAnim)
				dad.altAnim = '-alt';	

			if (curSong == 'Context')
				{
					if (kCool) 
					{
						if (curStep >= 626)
						{
							dad.altAnim = '-alt';
						}	
					}
				}	
		}

		boyfriend.bfAltAnim = "";

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].bfAltAnim)
				boyfriend.bfAltAnim = '-alt';

			if (curSong == 'Treacherous-Dads')
			{
				if (bfTransformSteps.contains(curStep) && !inCutscene)
				{
					boyfriend.bfAltAnim = '-alt';
				}
			}
		}

		if (curSong == 'Ballistic' && dad.curCharacter == "picoCrazy")
		{
			if(shootStepsBallistic.contains(curStep) && !inCutscene)
			{
				FlxG.sound.play(Paths.sound("shooters"), 1);
				FlxG.camera.shake(0.01, 0.15);
				new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					dad.playAnim("idle", true);
				});
			}
		}

		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		switch (curSong)
		{
			case 'Context':	
				switch (curStep)
				{
					case 1:
						camMovement = 0.02;
						defaultCamZoom = 1.0;
					case 19:
						camMovement = 0.09;
						defaultCamZoom = 0.8;
					case 51:
						camMovement = 0.09;
						defaultCamZoom = 1.0;
					case 63:
						camMovement = 0.09;
						defaultCamZoom = 0.7;
					case 75:
						camMovement = 0.09;
						defaultCamZoom = 0.8;
					case 83:
						camMovement = 0.09;
						defaultCamZoom = 1.0;
					case 95:
						camMovement = 0.09;
						defaultCamZoom = 0.7;
					case 107:
						camMovement = 0.09;
						defaultCamZoom = 0.8;
					case 115:
						camMovement = 0.09;
						defaultCamZoom = 0.7;
						FlxG.camera.flash(FlxColor.WHITE, 0.2);
						shakeCam = true;
					case 119:
						shakeCam = false;
					case 147:
						camMovement = 0.09;
						defaultCamZoom = 1.0;
					case 179:
						camMovement = 0.09;
						defaultCamZoom = 0.7;
					case 195:
						camMovement = 0.09;
						defaultCamZoom = 0.8;
					case 211:
						camMovement = 0.09;
						defaultCamZoom = 1.0;
					case 223:
						camMovement = 0.09;
						defaultCamZoom = 0.8;
					case 307:
						camMovement = 0.09;
						defaultCamZoom = 0.7;
					case 377:
						camMovement = 0.09;
						defaultCamZoom = 0.8;
					case 467:
						camMovement = 0.09;
						defaultCamZoom = 0.9;
					case 499:
						camMovement = 0.09;
						defaultCamZoom = 0.8;
					case 626:
						camMovement = 0.09;
						defaultCamZoom = 0.7;
						FlxG.camera.flash(FlxColor.WHITE, 0.2);
						shakeCam = true;
					case 630:
						shakeCam = false;
					case 643:
						camMovement = 0.09;
						defaultCamZoom = 1.0;
					case 655:
						camMovement = 0.09;
						defaultCamZoom = 0.8;
					case 677:
						camMovement = 0.09;
						defaultCamZoom = 1.0;
					case 691:
						camMovement = 0.09;
						defaultCamZoom = 0.8;
					case 773:
						camMovement = 0.09;
						defaultCamZoom = 1.0;
					case 787:
						camMovement = 0.09;
						defaultCamZoom = 0.8;
					case 819:
						camMovement = 0.09;
						defaultCamZoom = 0.7;
					case 883:
						camMovement = 0.09;
						defaultCamZoom = 0.8;
					case 948:
						FlxG.camera.flash(FlxColor.WHITE, 0.2);
						shakeCam = true;
						camMovement = 0.02;
						defaultCamZoom = 1.0;
					case 952:
						shakeCam = false;
					case 1011:
						new FlxTimer().start(0.1, function(tmr:FlxTimer)
						{
							defaultCamZoom -= 0.04;
							if (defaultCamZoom > 0.8)
							{
								tmr.reset(0.1);
							}
							else
							{
								//add(garsmoke);
								trace('elcamera do good');
							}
						});	
				}
			case 'Demon-Training':
				switch(curStep)
				{
					case 1024:
						FlxG.camera.flash(FlxColor.WHITE, 2, false);
						FlxG.sound.play(Paths.sound('rockFly'));
						defaultCamZoom = 0.65;
						normbg.alpha = 0;
						dad.x += -200;
						dad.y += -2500;
						dadrock.x = dad.x - 200;
						dadrock.y = dad.y + 600;
						dadrock.alpha = 1;
						boyfriend.x += 600;
						boyfriend.y += -2450;
						rock.x = boyfriend.x - 200;
						rock.y = boyfriend.y + 260;
						rock.alpha = 1;
						gf.scrollFactor.set(0.8, 0.8);
						gf.setGraphicSize(Std.int(gf.width * 0.8));
						gf.x += 100;
						gf.y += -2000;
						gf_rock.x = gf.x + 80;
						gf_rock.y = gf.y + 530;
						gf_rock.alpha = 1;		
				}
		}

		if (curSong == 'Context')
		{
			switch (curStep)
			{
				case 322:
					if (accuracy > 90) 
					{
						camMovement = 0.02;
						new FlxTimer().start(0.1, function(tmr:FlxTimer)
						{
							defaultCamZoom += 0.04;
							if (defaultCamZoom < 1.0)
							{
								tmr.reset(0.1);
							}
							else
							{
								//add(garsmoke);
								trace('elcamera do good');
							}
						});

						boyfriend.playAnim('lol-special');
					}
					if (accuracy < 70)
					{
						camMovement = 0.02;
						new FlxTimer().start(0.1, function(tmr:FlxTimer)
						{
							defaultCamZoom += 0.04;
							if (defaultCamZoom < 1.0)
							{
								tmr.reset(0.1);
							}
							else
							{
								//add(garsmoke);
								trace('elcamera do good');
							}
						});

						boyfriend.playAnim('frick-special');
					}

				case 335:
					if (boyfriend.animation.curAnim.name.startsWith("lol")) 
					{
						boyfriend.playAnim('idle');
					}
				case 338:
					if (boyfriend.animation.curAnim.name.startsWith("sing")) 
					{
						camMovement = 0.09;
						defaultCamZoom = 0.7;
					}
					
				case 355:
					dad.playAnim('huh-special');
					FlxG.sound.play(Paths.sound('huh'));

				case 578:
					if (accuracy > 75)
					{
						camMovement = 0.02;
						new FlxTimer().start(0.1, function(tmr:FlxTimer)
						{
							defaultCamZoom += 0.04;
							if (defaultCamZoom < 1.0)
							{
								tmr.reset(0.1);
							}
							else
							{
								//add(garsmoke);
								trace('elcamera do good');
							}
						});
					}
				case 579:
					if (accuracy < 70)
					{
						boyfriend.playAnim('hit-special');
					}

				case 588:
					if (accuracy > 75) 
					{
						boyfriend.playAnim('dab-special');
					}
					
				case 594:
					if (boyfriend.animation.curAnim.name.startsWith("sing"))
					{
						camMovement = 0.09;
						defaultCamZoom = 0.8;
					}
				case 610:
					if (accuracy > 75) 
					{
						camMovement = 0.02;
						new FlxTimer().start(0.1, function(tmr:FlxTimer)
						{
							defaultCamZoom += 0.04;
							if (defaultCamZoom < 1.0)
							{
								tmr.reset(0.1);
							}
							else
							{
								//add(garsmoke);
								trace('elcamera do good');
							}
						});

						dad.playAnim('grr-special');
						FlxG.sound.play(Paths.sound('hmph'));

						kCool = true;
					}
					else {
						camMovement = 0.02;
						new FlxTimer().start(0.1, function(tmr:FlxTimer)
						{
							defaultCamZoom += 0.04;
							if (defaultCamZoom < 1.0)
							{
								tmr.reset(0.1);
							}
							else
							{
								//add(garsmoke);
								trace('elcamera do good');
							}
						});
						dad.playAnim('derp-special');

						kCool = false;
					}

				case 626:
					var oldDadX = dad.x;
					var oldDadY = dad.y;
					var oldBFX = boyfriend.x;
					var oldBFY = boyfriend.y;
					var oldGFX = gf.x;
					var oldGFY = gf.y;
					if (!kCool)
					{
						changeGFCharacter(oldGFX, oldGFY, 'gf-nene-cry');
						changeDadCharacter(oldDadX + 201, oldDadY + 121, 'sky-happy');
						changeBoyfriendCharacter(oldBFX, oldBFY, 'bf-aloe-confused');
						iconP2.animation.play('sky-purehappiness');
					}
			}
		}
			
		if (curStage == 'auditorHell' && curStep != stepOfLast)
		{
			switch(curStep)  	
			{
				case 384:
					doStopSign(0);
				case 511:
					doStopSign(2);
					doStopSign(0);
				case 610:
					doStopSign(3);
				case 720:
					doStopSign(2);
				case 991:
					doStopSign(3);
				case 1184:
					doStopSign(2);
				case 1218:
					doStopSign(0);
				case 1235:
					doStopSign(0, true);
				case 1200:
					doStopSign(3);
				case 1328:
					doStopSign(0, true);
					doStopSign(2);
				case 1439:
					doStopSign(3, true);
				case 1567:
					doStopSign(0);
				case 1584:
					doStopSign(0, true);
				case 1600:
					doStopSign(2);
				case 1706:
					doStopSign(3);
				case 1917:
					doStopSign(0);
				case 1923:
					doStopSign(0, true);
				case 1927:
					doStopSign(0);
				case 1932:
					doStopSign(0, true);
				case 2032:
					doStopSign(2);
					doStopSign(0);
				case 2036:
					doStopSign(0, true);
				case 2144:
					dad.playAnim('idle', true);
				case 2162:
					doStopSign(2);
					doStopSign(3);
				case 2193:
					doStopSign(0);
				case 2202:
					doStopSign(0,true);
				case 2239:
					doStopSign(2,true);
				case 2258:
					doStopSign(0, true);
				case 2304:
					doStopSign(0, true);
					doStopSign(0);	
				case 2326:
					doStopSign(0, true);
				case 2336:
					doStopSign(3);
				case 2447:
					doStopSign(2);
					doStopSign(0, true);
					doStopSign(0);	
				case 2480:
					doStopSign(0, true);
					doStopSign(0);	
				case 2512:
					doStopSign(2);
					doStopSign(0, true);
					doStopSign(0);
				case 2544:
					doStopSign(0, true);
					doStopSign(0);	
				case 2575:
					doStopSign(2);
					doStopSign(0, true);
					doStopSign(0);
				case 2608:
					doStopSign(0, true);
					doStopSign(0);	
				case 2604:
					doStopSign(0, true);
				case 2655:
					doGremlin(20,13,true);
			}
			stepOfLast = curStep;
		}

		switch (curSong.toLowerCase())
		{
			case 'fading-senpai':
				switch (curStep)
				{
					case 247:
						dad.playAnim('disappear', true);
				}
			case 'pom-pomeranian':
				switch (curStep)
				{
					case 756 | 760 | 764:
						FlxG.camera.zoom += 0.25;
					case 768:
						add(bgcrowdjump);
						bgcrowd.alpha = 0;
					case 974 | 982 | 1006 | 1014 | 1164 | 1166 | 1312 | 1316 | 1320 | 1324 | 1376 | 1380 | 1384 | 1388:
						FlxG.camera.zoom += 0.02;
					case 976 | 984 | 1008 | 1016 | 1020 | 1168 | 1328 | 1330 | 1332 | 1392 | 1394 | 1396 | 1520 | 1528:
						FlxG.camera.zoom += 0.05;
				}
			case 'manifest':
				switch (curStep)
				{
					case 1504:
						//this is bullshit
						changeDadCharacter(120, -25, 'tabi-crazy');
						tabiTrail = new FlxTrail(dad, null, 4, 24, 0.6, 0.9);
						add(tabiTrail);
					case 1628:
						remove(tabiTrail);		
				}
			case 'hands':
				switch (curStep)
				{
					case 1088:
						//this is bullshit part 2
						grpLimoDancersHolo.forEach(function(dancer:BackgroundDancerHolo)
						{
							FlxTween.tween(dancer, {x: dancer.x, y: dancer.y - 3800}, 1, {ease: FlxEase.quadInOut});
						});	
						upperSky.velocity.x = 5;	
						upperSky2.velocity.x = 5;	
				}
		}


		if (curSong == 'Takeover')
		{
			switch (curStep)
			{
				case 512:
					remove(dad);
					remove(boyfriend);
					remove(gf);
					shut.play();
					add(justMonika);
					bg.alpha = 0;
					camHUD.visible = false;
					paused = true;
					inCutscene = true;
					isPixel = true;
				case 524:
					remove(justMonika);
					add(blackScreen);
					
					giggle.play();

					FlxG.save.data.downscroll = !FlxG.save.data.downscroll;

					if (FlxG.save.data.downscroll)
					{
						downScrollEvent = true;
						strumLineNotes.forEach(function(note)
						{
							ModCharts.addTrailToSprite(note);
							ModCharts.moveStrumNotes(playerStrums, 650, FlxG.height - 165, 0.1, 110, 0);
							ModCharts.moveStrumNotes(cpuStrums, -50, FlxG.height - 165, 0.1, 110, 0);
						});
					}
					else
					{
						upScrollEvent = true;
						strumLineNotes.forEach(function(note)
						{
							ModCharts.addTrailToSprite(note);
							ModCharts.moveStrumNotes(playerStrums, 650, 50, 0.1, 110, 0);
							ModCharts.moveStrumNotes(cpuStrums, -50, 50, 0.1, 110, 0);
						});	
					}
	
				case 528:
					for (note in 0...strumLineNotes.members.length) 
					{
						ModCharts.circleLoop(strumLineNotes.members[note], 50, 2);
					}
					paused = false;
					inCutscene = false;
					space.alpha = 1;
					bg2.alpha = 1;
					stageFront2.alpha = 1;		
					camHUD.visible = true;
					new FlxTimer().start(0.03, function(tmr:FlxTimer)
						{
							blackScreen.alpha -= 0.15;
							if (blackScreen.alpha > 0)
								{
									tmr.reset(0.03);
								}
								else
									{
										remove(blackScreen);
									}
						});
					dad = new Character(415, 391, 'monika-finale');
					boyfriend = new Boyfriend(970, 510, 'blantad-pixel');
					add(dad);
					add(boyfriend);	
					healthBar.createFilledBar(0xFFFFB8E3, 0xFF64B3FE);
					iconP2.animation.play('monika-finale');	
					iconP1.animation.play('blantad-pixel');	
				case 784:
					FlxG.save.data.downscroll = !FlxG.save.data.downscroll;

					if (!FlxG.save.data.downscroll)
					{
						downScrollEvent = false;
						strumLineNotes.forEach(function(note)
						{
							ModCharts.addTrailToSprite(note);
							ModCharts.moveStrumNotes(playerStrums, 650, 50, 0.1, 110, 0);
							ModCharts.moveStrumNotes(cpuStrums, -50, 50, 0.1, 110, 0);
						});
					}
					else
					{
						upScrollEvent = false;
						strumLineNotes.forEach(function(note)
						{		
							ModCharts.addTrailToSprite(note);
							ModCharts.moveStrumNotes(playerStrums, 650, FlxG.height - 165, 0.1, 110, 0);
							ModCharts.moveStrumNotes(cpuStrums, -50, FlxG.height - 165, 0.1, 110, 0);
						});	
					}
				case 785:
					for (note in 0...strumLineNotes.members.length) 
					{
						ModCharts.circleLoop(strumLineNotes.members[note], 50, 2);
					}			
			}
		}

			if (curSong == 'Treacherous-Dads') 
			{
				switch (curStep)
				{
					case 272 | 276 | 284 | 304 | 512 | 514 | 518 | 672 | 780 | 806 | 896 | 898 | 900 | 902 | 988 | 1035 | 1048 | 1052 | 1054 | 1080 | 1082 | 1084 | 1086 | 1152 | 1184:
						changeStaticNotes("pixel-corrupted");
						corruptBG('corrupt');
						changeDadCharacter(100, 175, 'bitdadcrazy');
						gf.alpha = 0;
					case 274 | 278 | 288 | 312 | 648 | 680 | 1040 | 1051 | 1053 | 1055 | 1081 | 1083 | 1085 | 1087 | 1160 | 1192:
						changeStaticNotes("pixel");
						corruptBG('normal');
						gf.alpha = 1;
						changeDadCharacter(100, 175, 'bitdadBSide');	
					case 368 | 752 | 760:
						dad.playAnim('switch', false);
						gf.playAnim('switch', false);
						iconP1.animation.play('bf-pixeld4');
						iconP2.animation.play('bitdad');
					case 370 | 373 | 380 | 628 | 636 | 754 | 758 | 762 | 1012 | 1020:
						iconP1.animation.play('bf-pixeld4BSide');
						iconP2.animation.play('bitdadBSide');
					case 371 | 374 | 378 | 382 | 626 | 630 | 634 | 638 | 756 | 764 | 1010 | 1014 | 1018 | 1022:
						iconP1.animation.play('bf-pixeld4');
						iconP2.animation.play('bitdad');
					case 376 | 624 | 632 | 1008 | 1016:
						dad.playAnim('switch', false);
						gf.playAnim('switch', false);
						iconP1.animation.play('bf-pixeld4BSide');
						iconP2.animation.play('bitdadBSide');
					case 383 | 768:
						changeStaticNotes("pixel");
						changeGFCharacter(580, 430, 'gf-pixeld4');
						changeDadCharacter(100, 175, 'bitdad');
						changeBoyfriendCharacter(970, 670, 'bf-pixeld4');
					case 513 | 516 | 520 | 784 | 812 | 897 | 899 | 901 | 903 | 992:
						changeStaticNotes("pixel");
						corruptBG('normal');
						gf.alpha = 1;
						changeDadCharacter(100, 175, 'bitdad');
					case 640:
						changeStaticNotes("pixel-corrupted");
						corruptBG('corrupt');
						changeGFCharacter(580, 430, 'gf-pixeld4BSide');
						gf.alpha = 0;
						changeDadCharacter(100, 175, 'bitdadcrazy');
						changeBoyfriendCharacter(970, 670, 'bf-pixeld4BSide');		
					case 1024:
						changeStaticNotes("pixel");
						changeGFCharacter(580, 430, 'gf-pixeld4BSide');
						changeDadCharacter(100, 175, 'bitdadBSide');				
						changeBoyfriendCharacter(970, 670, 'bf-pixeld4BSide');
				}
			}	

			if (curSong == 'Roses-Remix')
			{
				switch (curStep)
				{
					case 132 | 256 | 516 | 640 | 656:
						FlxG.sound.play(Paths.sound('glitch'));
					case 133 | 257 | 517 | 641 | 657:
						remove(glitchBG);	
					case 396 | 398 | 399:
						FlxG.sound.play(Paths.sound('glitch'));
						gf.alpha = 0;
						monikaBG.alpha = 1;
						monikaBG.animation.play('idle');
						iconP2.animation.play('green-monika');
					case 404 | 406:
						FlxG.sound.play(Paths.sound('glitch'));					
						gf.alpha = 0;
						dad.alpha = 0;
						monikaBG.animation.play('just-monika');
						monikaBG.alpha = 1;
						iconP2.animation.play('empty');
					case 412 | 413:
						FlxG.sound.play(Paths.sound('glitch'));
						gf.alpha = 0;
						monikaBG.animation.play('ghost');
						monikaBG.alpha = 1;
						iconP2.animation.play('green-monika');
					case 397 | 400 | 414:
						gf.alpha = 1;
						monikaBG.alpha = 0;
						iconP2.animation.play('monika-angry');
					case 405 | 407:
						gf.alpha = 1;
						dad.alpha = 1;
						monikaBG.alpha = 0;
						iconP2.animation.play('monika-angry');
					case 428 | 430 | 431:
						FlxG.sound.play(Paths.sound('glitch'));
						gf.alpha = 0;
						changeDadCharacter(250, 460, 'green-monika');
						monikaBG.alpha = 1;
						monikaBG.animation.play('idle');
					case 436 | 438:
						FlxG.sound.play(Paths.sound('glitch'));					
						gf.alpha = 0;
						gf.alpha = 1;
						monikaBG.animation.play('jumpscare');
						monikaBG.alpha = 1;
						iconP2.animation.play('monika-jumpscare');
					case 444 | 445:
						FlxG.sound.play(Paths.sound('glitch'));
						gf.alpha = 0;
						changeDadCharacter(250, 460, 'green-monika');
						monikaBG.animation.play('ghost');
						monikaBG.alpha = 1;
					case 429 | 432 | 446:
						gf.alpha = 1;
						changeDadCharacter(250, 460, 'monika-angry');
						monikaBG.alpha = 0;
					case 437 | 439:
						gf.alpha = 1;
						dad.alpha = 1;
						monikaBG.alpha = 0;
						iconP2.animation.play('monika-angry');
				}
			}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end

		if (spookyRendered && spookySteps + 3 < curStep)
		{
			if (resetSpookyText)
			{
				remove(spookyText);
				spookyRendered = false;
			}
			tstatic.alpha = 0;
			if (curStage == 'auditorHell')
				tstatic.alpha = 0.1;
		}

		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;
	var ruvShakeBeat:Int = 0;

	override function beatHit()
	{
		super.beatHit();

		if (SONG.song.toLowerCase() == 'hands' && curStep == 1088)
		{
			fastCarCanDrive = false;
		}

		if (curSong =='Crucify' && storyDifficulty == 3)
		{
			switch (curBeat)
			{
				case 47:
					health1 = true;
				case 50:
					health1 = false;
					health += 0.7;
			}
		}

		if(curSong == 'Sussus-Moogus') // sussus flashes
		{
			var sussusBeats = [94, 95, 288, 296, 304, 312, 318, 319];
			var _b = 0;

			flashSprite.alpha = 0;
			flashSprite.scrollFactor.set(0, 0);
			
			if(curBeat == 97 || curBeat == 192 || curBeat == 320)
				_cb = 1;
				if(curBeat > 98 && curBeat < 160 || curBeat > 192 && curBeat < 224 || curBeat > 320 && curBeat < 382 || curBeat == 98 || curBeat == 160 || curBeat == 192 || curBeat == 224 || curBeat == 320 || curBeat == 382)
				{
					_cb++;
					if(_cb == 2)
					{
						bgFlash();
						_cb = 0;
					}
				}
			while(_b < sussusBeats.length) {
			var susflash = sussusBeats[_b];
				++_b;
				if(curBeat == susflash)
				{
					bgFlash();
				}
			}
		}

		if (curSong.toLowerCase() == 'pom-pomeranian' && curStep >= 768 && curStep < 832)
		{
			FlxG.camera.zoom += 0.05;
		}

		if (curStage == 'day') {
			mini.animation.play('idle', true);
			if (stopWalkTimer == 0) {
				if (walkingRight)
					mordecai.flipX = false;
				else
					mordecai.flipX = true;
				if (walked)
					mordecai.animation.play('walk1');
				else
					mordecai.animation.play('walk2');
				if (walkingRight)
					mordecai.x += 10;
				else
					mordecai.x -= 10;
				walked = !walked;
				trace(mordecai.x);
				if (mordecai.x == 480 && walkingRight) { 
					stopWalkTimer = 10;
					walkingRight = false;
				} else if (mordecai.x == -80 && !walkingRight) { 
					stopWalkTimer = 8;
					walkingRight = true;
				}
			} else 
				stopWalkTimer--;
		}

		if (curSong == 'Roses-Remix')
		{
			switch (curBeat)
			{
				case 16:		
					bgGirls.getScared();
					changeDadCharacter(250, 670, 'bf-gf-pixel');
					iconP1.animation.play('bf-tankman-pixel-plain');
				case 24:
					changeBoyfriendCharacter(970, 670, 'bf-pixel');
				case 33:
					remove(bgSky);
					remove(bgSchool);
					remove(bgStreet);
					remove(fgTrees);
					remove(bgTrees);
					remove(treeLeaves);
					remove(bgGirls);
					add(bgSkyMario);
					add(bgSchoolMario);
					add(bgStreetMario);
					add(bgGirlsSFNAF);
					bgGirlsSFNAF.getScared();
					add(fgStreetMario);
					add(glitchBG);
					changeGFCharacter(580, 430, 'amy-pixel-mario');
					changeDadCharacter(250, 460, 'mario-angry');
				case 41:
					changeBoyfriendCharacter(970, 670, 'bf-sonic-pixel');	
				case 48:
					remove(fgStreetMario);
					remove(gf);
					remove(dad);
					remove(boyfriend);
					gf = new Character(580, 430, 'piper-pixel-mario');
					add(bgGirlsBSAA);
					bgGirlsBSAA.getScared();
					add(fgStreetMario);
					dad = new Character(250, 460, 'colt-angry');
					add(amyPixelBG);
					add(gf);
					add(dad);
					add(boyfriend);
					iconP2.animation.play('colt-angry');
				case 56:
					changeBoyfriendCharacter(970, 670, 'bf-rico-pixel');
				case 64:
					remove(bgSkyMario);
					remove(bgSchoolMario);
					remove(bgStreetMario);
					remove(fgStreetMario);
					remove(bgGirlsSFNAF);
					remove(bgGirlsBSAA);
					remove(amyPixelBG);
					add(bgSkyEdd);
					add(bgSchoolEdd);
					add(bgStreetEdd);
					add(bgTreesEdd);
					add(treeLeavesEdd);
					remove(gf);
					remove(dad);
					remove(boyfriend);
					gf = new Character(580, 430, 'gf-edd');
					dad = new Character(250, 460, 'matt-angry');
					bgGirlsEdd.getScared();
					add(bgGirlsEdd);
					add(glitchBG);
					add(gf);
					add(dad);
					add(boyfriend);
					iconP2.animation.play('matt-angry');
				case 72:
					changeBoyfriendCharacter(970, 670, 'bf-tom-pixel');
				case 80:
					changeDadCharacter(250, 460, 'monster-pixel');
				case 88:
					changeBoyfriendCharacter(870, 370, 'spooky-pixel');
				case 96:
					changeDadCharacter(250, 460, 'monika-angry');
				case 104:
					monikaBG.x = 30;
					monikaBG.y = 130;
					changeBoyfriendCharacter(970, 470, 'miku-pixel');
				case 112:
					FlxG.sound.play(Paths.sound('glitch'));
					remove(monikaBG);
					remove(bgGirlsEdd);
					add(monikaStillBG);
					add(bgGirlsBSAA);
					bgGirlsBSAA.getNormal();
					changeGFCharacter(580, 430, 'gf-edgeworth-pixel');
					changeDadCharacter(250, 460, 'kristoph-angry');
					changeBoyfriendCharacter(970, 670, 'bf-wright-pixel');		
				case 129:
					remove(monikaStillBG);
					remove(bgSkyEdd);
					remove(bgSchoolEdd);
					remove(bgStreetEdd);
					remove(bgTreesEdd);
					remove(treeLeavesEdd);
					add(bgSkyUT);
					add(bgSchoolUT);
					add(bgStreetUT);
					remove(bgGirlsBSAA);
					add(bgGirlsUTMJ);
					add(glitchBG);
					changeGFCharacter(580, 430, 'gf-flowey');
					changeDadCharacter(250, 460, 'chara-pixel');
				case 137:
					changeBoyfriendCharacter(970, 670, 'bf-sans-pixel');
				case 144:
					changeDadCharacter(240, 510, 'gura-amelia-pixel');
				case 152:
					changeBoyfriendCharacter(1010, 570, 'bf-botan-pixel');
				case 160:
					remove(bgSkyUT);
					remove(bgSchoolUT);
					remove(bgStreetUT);
					add(bgSkyBaldi);
					add(bgSchoolBaldi);
					add(bgStreetBaldi);
					remove(bgGirlsUTMJ);
					add(bgGirlsSFNAF);
					bgGirlsSFNAF.getNormal();				
					add(glitchBG);
					changeDadCharacter(250, 460, 'baldi-angry');
					changeGFCharacter(580, 430, 'gf-playtime');
					changeBoyfriendCharacter(1010, 570, 'bf-botan-pixel');
				case 162:
					changeBoyfriendCharacter(970, 460, 'mangle-angry');
				case 164:
					remove(bgSkyBaldi);
					remove(bgSchoolBaldi);
					remove(bgStreetBaldi);
					add(bgSkyNeon);
					add(bgStreetNeon);
					remove(bgGirlsSFNAF);
					add(bgGirlsSFNAF);
					add(bfPixelBG);			
					add(glitchBG);
					changeGFCharacter(580, 430, 'gf-pixel-neon');
					changeDadCharacter(250, 460, 'neon');
					changeBoyfriendCharacter(970, 460, 'mangle-angry');
				case 166:
					changeBoyfriendCharacter(970, 510, 'bf-whitty-pixel');		
				case 168:
					remove(bgGirlsSFNAF);
					remove(gf);	
					remove(dad);
					remove(boyfriend);
					remove(bfPixelBG);
					dad = new Character(250, 460, 'jackson');	
					boyfriend = new Boyfriend(970, 670, 'bf-pico-pixel');	
					add(bgGirlsSFNAF);	
					add(bgGirlsUTMJ);
					bgGirlsUTMJ.getScared();
					add(bfPixelBG);
					add(gf);	
					add(dad);
					add(boyfriend);
					iconP2.animation.play('jackson');	
					iconP1.animation.play('bf-pico-pixel');
			}
		}

		if (curSong == 'Takeover') 
		{
			switch (curBeat)
			{
				case 64:
					changeDadCharacter(0, 100, 'updike');	
					healthBar.createFilledBar(0xFFE1E1E1, 0xFFB7D855);	
					healthBar.updateBar();
				case 80:				
					changeBoyfriendCharacter(870, 100, 'whitty');
					healthBar.createFilledBar(0xFFE1E1E1, 0xFF1D1E35);
					healthBar.updateBar();	
				case 96:				
					changeDadCharacter(0, 100, 'rebecca');			
					healthBar.createFilledBar(0xFF19618C, 0xFF1D1E35);
					healthBar.updateBar();
				case 112:				
					changeBoyfriendCharacter(770, -25, 'bf-blantad');
					healthBar.createFilledBar(0xFF19618C, 0xFF64B3FE);
					healthBar.updateBar();
				case 148:					
					changeBoyfriendCharacter(970, 710, 'bf-senpai-pixel-angry');
					healthBar.createFilledBar(0xFFFFB8E3, 0xFFFFAA6F);
					healthBar.updateBar();
				case 164:
					monikaFinaleBG.alpha = 1;					
					changeDadCharacter(200, 700, 'lane-pixel');	
					healthBar.createFilledBar(0xFF1F7EFF, 0xFFFFAA6F);
					healthBar.updateBar();
				case 180:
					changeBoyfriendCharacter(970, 560, 'neon');
					healthBar.createFilledBar(0xFF1F7EFF, 0xFF06D22A);
					healthBar.updateBar();
				case 196:
					Bobismad();
					remove(space);
					remove(monikaFinaleBG);
					remove(stageFront2);
					remove(bg2);
					bg.alpha = 1;
					isPixel = false;
					add(gf);
					changeDadCharacter(100, 375, 'bob');
					changeBoyfriendCharacter(1085, 400, 'neon');			
					healthBar.createFilledBar(FlxColor.WHITE, 0xFF06D22A);
					healthBar.updateBar();
				case 212:
					
					changeBoyfriendCharacter(870, 200, 'opheebop');

					healthBar.createFilledBar(FlxColor.WHITE, FlxColor.BLACK);
					healthBar.updateBar();
					iconP1.animation.play('opheebop');
				case 228:					
					changeDadCharacter(100, 500, 'impostor');				
					healthBar.createFilledBar(0xFFFF3333, FlxColor.BLACK);
					healthBar.updateBar();
				case 244:
					changeBoyfriendCharacter(1070, 400, 'henry-angry');
					healthBar.createFilledBar(0xFFFF3333, 0xFFE1E1E1);
					healthBar.updateBar();
				case 260:			
					changeDadCharacter(100, 100, 'coco');
					healthBar.createFilledBar(0xFFE67A34, 0xFFE1E1E1);
					healthBar.updateBar();
				case 264:
					changeBoyfriendCharacter(870, 450, 'bf-aloe');
					healthBar.createFilledBar(0xFFE67A34, 0xFFEF71B1);
					healthBar.updateBar();
				case 268:				
					changeDadCharacter(50, 350, 'neko-crazy');
					healthBar.createFilledBar(0xFFFFD779, 0xFFEF71B1);
					healthBar.updateBar();
				case 272:
					changeBoyfriendCharacter(870, 450, 'bf-confused');
					healthBar.createFilledBar(0xFFFFD779, 0xFF51d8fb);
					healthBar.updateBar();
			}
		}

		if (curSong == 'Dead-Pixel') 
		{
			switch (curBeat)
			{
				case 156:
					dad.destroy();
					dad = new Character(250, 460, 'colt-angryd2corrupted');
					add(dad);
			}
		}

		if (curSong == 'Expurgation') 
		{
			switch (curBeat)
			{
				case 532:
					dad.playAnim('Hank', true);
				case 536:
					dad.playAnim('idle', true);
			}
		}

		if (curSong == 'Sharkventure') 
		{
			switch (curBeat)
			{
				case 39:
					dad.playAnim('singLEFTmiss', true);
					if (health < 2)
						health += 0.02;
				case 55:
					dad.playAnim('singRIGHTmiss', true);
					if (health < 2)
						health += 0.02;
			}
		}

		if (curSong == 'Norway') 
		{
			switch (curBeat)
			{
				case 64:
					gfBG.gone();
				case 96:
					gfBG.goBack();
			}
		}

		if (curSong == 'Cosmic') 
		{
			switch (curBeat)
			{
				case 24:
					addIconBG(SONG.player2, 200, 200, 0, true);
					changeDadCharacter(100, 450, 'bf-carol');
				case 32:
					addIconBG(SONG.player1, 300, 0, 10, true);
					changeBoyfriendCharacter(820, 100, 'whitty');
				case 48:
					addIconBG('bf-carol', 310, 150, -5, true);
					changeDadCharacter(100, 100, 'hex');
				case 56:
					addIconBG('whitty', 70, 260, -10, true);
					changeGFCharacter(400, 130, 'nogf');
					changeBoyfriendCharacter(790, 450, 'bf-gf');
				case 64:	
					addIconBG('hex', 120, 70, 5, true);
					changeDadCharacter(100, 450, 'bf-lexi');			
				case 88:
					changeGFCharacter(400, 130, 'madgf');
					addIconBG('empty', 0, 0, 0, true);
					changeBoyfriendCharacter(830, 350, 'bf-sky');
				case 104:
					changeGFCharacter(400, 130, 'gf-tabi');
					addIconBG('bf-lexi', 150, -75, 0, true);									
					changeDadCharacter(100, 0, 'bf-blantad');	
				case 120:
					changeGFCharacter(400, 130, 'gf');								
					addIconBG('bf-sky', 200, 120, -2, true);	
					changeBoyfriendCharacter(770, -10, 'henry');
				case 136:
					addIconBG('bf-blantad', 0, 160, 4);
					addIconBG('henry', 220, -60, 2);
					changeDadCharacter(100, 100, 'shaggy');
					changeBoyfriendCharacter(800, 450, 'matt');
				case 152:
					addIconBG('matt', 300, 75, -2);
					addIconBG('shaggy', 330, 260, -4); 
					changeDadCharacter(100, 100, 'hd-senpai');
					changeBoyfriendCharacter(770, 300, 'tankman');
				case 168:
					addIconBG('tankman', 0, -100, 2);
					addIconBG('hd-senpai', 0, 300, 1, true); 
					changeDadCharacter(0, 425, 'bf-annie');			
				case 178:
					addIconBG('bf-annie', 330, 360, 5, true); 
					changeDadCharacter(0, 375, 'botan');
				case 184:
					addIconBG('tankman', 120, 320, 4, true); 
					changeBoyfriendCharacter(600, 100, 'garcello'); 				
				case 194:
					addIconBG('garcello', 220, 25, -4, true); 
					changeBoyfriendCharacter(800, 450, 'bf-aloe'); 
				case 200:
					addIconBG('botan', 330, -75, 6, true); 
					changeDadCharacter(50, 100, 'miku');
				case 216:
					addIconBG('bf-aloe', 0, 230, 2, true); 
					changeBoyfriendCharacter(800, 150, 'hd-monika'); 
				case 232:
					addIconBG('miku', 400, 0, -6, true); 
					changeDadCharacter(50, 100, 'sarvente');
				case 248:
					addIconBG('hd-monika', 60, 330, 2, true); 
					changeBoyfriendCharacter(850, 100, 'ruv'); 
				case 264:
					addIconBG('sarvente', 100, 0, 2); 
					addIconBG('ruv', 370, 100, 1); 
					changeDadCharacter(0, 100, 'exgf');
					changeBoyfriendCharacter(800, 100, 'tabi'); 
				case 280:
					addIconBG('exgf', 420, -75, 2);
					addIconBG('tabi', 80, -75, 1); 
					addIconBG('gf', 255, 150, 3);  
					changeGFCharacter(400, 130, 'gf-kaity');
					changeDadCharacter(0, 120, 'bf-mom');
					changeBoyfriendCharacter(800, 100, 'bf-dad'); 
			}
		}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
			{
				switch (dad.curCharacter)
				{
					case 'sky-annoyed':
						if (!dad.animation.curAnim.name.contains('special'))
						{
							dad.dance();
						}
					default:
						dad.dance();
				}
			}
				
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (FlxG.save.data.camzoom)
		{
			// HARDCODING FOR MILF ZOOMS!
			if (curSong.toLowerCase().startsWith('milf') && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
	
			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
			{
				switch (curSong.toLowerCase())
				{
					case 'expurgation':
						FlxG.camera.zoom += 0.03;
						camHUD.zoom += 0.06;
					case 'crucify' | 'ballistic':
						// do nothing lol
					default:
						FlxG.camera.zoom += 0.015;
						camHUD.zoom += 0.03;
				}
			}

			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 2 == 0 && curSong.toLowerCase() == 'ballistic')
			{
				FlxG.camera.zoom += 0.020;
				camHUD.zoom += 0.035;
			}
	
			iconP1.setGraphicSize(Std.int(iconP1.width + 30));
			iconP2.setGraphicSize(Std.int(iconP2.width + 30));
			
			iconP1.updateHitbox();
			iconP2.updateHitbox();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			switch (curSong)
			{
				case 'Storm':
					if (!boyfriend.animation.curAnim.name.contains('wink'))
					{
						boyfriend.dance();
					}
				case 'Context':
					if (!boyfriend.animation.curAnim.name.contains('special'))
					{
						boyfriend.dance();
					}	
				case 'Ballistic':
					if (!boyfriend.animation.curAnim.name.contains('transition') && !picoCutscene)
					{
						boyfriend.dance();
					}	
				case 'Pom-Pomeranian':
					if (!boyfriend.animation.curAnim.name.contains('3'))
					{
						boyfriend.dance();
					}		
				case 'Hands':
					if (!boyfriend.animation.curAnim.name.contains('special'))
					{
						boyfriend.dance();
					}			
				default:
					boyfriend.dance();	
			}	
		}

		if (!dad.animation.curAnim.name.startsWith("sing") && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
		{
			switch (dad.curCharacter)
			{
				case 'senpaighosty':
					if (!dad.animation.curAnim.name.contains('disappear'))
					{
						dad.dance();
					}
				case 'cjClone':
					if (!dad.animation.curAnim.name.contains('Hank'))
					{
						dad.dance();
					}
				case 'gura-amelia':
					if (!dad.animation.curAnim.name.contains('ah') && !dad.animation.curAnim.name.contains('chu'))
					{
						dad.dance();
					}
				case 'sky-annoyed':
					if (!dad.animation.curAnim.name.contains('special'))
					{
						dad.dance();
					}
				case 'picoCrazy':
					if (!dad.animation.curAnim.name.contains('-alt'))
					{
						dad.dance();
					}
				case 'tankman':
					if (!dad.animation.curAnim.name.contains('lilDude'))
					{
						dad.dance();
					}
				case 'cj-ruby':
					if (!dad.animation.curAnim.name.contains('2'))
					{
						dad.dance();
					}
				case 'bb-tired' | 'bb':
					if (curBeat % 4 == 0)
					{
						dad.dance();
					}
				default:
					dad.dance();
			}		
		}

		if (SONG.song.toLowerCase() == 'fading-senpai')
		{
			if (curStep == 240)
			{
				new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					dad.alpha -= 0.05;
					iconP2.alpha -= 0.05;

					if (dad.alpha > 0)
					{
						tmr.reset(0.1);
					}
				});
			}
		}

		if (curBeat % gfSpeed == 0)
		{
			if (!picoCutscene)
			{
				gf.dance();
			}

			if (FlxG.save.data.flashing)
			{
				if (curStage == "manifest")
				{
					manifestBG.animation.play("idle");
					manifestFloor.animation.play("idle");
				}

				if(curStage == "skybroke")
				{
					manifestBG.animation.play('idle');
					manifestHole.animation.play('idle');
				}
			}			
		}

		if (boyfriend.curCharacter == 'bf-tankman-pixel' && dad.curCharacter != 'senpai-giddy' && !boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle-alt', false);
		}

		var coolTankmen:Array<String> = ['tankman', 'tankman-bw'];

		if (coolTankmen.contains(boyfriend.curCharacter) && curSong != 'Fading-Senpai')
		{
			var bwShit:String = "";

			switch (boyfriend.curCharacter)
			{
				case 'tankman':
					bwShit = "";
				case 'tankman-bw':
					bwShit = '-bw';
			}

			if (dad.curCharacter.contains('senpai') && !dad.curCharacter.contains('angry') && !dad.curCharacter.contains('ghosty'))
				iconP1.animation.play('tankman-happy' + bwShit);
			else
				iconP1.animation.play('tankman' + bwShit);		
		}

		if (dad.curCharacter.contains('hd-senpai'))
		{
			var bwShit:String = "";

			if (dad.curCharacter == 'hd-senpai-bw')
			{
				bwShit = '-bw';
			}

			if (boyfriend.curCharacter.contains('tankman') || boyfriend.curCharacter.contains('monika') || boyfriend.curCharacter.contains('aloe') || boyfriend.curCharacter.contains('ruv'))
			{
				iconP2.animation.play('hd-senpai-happy' + bwShit);
			}
			else
				iconP2.animation.play('hd-senpai' + bwShit);
			
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial-Remix' && curBeat > 16 && curBeat < 64)
			{
				dad.playAnim('cheer', true);
			}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'school-monika':
				if (curSong.toLowerCase() == 'shinkyoku')
					bgGirls2.dance();

			case 'school-switch':
				bgGirls.dance();
				bgGirlsUTMJ.dance();
				bgGirlsSFNAF.dance();
				bgGirlsBSAA.dance();
				bgGirlsEdd.dance();
				bfPixelBG.animation.play('idle');
				amyPixelBG.dance();

			case 'gamer':
				zero16.animation.play('idle', true);

			case 'eddhouse':
				switch (curSong)
				{
					case 'Norway':
						tomBG.animation.play('idle');
						bfBG.animation.play('idle');
						mattBG.animation.play('idle');
						tordBG.animation.play('idle');
						gfBG.dance();
					default:
						'';
				}

			case 'mackiestage':
				if (curSong.toLowerCase() == 'gateau')
				{
					smallbgcrowd.animation.play('smallbob', true);
				}
				
				if (curSong.toLowerCase() == 'pom-pomeranian')
				{
					bgcrowd.animation.play('bob', true);
					bgcrowdjump.animation.play('jump', true);
					alya.animation.play('alyabob', true);
					anchor.animation.play('anchorbob', true);
					tricky.animation.play('trickybob', true);
				}

			case "studio":
				cy_spk1.animation.play('bump', true);
				cy_spk2.animation.play('bump', true);
			
			case 'manifest':
				gfCrazyBG.animation.play('idle');

			case 'emptystage':
				monikaFinaleBG.animation.play('idle');

			case 'philly-wire':
				gfBG.dance();
				gfBG2.dance();
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;

					phillyCityLightswire.forEach(function(lightwire:FlxSprite)
					{
						lightwire.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLightswire.length - 1);

					phillyCityLightswire.members[curLight].visible = true;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8 && !dad.curCharacter.contains('wire'))
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}

			case 'tank':
				if (curBeat % 2 == 0)
				{	
					tankWatchtower.animation.play('idle', true);
					tank0.animation.play('idle', true);
					tank1.animation.play('idle', true);
					tank2.animation.play('idle', true);
					tank4.animation.play('idle', true);
					tank5.animation.play('idle', true);
					tank3.animation.play('idle', true);
				}

			case 'acrimony':
				modCrowdBig.animation.play('bop', true);

			case 'throne':
				bottomBoppers.animation.play('bop', true);
				bgcrowd.animation.play('bop', true);
			
			case 'mall' | 'mallSoft':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

				if (SONG.song.toLowerCase() == 'ugh-remix')
				{
					gfBG.dance();
					blantadBG2.animation.play('bop');
					momDadBG.animation.play('idle');
					softBFBG.animation.play('idle');
				}

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case 'limoholo':
				grpLimoDancersHolo.forEach(function(dancer:BackgroundDancerHolo)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case 'limoholo-night':
				var danced:Bool = false;
				gfBG.dance();
				grpLimoDancersHolo.forEach(function(dancer:BackgroundDancerHolo)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
				{
					if (curSong == 'Hands' && curStep >= 1088)
						'';	//do nothing
					else
						fastCarDrive();
				}					

				blantadBG.playAnim('idle');					

			case "philly"  | "phillyannie":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}

			case "room":
				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}
			case "prologue" | 'always-here':
                if (curBeat % 4 == 0)
                {
                    prologueLights.forEach(function(light:FlxSprite)
                    {
                        light.visible = false;
                    });

                    curLight = FlxG.random.int(0, prologueLights.length - 1);

                    prologueLights.members[curLight].visible = true;
                    // phillyCityLights.members[curLight].alpha = 1;
                }           
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
				lightningStrikeShit();
		}

		if ((dad.curCharacter.contains('ruv') && !dad.curCharacter.contains('smol') && !dad.curCharacter.contains('sarv') && dad.animation.curAnim.name.startsWith('sing') || boyfriend.curCharacter.contains('ruv') && !boyfriend.curCharacter.contains('smol') && !boyfriend.curCharacter.contains('sarv') && boyfriend.animation.curAnim.name.startsWith('sing')) && curBeat > ruvShakeBeat)
		{
			ruvShake();
		}

		if ((dad.curCharacter == 'sarv-ruv' && dad.animation.curAnim.name.startsWith('sing') && !dad.animation.curAnim.name.endsWith('-alt') || boyfriend.curCharacter == 'sarv-ruv' && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('-alt')) && curBeat > ruvShakeBeat) 
		{
			ruvShake();
		}
	}

	var curLight:Int = 0;
}
