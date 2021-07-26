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

using StringTools;

class PlayState extends MusicBeatState
{
	//Unused (I think) cus I have no idea how this works
	var characterCol:Array<String> = CoolUtil.coolTextFile(Paths.txt('data/healthBarColors'));
	var col:Array<FlxColor> = [
		FlxColor.BLACK, // demon hot milf cass
		0xFFB7D855, // go pico
		0xFFE1E1E1, // updike
		0xFF1D1E35, // bf-whitty
		0xFF19618C, // rebecca
		0xFF64B3FE, // bf-blantad (that's me!)
		0xFF64B3FE, // blantad-pixel (that's me but pixel!)
		0xFFFFB8E3, // monika-finale
		0xFFFFAA6F, // bf-senpai-pixel-angry (a lot of hyphens)
		0xFF1F7EFF, // lane-pixel
		0xFF06D22A, // neon
		0xFFFFFFFF, // bob
		FlxColor.BLACK, // opheebop
		0xFFFF3333, // sus
		0xFFE1E1E1, // Angered Stickmin
		0xFFE67A34, // Kiryu Coco
		0xFFEF71B1, // Mano Aloe
		0xFFFFD779, // Nekofreak
		0xFF51d8fb // BF
	];

	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var isBETADCIU:Bool = false;
	public static var isHidden:Bool = false;
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

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	public var minusHealth:Bool = false;
	public var tabiZoom:Bool = false;

	public var cjCloneLinesSing:Array<String> = ["SUFFER","INCORRECT", "INCOMPLETE", "INSUFFICIENT", "INVALID", "CORRECTION", "MISTAKE", "REDUCE", "ERROR", "ADJUSTING", "IMPROBABLE", "IMPLAUSIBLE", "MISJUDGED"];

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;

	//tankman shit
	var tankRolling:FlxSprite;
	var tankX:Int = 400;
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankAngle:Float = FlxG.random.float(-90, 45);
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public static var isSM:Bool = false;
	#if sys
	public static var sm:SMFile;
	public static var pathToSm:String;
	#end

	public static var startTime = 0.0;

	public var originalX:Float;

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	var tstatic:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('tricky/TrickyStatic', 'shared'), true, 320, 180);

	var tStaticSound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("staticSound","preload"));

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

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
	var curcol:FlxColor;
	var curcol2:FlxColor;
	var dadHealthBarColor:FlxColor;
	var bfHealthBarColor:FlxColor;
	var stageFront2:FlxSprite;
	var bg2:FlxSprite;
	var bg:FlxSprite;
	var babyArrow:FlxSprite;
	var babyArrow2:FlxSprite;
	var daSign:FlxSprite;
	var headlight:FlxSprite;
	var fac_bg:FlxSprite;
	var manifestHole:FlxSprite;

	public var dust:FlxSprite;
	public var car:FlxSprite;

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
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var grpLimoDancersHolo:FlxTypedGroup<BackgroundDancerHolo>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
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
	var bgGirlsUTMJ:BackgroundGirlsUTMJ;
	var bgGirlsSFNAF:BackgroundGirlsSFNAF;
	var bgGirlsBSAA:BackgroundGirlsBSAA;
	var bgGirlsEdd:BackgroundGirlsEdd;
	var gfBG:GirlfriendBG;
	var amyPixelBG:AmyPixelBG;
	var tankWatchtower:TankWatchtower;
	var wiggleShit:WiggleEffect = new WiggleEffect();
	var melandperi:MelandPeri;
	var melandperiwire:MelandPeriWire;

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

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

		var cover:FlxSprite = new FlxSprite(-180,755).loadGraphic(Paths.image('tricky/fourth/cover'));
		var hole:FlxSprite = new FlxSprite(50,530).loadGraphic(Paths.image('tricky/fourth/Spawnhole_Ground_BACK'));
		var converHole:FlxSprite = new FlxSprite(7,578).loadGraphic(Paths.image('tricky/fourth/Spawnhole_Ground_COVER'));

		isTakeover = (SONG.song.toLowerCase() == 'takeover');

		instance = this;
		
		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		//Code to send people back to lol menu if trying to access hidden songs through debug
		if ((SONG.song == 'Norway' || SONG.song == 'Haachama' || SONG.song == 'High-School-Conflict' || SONG.song == 'Hunger') && !isHidden)
		{
			FlxG.switchState(new GoFindTheSecretState());
		}

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

		cjCloneLinesSing = CoolUtil.coolTextFile(Paths.txt('data/cjCloneSingStrings'));

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
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/thorns/thornsDialogue'));
			case 'whittyvssarv':
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/whittyvssarv/whittyvssarvDialogue'));
			case 'gun-buddies':
				dialogue = CoolUtil.coolTextFile(Paths.txt('fata/gun-buddies/gun-buddiesDialogue'));
			case 'battle':
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/battle/battleDialogue'));
				
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
				curStage = "spooky";
				halloweenLevel = true;

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

				var hallowTex = Paths.getSparrowAtlas('manor_bg');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

				isHalloween = true;
			}

			case 'hungryhippo':
			{
				curStage = 'hungryhippo';
				defaultCamZoom = 0.6;
				var bg:FlxSprite = new FlxSprite(-800, -600).loadGraphic(Paths.image('rebecca/hungryhippo_bg'));
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

				manifestHole = new FlxSprite (150, -70);
				manifestHole.frames = Paths.getSparrowAtlas('sky/manifesthole');
				manifestHole.animation.addByPrefix('idle', 'manifest hole', 24, false);
				manifestHole.animation.addByIndices('noflash', "manifest hole", [5], "", 24, false);
				manifestHole.scrollFactor.set(0.8, 1);
				manifestHole.setGraphicSize(Std.int(manifestHole.width * 0.9));
				manifestHole.updateHitbox();
				manifestHole.animation.play('noflash');
				manifestHole.antialiasing = true;
				add(manifestHole);
					
			}

			case 'philly':
			{
				curStage = 'philly';

				bg = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

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

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain', 'week3'));
				add(streetBehind);

				phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train', 'week3'));
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes', 'week3'));
				FlxG.sound.list.add(trainSound);

				// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street', 'week3'));
				add(street);
			}

			case 'philly-wire':
			{
				curStage = 'philly-wire';

				bg = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				bgwire = new FlxSprite(-100).loadGraphic(Paths.image('wire/sky'));
				bgwire.scrollFactor.set(0.1, 0.1);
				add(bgwire);

				var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				citywire = new FlxSprite(-10).loadGraphic(Paths.image('wire/city'));
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
					lightwire = new FlxSprite(city.x).loadGraphic(Paths.image('wire/win' + i));
					lightwire.scrollFactor.set(0.3, 0.3);
					lightwire.visible = false;
					lightwire.setGraphicSize(Std.int(lightwire.width * 0.85));
					lightwire.updateHitbox();
					lightwire.antialiasing = true;
					phillyCityLightswire.add(lightwire);
				}

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain', 'week3'));
				add(streetBehind);

				streetBehindwire = new FlxSprite(-40, 50).loadGraphic(Paths.image('wire/behindTrain'));
				add(streetBehindwire);

				phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train', 'week3'));
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes', 'week3'));
				FlxG.sound.list.add(trainSound);

				// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street', 'week3'));
				add(street);

				streetwire = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('wire/street'));
				add(streetwire);

				melandperi = new MelandPeri(300, 210);
				melandperi.scrollFactor.set(0.95, 0.95);
				melandperi.setGraphicSize(Std.int(melandperi.width * 0.8));
				melandperi.updateHitbox();

				melandperiwire = new MelandPeriWire(300, 210);
				melandperiwire.scrollFactor.set(0.95, 0.95);
				melandperiwire.setGraphicSize(Std.int(melandperiwire.width * 0.8));
				melandperiwire.updateHitbox();
			}

			case 'phillyannie':
			{
				curStage = 'phillyannie';

				bg = new FlxSprite(-100).loadGraphic(Paths.image('annie/sky'));
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('annie/city'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				add(phillyCityLights);

				for (i in 0...5)
				{
					var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('annie/win' + i));
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
				}

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('annie/behindTrain'));
				add(streetBehind);

				phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('annie/train'));
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('annie/street'));
				add(street);
			}

			case 'limo':
			{
				curStage = 'limo';
				defaultCamZoom = 0.90;

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

				var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay', 'week4'));
				overlayShit.alpha = 0.5;
				// add(overlayShit);

				// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

				// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

				// overlayShit.shader = shaderBullshit;

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
				defaultCamZoom = 0.90;

				var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limoholo/limoSunset'));
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);

				var bgLimo:FlxSprite = new FlxSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('limoholo/bgLimo');
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

				var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limoholo/limoOverlay'));
				overlayShit.alpha = 0.5;
				// add(overlayShit);

				// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

				// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

				// overlayShit.shader = shaderBullshit;

				var limoTex = Paths.getSparrowAtlas('limoholo/limoDrive');

				limo = new FlxSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;

				fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limoholo/fastCarLol'));
				// add(limo);
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
				upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop', 'week5');
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
				santa.frames = Paths.getSparrowAtlas('christmas/santa');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = true;
				add(santa);
			}
			case 'mallEvil':
			{
				curStage = 'mallEvil';
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
				bg = new FlxSprite(-400, -500).loadGraphic(Paths.image('annie/evilBG'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);
	
				var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('annie/evilTree'));
				evilTree.antialiasing = true;
				evilTree.scrollFactor.set(0.2, 0.2);
				add(evilTree);
	
				var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("annie/evilSnow"));
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

				gfBG = new GirlfriendBG(750, 20);
				gfBG.antialiasing = true;
				gfBG.scrollFactor.set(0.9, 0.9);
				gfBG.setGraphicSize(Std.int(gfBG.width * 0.8));
				gfBG.updateHitbox();
				
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				sky.scrollFactor.set(0.5, 0);
				if(SONG.song.toLowerCase() == 'tordbot')sky.scrollFactor.set();
				bg.active = false;
				sky.active = false;
				//bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				sky.updateHitbox();
				add(sky);
				add(bg);
				add(tordBG);
				add(bfBG);	
				add(gfBG);
				add(mattBG);
				
			}

			case 'school':
			{
				curStage = 'school';

				// defaultCamZoom = 0.9;

				var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);

				var repositionShit = -200;

				var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);

				var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);

				var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('weeb/weebTrees');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);

				var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
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

				// defaultCamZoom = 0.9;

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
			}

			case 'school-switch':
			{
				curStage = 'school-switch';

				// defaultCamZoom = 0.9;

				bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
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

				bgSchool = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
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

				bgStreet = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
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

				fgTrees = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBacknoon'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);

				bgTrees = new FlxSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('weeb/weebTrees');
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
				treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
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

				bgGirlsUTMJ = new BackgroundGirlsUTMJ(-100, 190);
				bgGirlsUTMJ.scrollFactor.set(0.9, 0.9);
				bgGirlsUTMJ.setGraphicSize(Std.int(bgGirlsUTMJ.width * daPixelZoom));
				bgGirlsUTMJ.updateHitbox();

				bgGirlsEdd = new BackgroundGirlsEdd(-100, 190);
				bgGirlsEdd.scrollFactor.set(0.9, 0.9);
				bgGirlsEdd.setGraphicSize(Std.int(bgGirlsEdd.width * daPixelZoom));
				bgGirlsEdd.updateHitbox();

				bgGirlsBSAA = new BackgroundGirlsBSAA(-100, 190);
				bgGirlsBSAA.scrollFactor.set(0.9, 0.9);
				bgGirlsBSAA.setGraphicSize(Std.int(bgGirlsBSAA.width * daPixelZoom));
				bgGirlsBSAA.updateHitbox();

				bgGirlsSFNAF = new BackgroundGirlsSFNAF(-100, 190);
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

				amyPixelBG = new AmyPixelBG(500, 150);
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
				
				tankWatchtower = new TankWatchtower(100, 50);
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

			case 'stageruv':
			{
				defaultCamZoom = 0.8;
				curStage = 'stageruv';
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
				defaultCamZoom = 0.8;
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

				if (SONG.song.contains('Worship'))
				{
					pillars.color = 0xFFD6ABBF;
					floor.color = 0xFFD6ABBF;
					bg.color = 0xFFD6ABBF;
				}
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

				// defaultCamZoom = 0.9;

				bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSkynoon'));
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);

				bgSkyEvil = new FlxSprite().loadGraphic(Paths.image('weeb/weebSkyEvil'));
				bgSkyEvil.scrollFactor.set(0.1, 0.1);
				bgSkyEvil.alpha = 0;
				add(bgSkyEvil);

				var repositionShit = -200;

				bgSchool = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchoolnoon'));
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);

				bgSchoolEvil = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchoolEvil'));
				bgSchoolEvil.scrollFactor.set(0.6, 0.90);
				bgSchoolEvil.alpha = 0;
				add(bgSchoolEvil);


				bgStreet = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreetnoon'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);

				bgStreetEvil = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreetEvil'));
				bgStreetEvil.scrollFactor.set(0.95, 0.95);
				bgStreetEvil.alpha = 0;
				add(bgStreetEvil);

				fgTrees = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBacknoon'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);

				fgTreesEvil = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBackEvil'));
				fgTreesEvil.scrollFactor.set(0.9, 0.9);
				fgTreesEvil.alpha = 0;
				add (fgTreesEvil);

				bgTrees = new FlxSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('weeb/weebTreesnoon');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);

				var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('weeb/petalsnoon');
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

			case 'stage':
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

			case 'FNAFstage':
			{
				defaultCamZoom = 0.9;
				curStage = 'FNAFstage';
				bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('FNAF/stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('FNAF/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('FNAF/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				add(stageCurtains);
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

			case 'mind':
            {
        		defaultCamZoom = 0.8;
				curStage = 'mind';

                bg = new FlxSprite(0, 0);
				bg.frames = Paths.getSparrowAtlas("tormentor/mind");
				bg.animation.addByPrefix("idle", "Tormentor Bf Stage", 24, true);
				bg.animation.play("idle");
				bg.antialiasing = true;
				bg.setGraphicSize(Std.int(bg.width * 1.6));
				add(bg);
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

			case 'm-stage':
			{
				defaultCamZoom = 0.8;
				curStage = 'm-stage';
				bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('whitestageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);
			}

			case 'sabotage':
			{
				defaultCamZoom = 0.9;
				curStage = 'sabotage';
				bg = new FlxSprite(-200, -300).loadGraphic(Paths.image('polus/polusSky'));
				bg.setGraphicSize(Std.int(bg.width * 1.5));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.5, 0.5);
				bg.active = false;
				add(bg);


				var rocks:FlxSprite = new FlxSprite(-800, -300).loadGraphic(Paths.image('polus/polusrocks'));
				rocks.setGraphicSize(Std.int(rocks.width * 1.5));
				rocks.updateHitbox();
				rocks.antialiasing = true;
				rocks.scrollFactor.set(0.6, 0.6);
				rocks.active = false;
				add(rocks);

				
				var rocks:FlxSprite = new FlxSprite(-450, -200).loadGraphic(Paths.image('polus/polusWarehouse'));
				rocks.setGraphicSize(Std.int(rocks.width * 1.5));
				rocks.updateHitbox();
				rocks.antialiasing = true;
				rocks.scrollFactor.set(0.9, 0.9);
				rocks.active = false;
				add(rocks);
					
				var rocks:FlxSprite = new FlxSprite(-1000, 0).loadGraphic(Paths.image('polus/polusHills'));
				rocks.setGraphicSize(Std.int(rocks.width * 1.5));
				rocks.updateHitbox();
				rocks.antialiasing = true;
				rocks.scrollFactor.set(0.9, 0.9);
				rocks.active = false;
				add(rocks);

				var stageFront:FlxSprite = new FlxSprite(-400, 450).loadGraphic(Paths.image('polus/polusGround'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.5));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(1, 1);
				stageFront.active = false;
				add(stageFront);


				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
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
			case 'amy-pixel-mario':
				gfVersion = 'amy-pixel-mario';
			case 'crazygf-crucified':
				gfVersion = 'crazygf-crucified';
			case 'cj-tied':
				gfVersion = 'cj-tied';
			case 'dalia-car':
				gfVersion = 'dalia-car';
			case 'emptygf':
				gfVersion = 'emptygf';
			case 'gf':
				gfVersion = 'gf';
			case 'gfandbf':
				gfVersion = 'gfandbf';
			case 'gfandbf-fear':
				gfVersion = 'gfandbf-fear';
			case 'gf-bw':
				gfVersion = 'gf-bw';
			case 'gf-car':
				gfVersion = 'gf-car';
			case 'gf-christmas':
				gfVersion = 'gf-christmas';
			case 'gf-crucified':
				gfVersion = 'gf-crucified';
			case 'gf-demon':
				gfVersion = 'gf-demon';
			case 'gf-edd':
				gfVersion = 'gf-edd';
			case 'gf-edgeworth-pixel':
				gfVersion = 'gf-edgeworth-pixel';
			case 'gf-flowey':
				gfVersion = 'gf-flowey';
			case 'gf-hex':
				gfVersion = 'gf-hex';	
			case 'gf-kaity':
				gfVersion = 'gf-kaity';
			case 'gf-kinky':
				gfVersion = 'gf-kinky';
			case 'gf-m':
				gfVersion = 'gf-m';
			case 'gf-nene':
				gfVersion = 'gf-nene';	
			case 'gf-nene-cry':
				gfVersion = 'gf-nene-cry';	
			case 'gf-nene-bw':
				gfVersion = 'gf-nene-bw';	
			case 'gf-peri-whitty':
				gfVersion = 'gf-peri-whitty';
			case 'gf-pico':
				gfVersion = 'gf-pico';
			case 'gf-pixel':
				gfVersion = 'gf-pixel';
			case 'gf-pixeld4':
				gfVersion = 'gf-pixeld4';
			case 'gf-pixeld4BSide':
				gfVersion = 'gf-pixeld4BSide';
			case 'gf-pixel-mario':
				gfVersion = 'gf-pixel-mario';
			case 'gf-pixel-neon':
				gfVersion = 'gf-pixel-neon';
			case 'gf-playtime':
				gfVersion = 'gf-playtime';
			case 'gf-ruv':
				gfVersion = 'gf-ruv';
			case 'gf-ruv-glitcher':
				gfVersion = 'gf-ruv-glitcher';
			case 'gf-selever':
				gfVersion = 'gf-selever';
			case 'gf-tabi':
				gfVersion = 'gf-tabi';
			case 'gf-tankman':
				gfVersion = 'gf-tankman';
			case 'gf-tankman-pixel':
				gfVersion = 'gf-tankman-pixel';
			case 'gf-sarv':
				gfVersion = 'gf-sarv';
			case 'holo-cart':
				gfVersion = 'holo-cart';
			case 'nogf':
				gfVersion = 'nogf';
			case 'nogf-christmas':
				gfVersion = 'nogf-christmas';
			case 'nogf-crucified':
				gfVersion = 'nogf-crucified';
			case 'nogf-glitcher':
				gfVersion = 'nogf-glitcher';
			case 'nogf-night':
				gfVersion = 'nogf-night';
			case 'nogf-pixel':
				gfVersion = 'nogf-pixel';
			case 'nogf-rebecca':
				gfVersion = 'nogf-rebecca';
			case 'nogf-wire':
				gfVersion = 'nogf-wire';
			case 'madgf':
				gfVersion = 'madgf';
			case 'piper-pixel-mario':
				gfVersion = 'piper-pixel-mario';
			case 'piper-pixeld2':
				gfVersion = 'piper-pixeld2';
			case 'gf1':
				gfVersion = 'gf1';
			case 'gf2':
				gfVersion = 'gf2';
			case 'gf3':
				gfVersion = 'gf3';
			case 'gf4':
				gfVersion = 'gf4';
			case 'gf5':
				gfVersion = 'gf5';
			default:
				gfVersion = SONG.gfVersion;
		}

		if (SONG.song.toLowerCase() == 'takeover')	
		{
			dad = new Character(100, 100, 'updike');
			boyfriend = new Boyfriend(770, 450, 'bf-whitty');
			dad = new Character(100, 200, 'rebecca');
			boyfriend = new Boyfriend(770, 450, 'bf-blantad');
			boyfriend = new Boyfriend(770, 450, 'blantad-pixel');
			dad = new Character(100, 100, 'monika-finale');
			boyfriend = new Boyfriend(770, 450, 'bf-senpai-pixel-angry');
			dad = new Character(100, 25, 'lane-pixel');
			boyfriend = new Boyfriend(770, 450, 'neon');
			dad = new Character(100, 100, 'bob');
			boyfriend = new Boyfriend(770, 450, 'opheebop');
			dad = new Character(100, 100, 'impostor');
			boyfriend = new Boyfriend(770, 450, 'henry-angry');
			dad = new Character(100, 100, 'coco');
			boyfriend = new Boyfriend(770, 450, 'bf-aloe');
			dad = new Character(100, 100, 'neko-crazy');
			boyfriend = new Boyfriend(770, 450, 'bf-confused');
			dad = new Character(dad.x, dad.y, SONG.player2);
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, SONG.player1);
		}	

		if (SONG.song.toLowerCase() == 'remorse')	
		{
			dad = new Character(100, 100, 'agoti');
			boyfriend = new Boyfriend(770, 450, 'tabi');
			dad = new Character(100, 200, 'nene');
			boyfriend = new Boyfriend(770, 450, 'pico');
			boyfriend = new Boyfriend(770, 450, 'cassandra');
			dad = new Character(100, 100, 'monster');
			boyfriend = new Boyfriend(770, 450, 'bob2');
			dad = new Character(100, 25, 'bosip');
			boyfriend = new Boyfriend(770, 450, 'chara');
			dad = new Character(100, 100, 'bf-sans');
			boyfriend = new Boyfriend(770, 450, 'sunday');
			dad = new Character(100, 100, 'bf-carol');
			boyfriend = new Boyfriend(770, 450, 'bob');
			dad = new Character(100, 100, 'opheebop');
			boyfriend = new Boyfriend(770, 450, 'bf-updike');
			dad = new Character(100, 100, 'bf-sky');
			boyfriend = new Boyfriend(770, 450, 'bf-gf');
			dad = new Character(100, 100, 'hd-senpai');
			boyfriend = new Boyfriend(770, 450, 'bf');
			dad = new Character(100, 100, 'monika');
			boyfriend = new Boyfriend(770, 450, 'rebecca');
			dad = new Character(100, 100, 'garcello');
			boyfriend = new Boyfriend(770, 450, 'bf-annie');
			dad = new Character(100, 100, 'tankman');
			boyfriend = new Boyfriend(770, 450, 'tord2');
			dad = new Character(100, 100, 'tom2');
			boyfriend = new Boyfriend(770, 450, 'miku');
			dad = new Character(100, 100, 'cj');
			boyfriend = new Boyfriend(770, 450, 'ruby');
			dad = new Character(dad.x, dad.y, SONG.player2);
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, SONG.player1);
		}	

		if (SONG.song.toLowerCase() == 'context')	
		{
			dad = new Character(100, 100, 'sky-happy');
			boyfriend = new Boyfriend(770, 450, 'bf-aloe-confused');
			gf = new Character(100, 200, 'gf-nene-cry');
			gf = new Character(gf.x, gf.y, gfVersion);	
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, SONG.player1);
			dad = new Character(dad.x, dad.y, SONG.player2);
		}

		if (SONG.song.toLowerCase() == 'nerves')	
		{
			dad = new Character(0, 100, 'bf-annie');
			gf = new Character(400, 130, 'nogf');
			boyfriend = new Boyfriend(870, 450, 'bf-gf');
			dad = new Character(0, 100, 'dad');
			boyfriend = new Boyfriend(870, 450, 'bf-dad');
			dad = new Character(0, 100, 'mom');
			boyfriend = new Boyfriend(870, 450, 'bf-mom');
			dad = new Character(0, 100, 'tricky');
			dad = new Character(0, 100, 'knuckles');
			dad = new Character(0, 100, 'lila');
			boyfriend = new Boyfriend(870, 450, 'spooky');
			dad = new Character(0, 100, 'tom');
			boyfriend = new Boyfriend(870, 450, 'tord');
			dad = new Character(0, 100, 'gura-amelia');
			boyfriend = new Boyfriend(870, 450, 'botan');
			dad = new Character(0, 100, 'tabi');
			boyfriend = new Boyfriend(870, 450, 'bf-blantad');
			boyfriend = new Boyfriend(870, 450, 'bf-exgf');
			dad = new Character(0, 100, 'miku');
			boyfriend = new Boyfriend(870, 450, 'hex');
			dad = new Character(0, 100, 'pico');
			boyfriend = new Boyfriend(870, 450, 'nene');
			dad = new Character(0, 100, 'whitty');
			boyfriend = new Boyfriend(870, 450, 'agoti');
			dad = new Character(0, 100, 'kapi');
			boyfriend = new Boyfriend(870, 450, 'liz');
			dad = new Character(0, 100, 'bf-sky');
			dad = new Character(0, 100, 'hd-senpai');
			dad = new Character(0, 100, 'hd-senpaiangry');
			boyfriend = new Boyfriend(870, 450, 'tankman');
			dad = new Character(0, 100, 'hd-spirit');
			gf = new Character(gf.x, gf.y, gfVersion);	
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, SONG.player1);
			dad = new Character(dad.x, dad.y, SONG.player2);
		}	

		if (SONG.song.toLowerCase() == 'storm')	
		{
			dad = new Character(0, 100, 'whitty-bw');
			boyfriend = new Boyfriend(870, 100, 'hex-bw');
			dad = new Character(0, 100, 'roro-bw');
			boyfriend = new Boyfriend(770, 450, 'anchor-bw');
			dad = new Character(100, 100, 'gura-amelia-bw');
			boyfriend = new Boyfriend(770, 450, 'bf-aloe-bw');
			dad = new Character(100, 25, 'hd-senpai-bw');
			boyfriend = new Boyfriend(770, 450, 'tankman-bw');
			dad = new Character(100, 100, 'cassandra-bw');
			boyfriend = new Boyfriend(770, 450, 'nene-bw');
			dad = new Character(100, 100, 'pico-bw');
			gf = new Character(400, 130, 'gf-ruv-bw');
			gf = new Character(400, 130, 'gf-alya-bw');
			gf = new Character(400, 130, 'gf-nene-bw');
			gf = new Character(400, 130, 'gf-monika-bw');
			gf = new Character(400, 130, 'gf-pico-bw');
			gf = new Character(400, 130, 'gf-cassandra-bw');
			gf = new Character(gf.x, gf.y, gfVersion);
			dad = new Character(dad.x, dad.y, SONG.player2);
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, SONG.player1);
		}	

		if (SONG.song.toLowerCase() == 'guns' || SONG.song.toLowerCase() == 'ugh')
			{
				dad = new Character(0, 100, 'whitty');
				boyfriend = new Boyfriend(870, 450, 'hex');
				dad = new Character(0, 100, 'sarvente');
				boyfriend = new Boyfriend(1090, 450, 'ruv');
				dad = new Character(0, 100, 'dad');
				boyfriend = new Boyfriend(870, 450, 'mom');
				dad = new Character(0, 100, 'bf-sky');
				dad = new Character(0, 100, 'hd-senpaiangry');
				dad = new Character(0, 100, 'hd-senpai');
				dad = new Character(0, 100, 'pico');
				dad = new Character(0, 100, 'bf-annie');

				if (SONG.song.toLowerCase() == 'guns')
				{					
					dad = new Character(100, 150, 'garcello');
					dad = new Character(100, 150, 'zardy');
					boyfriend = new Boyfriend(1090, 450, 'spooky');			
					boyfriend = new Boyfriend(1090, 450, 'bf-carol');
					dad = new Character(0, 100, 'exgf');
					dad = new Character(0, 100, 'tricky');				
				}

				if (SONG.song.toLowerCase() == 'ugh')
				{				
					boyfriend = new Boyfriend(870, 450, 'bf-exgf');	
					boyfriend = new Boyfriend(870, 450, 'monika');
					dad = new Character(0, 100, 'whittyCrazy');
					dad = new Character(0, 100, 'cassandra');		
					boyfriend = new Boyfriend(870, 450, 'playable-garcello');
				}
				
				gf = new Character(410, 100, gfVersion);	
				dad = new Character(20, 340, SONG.player2);
				boyfriend = new Boyfriend(810, 450, SONG.player1);
			}

		if (SONG.song.toLowerCase() == 'norway')	
		{
			dad = new Character(100, 100, 'bf');
			boyfriend = new Boyfriend(770, 450, 'bf-gf');
			dad = new Character(100, 200, 'tabi');	
			boyfriend = new Boyfriend(770, 450, 'bf-exgf');
			dad = new Character(100, 100, 'pico');
			boyfriend = new Boyfriend(770, 450, 'cassandra');
			dad = new Character(100, 100, 'cj');
			boyfriend = new Boyfriend(770, 450, 'ruby');
			dad = new Character(100, 100, 'coco');
			boyfriend = new Boyfriend(770, 450, 'gura-amelia');
			dad = new Character(100, 100, 'tankman');
			boyfriend = new Boyfriend(770, 450, 'hd-senpai');
			dad = new Character(dad.x, dad.y, SONG.player2);
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, SONG.player1);
		}	

		if (SONG.song.toLowerCase() == 'glitcher')
		{
			dad = new Character(100, 150, 'agoti-wire');
			boyfriend = new Boyfriend(100, 150, 'tabi-wire');
			dad = new Character(dad.x, dad.y, SONG.player2);
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, SONG.player1);
		}	

		if (curStage == 'philly-wire')
		{
			gf = new Character(100, 150, 'nogf-wire');
			dad = new Character(100, 150, 'mia-wire');
			boyfriend = new Boyfriend(100, 150, 'bana-wire');
			gf = new Character(gf.x, gf.y, gfVersion);
			dad = new Character(dad.x, dad.y, SONG.player2);
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, SONG.player1);
		}	

		if (SONG.song.toLowerCase() == 'haachama')
		{
			dad = new Character(100, 150, 'opheebop');
			boyfriend = new Boyfriend(100, 150, 'pumpkinpie');
			dad = new Character(100, 150, 'crazygf');
			boyfriend = new Boyfriend(100, 150, 'drunk-annie');
			dad = new Character(dad.x, dad.y, SONG.player2);
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, SONG.player1);
		}	

		if (SONG.song.toLowerCase() == 'treacherous-dads')
		{
			gf = new Character(580, 430, 'gf-pixeld4');
			dad = new Character(100, 150, 'bitdad');
			dad = new Character(100, 150, 'bitdadcrazy');
			boyfriend = new Boyfriend(100, 150, 'bf-pixeld4');
			gf = new Character(gf.x, gf.y, gfVersion);
			dad = new Character(dad.x, dad.y, SONG.player2);
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, SONG.player1);
		}

		if (SONG.song.toLowerCase() == 'demon-training')
		{
			boyfriend = new Boyfriend(100, 150, 'bf-gf-demon');
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, SONG.player1);
		}	

		if (SONG.song.toLowerCase() == 'roses-remix')
		{
			gf = new Character(580, 430, 'gf-edgeworth-pixel');
			dad = new Character(100, 320, 'bf-gf-pixel');
			boyfriend = new Boyfriend(970, 670, 'bf-pixel');
			gf = new Character(580, 430, 'amy-pixel-mario');
			dad = new Character(100, 175, 'mario-angry');
			boyfriend = new Boyfriend(970, 670, 'bf-sonic-pixel');
			gf = new Character(580, 430, 'gf-edd');
			dad = new Character(100, 175, 'matt-angry');
			boyfriend = new Boyfriend(970, 670, 'bf-tom-pixel');
			dad = new Character(100, 175, 'monster-pixel');
			boyfriend = new Boyfriend(970, 670, 'spooky-pixel');
			dad = new Character(100, 175, 'monika-angry');
			dad = new Character(100, 175, 'green-monika');
			boyfriend = new Boyfriend(970, 670, 'miku-pixel');
			dad = new Character(100, 175, 'kristoph-angry');
			boyfriend = new Boyfriend(970, 670, 'bf-wright-pixel');
			gf = new Character(580, 430, 'gf-flowey');
			dad = new Character(250, 460, 'chara-pixel');
			boyfriend = new Boyfriend(970, 670, 'bf-sans-pixel');
			dad = new Character(250, 460, 'gura-amelia-pixel');
			boyfriend = new Boyfriend(970, 670, 'bf-botan-pixel');
			gf = new Character(580, 430, 'gf-playtime');
			dad = new Character(250, 460, 'baldi-angry');
			boyfriend = new Boyfriend(970, 670, 'mangle-angry');
			gf = new Character(580, 430, 'gf-pixel-neon');
			dad = new Character(250, 460, 'neon');
			boyfriend = new Boyfriend(970, 670, 'bf-whitty-pixel');
			dad = new Character(100, 175, 'jackson');
			boyfriend = new Boyfriend(970, 670, 'bf-pico-pixel');
			gf = new Character(gf.x, gf.y, gfVersion);
			dad = new Character(dad.x, dad.y, SONG.player2);
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, SONG.player1);
		}

		if (SONG.song.toLowerCase() == 'tutorial-remix')
		{
			dad = new Character(gf.x, gf.y, 'gf1');
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, 'bf1');
			dad = new Character(gf.x, gf.y, 'gf2');
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, 'bf2');
			dad = new Character(gf.x, gf.y, 'gf3');
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, 'bf3');
			dad = new Character(gf.x, gf.y, 'gf4');
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, 'bf4');
			dad = new Character(gf.x, gf.y, 'gf4');
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, 'bf4');
			dad = new Character(gf.x, gf.y, 'gf5');
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, 'bf5');
			dad = new Character(gf.x, gf.y, SONG.player2);
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, SONG.player1);
		}

		if (SONG.song.toLowerCase() == 'manifest')	
		{
			dad = new Character(100, 150, 'sarvente-lucifer');
			boyfriend = new Boyfriend(1090, 450, 'selever');
			dad = new Character(100, 150, 'nene');
			boyfriend = new Boyfriend(1090, 450, 'pico');
			dad = new Character(0, 100, 'drunk-annie');
			boyfriend = new Boyfriend(1090, 450, 'playable-garcello');
			dad = new Character(0, 100, 'monika-angry');
			boyfriend = new Boyfriend(1090, 450, 'senpaighosty');
			gf = new Character(400, 130, 'crazygf-crucified');
			gf = new Character(400, 130, 'nogf-crucified');
			dad = new Character(0, 100, 'crazygf');
			boyfriend = new Boyfriend(1090, 450, 'brother');
			dad = new Character(0, 100, 'mom');
			boyfriend = new Boyfriend(1090, 450, 'bf-mom');
			dad = new Character(0, 100, 'sunday');
			boyfriend = new Boyfriend(1090, 450, 'bf-carol');
			dad = new Character(0, 100, 'pompom-mad');
			boyfriend = new Boyfriend(1090, 450, 'kapi');
			dad = new Character(0, 100, 'roro');
			boyfriend = new Boyfriend(1090, 450, 'anchor');
			dad = new Character(0, 100, 'chara');
			boyfriend = new Boyfriend(1090, 450, 'bf-sans');
			dad = new Character(0, 100, 'whittyCrazy');
			boyfriend = new Boyfriend(1090, 450, 'agoti-mad');
			dad = new Character(0, 100, 'miku-mad');
			dad = new Character(0, 100, 'gura-amelia');
			boyfriend = new Boyfriend(1090, 450, 'hex-virus');
			boyfriend = new Boyfriend(1090, 450, 'botan');
			dad = new Character(0, 100, 'tabi-crazy');
			boyfriend = new Boyfriend(1090, 450, 'bf-exgf');
			dad = new Character(0, 100, 'tord');
			boyfriend = new Boyfriend(1090, 450, 'tom');
			gf = new Character(gf.x, gf.y, gfVersion);	
			dad = new Character(dad.x, dad.y, SONG.player2);
			boyfriend = new Boyfriend(dad.x, dad.y, SONG.player1);
		}

		if (SONG.song.toLowerCase() == 'cosmic')	
		{
			dad = new Character(100, 100, 'bf-carol');
			boyfriend = new Boyfriend(770, 450, 'bf-whitty');
			dad = new Character(100, 100, 'hex');
			gf = new Character(400, 130, 'nogf');
			boyfriend = new Boyfriend(770, 450, 'bf-gf');
			dad = new Character(100, 100, 'bf-lexi');
			gf = new Character(400, 130, 'madgf');
			boyfriend = new Boyfriend(770, 450, 'bf-sky');
			gf = new Character(400, 130, 'gf-tabi');
			dad = new Character(100, 25, 'bf-blantad');
			boyfriend = new Boyfriend(770, 450, 'henry');
			dad = new Character(100, 100, 'shaggy');
			boyfriend = new Boyfriend(770, 450, 'matt');
			dad = new Character(100, 100, 'hd-senpai');
			boyfriend = new Boyfriend(770, 450, 'tankman');
			dad = new Character(100, 100, 'bf-annie');
			boyfriend = new Boyfriend(770, 450, 'playable-garcello');
			dad = new Character(100, 100, 'botan');
			boyfriend = new Boyfriend(770, 450, 'bf-aloe');
			dad = new Character(100, 100, 'miku');
			boyfriend = new Boyfriend(770, 450, 'monika');
			dad = new Character(100, 100, 'sarvente');
			boyfriend = new Boyfriend(770, 450, 'ruv');
			dad = new Character(100, 100, 'tabi');
			boyfriend = new Boyfriend(770, 450, 'exgf');
			dad = new Character(100, 100, 'bf-mom');
			gf = new Character(400, 130, 'gf-kaity');
			boyfriend = new Boyfriend(770, 450, 'bf-dad');
			gf = new Character(gf.x, gf.y, gfVersion);	
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, SONG.player1);
			dad = new Character(100, 400, SONG.player2);
		}	

		if (SONG.song.toLowerCase() == 'animal')	
		{
			dad = new Character(100, 150, 'monster-christmas');
			boyfriend = new Boyfriend(1090, 450, 'spooky');
			dad = new Character(100, 150, 'garcello');
			boyfriend = new Boyfriend(1090, 450, 'matt');
			dad = new Character(0, 100, 'miku');
			boyfriend = new Boyfriend(1090, 450, 'monika');
			dad = new Character(0, 100, 'selever');
			boyfriend = new Boyfriend(1090, 450, 'ruv');
			dad = new Character(0, 100, 'hd-senpai');
			boyfriend = new Boyfriend(870, 450, 'tankman');
			dad = new Character(0, 100, 'liz');
			gf = new Character(400, 130, 'nogf');
			boyfriend = new Boyfriend(870, 450, 'bf-gf');
			dad = new Character(0, 100, 'dad');
			boyfriend = new Boyfriend(870, 450, 'mom');
			dad = new Character(0, 100, 'bf-frisk');
			boyfriend = new Boyfriend(870, 450, 'bf-sans');
			dad = new Character(0, 100, 'whitty');
			boyfriend = new Boyfriend(870, 450, 'hex');
			dad = new Character(0, 100, 'pico');
			boyfriend = new Boyfriend(870, 450, 'kapi');
			dad = new Character(0, 100, 'agoti');
			boyfriend = new Boyfriend(870, 450, 'tabi');
			dad = new Character(0, 100, 'tord');
			boyfriend = new Boyfriend(870, 450, 'tom');
			dad = new Character(0, 100, 'bf-carol');
			boyfriend = new Boyfriend(870, 450, 'bf-sky');
			gf = new Character(gf.x, gf.y, gfVersion);	
			dad = new Character(dad.x, dad.y, SONG.player2);
			boyfriend = new Boyfriend(boyfriend.x, boyfriend.y, SONG.player1);
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		switch(SONG.gfVersion)
		{
			case 'gf-peri-whitty':
				gf.y -= 80;
				gf.x -= 230;
			case 'gf-tankman':
				gf.x -= 175;
		}

		var tabiShitDad:Int = 0;

		if (curStage == 'curse')
		{
			tabiShitDad = -300;
		}

		dad = new Character(100 + tabiShitDad, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case 'gf1' | 'gf2' | 'gf3' | 'gf4' | 'gf5':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky" | "gura-amelia" | "sunday":
				dad.y += 200;
			case "mia":
				dad.x += 100;
				dad.y += 150;
			case "hex-virus":
				dad.y += 100;
			case "agoti-wire" | 'agoti-glitcher':
				dad.y += 100;
			case 'monika-finale':
				dad.x += 15;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case "rebecca":
				dad.x += 0;
				dad.y += 100;
				camPos.y += 500;
				camPos.set(dad.getMidpoint().x + 150, dad.getMidpoint().y + 100);
			case "whittyCrazy":
				dad.x -= 25;
			case "tankman":
				dad.y += 180;
			case 'haachama':
				dad.y += 100;
			case 'monster-christmas' | 'monster' | 'drunk-annie':
				dad.y += 130;
			case 'dad' | 'shaggy' | 'hd-senpai':
				camPos.x += 400;
			case 'bf-dad' | 'bf-blantad':
				dad.y -= 75;
			case 'pico' | 'annie-bw' | 'pico-m':
				camPos.x += 600;
				dad.y += 300;
			case 'botan':
				dad.y += 185;
			case 'neko-crazy':
                dad.x -= 50;
                dad.y += 230;
                camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'agoti-mad':
				dad.y += 100;
			case 'kou' | 'nene' | 'liz':
				camPos.x += 600;
				dad.y += 300;
			case 'bf-annie':
				camPos.x += 600;
				dad.y += 300;
			case 'bf' | 'bf-frisk' | 'bf-gf':
				camPos.x += 600;
				dad.y += 350;
			case 'bf-carol':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai' | 'monika':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry' | 'kristoph-angry' | 'senpai-giddy' | 'baldi-angry ' | 'mangle-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'lane-pixel':
				dad.x += 150;
				dad.y += 560;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y - 200);
			case 'bf-gf-pixel' | 'bf-pixel':
				dad.x += 150;
				dad.y += 460;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'bf-sky':
				dad.x -= 100;
				dad.y += 400;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'bf-botan-pixel':
				dad.x += 150;
				dad.y += 460;
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
			case 'monika-angry' | 'green-monika' | 'neon' | 'matt-angry' | 'jackson' | 'mario-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'colt-angryd2' | 'colt-angryd2corrupted':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'impostor':
				dad.y += 300;
				camPos.y -= 200;
				camPos.x += 400;	
			case 'updike':
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'demoncass':
				dad.y -= 50;	
			case 'bob':
				camPos.x += 600;
				dad.y += 300;	
			case 'cjClone':
				dad.x -= 250;
				dad.y -= 150;
				gf.x += 300;
				gf.y -= 25;
				dad.visible = false;
			case 'momi':
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				dad.y += 50;
			case 'rosie' | 'rosie-angry' | 'rosie-furious':
				dad.y += 100;
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

		var tabiShitBF:Int = 0;

		if (curStage == 'curse')
		{
			tabiShitBF = 300;
		}
		
		boyfriend = new Boyfriend(770 + tabiShitBF, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'prologue':
				dad.y += 50;
				boyfriend.y += 80;

			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'limoholo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'mallAnnie':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'school-switch':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'school-monika':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolnoon':
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
			case 'garStage' | 'eddhouse2' | 'm-stage':
				boyfriend.x += 50;
			case 'emptystage2':
				boyfriend.x += 100;
				dad.x -= 100;
			case 'garStageRise':
				boyfriend.x += 50;
			case 'stageruv':
				boyfriend.x += 100;
				dad.x -= 100;
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

			case 'skybroke':
				dad.x -= 100;
				dad.y += 100;
			
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

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
				dad.x -= 100;
				gf.y -= 110;
				gf.x -= 50;
			
			case 'skybroke':
				boyfriend.x += 60;
				boyfriend.y -= 145;
				dad.x -= 70;
				dad.y -= 100;
				gf.x -= 40;
				gf.y -= 170;

			case 'sabotage':
				gf.y -= 100;

			case 'auditorHell':
				boyfriend.y -= 160;
				boyfriend.x += 350;

			case 'shaggy-mansion':
				boyfriend.x += 100;
			case 'churchsarv':
				gf.x -= 100;
				gf.y -= 100;
				dad.y += 100;
				boyfriend.x += 100;
				boyfriend.y += 100;

			case 'mind':
				boyfriend.y += 150;
				boyfriend.x -= -220;
				dad.x -= 200;
				dad.y -= 50;

			case 'facility':
				boyfriend.x += 660;
				boyfriend.y += 230;
				gf.x += 575;
				gf.y += 430;
				dad.x += 310;
				dad.y += 250;
				gf.scrollFactor.set(1, 1);
		}

		switch (SONG.player1)
		{
			case 'pico' | 'annie-bw' | 'kou':
				boyfriend.x += 40;
				boyfriend.y -= 75;
			case 'monster' | 'monster-christmas':
				boyfriend.x += 100;
				boyfriend.y -= 250;
			case 'haachama':
				boyfriend.y -= 250;
			case 'henry-angry':
				boyfriend.x += 300;
				boyfriend.y -= 150;
			case 'senpai' | 'senpai-giddy' | 'monika':
				boyfriend.y -= 200;
			case 'senpai-angry' | 'colt-angry':
				boyfriend.y -= 200;
			case 'bf-whitty-pixel':
				boyfriend.y -= 170;
			case "gura-amelia" | "spooky":
				boyfriend.y -= 200;
			case 'monster-pixel':
				boyfriend.y -= 200;
			case 'miku-pixel' | 'mangle-angry' | 'monika-angry':
				boyfriend.y -= 200;
			case 'mario-angry' | 'jackson' | 'matt-angry':
				boyfriend.y -= 200;
			case 'bf-mom':
				boyfriend.y -= 350;
			case 'bana':
				boyfriend.y -= 260;
			case 'cassandra':
				boyfriend.y -= 325;
			case 'anchor':
				boyfriend.y -= 350;
			case 'tom2' | 'tord2' | 'matt2' | 'edd2' | 'garcello' | 'garcellotired':
				boyfriend.x -= 100;
				boyfriend.y -= 350;
			case 'bf-dad':
				boyfriend.y -= 350;
			case 'tabi-wire' | 'tabi-glitcher' | 'tabi':
				boyfriend.y -= 350;
			case 'bf-exgf':
				boyfriend.x += 100;
				boyfriend.y -= 400;
			case 'bf-blantad':
				boyfriend.y -= 400;
			case 'mom-car' | 'dad' | 'mom' | 'hex' | 'hd-senpai' | 'hd-senpaiangry' | 'bf-senpai-worried' | 'parents-christmas':
				boyfriend.y -= 350;
			case 'sarvente' | 'ruv':
				boyfriend.y -= 300;
			case 'botan':
				boyfriend.x += 40;
				boyfriend.y -= 75;
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
			case 'tord':
				boyfriend.y -= 200;
			case 'tom':
				boyfriend.y -= 200;
			case 'tankman':
				boyfriend.y -= 150;
			case 'ruby-worried':
				boyfriend.y -= 510;
				boyfriend.x += 200;
			case 'ruby' | 'ruby-worried-night':
				boyfriend.x += 100;
				boyfriend.y -= 350;
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

		if (curStage == 'auditorHell')
		{
			add(hole);
		}		

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo' || curStage == 'limoholo')
			add(limo);

		if (curStage == 'stageruv')
			add(pillarbroke);

		if (curStage == 'philly-wire')
			add(melandperi);
			add(melandperiwire);

		add(dad);
		add(boyfriend);

		if (curStage == 'curse')
		{
			var sumtable:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('tabi/sumtable'));
			sumtable.antialiasing = true;
			sumtable.scrollFactor.set(0.9, 0.9);
			sumtable.active = false;
			add(sumtable);
		}


		if (curStage == "momiStage")
		{
			add(dust);
			add(car);
		}
				
		if (curStage == 'tank' )	
		{
			add(tank0);
			add(tank1);
			add(tank2);
			add(tank4);
			add(tank5);
			add(tank3);
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

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

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
		if (curSong == 'Storm')
		{
			healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBarWhite'));
		}
		else
		{
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
		if (curStage.startsWith('gar'))
		{
			healthBar.createFilledBar(0xFF8E40A5, 0xFF66FF33);
		}
		else if (curSong == 'Accidental-Bop')
		{
			healthBar.createFilledBar(0xFFC11200, 0xFF265D86);
		}
		else if (curSong == 'Storm')
		{
			healthBar.createFilledBar(0xFF000000, 0xFF000000);
		}
		else if (curStage == 'emptystage')
		{
			curcol = col[characterCol.indexOf(dad.curCharacter)]; // Dad Icon
			curcol2 = col[characterCol.indexOf(boyfriend.curCharacter)]; // Bf Icon
	
			healthBar.createFilledBar(curcol, curcol2);
		}
		else
			healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		if (curSong == 'Storm')
		{
			scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.BLACK, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.WHITE);
		}
		else
		{
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

		iconP1 = new HealthIcon(SONG.player1, true);
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
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
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
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

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

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{
		inCutscene = false;

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

		if (curSong == 'Norway')
		{
			tomBG.animation.play('idle');
			bfBG.animation.play('idle');
			mattBG.animation.play('idle');
			tordBG.animation.play('idle');
			gfBG.dance();
		}

		if (curSong == 'Battle')
		{
			zero16.animation.play('idle');
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
			introAssets.set('emptystage2', [
				'bw/ready',
				'bw/set',
				'bw/go'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					if (curStage == 'emptystage2')
					{
						altSuffix = '';
					}
					else
					{
						altSuffix = '-pixel';
					}
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
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
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
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
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
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
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
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
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
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

	function generateStaticArrows(player:Int,noteTypeCheck:String,tweenShit:Bool = true):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			babyArrow = new FlxSprite(0, strumLine.y);

			//defaults if no noteStyle was found in chart
		
			if (SONG.noteStyle == null) {
				switch(storyWeek) {case 6: noteTypeCheck = 'pixel';}
			} else {noteTypeCheck = SONG.noteStyle;}

			switch (noteTypeCheck)
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
				
					case 'normal':
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

						case 'auditor':
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

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		floatshit += 0.05;

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
				health -= 0.001;
			}
		}

		if (SONG.song.toLowerCase() == 'demon-training' && minusHealth && curStep >= 1024 && curStep < 1280)
		{
			if (health > 0)
			{
				health -= 0.001;
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
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
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

		if (dad.curCharacter == "sarvente-lucifer")
		{
			dad.y += Math.sin(floatshit);
		}

		if (dad.curCharacter == "senpaighosty" && curSong == 'Tormentor')
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

				if (curStage == 'prologue')
				{
					offsetX = 50;
				}

				if (curStage == 'mind')
				{
					offsetX = 200;
				}

				if (curSong == 'gun-buddies')
				{
					offsetY = 50;
				}

				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerTwoTurn', []);
				#end
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y - 50;
					case 'rebecca':
						camFollow.y = dad.getMidpoint().y - 50;
					case 'bf-annie':
						camFollow.x = dad.getMidpoint().x + 250;
					case 'botan':
						camFollow.x = dad.getMidpoint().x + 50;	
						camFollow.y = dad.getMidpoint().y - 100 + offsetY;	
					case 'annie-bw':
						camFollow.x = dad.getMidpoint().x + 200;	
						camFollow.y = dad.getMidpoint().y - 200;	
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'bf-whitty-pixel':
						camFollow.y = dad.getMidpoint().y - 300;
						camFollow.x = dad.getMidpoint().x + 60;
					case 'senpai-giddy':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'bitdad':
						camFollow.y = dad.getMidpoint().y - 75;
						camFollow.x = dad.getMidpoint().x + 200;
					case 'bitdadBSide':
						camFollow.y = dad.getMidpoint().y - 75;
						camFollow.x = dad.getMidpoint().x + 200;
					case 'bitdadcrazy':
						camFollow.y = dad.getMidpoint().y - 75;
						camFollow.x = dad.getMidpoint().x + 230;
					case 'monika' | 'monster-pixel':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'monika-angry' | 'green-monika' | 'neon' | 'baldi-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'matt-angry' | 'mario-angry' | 'colt-angry' |'kristoph-angry' | 'chara-pixel' | 'colt-angryd2' | 'colt-angryd2corrupted':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'jackson':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'cassandra' | 'cassandra-bw':
						camFollow.y = dad.getMidpoint().y + 75;
					case 'sunday':
						camFollow.y = dad.getMidpoint().y - 100;
					case 'bf-gf-pixel' | 'bf-botan-pixel':
						camFollow.x = dad.getMidpoint().x + 125;
						camFollow.y = dad.getMidpoint().y - 225;
					case 'bf-annie':
						camFollow.y = dad.getMidpoint().y - 200;
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
						camFollow.x = dad.getMidpoint().x - 200;
					case 'monika-finale':
						camFollow.y = dad.getMidpoint().y - 390;
						camFollow.x = dad.getMidpoint().x - 250;
					case 'momi':
						camFollow.x = dad.getMidpoint().x + 200;
					case 'bf-sky' | 'sky-annoyed' | 'sky-happy' | 'sky-mad':
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial-remix')
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

				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);

				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);
				#end

				switch (curStage)
				{
					case 'limo' | 'limoholo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school-switch':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school-monika':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolnoon':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				if (SONG.song.toLowerCase() == 'tutorial-remix')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}

				switch (boyfriend.curCharacter)
				{
					case 'mom':
						camFollow.y = boyfriend.getMidpoint().y - 50;
						camFollow.x = boyfriend.getMidpoint().x - 250;
					case 'dad':
						camFollow.y = boyfriend.getMidpoint().y - 50;
						camFollow.x = boyfriend.getMidpoint().x - 250;
					case 'cassandra':
						camFollow.y = boyfriend.getMidpoint().y + 100;
						camFollow.x = boyfriend.getMidpoint().x - 200;
					case 'bana' | 'bana-wire':
						camFollow.y = boyfriend.getMidpoint().y;
						camFollow.x = boyfriend.getMidpoint().x - 150;
					case 'pompom-mad':
						camFollow.y = boyfriend.getMidpoint().y - 150;
					case 'henry-angry':
						camFollow.x = boyfriend.getMidpoint().x - 250;
					case 'bf-annie':
						camFollow.x = boyfriend.getMidpoint().x - 300;	
					case 'pico' | 'annie-bw':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'nene' | 'nene-bw':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'botan':
						camFollow.x = boyfriend.getMidpoint().x - 300;			
					case 'senpai' | 'blantad-pixel' | 'neon':
						camFollow.x = boyfriend.getMidpoint().x - 400;
						camFollow.y = boyfriend.getMidpoint().y - 400;
					case 'senpai-angry':
						camFollow.x = boyfriend.getMidpoint().x - 400;
						camFollow.y = boyfriend.getMidpoint().y - 400;
					case 'senpai-giddy':
						camFollow.x = boyfriend.getMidpoint().x - 400;
						camFollow.y = boyfriend.getMidpoint().y - 400;
					case 'monika':
						camFollow.x = boyfriend.getMidpoint().x - 400;
						camFollow.y = boyfriend.getMidpoint().y - 400;
					case 'monika-angry':
						camFollow.x = boyfriend.getMidpoint().x - 400;
						camFollow.y = boyfriend.getMidpoint().y - 400;
					case 'miku-pixel' | 'mangle-angry':
						camFollow.x = boyfriend.getMidpoint().x - 400;
						camFollow.y = boyfriend.getMidpoint().y - 400;
					case 'bitdadnormal':
						camFollow.x = boyfriend.getMidpoint().x - 400;
						camFollow.y = boyfriend.getMidpoint().y - 400;
					case 'monster-pixel':
						camFollow.x = boyfriend.getMidpoint().x - 400;
						camFollow.y = boyfriend.getMidpoint().y - 400;
					case 'jackson':
						camFollow.x = boyfriend.getMidpoint().x - 400;
						camFollow.y = boyfriend.getMidpoint().y - 400;
					case 'matt-angry' | 'mario-angry' | 'colt-angry':
						camFollow.x = boyfriend.getMidpoint().x - 400;
						camFollow.y = boyfriend.getMidpoint().y - 400;
					case 'colt-angryd2' | 'colt-angryd2corrupted':
						camFollow.x = boyfriend.getMidpoint().x - 400;
						camFollow.y = boyfriend.getMidpoint().y - 400;
					case 'anchor' | 'anchor-bw':
						camFollow.y = boyfriend.getMidpoint().y + 25;
					case 'brother':
						camFollow.y = boyfriend.getMidpoint().y + 25;
					case 'spooky-pixel':
						camFollow.x = boyfriend.getMidpoint().x - 250;
						camFollow.y = boyfriend.getMidpoint().y - 100;
					case 'spooky':
						camFollow.x = boyfriend.getMidpoint().x + 100;
						camFollow.y = boyfriend.getMidpoint().y;
					case 'bf-pico-pixel':
						camFollow.x = boyfriend.getMidpoint().x - 300;
						camFollow.y = boyfriend.getMidpoint().y - 250;
					case 'bf-botan-pixel':
						camFollow.x = boyfriend.getMidpoint().x - 300;
						camFollow.y = boyfriend.getMidpoint().y - 150;
					case 'bf-whitty-pixel':
						camFollow.x = boyfriend.getMidpoint().x - 350;
						camFollow.y = boyfriend.getMidpoint().y - 300;
					case 'bf-whitty':
						camFollow.x = boyfriend.getMidpoint().x - 200 + offsetX;	
					case 'bf-gf' | 'bf-aloe' | 'playable-garcello' | 'ruv' | 'tabi' | 'bf-dad' | 'liz':
						camFollow.x = boyfriend.getMidpoint().x - 200;
					case 'bf-senpai-worried':
						camFollow.x = boyfriend.getMidpoint().x - 300;	
					case 'bf-sky':
						camFollow.x = boyfriend.getMidpoint().x - 200;	
					case 'tankman' | 'henry':
						camFollow.x = boyfriend.getMidpoint().x - 200;	
					case 'tabi-glitcher' | 'tabi-wire':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'bf-blantad':
						camFollow.y = boyfriend.getMidpoint().y;
					case 'bf-senpai-pixel-angry':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'kou':
						camFollow.y = boyfriend.getMidpoint().y - 10;
					case 'gura-amelia':
						camFollow.x = boyfriend.getMidpoint().x - 200;
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

		if (health <= 0)
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

			if(FlxG.keys.justPressed.R)
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
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							{
								dad.altAnim = '-alt';
							}

							if (curSong == 'Ugh')
								{
									switch (curStep)
									{
										case 60 | 444 | 524 | 540 | 541 | 828  | 829 | 830 | 831 | 832 | 833 | 834 | 835 | 836:
											dad.altAnim = '-alt';
									}
								}

							if (curSong == 'Accidental-Bop')
								{
									switch (curStep)
									{
										case 892:
											dad.altAnim = '-alt';
									}
								}

							if (curSong == 'Norway')
								{
									switch (curBeat)
									{
										case 135:
											dad.altAnim = '-alt';
									}
								}

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

							if (curSong == 'Roses-Remix')
								{
									switch (curStep)
									{
										case 396 | 398 | 404 | 406 | 412 | 413:
											dad.altAnim = '-alt';
									}
								}

							if (curSong == 'Test' && dad.curCharacter == 'bf-sky')
								{
									switch (curBeat)
									{
										case 48 | 49 | 58 | 59:
											dad.altAnim = '-alt';
									}
								}
						}
						
						if (!(curBeat >= 532 && curBeat < 536  && curSong.toLowerCase() == "expurgation"))
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
									if (FlxG.random.bool(50) && !spookyRendered && !daNote.isSustainNote) // create spooky text :flushed:
										{
											createSpookyText(cjCloneLinesSing[FlxG.random.int(0,cjCloneLinesSing.length)]);
										}
							}
						
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

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
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
					if (health < 2)
						health += 0.02;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.75;
				case 'sick':
					if (health < 2)
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
			if (curSong == 'Remorse')
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
			health -= 0.02;
			totalDamageTaken += 0.02;
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
					boyfriend.playAnim('singLEFTmiss' + bfAltAnim, true);
				case 1:
					boyfriend.playAnim('singDOWNmiss' + bfAltAnim, true);
				case 2:
					boyfriend.playAnim('singUPmiss' + bfAltAnim, true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss' + bfAltAnim, true);
			}

			/*if (daNote == null || daNote.mustPress) 
			{
				boyfriend.sing(direction, true);
			}*/

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

			if (SONG.notes[Math.floor(curStep / 16)] != null)
			{
				if (SONG.notes[Math.floor(curStep / 16)].bfAltAnim)
					boyfriend.bfAltAnim = '-alt';

				if (curSong == 'Guns' && curStep >= 1374 && boyfriend.curCharacter == 'bf-sky')
				{
					boyfriend.bfAltAnim = '-alt';
				}

				if (curSong == 'Ugh')
				{
					switch (curStep)
					{
						case 588 | 604 | 605:
							boyfriend.bfAltAnim = '-alt';
					}
				}

				if (curSong == 'Nerves')
				{
					switch (curStep)
					{
						case 443 | 444 | 445:
							boyfriend.bfAltAnim = '-alt';
					}
				}

				if (curSong == 'Test' && boyfriend.curCharacter == 'bf-pixeld4')
				{
					switch (curBeat)
					{
						case 52 | 53 | 62 | 63:
							boyfriend.bfAltAnim = '-alt';
					}
				}

				if (curSong == 'Treacherous-Dads')
				{
					switch (curStep)
					{
						case 368 | 369 | 371 | 372 | 374 | 375 | 378 | 379 | 382 | 383| 624 | 625 | 628 | 629 | 632 | 633 | 636 | 637 | 752 | 753 | 756 | 757 | 760 | 761| 764 | 765 | 1008 | 1009 | 1012 | 1013 | 1016 | 1017 | 1020 | 1021 | 1024:
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
			FlxG.camera.shake(0.01, 0.1);
		}	
		
		if (gf.animOffsets.exists('scared'))
		{
			gf.playAnim('scared', true);
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
		}


		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (boyfriend.curCharacter == 'pico')
		{
			if (boyfriend.animation.curAnim.name == 'singDOWN-alt')
			{
				FlxG.sound.play(Paths.sound('shooters'));
				FlxG.camera.shake(0.01, 0.15);
			}
		}

		/*if (dad.curCharacter == 'pico')
		{
			if (boyfriend.animation.curAnim.name == 'singDOWN-alt')
			{
				FlxG.sound.play(Paths.sound('shooters'));
			}
		}*/

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
		}

		if (curSong == 'Demon-Training')
		{
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
								gf.destroy();
								gf = new Character(oldGFX, oldGFY, 'gf-nene-cry');
								add(gf);
								dad.destroy();
								dad = new Character(oldDadX, oldDadY, 'sky-happy');
								add(dad);
								boyfriend.destroy();
								boyfriend = new Boyfriend(oldBFX, oldBFY, 'bf-aloe-confused');
								add(boyfriend);
								iconP1.animation.play('bf-aloe-confused');
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

		if (curSong == 'Storm')
			{
				switch (curStep)
				{
					case 128:
						remove(dad);
						remove(gf);
						dad = new Character(0, 100, 'whitty-bw');
						gf = new Character (400, 130, 'gf-ruv-bw');
						add(gf);
						add(dad);			
						iconP2.animation.play('whitty-bw');
					case 192:
						remove(boyfriend);
						boyfriend = new Boyfriend(870, 100, 'hex-bw');
						add(boyfriend);
						iconP1.animation.play('hex-bw');
					case 248: 
						boyfriend.playAnim('wink', true);
					case 256:
						boyfriend.playAnim('idle');
					case 258:		
						remove(dad);
						remove(gf);
						dad = new Character(-300, 100, 'roro-bw');
						gf = new Character (400, 30, 'gf-alya-bw');
						add(gf);
						add(dad);			
						iconP2.animation.play('roro-bw');
					case 322:
						remove(boyfriend);
						boyfriend = new Boyfriend(870, 50, 'anchor-bw');
						add(boyfriend);
						iconP1.animation.play('anchor-bw');
					case 386:
						remove(dad);
						remove(gf);
						dad = new Character(0, 300, 'gura-amelia-bw');
						gf = new Character (400, 130, 'gf-nene-bw');
						add(gf);
						add(dad);			
						iconP2.animation.play('gura-amelia-bw');
					case 450:
						remove(boyfriend);
						boyfriend = new Boyfriend(870, 450, 'bf-aloe-bw');
						add(boyfriend);
						iconP1.animation.play('bf-aloe-bw');
					case 514:
						remove(dad);
						remove(gf);
						dad = new Character(0, 150, 'hd-senpai-bw');
						gf = new Character (400, 130, 'gf-monika-bw');
						add(gf);
						add(dad);			
						iconP2.animation.play('hd-senpai-bw');
					case 578:
						remove(boyfriend);
						boyfriend = new Boyfriend(870, 350, 'tankman-bw');
						add(boyfriend);
						iconP1.animation.play('tankman-bw');
					case 642:
						remove(dad);
						remove(gf);
						dad = new Character(0, 125, 'cassandra-bw');
						gf = new Character (400, 130, 'gf-pico-bw');
						add(gf);
						add(dad);			
						iconP2.animation.play('cassandra-bw');
					case 682:
						remove(boyfriend);
						boyfriend = new Boyfriend(870, 375, 'nene-bw');
						add(boyfriend);
						iconP1.animation.play('nene-bw');
					case 746:
						remove(dad);
						remove(gf);
						gf = new Character (400, 130, 'gf-cassandra-bw');
						dad = new Character(0, 400, 'pico-bw');
						add(gf);
						add(dad);			
						iconP2.animation.play('pico-bw');
				}
			}	

		if (curStep == 247 && SONG.song.toLowerCase() == 'fading-senpai')
			{
				dad.playAnim('disappear', true);
			}

		if (SONG.song.toLowerCase() == 'fading-senpai' && boyfriend.curCharacter == 'tankman')
		{
			iconP1.animation.play('tankmansad');
		}

		if (SONG.song.toLowerCase() == 'dead-pixel' && boyfriend.curCharacter == 'monster-pixel')
		{
			iconP1.animation.play('monster-pixel-look');
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
						changeToPixelCorrupted();
						bgSkyEvil.alpha = 1;
						bgSchoolEvil.alpha = 1;
						fgTreesEvil.alpha = 1;
						bgStreetEvil.alpha = 1;
						bgTrees.alpha = 0;
						remove(dad);
						dad = new Character(100, 175, 'bitdadcrazy');
						add(dad);
						iconP2.animation.play('bitdadcrazy');
						remove(gf);
					case 274 | 278 | 288 | 312 | 680 | 1040 | 1051 | 1053 | 1055 | 1081 | 1083 | 1085 | 1087 | 1160 | 1192:
						changeToPixel();
						bgSkyEvil.alpha = 0;
						bgSchoolEvil.alpha = 0;
						fgTreesEvil.alpha = 0;
						bgStreetEvil.alpha = 0;
						bgTrees.alpha = 1;
						remove(dad);
						add(gf);
						dad = new Character(100, 175, 'bitdadBSide');
						add(dad);
						iconP2.animation.play('bitdadBSide');				
					case 368 | 752 | 760:
						dad.playAnim('switch', false);
						gf.playAnim('switch', false);
						iconP1.animation.play('bf-pixeld4');
						iconP2.animation.play('bitdad');
					case 370 | 373 | 380 | 628 | 636 | 754 | 758 | 762:
						iconP1.animation.play('bf-pixeld4BSide');
						iconP2.animation.play('bitdadBSide');
					case 371 | 374 | 378 | 382 | 626 | 630 | 634 | 638 | 756 | 764:
						iconP1.animation.play('bf-pixeld4');
						iconP2.animation.play('bitdad');
					case 376 | 624 | 632:
						dad.playAnim('switch', false);
						gf.playAnim('switch', false);
						iconP1.animation.play('bf-pixeld4BSide');
						iconP2.animation.play('bitdadBSide');
					case 383:
						gf.destroy();
						gf = new Character(580, 430, 'gf-pixeld4');
						add(gf);
						dad.destroy();
						dad = new Character(100, 175, 'bitdad');
						add(dad);
						iconP2.animation.play('bitdad');
						boyfriend.destroy();
						boyfriend = new Boyfriend(970, 670, 'bf-pixeld4');
						add(boyfriend);
					case 513 | 516 | 520 | 784 | 812 | 897 | 899 | 901 | 903 | 992:
						bgSkyEvil.alpha = 0;
						bgSchoolEvil.alpha = 0;
						fgTreesEvil.alpha = 0;
						bgStreetEvil.alpha = 0;
						bgTrees.alpha = 1;
						remove(dad);
						add(gf);
						dad = new Character(100, 175, 'bitdad');
						add(dad);
						iconP2.animation.play('bitdad');
					case 640:
						bgSkyEvil.alpha = 1;
						bgSchoolEvil.alpha = 1;
						fgTreesEvil.alpha = 1;
						bgStreetEvil.alpha = 1;
						bgTrees.alpha = 0;
						dad.destroy();
						dad = new Character(100, 175, 'bitdadcrazy');
						add(dad);
						iconP2.animation.play('bitdadcrazy');
						boyfriend.destroy();
						boyfriend = new Boyfriend(970, 670, 'bf-pixeld4BSide');
						add(boyfriend);
						iconP1.animation.play('bf-pixeld4BSide');
						remove(gf);
					case 648:
						bgSkyEvil.alpha = 0;
						bgSchoolEvil.alpha = 0;
						fgTreesEvil.alpha = 0;
						bgStreetEvil.alpha = 0;
						bgTrees.alpha = 1;
						remove(dad);
						add (bgTrees);
						gf = new Character(580, 430, 'gf-pixeld4BSide');
						add(gf);
						dad = new Character(100, 175, 'bitdadBSide');
						add(dad);
						iconP2.animation.play('bitdadBSide');
					case 768:
						remove(dad);
						remove(gf);
						remove(boyfriend);
						dad = new Character(100, 175, 'bitdad');			
						gf = new Character(580, 430, 'gf-pixeld4');								
						boyfriend = new Boyfriend(970, 670, 'bf-pixeld4');
						add(gf);
						add(dad);
						add(boyfriend);
						iconP2.animation.play('bitdad');
						iconP1.animation.play('bf-pixeld4');
					case 1008 | 1016:
						dad.playAnim('switch', false);
						gf.playAnim('switch', false);
						iconP1.animation.play('bf-pixeld4BSide');
						iconP2.animation.play('bitdadBSide');
					case 1010 | 1014 | 1018 | 1022:
						iconP1.animation.play('bf-pixeld4');
						iconP2.animation.play('bitdad');
					case 1012 | 1020:
						iconP1.animation.play('bf-pixeld4BSide');
						iconP2.animation.play('bitdadBSide');
					case 1024:
						remove(dad);
						remove(gf);
						remove(boyfriend);
						dad = new Character(100, 175, 'bitdadBSide');		
						iconP2.animation.play('bitdadBSide');	
						gf = new Character(580, 430, 'gf-pixeld4BSide');
						boyfriend = new Boyfriend(970, 670, 'bf-pixeld4BSide');
						add(gf);
						add(dad);
						add(boyfriend);
						iconP1.animation.play('bf-pixeld4BSide');
				}
			}	

			if (curSong == 'Nerves')
			{
					switch (curStep)
				{
					case 166:
						remove(dad);
						dad = new Character(0, 100, 'dad');
						add(dad);
						iconP2.animation.play('dad');
					case 182: 
						remove(gf);
						gf = new Character(400, 130, 'gf');
						add(gf);	
						remove(boyfriend);
						boyfriend = new Boyfriend(870, 25, 'bf-dad');
						add(boyfriend);
						iconP1.animation.play('bf-dad');	
					case 198:
						remove(dad);
						dad = new Character(0, 100, 'mom');
						add(dad);
						iconP2.animation.play('mom');
					case 422:
						remove(dad);
						dad = new Character(0, 400, 'pico');
						add(dad);
						iconP2.animation.play('pico');
					case 454:
						remove(boyfriend);
						boyfriend = new Boyfriend(910, 375, 'nene');
						add(boyfriend);
						iconP1.animation.play('nene');	
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
						remove(gf);
						monikaBG.alpha = 1;
						monikaBG.animation.play('idle');
						iconP2.animation.play('green-monika');
					case 404 | 406:
						FlxG.sound.play(Paths.sound('glitch'));					
						remove(gf);
						remove(dad);
						monikaBG.animation.play('just-monika');
						monikaBG.alpha = 1;
						iconP2.animation.play('empty');
					case 412 | 413:
						FlxG.sound.play(Paths.sound('glitch'));
						remove(gf);
						monikaBG.animation.play('ghost');
						monikaBG.alpha = 1;
						iconP2.animation.play('green-monika');
					case 397 | 400 | 414:
						add(gf);
						monikaBG.alpha = 0;
						iconP2.animation.play('monika-angry');
					case 405 | 407:
						add(gf);
						add(dad);
						monikaBG.alpha = 0;
						iconP2.animation.play('monika-angry');
					case 428 | 430 | 431:
						FlxG.sound.play(Paths.sound('glitch'));
						remove(gf);
						remove(dad);
						dad = new Character(250, 460, 'green-monika');
						add(dad);
						monikaBG.alpha = 1;
						monikaBG.animation.play('idle');
						iconP2.animation.play('green-monika');
					case 436 | 438:
						FlxG.sound.play(Paths.sound('glitch'));					
						remove(gf);
						remove(dad);
						monikaBG.animation.play('jumpscare');
						monikaBG.alpha = 1;
						iconP2.animation.play('monika-jumpscare');
					case 444 | 445:
						FlxG.sound.play(Paths.sound('glitch'));
						remove(gf);
						remove(dad);
						dad = new Character(250, 460, 'green-monika');
						add(dad);
						monikaBG.animation.play('ghost');
						monikaBG.alpha = 1;
						iconP2.animation.play('green-monika');
					case 429 | 432 | 446:
						add(gf);
						remove(dad);
						dad = new Character(250, 460, 'monika-angry');
						add(dad);
						monikaBG.alpha = 0;
						iconP2.animation.play('monika-angry');
					case 437 | 439:
						add(gf);
						add(dad);
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

		if (curSong == 'Guns') 
		{
			switch (curBeat)
			{
				case 64:
					remove(dad);
					dad = new Character(20, 100, 'dad');
					add(dad);
					iconP2.animation.play('dad');
				case 80:
					remove(boyfriend);
					boyfriend = new Boyfriend(810, 75, 'mom');
					add(boyfriend);
					iconP1.animation.play('mom');
				case 96:
					remove(dad);
					dad = new Character(20, 400, 'pico');
					add(dad);
					iconP2.animation.play('pico');
				case 104:
					remove(boyfriend);
					boyfriend = new Boyfriend(810, 100, 'hd-senpaiangry');
					add(boyfriend);
					iconP1.animation.play('hd-senpaiangry');
				case 128:
					remove(dad);
					dad = new Character(-55, 75, 'garcello');
					add(dad);
					iconP2.animation.play('garcello');
				case 140:
					remove(boyfriend);
					boyfriend = new Boyfriend(810, 450, 'bf-annie');
					add(boyfriend);
					iconP1.animation.play('bf-annie');
				case 160:
					remove(dad);
					dad = new Character(-55, 100, 'zardy');
					add(dad);
					iconP2.animation.play('zardy');
				case 176:
					remove(boyfriend);
					boyfriend = new Boyfriend(810, 300, 'spooky');
					add(boyfriend);
					iconP1.animation.play('bf-spooky');
				case 192:
					remove(dad);
					dad = new Character(20, 100, 'whitty');
					add(dad);
					iconP2.animation.play('whitty');
				case 208:
					remove(boyfriend);
					boyfriend = new Boyfriend(810, 450, 'bf-carol');
					add(boyfriend);
					iconP1.animation.play('bf-carol');
				case 224:
					remove(dad);
					dad = new Character(-55, 75, 'sarvente');
					add(dad);
					iconP2.animation.play('sarvente');
				case 256:
					remove(boyfriend);
					boyfriend = new Boyfriend(810, 75, 'ruv');
					add(boyfriend);
					iconP1.animation.play('ruv');
				case 288:
					remove(dad);
					dad = new Character(20, 100, 'exgf');
					add(dad);
					iconP2.animation.play('exgf');
				case 320:
					remove(boyfriend);
					boyfriend = new Boyfriend(810, 500, 'bf-sky');
					add(boyfriend);
					iconP1.animation.play('bf-sky');
				case 352:
					remove(dad);
					dad = new Character(20, 140, 'tricky');
					add(dad);
					iconP2.animation.play('tricky');
				case 384:
					remove(boyfriend);
					boyfriend = new Boyfriend(810, 75, 'hex');
					add(boyfriend);
					iconP1.animation.play('hex');
			}
		}

		if (curSong == 'Manifest') 
		{
			switch (curBeat)
			{
				/*case 32:
					remove(dad);
					dad = new Character(0, -100, 'sarvente-lucifer');
					add(dad);
					iconP2.animation.play('sarvente-lucifer');
				case 48:
					remove(boyfriend);
					boyfriend = new Boyfriend(810, 100, 'selever');
					add(boyfriend);
					iconP1.animation.play('selever');
				case 64:
					remove(dad);
					dad = new Character(0, 450, 'nene');
					add(dad);
					iconP2.animation.play('nene');
				case 74:
					remove(boyfriend);
					boyfriend = new Boyfriend(770, 450, 'pico');
					add(boyfriend);
					iconP1.animation.play('pico');
				case 84:
					remove(dad);
					dad = new Character(0, 175, 'drunk-annie');
					dad.setZoom(1.2);
					add(dad);
					iconP2.animation.play('drunk-annie');
				case 94:
					remove(boyfriend);
					boyfriend = new Boyfriend(770, 475, 'playable-garcello');
					add(boyfriend);
					iconP1.animation.play('playable-garcello');
				case 104:
					dad.setZoom(1);
					remove(dad);
					dad = new Character(200, 400, 'monika-angry');
					add(dad);
					iconP2.animation.play('monika-angry');
				case 120:
					remove(boyfriend);
					boyfriend = new Boyfriend(770, 100, 'senpaighosty');
					add(boyfriend);
					iconP1.animation.play('senpaighosty');
				case 128:
					remove(gf);
					gf = new Character(400, 130, 'crazygf-crucified');
					add(gf);
				case 136:
					remove(gf);
					gf = new Character(400, 130, 'nogf-crucified');
					add(gf);
					remove(dad);
					dad = new Character(0, 375, 'crazygf');
					dad.setZoom(1.2);
					add(dad);
					iconP2.animation.play('crazygf');
				case 152:
					remove(boyfriend);
					boyfriend = new Boyfriend(770, 200, 'brother');
					add(boyfriend);
					iconP1.animation.play('brother');
				case 168:
					dad.setZoom(1);
					remove(dad);
					dad = new Character(0, 100, 'mom');
					add (gfCrazyBG);
					add(dad);
					iconP2.animation.play('mom');
				case 174:
					remove(boyfriend);
					boyfriend = new Boyfriend(770, 100, 'bf-mom');
					add(boyfriend);
					iconP1.animation.play('bf-mom');
				case 180:
					remove(dad);
					dad = new Character(0, 400, 'sunday');
					add(dad);
					iconP2.animation.play('sunday');
				case 186:
					remove(boyfriend);
					boyfriend = new Boyfriend(770, 450, 'bf-carol');
					add(boyfriend);
					iconP1.animation.play('bf-carol');
				case 192:
					remove(dad);
					dad = new Character(0, 400, 'pompom-mad');
					add(dad);
					iconP2.animation.play('pompom-mad');
				case 198:
					remove(boyfriend);
					boyfriend = new Boyfriend(720, 100, 'kapi');
					add(boyfriend);
					iconP1.animation.play('kapi');
				case 204:
					remove(dad);
					dad = new Character(-300, 200, 'roro');
					dad.setZoom(0.9);
					add(dad);
					iconP2.animation.play('roro');
				case 210:
					remove(boyfriend);
					boyfriend = new Boyfriend(770, 75, 'anchor');
					add(boyfriend);
					iconP1.animation.play('anchor');
				case 216:
					dad.setZoom(1);
					remove(dad);
					dad = new Character(0, 450, 'chara');
					add(dad);
					iconP2.animation.play('chara');
				case 232:
					remove(boyfriend);
					boyfriend = new Boyfriend(770, 450, 'bf-sans');
					add(boyfriend);
					iconP1.animation.play('bf-sans');
				case 248:
					remove(dad);
					dad = new Character(-20, 150, 'whittyCrazy');
					add(dad);
					iconP2.animation.play('whittyCrazy');
				case 264:
					remove(boyfriend);
					boyfriend = new Boyfriend(770, 300, 'agoti-mad');
					add(boyfriend);
					iconP1.animation.play('agoti-mad');
				case 280:
					remove(dad);
					dad = new Character(0, 100, 'miku-mad');
					add(dad);
					iconP2.animation.play('miku-mad');
				case 312:
					remove(dad);
					dad = new Character(0, 350, 'gura-amelia');
					add(dad);
					iconP2.animation.play('gura-amelia');
					remove(boyfriend);
					boyfriend = new Boyfriend(770, 100, 'hex');
					add(boyfriend);
					iconP1.animation.play('hex');
				case 344:
					remove(boyfriend);
					boyfriend = new Boyfriend(770, 400, 'botan');
					add(boyfriend);
					iconP1.animation.play('botan');
				case 376:
					remove(dad);
					dad = new Character(0, 200, 'tabi-crazy');
					add(dad);
					tabiTrail = new FlxTrail(dad, null, 4, 24, 0.6, 0.9);
					add(tabiTrail);
					iconP2.animation.play('tabi-crazy');
				case 392:
					remove(boyfriend);
					boyfriend = new Boyfriend(720, 100, 'bf-exgf');
					add(boyfriend);
					iconP1.animation.play('bf-exgf');
				case 408:
					remove(tabiTrail);
					remove(dad);
					dad = new Character(50, 275, 'tord');
					add(dad);
					iconP2.animation.play('tord');
				case 416:
					remove(boyfriend);
					boyfriend = new Boyfriend(770, 275, 'tom');
					add(boyfriend);
					iconP1.animation.play('tom');*/

				case 376:
					tabiTrail = new FlxTrail(dad, null, 4, 24, 0.6, 0.9);
					add(tabiTrail);
				case 408:
					remove(tabiTrail);
			}
		}

		if (curSong == 'Roses-Remix')
		{
			switch (curBeat)
			{
				case 16:
				iconP1.animation.play('bf-tankman-pixel-plain');	
				bgGirls.getScared();
				remove(dad);
				dad = new Character(250, 670, 'bf-gf-pixel');
				add(dad);
				iconP2.animation.play('bf-gf-pixel');
				case 24:
				remove(boyfriend);
				boyfriend = new Boyfriend(970, 670, 'bf-pixel');
				add(boyfriend);
				iconP1.animation.play('bf-pixel');
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
				bgGirlsSFNAF.getSonic();
				add(fgStreetMario);
				add(glitchBG);
				remove(gf);
				gf = new Character(580, 430, 'amy-pixel-mario');
				add(gf);
				remove(dad);
				dad = new Character(250, 460, 'mario-angry');
				add(dad);
				iconP2.animation.play('mario-angry');
				case 41:
				remove(boyfriend);
				boyfriend = new Boyfriend(970, 670, 'bf-sonic-pixel');
				add(boyfriend);
				iconP1.animation.play('bf-sonic-pixel');	
				case 48:
				remove(fgStreetMario);
				remove(gf);
				remove(dad);
				remove(boyfriend);
				gf = new Character(580, 430, 'piper-pixel-mario');
				add(bgGirlsBSAA);
				bgGirlsBSAA.getBrawl();
				add(fgStreetMario);
				dad = new Character(250, 460, 'colt-angry');
				add(amyPixelBG);
				add(gf);
				add(dad);
				add(boyfriend);
				iconP2.animation.play('colt-angry');
				case 56:
				remove(boyfriend);
				boyfriend = new Boyfriend(970, 670, 'bf-rico-pixel');
				add(boyfriend);
				iconP1.animation.play('bf-rico-pixel');	
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
				add(bgGirlsEdd);
				add(glitchBG);
				add(gf);
				add(dad);
				add(boyfriend);
				iconP2.animation.play('matt-angry');
				case 72:
				remove(boyfriend);
				boyfriend = new Boyfriend(970, 670, 'bf-tom-pixel');
				add(boyfriend);
				iconP1.animation.play('bf-tom-pixel');	
				case 80:
				remove(dad);
				dad = new Character(250, 460, 'monster-pixel');
				add(dad);
				iconP2.animation.play('monster-pixel');
				case 88:
				remove(boyfriend);
				boyfriend = new Boyfriend(870, 370, 'spooky-pixel');
				add(boyfriend);
				iconP1.animation.play('spooky-pixel');	
				case 96:
				remove(dad);
				dad = new Character(250, 460, 'monika-angry');
				add(dad);
				iconP2.animation.play('monika-angry');
				case 104:
				monikaBG.x = 30;
				monikaBG.y = 130;
				remove(boyfriend);
				boyfriend = new Boyfriend(970, 470, 'miku-pixel');
				add(boyfriend);
				iconP1.animation.play('miku-pixel');	
				case 112:
				FlxG.sound.play(Paths.sound('glitch'));
				remove(monikaBG);
				remove(bgGirlsEdd);
				add (monikaStillBG);
				add(bgGirlsBSAA);
				bgGirlsBSAA.getObjection();
				remove(gf);
				remove(dad);
				remove(boyfriend);
				dad = new Character(250, 460, 'kristoph-angry');
				gf = new Character(580, 430, 'gf-edgeworth-pixel');
				boyfriend = new Boyfriend(970, 670, 'bf-wright-pixel');		
				add(gf);
				add(dad);
				add(boyfriend);
				iconP2.animation.play('kristoph-angry');		
				iconP1.animation.play('bf-wright-pixel');	
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
				remove (bgGirlsBSAA);
				add (bgGirlsUTMJ);
				add(glitchBG);
				remove(gf);
				gf = new Character(580, 430, 'gf-flowey');
				add(gf);
				remove(dad);
				dad = new Character(250, 460, 'chara-pixel');
				add(dad);
				iconP2.animation.play('chara-pixel');
				case 137:
				remove(gf);
				remove(boyfriend);
				boyfriend = new Boyfriend(970, 670, 'bf-sans-pixel');
				add(gf);
				add(boyfriend);
				iconP1.animation.play('bf-sans-pixel');	
				case 144:
				remove(dad);
				dad = new Character(240, 510, 'gura-amelia-pixel');
				add(dad);	
				iconP2.animation.play('gura-amelia-pixel');	
				case 152:
				remove(boyfriend);
				boyfriend = new Boyfriend(1010, 570, 'bf-botan-pixel');
				add(boyfriend);
				iconP1.animation.play('bf-botan-pixel');
				case 160:
				remove(bgSkyUT);
				remove(bgSchoolUT);
				remove(bgStreetUT);
				add(bgSkyBaldi);
				add(bgSchoolBaldi);
				add(bgStreetBaldi);
				remove(bgGirlsUTMJ);
				add(bgGirlsSFNAF);
				bgGirlsSFNAF.getFNAF();
				remove(gf);
				remove(dad);
				remove(boyfriend);
				dad = new Character(250, 460, 'baldi-angry');
				gf = new Character(580, 430, 'gf-playtime');
				add(glitchBG);
				add(gf);
				add(dad);	
				add(boyfriend);
				iconP2.animation.play('baldi-angry');	
				case 162:
				remove(boyfriend);
				boyfriend = new Boyfriend(970, 470, 'mangle-angry');
				add(boyfriend);
				iconP1.animation.play('mangle-angry');
				case 164:
				remove(bgSkyBaldi);
				remove(bgSchoolBaldi);
				remove(bgStreetBaldi);
				add(bgSkyNeon);
				add(bgStreetNeon);
				remove(bgGirlsSFNAF);
				add(bgGirlsSFNAF);
				add(bfPixelBG);
				remove(gf);
				remove(dad);
				remove(boyfriend);
				gf = new Character(580, 430, 'gf-pixel-neon');
				dad = new Character(250, 460, 'neon');
				add(glitchBG);
				add(gf);
				add(dad);	
				add(boyfriend);
				iconP2.animation.play('neon');	
				case 166:
				remove(boyfriend);
				remove(bfPixelBG);
				remove(gf);
				boyfriend = new Boyfriend(970, 510, 'bf-whitty-pixel');
				add (bgGirlsSFNAF);
				add(bfPixelBG);
				add(gf);
				add(boyfriend);	
				iconP1.animation.play('bf-whitty-pixel');			
				case 168:
				remove(bgGirlsSFNAF);
				remove(gf);	
				remove(dad);
				remove(boyfriend);
				remove(bfPixelBG);
				dad = new Character(250, 460, 'jackson');	
				boyfriend = new Boyfriend(970, 670, 'bf-pico-pixel');	
				add(bgGirlsSFNAF);	
				add (bgGirlsUTMJ);
				bgGirlsUTMJ.getJackson();
				add(bfPixelBG);
				add(gf);	
				add(dad);
				add(boyfriend);
				iconP2.animation.play('jackson');	
				iconP1.animation.play('bf-pico-pixel');
			}
		}

		if (curSong == 'Nerves') 
		{
			switch (curBeat)
			{
				case 24:
					remove(dad);
					dad = new Character(0, 400, 'bf-annie');
					add(dad);
					iconP2.animation.play('bf-annie');
				case 32:
					remove(gf);
					gf = new Character(400, 130, 'nogf');
					add(gf);	
					remove(boyfriend);
					boyfriend = new Boyfriend(870, 450, 'bf-gf');
					add(boyfriend);
					iconP1.animation.play('bf-gf');				
				case 52:
					remove(boyfriend);
					boyfriend = new Boyfriend(870, 100, 'bf-mom');
					add(boyfriend);
					iconP1.animation.play('bf-mom');
				case 61:
					remove(dad);
					dad = new Character(0, 140, 'tricky');
					add(dad);
					iconP2.animation.play('tricky');
				case 63:
					remove(dad);
					dad = new Character(0, 100, 'knuckles');
					add(dad);
					iconP2.animation.play('uganda-knuckles');
				case 64:
					iconP2.animation.play('knuckles');
				case 65:
					remove(boyfriend);
					boyfriend = new Boyfriend(870, 300, 'bf-spooky');
					add(boyfriend);
					iconP1.animation.play('bf-spooky');
					remove(dad);
					dad = new Character(0, 100, 'lila');
					add(dad);
					iconP2.animation.play('lila');
				case 67:
					remove(boyfriend);
					boyfriend = new Boyfriend(870, 250, 'tord');
					add(boyfriend);
					iconP1.animation.play('tord');
					remove(dad);
					dad = new Character(0, 250, 'tom');
					add(dad);
					iconP2.animation.play('tom');
				case 69:
					remove(boyfriend);
					boyfriend = new Boyfriend(910, 325, 'botan');
					add(boyfriend);
					iconP1.animation.play('botan');
					remove(dad);
					dad = new Character(0, 300, 'gura-amelia');
					add(dad);
					iconP2.animation.play('gura-amelia');
				case 71:
					remove(boyfriend);
					boyfriend = new Boyfriend(870, 25, 'bf-blantad');
					add(boyfriend);
					iconP1.animation.play('bf-blantad');
					remove(dad);
					dad = new Character(0, 100, 'tabi');
					add(dad);
					iconP2.animation.play('tabi');
				case 80:
					remove(boyfriend);
					boyfriend = new Boyfriend(870, 100, 'bf-exgf');
					add(boyfriend);
					iconP1.animation.play('bf-exgf');
				case 88:
					remove(dad);
					dad = new Character(0, 100, 'miku');
					add(dad);
					iconP2.animation.play('miku');
				case 96:
					remove(boyfriend);
					boyfriend = new Boyfriend(870, 100, 'hex');
					add(boyfriend);
					iconP1.animation.play('hex');
				case 120:
					remove(dad);
					dad = new Character(0, 100, 'whitty');
					add(dad);
					iconP2.animation.play('whitty');
				case 128:
					remove(boyfriend);
					boyfriend = new Boyfriend(870, 100, 'agoti');
					add(boyfriend);
					iconP1.animation.play('agoti');
				case 136:
					remove(dad);
					dad = new Character(0, 100, 'kapi');
					add(dad);
					iconP2.animation.play('kapi');
				case 152:
					remove(boyfriend);
					boyfriend = new Boyfriend(870, 400, 'liz');
					add(boyfriend);
					iconP1.animation.play('liz');
				case 160:
					remove(dad);
					dad = new Character(-20, 500, 'bf-sky');
					add(dad);
					iconP2.animation.play('bf-sky');
				case 168:
					remove(dad);
					dad = new Character(0, 100, 'hd-senpaiangry');
					add(dad);
					iconP2.animation.play('hd-senpaiangry');
				case 176:
					remove(dad);
					dad = new Character(0, 100, 'hd-senpai');
					add(dad);
					iconP2.animation.play('hd-senpai');
					remove(boyfriend);
					boyfriend = new Boyfriend(870, 300, 'tankman');
					add(boyfriend);
					iconP1.animation.play('tankman');
				case 183:
					iconP2.animation.play('hd-senpaidark');
				case 184:
					remove(dad);
					dad = new Character(0, 100, 'hd-spirit');
					add(dad);
					iconP2.animation.play('hd-spiritnotmad');
			}
		}

		if (curSong == 'Takeover') 
		{
			switch (curBeat)
			{
				case 64:
					dad.destroy();
					dad = new Character(0, 100, 'updike');
					add(dad);			
					healthBar.createFilledBar(0xFFE1E1E1, 0xFFB7D855);
					iconP2.animation.play('updike');
				case 80:
					boyfriend.destroy();
					boyfriend = new Boyfriend(770, 450, 'bf-whitty');
					add(boyfriend);
					healthBar.createFilledBar(0xFFE1E1E1, 0xFF1D1E35);
					iconP1.animation.play('bf-whitty');		
				case 96:
					dad.destroy();
					dad = new Character(0, 100, 'rebecca');
					add(dad);
					healthBar.createFilledBar(0xFF19618C, 0xFF1D1E35);
					iconP2.animation.play('rebecca');
				case 112:
					boyfriend.destroy();
					boyfriend = new Boyfriend(770, -25, 'bf-blantad');
					add(boyfriend);
					healthBar.createFilledBar(0xFF19618C, 0xFF64B3FE);
					iconP1.animation.play('bf-blantad');	
				case 148:
					boyfriend.destroy();
					boyfriend = new Boyfriend(970, 710, 'bf-senpai-pixel-angry');
					add(boyfriend);
					healthBar.createFilledBar(0xFFFFB8E3, 0xFFFFAA6F);
					iconP1.animation.play('bf-senpai-pixel-angry');
				case 164:
					monikaFinaleBG.alpha = 1;
					dad.destroy();
					dad = new Character(200, 700, 'lane-pixel');
					add(dad);
					healthBar.createFilledBar(0xFF1F7EFF, 0xFFFFAA6F);
					iconP2.animation.play('lane-pixel');
				case 180:
					boyfriend.destroy();
					boyfriend = new Boyfriend(970, 560, 'neon');
					add(boyfriend);
					healthBar.createFilledBar(0xFF1F7EFF, 0xFF06D22A);
					iconP1.animation.play('neon');
				case 196:
					Bobismad();
					remove(space);
					remove(monikaFinaleBG);
					remove(stageFront2);
					remove(bg2);
					bg.alpha = 1;
					isPixel = false;
					dad.destroy();
					boyfriend.destroy();
					dad = new Character(100, 375, 'bob');
					boyfriend = new Boyfriend(1085, 400, 'neon');
					add(gf);
					add(dad);	
					add(boyfriend);
					healthBar.createFilledBar(FlxColor.WHITE, 0xFF06D22A);
					iconP2.animation.play('bob');
				case 212:
					boyfriend.destroy();
					boyfriend = new Boyfriend(870, 200, 'opheebop');
					add(boyfriend);
					healthBar.createFilledBar(FlxColor.WHITE, FlxColor.BLACK);
					iconP1.animation.play('opheebop');
				case 228:
					dad.destroy();
					dad = new Character(100, 500, 'impostor');
					add(dad);
					healthBar.createFilledBar(0xFFFF3333, FlxColor.BLACK);
					iconP2.animation.play('impostor');
				case 244:
					boyfriend.destroy();
					boyfriend = new Boyfriend(1070, 400, 'henry-angry');
					add(boyfriend);
					healthBar.createFilledBar(0xFFFF3333, 0xFFE1E1E1);
					iconP1.animation.play('henry-angry');
				case 260:
					dad.destroy();
					dad = new Character(100, 100, 'coco');
					add(dad);
					healthBar.createFilledBar(0xFFE67A34, 0xFFE1E1E1);
					iconP2.animation.play('coco');
				case 264:
					boyfriend.destroy();
					boyfriend = new Boyfriend(870, 450, 'bf-aloe');
					add(boyfriend);
					healthBar.createFilledBar(0xFFE67A34, 0xFFEF71B1);
					iconP1.animation.play('bf-aloe');
				case 268:
					dad.destroy();
					dad = new Character(50, 330, 'neko-crazy');
					add(dad);
					healthBar.createFilledBar(0xFFFFD779, 0xFFEF71B1);
					iconP2.animation.play('neko-crazy');
				case 272:
					boyfriend.destroy();
					boyfriend = new Boyfriend(870, 450, 'bf-confused');
					add(boyfriend);
					healthBar.createFilledBar(0xFFFFD779, 0xFF51d8fb);
					iconP1.animation.play('bf-confused');

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

		if (curSong == 'Tutorial-Remix') 
		{
			switch (curBeat)
			{
				case 16:
					dad.destroy();
					dad = new Character(400, 130, 'gf1');
					add(dad);
					iconP2.animation.play('gf1');
				case 24:
					boyfriend.destroy();
					boyfriend = new Boyfriend(770, 450, 'bf1');
					add(boyfriend);
					iconP1.animation.play('bf1');
				case 32:
					dad.destroy();
					dad = new Character(400, 130, 'gf2');
					add(dad);
					iconP2.animation.play('gf2');
				case 40:
					boyfriend.destroy();
					boyfriend = new Boyfriend(770, 450, 'bf2');
					add(boyfriend);
					iconP1.animation.play('bf2');
				case 48:
					dad.destroy();
					dad = new Character(400, 130, 'gf3');
					add(dad);
					iconP2.animation.play('gf3');
				case 56:
					boyfriend.destroy();
					boyfriend = new Boyfriend(770, 450, 'bf3');
					add(boyfriend);
					iconP1.animation.play('bf3');
				case 64:
					dad.destroy();
					dad = new Character(400, 130, 'gf4');
					add(dad);
					iconP2.animation.play('gf4');
				case 72:
					boyfriend.destroy();
					boyfriend = new Boyfriend(770, 450, 'bf4');
					add(boyfriend);
					iconP1.animation.play('bf4');
				case 80:
					dad.destroy();
					dad = new Character(400, 130, 'gf5');
					add(dad);
					iconP2.animation.play('gf5');
				case 84:
					boyfriend.destroy();
					boyfriend = new Boyfriend(770, 450, 'bf5');
					add(boyfriend);
					iconP1.animation.play('bf5');
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
					remove(dad);
					remove(scope);
					remove(gf);
					dad = new Character(100, 450, 'bf-carol');
					add(iconBG);
					add(scope);
					add(gf);
					add(dad);
					iconP2.animation.play('bf-carol');
				case 32:
					remove(boyfriend);
					boyfriend = new Boyfriend(770, 450, 'bf-whitty');
					iconBG = new HealthIcon('bf', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 300;
					iconBG.y = 0;
					iconBG.angle = 10;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(boyfriend);
					iconP1.animation.play('bf-whitty');
				case 48:
					remove(dad);
					remove(scope);
					remove(gf);
					dad = new Character(100, 100, 'hex');
					iconBG = new HealthIcon('bf-carol', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 310;
					iconBG.y = 150;
					iconBG.angle = -5;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(scope);
					add(gf);
					add(dad);
					iconP2.animation.play('hex');
				case 56:
					remove(gf);
					remove(boyfriend);
					gf = new Character(400, 130, 'nogf');
					boyfriend = new Boyfriend(790, 450, 'bf-gf');
					iconBG = new HealthIcon('bf-whitty', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 70;
					iconBG.y = 260;
					iconBG.angle = -10;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(gf);
					add(boyfriend);
					iconP1.animation.play('bf-gf');
				case 64:
					remove(dad);
					remove(scope);
					remove(gf);
					dad = new Character(100, 450, 'bf-lexi');
					iconBG = new HealthIcon('hex', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 120;
					iconBG.y = 70;
					iconBG.angle = 5;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(scope);
					add(gf);
					add(dad);
					iconP2.animation.play('bf-lexi');
				case 88:
					remove(gf);
					gf = new Character(400, 130, 'madgf');
					add(gf);
					remove(boyfriend);
					boyfriend = new Boyfriend(780, 520, 'bf-sky');
					add(boyfriend);
					iconP1.animation.play('bf-sky');
				case 104:
					remove(dad);
					remove(gf);
					remove(boyfriend);
					dad = new Character(100, 0, 'bf-blantad');
					gf = new Character(400, 130, 'gf-tabi');
					iconBG = new HealthIcon('bf-lexi', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 150;
					iconBG.y = -75;
					iconBG.angle = 0;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(gf);
					add(dad);
					add(boyfriend);
					iconP2.animation.play('bf-blantad');
				case 120:
					remove(gf);
					remove(boyfriend);
					gf = new Character(400, 130, 'gf');
					boyfriend = new Boyfriend(770, -10, 'henry');
					iconBG = new HealthIcon('bf-sky', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 200;
					iconBG.y = 120;
					iconBG.angle = -2;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(gf);
					add(boyfriend);
					iconP1.animation.play('henry');
				case 136:
					boyfriend.setZoom(1);
					remove(dad);
					remove(scope);
					remove(gf);
					remove(boyfriend);
					dad = new Character(100, 100, 'shaggy');
					boyfriend = new Boyfriend(800, 450, 'matt');
					iconBG = new HealthIcon('bf-blantad', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 0;
					iconBG.y = 160;
					iconBG.angle = 4;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					iconBG = new HealthIcon('henry', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 220;
					iconBG.y = -60;
					iconBG.angle = 2;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(scope);
					add(gf);
					add(dad);		
					add(boyfriend);
					iconP1.animation.play('matt');
					iconP2.animation.play('shaggy');
				case 152:
					remove(dad);
					remove(scope);
					remove(gf);
					remove(boyfriend);
					dad = new Character(100, 100, 'hd-senpai');
					boyfriend = new Boyfriend(770, 300, 'tankman'); 
					iconBG = new HealthIcon('matt', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 300;
					iconBG.y = 75;
					iconBG.angle = 4;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					iconBG = new HealthIcon('shaggy', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 330;
					iconBG.y = 260;
					iconBG.angle = 4;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(scope);
					add(gf);
					add(dad);			
					add(boyfriend);
					iconP2.animation.play('hd-senpai');
					iconP1.animation.play('tankman');
				case 168:
					remove(dad);
					remove(scope);
					remove(gf);
					remove(boyfriend);
					dad = new Character(0, 425, 'bf-annie');
					iconBG = new HealthIcon('tankman', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 0;
					iconBG.y = -100;
					iconBG.angle = 2;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					iconBG = new HealthIcon('hd-senpai', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 0;
					iconBG.y = 300;
					iconBG.angle = 1;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(scope);
					add(gf);
					add(boyfriend);
					add(dad);			
					iconP2.animation.play('bf-annie');
				case 178:
					remove(dad);
					remove(scope);
					remove(gf);
					remove(boyfriend);
					dad = new Character(0, 375, 'botan');
					iconBG = new HealthIcon('bf-annie', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 330;
					iconBG.y = 360;
					iconBG.angle = 5;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(scope);
					add(gf);
					add(boyfriend);
					add(dad);			
					iconP2.animation.play('botan');
				case 184:
					remove(dad);
					remove(scope);
					remove(gf);
					remove(boyfriend);
					boyfriend = new Boyfriend(800, 450, 'playable-garcello'); 
					iconBG = new HealthIcon('tankman', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 120;
					iconBG.y = 320;
					iconBG.angle = 4;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(scope);
					add(gf);
					add(dad);			
					add(boyfriend);
					iconP1.animation.play('garcello');
				case 194:
					remove(dad);
					remove(scope);
					remove(gf);
					remove(boyfriend);
					boyfriend = new Boyfriend(800, 450, 'bf-aloe'); 
					iconBG = new HealthIcon('garcello', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 220;
					iconBG.y = 25;
					iconBG.angle = -4;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(scope);
					add(gf);
					add(dad);			
					add(boyfriend);
					iconP1.animation.play('bf-aloe');
				case 200:
					remove(dad);
					remove(scope);
					remove(gf);
					remove(boyfriend);
					dad = new Character(50, 100, 'miku');
					iconBG = new HealthIcon('botan', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 330;
					iconBG.y = -75;
					iconBG.angle = 6;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(scope);
					add(gf);
					add(boyfriend);
					add(dad);			
					iconP2.animation.play('miku');
				case 216:
					remove(dad);
					remove(scope);
					remove(gf);
					remove(boyfriend);
					boyfriend = new Boyfriend(950, 400, 'monika'); 
					iconBG = new HealthIcon('bf-aloe', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 0;
					iconBG.y = 230;
					iconBG.angle = 2;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(scope);
					add(gf);
					add(dad);			
					add(boyfriend);
					iconP1.animation.play('monika');
				case 232:
					remove(dad);
					remove(scope);
					remove(gf);
					remove(boyfriend);
					dad = new Character(50, 100, 'sarvente');
					iconBG = new HealthIcon('miku', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 400;
					iconBG.y = 0;
					iconBG.angle = -6;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(scope);
					add(gf);
					add(boyfriend);
					add(dad);			
					iconP2.animation.play('sarvente');
				case 248:
					remove(dad);
					remove(scope);
					remove(gf);
					remove(boyfriend);
					boyfriend = new Boyfriend(800, 100, 'ruv'); 
					iconBG = new HealthIcon('monika', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 60;
					iconBG.y = 330;
					iconBG.angle = 2;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(scope);
					add(gf);
					add(dad);			
					add(boyfriend);
					iconP1.animation.play('ruv');
				case 264:
					remove(dad);
					remove(scope);
					remove(gf);
					remove(boyfriend);
					dad = new Character(0, 100, 'exgf');
					boyfriend = new Boyfriend(800, 100, 'tabi'); 
					iconBG = new HealthIcon('sarvente', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 100;
					iconBG.y = 0;
					iconBG.angle = 2;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					iconBG = new HealthIcon('ruv', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 370;
					iconBG.y = 100;
					iconBG.angle = 1;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(scope);
					add(gf);
					add(boyfriend);
					add(dad);			
					iconP2.animation.play('exgf');
					iconP1.animation.play('tabi');
				case 280:
					remove(dad);
					remove(scope);
					remove(gf);
					remove(boyfriend);
					dad = new Character(0, 150, 'bf-mom');
					gf = new Character(400, 130, 'gf-kaity');
					boyfriend = new Boyfriend(800, -25, 'bf-dad'); 
					iconBG = new HealthIcon('exgf', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 420;
					iconBG.y = -75;
					iconBG.angle = 2;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					iconBG = new HealthIcon('tabi', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 80;
					iconBG.y = -75;
					iconBG.angle = 1;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					iconBG = new HealthIcon('gf', false);
					iconBG.setGraphicSize(Std.int(iconBG.width * 0.3));
					iconBG.updateHitbox();
					iconBG.x = 255;
					iconBG.y = 150;
					iconBG.angle = 1;
					iconBG.scrollFactor.set(0.9, 0.9);
					add(iconBG);
					add(scope);
					add(gf);
					add(boyfriend);
					add(dad);			
					iconP2.animation.play('bf-mom');
					iconP1.animation.play('bf-dad');
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
				switch (curSong)
				{
					case 'Context':
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
			if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
	
			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
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
				default:
					boyfriend.dance();
			}		
		}

		if (!dad.animation.curAnim.name.startsWith("sing") && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				switch (curSong)
				{
					case 'Fading-Senpai':
						if (!dad.animation.curAnim.name.contains('disappear'))
						{
							dad.dance();
						}
					case 'Expurgation':
						if (!dad.animation.curAnim.name.contains('Hank'))
						{
							dad.dance();
						}
					case 'Gura-Nazel' | 'Norway' | 'Ugh':
						'';

					case 'Context':
						if (!dad.animation.curAnim.name.contains('special'))
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
			gf.dance();

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

		if (boyfriend.curCharacter.contains('tankman') && !boyfriend.curCharacter.contains('pixel'))
		{
			var bwShit:String = "";

			if (boyfriend.curCharacter == 'tankman-bw')
			{
				bwShit = '-bw';
			}

			if (dad.curCharacter.contains('senpai') && !dad.curCharacter.contains('angry') && !dad.curCharacter.contains('ghosty'))
			{
				iconP1.animation.play('tankman-happy' + bwShit);
			}
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
				tomBG.animation.play('idle');
				bfBG.animation.play('idle');
				mattBG.animation.play('idle');
				tordBG.animation.play('idle');
				gfBG.dance();

			case 'manifest':
				gfCrazyBG.animation.play('idle');

			case 'emptystage':
				monikaFinaleBG.animation.play('idle');

			case 'philly-wire':
				melandperi.dance();
				melandperiwire.dance();
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

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}

			case 'tank':
                tankWatchtower.dance();
				tank0.animation.play('idle', true);
				tank1.animation.play('idle', true);
				tank2.animation.play('idle', true);
				tank4.animation.play('idle', true);
				tank5.animation.play('idle', true);
				tank3.animation.play('idle', true);

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

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
			case "philly":
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
				
			case "phillyannie":
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

		if ((dad.curCharacter == 'ruv' && dad.animation.curAnim.name.startsWith('sing') || boyfriend.curCharacter == 'ruv' && boyfriend.animation.curAnim.name.startsWith('sing'))  && curBeat > ruvShakeBeat)
		{
			ruvShake();
		}
	}

	var curLight:Int = 0;

	function changeToPixelCorrupted()
	{
		remove(strumLineNotes);
		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		strumLineNotes.cameras = [camHUD];
			
		generateStaticArrows(0, "normal", false);
		generateStaticArrows(1, "normal", false);
	}
	
	function changeToPixel()
	{
		remove(strumLineNotes);
		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		strumLineNotes.cameras = [camHUD];
			
		generateStaticArrows(0, "pixel",false);
		generateStaticArrows(1, "pixel",false);
	}
}