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
import openfl.filters.BitmapFilter;

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

	//Filter array for bitmap bullshit ya for shaders
	var filters:Array<BitmapFilter> = [];
	var camfilters:Array<BitmapFilter> = [];
	var shadersLoaded:Bool = false;
	public var chromOn:Bool = false;
	var ch = 2 / 1000;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var camFollowIsOn:Bool = true;
	public static var lockedCamera:Bool = false;
	public static var defaultCamFollow:Bool = true;
	public static var isBETADCIU:Bool = false;
	public static var isNeonight:Bool = false;
	public static var isVitor:Bool = false;
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
	var usedTimeTravel:Bool = false;
	var trailShit:Bool = false;

	var shootStepsBallistic:Array<Int> = [284, 368, 384, 422, 430, 454, 462, 542, 656, 686, 750, 846, 878, 894, 910, 926, 976, 977, 1024, 1025, 1056, 1120, 1198, 1230, 1262, 1294, 1574, 1606, 1696, 1712, 1760, 1776, 1832, 1848, 1906, 1952, 2018, 2036, 2078];
	var bfTransformSteps:Array<Int> = [368, 369, 371, 372, 374, 375, 378, 379, 382, 383, 624, 625, 628, 629, 632, 633, 636, 637, 752, 753, 756, 757, 760, 761, 764, 765, 1008, 1009, 1012, 1013, 1016, 1017, 1020, 1021, 1024];

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	public var minusHealth:Bool = false;
	public var tabiZoom:Bool = false;
	public static var mania:Int = 0;
	public static var keyAmmo:Array<Int> = [4, 6, 9, 5];

	public var tordCam:Array<FlxPoint> = [new FlxPoint(391.2,-1094.15),new FlxPoint(290.9,-1094.15),new FlxPoint(450.9,-1094.15),new FlxPoint(374.9,-1174.15),new FlxPoint(570.9,-974.15)];

	public var cjCloneLinesSing:Array<String> = ["SUFFER","INCORRECT", "INCOMPLETE", "INSUFFICIENT", "INVALID", "CORRECTION", "MISTAKE", "REDUCE", "ERROR", "FAULTY", "IMPROBABLE", "IMPLAUSIBLE", "MISJUDGED", "ABUSE"];
	public var exTrickyLinesSing:Array<String> = ["SUFFER","INCORRECT", "INCOMPLETE", "INSUFFICIENT", "INVALID", "CORRECTION", "MISTAKE", "REDUCE", "ERROR", "ADJUSTING", "IMPROBABLE", "IMPLAUSIBLE", "MISJUDGED"];
	public var auditorLinesSing:Array<String> = ["SUFFER","INCORRECT", "INCOMPLETE", "INSUFFICIENT", "INVALID", "CORRECTION", "MISTAKE", "REDUCE", "ERROR", "ADJUSTING", "IMPROBABLE", "IMPLAUSIBLE", "MISJUDGED"];
	public var trickyLinesSing:Array<String> = ["SUFFER","INCORRECT", "INCOMPLETE", "INSUFFICIENT", "INVALID", "CORRECTION", "MISTAKE", "REDUCE", "ERROR", "ADJUSTING", "IMPROBABLE", "IMPLAUSIBLE", "MISJUDGED"];

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	var lolText:FlxText;

	public static var picoCutscene:Bool = false;
	public static var regenerateDadArrows:Bool = false;

	//tankman shit
	var tankRolling:FlxSprite;
	var tankX:Int = 400;
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankAngle:Float = FlxG.random.float(-90, 45);
	var tank0:FlxSprite;
	var tank1:FlxSprite;
	var tank2:FlxSprite;
	var tank3:FlxSprite;
	var tank4:FlxSprite;
	var tank5:FlxSprite;
	var tankWatchtower:FlxSprite;

	//sunday shit
	var aaa:FlxSprite;
	var glowShit:FlxSprite = new FlxSprite(-255.15,186.55);
	var garage:FlxSprite;
	var speakers:FlxSprite;
	public var carolEnter:FlxSprite;
	public var fret:FlxSprite;
	public var ending:FlxSprite;

	//cam moving shenanigans
	var bfCamX:Int = 0;
	var bfCamY:Int = 0;
	var dadCamX:Int = 0;
	var dadCamY:Int = 0;

	//sus
	var flashSprite:FlxSprite = new FlxSprite(-100, -100).makeGraphic(Std.int(FlxG.width *2), Std.int(FlxG.height*2), 0xFFb30000);
	var _cb = 0;
	var _b = 0;

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

	//multiple characters
	public static var dad1:Character;
	public static var dad2:Character;
	public static var dad3:Character;
	public static var boyfriend1:Boyfriend;
	public static var boyfriend2:Boyfriend;
	public static var boyfriend3:Boyfriend;
	public static var daMisser:Boyfriend;
	public var triple:Bool = false;
	public var duoDad:Bool = false;
	public var duoBoyfriend:Bool = false;
	var both:Bool = false;
	var quad:Bool = false;

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

	var healthSet:Bool;

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	var tstatic:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('tricky/TrickyStatic', 'shared'), true, 320, 180);
	var rushiaScreamOverlay:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('holofunk/russia/scream_overlay', 'shared'), true, 1280, 720);
	var zipperScreamOverlay:FlxSprite;
	var periScreamOverlay:FlxSprite;
	var rushiaOverlayFrame:Int = 0;
	static var rushiaOverlayFrameMax:Int = 27;

	var tStaticSound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("staticSound","preload"));

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	public static var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;
	
	public static var playerSplashes:FlxTypedGroup<FlxSprite> = null;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	public static var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;//
	public var health:Float = 1; //making public because sethealth doesnt work without it
	public var maxHealth:Float = 2; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	private var healthBarBG:FlxSprite;
	public static var healthBar:FlxBar; //pls don't die
	private var songPositionBar:Float = 0;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var iconBG:HealthIcon;
	public var camHUD:FlxCamera;
	public var camOther:FlxCamera;
	public var camGame:FlxCamera;
	public static var newIcons:Bool = false;
	public static var swapIcons:Bool = true;
	public static var playDad:Bool = true;
	public static var playBF:Bool = true;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];
	public var extra2:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];
	public var extra3:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	//YO MAMA
	public var yoMamaBG:FlxSprite;
	public var brody:FlxSprite;

	public var eyes:FlxSprite;
	public var eyes2:FlxSprite;

	// all the damn sprites
	var normbg:FlxSprite;
	var oldspace:FlxSprite;
	var space:FlxBackdrop;
	var whiteflash:FlxSprite;
	var blackScreen:FlxSprite;
	var justMonika:FlxSprite;
	var monikaBG:FlxSprite;
	var monikaStillBG:FlxSprite;
	var glitchBG:FlxSprite;
	var scope:FlxSprite;
	var stageFront:FlxSprite;
	var stageFront2:FlxSprite;
	var bg2:FlxSprite;
	var bg:FlxSprite;
	var babyArrow:FlxSprite;
	var daSign:FlxSprite;
	var wBg:FlxSprite;
	var nwBg:FlxSprite;
	var wstageFront:FlxSprite;

	var daSection:Int = 0;

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
	public static var daJumpscare:FlxSprite = new FlxSprite(0, 0);

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

	//i should seriously update the way i do the roses remix switching
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
	var tordBG:FlxSprite;
	var bfPixelBG:FlxSprite;
	var gfCrazyBG:FlxSprite;
	var mattBG:FlxSprite;
	var tomBG:FlxSprite;
	var bfBG:FlxSprite;
	var monikaFinaleBG:FlxSprite;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyCityLightswire:FlxTypedGroup<FlxSprite>;

	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var limoOhNo:FlxSprite;
	public var grpLimoDancersHolo:FlxTypedGroup<BackgroundDancerHolo>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var momDadBG:FlxSprite;
	var softBFBG:FlxSprite;
	public var tabiTrail:FlxTrail;
	var altAnim:String = "";
	var bfAltAnim:String = "";

	var fc:Bool = true;
	var comboSpr:FlxSprite;

	var rock:FlxSprite;
	var dadrock:FlxSprite;
	var gf_rock:FlxSprite;
	var burst:FlxSprite;

	public static var isTakeover:Bool = false;
	public static var isLullaby:Bool = false;

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
	public var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;
	private var floatshit:Float = 0;

	var kCool:Bool = false;
	var ringCounter:FlxSprite;
	var counterNum:FlxText;
	var cNum:Int = 0;

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

	public var executeModchart = false;
	private var bopeeboRumble = false;

	//note shit
	public static var alt:String;
	public static var alt2:String;

	private var shakeCam2:Bool = false;
	var shootArray:Array<Int> = [];
	var staticArray:Array<Int> = [];
	var bgspec:FlxSprite;

	// control arrays, order L D U R dumbass
	var holdArray:Array<Bool> = [];
	var pressArray:Array<Bool> = [];	
	var releaseArray:Array<Bool> = [];

	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }
	public function destroyObject(object:FlxBasic) { object.destroy(); }
	public function writeStuff(timer:Int, word:String) { startWriting(timer, word); }

	var pixelNotes:Array<String> = ['pixel', 'neon', 'pixel-corrupted', 'pixel-combined', 'guitar']; //guitar notes also have zero offsets
	var pixelSwap:Bool = false;
	var usesStageHx:Bool = false;
	public static var defaultBar:Bool = true;

	//neonight stuff
	public static var changeArrowSongs:Array<String> = ['split-ex', 'crucify'];
	public static var changeArrows:Bool = false;
	public static var Stage:Stage;
	public static var PreloadStage:PreloadStage;
	public static var splashSkin:String = '';
	public static var bfNoteStyle:String = 'normal';
	public static var dadNoteStyle:String = 'normal';
	var cover:FlxSprite;
	var cover2:FlxSprite;
	var hole:FlxSprite;
	var converHole:FlxSprite;
	var rope:FlxSprite;
	public var bfTrail:DeltaTrail;
	public var dadTrail:DeltaTrail;
	public var bf1Trail:DeltaTrail;
	public var dad1Trail:DeltaTrail;
	public static var isSpres:Bool = false;
	var isMania = false;

	//exe
	var blackFuck:FlxSprite;
	var startCircle:FlxSprite;
	var startText:FlxSprite;
	var xOff:Array<Int> = [-15, 0, 0, 15];
	var yOff:Array<Int> = [0, 15, -15, 0];
	var xOff2:Array<Int> = [-15, 0, 0, 0, 15];
	var yOff2:Array<Int> = [0, 15, 0, -15, 0];
	var dontHitNotes:Array<Int> = [2, 4, 6, 8, 9, 10];
	var daP3Static:FlxSprite = new FlxSprite(0, 0);
	var daNoteStatic:FlxSprite = new FlxSprite(0, 0);

	//hypno shit
	var trance:Float = 0;
	public var canHitPendulum:Bool = false;
	public var hitPendulum:Bool = false;
	var pendulum:Pendulum;
	var pendulumShadow:FlxTypedGroup<FlxSprite>;
	var pendulumDrain:Bool = true;
	var skippedFirstPendulum:Bool = false;
	var psyshockCooldown:Int = 80;
	var psyshocking:Bool = false;

	public static var pixelStrumsBF:Bool = false;
	public static var pixelStrumsDad:Bool = false;

	override public function create()
	{
		ModCharts.autoStrum = true;
		ModCharts.dadNotesVisible = true;
		ModCharts.bfNotesVisible = true;

		minusHealth = false;
		picoCutscene = false;
		isPixel = false;
		healthSet = false;
		usesStageHx = false;
		defaultBar = true;
		triple = false;
		duoDad = false;
		duoBoyfriend = false;
		splashSkin = '';
		changeArrows = false;
		newIcons = false;
		swapIcons = false;
		maxHealth = 2;
		pixelStrumsBF = false;
		pixelStrumsDad = false;

		mania = SONG.mania;
		isMania = (SONG.mania > 0);

		isTakeover = (SONG.song.toLowerCase() == 'takeover');
		isLullaby = (SONG.song.toLowerCase() == 'safety-lullaby');

		if (changeArrowSongs.contains(SONG.song.toLowerCase()) && isNeonight)
			changeArrows = true;

		if (SONG.song.toLowerCase() == 'endless' || SONG.song.toLowerCase() == 'triple-trouble')
		{
			blackFuck = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);

			startCircle = new FlxSprite();
			startText = new FlxSprite();

			if (SONG.song.toLowerCase() == 'triple-trouble')
			{
				daP3Static.frames = Paths.getSparrowAtlas('exe/Phase3Static');
				daP3Static.animation.addByPrefix('P3Static', 'Phase3Static instance 1', 24, false);
				add(daP3Static);
				daP3Static.animation.play('P3Static');
				remove(daP3Static);

				daNoteStatic.frames = Paths.getSparrowAtlas('exe/hitStatic');
				daNoteStatic.animation.addByPrefix('static', 'staticANIMATION', 24, false);
				daNoteStatic.animation.play('static');

				remove(daNoteStatic);
			}
		}
		
		var suf:String = "";
		if (isNeonight)
		{
			if (!FlxG.save.data.stageChange)
				suf = '-neo-noStage';				
			else
				suf = '-neo';				
		}
		if (isVitor)
			suf = '-vitor';		
		
		if (isBETADCIU && storyDifficulty == 5)
		{
			switch (SONG.song.toLowerCase())
			{
				case "rabbit's-luck": 
					isSpres = true;
				default:
					isSpres = false;
			}

			if (isSpres)
			{
				trace('on the spres level');

				if (!FlxG.save.data.stageChange)
					suf = '-guest-noStage';				
				else
				{
					changeArrows = true;
					suf = '-guest';
				}
			}
			else
			{
				trace ('everyone else');
				changeArrows = false;
				suf = '-guest';	
			}	
		}

		if (isBETADCIU && FileSystem.exists(Paths.lua(SONG.song.toLowerCase()  + "/modchart-betadciu")))
			suf = '-betadciu';
			
		switch (SONG.song.toLowerCase())
		{
			case 'spectral-spat': 
				duoDad = true;
			case 'expurgation': 
				if (isVitor)
					triple = true;
			case 'epiphany':
				if (storyDifficulty == 5)
					duoDad = true;
			case 'haachama-ex' | 'shinkyoku':
				duoDad = true;
				duoBoyfriend = true;
			case 'ghost-vip':
				if (storyDifficulty == 5)
					changeArrows = true;
			case 'kaboom':
				if (suf == '-betadciu')
					SONG.player2 = 'demoman';
			case 'hill-of-the-void':
				changeArrows = true;
				if (!FlxG.save.data.stageChange)
					suf = '-noStage';		
		}

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
			case 'scary-swings': songLowercase = 'scary swings';
			case 'my-sweets': songLowercase = 'my sweets';
		}
		
		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase  + "/modchart" + suf));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart" + suf));

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
			case 3:
				storyDifficultyText = "Neonight Ver.";
			case 4:
				storyDifficultyText = "Vitor0502 Ver.";
		}

		iconRPC = SONG.player2;

		if (SONG.song.toLowerCase() == 'crucify' && isNeonight && !FlxG.save.data.stageChange)
		{
			SONG.noteStyle = 'darker';
		}

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
			detailsText = "Story Mode: Week " + storyWeek;
		if (isBETADCIU || isNeonight || isVitor)
			detailsText = SONG.song + " But Every Turn A Different Cover is Used";
		else
			detailsText = "Freeplay";

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOther = new FlxCamera();
		camOther.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camOther);

		FlxCamera.defaultCameras = [camGame];

		if(FlxG.save.data.distractions && SONG.stage == 'garage'){
			camGame.setFilters(filters);
			camGame.filtersEnabled = true;
			camHUD.setFilters(camfilters);
			camHUD.filtersEnabled = true;
		}

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial', 'tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		cjCloneLinesSing = CoolUtil.coolTextFile(Paths.txt('cjCloneSingStrings'));
		exTrickyLinesSing = CoolUtil.coolTextFile(Paths.txt('trickyExSingStrings'));
		auditorLinesSing = CoolUtil.coolTextFile(Paths.txt('auditorSingStrings'));
		trickyLinesSing = CoolUtil.coolTextFile(Paths.txt('trickySingStrings'));

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

			case 'eddhouse' | 'eddhouse-bot':
			{
				defaultCamZoom = 1.05;
				curStage = 'eddhouse';
				var sky:FlxSprite = new FlxSprite( -162.1, -386.1);
				sky.frames = Paths.getSparrowAtlas("tord/sky");
				sky.animation.addByPrefix("bg_sky1", "bg_sky1");
				sky.animation.addByPrefix("bg_sky2", "bg_sky2");
				if(SONG.song.toLowerCase() == 'tordbot' || SONG.stage == 'eddhouse-bot'){
					sky.animation.play("bg_sky2");
				}else{
					sky.animation.play("bg_sky1");
				}
							
				bg = new FlxSprite( -162.1, -386.1);
				bg.frames = Paths.getSparrowAtlas("tord/bgFront");
				bg.animation.addByPrefix("bg_normal", "bg_normal");
				bg.animation.addByPrefix("bg_destroy", "bg_destroy");
				if(SONG.song.toLowerCase() == 'tordbot' || SONG.stage == 'eddhouse-bot'){
					bg.animation.play("bg_destroy");
				}else{
				bg.animation.play("bg_normal");
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

				if(SONG.song.toLowerCase() == 'norsky')
				{
					bfBG = new FlxSprite(-200, 250);
					bfBG.frames = Paths.getSparrowAtlas('characters/BOYFRIEND_TABI');
					bfBG.animation.addByPrefix('idle', "BF idle dance", 24, false);
					bfBG.scrollFactor.set(0.9, 0.9);
					bfBG.antialiasing = true;
					bfBG.setGraphicSize(Std.int(bfBG.width * 0.8));
					bfBG.flipX = true;

					tordBG = new FlxSprite(25, 100);
					tordBG.frames = Paths.getSparrowAtlas('tord/tord_assets');
					tordBG.animation.addByPrefix('idle', 'tord idle', 24, false);
					tordBG.antialiasing = true;
					tordBG.scrollFactor.set(0.9, 0.9);
					tordBG.setGraphicSize(Std.int(tordBG.width * 0.7));
					tordBG.updateHitbox();
				}
				
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				if (SONG.stage != 'eddhouse-bot'){sky.scrollFactor.set(0.5, 0);}
				else {sky.scrollFactor.set();}
				bg.active = false;
				sky.active = false;
				//bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				sky.updateHitbox();
				add(sky);
				add(bg);
				if(SONG.song.toLowerCase() == 'norway' || SONG.song.toLowerCase() == 'norsky')
				{
					add(tordBG);
					add(bfBG);
					if (SONG.song.toLowerCase() != 'norsky')
					{
						add(gfBG);
						add(mattBG);
					}				
				}			
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

				cover = new FlxSprite(-180,755).loadGraphic(Paths.image('tricky/fourth/cover'));
				cover2 = new FlxSprite(-180,755).loadGraphic(Paths.image('tricky/fourth/covercrackless'));
				hole = new FlxSprite(50,530).loadGraphic(Paths.image('tricky/fourth/Spawnhole_Ground_BACK'));
				converHole = new FlxSprite(7,578).loadGraphic(Paths.image('tricky/fourth/Spawnhole_Ground_COVER'));

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

				cover2.antialiasing = true;
			//	cover2.scrollFactor.set(0.9, 0.9);
				cover2.setGraphicSize(Std.int(cover.width * 1.55));
						
				var energyWall:FlxSprite = new FlxSprite(1350,-690).loadGraphic(Paths.image("tricky/fourth/Energywall"));
				energyWall.antialiasing = true;
				energyWall.scrollFactor.set(0.9, 0.9);
				add(energyWall);
				
				var stageFront:FlxSprite = new FlxSprite(-350, -355).loadGraphic(Paths.image('tricky/fourth/daBackground'));
				stageFront.antialiasing = true;
			//	stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.55));
				add(stageFront);

				daSign = new FlxSprite(0,0);

				daSign.frames = Paths.getSparrowAtlas('tricky/fourth/mech/Sign_Post_Mechanic');

				daSign.setGraphicSize(Std.int(daSign.width * 0.67));
				add(daSign);
				remove(daSign);
				add(cover2);
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
			default:
			{
				Stage = new Stage(SONG.stage);
				defaultCamZoom = Stage.camZoom;
				curStage = Stage.curStage;
				usesStageHx = true;

				for (i in Stage.toAdd)
				{
					add(i);
				}
			}
		}

		#if debug
		if (isLullaby)
		{
			lolText = new FlxText(0, 0, FlxG.width - 100, "0", 48);
			lolText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
			lolText.cameras = [camOther];
			add(lolText);
		}
		#end

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

		if (FileSystem.exists(Paths.txt(songLowercase  + "/preload" + suf)))
		{
			var characters:Array<String> = CoolUtil.coolTextFile2(Paths.txt(songLowercase  + "/preload" + suf));

			for (i in 0...characters.length)
			{
				var data:Array<String> = characters[i].split(' ');
				dad = new Character (0, 0, data[0]);
				trace ('found ' + data[0]);
			}
		}

		if (FileSystem.exists(Paths.txt(songLowercase  + "/arrowSwitches" + suf)) && !isNeonight && !(isBETADCIU && storyDifficulty == 5))
			changeArrows = true;

		if (FileSystem.exists(Paths.txt(songLowercase  + "/preload-stage"+suf)))
		{
			var characters:Array<String> = CoolUtil.coolTextFile2(Paths.txt(songLowercase  + "/preload-stage"+suf));

			for (i in 0...characters.length)
			{
				var data:Array<String> = characters[i].split(' ');
				PreloadStage = new PreloadStage (data[0]);
				trace ('stages are ' + data[0]);
			}

			curStage = SONG.stage;
		}

		//why do i even use this?
		if (FileSystem.exists(Paths.txt(songLowercase  + "/exeStaticSteps")))
		{
			var shootSteps:Array<String> = CoolUtil.coolTextFile2(Paths.txt(songLowercase  + "/exeStaticSteps"));	

			for (i in 0...shootSteps.length)
			{
				var data:Array<String> = shootSteps[i].split(' ');
				staticArray.push(Std.parseInt(data[0]));
				trace ('steps are ' + data[0]);
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
			case 'gf-tankmen' | 'gf-tea-tankmen':
				gf.x -= 190;
			case 'gf-sarv':
				gf.x -= 150;
				gf.y -= 150;
			case 'gf-bf-radio':
				gf.x -= 20;
			case 'gf-edd': 
				if (!curStage.contains('school'))
				{
					gf.x += 100;
					gf.y += 300;	
				}
			case 'gf-judgev2':
				gf.x += 50;
				gf.y += 80;
		}

		dad = new Character(100, 100, SONG.player2);
		trace('found dad character');

		if (duoDad)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'epiphany':
					if (storyDifficulty == 5) 
						dad1 = new Character(16, -140, 'bigmonika');
				case 'haachama-ex':
					dad1 = new Character(16, -140, 'amor-ex');
				default:
					dad1 = new Character(-100, 100, 'garcellodead');
			}				
		}
			

		if (triple)
		{
			dad1 = new Character(100, 100, 'dad');
			dad2 = new Character(100, 100, 'mom');
			trace('yay triples');
		}

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
			case 'tordbot':
				dad.x += 330;
				dad.y -= 1524.75;
				camPos.set(391.2, -1094.15);
			default:
				if (dad.isCustom)
				{
					dad.x += dad.positionArray[0];
					dad.y += dad.positionArray[1];
				}	
				else
				{
					//this should save me like 200 lines or smthn
					var offset = new CharacterOffsets(SONG.player2, false);
					dad.x += offset.daOffsetArray[0];
					dad.y += offset.daOffsetArray[1];
					camPos.x += offset.daOffsetArray[2];
					camPos.y += offset.daOffsetArray[3];
					if (offset.daOffsetArray[4] != 0)
						camPos.set(dad.getGraphicMidpoint().x + offset.daOffsetArray[4], dad.getGraphicMidpoint().y + offset.daOffsetArray[5]);
				}	
		}
		
		boyfriend = new Boyfriend(770, 450, SONG.player1);
		trace('found boyfriend character');

		if (duoBoyfriend)
			boyfriend1 = new Boyfriend(770, 100, 'amor-ex');

		if (triple)
		{
			boyfriend1 = new Boyfriend(770, 100, 'bf-dad');
			boyfriend2 = new Boyfriend(770, 100, 'bf-mom');
			trace('triples again');
		}

		dadTrail = new DeltaTrail(dad, null, 4, 12 / 60, 0.25, 0.069);
		dadTrail.active = false;
		dadTrail.color = FlxColor.fromString('#' + dad.trailColor);
		add(dadTrail);

		bfTrail = new DeltaTrail(boyfriend, null, 4, 12 / 60, 0.25, 0.069);
		bfTrail.active = false;
		bfTrail.color = FlxColor.fromString('#' + boyfriend.trailColor);
		add(bfTrail);

		if (duoDad || triple)
		{
			dad1Trail = new DeltaTrail(dad1, null, 4, 12 / 60, 0.25, 0.069);
			dad1Trail.active = false;
			dad1Trail.color = FlxColor.fromString('#' + dad1.trailColor);
			add(dad1Trail);
		}

		if (duoBoyfriend || triple)
		{
			bf1Trail = new DeltaTrail(boyfriend1, null, 4, 12 / 60, 0.25, 0.069);
			bf1Trail.active = false;
			bf1Trail.color = FlxColor.fromString('#' + boyfriend1.trailColor);
			add(bf1Trail);
		}

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo' | 'limoholo' | 'limoholo-night':
				boyfriend.y -= 250;
				boyfriend.x += 260;

				if (!usesStageHx)
				{
					resetFastCar();
					add(fastCar);
				}
				else
					Stage.resetFastCar();
			case 'ripdiner':
				boyfriend.x += 100;
				boyfriend.y += 165;
				boyfriend.scrollFactor.set(0.9, 0.9);
				gf.x -= 70;
				gf.y += 200;
				gf.scrollFactor.set(0.9, 0.9);

			case 'exestage':
				boyfriend.y += 25;
				dad.y += 25;
				dad.scrollFactor.set(1.37, 1);
				boyfriend.scrollFactor.set(1.37, 1);
				gf.scrollFactor.set(1.37, 1);
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y - 100);
			case 'churchgospel':
				gf.x -= 100;
				gf.y -= 70;
				dad.x -= 100;
				dad.y += 100;
				boyfriend.x += 100;
				boyfriend.y += 100;
				
			case 'takiStage':
				boyfriend.x += 500;
				boyfriend.y += 200;
				gf.x += 300;
				gf.y += 80;
				dad.x += 300;
				if (dad.curCharacter.startsWith('gf'))
				{
					dad.y += 80;
				}
				gf.scrollFactor.set(1.0, 1.0);

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
			case 'eddhouse':
				boyfriend.x += 330;
				boyfriend.y -= 180;
				gf.x += 250;
				gf.y -= 235;
			case 'neon':
				dad.scale.set(0.85, 0.85);
				boyfriend.scale.set(0.86, 0.86);
				gf.scale.set(0.86, 0.86);
				dad.x += 250;
				dad.y += 150;
				boyfriend.x += 100;
			
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
					dad.setZoom(1.1);
				if (curSong == 'Their-Battle')
					gf.setZoom(1.2);
				else
					gf.setZoom(1.1);

				boyfriend.x += 300;
				dad.x -= 400;
				gf.y -= 110;
				gf.x -= 50;

			case 'auditorHell':
				boyfriend.y -= 160;
				boyfriend.x += 350;
				gf.x += 345;
				gf.y -= 25;	

			case 'shaggy-mansion':
				boyfriend.x += 100;

			case 'facility':
				boyfriend.x += 660;
				boyfriend.y += 230;
				gf.x += 575;
				gf.y += 430;
				dad.x += 310;
				dad.y += 250;
				gf.scrollFactor.set(1, 1);

			case 'garage':
				boyfriend.x += 30;
				boyfriend.y -= 160;
				gf.x += 180;
				gf.y = -800;
				dad.x += 20;
				dad.y += 82;
				camPos.set(dad.getGraphicMidpoint().x + 200, dad.getGraphicMidpoint().y +20);

			case 'mackiestage':
				dad.x -= 300;
				boyfriend.x += 300;

			case 'acrimony':
				boyfriend.x += 70;
				gf.x += 67;
				gf.y += 430;
				dad.x -= 40;	
			case 'day':
				boyfriend.x += Stage.bfXOffset;
				boyfriend.y += Stage.bfYOffset;
				dad.x += Stage.dadXOffset;
				dad.y += Stage.dadYOffset;
				gf.x += Stage.gfXOffset;
				gf.y += Stage.gfYOffset;
				camPos.x = 536.63;
				camPos.y = 449.94;
			case 'hallway':
				camPos.x = 1176.3;
				camPos.y = 515.87;
				boyfriend.x += 585;
				boyfriend.y += 65;
				if (duoBoyfriend) {
					boyfriend1.x += 585;
					boyfriend1.y += 65;
				}
				gf.x += 180;
				gf.y -= 20;
				dad.x += 17;
				dad.y += 63;
				if (duoDad) {
					dad1.x += 17;
					dad1.y += 63;
				} 
				gf.color = FlxColor.fromHSL(gf.color.hue, gf.color.saturation, 0.5, 1);
			case 'trioStage':
				dad.scrollFactor.set(1.1, 1);
				boyfriend.scrollFactor.set(1.1, 1);

				boyfriend.x -= 305;
				boyfriend.y -= 75;

				dad.x -= 200;
				dad.y -= 50;
				camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);
			case 'sonicFUNSTAGE':
				boyfriend.y += 334;
				boyfriend.x += 80;
				dad.y += 300;
				gf.y += 300;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y - 200);
			default:
				if (usesStageHx)
				{
					boyfriend.x += Stage.bfXOffset;
					boyfriend.y += Stage.bfYOffset;
					dad.x += Stage.dadXOffset;
					dad.y += Stage.dadYOffset;
					gf.x += Stage.gfXOffset;
					gf.y += Stage.gfYOffset;
				}		
		}

		switch (SONG.player1)
		{
			default:
				if (boyfriend.isCustom)
				{
					boyfriend.x += boyfriend.positionArray[0];
					boyfriend.y += boyfriend.positionArray[1];
				}	
				else
				{
					var offset = new CharacterOffsets(SONG.player1, true);
					boyfriend.x += offset.daOffsetArray[0];
					boyfriend.y += offset.daOffsetArray[1];
					camPos.x += offset.daOffsetArray[2];
					camPos.y += offset.daOffsetArray[3];
					if (offset.daOffsetArray[4] != 0)
						camPos.set(boyfriend.getGraphicMidpoint().x + offset.daOffsetArray[4], boyfriend.getGraphicMidpoint().y + offset.daOffsetArray[5]);
				}		
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

		if (SONG.song.toLowerCase() == 'casanova' && dad.curCharacter == 'selever'){
			blackScreen = new FlxSprite(-100, -100).makeGraphic(Std.int(FlxG.width * 100), Std.int(FlxG.height * 100), FlxColor.BLACK);
			blackScreen.scrollFactor.set();
			blackScreen.alpha = 0;
			add(blackScreen);

			circ1 = new FlxSprite(dad.x-200,dad.y - 150).loadGraphic(Paths.image('sacredmass/churchselever/circ'));
			circ1.setGraphicSize(Std.int(circ1.width * 0.5));
			circ1.alpha = 0;
			add(circ1);
		}

		if (usesStageHx)
		{
			for (index => array in Stage.layInFront)
			{
				switch (index)
				{
					case 0:
						for (bg in array)
							add(bg);
				}
			}
		}
	
		switch (curStage)
		{
			case 'auditorHell':
				if (SONG.player2 == 'exTricky')
					add(hole);
				if (isVitor)
				{
					rope = new FlxSprite(850, 440).loadGraphic(Paths.image('tricky/fourth/rope','shared'));
					rope.scrollFactor.set(0.9, 0.9);
					add(rope);
				}	
			case 'limoholo-night':
				if (SONG.song.toLowerCase() == 'hands')
				{
					cloudGroup = new FlxTypedGroup<Cloud>(25);
					add(cloudGroup);
					add(limoOhNo);		
				}
				add(limo);				
			case 'philly-wire':
				add(gfBG);
				add(gfBG2);
		}

		if (duoDad && SONG.song.toLowerCase() == 'epiphany')
			add(dad1);

		add(dad);

		if (usesStageHx)
		{
			for (index => array in Stage.layInFront)
			{
				switch (index)
				{
					case 1:
						for (bg in array)
							add(bg);
				}
			}
		}

		if (curStage == 'auditorHell' && SONG.player2 == 'exTricky')
		{
			cloneOne = new FlxSprite(0,0);
			cloneTwo = new FlxSprite(0,0);
			cloneOne.frames = Paths.getSparrowAtlas('tricky/fourth/Clone', 'shared');
			cloneTwo.frames = Paths.getSparrowAtlas('tricky/fourth/Clone', 'shared');
			cloneOne.alpha = 0;
			cloneTwo.alpha = 0;
			cloneOne.animation.addByPrefix('clone','Clone',24,false);
			cloneTwo.animation.addByPrefix('clone','Clone',24,false);

			add(cloneOne);
			add(cloneTwo);
			add(cover);
			add(converHole);
			add(dad.exSpikes);
		}

		if (duoDad && SONG.song.toLowerCase() != 'epiphany')
			add(dad1);

		if (triple)
		{
			add(dad1);
			add(dad2);
		}

		add(boyfriend);

		if (duoBoyfriend)
			add(boyfriend1);

		if (usesStageHx)
		{
			for (index => array in Stage.layInFront)
			{
				switch (index)
				{
					case 2:
						for (bg in array)
							add(bg);
				}
			}
		}

		if (triple)
		{
			add(boyfriend1);
			add(boyfriend2);
		}

		switch (curStage)
		{
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
			case 'polus' | 'reactor' | 'reactor-m':
				flashSprite.alpha = 0;
				flashSprite.scrollFactor.set(0,0);
				flashSprite.screenCenter();
				add(flashSprite);
			case 'studioLot':
				if (SONG.song.toLowerCase() == 'jeez') {
					yoMamaBG = new FlxSprite(0, 0).loadGraphic(Paths.image('yomama'));
					yoMamaBG.cameras = [camHUD];
					yoMamaBG.antialiasing = true;
					add(yoMamaBG);
					if (!executeModchart) {
						yoMamaBG.alpha = 0;
					}
				} 
			case 'street3':
				if (SONG.song.toLowerCase() == 'really-happy' && dad.curCharacter.contains('yuri-crazy')) {
					blackScreen = new FlxSprite(-100, -100).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					blackScreen.scrollFactor.set();
					add(blackScreen);
				
					eyes = new FlxSprite(0, 0).loadGraphic(Paths.image('doki/eyes1'));
					eyes.cameras = [camHUD];
					eyes.antialiasing = true;
					add(eyes);
		
					eyes2 = new FlxSprite(0, 0).loadGraphic(Paths.image('doki/eyes2'));
					eyes2.cameras = [camHUD];
					eyes2.antialiasing = true;
					add(eyes2);
					
					if (!executeModchart) {
						eyes.alpha = 0;
						eyes2.alpha = 0;
						blackScreen.alpha = 0;
					}
				} 
			case 'emptystage3':
				if (SONG.song.toLowerCase() == 'monochrome') {
					eyes = new FlxSprite(200, -30);
					eyes.frames = Paths.getSparrowAtlas('doki/big_monikia_death_bg', 'shared');
					eyes.animation.addByPrefix('crashDeath2', 'Big Monika JUMP', 24, false);
					eyes.setGraphicSize(Std.int(eyes.width * 0.56));
					eyes.updateHitbox();
					eyes.animation.play('crashDeath2');
					eyes.cameras = [camHUD];
					eyes.antialiasing = true;
					eyes.alpha = 0;
					add(eyes);
				}
		}

		if (SONG.song.toLowerCase() == 'killer-scream')
		{
			zipperScreamOverlay = new FlxSprite().loadGraphic(Paths.image('holofunk/russia/vingette', 'shared'), true, 1920, 1080);
			zipperScreamOverlay.antialiasing = FlxG.save.data.antialiasing;
			zipperScreamOverlay.setGraphicSize(1440, 810);
			zipperScreamOverlay.visible = false;
			zipperScreamOverlay.updateHitbox();
			zipperScreamOverlay.screenCenter();
			zipperScreamOverlay.cameras = [camHUD];
			add(zipperScreamOverlay);
	
			periScreamOverlay = new FlxSprite();
			periScreamOverlay.frames = Paths.getSparrowAtlas('jojo', 'shared');
			periScreamOverlay.animation.addByPrefix('idle', 'JoJo', 24, false);
			periScreamOverlay.antialiasing = FlxG.save.data.antialiasing;
			periScreamOverlay.visible = false;
			periScreamOverlay.updateHitbox();
			periScreamOverlay.screenCenter();
			periScreamOverlay.cameras = [camHUD];
			periScreamOverlay.animation.play('idle');
			add(periScreamOverlay);
		}
	
		rushiaOverlayFrame = 0;
		rushiaScreamOverlay.antialiasing = FlxG.save.data.antialiasing;
		rushiaScreamOverlay.setGraphicSize(1280, 720);
		rushiaScreamOverlay.visible = false;
		rushiaScreamOverlay.updateHitbox();
		rushiaScreamOverlay.cameras = [camHUD];
		add(rushiaScreamOverlay);

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

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		add(grpNoteSplashes);
		
		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.0;

		playerStrums = new FlxTypedGroup<FlxSprite>();

		if (SONG.noteStyle == 'exe')
		{
			playerSplashes = new FlxTypedGroup<FlxSprite>();
			add(playerSplashes);
		}
		
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

		if(curStage == 'mind2')
		{
			moreDark = new FlxSprite(0, 0).loadGraphic(Paths.image('corruption/tormentor/dark'));
			moreDark.cameras = [camHUD];
			moreDark.antialiasing = true;
			add(moreDark);
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

		switch (curStage)
		{
			case 'garStage' | 'garStageDead' | 'garStageRise':
				healthBar.createFilledBar(0xFF8E40A5, 0xFF66FF33);
				defaultBar = false;	
			case 'hungryhippo' | 'hungryhippo-blantad':
				healthBar.createFilledBar(0xFF6495ED, 0xFF66FF33);
				defaultBar = false;	
			case 'street1' | 'street2' | 'street3':
				healthBar.createFilledBar(0xFF373737, 0xFF808080);	
				defaultBar = false;	
			case 'emptystage2':
				healthBar.createFilledBar(0xFF000000, 0xFF000000);
				defaultBar = false;	
			default:
				healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));				
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
			case 'monster-pixel':
				switch(curSong.toLowerCase())
				{
					case 'dead-pixel':
						p1Icon = 'monster-pixel-look';
					default:
						p1Icon = 'monster-pixel';
				}
			case 'hd-spirit':
				if (curSong.toLowerCase() == 'spectral-spat')
					p1Icon = 'gar-spirit';
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
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		doof2.cameras = [camHUD];
		doof3.cameras = [camHUD];
		doof4.cameras = [camHUD];
		if (SONG.song.toLowerCase() == 'endless' || SONG.song.toLowerCase() == 'triple-trouble')
		{
			startCircle.cameras = [camOther];
			startText.cameras = [camOther];
			blackFuck.cameras = [camOther];
		}
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		if (loadRep)
			replayTxt.cameras = [camHUD];

		if (SONG.noteStyle == 'exe')
		{
			if (mania == 3)
			{
				if (FlxG.save.data.downscroll)
				{
					ringCounter = new FlxSprite(1133, 30).loadGraphic(Paths.image('exe/Counter'));
					add(ringCounter);
					ringCounter.cameras = [camHUD];

					counterNum = new FlxText(1207, 36, 0, '0', 10, false);
					counterNum.setFormat('EurostileTBla', 60, FlxColor.fromRGB(255, 204, 51), FlxTextBorderStyle.OUTLINE, FlxColor.fromRGB(204, 102, 0));
					counterNum.setBorderStyle(OUTLINE, FlxColor.fromRGB(204, 102, 0), 3, 1);
					add(counterNum);
					counterNum.cameras = [camHUD];
				}
				else
				{
					ringCounter = new FlxSprite(1133, 610).loadGraphic(Paths.image('exe/Counter'));
					add(ringCounter);
					ringCounter.cameras = [camHUD];

					counterNum = new FlxText(1207, 606, 0, '0', 10, false);
					counterNum.setFormat('EurostileTBla', 60, FlxColor.fromRGB(255, 204, 51), FlxTextBorderStyle.OUTLINE, FlxColor.fromRGB(204, 102, 0));
					counterNum.setBorderStyle(OUTLINE, FlxColor.fromRGB(204, 102, 0), 3, 1);
					add(counterNum);
					counterNum.cameras = [camHUD];
				}
			}

			playerSplashes.cameras = [camHUD];
		}
			
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

		if (curStage == 'motherland' || curStage == 'concert')
		{
			add(tstatic);
			tstatic.alpha = 0;
			tstatic.setGraphicSize(Std.int(tstatic.width * 12));
			tstatic.x += 600;

			if (curStage == 'concert')
				tstatic.y += 300;
		}

		if (SONG.song.toLowerCase() == 'jeez') {
			brody = new FlxSprite(0, 0);
			brody.frames = Paths.getSparrowAtlas('brodyanimated');
			brody.animation.addByPrefix('yomom', 'Animated', 30,false);
			brody.cameras = [camHUD];
			brody.antialiasing = true;
			brody.animation.play('yomom');
			add(brody);
			if (!executeModchart) {
				brody.alpha = 0;
			}
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
				case 'monochrome':
					FlxG.sound.play(Paths.sound('listen'));
					boyfriend.visible = false;
					gf.visible = false;
					healthBar.alpha = 0;
					healthBarBG.alpha = 0;
					iconP1.alpha = 0;
					iconP2.alpha = 0;
					scoreTxt.alpha = 0;
					dad.visible = false;
					new FlxTimer().start(2, function(tmr:FlxTimer)
					{
						startCountdown();
					});
				case 'killer-scream' | 'deathmatch-holo':
					toggleHealthShit(true);
					startCountdown();
				case 'endless':
					add(blackFuck);
					startCircle.loadGraphic(Paths.image('exe/StartScreens/CircleMajin'));
					startCircle.x += 777;
					add(startCircle);
					startText.loadGraphic(Paths.image('exe/StartScreens/TextMajin'));
					startText.x -= 1200;
					add(startText);
					new FlxTimer().start(0.6, function(tmr:FlxTimer)
					{
						FlxTween.tween(startCircle, {x: 0}, 0.5);
						FlxTween.tween(startText, {x: 0}, 0.5);
					});

					new FlxTimer().start(1.9, function(tmr:FlxTimer)
					{
						FlxTween.tween(startCircle, {alpha: 0}, 1);
						FlxTween.tween(startText, {alpha: 0}, 1);
						FlxTween.tween(blackFuck, {alpha: 0}, 1);
					});
					startCountdown();
				case 'triple-trouble':
					add(blackFuck);
					startCircle.loadGraphic(Paths.image('exe/StartScreens/CircleTripleTrouble'));
					startCircle.x += 777;
					add(startCircle);
					startText.loadGraphic(Paths.image('exe/StartScreens/TextTripleTrouble'));
					startText.x -= 1200;
					add(startText);
					new FlxTimer().start(0.6, function(tmr:FlxTimer)
					{
						FlxTween.tween(startCircle, {x: 0}, 0.5);
						FlxTween.tween(startText, {x: 0}, 0.5);
					});

					new FlxTimer().start(1.9, function(tmr:FlxTimer)
					{
						FlxTween.tween(startCircle, {alpha: 0}, 1);
						FlxTween.tween(startText, {alpha: 0}, 1);
						FlxTween.tween(blackFuck, {alpha: 0}, 1);
					});
					startCountdown();
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				case 'expurgation':
					if (dad.curCharacter != 'exTricky')
					{
						dad.visible = false;

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
					}
					else
					{
						dad.visible = false;
						if (triple)
						{
							dad1.visible = false;
							dad2.visible = false;
							boyfriend1.visible = false;
							boyfriend2.visible = false;
							rope.visible = false;
						}
						camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
						var spawnAnim = new FlxSprite(-150,-380);
						spawnAnim.frames = Paths.getSparrowAtlas('characters/EXTRICKYENTER','shared');

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
								if (triple)
								{
									dad1.visible = true;
									dad2.visible = true;
									boyfriend1.visible = true;
									boyfriend2.visible = true;
									rope.visible = true;
								}		
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
					}
					
				case 'nerves':
					FlxG.sound.play(Paths.sound('garWeak'));
					startCountdown();
				case 'monochrome':
					FlxG.sound.play(Paths.sound('listen'));
					boyfriend.visible = false;
					gf.visible = false;
					healthBar.alpha = 0;
					healthBarBG.alpha = 0;
					iconP1.alpha = 0;
					iconP2.alpha = 0;
					scoreTxt.alpha = 0;
					dad.alpha = 0;
					Stage.swagBacks['stageFront'].alpha = 0;
					new FlxTimer().start(2, function(tmr:FlxTimer)
					{
						startCountdown();
					});	
				case 'killer-scream' | 'deathmatch-holo':
					toggleHealthShit(true);
					startCountdown();
				case 'endless':
					add(blackFuck);
					startCircle.loadGraphic(Paths.image('exe/StartScreens/CircleMajin'));
					startCircle.x += 777;
					add(startCircle);
					startText.loadGraphic(Paths.image('exe/StartScreens/TextMajin'));
					startText.x -= 1200;
					add(startText);
					new FlxTimer().start(0.6, function(tmr:FlxTimer)
					{
						FlxTween.tween(startCircle, {x: 0}, 0.5);
						FlxTween.tween(startText, {x: 0}, 0.5);
					});

					new FlxTimer().start(1.9, function(tmr:FlxTimer)
					{
						FlxTween.tween(startCircle, {alpha: 0}, 1);
						FlxTween.tween(startText, {alpha: 0}, 1);
						FlxTween.tween(blackFuck, {alpha: 0}, 1);
					});
					startCountdown();
				case 'triple-trouble':
					add(blackFuck);
					startCircle.loadGraphic(Paths.image('exe/StartScreens/CircleTripleTrouble'));
					startCircle.x += 777;
					add(startCircle);
					startText.loadGraphic(Paths.image('exe/StartScreens/TextTripleTrouble'));
					startText.x -= 1200;
					add(startText);
					new FlxTimer().start(0.6, function(tmr:FlxTimer)
					{
						FlxTween.tween(startCircle, {x: 0}, 0.5);
						FlxTween.tween(startText, {x: 0}, 0.5);
					});

					new FlxTimer().start(1.9, function(tmr:FlxTimer)
					{
						FlxTween.tween(startCircle, {alpha: 0}, 1);
						FlxTween.tween(startText, {alpha: 0}, 1);
						FlxTween.tween(blackFuck, {alpha: 0}, 1);
					});
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

		if(SONG.song.toLowerCase() == 'reactor') {
			camFollow.setPosition(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y - 100);
		}

		super.create();

		/*if (SONG.player2.contains('hypno'))
		{
			pendulum = new Pendulum();
			
			if (SONG.player2 == 'hypno') {
				pendulumShadow = new FlxTypedGroup<FlxSprite>();
				
				pendulum.frames = Paths.getSparrowAtlas('hypno/Pendelum', 'shared');
				pendulum.animation.addByPrefix('idle', 'Pendelum instance 1', 24, true);
				pendulum.animation.play('idle');
				pendulum.antialiasing = true; // fuck you ASH
				
				pendulum.scale.set(1.3, 1.3);
				pendulum.updateHitbox();
				pendulum.origin.set(65, 0);
				pendulum.angle = -9;
				add(pendulumShadow);
				add(pendulum);

				tranceActive = true;

				
			}
		}*/
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

	var writing:Bool = false;

	function startWriting(timer:Int = 15, word:String = ''):Void {
		canPause = false;
		writing = true;
		persistentUpdate = true;
		persistentDraw = true;
		var realTimer = timer;
		var textState = new TextSubState(realTimer, word);
		textState.win = finishedWriting;
		textState.lose = death;
		textState.cameras = [camHUD];
		FlxG.autoPause = false;
		openSubState(textState);
	}

	public function finishedWriting():Void {
		canPause = true;
		writing = false;
	}

	public function fixTrailShit(id:String):Void 
	{
		switch (id)
		{
			case 'dadTrail':
				dadTrail.destroy();
				remove(dad);
				dadTrail = new DeltaTrail(dad, null, 4, 12 / 60, 0.25, 0.069);
				dadTrail.active = false;
				dadTrail.color = FlxColor.fromString('#' + dad.trailColor);
				add(dadTrail);
				add(dad);
			case 'bfTrail':
				bfTrail.destroy();
				remove(boyfriend);
				bfTrail = new DeltaTrail(boyfriend, null, 4, 12 / 60, 0.25, 0.069);
				bfTrail.active = false;
				bfTrail.color = FlxColor.fromString('#' + boyfriend.trailColor);
				add(bfTrail);
				add(boyfriend);
			case 'dad1Trail':
				dad1Trail.destroy();
				remove(dad1);
				dad1Trail = new DeltaTrail(dad1, null, 4, 12 / 60, 0.25, 0.069);
				dad1Trail.active = false;
				dad1Trail.color = FlxColor.fromString('#' + dad1.trailColor);
				add(dad1Trail);
				add(dad1);
			case 'bf1Trail':
				bf1Trail.destroy();
				remove(boyfriend1);
				bf1Trail = new DeltaTrail(boyfriend1, null, 4, 12 / 60, 0.25, 0.069);
				bf1Trail.active = false;
				bf1Trail.color = FlxColor.fromString('#' + boyfriend1.trailColor);
				add(bf1Trail);
				add(boyfriend1);
			case 'tabiTrail':
				tabiTrail = new FlxTrail(dad, null, 4, 24, 0.6, 0.9);
				add(tabiTrail);
		}
	}

	var fuckingREACTOROFFSET:Float = 0;

	public function death():Void
	{
		if (SONG.song.toLowerCase() == 'monochrome')
		{
			boyfriend.stunned = true;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			FlxTween.tween(dad, {alpha: 0}, 1, {ease: FlxEase.linear, onComplete: function (twn:FlxTween){
				remove(dad);
			}});

			FlxTween.tween(Stage.swagBacks['stageFront'], {alpha: 0}, 1, {ease: FlxEase.linear, onComplete: function (twn:FlxTween){
				remove(Stage.swagBacks['stageFront']);
			}});

			FlxTween.tween(healthBar, {alpha: 0}, 1, {ease: FlxEase.linear, onComplete: function (twn:FlxTween) {
				healthBar.visible = false;
				healthBarBG.visible = false;
				scoreTxt.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
			}});
			FlxTween.tween(healthBarBG, {alpha: 0}, 1, {ease: FlxEase.linear});
			FlxTween.tween(scoreTxt, {alpha: 0}, 1, {ease: FlxEase.linear});
			FlxTween.tween(iconP1, {alpha: 0}, 1, {ease: FlxEase.linear});
			FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.linear});
			for (i in playerStrums) {
				FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
			}
			new FlxTimer().start(1.2, function(tmr:FlxTimer)
			{
				FlxG.resetState();
			});
		}
		else
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			var daX = boyfriend.getScreenPosition().x;
			var daY = boyfriend.getScreenPosition().y;

			if (SONG.song.toLowerCase() == 'epiphany')
			{
				daX = dad1.getScreenPosition().x;
				daY = dad1.getScreenPosition().y;
			}

			openSubState(new GameOverSubstate(daX, daY));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
		}		
	}

	public function callOnLuas(event:String, args:Array<Dynamic>):Dynamic {
		var returnVal:Dynamic = ModchartState.Function_Continue;
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			var ret:Dynamic = luaArray[i].call(event, args);
			if(ret != ModchartState.Function_Continue) {
				returnVal = ret;
			}
		}
		#end
		return returnVal;
	}

	function changeDadCharacter(x:Float, y:Float, character:String)
	{
		dad.destroy();
		dad = new Character(x, y, character);
		add(dad);
		iconP2.useOldSystem(character);

		if (defaultBar)
		{
			healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));
			healthBar.updateBar();
		}
	
		if (changeArrows)
			updateStaticNotes(dad.noteSkin);
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
		iconP1.useOldSystem(character);

		if (defaultBar)
		{
			healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));
			healthBar.updateBar();
		}
	}

	public function changeStaticNotes(id:String, ?id2:String)
	{
		if (id2 == '' || id2 == null)
			id2 = id;
		
		remove(strumLineNotes);
		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		strumLineNotes.cameras = [camHUD];	
		generateStaticArrows(0, id, false);
		generateStaticArrows(1, id2, false);
	}
	
	function updateStaticNotes(id:String)
	{
		remove(strumLineNotes);
		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		strumLineNotes.cameras = [camHUD];	
		generateStaticArrows(0, dad.noteSkin, false);
		generateStaticArrows(1, boyfriend.noteSkin, false);

		regenerateDadArrows = false;
	}

	function corruptBG(id:String)
	{
		switch (id)
		{
			case 'corrupt':
				Stage.swagBacks['bgSkyEvil'].alpha = 1;
				Stage.swagBacks['bgSchoolEvil'].alpha = 1;
				Stage.swagBacks['fgTreesEvil'].alpha = 1;
				Stage.swagBacks['bgStreetEvil'].alpha = 1;
				Stage.swagBacks['bgTrees'].alpha = 0;	
			case 'normal':
				Stage.swagBacks['bgSkyEvil'].alpha = 0;
				Stage.swagBacks['bgSchoolEvil'].alpha = 0;
				Stage.swagBacks['fgTreesEvil'].alpha = 0;
				Stage.swagBacks['bgStreetEvil'].alpha = 0;
				Stage.swagBacks['bgTrees'].alpha = 1;			
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

	var cloneOne:FlxSprite;
	var cloneTwo:FlxSprite;

	function doClone(side:Int)
	{
		switch(side)
		{
			case 0:
				if (cloneOne.alpha == 1)
					return;
				cloneOne.x = dad.x - 20;
				cloneOne.y = dad.y + 140;
				cloneOne.alpha = 1;

				cloneOne.animation.play('clone');
				cloneOne.animation.finishCallback = function(pog:String) {cloneOne.alpha = 0;}
			case 1:
				if (cloneTwo.alpha == 1)
					return;
				cloneTwo.x = dad.x + 390;
				cloneTwo.y = dad.y + 140;
				cloneTwo.alpha = 1;

				cloneTwo.animation.play('clone');
				cloneTwo.animation.finishCallback = function(pog:String) {cloneTwo.alpha = 0;}
		}

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

		if ((SONG.player1 == 'bf-aloe-past') && !FlxG.save.data.deathHoloUnlocked) //i know people have already seen the deathmatch holo but THIS should work.
		{
			FlxG.sound.play(Paths.sound('nogood'));
			FlxG.switchState(new GoFindTheSecretState());
		}
			
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

		var alpha:Float = 1;
		
		if (SONG.song.toLowerCase() == 'monochrome' || SONG.song.toLowerCase() == 'killer-scream')
		{
			alpha = 0;
			if (SONG.song.toLowerCase() == 'monochrome') {if (executeModchart)eyes.alpha = 1;}	
		}

		generateStaticArrows(0, dad.noteSkin, true, alpha);
		generateStaticArrows(1, boyfriend.noteSkin, true, alpha);	
	
		#if windows
		// pre lowercasing the song name (startCountdown)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
			case 'scary-swings': songLowercase = 'scary swings';
			case 'my-sweets': songLowercase = 'my sweets';
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

			switch (curStage)
			{
				case 'eddhouse':
					if (SONG.song.toLowerCase() == 'norway' || SONG.song.toLowerCase() == 'norskye')
					{
						bfBG.animation.play('idle');
						tordBG.animation.play('idle');
						if (SONG.song.toLowerCase() == 'norway')
						{
							tomBG.animation.play('idle');
							mattBG.animation.play('idle');					
							gfBG.dance();
						}		
					}
				case 'mallSoft':
					Stage.swagBacks['momDadBG'].animation.play('idle');
					Stage.swagBacks['softBFBG'].animation.play('idle');
					Stage.swagBacks['gfBG'].dance();
				case 'limoholo-night':
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
			introAssets.set('street1', [
				'bw/flipped/ready',
				'bw/flipped/set',
				'bw/flipped/go'
			]);
			introAssets.set('holostage-past', [
				'bw/flipped/ready',
				'bw/flipped/set',
				'bw/flipped/go'
			]);
			introAssets.set('street2', [
				'bw/flipped/ready',
				'bw/flipped/set',
				'bw/flipped/go'
			]);
			introAssets.set('street3', [
				'bw/flipped/ready',
				'bw/flipped/set',
				'bw/flipped/go'
			]);
			introAssets.set('day', [
				'b&b/2',
				'b&b/1',
				'b&b/go'
			]);
			introAssets.set('night', [
				'b&b/2',
				'b&b/1',
				'b&b/go'
			]);
			introAssets.set('motherland', [
				'holofunk/ui/ready',
				'holofunk/ui/set',
				'holofunk/ui/go'
			]);
			introAssets.set('holostage', [
				'holofunk/ui/ready',
				'holofunk/ui/set',
				'holofunk/ui/go'
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
						case 'school' | 'schoolEvil' | 'school-monika' | 'school-monika-finale' | 'school-switch':
							altSuffix = '-pixel';
						default:
							altSuffix = '';
					}
				}
			}

			if (SONG.song.toLowerCase() != 'monochrome' && SONG.song.toLowerCase() != 'killer-scream' && SONG.song.toLowerCase() != 'endless' && SONG.song.toLowerCase() != 'triple-trouble')
			{
				switch (swagCounter)
				{
					case 0:
						switch (curStage) {
							case 'day':
								FlxG.sound.play(Paths.sound('bob/3', 'shared'), 0.6);
							case 'sunset':
								FlxG.sound.play(Paths.sound('bosip/3', 'shared'), 0.6);
							case 'night':
								FlxG.sound.play(Paths.sound('amor/3', 'shared'), 0.6);
							default:
								FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
						}
						switch (curStage) {
							case 'day' | 'sunset' | 'night':
								var three:FlxSprite = new FlxSprite().loadGraphic(Paths.image('b&b/3', 'shared'));
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
							case 'night':
								FlxG.sound.play(Paths.sound('amor/2', 'shared'), 0.6);
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
							case 'night':
								FlxG.sound.play(Paths.sound('amor/1', 'shared'), 0.6);
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
							case 'night':
								FlxG.sound.play(Paths.sound('amor/Go', 'shared'), 0.6);
							default:
								FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
						}
						if (SONG.song.toLowerCase() == "casanova" && dad.curCharacter == 'selever') 
						{
							circ1.alpha = 1;
							FlxTween.tween(circ1, {angle: 360, alpha: 0, "scale.x":1, "scale.y":1, x: dad.x-100, y:dad.y}, 2.5, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									remove(circ1);
								}
							});
							
							FlxTween.tween(blackScreen, {alpha: 0.7}, 0.5, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									FlxTween.tween(blackScreen, {alpha: 0}, 0.5, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
										{
											blackScreen.destroy();
										}
									});
								}
							});
							FlxTween.tween(FlxG.camera, {zoom: 1.2}, 0.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.9, {
										ease: FlxEase.quadInOut,
									});
								}
							});
							dad.playAnim('hey');
						} 
					case 4:
						if (SONG.song.toLowerCase() == "takeover") 
						{
							for (note in 0...strumLineNotes.members.length) {
								ModCharts.circleLoop(strumLineNotes.members[note], 50, 3);
							}
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

		if (SONG.song.toLowerCase() == 'killer-scream')
			startTimer.finished = true;
	}

	public function softCountdown(?style:String):Void
	{
		inCutscene = false;
		camFollowIsOn = true;
		defaultCamFollow = true;

		talking = false;

		var dankCounter:Int = 0;

		var dankTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
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
			introAssets.set('street1', [
				'bw/flipped/ready',
				'bw/flipped/set',
				'bw/flipped/go'
			]);
			introAssets.set('street2', [
				'bw/flipped/ready',
				'bw/flipped/set',
				'bw/flipped/go'
			]);
			introAssets.set('street3', [
				'bw/flipped/ready',
				'bw/flipped/set',
				'bw/flipped/go'
			]);
			introAssets.set('day', [
				'b&b/2',
				'b&b/1',
				'b&b/go'
			]);
			introAssets.set('night', [
				'b&b/2',
				'b&b/1',
				'b&b/go'
			]);
			introAssets.set('motherland', [
				'holofunk/ui/ready',
				'holofunk/ui/set',
				'holofunk/ui/go'
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
						case 'emptystage2' | 'street1' | 'street2' | 'street3' | 'motherland':
							altSuffix = '';
						default:
							altSuffix = '-pixel';
					}
				}
			}
		
			switch (dankCounter)
			{
				case 0:
					switch (style) {
						case 'bob':
							FlxG.sound.play(Paths.sound('bob/3', 'shared'), 0.6);
						case 'bosip':
							FlxG.sound.play(Paths.sound('bosip/3', 'shared'), 0.6);
						case 'amor':
							FlxG.sound.play(Paths.sound('amor/3', 'shared'), 0.6);
						default:
							FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
					}
					switch (style) {
						case 'bob' | 'bosip' | 'amor':
							var three:FlxSprite = new FlxSprite().loadGraphic(Paths.image('b&b/3', 'shared'));
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
					switch (style) {
						case 'bob':
							FlxG.sound.play(Paths.sound('bob/2', 'shared'), 0.6);
						case 'bosip':
							FlxG.sound.play(Paths.sound('bosip/2', 'shared'), 0.6);
						case 'amor':
							FlxG.sound.play(Paths.sound('amor/2', 'shared'), 0.6);
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
					switch (style) {
						case 'bob':
							FlxG.sound.play(Paths.sound('bob/1', 'shared'), 0.6);
						case 'bosip':
							FlxG.sound.play(Paths.sound('bosip/1', 'shared'), 0.6);
						case 'amor':
							FlxG.sound.play(Paths.sound('amor/1', 'shared'), 0.6);
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
					switch (style) {
						case 'bob':
							FlxG.sound.play(Paths.sound('bob/Go', 'shared'), 0.6);
						case 'bosip':
							FlxG.sound.play(Paths.sound('bosip/Go', 'shared'), 0.6);
						case 'amor':
							FlxG.sound.play(Paths.sound('amor/Go', 'shared'), 0.6);
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

			dankCounter += 1;
		}, 5);
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

		if (SONG.song.toLowerCase() == 'monochrome') {
			FlxTween.tween(dad, {alpha: 1}, 0.5, {ease: FlxEase.linear});	
			FlxTween.tween(Stage.swagBacks['stageFront'], {alpha: 1}, 0.5, {ease: FlxEase.linear});	
		}

		switch (SONG.song.toLowerCase())
		{
			case 'killer-scream' | 'deathmatch-holo':
				toggleHealthShit(false);
		}

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
					case 'scary-swings': songLowercase = 'scary swings';
					case 'my-sweets': songLowercase = 'my sweets';
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
			var suf:String = "";
			if (isNeonight)
			{
				if (!FlxG.save.data.stageChange)
					suf = '-neo-noStage';				
				else
					suf = '-neo';				
			}

			if (isBETADCIU && storyDifficulty == 5)
			{
				if (!FlxG.save.data.stageChange)
					suf = '-guest-noStage';				
				else
					suf = '-guest';
			}

			if (isNeonight)
			{
				var dontSwap:Array<String> = ['amor', 'bob', 'bosip', 'bluskys', 'ron', 'gloopy', 'littleman'];

				if (!FlxG.save.data.stageChange){
					SONG.bfNoteStyle = boyfriend.noteSkin;
				}

				switch (SONG.song.toLowerCase())
				{
					case 'split-ex':
						switch (daSection)
						{
							case 1 | 16 | 112 | 129:
								SONG.dadNoteStyle = 'amor';
								if (FlxG.save.data.stageChange)SONG.bfNoteStyle = 'bf-b&b';
							case 9:
								SONG.dadNoteStyle = 'bluskys';
								if (FlxG.save.data.stageChange)SONG.bfNoteStyle = 'bf-b&b';
							case 17:
								SONG.dadNoteStyle = 'kapi';
							case 25 | 41 | 73 | 80 | 113:
								SONG.dadNoteStyle = 'normal';
							case 33:
								SONG.dadNoteStyle = 'neon';
							case 37:
								SONG.dadNoteStyle = 'void';
							case 57:
								SONG.dadNoteStyle = 'agoti';
							case 77:
								SONG.dadNoteStyle = 'fever';
							case 93:
								SONG.dadNoteStyle = 'littleman';
								if (FlxG.save.data.stageChange)SONG.bfNoteStyle = 'normal';
							case 97:
								SONG.dadNoteStyle = 'ron';
								if (FlxG.save.data.stageChange)SONG.bfNoteStyle = 'normal';
						}
					if (FlxG.save.data.stageChange && !dontSwap.contains(SONG.dadNoteStyle)){
						SONG.bfNoteStyle = SONG.dadNoteStyle;
					}
					case 'crucify':
						switch (daSection)
						{
							case 0: SONG.dadNoteStyle = 'taki';
							case 16 | 32 | 62 | 96 | 104 | 128: 
								if (FlxG.save.data.stageChange)
									SONG.dadNoteStyle = 'normal';
								else
									SONG.dadNoteStyle = 'darker';		
							case 24: SONG.dadNoteStyle = 'trollge';
							case 48: SONG.dadNoteStyle = 'party-crasher';						
							case 58:
								SONG.dadNoteStyle = 'gloopy';
								if (FlxG.save.data.stageChange)SONG.bfNoteStyle = 'normal';
							case 64:
								SONG.dadNoteStyle = 'ron';
								if (FlxG.save.data.stageChange)SONG.bfNoteStyle = 'normal';
							case 80: SONG.dadNoteStyle = 'agoti';			
							case 88: SONG.dadNoteStyle = 'tabi';							
							case 112: SONG.dadNoteStyle = 'sketchy';
							case 120: SONG.dadNoteStyle = 'starecrown';	
						}
					if (FlxG.save.data.stageChange && !dontSwap.contains(SONG.dadNoteStyle)){
						SONG.bfNoteStyle = SONG.dadNoteStyle;
					}
					default:
						//this one actually works
						if (FileSystem.exists(Paths.txt(songLowercase  + "/arrowSwitches" + suf)))
						{
							var stuff:Array<String> = CoolUtil.coolTextFile2(Paths.txt(songLowercase  + "/arrowSwitches" + suf));
				
							for (i in 0...stuff.length)
							{
								var data:Array<String> = stuff[i].split(' ');

								if (daSection == Std.parseInt(data[0]))
								{
									if (data[2] == 'dad')
										SONG.dadNoteStyle = data[1];
									if (data[2] == 'bf')
										SONG.bfNoteStyle = data[1];
								}
							}
						}
				}					
			}

			if (isBETADCIU && storyDifficulty == 5)
			{
				switch (SONG.song.toLowerCase())
				{
					case 'epiphany':
						if (daSection == 10)isPixel = true;
						if (daSection == 18)isPixel = false;
					case "rabbit's-luck":
						if (FileSystem.exists(Paths.txt(songLowercase  + "/arrowSwitches" + suf)))
						{
							var stuff:Array<String> = CoolUtil.coolTextFile2(Paths.txt(songLowercase  + "/arrowSwitches" + suf));
				
							for (i in 0...stuff.length)
							{
								var data:Array<String> = stuff[i].split(' ');

								if (daSection == Std.parseInt(data[0]))
								{
									if (data[2] == 'dad')
										SONG.dadNoteStyle = data[1];
									if (data[2] == 'bf')
										SONG.bfNoteStyle = data[1];
								}
							}
						}
				}
			}

			if (!isNeonight && !isSpres)
			{
				if (FileSystem.exists(Paths.txt(songLowercase  + "/arrowSwitches" + suf)))
				{
					var stuff:Array<String> = CoolUtil.coolTextFile2(Paths.txt(songLowercase  + "/arrowSwitches" + suf));
		
					for (i in 0...stuff.length)
					{
						var data:Array<String> = stuff[i].split(' ');
	
						if (daSection == Std.parseInt(data[0]))
						{
							if (data[2] == 'dad')
								SONG.dadNoteStyle = data[1];
							if (data[2] == 'bf')
								SONG.bfNoteStyle = data[1];
						}
					}
				}
			}

			switch (SONG.song.toLowerCase())
			{
				case 'hill-of-the-void':
				//	if (isBETADCIU)
			}
			
			var mn:Int = keyAmmo[mania]; //new var to determine max notes
			var coolSection:Int = Std.int(section.lengthInSteps / 4);
			var playerNotes:Array<Int> = [0, 1, 2, 3, 8, 9, 10, 11];

			if (curStage == 'auditorHell' || SONG.song.toLowerCase() == 'hill-of-the-void')
			{
				for (songNotes in section.sectionNotes)
				{
					alt = dad.noteSkin;
					alt2 = boyfriend.noteSkin;
					
					if (section.isPixel)
					{
						alt = "pixel";
						alt2 = 'pixel';
					}
	
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
	
					var daType = songNotes[3];
					var swagNote:Note;
	
					if (changeArrows)
					{
						if (gottaHitNote) {
							swagNote = new Note(daStrumTime, daNoteData, oldNote, false, daType, SONG.bfNoteStyle);
						} else {
							swagNote = new Note(daStrumTime, daNoteData, oldNote, false, daType, SONG.dadNoteStyle);
						}
					}
					else
					{
						if (gottaHitNote) {
							swagNote = new Note(daStrumTime, daNoteData, oldNote, false, daType, alt2);
						} else {
							swagNote = new Note(daStrumTime, daNoteData, oldNote, false, daType, alt);
						}
					}	
					swagNote.sustainLength = songNotes[2];
					swagNote.scrollFactor.set(0, 0);
					swagNote.dType = section.dType;
	
					switch (section.dType)
					{
						case 0:
							daMisser = boyfriend;
						case 1:
							daMisser = boyfriend1;
						case 2:
							daMisser = boyfriend2;
						case 3:
							daMisser = boyfriend3;	
					}
	
					var susLength:Float = swagNote.sustainLength;
	
					susLength = susLength / Conductor.stepCrochet;
					unspawnNotes.push(swagNote);
	
					for (susNote in 0...Math.floor(susLength))
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
	
						var sustainNote:Note;
						if (changeArrows)
						{
							if (gottaHitNote) {
								sustainNote = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType, SONG.bfNoteStyle);
							} else {
								sustainNote = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType, SONG.dadNoteStyle);
							}
						}
						else
						{
							if (gottaHitNote) {
								sustainNote = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType, alt2);
							} else {
								sustainNote = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType, alt);
							}
						}	
						sustainNote.scrollFactor.set();
						sustainNote.dType = section.dType;
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
			}
			else
			{
				for (songNotes in section.sectionNotes)
				{
					alt = dad.noteSkin;
					alt2 = boyfriend.noteSkin;
					
					if (section.isPixel)
					{
						if (SONG.noteStyle == 'doki')
						{
							alt = "doki-pixel";
							alt2 = 'doki-pixel';
						}
						else
						{
							alt = "pixel";
							alt2 = 'pixel';
						}
					}
	
					var daStrumTime:Float = songNotes[0];
					var daNoteData:Int = Std.int(songNotes[1] % mn);
	
					var gottaHitNote:Bool = section.mustHitSection;
	
					if (songNotes[1] >= mn)
						gottaHitNote = !section.mustHitSection;
					
					var oldNote:Note;
					if (unspawnNotes.length > 0)
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					else
						oldNote = null;
	
					var daType = songNotes[3];
					var swagNote:Note;
	
					if (changeArrows)
					{
						if (gottaHitNote) {
							swagNote = new Note(daStrumTime, daNoteData, oldNote, false, daType, SONG.bfNoteStyle);
						} else {
							swagNote = new Note(daStrumTime, daNoteData, oldNote, false, daType, SONG.dadNoteStyle);
						}
					}
					else
					{
						if (gottaHitNote) {
							swagNote = new Note(daStrumTime, daNoteData, oldNote, false, daType, alt2);
						} else {
							swagNote = new Note(daStrumTime, daNoteData, oldNote, false, daType, alt);
						}
					}	
					swagNote.sustainLength = songNotes[2];
					swagNote.scrollFactor.set(0, 0);
					swagNote.dType = section.dType;

					if (swagNote.noteType == 11)
						swagNote.dType = 1;
	
					switch (section.dType)
					{
						case 0:
							daMisser = boyfriend;
						case 1:
							daMisser = boyfriend1;
						case 2:
							daMisser = boyfriend2;
						case 3:
							daMisser = boyfriend3;	
					}
	
					var susLength:Float = swagNote.sustainLength;
	
					susLength = susLength / Conductor.stepCrochet;
					unspawnNotes.push(swagNote);
	
					for (susNote in 0...Math.floor(susLength))
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
	
						var sustainNote:Note;
						if (changeArrows)
						{
							if (gottaHitNote) {
								sustainNote = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType, SONG.bfNoteStyle);
							} else {
								sustainNote = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType, SONG.dadNoteStyle);
							}
						}
						else
						{
							if (gottaHitNote) {
								sustainNote = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType, alt2);
							} else {
								sustainNote = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType, alt);
							}
						}	
						sustainNote.scrollFactor.set();
						sustainNote.dType = section.dType;

						if (sustainNote.noteType == 11)
							sustainNote.dType = 1;

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
			}
			daSection += 1;
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

	var hudArrXPos:Array<Float>;
	var hudArrYPos:Array<Float>;
	var hudArrDadXPos:Array<Float>;
	var hudArrDadYPos:Array<Float>;

	function generateStaticArrows(player:Int, style:String, tweenShit:Bool = true, daAlpha:Float = 1):Void
	{
		switch (player)
		{
			case 1:
				hudArrXPos = [];
				hudArrYPos = [];
			case 0:
				hudArrDadXPos = [];
				hudArrDadYPos = [];
		}

		for (i in 0...keyAmmo[mania])
		{
			
			var bloodSplash:FlxSprite = new FlxSprite(0, strumLine.y - 80); // i have no idea on what am i doing
			
			if (style == 'exe')
			{
				if (player == 1)
				{
					bloodSplash.frames = Paths.getSparrowAtlas('notestuff/BloodSplash');
					bloodSplash.animation.addByPrefix('a', 'Squirt', 24, false);
					bloodSplash.animation.play('a');
					bloodSplash.antialiasing = true;
					bloodSplash.animation.curAnim.curFrame = 10;
				}
			}

			// FlxG.log.add(i);
			babyArrow = new FlxSprite(0, strumLine.y);

			//defaults if no noteStyle was found in chart
			var suf:String = "";

			switch (style)
			{
				case 'pixel' | 'pixel-corrupted' | 'neon' | 'doki-pixel':
					switch (style)
					{
						case 'pixel-corrupted':
							suf = '-corrupted';
						case 'neon':
							suf = '-neon';
						case 'doki-pixel':
							suf = '-doki';
					}
					babyArrow.loadGraphic(Paths.image('notestuff/arrows-pixels'+suf), true, 17, 17);
					
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
				
				case 'normal' | 'auditor' | 'gray' | 'corrupted' | 'cross' | 'taki' | 'kapi' | '1930' | 'agoti' | 'fever' | 'void' | 'shootin' | 'holofunk' | 'trollge' | 'starecrown'
				| 'tabi' | 'sketchy' | 'darker' | 'doki' | 'nyan' | 'bf-b&b' | 'amor' | 'bluskys' | 'bob' | 'bosip' | 'ron' | 'gloopy' | 'party-crasher' | 'eteled' | 'austin' | 'stepmania'
				| 'littleman':
					switch (style)
					{
						case 'auditor':
							babyArrow.frames = Paths.getSparrowAtlas('notestuff/NOTE_assets');
						default:
							babyArrow.frames = Paths.getSparrowAtlas('notestuff/'+style);
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
				case 'exe':
					babyArrow.frames = Paths.getSparrowAtlas('notestuff/exe');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					var nSuf:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
					var pPre:Array<String> = ['left', 'down', 'up', 'right'];

					switch (mania)
					{
						case 3:
							nSuf = ['LEFT', 'DOWN', 'SPACE', 'UP', 'RIGHT'];
							pPre = ['left', 'down', 'space', 'up', 'right'];
					}

					if (mania == 3)
					{
						if (player == 0)
						{
							if (i > 2)
								babyArrow.x += Note.swagWidth * (i - 1);
							else
								babyArrow.x += Note.swagWidth * i;
	
							if (i == 2)
								babyArrow.visible = false;
						}
							
						if (player == 1)
							babyArrow.x += Note.swagWidth * i;
					}
					else
						babyArrow.x += Note.swagWidth * i;
				
					
					babyArrow.animation.addByPrefix('static', 'arrow' + nSuf[i]);
					babyArrow.animation.addByPrefix('pressed', pPre[i] + ' press', 24, false);
					babyArrow.animation.addByPrefix('confirm', pPre[i] + ' confirm', 24, false);

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

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

				case 'guitar':
					babyArrow.frames = Paths.getSparrowAtlas('notestuff/GH_NOTES');
					babyArrow.animation.addByPrefix('green', 'upNoteBaby');
					babyArrow.animation.addByPrefix('blue', 'downNoteBaby');
					babyArrow.animation.addByPrefix('purple', 'leftNoteBaby');
					babyArrow.animation.addByPrefix('red', 'rightNoteBaby');
	
					babyArrow.antialiasing = true;
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'leftNoteBaby');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'downNoteBaby');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'upNoteBaby');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'rightNoteBaby');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('notestuff/'+style);
					
					if (babyArrow.frames == null)
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

			if (((isMania && i != 2) || !isMania) && player == 1 && style == 'exe')
			{
				bloodSplash.x = babyArrow.x + 520;
				playerSplashes.add(bloodSplash);
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();
			
			if (!isStoryMode && tweenShit)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: daAlpha}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			if ((isMania && i != 2) || !isMania && player == 1 && style == 'exe')
				bloodSplash.ID = i;
			else if (isMania && i == 2 && player == 1 && style == 'exe')
				bloodSplash.ID = -1;

			babyArrow.ID = i;
			
			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
					hudArrDadXPos.push(babyArrow.x);
					hudArrDadYPos.push(babyArrow.y);
				case 1:
					playerStrums.add(babyArrow);
					hudArrXPos.push(babyArrow.x);
					hudArrYPos.push(babyArrow.y);
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

	private function appearStaticArrows():Void
	{
		var index = 0;
		strumLineNotes.forEach(function(babyArrow:FlxSprite)
		{
			if (isStoryMode && !FlxG.save.data.middleScroll || executeModchart)
				babyArrow.alpha = 1;
			if (index > 3 && FlxG.save.data.middleScroll)
				babyArrow.alpha = 1;
			index++;
		});
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

	var vignette:FlxSprite;
	var addedVignette:Bool = false;

	public function toggleHealthShit(id:Bool) //cuz modcharts don't hide them immediately for some reason
	{
		if (id)
		{
			healthBarBG.visible = false;
			healthBar.visible = false;
			iconP1.visible = false;
			iconP2.visible = false;
			scoreTxt.visible = false;
		}

		if (!id)
		{
			healthBarBG.visible = true;
			healthBar.visible = true;
			iconP1.visible = true;
			iconP2.visible = true;
			scoreTxt.visible = true;
		}
	}

	var healthDrop:Float = 0;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (usesStageHx)
			Stage.update(elapsed);

		if (SONG.noteStyle == 'exe' && mania == 3)
			counterNum.text = Std.string(cNum);

		health -= healthDrop;

		switch (SONG.song.toLowerCase())
		{
			case 'senpai':
				if (DialogueBox.curCharacter == 'senpai-angry' && dad.curCharacter != 'senpai-angry')
					changeDadCharacter(250, 460, 'senpai-angry');
				else if (DialogueBox.curCharacter == 'senpai' && dad.curCharacter != 'senpai')
					changeDadCharacter(250, 460, 'senpai');			
			case 'ballistic':
				if (DialogueBox.curCharacter == 'pico-dark' && dad.curCharacter != 'picoCrazy')
					changeDadCharacter(100, 400, 'picoCrazy');
			case 'bi-nb':
				if (chromOn){
		
					ch = FlxG.random.int(1,5) / 1000;
					ch = FlxG.random.int(1,5) / 1000;
					ShadersHandler.setChrome(ch);
					//ShadersHandler.setRadialBlur(640+(FlxG.random.int(-100,100)),360+(FlxG.random.int(-100,100)),FlxG.random.float(0.001,0.005));
					ShadersHandler.setRadialBlur(640+(FlxG.random.int(-10,10)),360+(FlxG.random.int(-10,10)),FlxG.random.float(0.001,0.005));
				}else{
					ShadersHandler.setChrome(0);
					ShadersHandler.setRadialBlur(0,0,0);
					
				}	
		}

		switch (curStage)
		{
			case 'pokecenter':
				if (!dad.curCharacter.contains('hypno'))
					dad.color = FlxColor.fromHSL(dad.color.hue, dad.color.saturation, 0.65, 1);
			case 'genocide':
				if (!addedVignette)
				{
					vignette = new FlxSprite().loadGraphic(Paths.image('tabi/fire/vignette'));
					vignette.width = 1280;
					vignette.height = 720;
					vignette.x = 0;
					vignette.y = 0;
					vignette.updateHitbox();
					add(vignette);
					vignette.cameras = [camHUD];
					vignette.alpha = 1;
					addedVignette = true;
				}
			case 'demon-training':
				if (minusHealth && curStep >= 1024 && curStep < 1280)
				{
					if (health > 0)
						health -= 0.001 * (elapsed / (1/(cast (Lib.current.getChildAt(0), Main)).getFPS()));
				}
			case 'hallway':
				gf.color = FlxColor.fromHSL(gf.color.hue, gf.color.saturation, 0.5, 1);
			case 'philly-wire':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
			case 'tank':
				moveTank();
			case 'limoholo-night':
				var rotRateBl = (curStep / 9.5) * 1.2;
				
				var bl_toy = -8500 + -Math.sin(rotRateBl * 2) * bl_r * 0.45;
				var bl_tox = 50 - Math.cos(rotRateBl) * bl_r;

				blantadBG.x += (bl_tox - blantadBG.x) / 12;
				blantadBG.y += (bl_toy - blantadBG.y) / 12;
			case 'ballisticAlley':
				if (health != 2)
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
		}

		if (rushiaOverlayFrame > 0) 
		{
			rushiaOverlayFrame--;

			if (dad.curCharacter == 'zipper')
			{
				zipperScreamOverlay.visible = true;
				
				if (rushiaOverlayFrame <= 3)
					zipperScreamOverlay.alpha = (rushiaOverlayFrame / 3) * 0.8;
				if (rushiaOverlayFrame == 0)
					zipperScreamOverlay.visible = false;
			}

			if (dad.curCharacter == 'peri')
			{
				periScreamOverlay.visible = true;
				
				if (rushiaOverlayFrame <= 3)
					periScreamOverlay.alpha = (rushiaOverlayFrame / 3) * 0.8;
				if (rushiaOverlayFrame == 0)
					periScreamOverlay.visible = false;
			}
				
			rushiaScreamOverlay.visible = true;
	
			var newShader:ColorSwap = new ColorSwap();
			rushiaScreamOverlay.shader = newShader.shader;

			if (dad.curCharacter == 'alucard')
				newShader.hue = -125 / 360;
			else
				newShader.hue = 0 / 360;
			
			if (rushiaOverlayFrame <= 3)
				rushiaScreamOverlay.alpha = (rushiaOverlayFrame / 3) * 0.8;
			if (rushiaOverlayFrame == 0)
				rushiaScreamOverlay.visible = false;
		}

		//it's here now. 
		var coolTankmen:Array<String> = ['tankman', 'tankman-bw'];
		var noSwapSenpais:Array<String> = ['hd-senpai-dark', 'bf-hd-senpai-dark', 'bf-hd-senpai-worried'];

		if (coolTankmen.contains(boyfriend.curCharacter))
		{
			var bwShit:String = "";

			switch (boyfriend.curCharacter)
			{
				case 'tankman': bwShit = "";		
				case 'tankman-bw': bwShit = '-bw';		
			}

			if (dad.curCharacter.contains('senpai') && !dad.curCharacter.contains('angry') && !dad.curCharacter.contains('ghosty'))
			{
				if (newIcons)
					iconP1.changeIcon('tankman-happy' + bwShit);
				else
					iconP1.useOldSystem('tankman-happy' + bwShit);
			}			
			else
			{
				if (newIcons)
					iconP1.changeIcon('tankman' + bwShit);	
				else
					iconP1.useOldSystem('tankman' + bwShit);	
			}
									
		}

		if (coolTankmen.contains(dad.curCharacter))
		{
			var bwShit:String = "";

			switch (dad.curCharacter)
			{
				case 'tankman': bwShit = "";		
				case 'tankman-bw': bwShit = '-bw';		
			}

			if (boyfriend.curCharacter.contains('senpai') && !boyfriend.curCharacter.contains('angry') && !boyfriend.curCharacter.contains('ghosty'))
				iconP2.useOldSystem('tankman-happy' + bwShit);
			else 
				iconP2.useOldSystem('tankman' + bwShit);	
		}

		if (dad.curCharacter.contains('hd-senpai'))
		{
			var bwShit:String = "";

			switch (dad.curCharacter)
			{
				case 'hd-senpai-giddy-bw': bwShit = '-bw';	
				case 'hd-senpai-giddy-b3' | 'hd-senpai-angry-b3': bwShit = '-b3';
			}

			//if senpai is dad
			if ((boyfriend.curCharacter.contains('tankman') || boyfriend.curCharacter.contains('monika') || boyfriend.curCharacter.contains('aloe') || boyfriend.curCharacter.contains('bf-nene')))
			{
				if (newIcons)
					iconP2.changeIcon('hd-senpai-giddy' + bwShit);
				else
					iconP2.useOldSystem('hd-senpai-giddy' + bwShit);
			}		
			else
			{
				if (triple && dad2.curCharacter == 'tankman')
					'';
				else
				{
					if (newIcons)
						iconP2.changeIcon('hd-senpai-angry' + bwShit);
					else
						iconP2.useOldSystem('hd-senpai-angry' + bwShit);
				}			
			}	
		}

		if (boyfriend.curCharacter.contains('hd-senpai') && !noSwapSenpais.contains(boyfriend.curCharacter))
		{
			var bwShit:String = "";

			switch (boyfriend.curCharacter)
			{
				case 'hd-senpai-giddy-bw': bwShit = '-bw';	
				case 'hd-senpai-giddy-b3' | 'hd-senpai-angry-b3': bwShit = '-b3';
			}
			
			if ((dad.curCharacter.contains('tankman') || dad.curCharacter.contains('monika') || dad.curCharacter.contains('aloe') || dad.curCharacter.contains('bf-nene')))
				iconP1.useOldSystem('hd-senpai-giddy' + bwShit);
			else
			{
				if (triple && boyfriend2.curCharacter == 'tankman')
					'';
				else
					iconP1.useOldSystem('hd-senpai' + bwShit);	
			}	
		}

		if (addedVignette)
		{
			if (vignette.frames != null && curStage == 'genocide')
				vignette.alpha = 1 - (health / 2);
			else if (curStage != 'genocide')
			{
				vignette.alpha = 0;
				vignette.destroy();
			}
		}
			
		if (regenerateDadArrows)
			updateStaticNotes(dad.noteSkin);

		if (curStage == 'auditorHell' && dad.curCharacter != 'exTricky' && hole.frames != null && hole.alpha != 0 && executeModchart)
		{
			hole.alpha = 0;
			converHole.alpha = 0;
			cover.alpha = 0;
			cloneOne.visible = false;
			cloneTwo.visible = false;
		}

		if (curStage == 'auditorHell' && dad.curCharacter == 'exTricky' && hole.frames != null && hole.alpha != 1)
		{
			hole.alpha = 1;
			converHole.alpha = 1;
			cover.alpha = 1;
			cloneOne.visible = true;
			cloneTwo.visible = true;
		}

		if (shakeCam2)
			FlxG.camera.shake(0.0025, 0.10);

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
			FlxG.save.data.botplay = !FlxG.save.data.botplay;
		if (FlxG.keys.justPressed.SIX)
			healthSet = !healthSet;
		#end

		if (healthSet) health = 1;

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
			doFloatShit();

		if (dad.curCharacter != 'sarvente-lucifer' && dad.curCharacter != 'sh-carol' && doingFloatShit)
			doingFloatShit = false;

		if (boyfriend.curCharacter != 'sarvente-lucifer' && boyfriend.curCharacter != 'sh-carol' && doingFloatShit)
			doingBoyfriendFloatShit = false;

		if ((boyfriend.curCharacter == 'sarvente-lucifer' || boyfriend.curCharacter == 'sh-carol') && !doingBoyfriendFloatShit)
			doBFFloatShit();

		if (!dad.curCharacter.contains('spirit') && !removedTrail && curStage == 'schoolEvild4')
			remove(evilTrail);
			removedTrail = true;

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
				iconP2.useOldSystem('momosuzu');
			if (dad.animation.curAnim.name.startsWith('singRIGHT'))
				iconP2.useOldSystem('gfandbf');
			if (dad.animation.curAnim.name.startsWith('singUP'))
				iconP2.useOldSystem('gf');
			if (dad.animation.curAnim.name.startsWith('singDOWN'))
				iconP2.useOldSystem('boygf');
			if (dad.animation.curAnim.name.startsWith('dance'))
				iconP2.useOldSystem('gfandbf');
		}
		if (dad.curCharacter == 'gf2')
		{
			if (dad.animation.curAnim.name.startsWith('singLEFT'))
				iconP2.useOldSystem('bf-senpai-flippin');
			if (dad.animation.curAnim.name.startsWith('singRIGHT'))
				iconP2.useOldSystem('bf-senpai-flippin');
			if (dad.animation.curAnim.name.startsWith('singUP'))
				iconP2.useOldSystem('gf-rincewind');
			if (dad.animation.curAnim.name.startsWith('singDOWN'))
				iconP2.useOldSystem('gf-lemon');
			if (dad.animation.curAnim.name.startsWith('dance'))
				iconP2.useOldSystem('bf-senpai-flippin');
		}
		if (dad.curCharacter == 'gf3')
		{
			if (dad.animation.curAnim.name.startsWith('singLEFT'))
				iconP2.useOldSystem('gf-lapis');
			if (dad.animation.curAnim.name.startsWith('singRIGHT'))
				iconP2.useOldSystem('gf-kanna');
			if (dad.animation.curAnim.name.startsWith('singUP'))
				iconP2.useOldSystem('gf-moony');
			if (dad.animation.curAnim.name.startsWith('singDOWN'))
				iconP2.useOldSystem('gf-kaity');
			if (dad.animation.curAnim.name.startsWith('dance'))
				iconP2.useOldSystem('gf-kanna');
		}
		if (dad.curCharacter == 'gf4')
		{
			if (dad.animation.curAnim.name.startsWith('singLEFT'))
				iconP2.useOldSystem('gf-aubrey');
			if (dad.animation.curAnim.name.startsWith('singRIGHT'))
				iconP2.useOldSystem('bf-carol');
			if (dad.animation.curAnim.name.startsWith('singUP'))
				iconP2.useOldSystem('gf-chara');
			if (dad.animation.curAnim.name.startsWith('singDOWN'))
				iconP2.useOldSystem('gf-drip');
			if (dad.animation.curAnim.name.startsWith('dance'))
				iconP2.useOldSystem('bf-carol');
		}
		if (dad.curCharacter == 'gf5')
		{
			if (dad.animation.curAnim.name.startsWith('singLEFT'))
				iconP2.useOldSystem('gf-troll');
			if (dad.animation.curAnim.name.startsWith('singRIGHT'))
				iconP2.useOldSystem('gf');
			if (dad.animation.curAnim.name.startsWith('singUP'))
				iconP2.useOldSystem('gf-fugo');
			if (dad.animation.curAnim.name.startsWith('singDOWN'))
				iconP2.useOldSystem('starzgf');
			if (dad.animation.curAnim.name.startsWith('dance'))
				iconP2.useOldSystem('starzgf');
		}
		if (boyfriend.curCharacter == 'bf1')
		{
			if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
				iconP1.useOldSystem('gfandbf');
			if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
				iconP1.useOldSystem('bf-aloe');
			if (boyfriend.animation.curAnim.name.startsWith('singUP'))
				iconP1.useOldSystem('girlbf');
			if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
				iconP1.useOldSystem('bf');
			if (boyfriend.animation.curAnim.name.startsWith('idle'))
				iconP1.useOldSystem('bf-aloe');
		}

		if (boyfriend.curCharacter == 'bf2')
		{
			if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
				iconP1.useOldSystem('bf-senpai-flippin');
			if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
				iconP1.useOldSystem('bf-senpai-flippin');
			if (boyfriend.animation.curAnim.name.startsWith('singUP'))
				iconP1.useOldSystem('bf-pico');
			if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
				iconP1.useOldSystem('bf-rincewind');
			if (boyfriend.animation.curAnim.name.startsWith('idle'))
				iconP1.useOldSystem('bf-senpai-flippin');
		}

		if (boyfriend.curCharacter == 'bf3')
		{
			if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
				iconP1.useOldSystem('bf-ryuko');
			if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
				iconP1.useOldSystem('bf-peridot');
			if (boyfriend.animation.curAnim.name.startsWith('singUP'))
				iconP1.useOldSystem('bf-chris');
			if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
				iconP1.useOldSystem('bf-ena');
			if (boyfriend.animation.curAnim.name.startsWith('idle'))
				iconP1.useOldSystem('bf-peridot');
		}

		if (boyfriend.curCharacter == 'bf4')
		{
			if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
				iconP1.useOldSystem('bf-omori');
			if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
				iconP1.useOldSystem('bf-smol-whitty');
			if (boyfriend.animation.curAnim.name.startsWith('singUP'))
				iconP1.useOldSystem('bf-frisk');
			if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
				iconP1.useOldSystem('bf-drip');
			if (boyfriend.animation.curAnim.name.startsWith('idle'))
				iconP1.useOldSystem('bf-smol-whitty');
		}

		if (boyfriend.curCharacter == 'bf5')
		{
			if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
				iconP1.useOldSystem('bf-troll');
			if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
				iconP1.useOldSystem('bf');
			if (boyfriend.animation.curAnim.name.startsWith('singUP'))//
				iconP1.useOldSystem('bf-narancia');
			if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
				iconP1.useOldSystem('bf-starzchan');
			if (boyfriend.animation.curAnim.name.startsWith('idle'))
				iconP1.useOldSystem('bf-starzchan');
		}

		if (dad.curCharacter == 'eddsworld-switch')
		{
			if (dad.animation.curAnim.name.startsWith('singLEFT'))
				iconP2.useOldSystem('matt2');
			if (dad.animation.curAnim.name.startsWith('singRIGHT'))
				iconP2.useOldSystem('tord2');
			if (dad.animation.curAnim.name.startsWith('singUP'))
				iconP2.useOldSystem('edd2');
			if (dad.animation.curAnim.name.startsWith('singDOWN'))
				iconP2.useOldSystem('tom2');
			if (dad.animation.curAnim.name.startsWith('idle'))
				iconP2.useOldSystem('tord2');
		}

		if (boyfriend.curCharacter == 'bf-fnf-switch')
		{
			if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
				iconP1.useOldSystem('dad');
			if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
				iconP1.useOldSystem('gf');
			if (boyfriend.animation.curAnim.name.startsWith('singUP'))
				iconP1.useOldSystem('pico');
			if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
				iconP1.useOldSystem('bf');
			if (boyfriend.animation.curAnim.name.startsWith('idle'))
				iconP1.useOldSystem('bf');
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
				health -= 0.001 * (elapsed / (1/ (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		}

		if (dad.curCharacter == 'dad' && (boyfriend.curCharacter == 'bf-gf' || boyfriend.curCharacter == 'bf-gf-demon')  && curSong == 'Demon-Training')
			iconP2.useOldSystem('dad-happy');

		if (boyfriend.curCharacter.startsWith('spooky') || boyfriend.curCharacter.startsWith('gold'))
			iconP1.flipX = true;
		else
			iconP1.flipX = false;
		
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

		#if windows
		if (luaModchart != null)
		{
			if (luaModchart.getVar("newIcons",'bool'))
				newIcons = true;
			else
				newIcons = false;

			var iconSwitch = luaModchart.getVar("swapIcons",'bool');
			swapIcons = iconSwitch;
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
				iconP1.useOldSystem(boyfriend.curCharacter);
			else
				if (boyfriend.curCharacter.contains('-car'))
					bfCharacter = boyfriend.curCharacter.split('-')[0];

				if (iconP1.animation.getByName(bfCharacter+'-old') != null)
					iconP1.useOldSystem(bfCharacter+'-old');
				else
					iconP1.useOldSystem('bf-old');
		}

		if (isMania && SONG.noteStyle != 'exe')
		{
			var jj:Array<Float> = [0, 3, 9];

			playerStrums.forEach(function(spr:FlxSprite)
			{
				spr.x = hudArrXPos[spr.ID];
				spr.y = hudArrYPos[spr.ID];

				if (spr.animation.curAnim.name == 'confirm')
				{
					spr.x = hudArrXPos[spr.ID] + jj[mania];
					spr.y = hudArrYPos[spr.ID] + jj[mania];
				}
			});

			cpuStrums.forEach(function(spr:FlxSprite)
			{
				spr.x = hudArrDadXPos[spr.ID];
				spr.y = hudArrDadYPos[spr.ID];

				if (spr.animation.curAnim.name == 'confirm')
				{				
					spr.x = hudArrDadXPos[spr.ID] + jj[mania];
					spr.y = hudArrDadYPos[spr.ID] + jj[mania];
				}
			});
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
			case 'nonsense-god' | 'pshaggy' | 'makocorrupt':
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
			dad.y += Math.sin(floatshit);

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > maxHealth)
			health = maxHealth;
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
			AnimationDebug.isDad = true;
			AnimationDebug.isBF = false;
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.FOUR)
		{
			FlxG.switchState(new AnimationDebug(gf.curCharacter));
			AnimationDebug.isDad = true;
			AnimationDebug.isBF = false;
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
			AnimationDebug.isDad = false;
			AnimationDebug.isBF = true;
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if(FlxG.keys.justPressed.THREE) { //Go 10 seconds into the future, credit: Shadow Mario#9396
			if (!usedTimeTravel && Conductor.songPosition + 10000 < FlxG.sound.music.length) 
			{
				usedTimeTravel = true;
				FlxG.sound.music.pause();
				vocals.pause();
				Conductor.songPosition += 10000;
				notes.forEachAlive(function(daNote:Note)
				{
					if(daNote.strumTime - 500 < Conductor.songPosition) {
						daNote.active = false;
						daNote.visible = false;
					
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
				for (i in 0...unspawnNotes.length) {
					var daNote:Note = unspawnNotes[0];
					if(daNote.strumTime - 500 >= Conductor.songPosition) {
						break;
					}
					unspawnNotes.splice(unspawnNotes.indexOf(daNote), 1);
				}
				FlxG.sound.music.time = Conductor.songPosition;
				FlxG.sound.music.play();
				vocals.time = Conductor.songPosition;
				vocals.play();
				new FlxTimer().start(0.5, function(tmr:FlxTimer)
					{
						usedTimeTravel = false;
					});
			}
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
				if (curStage == 'night') {
					var coolGlowyLights = Stage.swagGroup['coolGlowyLights'];
					var coolGlowyLightsMirror = Stage.swagGroup['coolGlowyLightsMirror'];

					for (i in coolGlowyLights) {
						i.flipX = false;
					}
					for (i in coolGlowyLightsMirror) {
						i.flipX = true;
					}	
				}

				var offsetX = 0;
				var offsetY = 0;

				lockedCamera = false;

				if (curSong == 'Gun-Buddies')
					offsetY = 50;

				switch (curStage)
				{
					case 'curse': offsetX = 430;
					case 'stadium' | 'ripdiner' | 'motherland' | 'hallway' | 'concert': lockedCamera = true;
					case 'clubroomevil': if (storyDifficulty == 5 && dad.curCharacter != 'bigmonika') lockedCamera = true;
					case 'reactor' | 'reactor-m': camFollowIsOn = false;
					default: lockedCamera = false;
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

					if (dad.isCustom)
					{
						camFollow.x += dad.cameraPosition[0];
						camFollow.y += dad.cameraPosition[1];
					}
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
					case 'night':
						camFollow.x = FlxMath.lerp(295.92, camFollow.x, 0.1) + offsetX;
						camFollow.y = FlxMath.lerp(447.52, camFollow.y, 0.1) + offsetY;
					case 'stadium':
						camFollow.x = 530 + offsetX;
						camFollow.y = 610 + offsetY;
						lockedCamera = true;
					case 'ripdiner':
						camFollow.x = 736 + offsetX;
						camFollow.y = 544.5 + offsetY;
						lockedCamera = true;
					case 'ITB':
						camFollow.x = FlxMath.lerp(272.46, camFollow.x, 0.1) + offsetX;
						camFollow.y = FlxMath.lerp(420.96, camFollow.y, 0.1) + offsetY;
					case 'clubroomevil':
						if (storyDifficulty == 5 && dad.curCharacter != 'bigmonika' && curStep < 2344)
						{
							camFollow.y = dad1.getMidpoint().y + 50 + offsetY;
							camFollow.x = dad1.getMidpoint().x - 250 + offsetX;
						}	
						else if (storyDifficulty == 5)
						{
							camFollow.y = dad1.getMidpoint().y - 75 + offsetY;
							camFollow.x = dad1.getMidpoint().x + offsetX;
						}
					case 'motherland':
						if (defaultCamZoom >= 1.7)
						{
							camFollow.y = gf.getMidpoint().y + 110 + offsetY;
							camFollow.x = gf.getMidpoint().x - 480 + offsetX;
						}
						else if (defaultCamZoom == 0.80)
						{
							camFollow.y = gf.getMidpoint().y + 90 + offsetY;
							camFollow.x = gf.getMidpoint().x - 250 + offsetX;
						}
						else
						{
							camFollow.y = gf.getMidpoint().y - 60 + offsetY;
							camFollow.x = gf.getMidpoint().x - 200 + offsetX;
						}
					case 'hallway':
						camFollow.x = 657.81 + offsetX;
						switch (dad.curCharacter) {
							case 'austin':
								camFollow.y = 400.56 + offsetY;
							default:
								camFollow.y = 501.56 + offsetY;
						}
					case 'concert':
						camFollow.y = gf.getMidpoint().y - 25 + offsetY;
						camFollow.x = gf.getMidpoint().x - 25 + offsetX;
				}

				if (!lockedCamera)
				{
					switch (dad.curCharacter)
					{
						case 'mom' | 'b3-mom-sad' | 'b3-mom-mad' | 'rebecca' | 'mom-sad-blue' | 'exe-front':
							camFollow.y = dad.getMidpoint().y - 50 + offsetY;
						case 'doxxie':
							camFollow.y = dad.getMidpoint().y - 50 + offsetY;
							camFollow.x = dad.getMidpoint().x + 100 + offsetX;
						case 'duet-sm':
							camFollow.y = dad.getMidpoint().y - 400 + offsetY;
							camFollow.x = dad.getMidpoint().x + 0 + offsetX;
						case 'yukichi-police':  
							camFollow.x = dad.getMidpoint().x + 423;
							camFollow.y = dad.getMidpoint().y - 280;
						case 'sayori-blue':
							camFollow.y = dad.getMidpoint().y - 400 + offsetY;
							camFollow.x = dad.getMidpoint().x + 100 + offsetX;
						case 'oswald-happy' | 'oswald-angry':
							camFollow.x = dad.getMidpoint().x + 90 + offsetX;
							camFollow.y = dad.getMidpoint().y + 60 + offsetY;
						case 'sh-carol':
							camFollow.x = dad.getMidpoint().x + 250 + offsetX;
							camFollow.y = dad.getMidpoint().y + offsetY;
						case 'bf-annie':
							camFollow.x = dad.getMidpoint().x + 250 + offsetX;
							camFollow.y = dad.getMidpoint().y - 150 + offsetY;
						case 'botan':
							camFollow.x = dad.getMidpoint().x + 50 + offsetX; 	
							camFollow.y = dad.getMidpoint().y - 100 + offsetY;	
						case 'exe-revie':
							camFollow.x = dad.getMidpoint().x - 50 + offsetX; 	
							camFollow.y = dad.getMidpoint().y - 300 + offsetY;	
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
						case 'senpai' | 'senpai-angry' | 'senpai-giddy' | 'glitch' | 'glitch-angry' | 'monika' | 'monster-pixel' | 'monika-angry' | 'green-monika' | 'neon' | 'baldi-angry-pixel' | 'matt-angry' | 'mario-angry' | 'colt-angry' | 'kristoph-angry' | 'chara-pixel' | 'colt-angryd2' | 'colt-angryd2corrupted' | 'jackson':
							camFollow.y = dad.getMidpoint().y - 430 + offsetY;
							camFollow.x = dad.getMidpoint().x - 100 + offsetX;
						case 'void':
							camFollow.y = dad.getMidpoint().y - 50;
						case 'cassandra' | 'cassandra-bw':
							camFollow.y = dad.getMidpoint().y + 75 + offsetY;
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
						case 'monika-finale':
							camFollow.y = dad.getMidpoint().y - 390;
							camFollow.x = dad.getMidpoint().x - 250;
						case 'momi':
							camFollow.x = dad.getMidpoint().x + 200 + offsetX; 
						case 'bf-sky' | 'sky-annoyed' | 'sky-happy' | 'sky-mad' | 'sky-pissed':
							camFollow.y = boyfriend.getMidpoint().y - 200 + offsetY;
						case 'gf-crucified':
							camFollow.y = dad.getMidpoint().y + offsetY;
						case 'anchor-bowl':
							camFollow.y = dad.getMidpoint().y + 50 + offsetY;
						case 'eteled2':
							camFollow.y = dad.getMidpoint().y - 200 + offsetY;
						case 'exe':
							camFollow.x = dad.getMidpoint().x + 50 + offsetX;
						case 'kb':
							camFollow.y = dad.getMidpoint().y + 25 + offsetY;
							camFollow.x = dad.getMidpoint().x - 18 + offsetX;
						case 'bf-sonic':
							camFollow.x = dad.getMidpoint().x + 250 + offsetX;
						case 'yuri':
							camFollow.x = dad.getMidpoint().x + 200 + offsetX;
						case 'bigmonika':
							camFollow.y = dad.getMidpoint().y - 75 + offsetY;
							camFollow.x = dad.getMidpoint().x + offsetX;
						case 'crazygf' | 'haachama-blue' | 'sunky' | 'lord-x' | 'maijin-new-flipped':
							camFollow.y = dad.getMidpoint().y - 100 + offsetY;
							camFollow.x = dad.getMidpoint().x + 149 + offsetX;						
					}
				}		

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial-remix' || SONG.player2 == 'tordbot')
				{
					tweenCamIn();
				}

				if (curStage == 'curse')
					FlxTween.tween(FlxG.camera, {zoom: 0.6}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});

				if (SONG.song.toLowerCase() == 'endless' || SONG.song.toLowerCase() == 'triple-trouble')
				{
					camFollow.x += dadCamX;
					camFollow.y += dadCamY;
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				if (curStage == 'night') {
					var coolGlowyLights = Stage.swagGroup['coolGlowyLights'];
					var coolGlowyLightsMirror = Stage.swagGroup['coolGlowyLightsMirror'];
					for (i in coolGlowyLights) {
						i.flipX = true;
					}
					for (i in coolGlowyLightsMirror) {
						i.flipX = false;
					}
				}

				var offsetX = 0;
				var offsetY = 0;
				var lockedCamera:Bool = false;

				if (curSong == 'Gun-Buddies')
				{
					offsetY = 50;
				}

				switch (curStage)
				{
					case 'curse': offsetX = -330;
					case 'stadium' | 'ripdiner' | 'motherland' | 'hallway' | 'concert': lockedCamera = true;
					case 'clubroomevil': if(storyDifficulty == 5) lockedCamera = true;
					case 'room':
						offsetX = -200;
						if (boyfriend.curCharacter.startsWith('tankman'))
							offsetY = -100;
				}

				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followBFXOffset", "float");
					offsetY = luaModchart.getVar("followBFYOffset", "float");
				}
				#end

				if (camFollowIsOn)
				{
					camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);

					if (boyfriend.isCustom)
					{
						camFollow.x -= boyfriend.cameraPosition[0];
						camFollow.y += boyfriend.cameraPosition[1];
					}
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
					case 'mall' | 'mallSoft' | 'sofdeez':
						camFollow.y = boyfriend.getMidpoint().y - 200 + offsetY;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200 + offsetX;
						camFollow.y = boyfriend.getMidpoint().y - 200 + offsetY;
					case 'school-switch':
						camFollow.x = boyfriend.getMidpoint().x - 200 + offsetX;
						camFollow.y = boyfriend.getMidpoint().y - 200 + offsetY;
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
						camFollow.x = boyfriend.getMidpoint().x - 200 + offsetX;
						camFollow.y = boyfriend.getMidpoint().y - 200 + offsetY;
					case 'schoolEvil' | 'schoolEvild4' | 'school-monika-finale':
						camFollow.x = boyfriend.getMidpoint().x - 200 + offsetX;
						camFollow.y = boyfriend.getMidpoint().y - 200 + offsetY;
					case 'day' | 'sunset':
						camFollow.x = 818.96 + offsetX;
						camFollow.y = 475.95 + offsetY;
					case 'garage':
						camFollow.x = boyfriend.getMidpoint().x - 220 + offsetX;
						camFollow.y = boyfriend.getMidpoint().y - 200 + offsetY;
					case 'churchsarv' | 'churchruv' | 'churchselever':
						camFollow.y = boyfriend.getMidpoint().y - 150 + offsetY;
					case 'takiStage': 
						camFollow.x = boyfriend.getMidpoint().x - 250 + offsetX;
						camFollow.y = boyfriend.getMidpoint().y - 200 + offsetY;
					case 'night':
						camFollow.x = FlxMath.lerp(790.36, camFollow.x, 0.1) + offsetX;
						camFollow.y = FlxMath.lerp(480.91, camFollow.y, 0.1) + offsetY;
					case 'ITB':
						camFollow.x = FlxMath.lerp(626.31, camFollow.x, 0.1) + offsetX;
						camFollow.y = FlxMath.lerp(420.96, camFollow.y, 0.1) + offsetY;
					case 'stadium':
						camFollow.x = 844.5 + offsetX;
						camFollow.y = 610 + offsetY;
					case 'ripdiner':
						camFollow.x = 736 + offsetX;
						camFollow.y = 544.5 + offsetY;
						lockedCamera = true;
					case 'motherland':
						if (defaultCamZoom >= 1.7)
						{
							camFollow.y = gf.getMidpoint().y + 110 + offsetY;
							camFollow.x = gf.getMidpoint().x + 480 + offsetX;
						}
						else if (defaultCamZoom == 0.80)
						{
							camFollow.y = gf.getMidpoint().y + 90 + offsetY;
							camFollow.x = gf.getMidpoint().x + 250 + offsetX;
						}
						else
						{
							camFollow.y = gf.getMidpoint().y - 60 + offsetY;
							camFollow.x = gf.getMidpoint().x + 200 + offsetX;
						}
					case 'clubroomevil':
						if (storyDifficulty == 5)
						{
							camFollow.y = dad1.getMidpoint().y + 50 + offsetY;
							camFollow.x = dad1.getMidpoint().x + 250 + offsetX;
						}		
					case 'airplane':
						camFollow.setPosition(boyfriend.getMidpoint().x - 300 + offsetX, boyfriend.getMidpoint().y - 300 + offsetY);
					case 'hallway':
						camFollow.x = 1176.3 + offsetX;
						switch (boyfriend.curCharacter) {
							case 'austin':
								camFollow.y = 400.87 + offsetY;
							default:
								camFollow.y = 515.87 + offsetY;
						}
					case 'concert':
						camFollow.y = gf.getMidpoint().y - 25 + offsetY;
						camFollow.x = gf.getMidpoint().x - 25 + offsetX;
					case 'dokiclubroom-sayori' | 'dokiclubroom-natsuki' | 'dokiclubroom-yuri' | 'dokiclubroom-monika':
						camFollow.y = boyfriend.getMidpoint().y - 200 + offsetY;
				}

				if (SONG.song.toLowerCase() == 'tutorial-remix')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}

				if (!lockedCamera)
				{
					switch (boyfriend.curCharacter)
					{
						case 'sky-mad' | 'sky-pissed':
							camFollow.y = boyfriend.getMidpoint().y - 70 + offsetY;
							camFollow.x = boyfriend.getMidpoint().x - 220 + offsetX;
						case 'mokey':
							camFollow.y = boyfriend.getMidpoint().y + 200 + offsetY;
							camFollow.x = boyfriend.getMidpoint().x - 100 + offsetX;
						case 'sayori':
							camFollow.x = boyfriend.getMidpoint().x - 200 + offsetX;
						case 'dr-springheel' | 'dr-springheel-mad':
							camFollow.y = boyfriend.getMidpoint().y - 50 + offsetY;
							camFollow.x = boyfriend.getMidpoint().x - 140 + offsetX;
						case 'miku':
							camFollow.y = boyfriend.getMidpoint().y - 50 + offsetY;
						case 'piconjo':
							camFollow.y = boyfriend.getMidpoint().y - 300 + offsetY;
							camFollow.x = boyfriend.getMidpoint().x - 250 + offsetX;
						case 'bf-dad':
							camFollow.x = boyfriend.getMidpoint().x - 250 + offsetX;
						case 'mia' | 'mia-lookstraight':
							camFollow.x = boyfriend.getMidpoint().x - 150 + offsetX;
						case 'dad' | 'hex' | 'mom' | 'myra' | 'mom-shaded':
							camFollow.y = boyfriend.getMidpoint().y - 50 + offsetY;
							camFollow.x = boyfriend.getMidpoint().x - 250 + offsetX;
						case 'coco' | 'coco-car' | 'coco-corrupt':
							camFollow.x = boyfriend.getMidpoint().x - 200 + offsetX;
							camFollow.y = boyfriend.getMidpoint().y - 50 + offsetY;
						case 'austin':
							camFollow.x = boyfriend.getMidpoint().x - 90;
							camFollow.y = boyfriend.getMidpoint().y - 30;
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
						case 'pico' | 'annie-bw' | 'alya' | 'phil' | 'nene' | 'picoCrazy' | 'nene-bw' | 'pico-bw' | 'botan' | 'botan-corrupt':
							camFollow.x = boyfriend.getMidpoint().x - 300 + offsetX;		
						case 'senpai' | 'blantad-pixel' | 'glitch' | 'glitch-angry' | 'senpai-angry' | 'senpai-giddy' | 'miku-pixel' 
						| 'mangle-angry' | 'monster-pixel' | 'jackson' | 'matt-angry' | 'mario-angry' | 'colt-angry' | 'colt-angryd2' 
						| 'colt-angryd2corrupted' | 'bf-senpai-tankman' | 'neon-bigger':
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
						case 'gura-amelia' | 'gura-amelia-walfie' | 'gura-amelia-corrupt' | 'gura-amelia-bw':
							camFollow.x = boyfriend.getMidpoint().x - 200;
						case 'sarvente-lucifer':
							camFollow.x = boyfriend.getMidpoint().x - 101 + offsetX;
							camFollow.y = boyfriend.getMidpoint().y - 50 + offsetY;
						case 'gold-side' | 'gold-side-blue':
							camFollow.x = boyfriend.getMidpoint().x - 50 + offsetX;
							camFollow.y = boyfriend.getMidpoint().y - 50 + offsetY;
						case 'bf-sonic' | 'bf-sonic-flipped' | 'dust-sans':
							camFollow.x = boyfriend.getMidpoint().x - 101 + offsetX;
							camFollow.y = boyfriend.getMidpoint().y - 100 + offsetY;
					}
	
					if (!curStage.contains('school'))
					{
						switch (boyfriend.curCharacter)
						{
							case 'bf-pixel' | 'bf-pixeld4' | 'bf-pixeld4BSide' | 'bf-pixel-neon':
								camFollow.x = boyfriend.getMidpoint().x - 300;
								camFollow.y = boyfriend.getMidpoint().y - 200;
						}	
					}

					if (SONG.song.toLowerCase() == 'endless' || SONG.song.toLowerCase() == 'triple-trouble')
					{
						camFollow.x += bfCamX;
						camFollow.y += bfCamY;
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
		FlxG.watch.addQuick("songPos", Conductor.songPosition);

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

		if (curSong.toLowerCase() == 'epiphany' && storyDifficulty == 5)
		{
			switch (curBeat)
			{
				case 788:
					new FlxTimer().start(0.05, function(tmr:FlxTimer)
					{
						if (!paused)
							iconP2.alpha -= 0.15;

						if (iconP2.alpha > 0)
							tmr.reset(0.05);
						else
							iconP2.visible = false;
					});
				case 790:
					FlxG.camera.fade(FlxColor.BLACK, .7, false);
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
					iconP1.useOldSystem('gf-demon');
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

		if (health <= 0 || FlxG.keys.justPressed.R && !writing)
			death();

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
				
			if (ModCharts.autoStrum && startedCountdown)  // wtf
			{
				try {
					strumLine.y = strumLineNotes.members[4].y;
				} catch(hmm) {
					trace(hmm);
				}
			}

			if (isLullaby)
				pendulumDrain = true;

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

					if (daNote.isSustainNote)
					{
						daNote.x += daNote.width / 2 + 20;
						if ((pixelNotes.contains(SONG.noteStyle) || pixelNotes.contains(SONG.dadNoteStyle) || pixelNotes.contains(SONG.bfNoteStyle) || pixelNotes.contains(alt2) || pixelNotes.contains(alt)) && daNote.style != 'guitar')
							daNote.x -= 11;
						if (daNote.style == "guitar") 
							daNote.x -= 20;
					}		
				}
				if (daNote.canBeHit && daNote.mustPress && isLullaby)
					pendulumDrain = false;

				if (!daNote.mustPress)
					minusHealth = true;

				// instead of doing stupid y > FlxG.height
				// we be men and actually calculate the time :)
				if (daNote.tooLate)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					// mag not be dumb challange(failed instantly)
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
								}else if (!daNote.burning && !daNote.blackStatic && !dontHitNotes.contains(daNote.noteType))
								{
									var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
									swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;

									daNote.clipRect = swagRect;//
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
								}else if (!daNote.burning && !daNote.blackStatic && !dontHitNotes.contains(daNote.noteType))
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
						case 'Tutorial' | 'Tutorial-Remix' | 'Get Out' | 'Their-Battle' | 'Ghost-VIP':
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

					if (daNote.noteType == 1 || daNote.noteType == 7 && dad.curCharacter != 'exe' && dad.curCharacter != 'tricky')
						dad.altAnim = '-alt';

					if (dad.curCharacter == 'blantad-scream' && dad.altAnim == '-alt')
					{
						iconP2.useOldSystem('blantad-scream2');
						healthBar.createFilledBar(FlxColor.fromString('#' + 'FF0015FE'), FlxColor.fromString('#' + boyfriend.iconColor));
						healthBar.updateBar();
					}

					if (dad.curCharacter == 'blantad-scream' && dad.altAnim != '-alt' && iconP2.animation.name != 'blantad-scream')
					{
						iconP2.useOldSystem('blantad-scream');
						healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));
						healthBar.updateBar();
					}

					if (dad.curCharacter == 'midas-double' && dad.altAnim == '-alt')
					{
						iconP2.useOldSystem('midas-shadow');
						healthBar.createFilledBar(FlxColor.fromString('#' + 'FF8256B8'), FlxColor.fromString('#' + boyfriend.iconColor));
						healthBar.updateBar();
					}

					if (dad.curCharacter == 'midas-double' && dad.altAnim != '-alt' && iconP2.animation.name != 'midas-double')
					{
						iconP2.useOldSystem('midas-double');
						healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));
						healthBar.updateBar();
					}
						
					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
						{
							dad.altAnim = '-alt';
						}

						switch (curSong)
						{
							case 'Pom-Pomeranian':
								switch (curStep)
								{
									case 1294:
										dad.altAnim = '';
								}
							case 'Ballistic':
								if (shootStepsBallistic.contains(curStep) && !inCutscene  && dad.curCharacter == 'picoCrazy')
									dad.altAnim = '-alt';
							case 'Context':
								if (kCool) 
								{
									if (curStep >= 626)
										dad.altAnim = '-alt';	
								}
							case 'Roses-Remix':
								switch (curStep)
								{
									case 396 | 398 | 404 | 406 | 412 | 413:
										dad.altAnim = '-alt';
								}
						}					
					}

					var dDir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];

					if (SONG.song.toLowerCase() == 'endless')
					{
						dadCamX = xOff[daNote.noteData];
						dadCamY = yOff[daNote.noteData];
					}

					if (SONG.song.toLowerCase() == 'triple-trouble')
					{
						dadCamX = xOff2[daNote.noteData];
						dadCamY = yOff2[daNote.noteData];
					}

					playDad = true;

					#if desktop
					if (luaModchart != null)
					{
						if (luaModchart.getVar("playDadSing",'bool'))
							playDad = true;
						else
							playDad = false;
					}
					#end

					switch (mania)
					{
						case 1:
							dDir = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
						case 2:
							dDir = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'UP', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
						case 3:
							dDir = ['LEFT', 'DOWN', 'UP', 'UP', 'RIGHT'];
						default:
							dDir = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
					}
					
					if (!(curBeat >= 532 && curBeat < 536  && curSong.toLowerCase() == "expurgation" && dad.animOffsets.exists('Hank')) && !(curBeat == 516 && curSong.toLowerCase() == "split-ex") 
						&& !(curBeat >= 831 && curBeat < 848 && dad.curCharacter == 'bipolarmouse' && SONG.song.toLowerCase() == 'killer-scream') 
						&& !(curBeat >= 255 && curBeat < 256 && dad.curCharacter == 'bf-nene-scream' && SONG.song.toLowerCase() == 'killer-scream')
						&& !(curBeat >= 316 && curBeat < 320 && dad.curCharacter == 'blantad-scream' && SONG.song.toLowerCase() == 'killer-scream') && !(daNote.noteType == 2 && SONG.song.toLowerCase() == 'epiphany')
						&& !(curBeat >= 128 && curBeat < 136 && SONG.song.toLowerCase() == "rabbit's-luck") && !(daNote.noteType == 10) && playDad)
					{
						if (!duoDad)
							dad.playAnim('sing' + dDir[daNote.noteData] + dad.altAnim, true);

						if (duoDad)
						{
							var targ:Character = dad;
							both = false;
							switch (daNote.dType)
							{
								case 0:
									targ = dad;
								case 1:
									targ = dad1;
								case 2:
									targ = dad;
									both = true;
							}
							targ.playAnim('sing' + dDir[daNote.noteData] + targ.altAnim, true);
							if (both)dad1.playAnim('sing' + dDir[daNote.noteData] + dad1.altAnim, true);
						}

						if (triple)
						{
							dad1.playAnim('sing' + dDir[daNote.noteData] + dad1.altAnim, true);
							dad2.playAnim('sing' + dDir[daNote.noteData] + dad2.altAnim, true);
						}
					}

					if (curBeat >= 831 && curBeat < 848 && dad.curCharacter == 'bipolarmouse' && SONG.song.toLowerCase() == 'killer-scream')
						dad.playAnim('singDOWN-alt', true);

					if (curBeat >= 316 && curBeat < 320 && dad.curCharacter == 'blantad-scream' && SONG.song.toLowerCase() == 'killer-scream')
						dad.playAnim('scream', true);

					if (curStage == 'night') {
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								Stage.swagBacks['pc'].animation.play('singUP', true);
							case 3:
								Stage.swagBacks['pc'].animation.play('singRIGHT', true);
							case 1:
								Stage.swagBacks['pc'].animation.play('singDOWN', true);
							case 0:
								Stage.swagBacks['pc'].animation.play('singLEFT', true);
						}
					}

					if (curBeat >= 128 && curBeat < 136 && SONG.song.toLowerCase() == "rabbit's-luck")
					{
						gf.playAnim('sing' + dDir[daNote.noteData] + gf.altAnim, true);
						gf.holdTimer = 0;
					}

					switch(dad.curCharacter)
					{
						case 'cjClone': // 50% chance
							if (FlxG.random.bool(50) && !spookyRendered && !daNote.isSustainNote && curStage == 'auditorHell') // create spooky text :flushed:
								createSpookyText(cjCloneLinesSing[FlxG.random.int(0,cjCloneLinesSing.length)]);
						case 'exTricky': // 60% chance
							if (FlxG.random.bool(50) && !spookyRendered && !daNote.isSustainNote) // create spooky text :flushed:
								createSpookyText(exTrickyLinesSing[FlxG.random.int(0,exTrickyLinesSing.length)]);
						case 'b3-mom-mad':
							health -= 0.03;
						case 'taki':
							if (curSong.toLowerCase() != 'crucify')
								health -= 0.02;
					}

					if (daNote.noteType == 7)
					{
						if (daNote.isSustainNote)
							health -= 0.00015;
						else
							health -= 0.05;
	
						FlxG.camera.shake(0.025, 0.1);
						camHUD.shake(0.010, 0.1);

						switch (dad.curCharacter)
						{
							case 'auditor':
								if (FlxG.random.bool(45) && !spookyRendered && !daNote.isSustainNote) // create spooky text :flushed:
									createAuditorText(auditorLinesSing[FlxG.random.int(0,auditorLinesSing.length)]);
							case 'tricky':
								if (FlxG.random.bool(45) && !spookyRendered && !daNote.isSustainNote) // create spooky text :flushed:
									createSpookyText(trickyLinesSing[FlxG.random.int(0,trickyLinesSing.length)]);
							case 'exe':
								doSimpleJump(true);
							case 'zipper':
								rushiaOverlayFrame = rushiaOverlayFrameMax;
								zipperScreamOverlay.alpha = 0.8;
								rushiaScreamOverlay.alpha = 0.8;
							case 'peri':
								rushiaOverlayFrame = rushiaOverlayFrameMax;
								periScreamOverlay.alpha = 0.8;
								periScreamOverlay.animation.play('idle');
								rushiaScreamOverlay.alpha = 0.8;
							default:
								rushiaOverlayFrame = rushiaOverlayFrameMax;
								rushiaScreamOverlay.alpha = 0.8;
						}					
					} 
					switch (SONG.song.toLowerCase())
					{
						case 'crucify':
							health -= 0.02;
							if (!dad.curCharacter.contains('gf') && gf.animOffsets.exists('scared'))
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
						if (isPixel && isTakeover)
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
							if (spr.animation.curAnim.name == 'confirm' && !pixelNotes.contains(SONG.noteStyle) && !isPixel && !pixelNotes.contains(alt) && !pixelSwap && !pixelStrumsDad)
							{
								spr.centerOffsets();

								switch (mania)
								{
									case 1:
										spr.offset.x -= 16;
										spr.offset.y -= 16;
									case 2:
										spr.offset.x -= 22;
										spr.offset.y -= 22;
									default:
										spr.offset.x -= 13;
										spr.offset.y -= 13;
								}		
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

					if (duoDad)
						dad1.holdTimer = 0;
					if (triple)
					{
						dad1.holdTimer = 0;
						dad2.holdTimer = 0;
					}

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

					var place:Float;

					if (SONG.song.toLowerCase() == 'crucify' && isNeonight || SONG.song.toLowerCase() == 'you-cant-run') //the modchart doesn't follow after changing ze strums so i gotta modify this
					{
						place= strumLineNotes.members[Math.floor(Math.abs(daNote.noteData)) + 4].x;
					}
					else
					{
						place = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
					}
					daNote.x = place;
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

				if (SONG.noteStyle == 'exe')
				{
					playerSplashes.forEach(function(spr:FlxSprite)
					{
						playerStrums.forEach(function(spr2:FlxSprite)
						{
							if (spr.ID == spr2.ID)
							{
								spr.x = spr2.x - 68;
								spr.y = spr2.y - 20;
							}
						});
					});
				}
				
				if (daNote.isSustainNote)
				{
					daNote.x += daNote.width / 2 + 20;
					if ((pixelNotes.contains(SONG.noteStyle) || pixelNotes.contains(SONG.dadNoteStyle) || pixelNotes.contains(SONG.bfNoteStyle) || pixelNotes.contains(alt2) || pixelNotes.contains(alt)) && daNote.style != 'guitar')
						daNote.x -= 11;
					if (daNote.style == 'guitar')
						daNote.x -= 20;
				}

				if (daNote.burning && curStage == 'auditorHell')
					daNote.x -= 165;

				switch (daNote.noteType)
				{
					case 4:
						if (daNote.pixelBurn)
							daNote.x -= 5;
						else
							daNote.x -= 40;
					case 5:
						daNote.x -= 2;
					case 6:
						if (SONG.player2 == 'whittyCrazy')
							daNote.x -= 43;
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
							switch (daNote.noteType)
							{
								case 2:
									vocals.volume = 1;
								case 3:
									health -= 1;
									if (theFunne)
										noteMiss(daNote.noteData, daNote);
								case 4 | 6 | 8 | 9 | 10:
									''; //nothing
								case 5:
									if (!daNote.blackStatic)
									{
										noteMiss(daNote.noteData, daNote);
										health -= 0.2;
										staticHitMiss();
										vocals.volume = 0;
										FlxG.sound.play(Paths.sound('ring'), .7);
									}	
									else
										''; //nothing					
								default:
									if (theFunne && !writing && !(daNote.noteData == 2 && SONG.song.toLowerCase() == 'triple-trouble' && mania == 3))
									{
										health -= 0.02;
										totalDamageTaken += 0.02;
										interupt = true;
										vocals.volume = 0;	
										noteMiss(daNote.noteData, daNote);
									}
							}	
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

			//hypno shit
			if (isLullaby) 
			{
				trance -= 0.0015 / ((!pendulumDrain) ? reducedDrain : 1);
	
				/*tranceThing.alpha = trance / 2;
				if (trance > 1) {
					tranceSound.volume = trance - 1;
				} else {
					tranceSound.volume = 0;
				}*/
				
				if (trance > 2) 
				{
					trance = 2;
					death();
				}
				
				if (trance < -0.25)
					trance = -0.25;
	
				if (FlxG.keys.justPressed.SPACE && !inCutscene) 
				{
					if (canHitPendulum) 
					{
						canHitPendulum = false;
						hitPendulum = true;
						trance -= 0.02;
					} 
					else 
						losePendulum(true);
				}
			}
		}

		cpuStrums.forEach(function(spr:FlxSprite)
		{
			if (spr.animation.finished)
			{
				if (isPixel && isTakeover)
				{
					spr.animation.play('static2');
					spr.centerOffsets();
				}
				else
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			}

			if (isPixel && isTakeover && spr.animation.curAnim.name == 'static')
			{
				spr.animation.play('static2');
				spr.centerOffsets();
			}
			else if (!isPixel && isTakeover && spr.animation.curAnim.name == 'static2')
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
					if (isPixel && isTakeover)
					{
						spr.animation.play('static2');
						spr.centerOffsets();
					}
					else
					{
						spr.animation.play('static');
						spr.centerOffsets();
					}	
				}

				if (isPixel && isTakeover && spr.animation.curAnim.name == 'static')
				{
					spr.animation.play('static2');
					spr.centerOffsets();
				}
				else if (!isPixel && isTakeover && spr.animation.curAnim.name == 'static2')
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

	var reducedDrain:Float = 4;

	function losePendulum(forced:Bool = false) {
		
		trance += 0.2 / ((!forced && !pendulumDrain) ? reducedDrain : 1);
		trace("BAD");
	}

	function psyshock() 
	{
		//psyshockParticle.setPosition(dad.x, dad.y);
		//psyshockParticle.playAnim("psyshock particle", true);
		//psyshockParticle.alpha = 1;
		
		//psyshockParticle.animation.finishCallback = function (lol:String) {
		//	psyshockParticle.alpha = 0;
		//};
		
		trance += (0.45 / ((!pendulumDrain) ? (reducedDrain / 2) : 1));
		
	//	FlxG.sound.play(Paths.sound('Psyshock', 'shared'), 1);
		if (FlxG.save.data.flashing)
			camHUD.flash(FlxColor.fromString('0xFFFFAFC1'), 1, null, true);
	}

	public function createSpookyText(text:String, x:Float = -1111111111111, y:Float = -1111111111111, ?isBF:Bool = false):Void
	{
		spookySteps = curStep;
		spookyRendered = true;
		tstatic.alpha = 0.5;
		FlxG.sound.play(Paths.sound('tricky/staticSound','shared'));

		if (isBF)
			spookyText = new FlxText((x == -1111111111111 ? FlxG.random.float(boyfriend.x + 40,boyfriend.x + 120) : x), (y == -1111111111111 ? FlxG.random.float(boyfriend.y + 200, boyfriend.y + 300) : y));
		else
			spookyText = new FlxText((x == -1111111111111 ? FlxG.random.float(dad.x + 40,dad.x + 120) : x), (y == -1111111111111 ? FlxG.random.float(dad.y + 200, dad.y + 300) : y));

		spookyText.setFormat(Paths.font("impact.ttf"), 128, FlxColor.RED);
		spookyText.bold = true;
		spookyText.text = text;
		add(spookyText);
	}

	public function createBFSpookyText(text:String, x:Float = -1111111111111, y:Float = -1111111111111):Void
	{
		spookySteps = curStep;
		spookyRendered = true;
		tstatic.alpha = 0.5;
		FlxG.sound.play(Paths.sound('tricky/staticSound','shared'));

		spookyText = new FlxText((x == -1111111111111 ? FlxG.random.float(boyfriend.x + 40,boyfriend.x + 120) : x), (y == -1111111111111 ? FlxG.random.float(boyfriend.y + 200, boyfriend.y + 300) : y));
		spookyText.setFormat(Paths.font("impact.ttf"), 128, FlxColor.RED);
		spookyText.bold = true;
		spookyText.text = text;
		add(spookyText);
	}

	var effect:FlxSprite;

	function createAuditorText(text:String, x:Float = -1111111111111, y:Float = -1111111111111):Void
	{
		spookySteps = curStep;
		spookyRendered = true;
		tstatic.alpha = 0.5;
		FlxG.sound.play(Paths.sound('tricky/staticSound','shared'));

		var posX = (x == -1111111111111 ? FlxG.random.float(dad.x + 40,dad.x + 120) : x);
		var posY = (y == -1111111111111 ? FlxG.random.float(dad.y + 200, dad.y + 300) : y);
		
		spookyText = new FlxText(posX, posY);
		spookyText.setFormat("WithoutSans-Black", 90, FlxColor.BLACK);

		spookyText.setBorderStyle(OUTLINE, FlxColor.RED, 0.7);
		effect = new FlxSprite(posX, posY).loadGraphic(Paths.image('tricky/texteffect'));
		
		spookyText.bold = true;
		spookyText.text = text;
		if (posY > 279 && posX < -190)
			{
				var posX = -259;
		        var posY = 243;

				add(effect);
				add(spookyText);
			}
		else
			{
				add(effect);
				add(spookyText);
			}	

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

		if (curSong.toLowerCase() == 'split-ex' && storyDifficulty == 3 && songScore >= 300000)
			FlxG.save.data.exUnlocked = true;

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
				case 'Scary-Swings': songHighscore = 'Scary Swings';
				case 'My-Sweets': songHighscore = 'My Sweets';
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
						case 'Scary-Swings': songFormat = 'Scary Swings';
						case 'My-Sweets': songFormat = 'My Sweets';
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
				if (storyDifficulty == 5)
					FlxG.switchState(new GuestBETADCIUState());
				else
					FlxG.switchState(new BETADCIUState());
			}
			else if (isBonus)
			{
				trace('WENT BACK TO Bonus Song MENU??');			
				FlxG.switchState(new BonusSongsState());
			}
			else if (isNeonight)
			{
				trace('WENT BACK TO NEONIGHT MENU??');
				FlxG.switchState(new NeonightState());
			}
			else if (isVitor)
			{
				trace('WENT BACK TO VITOR MENU??');
				FlxG.switchState(new VitorState());
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

	public function healthbarshake(intensity:Float)
		{
		new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				iconP1.y += (10 * intensity);
				iconP2.y += (10 * intensity);
				healthBar.y += (10 * intensity);
				healthBarBG.y += (10 * intensity);
			});
			new FlxTimer().start(0.05, function(tmr:FlxTimer)
			{
				iconP1.y -= (15 * intensity);
				iconP2.y -= (15 * intensity);
				healthBar.y -= (15 * intensity);
				healthBarBG.y -= (15 * intensity);
			});
			new FlxTimer().start(0.10, function(tmr:FlxTimer)
			{
				iconP1.y += (8 * intensity);
				iconP2.y += (8 * intensity);
				healthBar.y += (8 * intensity);
				healthBarBG.y += (8 * intensity);
			});
			new FlxTimer().start(0.15, function(tmr:FlxTimer)
			{
				iconP1.y -= (5 * intensity);
				iconP2.y -= (5 * intensity);
				healthBar.y -= (5 * intensity);
				healthBarBG.y -= (5 * intensity);
			});
			new FlxTimer().start(0.20, function(tmr:FlxTimer)
			{
				iconP1.y += (3 * intensity);
				iconP2.y += (3 * intensity);
				healthBar.y += (3 * intensity);
				healthBarBG.y += (3 * intensity);
			});
			new FlxTimer().start(0.25, function(tmr:FlxTimer)
			{
				iconP1.y -= (1 * intensity);
				iconP2.y -= (1 * intensity);
				healthBar.y -= (1 * intensity);
				healthBarBG.y -= (1 * intensity);
			});
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
					if (health < maxHealth && curSong != 'Hunger')
						health += 0.02;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.75;
				case 'sick':
					if (health < maxHealth && curSong != 'Hunger')
						health += 0.0475;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 1;
					sicks++;
			}

			if(FlxG.save.data.noteSplash && daRating == 'sick')
			{
				if (curSong != 'Storm' && SONG.noteStyle != 'exe')
					spawnNoteSplash(daNote.x, daNote.y, daNote.noteData);	

				if (SONG.noteStyle == 'exe')
				{
					playerSplashes.forEach(function(spr:FlxSprite)
					{
						if (spr.ID == daNote.noteData)
							spr.animation.play('a', true);
					});
				}
			}

			switch (daNote.noteType)
			{
				case 2:
					health -= 2;
				case 4:
					if (daNote.noteType == 4) health -= 1;
					
					FlxG.sound.play(Paths.sound('burnSound'));
					noteMiss(daNote.noteData, daNote);
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (pressArray[spr.ID] && spr.ID == daNote.noteData)
						{
							var smoke:FlxSprite = new FlxSprite(spr.x - spr.width + 15, spr.y - spr.height);
							smoke.frames = Paths.getSparrowAtlas('tricky/Smoke');
							smoke.animation.addByPrefix('boom','smoke',24,false);
							smoke.animation.play('boom');
							smoke.setGraphicSize(Std.int(smoke.width * 0.6));
							smoke.cameras = [camHUD];
							add(smoke);
							smoke.animation.finishCallback = function(name:String) {
								remove(smoke);	
							}
						}
					});		
				case 5:
					if (daNote.blackStatic)
					{				
						health -= 0.2;
						staticHitMiss();
						noteMiss(daNote.noteData, daNote);
						vocals.volume = 0;
						FlxG.sound.play(Paths.sound('ring'), .7);
					}
				case 6:
					health -= 0.2;
					if (PlayState.SONG.player2 == 'whittyCrazy')
					{
						FlxG.sound.play(Paths.sound('burnSound'));
						noteMiss(daNote.noteData, daNote);
						playerStrums.forEach(function(spr:FlxSprite)
						{
							if (pressArray[spr.ID] && spr.ID == daNote.noteData)
							{
								var smoke:FlxSprite = new FlxSprite(spr.x - spr.width + 15, spr.y - spr.height);
								smoke.frames = Paths.getSparrowAtlas('tricky/Smoke');
								smoke.animation.addByPrefix('boom','smoke',24,false);
								smoke.animation.play('boom');
								smoke.setGraphicSize(Std.int(smoke.width * 0.6));
								smoke.cameras = [camHUD];
								add(smoke);
								smoke.animation.finishCallback = function(name:String) {
									remove(smoke);	
								}
							}
						});		
					}
				case 8:
					add(blackScreen);
					FlxTween.tween(blackScreen, {alpha: 0}, 5, {
						onComplete: function(tween:FlxTween)
						{
							blackScreen.destroy();
						},
					});
					FlxTween.color(healthBar, 2.20, FlxColor.RED, FlxColor.WHITE, {ease: FlxEase.quadOut});
					FlxTween.color(iconP1, 2.20, FlxColor.RED, FlxColor.WHITE, {ease: FlxEase.quadOut});
					FlxTween.color(iconP2, 2.20, FlxColor.RED, FlxColor.WHITE, {ease: FlxEase.quadOut});
					health -= 0.25;
					maxHealth -= 0.45;
					camGame.shake(0.08, 0.06, null, true);
                	camHUD.shake(0.021, 0.012, null, true);
					FlxG.sound.play(Paths.sound('funnyWord'));
					healthbarshake(3.0);
				case 9:
					health -= 0.25;
					noteMiss(daNote.noteData, daNote);
					camGame.shake(0.08, 0.06, null, true);
                	camHUD.shake(0.021, 0.012, null, true);
				case 10:
					var fuckyou:Int = 0;
					healthDrop += 0.00025;
					if (healthDrop == 0.00025)
					{
						new FlxTimer().start(0.1, function(sex:FlxTimer)
						{
							fuckyou += 1;
		
							if (fuckyou >= 100)
								healthDrop = 0;
		
							if (!paused && fuckyou < 100)
								sex.reset();
						});
					}
					else
						fuckyou = 0;
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
			var suf:String = "";

			var offsetX:Float = 0;
			var offsetY:Float = 0;
	
			if (curStage.startsWith('school'))
			{
				if (curStage.contains('monika'))suf = 'monika/';
				pixelShitPart1 = 'weeb/pixelUI/'+suf;
				pixelShitPart2 = '-pixel';
			}

			if (isPixel)
			{
				switch (dad.curCharacter)
				{
					case 'neon':
						pixelShitPart1 = 'weeb/pixelUI/neon/';
					case 'monika' | 'monika-angry' | 'monika-finale':
						pixelShitPart1 = 'weeb/pixelUI/monika/';
					default:
						pixelShitPart1 = 'weeb/pixelUI/';
				}	
				pixelShitPart2 = '-pixel';	
			}

			switch (curStage)
			{
				case 'emptystage2':
					if (SONG.song.toLowerCase() == 'storm')
						pixelShitPart1 = 'bw/';
				case 'street1' | 'street2' | 'street3' | 'holostage-past':
					pixelShitPart1 = 'bw/flipped/';	
				case 'clubroomevil' | 'dokiclubroom-sayori' | 'dokiclubroom-natsuki' | 'dokiclubroom-yuri' | 'dokiclubroom-monika':
					pixelShitPart1 = 'doki/ui/';	
				case 'holostage-corrupt':
					pixelShitPart1 = 'corruption/ui/';
				case 'motherland' | 'holostage':
					pixelShitPart1 = 'holofunk/ui/';
				case 'stadium':
					pixelShitPart1 = 'b3/';
				case 'facility':
					offsetX = 525;
					offsetY = 380;
				case 'neon':
					offsetX = 170;
					offsetY = 170;
				case 'takiStage':
					offsetX = 250;
				case 'emptystage3':
					offsetX = 400;
				case 'sonicFUNSTAGE':
					offsetY = 200;
					pixelShitPart1 = 'exe/ui/';
				case 'trioStage':					
					pixelShitPart1 = 'exe/ui/';
					offsetY = -50;

					if (curStep >= 1296 && curStep < 2320)
						offsetX = 350;
					else if (curStep >= 2320 && curStep < 2823)
						offsetX = 250;
					else
						offsetX = -250;
				case 'concert':
					pixelShitPart1 = 'camelliastage2/ui/';
				case 'market':
					offsetX = 100;
					offsetY = 500;
				case 'exestage':					
					pixelShitPart1 = 'exe/ui/';
			}

			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y += 200 + offsetY;
			rating.x = coolText.x - 40 + offsetX;
			rating.y -= 60;
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			if (curSong == 'Demon-Training' && curStep >= 1024)
			{
				rating.x += 100;
				rating.y += -2500;
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
				numScore.x = coolText.x + (43 * daLoop) - 90 + offsetX;
				numScore.y += 80 + 200 + offsetY;

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
				var s1 = controls.S1;
				var s2 = controls.S2;
				var s3 = controls.S3;
				var s4 = controls.S4;
				var s5 = controls.S5;
				var s6 = controls.S6;

				var s1P = controls.S1_P;
				var s2P = controls.S2_P;
				var s3P = controls.S3_P;
				var s4P = controls.S4_P;
				var s5P = controls.S5_P;
				var s6P = controls.S6_P;

				var s1R = controls.S1_R;
				var s2R = controls.S2_R;
				var s3R = controls.S3_R;
				var s4R = controls.S4_R;
				var s5R = controls.S5_R;
				var s6R = controls.S6_R;

				var n0 = controls.N0;
				var n1 = controls.N1;
				var n2 = controls.N2;
				var n3 = controls.N3;
				var n4 = controls.N4;
				var n5 = controls.N5;
				var n6 = controls.N6;
				var n7 = controls.N7;
				var n8 = controls.N8;

				var n0P = controls.N0_P;
				var n1P = controls.N1_P;
				var n2P = controls.N2_P;
				var n3P = controls.N3_P;
				var n4P = controls.N4_P;
				var n5P = controls.N5_P;
				var n6P = controls.N6_P;
				var n7P = controls.N7_P;
				var n8P = controls.N8_P;

				var n0R = controls.N0_R;
				var n1R = controls.N1_R;
				var n2R = controls.N2_R;
				var n3R = controls.N3_R;
				var n4R = controls.N4_R;
				var n5R = controls.N5_R;
				var n6R = controls.N6_R;
				var n7R = controls.N7_R;
				var n8R = controls.N8_R;

				var t1 = controls.T1;
				var t2 = controls.T2;
				var t3 = controls.T3;
				var t4 = controls.T4;
				var t5 = controls.T5;

				var t1P = controls.T1_P;
				var t2P = controls.T2_P;
				var t3P = controls.T3_P;
				var t4P = controls.T4_P;
				var t5P = controls.T5_P;

				var t1R = controls.T1_R;
				var t2R = controls.T2_R;
				var t3R = controls.T3_R;
				var t4R = controls.T4_R;
				var t5R = controls.T5_R;

				switch (mania)
				{
					case 1:
						holdArray = [s1, s2, s3, s4, s5, s6];
						pressArray = [s1P, s2P, s3P, s4P, s5P, s6P];
						releaseArray = [s1R, s2R, s3R, s4R, s5R, s6R];
					case 2:
						holdArray = [n0, n1, n2, n3, n4, n5, n6, n7, n8];
						pressArray = [n0P, n1P, n2P, n3P, n4P, n5P, n6P, n7P, n8P];
						releaseArray = [n0R, n1R, n2R, n3R, n4R, n5R, n6R, n7R, n8R];
					case 3:
						holdArray = [t1, t2, t3, t4, t5];
						pressArray = [t1P, t2P, t3P, t4P, t5P];
						releaseArray = [t1R, t2R, t3R, t4R, t5R];
					default:
						holdArray = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
						pressArray = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];
						releaseArray = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R];
				}
				
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
					switch (mania)
					{
						case 1:
							holdArray = [false, false, false, false, false, false];
							pressArray = [false, false, false, false, false, false];
							releaseArray = [false, false, false, false, false, false];
						case 2:
							holdArray = [false, false, false, false, false, false, false, false, false];
							pressArray = [false, false, false, false, false, false, false, false, false];
							releaseArray = [false, false, false, false, false, false, false, false, false];
						case 3:
							holdArray = [false, false, false, false, false];
							pressArray = [false, false, false, false, false];
							releaseArray = [false, false, false, false, false];
						default:
							holdArray = [false, false, false, false];
							pressArray = [false, false, false, false];
							releaseArray = [false, false, false, false];
					}			
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

					if (duoBoyfriend)
						boyfriend1.holdTimer = 0;

					if (triple)
					{
						boyfriend1.holdTimer = 0;
						boyfriend2.holdTimer = 0;
					}
		 
					var possibleNotes:Array<Note> = []; // notes that can be hit
					var directionList:Array<Int> = []; // directions that can be hit
					var dumbNotes:Array<Note> = []; // notes to kill later
					var directionsAccounted:Array<Bool> = []; // we don't want to do judgments for more than one presses

					switch (mania)
					{
						case 1:
							directionsAccounted = [false, false, false, false, false, false];
						case 2:
							directionsAccounted = [false, false, false, false, false, false, false, false, false];
						case 3:
							directionsAccounted = [false, false, false, false, false];
						default:
							directionsAccounted = [false, false, false, false];
					}		
					
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
									if (pressArray[shit] && !directionList.contains(shit) && !writing)
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
								if (pressArray[shit] && !writing)
								{
									interupt = true;
									noteMiss(shit, null);
								}		
						}

					if(dontCheck && possibleNotes.length > 0 && FlxG.save.data.ghost && !FlxG.save.data.botplay && !writing)
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
									if (duoBoyfriend || triple)
									{
										boyfriend1.holdTimer = 0;
										if (triple)
											boyfriend2.holdTimer = 0;
									}
								}
							}else 
							{
								if (!daNote.burning && !daNote.blackStatic && !dontHitNotes.contains(daNote.noteType))
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = 0;
									if (duoBoyfriend || triple)
									{
										boyfriend1.holdTimer = 0;
										if (triple)
											boyfriend2.holdTimer = 0;
									}
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

				if (duoBoyfriend || triple)
				{
					if (boyfriend1.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || FlxG.save.data.botplay))
					{
						if (boyfriend1.animation.curAnim.name.startsWith('sing') && !boyfriend1.animation.curAnim.name.endsWith('miss'))
						{		
							boyfriend1.dance();
						}
					}

					if (triple)
					{
						if (boyfriend2.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || FlxG.save.data.botplay))
						{
							if (boyfriend2.animation.curAnim.name.startsWith('sing') && !boyfriend2.animation.curAnim.name.endsWith('miss'))
							{		
								boyfriend2.dance();
							}
						}
					}		
				}		
		 
				if (!FlxG.save.data.botplay)
				{
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (isPixel && isTakeover)
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
					
							if (spr.animation.curAnim.name == 'confirm' && !pixelNotes.contains(SONG.noteStyle) && !isPixel && !pixelStrumsBF)
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
		if (cNum > 0)
			cNum--;

		if (!boyfriend.stunned && cNum == 0)
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

			if (isMania)
			{
				var sDir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
				switch (mania)
				{
					case 1:
						sDir = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
					case 2:
						sDir = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'UP', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
					case 3:
						sDir = ['LEFT', 'DOWN', 'UP', 'UP', 'RIGHT'];
					default:
						sDir = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
				}

				boyfriend.playAnim('sing' + sDir[direction] + 'miss' + boyfriend.bfAltAnim, true);
			}
			else
			{
				switch (direction)
				{
					case 0:
						boyfriend.playAnim('singLEFTmiss' + boyfriend.bfAltAnim, true);
						if (duoBoyfriend || triple)
						{
							boyfriend1.playAnim('singLEFTmiss' + boyfriend.bfAltAnim, true);
							if (triple)
								boyfriend2.playAnim('singLEFTmiss' + boyfriend.bfAltAnim, true);
						}
					case 1:
						boyfriend.playAnim('singDOWNmiss' + boyfriend.bfAltAnim, true);
						if (duoBoyfriend || triple)
						{
							boyfriend1.playAnim('singDOWNmiss' + boyfriend.bfAltAnim, true);
							if (triple)
								boyfriend2.playAnim('singDOWNmiss' + boyfriend.bfAltAnim, true);
						}
					case 2:
						boyfriend.playAnim('singUPmiss' + boyfriend.bfAltAnim, true);
						if (duoBoyfriend || triple)
						{
							boyfriend1.playAnim('singUPmiss' + boyfriend.bfAltAnim, true);
							if (triple)
								boyfriend2.playAnim('singUPmiss' + boyfriend.bfAltAnim, true);
						}
					case 3:
						boyfriend.playAnim('singRIGHTmiss' + boyfriend.bfAltAnim, true);
						if (duoBoyfriend || triple)
						{
							boyfriend1.playAnim('singRIGHTmiss' + boyfriend.bfAltAnim, true);
							if (triple)
								boyfriend2.playAnim('singRIGHTmiss' + boyfriend.bfAltAnim, true);
						}
				}	
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

	public function staticHitMiss()
	{
		trace ('lol you missed the static note!');

		var daNoteStatic:FlxSprite = new FlxSprite(0,0);

		daNoteStatic.frames = Paths.getSparrowAtlas('exe/hitStatic');

		daNoteStatic.setGraphicSize(FlxG.width, FlxG.height);

		daNoteStatic.screenCenter();
		
		daNoteStatic.cameras = [camHUD];

		daNoteStatic.animation.addByPrefix('static','staticANIMATION', 24, false);
		daNoteStatic.animation.addByPrefix('greystatic','greystaticANIMATION', 24, false);

		switch (curStage)
		{
			case 'emptystage2' | 'street1' | 'street2' | 'street3':
				daNoteStatic.animation.play('greystatic');
			default:
				daNoteStatic.animation.play('static');
		}
		
		shakeCam2 = true;

		new FlxTimer().start(0.8, function(tmr:FlxTimer)
			{
				shakeCam2 = false;
			});


		if (SONG.song.toLowerCase() != 'killer-scream')
			FlxG.sound.play(Paths.sound("hitStatic1"));

		if (SONG.song.toLowerCase() == 'killer-scream')
			daNoteStatic.alpha = 0.5;

		add(daNoteStatic);

		daNoteStatic.animation.finishCallback = function(pog:String)
			{
				trace('ended HITSTATICLAWL');
				remove(daNoteStatic);
			}
	}

	public function doStaticSign(lestatic:Int = 0, ?leopa:Bool = true)
	{
		trace ('static MOMENT HAHAHAH ' + lestatic );
		var daStatic:FlxSprite = new FlxSprite(0, 0);

		daStatic.frames = Paths.getSparrowAtlas('exe/daSTAT');

		daStatic.setGraphicSize(FlxG.width, FlxG.height);
		
		daStatic.screenCenter();

		daStatic.cameras = [camOther];

		switch(lestatic)
		{
			case 0:
				daStatic.animation.addByPrefix('static','staticFLASH',24, false);
		}
		add(daStatic);

		if (leopa)
			{
				if (daStatic.alpha != 0)
					daStatic.alpha = FlxG.random.float(0.1, 0.5);
			}
			else
				daStatic.alpha = 1;

		FlxG.sound.play(Paths.sound('staticBUZZ'));

		if (daStatic.alpha != 0)
			daStatic.alpha = FlxG.random.float(0.1, 0.5);

		daStatic.animation.play('static');

		daStatic.animation.finishCallback = function(pog:String)
		{
			trace('ended static');
			remove(daStatic);
		}
	}

	function doJumpscare()
	{
		trace ('JUMPSCARE aaaa');
		
		switch (dad.curCharacter)
		{
			case 'exe-bw':
				daJumpscare.frames = Paths.getSparrowAtlas('exe/sonicJUMPSCARE1930');
			default:
				daJumpscare.frames = Paths.getSparrowAtlas('exe/sonicJUMPSCARE');
		}
		
		daJumpscare.animation.addByPrefix('jump','sonicSPOOK',24, false);
		
		daJumpscare.screenCenter();

		daJumpscare.scale.x = 1.1;
		daJumpscare.scale.y = 1.1;

		daJumpscare.y += 370;

		daJumpscare.cameras = [camHUD];

		switch (dad.curCharacter)
		{
			case 'exe-bw':
				''; //it's part of the music
			default:
				FlxG.sound.play(Paths.sound('jumpscare'), 1);
				FlxG.sound.play(Paths.sound('datOneSound'), 1);
		}
		
		add(daJumpscare);

		daJumpscare.animation.play('jump');

		daJumpscare.animation.finishCallback = function(pog:String)
		{
			trace('ended jump');
			remove(daJumpscare);
		}
	}

	function doSimpleJump(?isRushiaNote:Bool = false)
	{
		trace ('SIMPLE JUMPSCARE');

		var simplejump:FlxSprite = new FlxSprite().loadGraphic(Paths.image('exe/simplejump'));
	
		simplejump.setGraphicSize(FlxG.width, FlxG.height);
			
		simplejump.screenCenter();
	
		simplejump.cameras = [camHUD];
		
		var timer:Float = 0.1;

		if (!isRushiaNote)
		{
			FlxG.sound.play(Paths.sound('sppok', 'exe'), 1);
			FlxG.camera.shake(0.0025, 0.50);
			timer = 0.2;
		}
			
		add(simplejump);

		new FlxTimer().start(timer, function(tmr:FlxTimer)
		{
			trace('ended simple jump');
			remove(simplejump);
		});
	}

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

					if (note.noteType == 1)
					{
						boyfriend.bfAltAnim = '-alt';
					}

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
						}

						if (curSong == 'Treacherous-Dads')
						{
							if (bfTransformSteps.contains(curStep) && !inCutscene)
								boyfriend.bfAltAnim = '-alt';
						}
					}

					playBF = true;

					#if desktop
					if (luaModchart != null)
					{
						if (luaModchart.getVar("playBFSing",'bool'))
							playBF = true;
						else
							playBF = false;
					}
					#end

					var sDir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];

					switch (mania)
					{
						case 1:
							sDir = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
						case 2:
							sDir = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'UP', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
						case 3:
							sDir = ['LEFT', 'DOWN', 'UP', 'UP', 'RIGHT'];
						default:
							sDir = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
					}

					if (!(duoDad && SONG.song.toLowerCase() == 'epiphany') && playBF && !(mania == 3 && SONG.noteStyle == 'exe' && note.noteData == 2) && !duoBoyfriend)
						boyfriend.playAnim('sing' + sDir[note.noteData] + boyfriend.bfAltAnim, true);

					if (mania == 3 && SONG.noteStyle == 'exe' && note.noteData == 2)
						cNum++;

					if (SONG.song.toLowerCase() == 'endless')
					{
						bfCamX = xOff[note.noteData];
						bfCamY = yOff[note.noteData];
					}

					if (SONG.song.toLowerCase() == 'triple-trouble')
					{
						bfCamX = xOff2[note.noteData];
						bfCamY = yOff2[note.noteData];
					}

					if (isMania && note.noteData == 2 && !note.isSustainNote && mania == 3)
						FlxG.sound.play(Paths.sound('ring2'));
							
					if (duoDad && SONG.song.toLowerCase() == 'epiphany')
					{
						var targ:Boyfriend = boyfriend;
						both = false;
						switch (note.dType)
						{
							case 0:
								targ = boyfriend;
							case 1:
								targ = boyfriend;
							case 2:
								targ = boyfriend;
								both = true;
						}
						boyfriend.playAnim('sing' + sDir[note.noteData] + targ.altAnim, true);
						if (both)dad1.playAnim('sing' + sDir[note.noteData] + dad1.altAnim, true);
					}

					if (duoBoyfriend)
					{
						var targ:Boyfriend = boyfriend;
						both = false;
						switch (note.dType)
						{
							case 0:
								targ = boyfriend;
							case 1:
								targ = boyfriend1;
							case 2:
								targ = boyfriend;
								both = true;
						}
						targ.playAnim('sing' + sDir[note.noteData] + targ.bfAltAnim, true);
						if (both)boyfriend1.playAnim('sing' + sDir[note.noteData] + boyfriend1.bfAltAnim, true);
					}

					if (duoDad && SONG.song.toLowerCase() == 'epiphany')
						dad1.holdTimer = 0;

					if (triple)
					{
						boyfriend1.playAnim('sing' + sDir[note.noteData] + boyfriend.bfAltAnim, true);
						boyfriend2.playAnim('sing' + sDir[note.noteData] + boyfriend.bfAltAnim, true);
					}
						
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end


					if(!loadRep && note.mustPress)
						saveNotes.push(HelperFunctions.truncateFloat(note.strumTime, 2));

					switch (SONG.song.toLowerCase())
					{
						case 'hunger':
							health -= 0.01;
						case 'ghost-vip':
							if (curStep >= 3248 && curStep < 3296)
							{
								if (FlxG.random.bool(45) && !spookyRendered && !note.isSustainNote) // create spooky text :flushed:
									createBFSpookyText(trickyLinesSing[FlxG.random.int(0,trickyLinesSing.length)]);
							}	
							if (curStep == 3304 && !spookyRendered)
								createBFSpookyText('HANK!!!');
					}
					switch (curStage)
					{
						case 'churchgospel':
							var spin:Int = FlxG.random.int(1, 3);
							circ1new.angle -= spin;
					}

					#if windows
						if (luaModchart != null)
							luaModchart.executeState('bfNoteHit', []);
					#end
					
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (isPixel && isTakeover)
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
							if (spr.animation.curAnim.name == 'confirm' && !pixelNotes.contains(SONG.noteStyle) && !isPixel && alt2 != 'pixel' && !pixelStrumsBF)
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

	public function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null) {//
		var skin:String = "";
		skin = splashSkin;
		
		if(note != null) {
			skin = splashSkin;
		}

		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data, skin);
		grpNoteSplashes.add(splash);
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
		flashSprite.alpha = 0.4;		
	}

	var danced:Bool = false;

	var stepOfLast = 0;

	function funCountdown(number:String = 'three') // why tf were they separate functions!? this works perfectly fine
	{
		switch (number)
		{
			case 'three':
				var three:FlxSprite = new FlxSprite().loadGraphic(Paths.image('exe/three'));
				three.scrollFactor.set();
				three.updateHitbox();
				three.screenCenter();
				three.y -= 100;
				three.alpha = 0.5;
				add(three);
				FlxTween.tween(three, {y: three.y += 100, alpha: 0}, Conductor.crochet / 1000, {
					ease: FlxEase.cubeOut,
					onComplete: function(twn:FlxTween)
					{
						three.destroy();
					}
				});
			case 'two':
				var two:FlxSprite = new FlxSprite().loadGraphic(Paths.image('exe/two'));
				two.scrollFactor.set();
				two.screenCenter();
				two.y -= 100;
				two.alpha = 0.5;
				add(two);
				FlxTween.tween(two, {y: two.y += 100, alpha: 0}, Conductor.crochet / 1000, {
					ease: FlxEase.cubeOut,
					onComplete: function(twn:FlxTween)
					{
						two.destroy();
					}
				});
			case 'one':
				var one:FlxSprite = new FlxSprite().loadGraphic(Paths.image('exe/one'));
				one.scrollFactor.set();
				one.screenCenter();
				one.y -= 100;
				one.alpha = 0.5;

				add(one);
				FlxTween.tween(one, {y: one.y += 100, alpha: 0}, Conductor.crochet / 1000, {
					ease: FlxEase.cubeOut,
					onComplete: function(twn:FlxTween)
					{
						one.destroy();
					}
				});
			case 'go': // go is not a number lol
			var gofun:FlxSprite = new FlxSprite().loadGraphic(Paths.image('exe/gofun'));
			gofun.scrollFactor.set();
			gofun.screenCenter();
			gofun.y -= 100;
			gofun.alpha = 0.5;

			add(gofun);
			FlxTween.tween(gofun, {y: gofun.y += 100, alpha: 0}, Conductor.crochet / 1000, {
				ease: FlxEase.cubeInOut,
				onComplete: function(twn:FlxTween)
				{
					gofun.destroy();
				}
			});
		}
	}

	function doP3Static()
	{
		trace('p3static XDXDXD');

		daP3Static.frames = Paths.getSparrowAtlas('exe/Phase3Static');
		daP3Static.animation.addByPrefix('P3Static', 'Phase3Static instance 1', 24, false);

		daP3Static.screenCenter();

		daP3Static.scale.x = 4;
		daP3Static.scale.y = 4;
		daP3Static.alpha = 0.5;

		daP3Static.cameras = [camOther];

		add(daP3Static);

		daP3Static.animation.play('P3Static');

		daP3Static.animation.finishCallback = function(pog:String)
		{
			trace('ended p3static');
			daP3Static.alpha = 0;

			remove(daP3Static);
		}
	}

	function doP3Jump(character:String)
	{
		trace('SIMPLE JUMPSCARE');

		var doP3JumpTAILS:FlxSprite = new FlxSprite().loadGraphic(Paths.image('exe/JUMPSCARES/'+character));

		doP3JumpTAILS.setGraphicSize(FlxG.width, FlxG.height);

		doP3JumpTAILS.screenCenter();

		doP3JumpTAILS.cameras = [camOther];

		FlxG.camera.shake(0.0025, 0.50);

		add(doP3JumpTAILS);

		FlxG.sound.play(Paths.sound('P3Jumps/'+character+'ScreamLOL', 'shared'), .1);

		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			trace('ended simple jump');
			remove(doP3JumpTAILS);
		});

		var balling:FlxSprite = new FlxSprite(0, 0);

		balling.frames = Paths.getSparrowAtlas('exe/daSTAT');
		balling.animation.addByPrefix('static', 'staticFLASH', 24, false);

		balling.setGraphicSize(FlxG.width, FlxG.height);

		balling.screenCenter();

		balling.cameras = [camOther];

		add(balling);

		FlxG.sound.play(Paths.sound('staticBUZZ'));

		if (balling.alpha != 0)
			balling.alpha = FlxG.random.float(0.1, 0.5);

		balling.animation.play('static');

		balling.animation.finishCallback = function(pog:String)
		{
			trace('ended static');
			remove(balling);
		}
	}

	override function stepHit()
	{
		super.stepHit();

		if (curStage == 'reactor' || curStage == 'polus' || curStage == 'polus2' || curStage == 'reactor-m')
			if (flashSprite.alpha > 0)
				flashSprite.alpha -= 0.08;

		if (SONG.notes[Std.int(curStep / 16)].dadCrossfade)
		{
			dadTrail.active = true;
			if (duoDad || triple)
				dad1Trail.active = true;
		}			
		else if (!SONG.notes[Std.int(curStep / 16)].dadCrossfade)
		{
			dadTrail.active = false;
			dadTrail.resetTrail();
			if (duoDad || triple)
			{
				dad1Trail.active = false;
				dad1Trail.resetTrail();
			}		
		}
			
		if (SONG.notes[Std.int(curStep / 16)].bfCrossfade)
		{
			bfTrail.active = true;	
					
			if (duoBoyfriend || triple)
				bf1Trail.active = true;	
		}	
		else if (!SONG.notes[Std.int(curStep / 16)].bfCrossfade)
		{
			bfTrail.active = false;
			bfTrail.resetTrail();
			if (duoBoyfriend || triple)
			{
				bf1Trail.active = false;
				bf1Trail.resetTrail();
			}		
		}		

		if (usesStageHx)
		{
			Stage.stepHit();
		}

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

		if (staticArray.contains(curStep))
		{
			doStaticSign();
		}
		if (isLullaby) 
		{
			if (psyshockCooldown <= 0) 
			{	
				psyshock();

				if (dad.curCharacter == 'hypno') {
					dad.playAnim('psyshock', true);
					psyshocking = true;
					new FlxTimer().start(Conductor.stepCrochet * 4 / 1000, function(tmr:FlxTimer)
					{
						psyshocking = false;
					});
					psyshockCooldown = FlxG.random.int(70, 150);
				} else 
					psyshockCooldown = FlxG.random.int(60, 90);
			} else {
				psyshockCooldown--;
			}
		}


		switch (SONG.song.toLowerCase())
		{
			case 'context':	
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
			case 'demon-training':
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
			case 'safety-lullaby':
				#if debug
					lolText.text = Std.string(trance); //tracking this is bs
				#end
				switch (curStep % 16) {
					case 7 | 15:
						canHitPendulum = true;
					case 10 | 2:
						canHitPendulum = false;
						if (!hitPendulum)
						{
							if (skippedFirstPendulum)
								losePendulum();
							else
								skippedFirstPendulum = true;
						} 
						else						
							hitPendulum = false;
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
						iconP2.useOldSystem('sky-purehappiness');
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
			case 'split-ex':
				if (curStage == 'night')
				{
					var phillyCityLights = Stage.swagGroup['phillyCityLights'];
					switch (curStep)
					{
						case 256 | 1792:
							if (FlxG.save.data.flashing) {
								Stage.swagGroup['areYouReady'].members[0].visible = true;
								phillyCityLights.forEach(function(light:FlxSprite)
								{
									light.visible = false;
								});
								phillyCityLights.members[0].visible = true;
								phillyCityLights.members[0].alpha = 1;
								FlxTween.tween(phillyCityLights.members[0], {alpha: 0}, 0.2, {
								});
							}
						case 260 | 1796:
							if (FlxG.save.data.flashing) {
								Stage.swagGroup['areYouReady'].members[1].visible = true;
								phillyCityLights.forEach(function(light:FlxSprite)
								{
									light.visible = false;
								});
								phillyCityLights.members[0].visible = true;
								phillyCityLights.members[0].alpha = 1;
								FlxTween.tween(phillyCityLights.members[0], {alpha: 0}, 0.2, {
								});
							}
						case 264 | 1800:
							if (FlxG.save.data.flashing) {
								Stage.swagGroup['areYouReady'].members[2].visible = true;
								phillyCityLights.forEach(function(light:FlxSprite)
								{
									light.visible = false;
								});
								phillyCityLights.members[0].visible = true;
								phillyCityLights.members[0].alpha = 1;
								FlxTween.tween(phillyCityLights.members[0], {alpha: 0}, 0.2, {
								});
							}
						case 272 | 1808:
							for (i in Stage.swagGroup['areYouReady']) {
								i.visible = false;
							}
						case 257 | 1793:
							if (!Stage.swagGroup['areYouReady'].members[0].visible)
								Stage.swagGroup['areYouReady'].members[0].visible = true;
					}
				}

				switch (curStep)
				{
					case 528:
						if (isNeonight) {			
							if (!FlxG.save.data.stageChange)
								pixelSwap = true;
							else
								isPixel = true;
						}			
					case 592:
						if (isNeonight) {				
							if (!FlxG.save.data.stageChange)
								pixelSwap = false;
							else
								isPixel = false;
						}
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
			case 'happy':
				if (dad.curCharacter.contains('exe') && curStep == 443)
					doJumpscare();
			case 'endless':
				switch (curStep)
				{
					case 888:
						camFollowIsOn = false;
						lockedCamera = true;
						camFollow.setPosition(GameDimensions.width / 2 + 50, GameDimensions.height / 4 * 3 + 280);
						FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.3}, 0.7, {ease: FlxEase.cubeInOut});
						funCountdown('three');
					case 891:
						FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.3}, 0.7, {ease: FlxEase.cubeInOut});
						funCountdown('two');
					case 896:
						FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.3}, 0.7, {ease: FlxEase.cubeInOut});
						funCountdown('one');
					case 899:
						camFollowIsOn = true;
						lockedCamera = false;
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.7, {ease: FlxEase.cubeInOut});
						funCountdown('go');
				}	
			case 'triple-trouble':
				switch (curStep)
				{
					case 1:
						doP3Static(); // cool static
					case 144:
						doP3Jump('sunky');
					case 1024 | 1088 | 1216 | 1280 | 2305 | 2810 | 3199 | 4096:
						doP3Static();
					case 1296: // switch to knuckles facing left facing right and bf facing right, and cool static
						Stage.swagBacks['p3staticbg'].visible = false;
						doP3Jump('maijin');
					case 1040 | 2320 | 4111:
						Stage.swagBacks['p3staticbg'].visible = true;
					case 2823:
						doP3Jump('lord-x');
						Stage.swagBacks['p3staticbg'].visible = false;
					case 2887, 3015, 4039:
						//dad.playAnim('laugh', true);
						//dad.nonanimated = true; //i can set this in the modchart
					case 2895, 3023, 4048:
						//dad.nonanimated = false; //same here
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
					iconP2.useOldSystem('monika-finale');	
					iconP1.useOldSystem('blantad-pixel');	
					healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));
					healthBar.updateBar();
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
						iconP1.useOldSystem('bf-pixeld4');
						iconP2.useOldSystem('bitdad');
					case 370 | 373 | 380 | 628 | 636 | 754 | 758 | 762 | 1012 | 1020:
						iconP1.useOldSystem('bf-pixeld4BSide');
						iconP2.useOldSystem('bitdadBSide');
					case 371 | 374 | 378 | 382 | 626 | 630 | 634 | 638 | 756 | 764 | 1010 | 1014 | 1018 | 1022:
						iconP1.useOldSystem('bf-pixeld4');
						iconP2.useOldSystem('bitdad');
					case 376 | 624 | 632 | 1008 | 1016:
						dad.playAnim('switch', false);
						gf.playAnim('switch', false);
						iconP1.useOldSystem('bf-pixeld4BSide');
						iconP2.useOldSystem('bitdadBSide');
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
						iconP2.useOldSystem('green-monika');
					case 404 | 406:
						FlxG.sound.play(Paths.sound('glitch'));					
						gf.alpha = 0;
						dad.alpha = 0;
						monikaBG.animation.play('just-monika');
						monikaBG.alpha = 1;
						iconP2.useOldSystem('empty');
					case 412 | 413:
						FlxG.sound.play(Paths.sound('glitch'));
						gf.alpha = 0;
						monikaBG.animation.play('ghost');
						monikaBG.alpha = 1;
						iconP2.useOldSystem('green-monika');
					case 397 | 400 | 414:
						gf.alpha = 1;
						monikaBG.alpha = 0;
						iconP2.useOldSystem('monika-angry');
					case 405 | 407:
						gf.alpha = 1;
						dad.alpha = 1;
						monikaBG.alpha = 0;
						iconP2.useOldSystem('monika-angry');
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
						iconP2.useOldSystem('monika-jumpscare');
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
						iconP2.useOldSystem('monika-angry');
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

				if (dad.curCharacter == 'auditor')
					remove(effect);
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

	var lastBeatT:Int = 0;
	var lastBeatDadT:Int = 0;
	var beatOfFuck:Int = 0;
	var ruvShakeBeat:Int = 0;
	var reactorBeats = [1, 16, 32, 48, 64, 72, 80, 88, 96, 104, 112, 120, 126, 127, 128, 132, 136, 140, 144, 148, 152, 156, 160, 164, 168, 172, 176, 180, 184, 188, 448, 456, 464, 472, 476, 478, 480, 484, 488, 492, 496, 500, 504, 508, 512, 516, 520, 524, 528, 532, 536, 540, 544, 548, 552, 556, 560, 564, 568, 572, 576, 580, 584, 588, 592, 596, 600, 604];

	override function beatHit()
	{
		super.beatHit();

		if (usesStageHx)
		{
			Stage.beatHit();
		}

		if (SONG.song.toLowerCase() == 'hands' && curStep == 1088)
			fastCarCanDrive = false;

		switch (curSong.toLowerCase())
		{
			case 'killer-scream':
				if (curBeat == 1)
					camZooming = true;
					FlxTween.tween(Stage.swagBacks['blackScreen'], {alpha: 0}, 4);
				if (curBeat == 59)
					resyncVocals();
				if (curBeat == 60)
					softCountdown();
				if (curBeat == 64)
					appearStaticArrows();
				if (curBeat >= 64 && babyArrow.alpha != 1)
					appearStaticArrows();
			case 'reactor':
				switch (curBeat)
				{
					case 128 | 319 | 607:
						defaultCamZoom = 0.7;
						camFollow.setPosition(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y);
					case 191 | 383:
						defaultCamZoom = 0.5;
						camFollow.setPosition(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y - 100);
					case 480:
						defaultCamZoom = 0.9;
						camFollow.setPosition(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y);
				}

				if (curBeat >= 128 && curBeat < 191 && camZooming && FlxG.camera.zoom < 1.35)
				{
					FlxG.camera.zoom += 0.025;
					camHUD.zoom += 0.03;
				}
				//drop 2
				if (curBeat >= 319 && curBeat < 383 && camZooming && FlxG.camera.zoom < 1.35)
				{
					FlxG.camera.zoom += 0.025;
					camHUD.zoom += 0.03;
				}
				
				if (curBeat >= 480 && curBeat < 607 && camZooming && FlxG.camera.zoom < 1.35)
				{
					FlxG.camera.zoom += 0.035;
					camHUD.zoom += 0.03;
				}

				if(reactorBeats.contains(curBeat) && !inCutscene)
					bgFlash();
			case 'bi-nb':
				if (curBeat > 0 && !shadersLoaded)
				{
					shadersLoaded = true;
					// also comment filters.push if your planning to do a disable shaders option
					filters.push(ShadersHandler.chromaticAberration);
					filters.push(ShadersHandler.radialBlur);
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
			if(sussusBeats.contains(curBeat) && !inCutscene)
				bgFlash();
		}

		if (curSong.toLowerCase() == 'pom-pomeranian' && curStep >= 768 && curStep < 832)
			FlxG.camera.zoom += 0.05;

		if (curSong == 'Roses-Remix')
		{
			switch (curBeat)
			{
				case 16:		
					bgGirls.getScared();
					changeDadCharacter(250, 670, 'bf-gf-pixel');
					iconP1.useOldSystem('bf-tankman-pixel-plain');
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
					remove(boyfriend);
					add(bgGirlsBSAA);
					bgGirlsBSAA.getScared();
					add(amyPixelBG);
					changeGFCharacter(580, 430, 'piper-pixel-mario');				
					changeDadCharacter(250, 460, 'colt-angry');
					add(boyfriend);
					add(fgStreetMario);
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
					add(bgGirlsEdd);
					bgGirlsEdd.getScared();
					add(glitchBG);
					add(monikaBG);
					remove(boyfriend);
					changeGFCharacter(580, 430, 'gf-edd');
					changeDadCharacter(250, 460, 'matt-angry');				
					add(boyfriend);
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
					changeDadCharacter(250, 460, 'baldi-angry-pixel');
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
					remove(bfPixelBG);
					add(bgGirlsSFNAF);	
					add(bgGirlsUTMJ);
					bgGirlsUTMJ.getScared();
					add(bfPixelBG);
					add(gf);	
					changeDadCharacter(250, 460, 'jackson');	
					changeBoyfriendCharacter(970, 670, 'bf-pico-pixel');		
			}
		}

		if (curSong == 'Takeover') 
		{
			switch (curBeat)
			{
				case 64:
					changeDadCharacter(0, 100, 'updike');	
				case 80:				
					changeBoyfriendCharacter(870, 100, 'whitty');
				case 96:				
					changeDadCharacter(0, 100, 'rebecca');			
				case 112:				
					changeBoyfriendCharacter(770, -25, 'bf-blantad');
				case 148:					
					changeBoyfriendCharacter(970, 710, 'bf-senpai-pixel-angry');
				case 164:
					monikaFinaleBG.alpha = 1;					
					changeDadCharacter(200, 700, 'lane-pixel');	
				case 180:
					changeBoyfriendCharacter(970, 560, 'neon');
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
				case 212:		
					changeBoyfriendCharacter(870, 200, 'opheebop');
				case 228:					
					changeDadCharacter(100, 500, 'impostor');				
				case 244:
					changeBoyfriendCharacter(1070, 400, 'henry-angry');
				case 260:			
					changeDadCharacter(100, 100, 'coco');
				case 264:
					changeBoyfriendCharacter(870, 450, 'bf-aloe');
				case 268:				
					changeDadCharacter(50, 350, 'neko-crazy');
				case 272:
					changeBoyfriendCharacter(870, 450, 'bf-confused');
			}
		}

		if (curSong == 'Dead-Pixel') 
		{
			switch (curBeat)
			{
				case 156:
					changeDadCharacter(250, 460, 'colt-angryd2corrupted');
			}
		}

		if (curSong == 'Expurgation') 
		{
			switch (curBeat)
			{
				case 532:
					if (dad.animOffsets.exists('Hank'))
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
					if (health < maxHealth)
						health += 0.02;
				case 55:
					dad.playAnim('singRIGHTmiss', true);
					if (health < maxHealth)
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
					changeDadCharacter(100, 180, 'blantad-watch');	
					dad.setZoom(0.9);
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
					changeDadCharacter(100, 100, 'hd-senpai-giddy');
					changeBoyfriendCharacter(770, 300, 'tankman');
				case 168:
					addIconBG('tankman', 0, -100, 2);
					addIconBG('hd-senpai-giddy', 0, 300, 1, true); 
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

		switch (SONG.song.toLowerCase())
		{
			case 'monochrome':
				switch (curBeat) {
					case 28:
						FlxTween.tween(healthBar, {alpha: 0.4}, 3, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0.4}, 3, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 0.4}, 3, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 1}, 3, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 1}, 3, {ease: FlxEase.linear});
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 0.7}, 3, {ease: FlxEase.linear});
						}
					case 392:
						FlxTween.tween(healthBar, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(dad, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(Stage.swagBacks['stageFront'], {alpha: 0}, 1, {ease: FlxEase.linear});
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
						}
					/*case 224:
						if (ClientPrefs.hellMode)
							startUnown(16, 'abcdefghijklmnopqrstuvwxyz');
						else
							startUnown(8);
					case 232:
						if (!ClientPrefs.hellMode)
							startUnown(8);*/
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
						if (!dad.animation.curAnim.name.startsWith('sing'))
							dad.dance();
						if (duoDad)
							dad1.dance();
						if (triple)
						{
							dad1.dance();
							dad2.dance();
						}		
				}
			}
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (FlxG.save.data.camzoom)
		{
			// HARDCODING FOR MILF ZOOMS!
			if ((curSong.toLowerCase() == 'milf' || curSong.toLowerCase() == 'milf-g') && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
	
			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0 && !inCutscene)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
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
			switch (boyfriend.curCharacter)
			{
				case 'hex-bw':
					if (!boyfriend.animation.curAnim.name.contains('wink'))
						boyfriend.dance();
				case 'bf-aloe' | 'bf-aloe-confused':
					if (!boyfriend.animation.curAnim.name.contains('special'))
						boyfriend.dance();
				case 'bf-cesar' | 'bf-demoncesar':
					if (!boyfriend.animation.curAnim.name.contains('transition') && !picoCutscene)
						boyfriend.dance();	
				case 'sarv-ruv' | 'sarv-ruv-both':
					if (!boyfriend.animation.curAnim.name.contains('3'))
						boyfriend.dance();	
				case 'blantad-watch' | 'blantad-teleport' | 'blantad-handscutscene':
					if (!boyfriend.animation.curAnim.name.contains('special'))
						boyfriend.dance();			
				default:
					boyfriend.dance();	
			}	
		}

		if (duoBoyfriend || triple)
		{
			if (!boyfriend1.animation.curAnim.name.startsWith("sing"))
				boyfriend1.dance();

			if (triple)
			{
				if (!boyfriend2.animation.curAnim.name.startsWith("sing"))
					boyfriend2.dance();
			}		
		}

		if (!dad.animation.curAnim.name.startsWith("sing") && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
		{
			switch (dad.curCharacter)
			{
				case 'senpaighosty':
					if (!dad.animation.curAnim.name.contains('disappear'))
						dad.dance();
				case 'cjClone' | 'exTricky':
					if (!dad.animation.curAnim.name.contains('Hank'))
						dad.dance();
				case 'gura-amelia':
					if (!dad.animation.curAnim.name.contains('ah') && !dad.animation.curAnim.name.contains('chu'))
						dad.dance();
				case 'sky-annoyed':
					if (!dad.animation.curAnim.name.contains('special'))
						dad.dance();
				case 'cj-ruby' | 'cj-ruby-both':
					if (!dad.animation.curAnim.name.contains('2'))
						dad.dance();
				case 'amor-ex':
					if (!dad.animation.curAnim.name.contains('drop'))
						dad.dance();
				case 'bb-tired' | 'bb':
					if (curBeat % 4 == 0)
						dad.dance();
				default:
					dad.dance();
			}		
		}

		if (duoDad)
		{
			if (!dad1.animation.curAnim.name.startsWith("sing") && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				dad1.dance();	
		}

		if (triple)
		{
			if (!dad1.animation.curAnim.name.startsWith("sing") && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				dad1.dance();	
		
			if (!dad2.animation.curAnim.name.startsWith("sing") && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				dad2.dance();		
		}
		
		if (curStage == 'auditorHell' && dad.curCharacter == 'exTricky')
		{
			if (curBeat % 8 == 4 && beatOfFuck != curBeat)
			{
				beatOfFuck = curBeat;
				doClone(FlxG.random.int(0,1));
			}
		}

		if (dad.animation.curAnim.name == 'idle' && curStage == 'night') 
			Stage.swagBacks['pc'].animation.play('idle');

		if (curBeat % gfSpeed == 0)
		{
			if (!picoCutscene)
				gf.dance();

			if (FlxG.save.data.flashing)
			{
				if (curStage == "manifest")
				{
					Stage.swagBacks['manifestBG'].animation.play("idle");
					Stage.swagBacks['manifestFloor'].animation.play("idle");
				}

				if(curStage == "skybroke")
				{
					Stage.swagBacks['manifestBG'].animation.play('idle');
					Stage.swagBacks['manifestHole'].animation.play('idle');
				}
			}			
		}

		if (boyfriend.curCharacter == 'bf-tankman-pixel' && dad.curCharacter != 'senpai-giddy' && !boyfriend.animation.curAnim.name.startsWith("sing"))
			boyfriend.animation.getByName('idle').frames = boyfriend.animation.getByName('idle-alt').frames;

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial-Remix' && curBeat > 16 && curBeat < 64)
			dad.playAnim('cheer', true);

		switch (curStage)
		{
			case 'school-monika':
				if (curSong.toLowerCase() == 'shinkyoku')
					bgGirls2.dance();
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
			case 'school-switch':
				bgGirls.dance();
				bgGirlsUTMJ.dance();
				bgGirlsSFNAF.dance();
				bgGirlsBSAA.dance();
				bgGirlsEdd.dance();
				bfPixelBG.animation.play('idle');
				amyPixelBG.dance();

			case 'eddhouse':
				switch (curSong)
				{
					case 'Norway':
						tomBG.animation.play('idle');
						bfBG.animation.play('idle');
						mattBG.animation.play('idle');
						tordBG.animation.play('idle');
						gfBG.dance();
					case 'Norsky':
						bfBG.animation.play('idle');
						tordBG.animation.play('idle');
					default:
						'';
				}

			case 'mackiestage':
				if (curSong.toLowerCase() == 'gateau')
					smallbgcrowd.animation.play('smallbob', true);
				
				if (curSong.toLowerCase() == 'pom-pomeranian')
				{
					bgcrowd.animation.play('bob', true);
					bgcrowdjump.animation.play('jump', true);
					alya.animation.play('alyabob', true);
					anchor.animation.play('anchorbob', true);
					tricky.animation.play('trickybob', true);
				}

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
			case 'limoholo-night':
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
		}

		if ((dad.curCharacter.contains('ruv') && !dad.curCharacter.contains('smol') && !dad.curCharacter.contains('sarv') && dad.animation.curAnim.name.startsWith('sing') || boyfriend.curCharacter.contains('ruv') && !boyfriend.curCharacter.contains('smol') && !boyfriend.curCharacter.contains('sarv') && boyfriend.animation.curAnim.name.startsWith('sing')) && curBeat > ruvShakeBeat)
			ruvShake();

		if ((dad.curCharacter == 'sarv-ruv' && dad.animation.curAnim.name.startsWith('sing') && !dad.animation.curAnim.name.endsWith('-alt') || boyfriend.curCharacter == 'sarv-ruv' && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('-alt')) && curBeat > ruvShakeBeat) 
			ruvShake();
	}

	var curLight:Int = 0;
}

class Pendulum extends FlxSprite
{
	public var daTween:FlxTween;
	public function new()
	{
		super();
		daTween = FlxTween.tween(this, {x: this.x}, 0.001, {});
	}
}