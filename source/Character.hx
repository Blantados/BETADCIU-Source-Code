package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import lime.app.Application;
import flash.display.BitmapData;

#if windows
import Sys;
import sys.FileSystem;
import sys.io.File;
#end

import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
import flixel.text.FlxText;

using StringTools;

typedef CharacterFile = {
	var animations:Array<AnimArray>;
	var image:String;
	var scale:Float;
	var sing_duration:Float;
	var healthicon:String;

	var position:Array<Float>;
	var camera_position:Array<Float>;

	var flip_x:Bool;
	var no_antialiasing:Bool;
	var healthbar_colors:Array<Int>;
}

typedef AnimArray = {
	var anim:String;
	var name:String;
	var fps:Int;
	var loop:Bool;
	var indices:Array<Int>;
	var offsets:Array<Int>;
	var playerOffsets:Array<Int>;
}

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var isCustom:Bool = false;
	public var altAnim:String = '';
	public var bfAltAnim:String = '';
	public var danceIdle:Bool = false; //Character use "danceLeft" and "danceRight" instead of "idle" "-- why didn't i think of this?"
	
	public var isPixel:Bool = false;
	public var noteSkin:String = PlayState.SONG.noteStyle;
	public var iconColor:String;
	public var trailColor:String;

	public var holdTimer:Float = 0;

	public var daZoom:Float = 1;

	public var tex:FlxAtlasFrames;
	public var exSpikes:FlxSprite;

	public static var colorPreString:FlxColor;
	public static var colorPreCut:String; 

	var pre:String = "";

	//psych method. yay!
	public var imageFile:String = '';
	public var jsonScale:Float = 1;
	public var noAntialiasing:Bool = false;
	public var healthColorArray:Array<Int> = [255, 0, 0];
	public var positionArray:Array<Float> = [0, 0];
	public var cameraPosition:Array<Float> = [0, 0];
	public var singDuration:Float = 4; //Multiplier of how long a character holds the sing pose
	public var animationsArray:Array<AnimArray> = [];

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;
		iconColor = isPlayer ? 'FF66FF33' : 'FFFF0000';
		trailColor = isPlayer ? "FF0026FF" : "FFAA0044";
				
		antialiasing = true;
		isCustom = false;
		pre = "";
		
		switch (curCharacter)
		{
			case 'gf' | 'gf-special' | 'gf-demon' | 'gf-christmas' | 'gf-bw' | 'madgf' | 'gf-kaity' | 'gf-hex' | 'gf-pico' | 'gf-cassandra-bw' | 'gf-alya-bw' | 'gf-pico-bw' | 'gf-monika-bw' 
			| 'madgf-christmas'	| 'gf-arcade' | 'gf-ghost' | 'gf-b3' | 'gf-aloe' | 'gf-pelo-spooky' | 'gf-bf' | 'gf-bf-bw' | 'gf-demona' | 'gf-bw2' | 'gf-mii' | 'gfHalloween' | 'gf-kaguya':
				// GIRLFRIEND CODE
				switch (curCharacter)
				{
					case 'gf-demon': frames = Paths.getSparrowAtlas('characters/GF_demon_assets');							
					case 'gf-arcade': frames = Paths.getSparrowAtlas('characters/GF_arcade_assets');					
					case 'gf-special': frames = Paths.getSparrowAtlas('characters/GF_Special');				
					case 'gf-christmas': frames = Paths.getSparrowAtlas('characters/gfChristmas');	
					case 'gf-ghost': frames = Paths.getSparrowAtlas('characters/gfghost');											
					case 'madgf': frames = Paths.getSparrowAtlas('characters/madGF_assets');								
					case 'madgf-christmas': frames = Paths.getSparrowAtlas('characters/madgfChristmas');						
					case 'gf-kaity': frames = Paths.getSparrowAtlas('characters/GF_Kaity_assets');	
					case 'gf-hex': frames = Paths.getSparrowAtlas('characters/GF_Hex_assets');				
					case 'gf-pico': frames = Paths.getSparrowAtlas('characters/GF_Pico_assets');				
					case 'gf-cassandra-bw': frames = Paths.getSparrowAtlas('characters/bw/Cassandra_GF_assets');			
					case 'gf-alya-bw': frames = Paths.getSparrowAtlas('characters/bw/GF_Alya_assets');					
					case 'gf-pico-bw': frames = Paths.getSparrowAtlas('characters/bw/GF_Pico_assets');					
					case 'gf-monika-bw': frames = Paths.getSparrowAtlas('characters/bw/Monika_GF_assets');					
					case 'gf-b3': frames = Paths.getSparrowAtlas('characters/b3/GF_assets');			
					case 'gf-aloe': frames = Paths.getSparrowAtlas('characters/GF_Aloe_assets');			
					case 'gf-pelo-spooky': frames = Paths.getSparrowAtlas('characters/GF_assets_pelo_spooky');
					case 'gf-bf': frames = Paths.getSparrowAtlas('characters/GF_BF_assets');	
					case 'gf-bf-bw': frames = Paths.getSparrowAtlas('characters/bw/GF_BF_assets');	
					case 'gf-demona': frames = Paths.getSparrowAtlas('characters/demona');	
					case 'gfHalloween': frames = Paths.getSparrowAtlas('characters/GF_assets_halloween');		
					case 'gf-kaguya': frames = Paths.getSparrowAtlas('characters/Kaguya_GF_assets');			
					case 'gf': 
						frames = Paths.getSparrowAtlas('characters/GF_assets');				
						iconColor = 'FF9A1652';
					case 'gf-bw' | 'gf-bw2': 
						if (curCharacter == 'gf-bw2') pre = '_2';
						frames = Paths.getSparrowAtlas('characters/bw/GF_assets'+pre);	
					case 'gf-mii':
						frames = Paths.getSparrowAtlas('characters/GF_MII_assets');		
				}

				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);
				animation.addByPrefix('transform', 'GF Transform', 24, false);

				if (curCharacter == 'gf-ghost'){
					loadOffsetFile(curCharacter);
				}
				else {
					loadOffsetFile('gf');
				}		

				playAnim('danceRight');

			case 'gf-realdoki':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/DDLCGF_ass_sets');
				frames = tex;
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('countdownThree', 'GF countdown', [0, 1, 2, 3, 4, 5, 6], "", 24, false);
				animation.addByIndices('countdownTwo', 'GF countdown', [7, 8, 9, 10, 11, 12, 13, 14, 15], "", 24, false);
				animation.addByIndices('countdownOne', 'GF countdown', [16, 17, 18, 19, 20, 21, 22, 23], "", 24, false);
				animation.addByIndices('countdownGo', 'GF countdown', [24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34], "", 24, false);
				animation.addByPrefix('necksnap', 'GF NECKSNAP', 24, true);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'gf-tea' | 'gf-tea-bw':
				switch (curCharacter)
				{
					case 'gf-tea':
						frames = Paths.getSparrowAtlas('characters/Tea_GF_assets');
					case 'gf-tea-bw':
						frames = Paths.getSparrowAtlas('characters/bw/Tea_GF_assets');
				}
				
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -13);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 1, -8);
				addOffset('hairFall', 0, -8);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-kinky':
				tex = Paths.getSparrowAtlas('characters/gf_but_spicy');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);	
				animation.addByIndices('danceLeft-alt', 'GF Dancing Beat edgy', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight-alt', 'GF Dancing Beat edgy', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'gf-judgev2':
				frames = Paths.getSparrowAtlas('characters/GF_Tablev2');
				
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('spooked', 'GF_Spooked', 24);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * 0.6));
				updateHitbox();

				playAnim('danceRight');
			case 'cj-tied' :
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/cj_tied');
				frames = tex;
				animation.addByIndices('danceLeft', 'CJ', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'CJ', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				playAnim('danceRight');

			case 'gf-tied':
				tex = Paths.getSparrowAtlas('characters/EX Tricky GF');
				frames = tex;

				animation.addByIndices('danceLeft','GF Ex Tricky',[0,1,2,3,4,5,6,7,8], "", 24, false);
				animation.addByIndices('danceRight','GF Ex Tricky',[9,10,11,12,13,14,15,16,17,18,19], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'gf-ex-night':
				noteSkin = 'gf';
				tex = Paths.getSparrowAtlas('characters/GF_ass_sets_outfit_with_bb');
				frames = tex;
				animation.addByIndices('sad', 'GF Dancing Beat EX instance 1', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat EX instance 1', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat EX instance 1', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);
				addOffset('sad', 0);

				playAnim('danceRight');

			case 'gf-selever' | 'gf-selever-special' | 'gf-selever-bop':
				switch (curCharacter)
				{
					case 'gf-selever' | 'gf-selever-special':
						frames = Paths.getSparrowAtlas('characters/GF_Selever_assets');
					case 'gf-selever-bop':
						frames = Paths.getSparrowAtlas('characters/GF_Selever_bop');
				}
				
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				switch (curCharacter)
				{
					case 'gf-selever':
						animation.addByPrefix('scared', 'GF FEAR', 24);
					case 'gf-selever-special':
						animation.addByIndices('1', 'GF 1', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);	
				}
				

				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
				
				switch (curCharacter)
				{
					case  'gf-selever':
						addOffset('scared', 0, -9);
					case 'gf-selever-special':
						addOffset('1', 0, -9);
				}
				
				playAnim('danceRight');

			case 'gf-nospeaker' | 'gf-tea-nospeaker' | 'gf-tea-nospeaker-trollge':
				switch (curCharacter)
				{
					case 'gf-nospeaker':
						frames = Paths.getSparrowAtlas('characters/nospeakergf');
					case 'gf-tea-nospeaker':
						frames = Paths.getSparrowAtlas('characters/nospeakertea');
					case 'gf-tea-nospeaker-trollge':
						frames = Paths.getSparrowAtlas('characters/nospeakertea_trollge');
				}

				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'gf-tabi-crazy':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('tabi/fire/PostExpGF_Assets');
				frames = tex;
				animation.addByIndices('danceLeft', 'GF LayedDownHurt ', [0, 1, 2, 3, 4, 5, 6, 7], "", 24, false);
				animation.addByIndices('danceRight', 'GF LayedDownHurt ', [8, 9, 10, 11, 12, 13, 14, 15], "", 24, false);
		
				addOffset('danceLeft', -300, -250);
				addOffset('danceRight', -300, -250);

				playAnim('danceRight');

			case 'gf-peri-whitty':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/gfPeriWhitty');
				frames = tex;
				animation.addByIndices('danceLeft', 'GF Dancing Beat Peri', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Peri', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				playAnim('danceRight');

			case 'gf-nene' | 'gf-nene-bw' | 'gf-nene-cry' | 'gf-nene-aloe' | 'gf-nene-corrupt' | 'gf-nene-past' | 'gf-nene-gf':
				switch (curCharacter)
				{
					case 'gf-nene' | 'gf-nene-bw' | 'gf-nene-corrupt':
						if (curCharacter == 'gf-nene-bw') pre = 'bw/';
						if (curCharacter == 'gf-nene-corrupt') pre = 'corruption/';
						frames = Paths.getSparrowAtlas('characters/'+pre+'Nene_GF_assets');
					case 'gf-nene-cry':
						frames = Paths.getSparrowAtlas('characters/Nene_GF_assets_cry');
					case 'gf-nene-aloe':
						frames = Paths.getSparrowAtlas('characters/NA_GF_assets');
					case 'gf-nene-past':
						frames = Paths.getSparrowAtlas('characters/corruption/Nene_GF_assets_past');
					case 'gf-nene-gf':
						frames = Paths.getSparrowAtlas('characters/Nene_And_GF_assets');
				}
				
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);
			
				addOffset('sad', -2, 13);
				addOffset('danceLeft', 0, 31);
				addOffset('danceRight', 0, 31);
				addOffset('scared', -2, 28);

				if (curCharacter != 'gf-nene-cry')
				{
					addOffset('cheer', 0, 33);
					addOffset("singUP", 0, 46);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", 0, 16);
					addOffset("singDOWN", 0, 21);
					addOffset('hairBlow', 45, 31);
					addOffset('hairFall', 0, 31);		
				}		

				playAnim('danceRight');
				
			case 'gf1':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/gf1');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer', 0, 13);
				addOffset('sad', -2, 12);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 44);
				addOffset("singRIGHT", 0, 25);
				addOffset("singLEFT", 0, 15);
				addOffset("singDOWN", 0, 20);
				addOffset('hairBlow', 0, 32);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -27);

				playAnim('danceRight');

			case 'gf2':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/gf2');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);

				addOffset('cheer', 0, -6);
				addOffset('sad', -2, -20);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", -1, 6);
				addOffset("singRIGHT", 0, -15);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -17);
				addOffset('hairBlow', 0, -9);
				addOffset('hairFall', 0, -9);

				playAnim('danceRight');

			case 'gf3':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/gf3');
				frames = tex;
				animation.addByPrefix('cheer', 'GF FEAR', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);

				addOffset('cheer', -2, -19);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, -9);
				addOffset("singRIGHT", 0, -15);
				addOffset("singLEFT", 1, -28);
				addOffset("singDOWN", 0, -32);
				addOffset('hairBlow', 0, -7);
				addOffset('hairFall', 0, -9);

				playAnim('danceRight');

			case 'gf4':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/gf4');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);

				addOffset('cheer', 0, -6);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", -1, 6);
				addOffset("singRIGHT", 0, -15);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -17);
				addOffset('hairBlow', 0, -9);
				addOffset('hairFall', 0, -9);

				playAnim('danceRight');

			case 'gf5':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/gf5');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);

				addOffset('cheer', 0, 1);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", -1, -14);
				addOffset("singRIGHT", 0, -48);
				addOffset("singLEFT", 0, -63);
				addOffset("singDOWN", 0, -17);
				addOffset('hairBlow', 39, -8);
				addOffset('hairFall', 0, -9);

				playAnim('danceRight');

			case 'gf-tabi':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_TABI');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('cheer');
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				playAnim('danceRight');

			case 'nogf' | 'emptygf' | 'nogf-night' | 'nogf-wire' | 'nogf-christmas' | 'nogf-rebecca' | 'nogf-glitcher' | 'nogf-bw' | 'nogf-r':
				// GIRLFRIEND CODE
				switch (curCharacter)
				{
					case 'nogf':
						frames = Paths.getSparrowAtlas('characters/nogf_assets');
					case 'nogf-r':
						frames = Paths.getSparrowAtlas('characters/nogfr_assets');
					case 'emptygf':
						frames = Paths.getSparrowAtlas('characters/emptygf_assets');
					case 'nogf-night':
						frames = Paths.getSparrowAtlas('characters/nogf_night');
					case 'nogf-wire':
						frames = Paths.getSparrowAtlas('characters/nogf_assets_WIRE');
					case 'nogf-christmas':
						frames = Paths.getSparrowAtlas('characters/nogf_christmas_assets');
					case 'nogf-rebecca':
						frames = Paths.getSparrowAtlas('characters/nogf_rebecca');
					case 'nogf-glitcher':
						frames = Paths.getSparrowAtlas('characters/nogf_glitcher');
					case 'nogf-bw':
						frames = Paths.getSparrowAtlas('characters/bw/nogf_assets');
				}
				
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByIndices('sad', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('hairBlow', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('hairFall', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('scared', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('cheer');
				addOffset('sad', 0, -9);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset('scared', 0, -9);

				playAnim('danceRight');

			case 'gf-ruv' | 'gf-ruv-bw' | 'gf-ruv-glitcher':
				switch (curCharacter)
				{
					case 'gf-ruv':
						tex = Paths.getSparrowAtlas('characters/GF_Ruv');
					case 'gf-ruv-bw':
						tex = Paths.getSparrowAtlas('characters/bw/GF_Ruv');
					case 'gf-ruv-glitcher':
						tex = Paths.getSparrowAtlas('characters/GF_Ruv_Glitcher');
				}
				frames = tex;
				animation.addByIndices('sad', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('hairBlow', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('hairFall', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				playAnim('danceRight');

			case 'gfandbf-fear':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GFANDBF_assets');
				frames = tex;
				animation.addByPrefix('sad', 'GF Cheer', 24, false);
				animation.addByPrefix('danceLeft', 'GF FEAR', 24);
				animation.addByPrefix('danceRight', 'GF FEAR', 24);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('sad');
				addOffset('danceLeft', -2, -17);
				addOffset('danceRight', -2, -17);

				playAnim('danceRight');

			case 'gfandbf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GFANDBF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [23, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22], "", 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('sad');
				addOffset('cheer');
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				playAnim('danceRight');

			case 'gf-bf-radio' | 'gf-bf-city':
				// GIRLFRIEND CODE
				switch (curCharacter)
				{
					case 'gf-bf-radio':
						frames = Paths.getSparrowAtlas('characters/bf-radio');
					case 'gf-bf-city':
						frames = Paths.getSparrowAtlas('characters/bfcity');
				} 

				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'gf-sarv':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/sarvGF');
				frames = tex;
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [23, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22], "", 24, false);

				addOffset('danceLeft', 200, 200);
				addOffset('danceRight', 200, 200);
				
				playAnim('danceRight');

				setGraphicSize(Std.int(width * 0.9));
				updateHitbox();

			case 'gf-tankmen' | 'gf-tea-tankmen':
				// GIRLFRIEND CODE
				switch (curCharacter)
				{
					case 'gf-tankmen':
						frames = Paths.getSparrowAtlas('characters/gfTankmen');
					case 'gf-tea-tankmen':
						frames = Paths.getSparrowAtlas('characters/teaTankmen');
				}
				
				animation.addByIndices('sad', 'GF Crying at Gunpoint', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing at Gunpoint', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing at Gunpoint', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
				
				playAnim('danceRight');

			case 'crazygf-crucified' | 'nogf-crucified':
				// GIRLFRIEND CODE
				switch (curCharacter)
				{
					case 'crazygf-crucified':
						tex = Paths.getSparrowAtlas('sky/crazygf');
					case 'nogf-crucified':
						tex = Paths.getSparrowAtlas('sky/nogf');
				}	
				
				frames = tex;
				animation.addByIndices('sad', 'GF miss', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF idle', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF idle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile('no-gf');
				
				playAnim('danceRight');

			case 'gf-crucified' | 'gf-tea-crucified':
				switch (curCharacter)
				{
					case 'gf-crucified':
						frames = Paths.getSparrowAtlas('sky/gf');
						iconColor = 'FF9A1652';
					case 'gf-tea-crucified':
						frames = Paths.getSparrowAtlas('sky/tea');
				}
				
				animation.addByIndices('sad', 'GF miss', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF idle', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF idle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('singLEFT', 'GF Left Note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);

				loadOffsetFile('no-gf');
				
				playAnim('danceRight');

			case 'gf-car' | 'dalia-car':
				switch (curCharacter)
				{
					case 'gf-car':
						tex = Paths.getSparrowAtlas('characters/gfCar');
					case 'dalia-car':
						tex = Paths.getSparrowAtlas('characters/daliaCar');
				}
				
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile('no-gf');

				playAnim('danceRight');

			case 'gf-rock2':
				frames = Paths.getSparrowAtlas('characters/GF_rock');
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);

				addOffset('hairBlow', 45, -8);

				playAnim('hairBlow');

			case 'holo-cart' | 'holo-cart-hover' | 'holo-cart-ohno':
				switch (curCharacter)
				{
					case 'holo-cart':
						tex = Paths.getSparrowAtlas('characters/holoCart');
					case 'holo-cart-hover':
						tex = Paths.getSparrowAtlas('characters/holoCartHover');
					case 'holo-cart-ohno':
						tex = Paths.getSparrowAtlas('characters/holoCartOhNo');
				}
				
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 120, 10);
				addOffset('danceRight', 120, 10);

				playAnim('danceRight');

			case 'gf-pixel' | 'gf-tankman-pixel' | 'gf-pixel-mario' | 'amy-pixel-mario' | 'piper-pixel-mario' | 'piper-pixeld2' | 'gf-pixel-neon' | 'gf-playtime' | 'nogf-pixel' | 'gf-edgeworth-pixel' | 'gf-flowey':
				switch (curCharacter)
				{
					case 'gf-pixel':
						tex = Paths.getSparrowAtlas('characters/gfPixel');
					case 'gf-tankman-pixel':
						tex = Paths.getSparrowAtlas('characters/gfTankmanPixel');
					case 'gf-pixel-mario':
						tex = Paths.getSparrowAtlas('characters/gfPixelMario');
					case 'amy-pixel-mario':
						tex = Paths.getSparrowAtlas('characters/amyPixelMario');
					case 'piper-pixel-mario':
						tex = Paths.getSparrowAtlas('characters/piperPixelMario');
					case 'piper-pixeld2':
						tex = Paths.getSparrowAtlas('characters/piperPixeld2');
					case 'gf-pixel-neon':
						tex = Paths.getSparrowAtlas('characters/gfPixelNeon');
					case 'gf-playtime':
						tex = Paths.getSparrowAtlas('characters/gfPlaytime');
					case 'nogf-pixel':
						tex = Paths.getSparrowAtlas('characters/nogfPixel');
					case 'gf-edgeworth-pixel':
						tex = Paths.getSparrowAtlas('characters/gfEdgeworthPixel');
					case 'gf-flowey':
						tex = Paths.getSparrowAtlas('characters/gfFlowey');
				}
				
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile('no-gf');

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'gf-edd':
				tex = Paths.getSparrowAtlas('tord/gfEdd');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [12, 0, 1, 2, 3, 4, 5], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [6, 7, 8, 9, 10, 11], "", 24, false);

				loadOffsetFile('no-gf');

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'gf-pixeld4' | 'gf-pixeld4BSide':
				switch (curCharacter)
				{
					case 'gf-pixeld4':
						tex = Paths.getSparrowAtlas('characters/gfPixeld4');
					case 'gf-pixeld4BSide':
						tex = Paths.getSparrowAtlas('characters/gfPixeld4BSide');
				}
				
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByPrefix('switch', 'GF SWITCH', 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile('no-gf');

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'miku':
				frames = Paths.getSparrowAtlas('characters/ev_miku_assets');
				iconColor = 'FF32CDCC';
				animation.addByPrefix('idle', 'Miku idle dance', 24, false);
				animation.addByPrefix('hey', 'miku hey', 24, false);
				animation.addByPrefix('singUP', 'Miku Sing Note UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'Miku Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'Miku Sing Note DOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'Miku Sing Note LEFT0', 24, false);
				animation.addByPrefix('singUPmiss', 'Miku Sing Note UP MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Miku Sing Note RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Miku Sing Note DOWN MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Miku Sing Note LEFT MISS', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'miku-mad' | 'miku-mad-christmas':
				switch (curCharacter)
				{
					case 'miku-mad':
						frames = Paths.getSparrowAtlas('characters/ev_miku_mad');
						iconColor = 'FF32CDCC';
					case 'miku-mad-christmas':
						frames = Paths.getSparrowAtlas('characters/ev_miku_mad_christmas');
						iconColor = 'FFFF3E3F';
				}
				animation.addByPrefix('idle', 'Miku idle dance', 24, false);
				animation.addByPrefix('idle-alt', 'Miku idle dance', 24, false);
				animation.addByPrefix('singUP', 'Miku Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Miku Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Miku Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Miku Sing Note LEFT', 24, false);
				animation.addByPrefix('singUP-alt', 'Miku Scream Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Miku Scream Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Miku Scream Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Miku Scream Sing Note LEFT', 24, false);

				loadOffsetFile('miku-mad');

				playAnim('idle');

			case 'dad' | 'dad-flipped' | 'dad-pixel':
				switch (curCharacter)
				{
					case 'dad-pixel':
						frames = Paths.getSparrowAtlas('characters/DAD_PIXEL');
						noteSkin = 'pixel';
					default:
						frames = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
				}
				
				
				iconColor = 'FFAF66CE';
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP0', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'Dad Sing Note UP MISS0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Dad Sing Note RIGHT MISS0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Dad Sing Note DOWN MISS0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Dad Sing Note LEFT MISS0', 24, false);

				if (curCharacter.contains('-flipped'))
				{
					animation.addByPrefix('singLEFT', 'Dad Sing Note RIGHT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Dad Sing Note LEFT0', 24, false);
				}
				else
				{
					animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT0', 24, false);
					animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT0', 24, false);		
				}

				if (curCharacter == 'dad-pixel')
					loadOffsetFile('dad');
				else
					loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'cg5' | 'calli' | 'calli-mad-new' | 'calli-sad-new' | 'calli-mad' | 'calli-sad' | 'calli-sad2' | 'calli-sad3' | 'dad-b3' | 'midas' | 'midas-r' | 'anders' | 'anders-fearsome'
			| 'midas-double' | 'calli-past':
				iconColor = 'FFFF9FC0';
				switch (curCharacter)
				{
					case 'cg5':
						frames = Paths.getSparrowAtlas('characters/CG5');
						iconColor = 'FF003366';
					case 'calli':
						frames = Paths.getSparrowAtlas('characters/CALLI');
					case 'calli-mad-new':
						frames = Paths.getSparrowAtlas('characters/CALLI_MAD');
					case 'calli-sad-new':
						frames = Paths.getSparrowAtlas('characters/CALLI_SAD');
					case 'calli-mad':
						frames = Paths.getSparrowAtlas('characters/corruption/CALLI_MAD');
					case 'calli-past':
						frames = Paths.getSparrowAtlas('characters/corruption/CALLI_PAST');
						iconColor = 'FFC0C0C0';
						noteSkin = '1930';
					case 'calli-sad':
						frames = Paths.getSparrowAtlas('characters/corruption/CALLI_SAD');
					case 'calli-sad2':
						frames = Paths.getSparrowAtlas('characters/corruption/CALLI_SAD2');
					case 'calli-sad3':
						frames = Paths.getSparrowAtlas('characters/corruption/CALLI_SAD3');
					case 'dad-b3':
						frames = Paths.getSparrowAtlas('characters/b3/DADDY_DEAREST');
						iconColor = 'FF6E5D71';
					case 'midas' | 'midas-double' | 'midas-r':
						if (curCharacter == 'midas-double')pre = "_DOUBLE";
						if (curCharacter == 'midas-r')pre = "_R";
						frames = Paths.getSparrowAtlas('characters/MIDAS'+pre);
						iconColor = 'FFFDC405';
					case 'anders' | 'anders-fearsome':
						frames = Paths.getSparrowAtlas('characters/'+curCharacter);
						iconColor = 'FF464651';
				}
					
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT0', 24, false);
			
				if (curCharacter == 'midas-double')
				{
					animation.addByPrefix('idle-alt', 'Dad Alt idle dance', 24, false);
					animation.addByPrefix('singUP-alt', 'Dad Alt Sing Note UP0', 24, false);
					animation.addByPrefix('singRIGHT-alt', 'Dad Alt Sing Note RIGHT0', 24, false);
					animation.addByPrefix('singDOWN-alt', 'Dad Alt Sing Note DOWN0', 24, false);
					animation.addByPrefix('singLEFT-alt', 'Dad Alt Sing Note LEFT0', 24, false);
				}

				switch (curCharacter)
				{
					case 'calli' | 'calli-mad-new' | 'calli-sad-new' | 'calli-past':
						loadOffsetFile('calli');					
					case 'calli-mad' | 'calli-sad' | 'calli-sad2' | 'calli-sad3':
						addOffset('idle');
						addOffset("singUP", -9, 8);
						addOffset("singRIGHT", 0, 10);
						addOffset("singLEFT", 0, -11);
						addOffset("singDOWN");
					case 'midas-r':
						loadOffsetFile('midas');
					default:
						loadOffsetFile(curCharacter);
				}
				
				playAnim('idle');

			case 'beardington':
				frames = Paths.getSparrowAtlas('characters/Beardington_Assets');
				iconColor = 'FFF266FF';

				animation.addByPrefix('idle', 'Beardington idle dance', 24, false);
				animation.addByPrefix('singUP', 'Beardington Sing Note UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'Beardington Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'Beardington Sing Note DOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'Beardington Sing Note LEFT0', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -25, 0);
					addOffset("singRIGHT", -30, -30);
					addOffset("singLEFT", 30, -35);
					addOffset("singDOWN", -10, -40);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", -75, 0);
					addOffset("singLEFT", 10, -30);
					addOffset("singRIGHT", -30, -35);
					addOffset("singDOWN", -60, -40);
				}

				playAnim('idle');

			case 'snow':
				frames = Paths.getSparrowAtlas('characters/snow_assets');
				iconColor = 'FFBA4544';
				
				animation.addByPrefix('idle', 'SnowIdle', 24, false);
				animation.addByPrefix('singUP', 'SnowUp', 24, false);
				animation.addByPrefix('singRIGHT', 'SnowRight', 24, false);
				animation.addByPrefix('singDOWN', 'SnowDown', 24, false);
				animation.addByPrefix('singLEFT', 'SnowLeft', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -16, 30);
					addOffset("singRIGHT", -30, -15);
					addOffset("singLEFT", 25, -13);
					addOffset("singDOWN", 0, -25);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", -16, 30);
					addOffset("singRIGHT", -25, -13);
					addOffset("singLEFT", 20, -15);
					addOffset("singDOWN", 0, -25);
				}

				playAnim('idle');

			case 'blantad-new' | 'blantad-watch' | 'blantad-blue':
				switch (curCharacter)
				{
					case 'blantad-new':
						frames = Paths.getSparrowAtlas('characters/Blantad_New');
						iconColor = 'FF64B3FE';
					case 'blantad-watch':
						frames = Paths.getSparrowAtlas('characters/blantad_watch');
						iconColor = 'FF64B3FE';
					case 'blantad-blue':
						frames = Paths.getSparrowAtlas('characters/blue/BlantadStarving');
				}				
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT0', 24, false);

				loadOffsetFile('blantad');

				playAnim('idle');

			case 'blantad-scream':
				frames = Paths.getSparrowAtlas('characters/blantad_scream');
				iconColor = 'FF64B3FE';

				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('idle-alt', 'Blantad Powerful Idle', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT0', 24, false);
				animation.addByPrefix('singUP-alt', 'Dad Sing Note UP WIRE', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Dad Sing Note RIGHT WIRE', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Dad Sing Note DOWN WIRE', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Dad Sing Note LEFT WIRE', 24, false);
				animation.addByPrefix('scream', 'Blantad Power Up', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'blantad-handscutscene':
				tex = Paths.getSparrowAtlas('characters/BlantadCutscene');
				frames = tex;
				iconColor = 'FF64B3FE';
				animation.addByPrefix('idle', 'Powerful Idle', 24, false);
				animation.addByPrefix('singUP', 'Blantados Warning Glint', 24, false);
				animation.addByPrefix('singDOWN', 'Blantados Warning Glint', 24, false);
				animation.addByPrefix('singLEFT', 'Blantados Warning Glint', 24, false);
				animation.addByPrefix('singRIGHT', 'Blantados Warning Glint', 24, false);
				animation.addByPrefix('warning-special', 'Blantados Warning Glint', 24, false);
				animation.addByPrefix('lift-special', 'BlantadosLiftthing', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset('singUP', 15, 0);
					addOffset('warning-special', 15, 0);
					addOffset('lift-special', -5, 10);
				}
				else
				{
					addOffset('idle');
					addOffset('singUP', -20, 0);
					addOffset('warning-special', -20, 0);
					addOffset('lift-special', 85, 10);
				}

				playAnim('idle');

			case 'blantad-teleport':
				tex = Paths.getSparrowAtlas('characters/BlantadTeleport');
				frames = tex;
				iconColor = 'FF64B3FE';
				animation.addByPrefix('idle', "teleport", 24, false);
				animation.addByPrefix('singUP', "teleport", 24, false);
				animation.addByPrefix('singDOWN', "teleport", 24, false);
				animation.addByPrefix('singLEFT', "teleport", 24, false);
				animation.addByPrefix('singRIGHT', "teleport", 24, false);
				animation.addByPrefix('tele-special', 'teleport', 24, false);

				addOffset('idle');
				addOffset('tele-special', 88, 35);
				addOffset('singUP');
				addOffset('singDOWN');
				addOffset('singLEFT');
				addOffset('singRIGHT');

				playAnim('idle');

			case 'blantad-handscutscene2':
				tex = Paths.getSparrowAtlas('holofunk/limoholo/FlyingBlantad');
				iconColor = 'FF64B3FE';
				frames = tex;
				animation.addByPrefix('idle', "FlyingBlantados", 24, false);
				animation.addByPrefix('tele', 'tele2', 24, false);

				addOffset('idle');
				addOffset('tele', 520, 370);

				playAnim('idle');

				setGraphicSize(Std.int(width * 0.65));
				updateHitbox();

			case 'dad-mad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST_D3');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT0', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -12, 50);
					addOffset("singRIGHT", -40, 10);
					addOffset("singLEFT", 40, 27);
					addOffset("singDOWN", 40, -30);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", -1, 52);
					addOffset("singRIGHT", -1, 13);
					addOffset("singLEFT", 61, 20);
					addOffset("singDOWN", 5, -29);
				}

				playAnim('idle');

			case 'dad-sad'| 'dad-sad-pixel':
				switch (curCharacter)
				{
					case 'dad-sad':
						tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST_D3_Sad');
					case 'dad-sad-pixel':
						tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST_D3_Sad_Pixel');
				}
				
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				
				animation.addByPrefix('singUP', 'Dad Sing Note UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT0', 24, false);
				
				if (curCharacter == 'dad-sad-pixel')
				{
					animation.addByPrefix('idle-alt', 'Dad idle dance', 24, false);
					animation.addByPrefix('singDOWN-alt', 'Dad Alt Sing Note DOWN0', 24, false);
				}

				addOffset('idle');

				if (isPlayer)
				{				
					addOffset("singUP", -12, 50);
					addOffset("singRIGHT", -40, 10);
					addOffset("singLEFT", 40, 27);
					addOffset("singDOWN", 40, -30);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", 1, 58);
					addOffset("singRIGHT", -4, 38);
					addOffset("singLEFT", 42, 19);
					addOffset("singDOWN", -1, -20);
					if (curCharacter == 'dad-sad-pixel')
					{
						addOffset("singDOWN-alt", -1, -20);
					}			
				}

				playAnim('idle');

			case 'cyrix':	
				tex = Paths.getSparrowAtlas('characters/Cyrix');
				frames = tex;
				iconColor = 'FF88DE30';

				animation.addByPrefix('idle', 'cyrix idle', 24);
				animation.addByPrefix('singUP', 'cyrix up note', 24);
				animation.addByPrefix('singRIGHT', 'cyrix right note', 24);
				animation.addByPrefix('singDOWN', 'cyrix down note', 24);
				animation.addByPrefix('singLEFT', 'cyrix left note', 24);

				addOffset('idle', 0, 0);
				addOffset("singUP", 31, 18);
				addOffset("singRIGHT", 18, -24);
				addOffset("singLEFT", 21, -15);
				addOffset("singDOWN", 2, -42);
	
				playAnim('idle');

				this.scale.x = 0.85;
				this.scale.y = 0.85;

			case 'cyrix-crazy':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/Cyrix_Crazy');
				iconColor = 'FF88DE30';
				noteSkin = PlayState.SONG.noteStyle;
	
				animation.addByPrefix('idle', 'crazycyrix idle', 24);
				animation.addByPrefix('singUP', 'crazycyrix up note', 24);
				animation.addByPrefix('singRIGHT', 'crazycyrix right note', 24);
				animation.addByPrefix('singDOWN', 'crazycyrix down note', 24);
				animation.addByPrefix('singLEFT', 'crazycyrix left note', 24);
			
				loadOffsetFile(curCharacter);
			
				playAnim('idle');
		
				this.scale.x = 0.85;
				this.scale.y = 0.85;

			case 'rebecca':
				frames = Paths.getSparrowAtlas('characters/rebecca_asset');
				iconColor = 'FF19618C';
				animation.addByPrefix('idle', 'rebecca idle dance', 24);
				animation.addByPrefix('singUP', 'rebecca Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'rebecca Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'rebecca Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'rebecca Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'henry' | 'henry-blue':
				switch (curCharacter)
				{
					case 'henry':
						tex = Paths.getSparrowAtlas('characters/henry');
						iconColor = 'FFE1E1E1';
					case 'henry-blue':
						tex = Paths.getSparrowAtlas('characters/blue/henry');
				}
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				loadOffsetFile('henry');			

				setGraphicSize(Std.int(width * 1.3));
				updateHitbox();

				playAnim('idle');

			case 'shaggy':
				frames = Paths.getSparrowAtlas('characters/shaggy');
				iconColor = 'FF33724A';

				animation.addByPrefix('danceLeft', 'shaggy_idle0', 24, false);
				animation.addByPrefix('danceRight', 'shaggy_idle2', 24, false);
				animation.addByPrefix('singUP', 'shaggy_up', 20, false);
				animation.addByPrefix('singRIGHT', 'shaggy_right', 20, false);
				animation.addByPrefix('singDOWN', 'shaggy_down', 24, false);
				animation.addByPrefix('singLEFT', 'shaggy_left', 24, false);

				animation.addByPrefix('power', 'shaggy_powerup', 30, false);
				animation.addByPrefix('idle_s', 'shaggy_super_idle', 24);
				animation.addByPrefix('danceLeft-alt', 'shaggy_super_idle', 24);
				animation.addByPrefix('danceRight-alt', 'shaggy_super_idle', 24);
				animation.addByPrefix('singUP-alt', 'shaggy_sup2', 20, false);
				animation.addByPrefix('singRIGHT-alt', 'shaggy_sright', 20, false);
				animation.addByPrefix('singDOWN-alt', 'shaggy_sdown', 24, false);
				animation.addByPrefix('singLEFT-alt', 'shaggy_sleft', 24, false);

				loadOffsetFile(curCharacter);			

				playAnim('danceLeft');

			case 'rshaggy':
				frames = Paths.getSparrowAtlas('characters/shaggy_red');
				iconColor = 'FFD11A1A';

				animation.addByPrefix('danceLeft', 'shaggy_idle0', 24, false);
				animation.addByPrefix('danceRight', 'shaggy_idle2', 24, false);
				animation.addByPrefix('singUP', 'shaggy_up', 20, false);
				animation.addByPrefix('singRIGHT', 'shaggy_right', 20, false);
				animation.addByPrefix('singDOWN', 'shaggy_down', 24, false);
				animation.addByPrefix('singLEFT', 'shaggy_left', 24, false);
				animation.addByPrefix('stand', 'shaggy_stand', 30, false);
				animation.addByPrefix('sit', 'shaggy_sit', 30, false);

				loadOffsetFile(curCharacter);			

				playAnim('danceLeft');

			case 'sh-carol':
				frames = Paths.getSparrowAtlas('characters/sh_carol_assets');
				iconColor = 'FFFF6600';
				animation.addByPrefix('idle', 'carol idle', 24, false);
				animation.addByPrefix('singUP', 'carol up', 24, false);
				animation.addByPrefix('singDOWN', 'carol down', 24, false);
				animation.addByPrefix('singLEFT', 'carol left', 24, false);
				animation.addByPrefix('singRIGHT', 'carol right', 24, false);
				
				loadOffsetFile('no');
				playAnim('idle');

			case 'beebz' | 'beebz-b3':
				switch (curCharacter)
				{
					case 'beebz':
						frames = Paths.getSparrowAtlas('characters/beebz');
						iconColor = 'FFA2588C';
					case 'beebz-b3':
						frames = Paths.getSparrowAtlas('characters/b3/beebz');
						iconColor = 'FFA2588C';
				}
				
				animation.addByPrefix('idle', 'Beebz_Idle', 24, false);
				animation.addByPrefix('singUP', 'Beebz_up', 24, false);
				animation.addByPrefix('singDOWN', 'Beebz_down', 24, false);
				animation.addByPrefix('singLEFT', 'Beebz_left', 24, false);
				animation.addByPrefix('singRIGHT', 'Beebz_right', 24, false);
				
				loadOffsetFile('beebz');
				playAnim('idle');

			case 'sky-b3':
				frames = Paths.getSparrowAtlas('characters/b3/sky_assets');
				iconColor = 'FF20AC5D';
				animation.addByIndices('danceLeft', 'sky annoyed idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'sky annoyed idle', [8, 10, 12, 14], "", 12, false);

				animation.addByPrefix('singUP', 'sky annoyed up', 24, false);
				animation.addByPrefix('singDOWN', 'sky annoyed down', 24, false);
				animation.addByPrefix('singLEFT', 'sky annoyed left', 24, false);
				animation.addByPrefix('singRIGHT', 'sky annoyed right', 24, false);

				animation.addByPrefix('huh-special', 'sky annoyed huh', 24, false);
				animation.addByPrefix('oh-special', 'sky annoyed oh', 24, false);
				animation.addByPrefix('derp-special', 'sky derp', 24, false);
				
				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'lila' | 'lila-pelo':
				switch (curCharacter)
				{
					case 'lila':
						frames = Paths.getSparrowAtlas('characters/lila');
					case 'lila-pelo':
						frames = Paths.getSparrowAtlas('characters/lila_pelo');
				}	
				iconColor = 'FF725585';
				
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Dad Clear Throat', 24, false);

				addOffset('idle');

				if (isPlayer)
				{
					switch (curCharacter)
					{
						case 'lila-pelo':
							addOffset("singUP", -12, 50);
							addOffset("singRIGHT", -40, 10);
							addOffset("singLEFT", 40, 27);
							addOffset("singDOWN", 40, -30);
							addOffset("singDOWN-alt", 40, -30);
						case 'lila':
							addOffset("singUP", 38, 50);
							addOffset("singRIGHT", -10, 10);
							addOffset("singLEFT", 40, 27);
							addOffset("singDOWN", 10, -30);
							addOffset("singDOWN-alt", 10, -30);
					}			
				}
				else
				{
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
					addOffset("singDOWN-alt", 0, -30);
				}
				
				playAnim('idle');

			case 'knuckles':
				frames = Paths.getSparrowAtlas('characters/knuckles');
				iconColor = 'FFCC0000';

				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Knuckles Oh No', 24, true);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -12, 50);
					addOffset("singRIGHT", -40, 10);
					addOffset("singLEFT", 40, 27);
					addOffset("singDOWN", 40, -30);
					addOffset("singDOWN-alt", 110, -200);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
					addOffset("singDOWN-alt", 70, -200);
				}		

				playAnim('idle');

			case 'kapi' | 'kapi-angry' | 'hubert' | 'teto' | 'fujiwara':
				iconColor = 'FF4E68C2';
				switch (curCharacter)
				{
					case 'kapi':
						frames = Paths.getSparrowAtlas('characters/KAPI');
						noteSkin = 'kapi';
					case 'kapi-angry':
						frames = Paths.getSparrowAtlas('characters/KAPI_ANGRY');
						noteSkin = 'kapi';
					case 'hubert':
						frames = Paths.getSparrowAtlas('characters/MrSaladHubert');
						noteSkin = PlayState.SONG.noteStyle;
						iconColor = 'FF8A9C5E';
					case 'teto':
						frames = Paths.getSparrowAtlas('characters/TETO');
						iconColor = 'FFE24767';
					case 'fujiwara':
						frames = Paths.getSparrowAtlas('characters/FUJIWARA');
						iconColor = 'FFEAD0D4';
				}
							
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				if (curCharacter == 'fujiwara')
					loadOffsetFile(curCharacter);
				else
					loadOffsetFile('kapi');				

				playAnim('idle');

			case 'cheeky':
				switch(PlayState.SONG.song.toLowerCase()){
					case 'bad eggroll': 
						tex = Paths.getSparrowAtlas('mugen/week3/characters/Mad Cheeky');
					default: 
						tex = Paths.getSparrowAtlas('characters/Cheeky');
				}
				frames = tex;
				iconColor = 'FF3FBFF6';
				animation.addByPrefix('idle', 'Cheeky Idle Dance', 24);
				animation.addByPrefix('singUP', 'Cheeky NOTE UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Cheeky NOTE RIGHT', 32, false);
				animation.addByPrefix('singDOWN', 'Cheeky NOTE DOWN', 32, false);
				animation.addByPrefix('singLEFT', 'Cheeky NOTE LEFT', 24, false);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * 2.25));

				playAnim('idle');
				iconColor = 'FF6EB3CC';

			case 'bf-dad' | 'bf-dad-b3':
				switch (curCharacter)
				{
					case 'bf-dad':
						frames =  Paths.getSparrowAtlas('characters/BFDAD');
						iconColor = 'FF0EAEFE';
					case 'bf-dad-b3':
						frames =  Paths.getSparrowAtlas('characters/b3/BFDAD');
						iconColor = 'FF10A448';
				}
				
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note LEFT', 24, false);

				addOffset('idle');
				
				if (isPlayer)
				{	
					addOffset("singUP", -10, 50);
					addOffset("singRIGHT", -49, 13);
					addOffset("singLEFT", 24, 29);	
					addOffset("singDOWN", 40, -30);		
				}
				else
				{
					addOffset("singUP", -6, 50);
					addOffset("singLEFT", -7, 13);
					addOffset("singRIGHT", 18, 29);	
					addOffset("singDOWN", 0, -30);		
				}

				playAnim('idle');

			case 'agoti':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/AGOTI');
				iconColor = 'FF494949';
				noteSkin = 'agoti';

				animation.addByPrefix('idle', 'Agoti_Idle', 24, false);
				animation.addByPrefix('singUP', 'Agoti_Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Agoti_Right', 24, false);
				animation.addByPrefix('singDOWN', 'Agoti_Down', 24, false);
				animation.addByPrefix('singLEFT', 'Agoti_Left', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'agoti-mad' | 'agoti-glitcher' | 'agoti-wire':
				iconColor = 'FF494949';
				switch (curCharacter)
				{
					case 'agoti-mad':
						frames = Paths.getSparrowAtlas('characters/AGOTI-MAD');	
						noteSkin = 'agoti';
					case 'agoti-glitcher':
						frames = Paths.getSparrowAtlas('characters/AGOTI-GLITCHER');
					case 'agoti-wire':
						frames = Paths.getSparrowAtlas('characters/AGOTI-WIRE');
						iconColor = 'FFFF0000';
				}
				
				animation.addByPrefix('idle', 'Angry_Agoti_Idle', 24);
				animation.addByPrefix('singUP', 'Angry_Agoti_Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry_Agoti_Right', 24, false);
				animation.addByPrefix('singDOWN', 'Angry_Agoti_Down', 24, false);
				animation.addByPrefix('singLEFT', 'Angry_Agoti_Left', 24, false);

				loadOffsetFile('agoti-mad');
				
				playAnim('idle');

			case 'tabi' | 'tabi-glitcher' | 'tabi-wire':
				iconColor = 'FFFFBB81';
				switch (curCharacter)
				{
					case 'tabi':			
						frames = Paths.getSparrowAtlas('characters/TABI');
						noteSkin = 'tabi';
					case 'tabi-wire':
						frames = Paths.getSparrowAtlas('characters/TABI_WIRE');
						iconColor = 'FF00137F';
					case 'tabi-glitcher':
						frames = Paths.getSparrowAtlas('characters/TABI_glitcher');
				}
				
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				loadOffsetFile('tabi');
				
				playAnim('idle');

			case 'tabi-crazy':
				frames = Paths.getSparrowAtlas('characters/MadTabi');
				iconColor = 'FFFFA15D';
				noteSkin = 'tabi';
				
				animation.addByPrefix('idle', 'MadTabiIdle', 24, false);
				animation.addByPrefix('singUP', 'MadTabiUp', 24, false);
				animation.addByPrefix('singDOWN', 'MadTabiDown', 24, false);
				animation.addByPrefix('singLEFT', 'MadTabiLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'MadTabiRight', 24, false);
				
				loadOffsetFile('tabi-crazy');
				
				playAnim('idle');

			case 'ina':
				frames = Paths.getSparrowAtlas('characters/ina', 'shared');
				iconColor = 'FF31254A';
				animation.addByPrefix('idle', 'Ina_Idle', 24, false);
				animation.addByPrefix('singUP', 'Ina_Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Ina_Right', 24, false);
				animation.addByPrefix('singDOWN', 'Ina_Down', 24, false);
				animation.addByPrefix('singLEFT', 'Ina_Left', 24, false);		

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'ina2':
				frames = Paths.getSparrowAtlas('characters/ina2', 'shared');
				iconColor = 'FF31254A';
				animation.addByPrefix('idle', 'InaP2_Idle', 24, false);
				animation.addByPrefix('singUP', 'InaP2_Up', 24, false);
				animation.addByPrefix('singRIGHT', 'InaP2_Right', 24, false);
				animation.addByPrefix('singDOWN', 'InaP2_Down', 24, false);
				animation.addByPrefix('singLEFT', 'InaP2_Left', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'little-man':
				frames = Paths.getSparrowAtlas('characters/Small_Guy');
				iconColor = 'FFFFFFFF';
				noteSkin = 'littleman';
				animation.addByPrefix('idle', "idle", 24);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				loadOffsetFile(curCharacter);

			case 'hellbob':
				frames = Paths.getSparrowAtlas('characters/hellbob_assets');
				iconColor = 'FF000000';	

				animation.addByPrefix('idle', "bobismad", 24);
				animation.addByPrefix('singUP', 'lol', 24, false);
				animation.addByPrefix('singDOWN', 'lol', 24, false);
				animation.addByPrefix('singLEFT', 'lol', 24, false);
				animation.addByPrefix('singRIGHT', 'lol', 24, false);
				animation.addByPrefix('singUPmiss', 'lol', 24);
				animation.addByPrefix('singDOWNmiss', 'lol', 24);

				loadOffsetFile('no');

				playAnim('idle');

				flipX = true;

			case 'calebcity' | 'woody':
				switch (curCharacter)
				{
					case 'calebcity':
						frames = Paths.getSparrowAtlas('characters/PizzaMan');
						iconColor = 'FF8F8366';
					case 'woody':
						frames = Paths.getSparrowAtlas('characters/Woody');
						iconColor = 'FF5A2814';
				}	
				animation.addByPrefix('idle', "PizzasHere", 29);
				animation.addByPrefix('fall', "PizzasHere", 29);
				animation.addByPrefix('singUP', 'Up', 29, false);
				animation.addByPrefix('singDOWN', 'Down', 29, false);
				animation.addByPrefix('singLEFT', 'Left', 29, false);
				animation.addByPrefix('singRIGHT', 'Right', 29, false);

				if (curCharacter == 'woody')
				{
					animation.addByPrefix('singUP-alt', 'Scream', 29, false);
					animation.addByPrefix('singLEFT-alt', 'Scream', 29, false);
					animation.addByPrefix('singDOWN-alt', 'Scream', 29, false);
					animation.addByPrefix('singRIGHT-alt', 'Scream', 29, false);
				}

				loadOffsetFile(curCharacter);

			 case 'void':
		        frames = Paths.getSparrowAtlas('characters/void_assets');
				iconColor = 'FF56006B';
				noteSkin = 'void';
		        animation.addByPrefix('idle', 'Void Idle', 24, false);
		        animation.addByPrefix('singUP', 'Void Up Note Chill', 20, false);
		        animation.addByPrefix('singDOWN', 'Void Down Note Chill', 20, false);
		        animation.addByPrefix('singLEFT', 'Void Left Note Chill', 20, false);
		        animation.addByPrefix('singRIGHT', 'Void Right Note Chill', 26, false);

		        animation.addByPrefix('singUP-alt', 'Void Up Note Hype', 20, false);
		        animation.addByPrefix('singDOWN-alt', 'Void Down Note Hype', 20, false);
		        animation.addByPrefix('singLEFT-alt', 'Void Left Note Hype', 20, false);
		        animation.addByPrefix('singRIGHT-alt', 'Void Right Note Hype', 26, false);

				animation.addByPrefix('wink', 'Void Wink', 12, false);
				animation.addByPrefix('seethe', 'Void Seethe', 24, false);

				animation.addByPrefix('sickintro', 'Void Intro', 12, false);

				loadOffsetFile(curCharacter);

		        playAnim('idle');
				
			case 'abby' | 'abby-mad':
				switch (curCharacter)
				{
					case 'abby':
						frames = Paths.getSparrowAtlas('maginage/AbbyPOSES');
						pre = 'Abby';
					case 'abby-mad':
						frames = Paths.getSparrowAtlas('maginage/AbbyMADposes');
						pre = 'AbbyMad';
				}
				iconColor = 'FFFFB644';
			
				animation.addByPrefix('idle', pre+'IDLE', 24, false);
				animation.addByPrefix('singUP', pre+'UP', 24, false);
				animation.addByPrefix('singDOWN', pre+'DOWN', 24, false);
				animation.addByPrefix('singLEFT', pre+'LEFT', 24, false);
				animation.addByPrefix('singRIGHT', pre+'RIGHT', 24, false);

				loadOffsetFile(curCharacter);
				
				playAnim('idle');

			case 'makocorrupt': 
				iconColor = 'FF47CC40';
				noteSkin = 'fever';
				flipX = true;

				setGraphicSize(Std.int(width * 0.95));
				frames = Paths.getSparrowAtlas('characters/makoCorrupt');
				
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
				
				loadOffsetFile(curCharacter);
				
				playAnim('idle');

			case 'lucian':
				frames = Paths.getSparrowAtlas('maginage/Lucian Poses');
				iconColor = 'FFFF9CBE';
				animation.addByPrefix('idle', 'LucianIdle', 24, false);
				animation.addByPrefix('singUP', 'LucianUp', 24, false);
				animation.addByPrefix('singDOWN', 'LucianDown', 24, false);
				animation.addByPrefix('singLEFT', 'LucianLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'LucianRight', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'matt':
				frames = Paths.getSparrowAtlas('characters/matt_assets');
				iconColor = 'FFFF8C00';
				animation.addByPrefix('idle', "matt idle", 24);
				animation.addByPrefix('singUP', 'matt up note', 24, false);
				animation.addByPrefix('singDOWN', 'matt down note', 24, false);
				animation.addByPrefix('singLEFT', 'matt left note', 24, false);
				animation.addByPrefix('singRIGHT', 'matt right note', 24, false);
				animation.addByPrefix('singUPmiss', 'miss up', 24, false);
				animation.addByPrefix('singDOWNmiss', 'miss down', 24, false);
				animation.addByPrefix('singLEFTmiss', 'miss left', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'miss right', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'foks':
				frames = Paths.getSparrowAtlas('characters/foks');
				iconColor = 'FFF19A29';
				animation.addByPrefix('idle', "matt idle", 24);
				animation.addByPrefix('singUP', 'matt up note', 24, false);
				animation.addByPrefix('singDOWN', 'matt down note', 24, false);
				animation.addByPrefix('singLEFT', 'matt left note', 24, false);
				animation.addByPrefix('singRIGHT', 'matt right note', 24, false);
				
				animation.addByPrefix('singDOWN-alt', 'down alt', 24, false);
				animation.addByPrefix('singLEFT-alt', 'left alt', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'right alt', 24, false);
				if (isPlayer) {
					animation.addByPrefix('singUP-alt', 'up alt2', 24, false);
				}
				else {
					animation.addByPrefix('singUP-alt', 'up alt0', 24, false);
				}

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'pinkie' | 'camellia' | 'camelliahalloween' | 'woopermellia':
				switch (curCharacter)
				{
					case 'pinkie':
						frames = Paths.getSparrowAtlas('characters/pinkie');
						iconColor = 'FFFFFF99';
					case 'camellia':
						frames = Paths.getSparrowAtlas('characters/camellia');
						iconColor = 'FFD55F56';
					case 'camelliahalloween':
						frames = Paths.getSparrowAtlas('characters/camellia_halloween');
						iconColor = 'FFD55F56';
					case 'woopermellia':
						frames = Paths.getSparrowAtlas('characters/woopermellia');
						iconColor = 'FF81B8FA';
				}
				
				//experimental but let's try it -- it worked let's go!
				switch (curCharacter)
				{
					case 'woopermellia':
						loadAnims('camellia');
						loadOffsetFile('camellia');
					default:
						loadAnims(curCharacter);
						loadOffsetFile(curCharacter);
				}
				
			case 'ace':
				frames = Paths.getSparrowAtlas('characters/ace', 'shared');
				iconColor = 'FFBAE2FF';
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing note UP', 24, false);
				animation.addByPrefix('singLEFT', 'dad sing note right', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note LEFT', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'zardy' | 'starecrown' | 'whitty-minus' | 'whitty-minus-b3' | 'lexi-b3' | 'happymouse' | 'papyrus' | 'kirbo' | 'dr-springheel' | 'noke' | 'ron' | 'cablecrow' | 'mario'
			| 'trollge' | 'jester' | 'tornsketchy' | 'happymouse2' | 'sunky' | 'herobrine' | 'mokey' | 'geese-minus' | 'geese' | 'monika-real' | 'natsuki' | 'yuri' | 'kalisa' | 'kkslider'
			| 'mami' | 'taeyai' | 'taeyai-b3' | 'neonight' | 'baldi-angry' | 'retro' | 'alucard' | 'bipolarmouse' | 'auditor' | 'gold-side' | 'zipper' | 'geese-fly' | 'richard1' 
			| 'mara' | 'v-calm' | 'kadedev' | 'cerbera'  | 'happymouse-bw' | 'sadmouse-bw' | 'sadmouse' | 'dust-sans' | 'doxxie' | 'cjClone' | 'gold-side-blue' | 'king' | 'gf-standing'
			| 'gf-standing-halloween' | 'coco2' | 'scott' | 'sketch' | 'monokuma' | 'hank-antipathy' | 'hallow' | 'soul-tails' | 'daidem' | 'betty' | 'betty-bw': 
			// this is a long af list
				switch (curCharacter)
				{
					case 'zardy':
						frames = Paths.getSparrowAtlas('characters/Zardy');
						iconColor = 'FF2C253B';
					case 'starecrown':
						frames = Paths.getSparrowAtlas('characters/starecrown');
						iconColor = 'FFFCC60F';
						noteSkin = 'starecrown';
					case 'whitty-minus':
						frames = Paths.getSparrowAtlas('characters/WhittyMinusSprites');
						iconColor = 'FF1D1E35';
					case 'whitty-minus-b3':
						frames = Paths.getSparrowAtlas('characters/b3/WhittyMinusSprites');
						iconColor = 'FF1D1E35';
					case 'lexi-b3':
						frames = Paths.getSparrowAtlas('characters/b3/Lexi_Assets');
						iconColor = 'FF66FF33';
					case 'mario':
						frames = Paths.getSparrowAtlas('characters/mario_assets');
						iconColor = 'FFCC0000';
					case 'happymouse' | 'happymouse-bw' | 'sadmouse-bw' | 'sadmouse':
						iconColor = 'FFAFAFAF';
						switch (curCharacter)
						{			
							case 'happymouse-bw': pre = 'bw/happy';
							case 'sadmouse-bw': 
								pre = 'bw/sad';
								noteSkin = '1930';
							case 'happymouse': 
								pre = 'happy';
								iconColor = 'FFFAFAFA';
							case 'sadmouse':
								pre = 'sad';
								iconColor = 'FFFAFAFA';
						}
						frames = Paths.getSparrowAtlas('characters/'+pre+'mouse_assets');
					case 'papyrus':
						frames = Paths.getSparrowAtlas('characters/papyrus');
						iconColor = 'FFFFFFFF';
					case 'kirbo':
						frames = Paths.getSparrowAtlas('characters/kirbo');
						iconColor = 'FFEE8BCE';
					case 'dr-springheel':
						frames = Paths.getSparrowAtlas('characters/jack');
						iconColor = 'FFAF68CE';
					case 'noke':
						frames = Paths.getSparrowAtlas('characters/noke');
						iconColor = 'FF705878';
					case 'cablecrow':
						frames = Paths.getSparrowAtlas('characters/Cablecrow');
						iconColor = 'FFB97C41';
					case 'ron':
						frames = Paths.getSparrowAtlas('characters/ron');
						iconColor = 'FF7F6A00';
						noteSkin = 'ron';
					case 'trollge':
						frames = Paths.getSparrowAtlas('characters/trollge');
						iconColor = 'FFB5B5B5';
						noteSkin = 'trollge';
					case 'jester':
						frames = Paths.getSparrowAtlas('characters/Jester','shared');
						iconColor = 'FFF14CF1';
					case 'tornsketchy':
						frames = Paths.getSparrowAtlas('characters/crumple');
						iconColor = 'FFB5B5B5';
						noteSkin = 'sketchy';
					case 'happymouse2':
						frames = Paths.getSparrowAtlas('characters/happymouse2_assets');
						iconColor = 'FFFAFAFA';
					case 'sunky':
						frames = Paths.getSparrowAtlas('characters/Sunky');
						iconColor = 'FF2547FB';
					case 'herobrine':
						frames = Paths.getSparrowAtlas('characters/herobrine');
						iconColor = 'FF056B82';
					case 'mokey':
						frames = Paths.getSparrowAtlas('characters/Mokey_AAAAssets');
						iconColor = 'FF686868';
					case 'geese-minus':
						frames = Paths.getSparrowAtlas('characters/MasonMinus');
						iconColor = 'FF933F9E';
					case 'geese':
						frames = Paths.getSparrowAtlas('characters/Mason');
						iconColor = 'FF933F9E';
					case 'monika-real':
						frames = Paths.getSparrowAtlas('characters/Doki_MonikaNonPixel_Assets');
						iconColor = 'FF8CD465';
					case 'natsuki':
						frames = Paths.getSparrowAtlas('characters/Doki_Nat_Assets');
						iconColor = 'FFFC95D3';
					case 'yuri':
						frames = Paths.getSparrowAtlas('characters/Doki_Yuri_Assets');
						iconColor = 'FF9E72D2';
					case 'kalisa':
						frames = Paths.getSparrowAtlas('characters/Kalisa');
						iconColor = 'FF703BC6';
					case 'kkslider':
						frames = Paths.getSparrowAtlas('characters/kk_assets');
						iconColor = 'FFFFFFFF';
					case 'mami':
						frames = Paths.getSparrowAtlas('characters/Mami');
						iconColor = 'FFFFF196';
					case 'taeyai':
						frames = Paths.getSparrowAtlas('characters/Taeyai');
						iconColor = 'FF666666'; //unholy number
						noteSkin = 'taeyai';
					case 'taeyai-b3':
						frames = Paths.getSparrowAtlas('characters/b3/Taeyai');
						iconColor = 'FF4DC66B';
						noteSkin = 'taeyai';
					case 'neonight':
						frames = Paths.getSparrowAtlas('characters/Neonight');
						iconColor = 'FFCC3399';
					case 'retro':
						frames = Paths.getSparrowAtlas('characters/RetroSpecter','shared');
						iconColor = 'FF17D8E4';
					case 'baldi-angry':
						frames = Paths.getSparrowAtlas('characters/BALDI');
						iconColor = 'FF00DF3B';
					case 'alucard':
						frames = Paths.getSparrowAtlas('characters/alucard');
						iconColor = 'FF3100FF';
					case 'bipolarmouse':
						frames = Paths.getSparrowAtlas('characters/bipolarmouse_assets');
						iconColor = 'FF0D0D0D';
					case 'auditor':
						frames = Paths.getSparrowAtlas('characters/auditor');
						iconColor = 'FFFF0000';
					case 'gold-side' | 'gold-side-blue':
						iconColor = 'FFFFFFFF';
						if (curCharacter == 'gold-side-blue')
						{
							pre = 'blue/';
							iconColor = 'FFE6E6FF';
						}			
						frames = Paths.getSparrowAtlas('characters/'+pre+'gold_side');
					case 'zipper':
						frames = Paths.getSparrowAtlas('characters/zipper');
						iconColor = 'FFA41F3E';
					case 'geese-fly':
						frames = Paths.getSparrowAtlas('characters/MasonFly');
						iconColor = 'FF933F9E';
					case 'richard1':
						frames = Paths.getSparrowAtlas('characters/richard1');
						iconColor = 'FFFFCE5B';
					case 'mara':
						frames = Paths.getSparrowAtlas('characters/Mara_assets');
						iconColor = 'FFFF0000';
					case 'v-calm':
						frames = Paths.getSparrowAtlas('characters/v-calm');
						iconColor = 'FFFFFFFF';
					case 'kadedev':
						frames = Paths.getSparrowAtlas('characters/kadedev');
						iconColor = 'FF008000';
					case 'cerbera':
						frames = Paths.getSparrowAtlas('characters/Cerb');
						iconColor = "FF484848";
					case 'dust-sans':
						frames = Paths.getSparrowAtlas('characters/dustsans');
						iconColor = "FF999999";
					case 'doxxie':
						frames = Paths.getSparrowAtlas('characters/doxxie_assets');
						iconColor = 'FFFFFF00';
					case 'cjClone':
						frames = Paths.getSparrowAtlas('characters/CJCLONE');
						iconColor = 'FFFF0000';	
					case 'king':
						frames = Paths.getSparrowAtlas('characters/king');
						iconColor = 'FF74628B';			
					case 'gf-standing':
						frames =  Paths.getSparrowAtlas('characters/GIOFIEND');
						iconColor = 'FF9A1652';
					case 'gf-standing-halloween':
						frames =  Paths.getSparrowAtlas('characters/gf_standing_halloween');
						iconColor = 'FF9A1652';
					case 'coco2':
						frames =  Paths.getSparrowAtlas('characters/CocoMunchkin_assets');
						iconColor = 'FFA37E6A';
					case 'scott':
						frames =  Paths.getSparrowAtlas('characters/ScottRemade');
						iconColor = 'FF6576E6';
					case 'sketch':
						frames =  Paths.getSparrowAtlas('characters/sketch_assets'); // i needed to save space so i cropped it
						iconColor = 'FF6B4436';
					case 'monokuma':
						frames =  Paths.getSparrowAtlas('characters/monokuma_assets');
						iconColor = 'FFFFFFFF';
					case 'hank-antipathy':
						frames =  Paths.getSparrowAtlas('characters/PIPEMAN');
						iconColor = 'FFFF0000';
					case 'hallow':
						frames =  Paths.getSparrowAtlas('characters/Hallow');
						iconColor = 'FFC6C1F3';
					case 'soul-tails':
						frames = Paths.getSparrowAtlas('characters/Soul_Tails');
						iconColor = 'FF666666';
					case 'daidem':
						frames = Paths.getSparrowAtlas('characters/DaidemAssetsREwork','shared');
						iconColor = 'FFFF863D';
					case 'betty' | 'betty-bw':
						if (curCharacter.contains('bw')) pre = 'bw/';
						frames = Paths.getSparrowAtlas('characters/'+pre+'Bete_Noire');
						iconColor = 'FFFF6BAB';
				}
				
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Sing Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24, false);
				animation.addByPrefix('singDOWN', 'Sing Down', 24, false);
				animation.addByPrefix('singLEFT', 'Sing Left', 24, false);
					
				switch (curCharacter)
				{
					case 'happymouse2' | 'bipolarmouse':
						animation.addByPrefix('singDOWN-alt', 'Laugh', 24, false);
						addOffset('singDOWN-alt');
					case 'yuri':
						animation.addByPrefix('breath', 'Breath', 24, false);
					case 'zipper':
						animation.addByPrefix('singUP-alt', 'scream', 24, false);
						animation.addByPrefix('singRIGHT-alt', 'scream', 24, false);
						animation.addByPrefix('singDOWN-alt', 'scream', 24, false);
						animation.addByPrefix('singLEFT-alt', 'scream', 24, false);
					case 'richard1':
						animation.addByPrefix('chaChing', 'cha ching', 24, false);
						animation.addByPrefix('troll', 'troll', 24, false);
						animation.addByPrefix('sell', 'sell', 24, false);
						animation.addByPrefix('surprised', 'surprised', 24, false);	
					case 'dust-sans':
						animation.addByPrefix('swingDOWN', 'swingDown0', 24, false);
						animation.addByPrefix('swingUP', 'swingUp0', 24, false);	
					case 'doxxie':
						animation.addByPrefix('giggle', 'Giggle0', 24, false);
						animation.addByPrefix('laugh', 'Laugh0', 24, false);
					case 'cjClone':
						animation.addByPrefix('Hank', 'Showtime', 24, false);
					case 'coco2':
						animation.addByPrefix('go', "let's go", 24, false);
					case 'hank-antipathy':
						animation.addByPrefix('block', "Block", 24, false);
				}

				switch (curCharacter)
				{
					case 'whitty-minus' | 'whitty-minus-b3':
						loadOffsetFile('whitty-minus');
					case 'taeyai-b3':
						loadOffsetFile('taeyai');
					case 'happymouse' | 'sunky' | 'kkslider' | 'happymouse-bw' | 'king':
						loadOffsetFile('no');
					case 'gold-side' | 'gold-side-blue':
						loadOffsetFile('gold-side');
					case 'betty' | 'betty-bw':
						loadOffsetFile('betty');
					default:
						loadOffsetFile(curCharacter);
				}	

				playAnim('idle');

				if (curCharacter == 'noke') {
					flipX = true;
				}

				if (curCharacter == 'monika-real'){
					setGraphicSize(Std.int(width * .9));
					updateHitbox();
				}

				if (curCharacter == 'soul-tails'){
					setGraphicSize(Std.int(width * 1.2));
					updateHitbox();
				}

			case 'tricky' | 'trickward':
				switch (curCharacter)
				{
					case 'tricky':
						frames = Paths.getSparrowAtlas('characters/tricky');
						iconColor = 'FF185F40';
					case 'trickward':
						frames = Paths.getSparrowAtlas('characters/TRICKWARD');
						iconColor = 'FF80CAAA';
				}

				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Sing Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24, false);
				animation.addByPrefix('singDOWN', 'Sing Down', 24, false);
				animation.addByPrefix('singLEFT', 'Sing Left', 24, false);

				if (curCharacter == 'tricky')
					animation.addByPrefix('singDOWN-alt', 'Scream', 24, false);		

				loadOffsetFile(curCharacter);

			case 'sayori': //she uses danceIdle so she had to be separated from the others.
				// and the blind forest
				frames = Paths.getSparrowAtlas('characters/Doki_Sayo_Assets');
				iconColor = 'FF95E0FA';

				animation.addByIndices('danceLeft', 'Sayo Idle nrw test', [25, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceRight', 'Sayo Idle nrw test', [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24], "", 24, false);
				animation.addByPrefix('singUP', 'Sayo Sing Note Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Sayo Sing Note Right', 24, false);
				animation.addByPrefix('singDOWN', 'Sayo Sing Note Down', 24, false);
				animation.addByPrefix('singLEFT', 'Sayo Sing Note Left', 24, false);
				animation.addByPrefix('nara', 'Sayo Nara animated', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'yuri-crazy' | 'yuri-crazy-bw':
				if (curCharacter.contains('bw')){pre = 'bw/';}
				frames = Paths.getSparrowAtlas('characters/'+pre+'Doki_Crazy_Yuri_Assets');
				iconColor = 'FF9E72D2';

				if (curCharacter == 'yuri-crazy')
					noteSkin = 'doki';

				animation.addByPrefix('idle', 'Yuri Crazy Idle', 24, false);
				animation.addByPrefix('singUP', 'Yuri Crazy Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Yuri Crazy Right', 24, false);
				animation.addByPrefix('singDOWN', 'Yuri Crazy Down', 24, false);
				animation.addByPrefix('singLEFT', 'Yuri Crazy Left', 24, false);

				loadOffsetFile('yuri-crazy');

				playAnim('idle');

			case 'mami-holy':
				frames = Paths.getSparrowAtlas('characters/Holy Mami','shared');
				iconColor = 'FFFFF196';
				animation.addByPrefix('idle', 'IDLE', 24);
				animation.addByPrefix('singUP', 'UP', 24);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24);
				animation.addByPrefix('singDOWN', 'DOWN', 24);
				animation.addByPrefix('singLEFT', 'LEFT', 24);

				loadOffsetFile(curCharacter);
	
				playAnim('idle');
				
			case 'hank':
				frames = Paths.getSparrowAtlas('characters/hank_assets', 'shared');	
				iconColor = 'FFFF0000';

				animation.addByPrefix('idle', 'Hank Idle', 24, false);
				animation.addByPrefix('singUP', 'Hank Up note', 24, false);
				animation.addByPrefix('singRIGHT', 'Hank right note', 24, false);
				animation.addByPrefix('singDOWN', 'Hank Down Note', 24, false);
				animation.addByPrefix('singLEFT', 'Hank Left Note', 24, false);

				animation.addByPrefix('idle-alt', 'HankScaredIdle', 24, false);
				animation.addByPrefix('singUP-alt', 'Hank Up shoot', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Hank Down Shoot', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Hank Left Shoot', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Hank right shoot', 24, false);

				animation.addByPrefix('singLEFT-scream', 'Hank screamright', 24, false);
				animation.addByPrefix('singRIGHT-scream', 'Hank screamright', 24, false);
	
				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'oswald-angry':
				frames = Paths.getSparrowAtlas('characters/Oswald_Angry_Assets', 'shared');	
				iconColor = 'FF5087FF';
				
				animation.addByPrefix('danceLeft', 'Os_danceLeft_Angry', 24, false);
				animation.addByPrefix('danceRight', 'Os_danceRight_Angry', 24, false);
				animation.addByPrefix('singUP', 'Os_Up_Angry', 20, false);
				animation.addByPrefix('singRIGHT', 'Os_Right_Angry', 20, false);
				animation.addByPrefix('singDOWN', 'Os_Down_Angry', 24, false);
				animation.addByPrefix('singLEFT', 'Os_Left_Angry', 24, false);
				animation.addByPrefix('hah', 'Os_HAH', 24, false);
				animation.addByPrefix('notold', 'Os_NotOld', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceLeft');

			case 'oswald-happy':
				frames = Paths.getSparrowAtlas('characters/Oswald_Happy_Assetsv2', 'shared');	
				iconColor = 'FF5087FF';
				
				animation.addByPrefix('danceLeft', 'Os_danceLeft instance', 24, false);
				animation.addByPrefix('danceRight', 'Os_danceRight instance', 24, false);
				animation.addByPrefix('singUP', 'Os_Up instance', 20, false);
				animation.addByPrefix('singRIGHT', 'Os_Right instance', 20, false);
				animation.addByPrefix('singDOWN', 'Os_Down instance', 24, false);
				animation.addByPrefix('singLEFT', 'Os_Left instance', 24, false);

				animation.addByPrefix('danceLeft-alt', 'Os_danceLeft_Alt', 24, false);
				animation.addByPrefix('danceRight-alt', 'Os_danceRight_Alt', 24, false);
				animation.addByPrefix('singUP-alt', 'Os_Up_Alt', 20, false);
				animation.addByPrefix('singRIGHT-alt', 'Os_Right_Alt', 20, false);
				animation.addByPrefix('singDOWN-alt', 'Os_Down_Alt', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Os_Left_Alt', 24, false);

				animation.addByPrefix('lucky', 'Os_Lucky', 24, false);
				animation.addByPrefix('oldtimey', 'Os_OldTimey', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceLeft');

			case 'sasha':
				frames = Paths.getSparrowAtlas('characters/Sasha_Assets');
				iconColor = 'FFE7479E';
				animation.addByPrefix('idle', 'Idle0', 24, false);
				animation.addByPrefix('singUP', 'Sing Up0', 24, false);
				animation.addByPrefix('singRIGHT', 'Sing Right0', 24, false);
				animation.addByPrefix('singDOWN', 'Sing Down0', 24, false);
				animation.addByPrefix('singLEFT', 'Sing Left0', 24, false);

				animation.addByPrefix('idle-alt', 'Idle_Alt0', 24, false);
				animation.addByPrefix('singUP-alt', 'Sing Up_Alt0', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Sing Right_Alt0', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Sing Down_Alt0', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Sing Left_Alt0', 24, false);
				
				loadOffsetFile(curCharacter);

			case 'bigmonika':
				frames = Paths.getSparrowAtlas('characters/big_monikia_base');
				iconColor = "FF8CD465";
				animation.addByPrefix('idle', 'Big Monika Idle', 24, false);
				animation.addByPrefix('singUP', 'Big Monika Up', 24, false);
				animation.addByPrefix('singDOWN', 'Big Monika Down', 24, false);
				animation.addByPrefix('singLEFT', 'Big Monika Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Big Monika Right', 24, false);
				animation.addByPrefix('lastNOTE', 'Big Monika Last Note', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');
				updateHitbox();

			case 'bf-bigmonika-dead':
				frames = Paths.getSparrowAtlas('characters/big_monikia_death');
				iconColor = "FF8CD465";
				animation.addByPrefix('idle', "Big Monika Retry Start", 24, false);
				animation.addByPrefix('singUP', "Big Monika Retry Start", 24, false);
				animation.addByPrefix('firstDeath', 'Big Monika Retry Start', 24, false);
				animation.addByPrefix('deathLoop', 'Big Monika Retry Loop', 24, true);
				animation.addByPrefix('deathConfirm', 'Big Monika Retry End', 24, false);
				animation.addByPrefix('crashDeath', 'Big Monika SCARY', 24, false);
				animation.addByPrefix('crashDeath2', 'Big Monika JUMP', 24, false);
				
				loadOffsetFile(curCharacter);

				flipX = true;
				playAnim('firstDeath');

			case 'liz':
				frames = Paths.getSparrowAtlas('characters/liz_assets');
				iconColor = 'FFAB219D';
				noteSkin = PlayState.SONG.noteStyle;

				animation.addByPrefix('idle', 'liz idle', 24, false);
				animation.addByPrefix('singUP', 'liz up pose', 24, false);				
				animation.addByPrefix('singDOWN', 'liz down pose', 24, false);
				animation.addByPrefix('singUPmiss', 'liz up miss', 24, false);				
				animation.addByPrefix('singDOWNmiss', 'liz down miss', 24, false);
				animation.addByPrefix('singRIGHT', 'liz right pose', 24, false);
				animation.addByPrefix('singLEFT', 'liz left pose', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'liz right miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'liz left miss', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'tord' | 'tom':
				switch (curCharacter)
				{
					case 'tord':
						tex = Paths.getSparrowAtlas('characters/tord_assets');
						iconColor = 'FFC11200';
					case 'tom':
						tex = Paths.getSparrowAtlas('characters/tom_assets');
						iconColor = 'FF265D86';
				}
				
				frames = tex;

				animation.addByPrefix('idle', "tord idle", 24, false);
				animation.addByPrefix('singUP', "tord up", 24, false);
				animation.addByPrefix('singDOWN', "tord down", 24, false);
				animation.addByPrefix('singLEFT', 'tord left', 24, false);
				animation.addByPrefix('singRIGHT', 'tord right', 24, false);

				if (curCharacter == 'tom')
				{
					animation.addByPrefix('singLEFT-alt', "tord ugh", 24, false);
					if (isPlayer)
						addOffset("singLEFT-alt", 0, 80);
					else
						addOffset("singLEFT-alt", 80, 80);
				}

				loadOffsetFile('tord');

				playAnim('idle');

			case 'hex' | 'peasus':
				// DAD ANIMATION LOADING CODE
				switch (curCharacter)
				{
					case 'hex':
						frames = Paths.getSparrowAtlas('characters/hex');
						iconColor = 'FFF46C4E';
					case 'peasus':
						frames = Paths.getSparrowAtlas('characters/peaky_horny');
						iconColor = 'FF99D4F4';
				}
				
				noteSkin = PlayState.SONG.noteStyle;
				
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT0', 24, false);
				animation.addByPrefix('singUP-alt', 'Dad Jump', 24, false);

				if (isPlayer && curCharacter == 'hex')
				{
					animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT Purple', 24, false);
					animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT Red', 24, false);
				}

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'hex-virus':
				frames = Paths.getSparrowAtlas('characters/Hex_Virus');
				iconColor = 'FF0A1233';
				animation.addByPrefix('idle', 'Hex crazy idle', 24, false);
				animation.addByPrefix('singUP', 'Hex crazy up', 24, false);
				animation.addByPrefix('singRIGHT', 'Hex crazy right', 24, false);
				animation.addByPrefix('singDOWN', 'Hex crazy down', 24, false);
				animation.addByPrefix('singLEFT', 'Hex crazy left', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'hex-bw':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/bw/hex');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT0', 24, false);
				animation.addByPrefix('wink', 'Dad Wink', 24);
				animation.addByPrefix('idle-alt', 'Dad idle dance', 24, false);

				if (isPlayer)
				{
					animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT Purple', 24, false);
					animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT Red', 24, false);
				}

				if (isPlayer)
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", -12, 50);
					addOffset("singRIGHT", -40, 10);
					addOffset("singLEFT", 40, 27);
					addOffset("singDOWN", 40, -30);
					addOffset("wink", -10, -16);
				}	

				else
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
					addOffset("wink", -7, -16);
				}	

				playAnim('idle');

			case 'hd-senpai-giddy' | 'hd-senpai-giddy-b3':
				switch (curCharacter)
				{
					case 'hd-senpai-giddy':
						frames = Paths.getSparrowAtlas('characters/HD_SENPAI_GIDDY');
						iconColor = 'FFFFAA6F';
					case 'hd-senpai-giddy-b3':
						frames = Paths.getSparrowAtlas('characters/b3/HD_SENPAI_GIDDY');
						iconColor = 'FFBB2626';
				}
							
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Dad Die', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Dad UGH', 24, false);

				loadOffsetFile('hd-senpai-giddy');

				playAnim('idle');

			case 'hd-senpai-happy' | 'hd-senpai-giddy-bw' | 'hd-senpai-angry' | 'hd-senpai-angry-b3':
				switch (curCharacter)
				{
					case 'hd-senpai-happy':
						frames = Paths.getSparrowAtlas('characters/HD_SENPAI_HAPPY');
						iconColor = 'FFFFAA6F';
					case 'hd-senpai-giddy-bw':
						frames = Paths.getSparrowAtlas('characters/bw/HD_SENPAI_GIDDY');
					case 'hd-senpai-angry':
						frames = Paths.getSparrowAtlas('characters/HD_SENPAI_ANGRY');
						iconColor = 'FFFFAA6F';
					case 'hd-senpai-angry-b3':
						frames = Paths.getSparrowAtlas('characters/b3/HD_SENPAI_ANGRY');
						iconColor = 'FFBB2626';
				}
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				loadOffsetFile('hd-senpai-angry');	

				playAnim('idle');

			case 'hd-monika' | 'hd-monika-angry':
				switch (curCharacter)
				{
					case 'hd-monika':
						frames = Paths.getSparrowAtlas('characters/HD_MONIKA');
					case 'hd-monika-angry':
						frames = Paths.getSparrowAtlas('characters/HD_MONIKA_ANGRY');
				}
				iconColor = 'FFFFB8E3';
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				loadOffsetFile('hd-monika');

				playAnim('idle');

			case 'bf-senpai-worried' | 'bf-hd-senpai-angry' | 'bf-hd-senpai-giddy' | 'bf-hd-senpai-angry-night' | 'bf-hd-senpai-dark':
				switch (curCharacter)
				{
					case 'bf-senpai-worried': frames = Paths.getSparrowAtlas('characters/HD_SENPAI_WORRIED');
					case 'bf-hd-senpai-angry': frames = Paths.getSparrowAtlas('characters/BF_HD_SENPAI_ANGRY');
					case 'bf-hd-senpai-giddy': frames = Paths.getSparrowAtlas('characters/BF_HD_SENPAI_GIDDY');
					case 'bf-hd-senpai-angry-night': frames = Paths.getSparrowAtlas('characters/BF_HD_SENPAI_ANGRY_NIGHT');
					case 'bf-hd-senpai-dark': frames = Paths.getSparrowAtlas('characters/BF_HD_SENPAI_DARK');
				}
				
				iconColor = 'FFFFAA6F';
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				loadOffsetFile('bf-hd-senpai-angry');

				playAnim('idle');

				flipX = true;

			case 'yukichi-police': // YUKICHI
				iconColor = 'FF97F0';
				frames = Paths.getSparrowAtlas('characters/yukichi_leader_assets');
				noteSkin = 'party-crasher';

				animation.addByPrefix('idle', 'yukichi idle', 24);
				animation.addByPrefix('singUP', 'yukichi up note', 24);
				animation.addByPrefix('singRIGHT', 'yukichi right note', 24);
				animation.addByPrefix('singDOWN', 'yukichi down note', 24);
				animation.addByPrefix('singLEFT', 'yukichi left note', 24);

				addOffset('idle');
				addOffset("singUP", -27, 17);
				addOffset("singRIGHT", -54, -7);
				addOffset("singLEFT", 47, 4);
				addOffset("singDOWN", -139, -62);

				setGraphicSize(Std.int(width * 0.8));

				playAnim('idle');

			case 'yukichi-mad' | 'yukichi-mad-city':
				switch (curCharacter)
				{
					case 'yukichi-mad':
						frames = Paths.getSparrowAtlas('characters/yukichi_mad_assets');
					case 'yukichi-mad-city':
						frames = Paths.getSparrowAtlas('characters/yukichi_mad_assets_city');
				}
				iconColor = 'FF97F0';
				noteSkin = 'party-crasher';

				animation.addByPrefix('idle', 'yukichi angry idle', 24);
				animation.addByPrefix('singUP', 'yukichi angry up', 24);
				animation.addByPrefix('singRIGHT', 'yukichi angry right', 24);
				animation.addByPrefix('singDOWN', 'yukichi angry down', 24);
				animation.addByPrefix('singLEFT', 'yukichi angry left', 24);

				loadOffsetFile('no');

				playAnim('idle');

			case 'demongf' | 'demongf-city':
				switch (curCharacter)
				{
					case 'demongf':
						frames = Paths.getSparrowAtlas('characters/demongf');
						iconColor = 'FF9A1652';
					case 'demongf-city':
						frames = Paths.getSparrowAtlas('characters/demongf_city');
						iconColor = 'FFA50095';
				}		

				animation.addByPrefix('idle', "Demon Idle", 24, false);
				animation.addByPrefix('singUP', "Demon Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "Demon DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Demon Left Pose', 24, false);
				animation.addByPrefix('singRIGHT', 'Demon Pose Left', 24, false);

				loadOffsetFile('demongf');

				playAnim('idle');

			case 'brother':
				frames = Paths.getSparrowAtlas('characters/brother');
				iconColor = 'FFAF66CE';
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -45, 50);
					addOffset("singRIGHT", -20, 10);
					addOffset("singLEFT", -70, 27);
					addOffset("singDOWN", 0, -30);
				}	

				else
				{
					addOffset('idle');
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
				}
				
				playAnim('idle');

			case 'sunday':
				frames = Paths.getSparrowAtlas('characters/sunday_assets');
				iconColor = 'FF7D5849';
				animation.addByPrefix('idle-alt', 'sunday alt idle', 24, true);
				animation.addByPrefix('idle', 'sunday idle', 24, true);
				animation.addByPrefix('singUP', 'sunday up', 24, false);
				animation.addByPrefix('singUP-alt', 'sunday alt up', 24, false);
				animation.addByPrefix('singDOWN', 'sunday down', 24, false);
				animation.addByPrefix('singLEFT', 'sunday left', 24, false);
				animation.addByPrefix('singRIGHT', 'sunday right', 24, false);

				loadOffsetFile(curCharacter);
					
				if (PlayState.SONG.song.toLowerCase() == "valentine")
					playAnim('idle-alt');
				else
					playAnim('idle');

			case 'sunday-guitar':
				frames = Paths.getSparrowAtlas('characters/sunday_guitar_assets');
				iconColor = 'FF7D5849';
				animation.addByPrefix('idle-alt', 'sunday guitar idle', 24, true);
				animation.addByPrefix('idle', 'sunday guitar idle', 24, true);
				
				animation.addByPrefix('singUP', 'sunday guitar up', 24, false);
				animation.addByPrefix('singUP-alt', 'sunday guitar alt up', 24, false);
				
				animation.addByPrefix('singDOWN', 'sunday guitar down', 24, false);
				animation.addByPrefix('singDOWN-alt', 'sunday guitar alt down', 24, false);
				
				animation.addByPrefix('singLEFT', 'sunday guitar left', 24, false);
				animation.addByPrefix('singLEFT-alt', 'sunday guitar alt left', 24, false);
				
				animation.addByPrefix('singRIGHT', 'sunday guitar right', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'sunday guitar alt right', 24, false);
				
				animation.addByPrefix('end', 'sunday guitar end', 24, false);

				addOffset('idle-alt',1,1);
				
				addOffset("singRIGHT-alt",-31,-15);
				addOffset("singDOWN", 167, -28);
				addOffset("singLEFT-alt",41,-5);
				addOffset("singUP", 138, 145);
				
				addOffset('end', 166, -5);
				addOffset('idle',1,1);
				
				addOffset("singRIGHT", -36,-12);
				addOffset("singDOWN-alt",160,-30);
				addOffset("singUP-alt",104,-7);
				addOffset("singLEFT", 45, -2);
				
				
				playAnim('idle');

			case 'pompom':
				frames = Paths.getSparrowAtlas('characters/pompom_assets');
				iconColor = 'FFA93E3E';

				animation.addByPrefix('singUP', 'pompom UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'pompom DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'pompom left', 24, false);
				animation.addByPrefix('singRIGHT', 'pompom sing right', 24, false);
				animation.addByIndices('danceLeft', 'pompom dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'pompom dance idle', [8, 10, 12, 14], "", 12, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'pompom-mad':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/pompommad_assets');
				iconColor = 'FFA93E3E';
				animation.addByPrefix('idle', 'pompom mad idle', 24, false);
				animation.addByPrefix('singUP', 'pompom mad up', 24, false);
				animation.addByPrefix('singRIGHT', 'pompom mad right', 24, false);
				animation.addByPrefix('singDOWN', 'pompom mad down', 24, false);
				animation.addByPrefix('singLEFT', 'pompom mad left', 24, false);

				loadOffsetFile(curCharacter);
				
				playAnim('idle');

			case 'bf-carol':
				frames = Paths.getSparrowAtlas('characters/carol');
				iconColor = 'FF282833';
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'garcello' | 'matt2' | 'tom2' | 'garcellodead':
				switch (curCharacter)
				{
					case 'garcello': 
						frames = Paths.getSparrowAtlas('characters/garcello_assets');
						iconColor = 'FF8E40A5';
					case 'matt2':
						frames = Paths.getSparrowAtlas('characters/matt_assets_2');
						iconColor = 'FFA55BA0';
					case 'tom2':
						frames = Paths.getSparrowAtlas('characters/tom_assets_2');
						iconColor = 'FF265D86';
					case 'garcellodead':
						frames = Paths.getSparrowAtlas('characters/garcellodead_assets');
						iconColor = 'FF8E40A5';
				}

				animation.addByPrefix('idle', 'garcello idle dance', 24, false);
				animation.addByPrefix('singUP', 'garcello Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'garcello Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'garcello Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'garcello Sing Note LEFT', 24, false);

				if (curCharacter == 'tom2' || curCharacter == 'garcellodead')
				{
					animation.addByPrefix('lame', 'garcello coolguy', 24, false);
					loadOffsetFile('garcellodead');
				}
				else
				{
					loadOffsetFile('garcello');
				}

				playAnim('idle');

			case 'kou':
				frames = Paths.getSparrowAtlas('characters/Kou_FNF_assetss');
				iconColor = 'FF175D7A';

				animation.addByPrefix('idle', 'Kou Idle Pose', 24, false);
				animation.addByPrefix('singUP', 'Kou Up Note', 24, false);
				animation.addByPrefix('singRIGHT', 'Kou Right Note', 24, false);
				animation.addByPrefix('singDOWN', 'Kou Down Note', 24, false);
				animation.addByPrefix('singLEFT', 'Kou Left Note', 24, false);

				loadOffsetFile(curCharacter);
				
				playAnim('idle');

			case 'senpaighosty' | 'edd2' | 'senpaighosty-blue' | 'hd-spirit':
				switch (curCharacter)
				{
					case 'senpaighosty':
						frames = Paths.getSparrowAtlas('characters/senpaighosty_assets');
						iconColor = 'FFFF3C6E';
					case 'senpaighosty-blue':
						frames = Paths.getSparrowAtlas('characters/blue/senpaighosty_assets');
					case 'edd2':
						frames = Paths.getSparrowAtlas('characters/edd_assets_2');
						iconColor = 'FF029835';
					case 'hd-spirit':
						frames = Paths.getSparrowAtlas('characters/HD_SPIRIT');
						iconColor = 'FFFF3C6E';
				}
				
				animation.addByPrefix('idle', 'garcello idle dance', 24, false);
				animation.addByPrefix('singUP', 'garcello Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'garcello Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'garcello Sing Note DOWN', 24,  false);
				animation.addByPrefix('singLEFT', 'garcello Sing Note LEFT', 24, false);
				animation.addByPrefix('disappear', 'garcello coolguy', 24, false);

				loadOffsetFile('edd2');

				playAnim('idle');	

			case 'sayori-sad' | 'sayori-sad-blue':
				frames = Paths.getSparrowAtlas('characters/blue/sayori');
				iconColor = 'FFA15E73';
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);

				loadOffsetFile('sayori-sad');

			case 'steve':
				frames = Paths.getSparrowAtlas('characters/Steve_assets');
				iconColor = 'FF71352C';

				animation.addByPrefix('idle', 'Steve Idle Dance', 24, false);
				animation.addByPrefix('singUP', 'Steve Up Note', 24, false);
				animation.addByPrefix('singRIGHT', 'Steve Right Note', 24, false);
				animation.addByPrefix('singDOWN', 'Steve Down Note', 24,  false);
				animation.addByPrefix('singLEFT', 'Steve Left Note', 24, false);

				addOffset('idle');

				if (isPlayer)
				{
					addOffset("singUP", 100, 180);
					addOffset("singRIGHT", 80, -55);
					addOffset("singLEFT", 0, -40);
					addOffset("singDOWN", 60, -135);
				}
				else
				{
					addOffset("singUP", 0, 180);
					addOffset("singRIGHT", 0, -35);
					addOffset("singLEFT", 0, -50);
					addOffset("singDOWN", 0, -145);
				}
				
				playAnim('idle');
			
			case 'garcellotired' | 'tord2' | 'eddsworld-switch' | 'garcellotired-blue':
				switch (curCharacter)
				{
					case 'garcellotired':
						frames = Paths.getSparrowAtlas('characters/garcellotired_assets');
						iconColor = 'FF8E40A5';
					case 'garcellotired-blue':
						frames = Paths.getSparrowAtlas('characters/blue/garcellotired_assets');
					case 'tord2':
						frames = Paths.getSparrowAtlas('characters/tord_assets_2');
						iconColor = 'FFC11200';
					case 'eddsworld-switch':
						frames = Paths.getSparrowAtlas('characters/eddsworld_switch');
				}

				animation.addByPrefix('idle', 'garcellotired idle dance', 24, false);
				animation.addByPrefix('idle-alt', 'garcellotired idle dance', 24, false);
				animation.addByPrefix('singUP', 'garcellotired Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'garcellotired Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'garcellotired Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'garcellotired Sing Note LEFT', 24, false);
				animation.addByPrefix('singDOWN-alt', 'garcellotired cough', 24, false);

				loadOffsetFile('garcellotired');

				playAnim('idle');
			
			case 'whitty' | 'whitty-bw' | 'whitty-b3':			
				switch (curCharacter)
				{
					case 'whitty':
						tex = Paths.getSparrowAtlas('characters/WhittySprites');
						iconColor = 'FF1D1E35';
					case 'whitty-bw':
						tex = Paths.getSparrowAtlas('characters/bw/WhittySprites');
					case 'whitty-b3':
						tex = Paths.getSparrowAtlas('characters/b3/WhittySprites');
						iconColor = 'FF1D1E35';
				}
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Sing Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24, false);
				animation.addByPrefix('singDOWN', 'Sing Down', 24, false);
				animation.addByPrefix('singLEFT', 'Sing Left', 24, false);
				animation.addByPrefix('singUP-alt', 'Whitty Ballistic', 24, false);

				loadOffsetFile('whitty');		

				playAnim('idle');

			case 'whittyCrazy':
				frames = Paths.getSparrowAtlas('characters/WhittyCrazy');
				iconColor = 'FFFF0000';
				animation.addByPrefix('idle', 'Whitty idle dance', 24, false);
				animation.addByPrefix('singUP', 'Whitty Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'whitty sing note right', 24, false);
				animation.addByPrefix('singDOWN', 'Whitty Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Whitty Sing Note LEFT', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'spooky' | 'spooky-b3' | 'jevil' | 'spooky-pelo' | 'bomberman':
				var name:String = curCharacter;
				name = curCharacter;
				switch (curCharacter)
				{
					case 'spooky-b3':
						frames = Paths.getSparrowAtlas('characters/b3/spooky_kids_assets');
						iconColor = 'FF339966';
					case 'spooky':
						frames = Paths.getSparrowAtlas('characters/spooky_kids_assets');
						iconColor = 'FFD57E00';
					case 'jevil':
						frames = Paths.getSparrowAtlas('characters/jevil');
						iconColor = 'FFD57E00';
					case 'spooky-pelo':
						frames = Paths.getSparrowAtlas('characters/spooky_kids_assets_pelo');
						iconColor = 'FFD57E00';
						name = 'spooky';
					case 'bomberman':
						frames = Paths.getSparrowAtlas('characters/bomberman');
						iconColor = 'FFE53778';
						name = 'spooky';
				}
					
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				loadOffsetFile(name);

				playAnim('danceRight');

			case 'spooky-pixel':
				frames = Paths.getSparrowAtlas('characters/spooky_pixel');
				iconColor = 'FFD57E00';
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				if (isPlayer)
				{
					addOffset('danceLeft');
					addOffset('danceRight', 0, -5);
					addOffset("singUP", -45, 20);
					addOffset("singLEFT", 100, -15);
					addOffset("singRIGHT", -45, -15);
					addOffset("singDOWN", -10, -140);
				}	
				else
				{
					addOffset('danceLeft');
					addOffset('danceRight');
					addOffset("singUP", -20, 26);
					addOffset("singRIGHT", -130, -14);
					addOffset("singLEFT", 130, -10);
					addOffset("singDOWN", -50, -130);
				}

				playAnim('danceRight');

				antialiasing = false;

			case 'momi':
				frames = Paths.getSparrowAtlas('characters/momi_assets');
				iconColor = 'FF996699';
				animation.addByIndices('danceLeft', 'momi idle',[0,1,2,3,4],"", 24, false);
				animation.addByIndices('danceLeft-alt', 'momi alt idle',[0,1,2,3,4],"", 24, false);
				animation.addByIndices('danceRight', 'momi idle',[8,9,10,11,12],"", 24, false);
				animation.addByIndices('danceRight-alt', 'momi alt idle',[8,9,10,11,12],"", 24, false);
				
				animation.addByPrefix('singUP', 'momi up', 24, false);
				animation.addByPrefix('singDOWN', 'momi down', 24, false);
				animation.addByPrefix('singLEFT', 'momi left', 24, false);
				animation.addByPrefix('singRIGHT', 'momi right', 24, false);
				
				animation.addByPrefix('ah', 'momi ah', 24, false);
				animation.addByPrefix('ah-charged', 'momi charge ah', 24, true);
				animation.addByPrefix('chu', 'momi chu', 24, false);
				animation.addByPrefix('chu-charged', 'momi charge chu', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceLeft');

			case 'gura-amelia' | 'gura-amelia-walfie' | 'gura-amelia-bw' | 'gura-amelia-corrupt':
				if (!curCharacter.contains('bw')){
					iconColor = 'FFFFA054';
				}

				switch (curCharacter)
				{
					case 'gura-amelia':
						frames = Paths.getSparrowAtlas('characters/gura_amelia');
					case 'gura-amelia-corrupt':
						frames = Paths.getSparrowAtlas('characters/corruption/gura_amelia');
						iconColor = 'FFE22D7A';
					case 'gura-amelia-walfie':
						frames = Paths.getSparrowAtlas('characters/AmeSame_assets_WALFIE');
					case 'gura-amelia-bw':
						frames = Paths.getSparrowAtlas('characters/bw/gura_amelia');
				}
						
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByPrefix('singUPmiss', 'spooky UPNOTE MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'spooky DOWNnote MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'note singleft MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'spooky singright MISS', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);
				animation.addByIndices('danceLeft-alt', 'spooky dance idle alt', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight-alt', 'spooky dance idle alt', [8, 10, 12, 14], "", 12, false);	
				animation.addByPrefix('ah', 'spooky ah0', 24, false);
				animation.addByPrefix('ah-charged', 'spooky ah charge', 24);
				animation.addByPrefix('chu', 'spooky chu0', 24, false);
				animation.addByPrefix('chu-charged', 'spooky chu charge', 24, false);
				if (PlayState.SONG.song == 'Nerves')
				{
					animation.addByPrefix('singDOWN-alt', 'spooky sneeze', 24, false);
				}

				addOffset('danceLeft');
				addOffset('danceRight');

				if (isPlayer)
				{
					addOffset("singUP", -50, 31);
					addOffset("singDOWN", -20, -150);	
					addOffset("singLEFT", 45, -17);
					addOffset("singRIGHT", -15, -10);

					addOffset("singUPmiss", -60, 28);
					addOffset("singDOWNmiss", -15, -140);		
					addOffset("singLEFTmiss", 41, -25);
					addOffset("singRIGHTmiss", -10, -20);

					addOffset("ah", -53, 26);
					addOffset("chu", 45, -17);
					addOffset("ah-charged", -40, 26);
					addOffset("chu-charged", 53, -17);
					if (PlayState.SONG.song == 'Nerves')
						addOffset("singDOWN-alt", -8, 198);
				}
				else
				{
					addOffset("singUP", -20, 26);
					addOffset("singRIGHT", -92, -17);
					addOffset("singLEFT", 130, -10);
					addOffset("singDOWNmiss", 50, -150);
					addOffset("singUPmiss", -20, 26);
					addOffset("singRIGHTmiss", -92, -17);
					addOffset("singLEFTmiss", 130, -10);
					addOffset("singDOWN", 45, -150);
					addOffset("ah", -20, 26);
					addOffset("chu", -87, -17);
					addOffset("ah-charged", -20, 26);
					addOffset("chu-charged", -87, -17);
					if (PlayState.SONG.song == 'Nerves')
						addOffset("singDOWN-alt", -8, 198);
				}

				playAnim('danceRight');

			case 'mom' | 'static' | 'mom-shaded':
				var name:String = curCharacter;
				switch (curCharacter)
				{
					case 'mom':
						frames = Paths.getSparrowAtlas('characters/Mom_Assets');
						iconColor = 'FFD8558E';
					case 'static':
						frames = Paths.getSparrowAtlas('characters/static_Assets');
						iconColor = 'FF434050';
					case 'mom-shaded':
						frames = Paths.getSparrowAtlas('characters/Mom_Assets_Shaded');
						iconColor = 'FFD8558E';
						name = 'mom';
				}	
				noteSkin = PlayState.SONG.noteStyle;

				animation.addByPrefix('idle', "Mom Idle0", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose0", 24, false);
				animation.addByPrefix('singUPmiss', "Mom Up Pose MISS0", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE0", 24, false);
				animation.addByPrefix('singDOWNmiss', "MOM DOWN POSE MISS0", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Mom Left Pose MISS0', 24, false);
				animation.addByPrefix('singRIGHT', 'Mom Pose Left0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Mom Pose Left MISS0', 24, false);

				loadOffsetFile(name);
				
				playAnim('idle');
				
			case 'b3-mom-sad' | 'b3-mom-mad' | 'mom-sad-blue':
				tex = Paths.getSparrowAtlas('characters/B3_Mom_Sad');
				switch (curCharacter)
				{
					case 'b3-mom-sad':
						tex = Paths.getSparrowAtlas('characters/B3_Mom_Sad');
						iconColor = 'FFB1439A';
					case 'b3-mom-mad':
						tex = Paths.getSparrowAtlas('characters/B3_Mom_Mad');
						iconColor = 'FFB1439A';
					case 'mom-sad-blue':
						tex = Paths.getSparrowAtlas('characters/blue/Mom_Sad_Assets');
				}
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle0", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose0", 24, false);
				animation.addByPrefix('singDOWN', "Mom Down Pose0", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose0', 24, false);
				animation.addByPrefix('singRIGHT', 'Mom Right Pose0', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -16, 71);
					addOffset("singLEFT", 250, -60);
					addOffset("singRIGHT", -50, -23);
					addOffset("singDOWN", 20, -160);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", 14, 71);
					addOffset("singRIGHT", 10, -60);
					addOffset("singLEFT", 250, -23);
					addOffset("singDOWN", 20, -160);
				}
				
				playAnim('idle');

			case 'mia' | 'mia-lookstraight' | 'mia-wire' | 'mia-lookstraight-sad-blue':
				switch (curCharacter)
				{
					case 'mia' | 'mia-lookstraight':
						tex = Paths.getSparrowAtlas('characters/mia_assets');
					case 'mia-lookstraight-sad-blue':
						tex = Paths.getSparrowAtlas('characters/blue/mia_assets_sad');
					case 'mia-wire':
						tex = Paths.getSparrowAtlas('characters/mia_assets_WIRE');
				}
				iconColor = 'FFFF68ED';
				
				frames = tex;

				if (curCharacter.contains('lookstraight'))
				{
					animation.addByPrefix('idle', "Mia Tall Idle0", 24, false);
					animation.addByPrefix('singUP', "Mia Tall Up0", 24, false);
					animation.addByPrefix('singDOWN', "Mia Down0", 24, false);
					animation.addByPrefix('singLEFT', 'Mia Left0', 24, false);
					animation.addByPrefix('singRIGHT', 'Mia Tall Right0', 24, false);
				}
				else
				{
					animation.addByPrefix('idle', "Mia Idle0", 24, false);
					animation.addByPrefix('singUP', "Mia Up0", 24, false);
					animation.addByPrefix('singDOWN', "Mia Down0", 24, false);
					animation.addByPrefix('singLEFT', 'Mia Left0', 24, false);
					animation.addByPrefix('singRIGHT', 'Mia Right0', 24, false);
				}		

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -26, 61);
					addOffset("singLEFT", 60, -70);
					addOffset("singRIGHT", -100, -23);
					addOffset("singDOWN", 70, 0);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", 44, 61);
					addOffset("singRIGHT", 150, -70);
					addOffset("singLEFT", 250, -23);
					addOffset("singDOWN", 70, 0);
				}	

				playAnim('idle');
				
			case 'peri':
				frames = Paths.getSparrowAtlas('characters/peri_assets');
				iconColor = 'FFF199DA';

				animation.addByPrefix('idle', 'peri idle', 24, false);
				animation.addByPrefix('singUP', 'peri up', 24, false);
				animation.addByPrefix('singRIGHT', 'peri right', 24, false);
				animation.addByPrefix('singDOWN', 'peri down', 24, false);
				animation.addByPrefix('singLEFT', 'peri left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 20);
				addOffset("singRIGHT", 30, -20);
				addOffset("singLEFT", 60, -20);
				addOffset("singDOWN", 20, -25);

				setGraphicSize(Std.int(width * 0.85));
				updateHitbox();

				playAnim('idle');

			case 'mel':
				frames = Paths.getSparrowAtlas('characters/mel_assets');
				iconColor = 'FFC4E666';//

				animation.addByPrefix('idle', 'mel idle', 24, false);
				animation.addByPrefix('singUP', 'mel up', 24, false);
				animation.addByPrefix('singRIGHT', 'mel right', 24, false);
				animation.addByPrefix('singDOWN', 'mel down', 24, false);
				animation.addByPrefix('singLEFT', 'mel left', 24, false);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * 0.85));
				updateHitbox();

				playAnim('idle');	
			
			case 'bana' | 'bana-wire':
				switch (curCharacter)
				{
					case 'bana':
						frames = Paths.getSparrowAtlas('characters/bana_assets');
					case 'bana-wire':
						frames = Paths.getSparrowAtlas('characters/bana_assets_WIRE');
				}
				iconColor = 'FFFEDC5F';

				animation.addByPrefix('idle', 'bana idle', 24, false);
				animation.addByPrefix('singUP', 'bana up', 24, false);
				animation.addByPrefix('singRIGHT', 'bana right', 24, false);
				animation.addByPrefix('singDOWN', 'bana down', 24, false);
				animation.addByPrefix('singLEFT', 'bana left', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -16, 160);
					addOffset("singRIGHT", 60, -10);
					addOffset("singLEFT", 10, -20);
					addOffset("singDOWN", 50, -	5);
				}	
				else
				{
					addOffset('idle');
					addOffset("singUP", 14, 120);
					addOffset("singRIGHT", 10, -20);
					addOffset("singLEFT", 60, -20);
					addOffset("singDOWN", 20, -25);
				}	

				setGraphicSize(Std.int(width * 0.85));
				updateHitbox();

				playAnim('idle');

			case 'anchor' | 'anchor-bw':
				switch (curCharacter)
				{
					case 'anchor':
						tex = Paths.getSparrowAtlas('characters/anchorAssets');
						iconColor = 'FF4E589B';
					case 'anchor-bw':
						tex = Paths.getSparrowAtlas('characters/bw/anchorAssets');
				}
				frames = tex;

				animation.addByPrefix('idle', "anchor Idle", 24, false);
				animation.addByPrefix('singUP', "anchor Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "anchor DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'anchor Left Pose', 24, false);
				// ANIMATION IS CALLED anchor LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'anchor Pose Left', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -25, 60);
					addOffset("singRIGHT", -70, 0);
					addOffset("singLEFT", 150, -35);
					addOffset("singDOWN", -5, -195);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", 35, 60);
					addOffset("singLEFT", 190, 0);
					addOffset("singRIGHT", 80, -35);
					addOffset("singDOWN", -10, -190);
				}

				playAnim('idle');

			case 'bf-mom' | 'bf-mom-car':
				switch (curCharacter)
				{
					case 'bf-mom':
						frames = Paths.getSparrowAtlas('characters/mombf');
					case 'bf-mom-car':
						frames = Paths.getSparrowAtlas('characters/mombfCar');
				}
				iconColor = 'FF0EAEFE';
				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singRIGHT', 'Mom Left Pose', 24, false);
				animation.addByPrefix('singLEFT', 'Mom Pose Left', 24, false);
				
				if (!isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", 4, 71);
					addOffset("singRIGHT", -20, -60);
					addOffset("singLEFT", 250, -23);
					addOffset("singDOWN", -10, -160);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", 95, 50);
					addOffset("singLEFT", 10, -50);
					addOffset("singRIGHT", 120, -33);
					addOffset("singDOWN", 160, -150);
				}
				
				playAnim('idle');

			case 'cassandra' | 'cassandra-bw':
				switch (curCharacter)
				{
					case 'cassandra':
						tex = Paths.getSparrowAtlas('characters/cassandra');
						iconColor = 'FF454545';
					case 'cassandra-bw':
						tex = Paths.getSparrowAtlas('characters/bw/cassandra');
				}
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('idle-alt', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				animation.addByPrefix('singUP-alt', 'Mom UGH', 24, false);
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", 35, 60);
					addOffset("singLEFT", 120, -55);
					addOffset("singRIGHT", -35, -25);
					addOffset("singDOWN", 80, -160);
					addOffset("singUP-alt", -35, -25);	
				}
				else
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", 14, 71);
					addOffset("singRIGHT", 10, -60);
					addOffset("singLEFT", 250, -23);
					addOffset("singDOWN", 20, -160);
					addOffset("singUP-alt", 250, -23);
				}
				playAnim('idle');

			// Normal Alt is Dark Sarv and Alt2 is Concerned Sarv
			case 'sarvente':
				frames = Paths.getSparrowAtlas('characters/sarvente_sheet');
				iconColor = 'FFF691C5';

				animation.addByPrefix('idle', "SarventeIdle", 24, false);
				animation.addByPrefix('singUP', "SarventeUp", 24, false);
				animation.addByPrefix('singDOWN', "SarventeDown", 24, false);
				animation.addByPrefix('singLEFT', 'SarventeLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'SarventeRight', 24, false);
				animation.addByPrefix('idle-alt', "SarvDarkIdle", 24, false);
				animation.addByPrefix('singUP-alt', "SarvDarkUp2", 24, false);
				animation.addByPrefix('singLEFT-alt', 'SarvDarkLeft2', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'SarvDarkRight2', 24, false);
				animation.addByPrefix('singDOWN-alt', "SarvDarkDown2", 24, false);
				animation.addByPrefix('idle-alt2', "SarvDarkIdle", 24, false);
				animation.addByPrefix('singUP-alt2', "SarvDarkUp0", 24, false);
				animation.addByPrefix('singLEFT-alt2', 'SarvDarkLeft0', 24, false);
				animation.addByPrefix('singRIGHT-alt2', 'SarvDarkRight0', 24, false);
				animation.addByPrefix('singDOWN-alt2', "SarvDarkDown0", 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'sarvente-dark':
				frames = Paths.getSparrowAtlas('characters/sarvente_sheet');
				iconColor = 'FFF691C5';

				animation.addByPrefix('idle', "SarvDarkIdle", 24, false);
				animation.addByPrefix('singUP', "SarvDarkUp", 24, false);
				animation.addByPrefix('singLEFT', 'SarvDarkLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'SarvDarkRight', 24, false);
				animation.addByPrefix('singDOWN', "SarvDarkDown", 24, false);
				animation.addByPrefix('singUP-alt', "SarvDarkUp2", 24, false);
				animation.addByPrefix('singLEFT-alt', 'SarvDarkLeft2', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'SarvDarkRight2', 24, false);
				animation.addByPrefix('singDOWN-alt', "SarvDarkDown2", 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'sarvente-worried-night' | 'sarvente-worried-blue':
				switch (curCharacter)
				{
					case 'sarvente-worried-night':
						frames = Paths.getSparrowAtlas('characters/sarvente_sheet_worried_night');
					case 'sarvente-worried-blue':
						frames = Paths.getSparrowAtlas('characters/blue/sarvente_sheet_worried');
				}
				iconColor = 'FFF691C5';
			
				animation.addByPrefix('idle', "SarventeIdle", 24, false);
				animation.addByPrefix('singUP', "SarventeUp", 24, false);
				animation.addByPrefix('singDOWN', "SarventeDown", 24, false);
				animation.addByPrefix('singLEFT', 'SarventeLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'SarventeRight', 24, false);
				animation.addByPrefix('idle-alt', "SarvDarkIdle", 24, false);
				animation.addByPrefix('singDOWN-alt', "SarvDarkDown2", 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset('idle-alt');
				addOffset("singDOWN-alt");

				playAnim('idle');

			case 'sky-mad' | 'sky-pissed':
				switch (curCharacter)
				{
					case 'sky-mad':
						frames = Paths.getSparrowAtlas('characters/sky_mad_assets');
					case 'sky-pissed':
						frames = Paths.getSparrowAtlas('characters/sky_pissed_assets');
				}
				iconColor = 'FFFF0000';
				animation.addByPrefix('idle', "sky mad idle", 24, false);
				animation.addByPrefix('singUP', "sky mad up", 24, false);
				animation.addByPrefix('singDOWN', "sky mad down", 24, false);
				animation.addByPrefix('singLEFT', 'sky mad left', 24, false);
				animation.addByPrefix('singRIGHT', 'sky mad right', 24, false);

				addOffset('idle');
				
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				if (isPlayer)
				{
					addOffset("singUP", -20, 0);
				}
				else
				{
					addOffset("singUP", 20, 0);
				}

				playAnim('idle');

			case 'sarvente-lucifer':
				tex = Paths.getSparrowAtlas('characters/smokinhotbabe');
				frames = tex;
				iconColor = 'FFDA317D';

				animation.addByPrefix('idle', "LuciferSarvIdle", 24, false);
				animation.addByPrefix('singUP', "LuciferSarvUp", 24, false);
				animation.addByPrefix('singDOWN', "LuciferSarvDown", 24, false);
				animation.addByPrefix('singLEFT', 'LuciferSarvLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'LuciferSarvRight', 24, false);

				loadOffsetFile('no');

				playAnim('idle');

			case 'ruv' | 'ruv-mad':
				switch (curCharacter)
				{
					case 'ruv':
						frames = Paths.getSparrowAtlas('characters/ruv_sheet');
					case 'ruv-mad':
						frames = Paths.getSparrowAtlas('characters/ruv_mad');
				}
				iconColor = 'FF978AA6';

				animation.addByPrefix('idle', "RuvIdle", 24, false);
				animation.addByPrefix('idle-alt', "RuvIdle", 24, false);
				animation.addByPrefix('singUP', "RuvUp", 24, false);
				animation.addByPrefix('singDOWN', "RuvDown", 24, false);
				animation.addByPrefix('singLEFT', 'RuvLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'RuvRight', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", 160, 0);
					addOffset("singRIGHT", 20, -60);
					addOffset("singLEFT", 90, 0);
					addOffset("singDOWN", 110, 5);
				}
				else
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", -10, 0);
					addOffset("singRIGHT", -30, 0);
					addOffset("singLEFT", 90, -60);
					addOffset("singDOWN", 40, 5);
				}	

				playAnim('idle');

			case 'selever':
				tex = Paths.getSparrowAtlas('characters/fuckboi_sheet');
				frames = tex;
				noteSkin = PlayState.SONG.noteStyle;
				iconColor = 'FF96224F';

				animation.addByPrefix('idle', "SelIdle", 24, false);
				animation.addByPrefix('singUP', "SelUp", 24, false);
				animation.addByPrefix('singDOWN', "SelDown", 24, false);
				animation.addByPrefix('singLEFT', 'SelLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'SelRight', 24, false);
				animation.addByPrefix('hey', 'SelHey', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'myra':
				frames = Paths.getSparrowAtlas('characters/myra_assets');
				iconColor = 'FF5A2253';

				animation.addByPrefix('idle', "MyraIdle", 24, false);
				animation.addByPrefix('singUP', "MyraUp", 24, false);
				animation.addByPrefix('singRIGHT', 'MyraRight', 24, false);
				animation.addByPrefix('singLEFT', 'MyraLeft', 24, false);
				animation.addByPrefix('singDOWN', "MyraDown", 24, false);

				animation.addByPrefix('singUP-alt', 'MyraAAA', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'MyraRight', 24, false);
				animation.addByPrefix('singLEFT-alt', 'MyraLaugh', 24, false);
				animation.addByPrefix('singDOWN-alt', 'MyraDown', 24, false);

				loadOffsetFile('no');

				playAnim('idle');

			case 'roro' | 'roro-bw':
				switch (curCharacter)
				{
					case 'roro':
						tex = Paths.getSparrowAtlas('characters/roroAssets');
						iconColor = 'FF198C7F';
					case 'roro-bw':
						tex = Paths.getSparrowAtlas('characters/bw/roroAssets');
				}
				
				frames = tex;

				animation.addByPrefix('idle', "roro Idle", 24, false);
				animation.addByPrefix('singUP', "roro Up Note", 24, false);
				animation.addByPrefix('singDOWN', "roro Down Note", 24, false);
				animation.addByPrefix('singLEFT', 'roro Left Note', 24, false);
				animation.addByPrefix('singRIGHT', 'roro Right Note', 24, false);

				loadOffsetFile('roro');

				playAnim('idle');

			case 'chara':
				frames = Paths.getSparrowAtlas('characters/chara');
				iconColor = 'FFFF0000';

				animation.addByPrefix('idle', "chara0", 24, false);
				animation.addByPrefix('singUP', "chara up", 24, false);
				animation.addByPrefix('singDOWN', "chara down", 24, false);
				animation.addByPrefix('singLEFT', 'chara left', 24, false);
				animation.addByPrefix('singRIGHT', 'chara right', 24, false);

				addOffset('idle');
				addOffset("singUP", 10 , 10);
				addOffset("singRIGHT", 15, 5);
				addOffset("singLEFT");
				addOffset("singDOWN", 10, -10);

				playAnim('idle');

			case 'mackiepom':
				frames = Paths.getSparrowAtlas('characters/mackiepom_assets');
				iconColor = 'FFA93E3E';
				animation.addByPrefix('danceLeft', 'mackiepom dance left', 24, false);
				animation.addByPrefix('danceRight', 'mackiepom dance right', 24, false);
				animation.addByPrefix('danceLeft-alt', 'mackiepom dance left', 24, false);
				animation.addByPrefix('danceRight-alt', 'mackiepom dance right', 24, false);
				animation.addByPrefix('singUP', 'pom up', 24, false);
				animation.addByPrefix('singDOWN', 'pom down', 24, false);
				animation.addByPrefix('singLEFT', 'pom left', 24, false);
				animation.addByPrefix('singRIGHT', 'pom right', 24, false);

				animation.addByPrefix('singUP-alt', 'mackiepom up alt', 24, false);
				animation.addByPrefix('singDOWN-alt', 'mackiepom down alt', 24, false);
				animation.addByPrefix('singLEFT-alt', 'mackiepom left alt', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'mackiepom right alt', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'mom-car' | 'exgf' | 'freddy':
				switch (curCharacter)
				{
					case 'mom-car':
						tex = Paths.getSparrowAtlas('characters/momCar');
						iconColor = 'FFd8558e';
					case 'exgf':
						tex = Paths.getSparrowAtlas('characters/exGF');
						iconColor = 'FF64FFC1';
					case 'freddy':
						tex = Paths.getSparrowAtlas('characters/freddy');
						iconColor = 'FF6D3B0E';
				}
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				if (curCharacter == 'freddy')
				{
					loadOffsetFile(curCharacter);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", 14, 71);
					addOffset("singRIGHT", 10, -60);
					addOffset("singLEFT", 250, -23);
					addOffset("singDOWN", 20, -160);
				}

				playAnim('idle');

			case 'coco' | 'coco-car' | 'coco-corrupt':
				iconColor = 'FFE67A34';
				noteSkin = 'holofunk';
				switch (curCharacter)
				{
					case 'coco':
						tex = Paths.getSparrowAtlas('characters/Coco_Assets');
					case 'coco-car':
						tex = Paths.getSparrowAtlas('characters/cocoCar');	
					case 'coco-corrupt':
						tex = Paths.getSparrowAtlas('characters/corruption/Coco_Assets');
						iconColor = 'FFE22D7A';
						noteSkin = 'corrupted';
				}

				frames = tex;
				
				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				animation.addByPrefix('singUP-alt', 'Coco Laugh Up', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Coco Laugh Down', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Coco Laugh Left', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Coco Laugh Right', 24, false);

				addOffset('idle', 0, 15);
				
				if (isPlayer)
				{
					addOffset("singUP", 15, 52);
					addOffset("singLEFT", 80, -80);
					addOffset("singRIGHT", 80, -52);
					addOffset("singDOWN", 80, -200);
					addOffset("singUP-alt", 15, 52);
					addOffset("singLEFT-alt", 80, -80);
					addOffset("singRIGHT-alt", 80, -52);
					addOffset("singDOWN-alt", 80, -200);
				}
				else
				{
					addOffset("singUP", 35, 52);
					addOffset("singRIGHT", -30, -80);
					addOffset("singLEFT", 250, -52);
					addOffset("singDOWN", 20, -200);
					addOffset("singUP-alt", 35, 52);
					addOffset("singRIGHT-alt", -30, -80);
					addOffset("singLEFT-alt", 250, -52);
					addOffset("singDOWN-alt", 20, -200);
				}

				playAnim('idle');

			case 'monster':
				frames = Paths.getSparrowAtlas('characters/Monster_Assets');
				iconColor = 'FFF3FF6E';
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				if (isPlayer)
				{
					animation.addByPrefix('singRIGHT', 'Monster left note', 24, false);
					animation.addByPrefix('singLEFT', 'Monster Right note', 24, false);
				}

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -50, 80);
					addOffset("singRIGHT", -51, 20);
					addOffset("singLEFT", 10, 0);
					addOffset("singDOWN", -2, -94);
				}
				else
				{	
					addOffset('idle');
					addOffset("singUP", -22, 87);
					addOffset("singLEFT", -24, 4);
					addOffset("singRIGHT", -40, 10);
					addOffset("singDOWN", -43, -89);				
				}

				playAnim('idle');

			case 'bob2' | 'bob2-night':
				switch (curCharacter)
				{
					case 'bob2':
						frames = Paths.getSparrowAtlas('characters/bob_assets');
					case 'bob2-night':
						frames = Paths.getSparrowAtlas('characters/bob_assets_night');
				}
				
				iconColor = "FFEBDD44";
				noteSkin = 'bob';
				animation.addByPrefix('idle', 'BOB idle dance', 24, false);
				animation.addByPrefix('singUP', 'BOB Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'BOB Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'BOB Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'BOB Sing Note RIGHT', 24, false);

				loadOffsetFile('bob2');

				playAnim('idle');

			case 'bosip':
				frames = Paths.getSparrowAtlas('characters/bosip_assets');
				iconColor = "FFE18B38";
				noteSkin = 'bosip';
				animation.addByPrefix('idle', 'Bosip idle dance', 24, false);
				animation.addByPrefix('singUP', 'Bosip Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'Bosip Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Bosip Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'Bosip Sing Note RIGHT', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", 93, 24);
					addOffset("singLEFT", -6, -18);
					addOffset("singRIGHT", -26, 7);
					addOffset("singDOWN", -40, -18);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", 23, 24);
					addOffset("singRIGHT", -6, -18);
					addOffset("singLEFT", 64, 7);
					addOffset("singDOWN", 22, -18);
				}
				
				playAnim('idle');

			case 'pumpkinpie':
				frames = Paths.getSparrowAtlas('characters/Pumpkin_Pie_Assets');
				iconColor = 'FFA84929';
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');

				if (isPlayer)
				{
					addOffset("singUP", 20, 50);
					addOffset("singRIGHT", 115, 0);
					addOffset("singLEFT", 100, 0);
					addOffset("singDOWN", 40, -94);
				}
				else
				{	
					addOffset("singUP", -20, 50);
					addOffset("singLEFT", -51);
					addOffset("singRIGHT", -30);
					addOffset("singDOWN", -40, -94);				
				}

				playAnim('idle');
				
			case 'haachama' | 'haachama-blue':
				iconColor = 'FFF58F2B';
				if (curCharacter == 'haachama-blue') 
				{
					pre = 'blue/';
					iconColor = 'FFDAE6A0';
				}
					
				frames = Paths.getSparrowAtlas('characters/'+pre+'Haachama_Assets');
				
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle', 0, -70);

				if (isPlayer)
				{			
					addOffset("singUP", -25, -23);
					addOffset("singLEFT", 29, -84);
					addOffset("singRIGHT", -70, -70);
					addOffset("singDOWN", -10, -130);
				}
				else
				{
					addOffset("singUP", 5, -23);
					addOffset("singRIGHT", -61, -84);
					addOffset("singLEFT", 0, -70);
					addOffset("singDOWN", 20, -130);
				}
				
				playAnim('idle');

			case 'taki':
				frames = Paths.getSparrowAtlas('characters/Taki_Assets');
				iconColor = 'FFD34470';
				noteSkin = 'taki';

				animation.addByIndices('danceLeft', 'monster idle', [15, 0, 1, 2, 3, 4, 5, 6], "", 24, false);
				animation.addByIndices('danceRight', 'monster idle', [7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('danceLeft', 0, -70);
				addOffset('danceRight', 0, -70);

				addOffset("singUP", -5, -53);
				addOffset("singRIGHT", 10, -70);
				addOffset("singLEFT", 0, -70);
				addOffset("singDOWN", 30, -50);

				playAnim('danceRight');

			case 'monster-christmas':
				frames = Paths.getSparrowAtlas('characters/monsterChristmas');
				iconColor = 'FFF3FF6E';
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster left note', 24, false);
				animation.addByPrefix('singLEFT', 'Monster Right note', 24, false);

				addOffset('idle');

				if (isPlayer)
				{
					addOffset("singUP", -50, 80);
					addOffset("singRIGHT", -51, 20);
					addOffset("singLEFT", 10, 0);
					addOffset("singDOWN", -2, -94);
				}
				else
				{	
					addOffset("singUP", -20, 50);
					addOffset("singLEFT", -51);
					addOffset("singRIGHT", -30);
					addOffset("singDOWN", -40, -94);				
				}

			case 'drunk-annie' | 'drunk-annie-blue':
				switch (curCharacter)
				{
					case 'drunk-annie':
						frames = Paths.getSparrowAtlas('characters/drunkAnnie');
						iconColor = 'FF1D2A2C';
					case 'drunk-annie-blue':
						frames = Paths.getSparrowAtlas('characters/blue/drunkAnnie');
				}
			
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				
				if (isPlayer)
				{
					addOffset("singUP", 20, 50);
					addOffset("singRIGHT", 40);
					addOffset("singLEFT", 50);
					addOffset("singDOWN", 40, -90);
				}
				else
				{
					addOffset("singUP", -20, 50);
					addOffset("singRIGHT", -50);
					addOffset("singLEFT", -40);
					addOffset("singDOWN", -40, -90);
				}
						
				playAnim('idle');

			case 'nonsense-god':
				frames = Paths.getSparrowAtlas('characters/Nonsense_God');
				iconColor = 'FF82592E';
				noteSkin = PlayState.SONG.noteStyle;
				animation.addByPrefix('idle', 'idle god', 24, false);
				animation.addByPrefix('singUP', 'god right', 24, false);
				animation.addByPrefix('singLEFT', 'left god', 24, false);
				animation.addByPrefix('singRIGHT', 'god right', 24, false);
				animation.addByPrefix('singDOWN', 'God down', 24, false);
				animation.addByPrefix('die', 'die god', 24, false);
				animation.addByIndices('singUP-alt', 'god up long note', [0, 2, 3, 4, 5, 6, 7], "", 24, false);

				addOffset('idle', 1, 1);
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("die", 718, 302);
				addOffset("singUP-alt", 0, 6);
				
				playAnim('idle');

			case 'nonsense-pissed':
				frames = Paths.getSparrowAtlas('characters/Nonsense_Pissed');
				iconColor = 'FF82592E';

				animation.addByPrefix('idle', 'Idle pissed', 24, false);
				animation.addByPrefix('singUP', 'Up Pissed', 24, false);
				animation.addByPrefix('singLEFT', 'Right Pissed', 24, false);
				animation.addByPrefix('singRIGHT', 'pissed left', 24, false);
				animation.addByPrefix('singDOWN', 'Pissed Down', 24, false);
				animation.addByPrefix('mad', 'pissed mid-song', 24, false);
				animation.addByPrefix('hahahlol', 'takethat', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 21);
				addOffset("singRIGHT", -6, -7);
				addOffset("singLEFT", 20, -13);
				addOffset("singDOWN", 19, -50);
				addOffset("mad");
				addOffset("hahahlol");
				
				playAnim('idle');

			case 'nonsense-mad':
				frames = Paths.getSparrowAtlas('characters/Nonsense_Mad');
				iconColor = 'FF82592E';

				animation.addByIndices('idle', 'Mad Idle', [0, 1, 2, 3], "", 24, true);
				animation.addByPrefix('singUP', 'MAD up', 24, false);
				animation.addByPrefix('singLEFT', 'Mad Left', 24, false);
				animation.addByPrefix('singRIGHT', 'MadRight', 24, false);
				animation.addByPrefix('singDOWN', 'Mad down', 24, false);
				animation.addByPrefix('pain', 'Lol he pissed', 24, false);
				
				loadOffsetFile(curCharacter);
				
				playAnim('idle');

			case 'eteled2':
				noteSkin = 'eteled';
				iconColor = 'FF181A22';
				frames = Paths.getSparrowAtlas('characters/eteled2_assets');

				animation.addByPrefix('idle', 'eteled idle dance', 24);
				animation.addByPrefix('singUP', 'eteled Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'eteled Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'eteled Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'eteled Sing Note LEFT', 24);
				animation.addByPrefix('scream', 'eteled SCREAM', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'austin':
				noteSkin = 'austin';
				iconColor = 'FF6A0200';
				frames = Paths.getSparrowAtlas('characters/austin_assets','shared');

				animation.addByPrefix('idle', 'austin idle dance', 24, false);

				animation.addByPrefix('singUP', 'austin Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'austin Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'austin Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'austin Sing Note LEFT', 24, false);

				animation.addByPrefix('singUPmiss', 'austin miss up', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'austin miss right', 24, false);
				animation.addByPrefix('singDOWNmiss', 'austin miss down', 24, false);
				animation.addByPrefix('singLEFTmiss', 'austin miss left', 24, false);

				animation.addByPrefix('firstDeath', "austin fucking dies", 24, false);
				animation.addByPrefix('deathLoop', "austin fucking dies loop", 24, false);
				animation.addByPrefix('deathConfirm', "austin fucking dies confirm", 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'brody':
				frames = Paths.getSparrowAtlas('characters/Brody_Assets','shared');
				iconColor = 'FFFFA2E1';
				
				animation.addByPrefix('idle', 'Brody idle dance', 24, false);
				animation.addByPrefix('singUP', 'Brody Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Brody Right', 24, false);
				animation.addByPrefix('singDOWN', 'Brody Down', 24, false);
				animation.addByPrefix('singLEFT', 'Brody Left', 24, false);
				
				animation.addByPrefix('singUP-alt', 'Brody Ugh', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'pshaggy':
				tex = Paths.getSparrowAtlas('characters/pshaggy');
				frames = tex;
				animation.addByPrefix('idle', 'pshaggy_idle', 7, false);
				animation.addByPrefix('singUP', 'pshaggy_up', 28, false);
				animation.addByPrefix('singDOWN', 'pshaggy_down', 28, false);
				animation.addByPrefix('singLEFT', 'pshaggy_left', 28, false);
				animation.addByPrefix('singRIGHT', 'pshaggy_right', 28, false);
				animation.addByPrefix('back', 'pshaggy_back', 28, false);
				animation.addByPrefix('snap', 'pshaggy_snap', 7, false);
				animation.addByPrefix('snapped', 'pshaggy_did_snap', 28, false);
				animation.addByPrefix('smile', 'pshaggy_smile', 7, false);
				animation.addByPrefix('stand', 'pshaggy_stand', 7, false);

				addOffset("idle");
				addOffset("smile");
				var sOff = 20;
				addOffset("back", 0, -20 + sOff);
				addOffset("stand", 0, -20 + sOff);
				addOffset("snap", 10, 72 + sOff);
				addOffset("snapped", 0, 60 + sOff);
				addOffset("singUP", -6, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 10, 0);
				addOffset("singDOWN", 60, -100);

				playAnim('idle', true);

			case 'picoCrazy':
				tex = Paths.getSparrowAtlas('characters/picoCrazy');
				frames = tex;

				animation.addByPrefix('idle', 'Pico Idle Dance', 24, false);
				animation.addByPrefix('mad', 'Pico Mad Idle', 24, false);
				animation.addByPrefix('huh', 'Pico Huh Idle', 24, false);
				animation.addByPrefix('pissed', 'Pico Pissed Shot', 24, false);
				animation.addByPrefix('idle-alt', 'Pico Idle Dance', 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Pico Shoot0', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Pico Shoot Left0', 24, false);

				addOffset('idle');
				addOffset('idle-alt');

				if (isPlayer)
				{
					addOffset("singUP", 20, 20);
					addOffset("singLEFT", 80, -15);
					addOffset("singLEFT-alt", 80, -15);
					addOffset("singRIGHT", -45, 0);
					addOffset("singDOWN", 95, -90);
					addOffset("singDOWN-alt", 95, -90);
				}
				else
				{
					addOffset('mad');
					addOffset('huh');
					addOffset('pissed', 0, 98);
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -68, -7);
					addOffset("singRIGHT-alt", -68, -7);
					addOffset("singLEFT", 65, 9);
					addOffset("singDOWN", 200, -70);
					addOffset("singDOWN-alt", 200, -70);
				}

				playAnim('idle');

				flipX = true;

			case 'pico' | 'pico-bw' | 'pico-b3' | 'sanford' | 'ridzak':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');
				switch (curCharacter)
				{
					case 'pico':
						frames = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');
						iconColor = 'FFB7D855';
					case 'pico-bw':
						frames = Paths.getSparrowAtlas('characters/bw/Pico_FNF_assetss');
					case 'pico-b3':
						frames = Paths.getSparrowAtlas('characters/b3/Pico_FNF_assetss');
						iconColor = 'FF83001F';
					case 'sanford':
						frames = Paths.getSparrowAtlas('characters/Sanford_FNF_assets');
						iconColor = 'FF626262';
					case 'ridzak':
						frames = Paths.getSparrowAtlas('characters/ridzak');
						iconColor = 'FFD22D3D';
				}
				
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Pico Shoot0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24, false);

				if (curCharacter == 'pico-b3' || curCharacter == 'ridzak'){
					loadOffsetFile(curCharacter);
				}
				else {
					loadOffsetFile('pico');
				}

				playAnim('idle');

				flipX = true;

			case 'alya':
				frames = Paths.getSparrowAtlas('characters/alyaAssets');
				iconColor = 'FF4E6575';

				animation.addByPrefix('idle', "Alya Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'Alya Up Note0', 24, false);
				animation.addByPrefix('singDOWN', 'Alya Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Alya Right Note0', 24, false);
				animation.addByPrefix('singRIGHT', 'Alya Left Note0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Alya Left Note MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Alya Right Note MISS', 24, false);

				animation.addByPrefix('singUPmiss', 'Alya Up Note MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Alya Down Note MISS', 24, false);

				addOffset('idle');

				if (isPlayer)
				{
					addOffset("singUP", -33, 36);
					addOffset("singLEFT", 30, -10);
					addOffset("singRIGHT", -23, -7);
					addOffset("singDOWN", -10, -43);
					addOffset("singUPmiss", -27, 40);
					addOffset("singLEFTmiss", 30, -10);
					addOffset("singRIGHTmiss", -28, -9);
					addOffset("singDOWNmiss", -10, 0);
				}
				else
				{				
					addOffset("singUP", 27, 36);
					addOffset("singRIGHT", 30, -10);
					addOffset("singLEFT", 17, -7);
					addOffset("singDOWN", 10, -43);
					addOffset("singUPmiss", 33, 40);
					addOffset("singRIGHTmiss", 20, -3);
					addOffset("singLEFTmiss", 17, -7);
					addOffset("singDOWNmiss", 10, 0);
				}

				playAnim('idle');

				flipX = true;

			case 'bb':
				switch (curCharacter)
				{
					case 'bb':
						frames = Paths.getSparrowAtlas('characters/BB_Sprite_Sheet');
				}
			
				animation.addByPrefix('danceLeft', 'BB idle dance', 8, false);
				animation.addByPrefix('danceRight', 'BB idle dance', 8, false);
				animation.addByPrefix('singUP', 'BB Sing Note UP', 9, false);
				animation.addByPrefix('singRIGHT', 'BB Sing Note RIGHT', 9, false);
				animation.addByPrefix('singDOWN', 'BB Sing Note DOWN', 9, false);
				animation.addByPrefix('singLEFT', 'BB Sing Note LEFT', 9, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				if (isPlayer)
				{
					addOffset("singUP", -5, 20);
					addOffset("singRIGHT", 0, 30);
					addOffset("singLEFT", 0, 30);
					addOffset("singDOWN", -13, 25);
				}
				else
				{
					addOffset("singUP", 15, 20);
					addOffset("singRIGHT", 10, 30);
					addOffset("singLEFT", 10, 30);
					addOffset("singDOWN", 25, 25);
				}
				
				playAnim('danceLeft');

			case 'bb-tired-blue':
				switch (curCharacter)
				{
					case 'bb-tired-blue':
						frames = Paths.getSparrowAtlas('characters/blue/bbTired');
				}
			
				animation.addByPrefix('idle', 'BB idle dance', 24, false);
				animation.addByPrefix('singUP', 'BB Sing Note UP', 8, false);
				animation.addByPrefix('singRIGHT', 'BB Sing Note RIGHT', 8, false);
				animation.addByPrefix('singDOWN', 'BB Sing Note DOWN', 8, false);
				animation.addByPrefix('singLEFT', 'BB Sing Note LEFT', 8, false);

				addOffset('idle');

				if (isPlayer)
				{
					addOffset("singUP", -5, 20);
					addOffset("singRIGHT", 0, 30);
					addOffset("singLEFT", 0, 30);
					addOffset("singDOWN", -13, 25);
				}
				else
				{
					addOffset("singUP", 15, 20);
					addOffset("singRIGHT", 10, 30);
					addOffset("singLEFT", 10, 30);
					addOffset("singDOWN", 25, 25);
				}
				
				playAnim('idle');

			case 'annie-bw':
				tex = Paths.getSparrowAtlas('characters/bw/annie');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);

				addOffset('idle');

				if (isPlayer)
				{
					addOffset("singUP", 20, 20);
					addOffset("singLEFT", 80, -15);
					addOffset("singRIGHT", -45, 0);
					addOffset("singDOWN", 95, -90);
				}
				else
				{
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -68, -7);
					addOffset("singLEFT", 65, 9);
					addOffset("singDOWN", 200, -70);
				}

				playAnim('idle');

				flipX = true;
			
			case 'phil':
				frames = Paths.getSparrowAtlas('characters/phil_assets');
				iconColor = 'FF264A3C';
				animation.addByPrefix('idle', "Phil Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'Phil Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'Phil Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Phil Sing Note RIGHT', 24, false);
				animation.addByPrefix('singRIGHT', 'Phil Sing Note LEFT', 24, false);

				addOffset('idle');
				
				if (isPlayer)
				{		
					addOffset("singUP", -10, -2);
					addOffset("singLEFT", 19, -18);
					addOffset("singRIGHT", -30, -15);
					addOffset("singDOWN", 20, -38);
				}
				else
				{
					addOffset("singUP", 30, -2);
					addOffset("singRIGHT", 9, -18);
					addOffset("singLEFT", -20, -15);
					addOffset("singDOWN", 10, -38);
				}

				playAnim('idle');

				flipX = true;

			case 'crazygf' | 'crazygf-bw':
				if (curCharacter == 'crazygf-bw'){pre = 'bw/';}
				frames = Paths.getSparrowAtlas('characters/'+pre+'crazyGF');
				iconColor = 'FF9A1652';
				animation.addByPrefix('idle', "gf Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'gf Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'gf Down Note0', 24, false);
				animation.addByPrefix('singRIGHT', 'gf Note Right0', 24, false);
				animation.addByPrefix('singLEFT', 'gf NOTE LEFT0', 24, false);

				addOffset('idle');

				if (isPlayer)
				{
					addOffset("singUP", -20, 0);
					addOffset("singLEFT", 45, 0);
					addOffset("singRIGHT", 25, 0);
					addOffset("singDOWN", 20, 0);
				}
				else
				{
					addOffset("singUP", 30, 0);
					addOffset("singLEFT", 85, 0);
					addOffset("singRIGHT", 45, 10);
					addOffset("singDOWN", -30, 0);
				}

				playAnim('idle');

				flipX = true;

			case 'nene' | 'nene-bw':
				switch (curCharacter)
				{
					case 'nene':
						tex = Paths.getSparrowAtlas('characters/Nene_FNF_assetss');
						iconColor = 'FFFF6690';
					case 'nene-bw':
						tex = Paths.getSparrowAtlas('characters/bw/Nene_FNF_assetss');
				}
				
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);

				addOffset('idle');

				if (isPlayer)
				{
					addOffset("singUP", 20, 20);
					addOffset("singLEFT", 80, -15);
					addOffset("singRIGHT", -45, 0);
					addOffset("singDOWN", 95, -90);
				}
				else
				{
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -68, -7);
					addOffset("singLEFT", 65, 9);
					addOffset("singDOWN", 200, -70);
				}

				playAnim('idle');

				flipX = true;

			case 'nene2':
				frames = Paths.getSparrowAtlas('characters/Nene_FNF_assets');
				iconColor = 'FFFF6690';
				noteSkin = 'shootin';
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'PICO NOTE LEFT0', 24, false);

				loadOffsetFile(curCharacter);

			case 'nyancat':
				frames = Paths.getSparrowAtlas('characters/cat_assets');
				iconColor = 'FF989898';
				
				animation.addByPrefix('idle', "Cat_idle", 24, false);
				animation.addByPrefix('singUP', 'Cat_Up', 24, false);
				animation.addByPrefix('singDOWN', 'Cat_Down', 24, false);
				animation.addByPrefix('singLEFT', 'Cat_Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Cat_Right', 24, false);

				loadOffsetFile(curCharacter);

			case 'botan' | 'botan-b3':
				noteSkin = 'holofunk';
				switch(curCharacter)
				{
					case 'botan':
						frames = Paths.getSparrowAtlas('characters/botan');
						iconColor = 'FF7DA8C5';
					case 'botan-b3':
						frames = Paths.getSparrowAtlas('characters/b3/botan');
						iconColor = 'FFF3EAE8';
				}
					
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24, false);

				loadOffsetFile('botan');
				
				playAnim('idle');

				flipX = true;

			case 'botan-corrupt':
				switch(curCharacter)
				{
					case 'botan-corrupt':
						frames = Paths.getSparrowAtlas('characters/corruption/botan');
						iconColor = 'FFE22D7A';
				}
					
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", 0, 20);
					addOffset("singLEFT", 93, -13);
					addOffset("singRIGHT", -38, -12);
					addOffset("singDOWN", 95, -110);
					addOffset("singUPmiss", 9, 20);
					addOffset("singLEFTmiss", 88, -9);
					addOffset("singRIGHTmiss", -46, 9);
					addOffset("singDOWNmiss", 98, -81);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", -40, 20);
					addOffset("singRIGHT", -105, -13);
					addOffset("singLEFT", 12, -12);
					addOffset("singDOWN", 175, -110);
					addOffset("singUPmiss", -41, 20);
					addOffset("singRIGHTmiss", -92, 9);
					addOffset("singLEFTmiss", 14, 9);
					addOffset("singDOWNmiss", 172, -81);
				}

				playAnim('idle');

				flipX = true;

			case 'bf-annie' | 'bf-exgf':
				switch (curCharacter)
				{
					case 'bf-annie':
						tex = Paths.getSparrowAtlas('characters/annie');
						iconColor = 'FF1D2A2C';
					case 'bf-exgf':
						tex = Paths.getSparrowAtlas('characters/playableexGF');
						iconColor = 'FF64FFC1';
				}
				
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -10, 50);
				addOffset("singUP", -10, 50);
				addOffset("singRIGHT", -10, 50);
				addOffset("singLEFT", -10, 50);
				addOffset("singDOWN", -10, 50);
				addOffset("singUPmiss", -10, 50);
				addOffset("singRIGHTmiss", -10, 50);
				addOffset("singLEFTmiss", -10, 50);
				addOffset("singDOWNmiss", -10, 50);

				playAnim('idle');

				flipX = true;

			case 'sky-annoyed':
				frames = Paths.getSparrowAtlas('characters/sky_annoyed_assets');
				iconColor = 'FF9C6ECC';

				animation.addByIndices('danceLeft', 'sky annoyed idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'sky annoyed idle', [8, 10, 12, 14], "", 12, false);
				animation.addByIndices('danceLeft-alt', 'sky annoyed alt idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight-alt', 'sky annoyed alt idle', [8, 10, 12, 14], "", 12, false);

				animation.addByPrefix('singUP', 'sky annoyed up', 24, false);
				animation.addByPrefix('singDOWN', 'sky annoyed down', 24, false);
				animation.addByPrefix('singLEFT', 'sky annoyed left', 24, false);
				animation.addByPrefix('singRIGHT', 'sky annoyed right', 24, false);

				animation.addByPrefix('singUP-alt', 'sky annoyed alt up', 24, false);
				animation.addByPrefix('singDOWN-alt', 'sky annoyed alt down', 24, false);
				animation.addByPrefix('singLEFT-alt', 'sky annoyed alt left', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'sky annoyed alt right', 24, false);

				animation.addByPrefix('grr-special', 'sky annoyed grr', 24, false);
				animation.addByPrefix('huh-special', 'sky annoyed huh', 24, false);
				animation.addByPrefix('derp-special', 'sky derp', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'sky-happy':
				frames = Paths.getSparrowAtlas('characters/sky_happy_assets');
				iconColor = 'FF9C6ECC';

				animation.addByIndices('danceLeft', 'sky idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'sky idle', [8, 10, 12, 14], "", 12, false);

				animation.addByPrefix('singUP', 'sky up', 24, false);
				animation.addByPrefix('singDOWN', 'sky down', 24, false);
				animation.addByPrefix('singLEFT', 'sky left', 24, false);
				animation.addByPrefix('singRIGHT', 'sky right', 24, false);

				addOffset('danceLeft');
				addOffset('danceRight');
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0,  0);
				
				if (isPlayer)
				{
					addOffset("singUP", 46, 10);
					addOffset("singDOWN", -5, -35);
				}
				else
				{
					addOffset("singUP", -54, 10);
					addOffset("singDOWN", 5, -35);
				}
				
				playAnim('danceRight');

			case 'flexy':
				frames = Paths.getSparrowAtlas('characters/flexy_assets');
				iconColor = 'FFFFFFFF';
				animation.addByPrefix('idle', 'flexy idle', 24, false);
				animation.addByPrefix('singUP', 'flexy up note', 24, false);
				animation.addByPrefix('singDOWN', 'flexy down note', 24, false);
				animation.addByPrefix('singLEFT', 'flexy left note', 24, false);
				animation.addByPrefix('singRIGHT', 'flexy right note', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'arch':
				frames = Paths.getSparrowAtlas('characters/arch');
				iconColor = 'FF666666';

				animation.addByPrefix('idle', 'arch0000', 24, false);
				animation.addByPrefix('singUP', 'arch0002', 24, false);
				animation.addByPrefix('singDOWN', 'arch0004', 24, false);
				animation.addByPrefix('singLEFT', 'arch0003', 24, false);
				animation.addByPrefix('singRIGHT', 'arch0001', 24, false);

				loadOffsetFile('no');

				playAnim('idle');

			case 'bf-sky':
				frames = Paths.getSparrowAtlas('characters/sky_assets');
				iconColor = 'FF9C6ECC';
				animation.addByPrefix('singUP', 'sky annoyed up', 24, false);
				animation.addByPrefix('singDOWN', 'sky annoyed down', 24, false);
				animation.addByPrefix('singUP-alt', 'sky annoyed alt up', 24, false);
				animation.addByPrefix('singDOWN-alt', 'sky annoyed alt down', 24, false);
				animation.addByPrefix('singUPmiss', 'sky annoyed alt up', 24, false);
				animation.addByPrefix('singDOWNmiss', 'sky annoyed alt down', 24, false);
				animation.addByIndices('danceLeft', 'sky annoyed idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'sky annoyed idle', [8, 10, 12, 14], "", 12, false);
				animation.addByIndices('danceLeft-alt', 'sky annoyed alt idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight-alt', 'sky annoyed alt idle', [8, 10, 12, 14], "", 12, false);
				animation.addByPrefix('singLEFT', 'sky annoyed left', 24, false);
				animation.addByPrefix('singRIGHT', 'sky annoyed right', 24, false);
				animation.addByPrefix('singLEFTmiss', 'sky annoyed alt left', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'sky annoyed alt right', 24, false);
				animation.addByPrefix('singLEFT-alt', 'sky annoyed alt left', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'sky annoyed alt right', 24, false);	
				
				loadOffsetFile(curCharacter);

				playAnim('danceRight');

				flipX = true;

			case 'tankman' | 'tankman-mad' | 'tankman-sad-blue' | 'tankman-bw':
				switch (curCharacter)
				{
					case 'tankman':
						frames = Paths.getSparrowAtlas('characters/tankmanCaptain');
					case 'tankman-mad':
						frames = Paths.getSparrowAtlas('characters/tankman_mad');
					case 'tankman-sad-blue':
						frames = Paths.getSparrowAtlas('characters/blue/tankmanSad');
					case 'tankman-bw':
						frames = Paths.getSparrowAtlas('characters/bw/tankmanCaptain');
				}
				iconColor = 'FF2C2D41';
					
				animation.addByPrefix('idle', "Tankman Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'Tankman UP note', 24, false);
				animation.addByPrefix('singDOWN', 'Tankman DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'Tankman Right Note', 24, false);
				animation.addByPrefix('singRIGHT', 'Tankman Note Left', 24, false);
				animation.addByPrefix('singUP-alt', 'TANKMAN UGH', 24, false);
				animation.addByPrefix('singDOWN-alt', 'PRETTY GOOD', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Lil Dude', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'TANKMAN UGH', 24, false);

				loadOffsetFile('tankman');

				playAnim('idle');

				flipX = true;

			case 'twinstwo':
				//they are so angyyyy
				frames = Paths.getSparrowAtlas('characters/GhostTwinsAngry');
				iconColor = 'FFFFFFFF';

				setGraphicSize(Std.int(width * 0.83));
		
				animation.addByPrefix('idle', 'AngyTwinIdle', 24);
				animation.addByPrefix('singUP', 'AngyTwinUp', 24);
				animation.addByPrefix('singRIGHT', 'AngyTwinRight', 24);
				animation.addByPrefix('singDOWN', 'AngyTwinDown', 24);
				animation.addByPrefix('singLEFT', 'AngyTwinLeft', 24);

				addOffset('idle');
				addOffset("singUP", -6, 65);
				addOffset("singRIGHT", -55, 30);
				addOffset("singLEFT", 38, 50);
				addOffset("singDOWN", 70, 46);

				playAnim('idle');

			case 'cc':
				frames = Paths.getSparrowAtlas('characters/cc');
				iconColor = 'FFE3E3E3';

				animation.addByPrefix('idle', 'Idle', 24);
				animation.addByPrefix('singUP', 'Sing Up', 24, false);
				animation.addByPrefix('singDOWN', 'Sing Down', 24, false);
				animation.addByPrefix('singLEFT', 'Sing Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'bf' | 'bf-bw' | 'bf-kaity' | 'bf-sonic' | 'bf-blue' | 'bf-pump' | 'bf-sonic-bw' | 'bf-ex-night' | 'bf-ghost' | 'bf-b3' | 'bf-frisk' | 'bf-gf' | 'bf-gf-demon'
			| 'bf-kitty' | 'bf-nene' | 'bf-sticky' | 'bf-nene-scream' | 'bf-sans-new' | 'bf-bw2' | 'bfHalloween' | 'bf-sonic-flipped' | 'bf-spongebob' | 'bf-jabibi' | 'bf-six'
			| 'bf-shirogane' | 'bf-cryingchild' | 'bf-frisk-bw':
				switch (curCharacter)
				{				
					case 'bf-bw' | 'bf-bw2':
						if (curCharacter == 'bf-bw2') pre = '_2';
						frames = Paths.getSparrowAtlas('characters/bw/BOYFRIEND'+pre);
					case 'bf':
						frames = Paths.getSparrowAtlas('characters/BOYFRIEND');
						iconColor = 'FF0EAEFE';
						switch (PlayState.curStage)
						{
							case 'day' | 'sunset' | 'night':
								noteSkin = 'bf-b&b';
							default:
								if (PlayState.changeArrows)
									noteSkin = PlayState.bfNoteStyle;
								else
									noteSkin = PlayState.SONG.noteStyle;
						}
					case 'bf-blue':
						frames = Paths.getSparrowAtlas('characters/blue/BOYFRIEND');
					case 'bf-kaity':
						frames = Paths.getSparrowAtlas('characters/KAITY');
						iconColor = 'FF0EAEFE';
					case 'bf-sonic' | 'bf-sonic-flipped':
						frames = Paths.getSparrowAtlas('characters/SONIC');
						iconColor = 'FF0028B2';
					case 'bf-sonic-bw':
						frames = Paths.getSparrowAtlas('characters/bw/SONIC');
					case 'bf-pump':
						frames = Paths.getSparrowAtlas('characters/PUMP');
						iconColor = 'FFD57E00';
					case 'bf-ex-night':
						frames = Paths.getSparrowAtlas('characters/BoyFriend_Assets_EX_night', 'shared');
						noteSkin = 'bf-b&b';
						iconColor = 'FF0EAEFE';
					case 'bf-ghost':
						frames = Paths.getSparrowAtlas('characters/bfghost');
						noteSkin = 'normal';
						iconColor = 'FF0EAEFE';
					case 'bf-b3':
						frames = Paths.getSparrowAtlas('characters/b3/BOYFRIEND');
						iconColor = 'FF66FF33';
					case 'bf-frisk' | 'bf-frisk-bw':
						if (curCharacter == 'bf-frisk-bw') pre = 'bw/';
						frames = Paths.getSparrowAtlas('characters/'+pre+'frisk');
						iconColor = 'FF5691D8';
					case 'bf-gf':
						frames = Paths.getSparrowAtlas('characters/playableGF');
						iconColor = 'FF9A1652';
					case 'bf-gf-demon':
						frames = Paths.getSparrowAtlas('characters/playableGFdemon');
						iconColor = 'FFAF66CE';
					case 'bf-kitty':
						frames = Paths.getSparrowAtlas('characters/KITTY_KEAREST');
						iconColor = 'FFA30016';
					case 'bf-nene' | 'bf-nene-scream':
						if (curCharacter == 'bf-nene-scream') pre = "_Scream";
						frames = Paths.getSparrowAtlas('characters/Nene_Assets' + pre);
						iconColor = 'FFFFF29E';
						noteSkin = 'holofunk';
					case 'bf-sticky':
						frames = Paths.getSparrowAtlas('characters/STICKY');
						iconColor = 'FFFFF29E';
					case 'bf-sans-new':
						frames = Paths.getSparrowAtlas('characters/sans2');
						iconColor = 'FF7484E5';
					case 'bfHalloween':
						frames = Paths.getSparrowAtlas('characters/BOYFRIEND_halloween');
						iconColor = 'FF0EAEFE';
					case 'bf-spongebob':
						frames = Paths.getSparrowAtlas('characters/SPONGEBOB');
						iconColor = 'FFE9D752';
					case 'bf-jabibi':
						frames = Paths.getSparrowAtlas('characters/jabibi');
						iconColor = 'FFFF77F4';
					case 'bf-six':
						frames = Paths.getSparrowAtlas('characters/sixsheet','shared');
						iconColor = 'FF549B95';
					case 'bf-shirogane':
						frames = Paths.getSparrowAtlas('characters/SHIROGANE','shared');
						iconColor = 'FFDBB07F';
					case 'bf-cryingchild':
						frames = Paths.getSparrowAtlas('characters/CRYINGCHILD');
						iconColor = 'FF';
				}

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				if (curCharacter != 'bf-sticky')
					animation.addByPrefix('singUP-alt', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				if (curCharacter.contains('-flipped'))
				{
					animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);	
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS', 24, false);
				}
				else
				{
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);	
					animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				}
			
				if (curCharacter == 'bf-nene-scream')
					animation.addByPrefix('scream', 'BF SCREAM', 24);

				if (curCharacter == 'bf-sticky')
				{
					animation.addByPrefix('singUP-alt', 'boyfriend dodge', 24, false);
					animation.addByPrefix('singLEFT-alt', 'boyfriend dodge', 24, false);
					animation.addByPrefix('singDOWN-alt', 'boyfriend dodge', 24, false);
					animation.addByPrefix('singRIGHT-alt', 'boyfriend dodge', 24, false);
				}

				var loadSelfOffsets:Array<String> = ['bf-b3', 'bf-nene', 'bf-nene-scream', 'bf-sonic', 'bf-sticky', 'bf-sans-new', 'bfHalloween', 'bf-sonic-flipped', 'bf-six'];

				if (loadSelfOffsets.contains(curCharacter)) 
					loadOffsetFile(curCharacter);
				else
					loadOffsetFile('bf');
				
				playAnim('idle');

				flipX = true;

			case 'bf-bbpanzu':
				frames = Paths.getSparrowAtlas('characters/bb');
				iconColor = 'FF009933';
				
				animation.addByPrefix('idle', 'bb idle', 24, false);
				animation.addByPrefix('singUP', 'bb up0', 24, false);
				animation.addByPrefix('singDOWN', 'bb down0', 24, false);
				animation.addByPrefix('singLEFT', 'bb left0', 24, false);
				animation.addByPrefix('singRIGHT', 'bb right0', 24, false);

				loadOffsetFile('no');

				playAnim('idle');

				flipX = true;

			case 'bf-cesar' | 'bf-cesar-scream':
				if (curCharacter == 'bf-cesar-scream')pre = "_scream";
				frames = Paths.getSparrowAtlas('characters/cesar'+pre);
				iconColor = 'FFC353E3';

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('transition', 'BF Transition', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				if (curCharacter == 'bf-cesar-scream')
				{
					animation.addByPrefix('singUP-alt', 'BF hit0', 24, false);
					animation.addByPrefix('singLEFT-alt', 'BF hit0', 24, false);
					animation.addByPrefix('singRIGHT-alt', 'BF hit0', 24, false);
					animation.addByPrefix('singDOWN-alt', 'BF hit0', 24, false);
				}

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'bf-demoncesar' | 'bf-demoncesar-bw' | 'bf-demoncesar-trollge' | 'bf-demoncesar-cas':
				switch (curCharacter)
				{
					case 'bf-demoncesar':
						frames = Paths.getSparrowAtlas('characters/demonCesar');
						iconColor = 'FFE353C8';
					case 'bf-demoncesar-bw':
						frames = Paths.getSparrowAtlas('characters/bw/demonCesar');
						iconColor = 'FFE1E1E1';
					case 'bf-demoncesar-trollge':
						frames = Paths.getSparrowAtlas('characters/demonCesar_trollge');
						iconColor = 'FFB76FA9';
					case 'bf-demoncesar-cas':
						frames = Paths.getSparrowAtlas('characters/casDEMON');
						iconColor = 'FFE353C8';						
				}
				
				if (curCharacter.contains('cas'))
					noteSkin = 'fever';
				else
				{
					switch (PlayState.curStage)
					{
						case 'takiStage':
							noteSkin = 'taki';
						case 'ripdiner':
							noteSkin = 'party-crasher';
						default:
							if (PlayState.changeArrows)
								noteSkin = PlayState.bfNoteStyle;
							else
								noteSkin = PlayState.SONG.noteStyle;
					}
				}	

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('transition', 'BF Transition', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -61, 13);
				addOffset("singRIGHT", -75, -10);
				addOffset("singLEFT", -15, -3);
				addOffset("singDOWN", -39, -84);
				addOffset("singUPmiss", -64, 6);
				addOffset("singRIGHTmiss", -74, -19);
				addOffset("singLEFTmiss", -16, -4);
				addOffset("singDOWNmiss", -36, -84);
				addOffset("hey", -54, 1);
				addOffset("transition", -54, 1);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -54, -12);

				playAnim('idle');

				flipX = true;

			case 'bf-updike':
				frames = Paths.getSparrowAtlas('characters/bf_assets_updike');
				iconColor = 'FF0EAEFE';

				animation.addByPrefix('idle', 'BF idle dance0', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS0', 24, false);
				
				animation.addByPrefix('idle-alt', 'BF idle dance edgy', 24, false);
				animation.addByPrefix('singUP-alt', 'BF NOTE UP edgy0', 24, false);
				animation.addByPrefix('singLEFT-alt', 'BF NOTE LEFT edgy0', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'BF NOTE RIGHT edgy0', 24, false);
				animation.addByPrefix('singDOWN-alt', 'BF NOTE DOWN edgy0', 24, false);
				animation.addByPrefix('singUPmiss-alt', 'BF NOTE UP MISS edgy', 24, false);
				animation.addByPrefix('singLEFTmiss-alt', 'BF NOTE LEFT MISS edgy', 24, false);
				animation.addByPrefix('singRIGHTmiss-alt', 'BF NOTE RIGHT MISS edgy', 24, false);
				animation.addByPrefix('singDOWNmiss-alt', 'BF NOTE DOWN MISS edgy', 24, false);

				loadOffsetFile(curCharacter);
				
				playAnim('idle');

				flipX = true;

			case 'bf-fnf-switch':
				var tex = Paths.getSparrowAtlas('characters/fnf-switch');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);	
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
		
				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'bf-aloe' | 'bf-aloe-bw' | 'bf-aloe-corrupt' | 'bf-aloe-b3' | 'bf-aloe-past':
				noteSkin = 'holofunk';
				switch (curCharacter)
				{
					case 'bf-aloe':
						frames = Paths.getSparrowAtlas('characters/ALOE');
						iconColor = 'FFEF71B1';
					case 'bf-aloe-bw':
						frames = Paths.getSparrowAtlas('characters/bw/ALOE');
					case 'bf-aloe-corrupt':
						frames = Paths.getSparrowAtlas('characters/corruption/ALOE');
						iconColor = 'FFE22D7A';
						noteSkin = 'corrupted';
					case 'bf-aloe-b3':
						frames = Paths.getSparrowAtlas('characters/b3/ALOE');
						iconColor = 'FF72EF71';
					case 'bf-aloe-past':
						frames = Paths.getSparrowAtlas('characters/corruption/ALOE_PAST');
						iconColor = 'FF9E9E9E';
						noteSkin = '1930';
				}

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('lol-special', 'Smug', 24, false);
				animation.addByPrefix('frick-special', 'bruh', 24, false);
				animation.addByPrefix('dab-special', 'Dab', 24, false);
				animation.addByPrefix('hit-special', 'BF hit', 24, false);

				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);	
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				loadOffsetFile('bf-aloe');

				playAnim('idle');

				flipX = true;

			case 'bf-aloe-confused':
				frames = Paths.getSparrowAtlas('characters/ALOE_Confused');
				iconColor = 'FFEF71B1';
		
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);	
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle');
				addOffset("singUP", -25, 29);
				addOffset("singRIGHT", -27, -1);
				addOffset("singLEFT", -12, -9);
				addOffset("singDOWN", 34, -49);
				addOffset("singUPmiss", -7, 33);
				addOffset("singRIGHTmiss", -12, 22);
				addOffset("singLEFTmiss", -13, -2);
				addOffset("singDOWNmiss", 24, -19);
				addOffset("hey", -10, -2);
				addOffset('scared', 16, 1);

				playAnim('idle');

				flipX = true;

			case 'bf-aloe-car':
				frames = Paths.getSparrowAtlas('characters/aloeCar');
				iconColor = 'FFEF71B1';

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);	
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);

				addOffset('idle', 0, 0);
				addOffset("singUP", -3, 24);
				addOffset("singRIGHT", -12, -1);
				addOffset("singLEFT", -2, -11);
				addOffset("singDOWN", 30, -49);
				addOffset("singUPmiss", 0, 25);
				addOffset("singRIGHTmiss", -12, 12);
				addOffset("singLEFTmiss", -4, -2);
				addOffset("singDOWNmiss", 27, -32);
				playAnim('idle');

				flipX = true;

			case 'bf1' | 'bf2' | 'bf3' | 'bf4' | 'bf5':
				switch (curCharacter)
				{
					case 'bf1':
						frames = Paths.getSparrowAtlas('characters/bf1');
					case 'bf2':
						frames = Paths.getSparrowAtlas('characters/bf2');
					case 'bf3':
						frames = Paths.getSparrowAtlas('characters/bf3');
					case 'bf4':
						frames = Paths.getSparrowAtlas('characters/bf4');
					case 'bf5':
						frames = Paths.getSparrowAtlas('characters/bf5');
				}
				
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				switch (curCharacter)
				{
					case 'bf1' | 'bf5':
						loadOffsetFile(curCharacter);
					case 'bf2' | 'bf3' | 'bf4':
						loadOffsetFile('bf2');
				}
				
				playAnim('idle');

				flipX = true;

			case 'bf-lexi' | 'bf-lexi-b3':
				switch (curCharacter)
				{
					case 'bf-lexi':
						frames = Paths.getSparrowAtlas('characters/Lexi');
						iconColor = 'FFFE94EB';
					case 'bf-lexi-b3':
						frames = Paths.getSparrowAtlas('characters/b3/lexi');
						iconColor = 'FFFE94EB';
				}
				
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
		
				loadOffsetFile(curCharacter);
					
				playAnim('idle');

				flipX = true;

			case 'bf-sans':
				frames = Paths.getSparrowAtlas('characters/sans');
				iconColor = 'FF7484E5';
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset('scared', -4);

				if (!isPlayer)
				{
					addOffset("singUP", 1, 27);
					addOffset("singRIGHT", 0, 1);
					addOffset("singLEFT", 37, -6);
					addOffset("singDOWN", -18, -42);
					addOffset("singUPmiss", 1, 27);
					addOffset("singRIGHTmiss", -18, -42);
					addOffset("singLEFTmiss", 40, 24);
					addOffset("singDOWNmiss", -11, -19);
					addOffset("hey", -2, 5);
					addOffset('firstDeath', 37, 11);
					addOffset('deathLoop', 37, 5);
					addOffset('deathConfirm', 37, 69);
				}
				else
				{
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -38, -7);
					addOffset("singLEFT", 12, -6);
					addOffset("singDOWN", -10, -50);
					addOffset("singUPmiss", -29, 27);
					addOffset("singRIGHTmiss", -30, 21);
					addOffset("singLEFTmiss", 12, 24);
					addOffset("singDOWNmiss", -11, -19);
					addOffset("hey", 7, 4);
					addOffset('firstDeath', 37, 11);
					addOffset('deathLoop', 37, 5);
					addOffset('deathConfirm', 37, 69);				
				}
				
				playAnim('idle');

				flipX = true;

			case 'bf-blantad':
				switch (curCharacter)
				{
					case 'bf-blantad':
						frames = Paths.getSparrowAtlas('characters/blantad');
						iconColor = 'FF64B3FE';
				}
			
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);

				loadOffsetFile('no');

				playAnim('idle');

				flipX = true;

			case 'bf-christmas' | 'bf-sarv':
				switch (curCharacter)
				{
					case 'bf-christmas':
						frames = Paths.getSparrowAtlas('characters/bfChristmas');
					case 'bf-sarv':
						frames = Paths.getSparrowAtlas('characters/bfSarv');
						iconColor = 'FFF691C5';
				}
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('singUP-alt', 'BF HEY', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("singUP-alt", 7, 4);
				addOffset("hey", 7, 4);

				playAnim('idle');

				flipX = true;

			case 'bf-tc':
				frames = Paths.getSparrowAtlas('characters/hdtc');
				iconColor = 'FF112550';

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				
				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'bf-car' | 'bf-kaity-car' | 'bf-smol-ruv':
				iconColor = 'FF0EAEFE';
				switch (curCharacter)
				{
					case 'bf-car':
						frames = Paths.getSparrowAtlas('characters/bfCar');
						if (PlayState.changeArrows)
							noteSkin = PlayState.bfNoteStyle;
						else
							noteSkin = PlayState.SONG.noteStyle;
					case 'bf-kaity-car':
						frames = Paths.getSparrowAtlas('characters/kaityCar');
					case 'bf-smol-ruv':
						frames = Paths.getSparrowAtlas('characters/smol_ruv');
						iconColor = 'FF978AA6';
				}
				
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);		
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);	

				addOffset('idle', -5);
				
				if (!isPlayer)
				{
					addOffset("singUP", 1, 27);
					addOffset("singRIGHT", -39, -2);
					addOffset("singLEFT", 33, -3);
					addOffset("singDOWN", -20, -55);
					addOffset("singUPmiss", -9, 27);
					addOffset("singRIGHTmiss", -30, 21);
					addOffset("singLEFTmiss", 33, 24);
					addOffset("singDOWNmiss", -21, -19);
				}
				else
				{
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -38, -7);
					addOffset("singLEFT", 12, -6);
					addOffset("singDOWN", -10, -50);
					addOffset("singUPmiss", -29, 27);
					addOffset("singRIGHTmiss", -30, 21);
					addOffset("singLEFTmiss", 12, 24);
					addOffset("singDOWNmiss", -11, -19);
				}	

				playAnim('idle');

				flipX = true;

			case 'bf-pixel' | 'bf-pixel-neon' | 'bf-senpai-pixel-angry' | 'bf-senpai-pixel' | 'bf-wright-pixel' | 'bf-pico-pixel' | 'bf-rico-pixel' | 'bf-sonic-pixel' 
			| 'bf-tom-pixel' | 'bf-sans-pixel' | 'bf-kapi-pixel':
				switch (curCharacter)
				{
					case 'bf-pixel':
						frames = Paths.getSparrowAtlas('characters/bfPixel');
						iconColor = 'FF0EAEFE';
					case 'bf-kapi-pixel':
						frames = Paths.getSparrowAtlas('characters/bf-kapiPixel');
						iconColor = 'FF3483E3';
					case 'bf-pixel-neon':
						frames = Paths.getSparrowAtlas('characters/bfPixelNeon');
						iconColor = 'FF4674EE';
						noteSkin = 'neon';
					case 'bf-senpai-pixel-angry':
						frames = Paths.getSparrowAtlas('characters/bfSenpaiPixelangry');
						iconColor = 'FFFFAA6F';
						noteSkin = 'pixel';
					case 'bf-senpai-pixel':
						frames = Paths.getSparrowAtlas('characters/bfSenpaiPixel');
						iconColor = 'FFFFAA6F';
					case 'bf-wright-pixel':
						frames = Paths.getSparrowAtlas('characters/bf-wrightPixel');
						iconColor = 'FF2D415C';
					case 'bf-pico-pixel':
						frames = Paths.getSparrowAtlas('characters/bf-picoPixel');
						iconColor = 'FFB7D855';
					case 'bf-rico-pixel':
						frames = Paths.getSparrowAtlas('characters/bf-ricoPixel');
						iconColor = 'FF7B59E5';
					case 'bf-sonic-pixel':
						frames = Paths.getSparrowAtlas('characters/bf-sonicPixel');
						iconColor = 'FF7BD6F6';
					case 'bf-tom-pixel':
						frames = Paths.getSparrowAtlas('characters/bf-tomPixel');
						iconColor = 'FF265D86';
					case 'bf-sans-pixel':
						frames = Paths.getSparrowAtlas('characters/bf-sansPixel');
						iconColor = 'FF7484E5';
				}
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;

			case 'bob' | 'angrybob':
				switch (curCharacter)
				{
					case 'bob':
						frames = Paths.getSparrowAtlas('characters/bob_asset');
					case 'angrybob':
						frames = Paths.getSparrowAtlas('characters/angrybob_asset');
				}
				iconColor = 'FFFFFFFF';
				noteSkin = 'gloopy';

				animation.addByPrefix('idle', "bob_idle", 24, false);
				animation.addByPrefix('singUP', 'bob_UP', 24, false);
				animation.addByPrefix('singDOWN', 'bob_DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'bob_RIGHT', 24, false);
				animation.addByPrefix('singRIGHT', 'bob_LEFT', 24, false);

				addOffset('idle');

				playAnim('idle');

				flipX = true;

			case 'glitched-bob':
				tex = Paths.getSparrowAtlas('characters/ScaryBobAaaaah');
				frames = tex;
				animation.addByPrefix('idle', "idle???-", 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				addOffset('idle');

			case 'lord-x':
				frames = Paths.getSparrowAtlas('characters/SONIC_X');
				iconColor = 'FF7877B0';

				animation.addByPrefix('idle', 'X_Idle', 24, false);
				animation.addByPrefix('singUP', 'X_Up', 24, false);
				animation.addByPrefix('singDOWN', 'X_Down', 24, false);
				animation.addByPrefix('singLEFT', 'X_Left', 24, false);
				animation.addByPrefix('singRIGHT', 'X_Right', 24, false);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * 1.2));
				updateHitbox();

				playAnim('idle');

			case 'maijin-new' | 'maijin-new-flipped':
				frames = Paths.getSparrowAtlas('characters/SonicFunAssets');
				iconColor = 'FF0000D7';
				noteSkin = 'maijin';

				animation.addByPrefix('idle', 'SONICFUNIDLE', 24);
				animation.addByPrefix('singUP', 'SONICFUNUP', 24);
				animation.addByPrefix('singDOWN', 'SONICFUNDOWN', 24);
			
				if (curCharacter.contains('-flipped'))
				{
					animation.addByPrefix('singRIGHT', 'SONICFUNLEFT', 24);
					animation.addByPrefix('singLEFT', 'SONICFUNRIGHT', 24);
				}
				else
				{
					animation.addByPrefix('singRIGHT', 'SONICFUNRIGHT', 24);
					animation.addByPrefix('singLEFT', 'SONICFUNLEFT', 24);
				}

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'beast-sonic' | 'beast-sonic-flipped':
				frames = Paths.getSparrowAtlas('characters/Beast');
				iconColor = 'FF2A0576';
				animation.addByPrefix('idle', 'Beast_IDLE', 24, false);
				animation.addByPrefix('singUP', 'Beast_UP', 24, false);
				animation.addByPrefix('singDOWN', 'Beast_DOWN', 24, false);
				animation.addByPrefix('laugh', 'Beast_LAUGH', 24, false);

				if (curCharacter.contains('-flipped')) // the anims weren't flipped properly in the og triple trouble
				{
					animation.addByPrefix('singLEFT', 'Beast_RIGHT', 24, false);
					animation.addByPrefix('singRIGHT', 'Beast_LEFT', 24, false);
				}
				else
				{
					animation.addByPrefix('singLEFT', 'Beast_LEFT', 24, false);
					animation.addByPrefix('singRIGHT', 'Beast_RIGHT', 24, false);
				}

				loadOffsetFile(curCharacter);

				antialiasing = true;

				playAnim('idle');

			case 'lane':
				frames = Paths.getSparrowAtlas('characters/Lane_assets');
				iconColor = "FF1F7EFF";
				animation.addByPrefix('idle', "lane idle", 24, false);
				animation.addByPrefix('singUP', 'lane singup', 24, false);
				animation.addByPrefix('singDOWN', 'lane singdown', 24, false);
				animation.addByPrefix('singLEFT', 'lane singleft', 24, false);
				animation.addByPrefix('singRIGHT', 'lane singright', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset('singUP', -20, 20);
					addOffset('singDOWN', 20, -20);
					addOffset('singRIGHT', -40, 20);
					addOffset('singLEFT', 25, -35);
				}
				else
				{
					addOffset('idle');
					addOffset('singUP', 10, 20);
					addOffset('singDOWN', 30, -20);
					addOffset('singLEFT', 120, 20);
					addOffset('singRIGHT', -75, -35);
				}

				playAnim('idle');

			case 'lane-pixel':
				frames = Paths.getSparrowAtlas('characters/Lane_Pixel_assets');
				iconColor = "FF1F7EFF";
				animation.addByPrefix('idle', 'Lane Pixel Idle', 24, false);
				animation.addByPrefix('singUP', 'Lane Pixel Up', 24, false);
				animation.addByPrefix('singDOWN', 'Lane Pixel Down', 24, false);
				animation.addByPrefix('singLEFT', 'Lane Pixel Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Lane Pixel Right', 24, false);

				addOffset('idle');
				addOffset("singUP", 10, 20);
				addOffset("singRIGHT", -50, -34);
				addOffset("singLEFT", 110, 10);
				addOffset("singDOWN", 30, -15);

				setGraphicSize(Std.int(width * 5));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'monika-finale':
				frames = Paths.getSparrowAtlas('characters/Monika_Finale');
				iconColor = 'FFFFB8E3';
				animation.addByPrefix('idle', 'MONIKA IDLE', 24, false);
				animation.addByPrefix('singUP', 'MONIKA UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'MONIKA LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'MONIKA RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'MONIKA DOWN NOTE', 24, false);

				animation.addByPrefix('singUP-alt', 'MONIKA UP GLITCH', 24, false);
				animation.addByPrefix('singLEFT-alt', 'MONIKA LEFT GLITCH', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'MONIKA RIGHT GLITCH', 24, false);
				animation.addByPrefix('singDOWN-alt', 'MONIKA DOWN GLITCH', 24, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				addOffset("singUP-alt", 60, -6);
				addOffset("singRIGHT-alt", 60, -6);
				addOffset("singLEFT-alt", 60, -6);
				addOffset("singDOWN-alt", 60, -6);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'gura-amelia-pixel':
				frames = Paths.getSparrowAtlas('characters/gura_amelia_pixel');
				iconColor = 'FFFFA054';
				animation.addByPrefix('singUP', 'Spooky Pixel Up', 24, false);
				animation.addByPrefix('singDOWN', 'Spooky Pixel Down', 24, false);
				animation.addByPrefix('singLEFT', 'Spooky Pixel Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Spooky Pixel Right', 24, false);
				animation.addByIndices('danceLeft', 'Spooky Pixel Idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'Spooky Pixel Idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				if (isPlayer)
				{
					addOffset("singUP", -50, 40);
					addOffset("singLEFT", 50, -4);
					addOffset("singRIGHT", -10, 0);
					addOffset("singDOWN", -40, -130);
				}
				else
				{
					addOffset("singUP", -20, 40);
					addOffset("singRIGHT", -110, -4);
					addOffset("singLEFT", 130, 0);
					addOffset("singDOWN", 40, -130);
				}

				setGraphicSize(Std.int(width * 5));
				updateHitbox();

				playAnim('danceRight');

				antialiasing = false;

			case 'bf-botan-pixel':
				frames = Paths.getSparrowAtlas('characters/bf-botanPixel');
				iconColor = 'FF7DA8C5';
				animation.addByPrefix('idle', 'Pico Pixel Idle', 24, false);
				animation.addByPrefix('singUP', 'Pico Pixel Up0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Pixel Down0', 24, false);
				animation.addByPrefix('singUPmiss', 'Pico Pixel Up Miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Pico Pixel Down Miss', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Pixel Left0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico Pixel Right0', 24, false);			
				animation.addByPrefix('singLEFTmiss', 'Pico Pixel Left Miss', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico Pixel Right Miss', 24, false);
				
				addOffset('idle');
				addOffset("singUP", 0, 20);	
				addOffset("singUPmiss", 0, 20);
			
				if (!isPlayer)
				{
					addOffset("singDOWN", -55, -110);
					addOffset("singDOWNmiss", -55 , -80);
					addOffset("singLEFT", 25, -15);
					addOffset("singRIGHT", -55, -15);
					addOffset("singLEFTmiss", 25, 5);
					addOffset("singRIGHTmiss", -60, -15);
				}
				else
				{
					addOffset("singDOWN", 55, -110);
					addOffset("singDOWNmiss", 55 , -80);
					addOffset("singRIGHT", -25, -15);
					addOffset("singLEFT", 55, -15);
					addOffset("singRIGHTmiss", -25, 5);
					addOffset("singLEFTmiss", 60, -15);
				}

				setGraphicSize(Std.int(width * 4.5));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

				flipX = true;

			case 'bf-whitty-pixel':
				frames = Paths.getSparrowAtlas('characters/whitty-pixel');
				iconColor = 'FF1D1E35';
				animation.addByPrefix('idle', 'Whitty Pixel Idle', 24, false);
				animation.addByPrefix('singUP', 'Whitty Pixel Up0', 24, false);
				animation.addByPrefix('singDOWN', 'Whitty Pixel Down0', 24, false);
				animation.addByPrefix('singLEFT', 'Whitty Pixel Left0', 24, false);
				animation.addByPrefix('singRIGHT', 'Whitty Pixel Right0', 24, false);

				addOffset('idle');
				addOffset("singUP", 0, 45);

				if (!isPlayer)
				{
					addOffset("singRIGHT", 0, 40);
					addOffset("singLEFT", 25, -10);
					addOffset("singDOWN", -25, -45);
				}

				else
				{
					addOffset("singLEFT", 0, 40);
					addOffset("singRIGHT", -25, -10);
					addOffset("singDOWN", 25, -45);
				}

				setGraphicSize(Std.int(width * 4.5));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

				flipX = true;

			case 'bf-gf-pixel':
				frames = Paths.getSparrowAtlas('characters/bf-gfPixel');
				iconColor = 'FF9A1652';
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");
				if (!isPlayer)
				{
					addOffset("singRIGHT", -30, 0);
					addOffset("singLEFT", 30, 0);
				}
				else
				{
					addOffset("singRIGHT", -30, 0);
					addOffset("singLEFT", 30, 0);
				}

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;

			case 'bf-tankman-pixel':
				frames = Paths.getSparrowAtlas('characters/bf-tankmanPixel');
				iconColor = 'FF2C2D41';
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('idle-alt', 'BF ALT IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUP-alt', 'BF UGH', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle-alt');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;

			case 'bf-pixeld4' | 'bf-pixeld4BSide':
				var normShit:String = "";
				var altShit:String = "";

				switch (curCharacter)
				{
					case 'bf-pixeld4':
						frames = Paths.getSparrowAtlas('characters/bfPixeld4');
						normShit = "";
						altShit = " ALT";
						
					case 'bf-pixeld4BSide':
						frames = Paths.getSparrowAtlas('characters/bfPixeld4');
						normShit = " ALT";
						altShit = "";
				}
				
				animation.addByPrefix('idle', 'BF'+normShit+' IDLE', 24, false);
				animation.addByPrefix('idle-alt', 'BF'+altShit+' IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF'+normShit+' UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF'+normShit+' LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF'+normShit+' RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF'+normShit+' DOWN NOTE', 24, false);		
				animation.addByPrefix('singUP-alt', 'BF'+altShit+' UP NOTE', 24, false);
				animation.addByPrefix('singLEFT-alt', 'BF'+altShit+' LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'BF'+altShit+' RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN-alt', 'BF'+altShit+' DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				loadOffsetFile('no');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;

			case 'rosie' | 'rosie-angry' | 'rosie-furious':
				switch (curCharacter)
				{
					case 'rosie':
						frames = Paths.getSparrowAtlas('characters/rosie_assets');
						pre = '';
					case 'rosie-angry':
						frames = Paths.getSparrowAtlas('characters/rosie_angry_assets');
						pre = 'angry ';
					case 'rosie-furious':
						frames = Paths.getSparrowAtlas('characters/rosie_furious_assets');
						pre = 'furious ';
				}
				iconColor = 'FFF65C7E';
				animation.addByPrefix('idle', pre+'rosanna idle', 24, false);
				animation.addByPrefix('singUP', pre+'rosanna up', 24, false);
				animation.addByPrefix('singRIGHT', pre+'rosanna right', 24, false);
				animation.addByPrefix('singDOWN', pre+'rosanna down', 24, false);
				animation.addByPrefix('singLEFT', pre+'rosanna left', 24, false);
				switch (curCharacter)
				{
					case 'rosie':
						animation.addByPrefix('ara', 'rosanna ara ara', 24);
						addOffset("ara", -19, 0);
					case 'rosie-angry':
						animation.addByPrefix('fuck this', "rosanna lost it", 24, false);
						addOffset('fuck this', 1295, 87);
					case 'rosie-furious':
						animation.addByPrefix('shoot', 'furious rosanna down', 24, false);
						addOffset("shoot", -29, -126);
				}

				addOffset('idle');
				switch (curCharacter)
				{
					case 'rosie' | 'rosie-angry':
						loadOffsetFile('rosie');
					case 'rosie-furious':
						addOffset("singUP", 97, 26);
						addOffset("singRIGHT", 54, 1);
						addOffset("singLEFT", 158, 45);
						addOffset("singDOWN", 229, -126);
				}	
				playAnim('idle');			

			case 'bf-pixel-dead' | 'bf-tankman-pixel-dead' | 'bf-pico-pixel-dead' | 'bf-rico-pixel-dead' | 'bf-sans-pixel-dead' | 'bf-gf-pixel-dead' | 'bf-sonic-pixel-dead' 
			| 'bf-tom-pixel-dead' | 'bf-wright-pixel-dead':
				switch (curCharacter)
				{
					case 'bf-pixel-dead':
						frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');
					case 'bf-tankman-pixel-dead':
						frames = Paths.getSparrowAtlas('characters/bf-tankmanPixelDEAD');	
					case 'bf-pico-pixel-dead':
						frames = Paths.getSparrowAtlas('characters/bf-picoPixelsDEAD');
					case 'bf-rico-pixel-dead':
						frames = Paths.getSparrowAtlas('characters/bf-ricoPixelsDEAD');
					case 'bf-sans-pixel-dead':
						frames = Paths.getSparrowAtlas('characters/bf-sansPixelsDEAD');
					case 'bf-gf-pixel-dead':
						frames = Paths.getSparrowAtlas('characters/bf-gfPixelsDEAD');
					case 'bf-sonic-pixel-dead':
						frames = Paths.getSparrowAtlas('characters/bf-sonicPixelsDEAD');
					case 'bf-tom-pixel-dead':
						frames = Paths.getSparrowAtlas('characters/bf-tomPixelsDEAD');
					case 'bf-wright-pixel-dead':
						frames = Paths.getSparrowAtlas('characters/bf-wrightPixelsDEAD');
				}
				
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'bf-senpai-tankman-dead' | 'bf-senpai-pixel-dead':
				switch (curCharacter)
				{
					case 'bf-senpai-tankman-dead':
						frames = Paths.getSparrowAtlas('characters/bf-senpai-tankman-dead');
					case 'bf-senpai-pixel-dead':
						frames = Paths.getSparrowAtlas('characters/bf-senpai-pixel-dead');
				}
				
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "senpai retry", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);

				addOffset('firstDeath', -50, 150);
				addOffset('deathLoop', -50, 150);
				addOffset('deathConfirm', -50, 150);
	
				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				flipX = true;
	
				playAnim('idle');
	
				antialiasing = false;

			case 'senpai' | 'neon' | 'miku-pixel' | 'monster-pixel' | 'monika' | 'colt' | 'neon-bigger' | 'glitch':
				frames = Paths.getSparrowAtlas('characters/senpai');
				switch (curCharacter)
				{
					case 'senpai':
						frames = Paths.getSparrowAtlas('characters/senpai');
						iconColor = 'FFFFAA6F';
					case 'glitch':
						frames = Paths.getSparrowAtlas('characters/glitch');
						iconColor = 'FF0DA554';
					case 'neon' | 'neon-bigger':
						frames = Paths.getSparrowAtlas('characters/neon');
						iconColor = "FF06D22A";
						noteSkin = 'neon';
					case 'miku-pixel':
						frames = Paths.getSparrowAtlas('characters/bitmiku');
						iconColor = 'FF32CDCC';
					case 'monster-pixel':
						frames = Paths.getSparrowAtlas('characters/monsterPixel');
						iconColor = 'FFF3FF6E';
					case 'monika':
						frames = Paths.getSparrowAtlas('characters/monika');
						iconColor = 'FFFFB8E3';
					case 'colt':
						frames = Paths.getSparrowAtlas('characters/colt');
						iconColor = 'FF584190';
				}
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				if (curCharacter.contains('neon'))
				{
					loadOffsetFile(curCharacter);
				}
				else
				{
					loadOffsetFile('senpai');
				}
				
				playAnim('idle');

				if (curCharacter == 'neon')
					setGraphicSize(Std.int(width * 5));
				else
					setGraphicSize(Std.int(width * 6));
				
				updateHitbox();

				antialiasing = false;

			case 'senpai-z':
				frames = Paths.getSparrowAtlas('characters/Senpai_Z_Axis');
				iconColor = 'FFFFAA6F';
				noteSkin = 'pixel';
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				antialiasing = false;

			case 'monika-angry':
				frames = Paths.getSparrowAtlas('characters/monika');
				iconColor = 'FFFFB8E3';
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);
				animation.addByPrefix('idle-alt', 'Green Senpai Idle', 24, false);
				animation.addByPrefix('singUP-alt', 'Green Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Green Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Green Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Green Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset('idle-alt');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);
				addOffset("singUP-alt", 5, 37);
				addOffset("singRIGHT-alt");
				addOffset("singLEFT-alt", 40);
				addOffset("singDOWN-alt", 14);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'green-monika':
				frames = Paths.getSparrowAtlas('characters/monika');
				iconColor = 'FFFFB8E3';
				animation.addByPrefix('idle', 'Green Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Green Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Green Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Green Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Green Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'duet-sm':
				frames = Paths.getSparrowAtlas('characters/Duet_Assets_SM');
				animation.addByPrefix('idle', 'Duet Idle', 24, false);
				animation.addByPrefix('singUP', 'Duet Monika UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Duet Monika LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Duet Monika RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Duet Monika DOWN NOTE', 24, false);

				animation.addByPrefix('singUP-alt', 'Duet Senpai UP NOTE', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Duet Senpai DOWN NOTE', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Duet Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Duet Senpai RIGHT NOTE', 24, false);

				animation.addByPrefix('cutsceneidle', 'cutscene idle0', 24, false);
				animation.addByPrefix('cutsceneidle2', 'cutscene idle2', 24, false);
				animation.addByPrefix('cutscenetransition', 'cutscene transition0', 24, false);
				animation.addByPrefix('cutscenetransition2', 'cutscene transition2', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'bf-senpai-tankman':
				frames = Paths.getSparrowAtlas('characters/Duet_Assets_ST');
				animation.addByPrefix('idle', 'Duet Idle', 24, false);
				animation.addByPrefix('singUP', 'Duet Senpai Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Duet Senpai Left0', 24, false);
				animation.addByPrefix('singRIGHT', 'Duet Senpai Right0', 24, false);
				animation.addByPrefix('singDOWN', 'Duet Senpai Down0', 24, false);
				animation.addByPrefix('singUPmiss', 'Duet Senpai Up Miss0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Duet Senpai Left Miss0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Duet Senpai Right Miss0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Duet Senpai Down Miss0', 24, false);

				animation.addByPrefix('singUP-alt', 'Duet Tankman Up0', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Duet Tankman Down0', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Duet Tankman Left0', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Duet Tankman Right0', 24, false);
				animation.addByPrefix('singUPmiss-alt', 'Duet Tankman Up Miss0', 24, false);
				animation.addByPrefix('singDOWNmiss-alt', 'Duet Tankman Down Miss0', 24, false);
				animation.addByPrefix('singLEFTmiss-alt', 'Duet Tankman Left Miss0', 24, false);
				animation.addByPrefix('singRIGHTmiss-alt', 'Duet Tankman Right Miss0', 24, false);

				animation.addByPrefix('cutsceneidle2', 'cutscene idle2', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

				flipX = true;

			case 'senpai-angry'| 'glitch-angry' | 'kristoph-angry' | 'chara-pixel' | 'jackson' | 'mario-angry' | 'matt-angry' | 'mangle-angry' | 'baldi-angry-pixel' | 'colt-angry' 
			| 'colt-angryd2' | 'senpai-giddy' | 'blantad-pixel':
				switch (curCharacter)
				{
					case 'kristoph-angry':
						frames = Paths.getSparrowAtlas('characters/kristoph');
						iconColor = 'FF9284AD';
					case 'glitch-angry':
						frames = Paths.getSparrowAtlas('characters/glitch');
						iconColor = 'FF0DA554';
					case 'chara-pixel':
						frames = Paths.getSparrowAtlas('characters/chara_pixel');
						iconColor = 'FFFF0000';
					case 'jackson':
						frames = Paths.getSparrowAtlas('characters/jackson');
						iconColor = 'FFC05D68';
					case 'mario-angry':
						frames = Paths.getSparrowAtlas('characters/mario');
						iconColor = 'FFCC0000';
					case 'matt-angry':
						frames = Paths.getSparrowAtlas('characters/matt');
						iconColor = 'FFA55BA0';
					case 'senpai-angry':
						frames = Paths.getSparrowAtlas('characters/senpai');
						iconColor = 'FFFFAA6F';
					case 'mangle-angry':
						frames = Paths.getSparrowAtlas('characters/mangle');
						iconColor = 'FFDA47AD';
					case 'baldi-angry-pixel':
						frames = Paths.getSparrowAtlas('characters/baldi_pixel');
						iconColor = 'FF18E416';
					case 'colt-angry':
						frames = Paths.getSparrowAtlas('characters/colt');
						iconColor = 'FF584190';
					case 'colt-angryd2':
						frames = Paths.getSparrowAtlas('characters/coltd2');
						iconColor = 'FF584190';
					case 'senpai-giddy':
						frames = Paths.getSparrowAtlas('characters/senpaigiddy');
						iconColor = 'FFFFAA6F';
					case 'blantad-pixel':
						frames = Paths.getSparrowAtlas('characters/blantad-pixel');
						iconColor = 'FF64B3FE';
				}
				
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'colt-angryd2corrupted':
				frames = Paths.getSparrowAtlas('characters/coltd2');
				iconColor = 'FF584190';
				animation.addByPrefix('idle', 'Corrupt Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Corrupt Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Corrupt Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Corrupt Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Corrupt Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'bitdadcrazy':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/BitDadCrazy');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);
				playAnim('idle');	

				setGraphicSize(Std.int(width * 0.85));
				updateHitbox();

				antialiasing = false;	
				
			case 'bitdad' | 'bitdadBSide':
				switch (curCharacter)
				{
					case 'bitdad':
						tex = Paths.getSparrowAtlas('characters/BitDad');
					case 'bitdadBSide':
						tex = Paths.getSparrowAtlas('characters/BitDadBSide');
				}
				
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('switch', 'Dad version switch', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				addOffset('idle');
				addOffset('switch');
				addOffset("singUP", 1, 58);
				addOffset("singRIGHT", -4, 38);
				addOffset("singLEFT", 42, 19);
				addOffset("singDOWN", -1, -20);
				playAnim('idle');	

				setGraphicSize(Std.int(width * 1));
				updateHitbox();

				antialiasing = false;	

			case 'matt-ew-pixel':
				frames = Paths.getSparrowAtlas('characters/matt');
				iconColor = 'FFA55BA0';
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'opheebop':
				tex = Paths.getSparrowAtlas('characters/Opheebop_Assets');
				frames = tex;
				iconColor = 'FF000000';
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -60, 50);
					addOffset("singLEFT", -51);
					addOffset("singRIGHT", -30);
					addOffset("singDOWN", -30, -40);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", -20, 50);
					addOffset("singRIGHT", -51);
					addOffset("singLEFT", -30);
					addOffset("singDOWN", -30, -40);
				}
				
				playAnim('idle');

			case 'bf-confused':
				var tex = Paths.getSparrowAtlas('characters/bf_confused');
				frames = tex;
				iconColor = 'FF51d8fb';
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				playAnim('idle');

				flipX = true;

			case 'spirit' | 'spirit-glitchy':
				switch (curCharacter)
				{
					case 'spirit':
						frames = Paths.getPackerAtlas('characters/spirit');
						noteSkin = 'pixel';
					case 'spirit-glitchy':
						frames = Paths.getPackerAtlas('characters/spiritglitchy');
				}
				iconColor = 'FFFF3C6E';
				
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				addOffset('idle', -220, -280);
				addOffset('singUP', -220, -240);
				addOffset("singRIGHT", -220, -280);
				addOffset("singLEFT", -200, -280);
				addOffset("singDOWN", 170, 110);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'parents-christmas' | 'parents-christmas-angel' | 'parents-christmas-soft' | 'bico-christmas' | 'skye' | 'skye-r':
				switch (curCharacter)
				{
					case 'parents-christmas':
						frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets');
					case 'parents-christmas-angel':
						frames = Paths.getSparrowAtlas('characters/parents_xmas_angel');
					case 'parents-christmas-soft':
						frames = Paths.getSparrowAtlas('characters/parents_xmas_soft');
					case 'bico-christmas':
						frames = Paths.getSparrowAtlas('characters/cursed_xmas');
					case 'skye' | 'skye-r':
						if (curCharacter == 'skye-r')pre = '_r';
						frames = Paths.getSparrowAtlas('characters/skye' + pre);
						iconColor = 'FFFF0000';
				}
				
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('idle-alt', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				if (curCharacter == 'skye-r')
					loadOffsetFile('skye')
				else
					loadOffsetFile(curCharacter);
	
				playAnim('idle');

			case 'neko-crazy':
                frames = Paths.getSparrowAtlas('characters/nf2');
				iconColor = 'FFFFD779';
                
                animation.addByPrefix('idle', 'nfc_idle', 24, false);
                animation.addByPrefix('singUP', 'nfc_up', 24, false);
				animation.addByPrefix('singDOWN', 'nfc_down', 24, false);
				animation.addByPrefix('singLEFT', 'nfc_left', 24, false);
				animation.addByPrefix('singRIGHT', 'nfc_right', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'nfc_freeze', 24, false);
                
               loadOffsetFile(curCharacter);
                
                playAnim('idle');

			case 'demoncass':
				tex = Paths.getSparrowAtlas('characters/demoncass');
				iconColor = 'FF000000';
				frames = tex;
	
				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);
	
				addOffset('idle');
				addOffset("singUP", 0, 35);
				addOffset("singRIGHT", 6, -60);
				addOffset("singLEFT", 77, 0);
				addOffset("singDOWN", 187, -107);

				playAnim('idle');

			case 'impostor' | 'impostor2':
				switch (curCharacter)
				{
					case 'impostor':
						frames = Paths.getSparrowAtlas('characters/impostor');
					case 'impostor2':
						frames = Paths.getSparrowAtlas('characters/impostor2');
				}	
				iconColor = 'FFFF3333';
				noteSkin = PlayState.SONG.noteStyle;
				animation.addByPrefix('idle', 'impostor idle', 24, false);
				animation.addByPrefix('singUP', 'impostor up', 24, false);
				animation.addByPrefix('singRIGHT', 'impostor right', 24, false);
				animation.addByPrefix('singDOWN', 'impostor down', 24, false);
				animation.addByPrefix('singLEFT', 'impostor left', 24, false);
				animation.addByPrefix('kill', 'impostor kill', 24, false);

				addOffset('idle');

				switch (curCharacter)
				{
					case 'impostor':
						if (isPlayer)
						{
							addOffset("singUP", -129, 16);
							addOffset("singLEFT", -70, -20);
							addOffset("singRIGHT", -180, 3);
							addOffset("singDOWN", -91, -62);
							addOffset('kill', -10, 140);
						}
						else
						{
							addOffset("singUP", -79, 16);
							addOffset("singRIGHT", -100, -20);
							addOffset("singLEFT", 140, 3);
							addOffset("singDOWN", -51, -62);
							addOffset('kill', -30, 140);
						}
					case 'impostor2':
						addOffset("singUP", -25, 54);
						addOffset("singRIGHT", -36, 13);
						addOffset("singLEFT", 113, -6);
						addOffset("singDOWN", -28, -17);
				}
				
				playAnim('idle');

			case 'henry-angry':
				frames = Paths.getSparrowAtlas('characters/henry_angry');
				iconColor = 'FFE1E1E1';
				animation.addByPrefix('singUP', 'spooky UP note', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);
				animation.addByPrefix('singUPmiss', 'spooky UPNOTE MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'note singleft MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'spooky singright MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'spooky DOWNnote MISS', 24, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				if (isPlayer)
				{
					addOffset("singUP", 15, 45);
					addOffset("singLEFT", 100, -15);
					addOffset("singRIGHT", 80, 10);
					addOffset("singDOWN", 120, -70);
				}

				else
				{
					addOffset("singUP", 5, 45);
					addOffset("singRIGHT", 70, -15);
					addOffset("singLEFT", 80, 10);
					addOffset("singDOWN", 30, -70);
				}
				
				playAnim('danceRight');

			case 'updike':
				tex = Paths.getSparrowAtlas('characters/updike_assets');
				frames = tex;
				iconColor = 'FFE1E1E1';
	
				animation.addByPrefix('idle', "updingdong idle0", 24, false);
				animation.addByPrefix('singUP', "updingdong up note0", 24, false);
				animation.addByPrefix('singDOWN', "updingdong down note0", 24, false);
				animation.addByPrefix('singLEFT', 'updingdong left note0', 24, false);
				animation.addByPrefix('singRIGHT', 'updingdong right note0', 24, false);

				animation.addByPrefix('idle-alt', 'updingdong idle edgy', 24, false);
				animation.addByPrefix('singUP-alt', 'updingdong up note edgy', 24, false);
				animation.addByPrefix('singDOWN-alt', 'updingdong down note edgy', 24, false);
				animation.addByPrefix('singLEFT-alt', 'updingdong left note edgy', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'updingdong right note edgy', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'ruby-worried' | 'ruby-worried-night' | 'ruby-worried-blue' | 'ruby':
				switch (curCharacter)
				{
					case 'ruby-worried':
						frames = Paths.getSparrowAtlas('characters/ruby_worried_assets');
						iconColor = 'FFFF00FF';
					case 'ruby-worried-blue':
						frames = Paths.getSparrowAtlas('characters/blue/ruby_worried_assets');
					case 'ruby-worried-night':
						frames = Paths.getSparrowAtlas('characters/ruby_assets_worried_night');
						iconColor = 'FFFF00FF';
					case 'ruby':
						frames = Paths.getSparrowAtlas('characters/ruby_assets');
						iconColor = 'FFFF00FF';
				}
				
				animation.addByPrefix('idle', 'ruby idle dance', 24, true);
				animation.addByPrefix('singUP', 'ruby Sing Note UP0', 24, false);
				animation.addByPrefix('singLEFT', 'ruby Sing Note LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'ruby Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'ruby Sing Note DOWN0', 24, false);

				if (curCharacter == 'ruby')
				{
					animation.addByPrefix('hey', 'ruby hey0', 24, false);
					if (isPlayer) {
						addOffset("hey", 24, 19);
					}
					else {
						addOffset("hey", -17, 19);
					}
					
				}
				
				loadOffsetFile('ruby');
				
				playAnim('idle');	

			case 'cj':
				frames = Paths.getSparrowAtlas('characters/cj_assets');
				iconColor = 'FF0244EF';

				animation.addByPrefix('idle', 'cj idle dance', 24, false);
				animation.addByPrefix('singUP', 'cj Sing Note UP0', 24, false);
				animation.addByPrefix('singLEFT', 'cj Sing Note LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'cj Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'cj Sing Note DOWN0', 24, false);
				animation.addByPrefix('singUP-alt', 'cj singleha0', 24, false);
				animation.addByPrefix('haha', 'cj doubleha0', 24, false);
				animation.addByPrefix('intro', 'cj intro0', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'cj-ruby':
				frames = Paths.getSparrowAtlas('characters/Duet_Assets_CR');
				iconColor = 'FF8D1FF7';
				animation.addByPrefix('idle', 'duet idle dance', 24, true);
				animation.addByPrefix('singUP', 'duet CJ Sing Note UP', 24, false);
				animation.addByPrefix('singLEFT', 'duet CJ Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'duet CJ Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'duet CJ Sing Note DOWN', 24, false);

				animation.addByPrefix('idle-alt', 'duet idle dance', 24, true);
				animation.addByPrefix('singUP-alt', 'duet Ruby Sing Note UP', 24, false);
				animation.addByPrefix('singLEFT-alt', 'duet Ruby Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'duet Ruby Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN-alt', 'duet Ruby Sing Note DOWN', 24, false);

				animation.addByPrefix('2', 'duet 2', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -6, 42);
					addOffset("singRIGHT", 18, 0);
					addOffset("singLEFT", 153, 18);
					addOffset("singDOWN", 17, -39);
					addOffset('2', 28, -62);

					addOffset('idle-alt');
					addOffset("singUP-alt", -6, 42);
					addOffset("singRIGHT-alt", 18, 0);
					addOffset("singLEFT-alt", 153, 18);
					addOffset("singDOWN-alt", 17, -39);
				}

				else
				{
					addOffset('idle');
					addOffset("singUP", -16, 42);
					addOffset("singRIGHT", 53, 18);
					addOffset("singLEFT", 8, 0);
					addOffset("singDOWN", 17, -39);
					addOffset('2', 8, -62);

					addOffset('idle-alt');
					addOffset("singUP-alt", -16, 42);
					addOffset("singRIGHT-alt", 53, 18);
					addOffset("singLEFT-alt", 8, 0);
					addOffset("singDOWN-alt", 17, -39);
				}	
				
				playAnim('idle');

			case 'cj-ruby-both':
				frames = Paths.getSparrowAtlas('characters/Duet_Assets_CR_Both');
				iconColor = 'FF8D1FF7';
				animation.addByPrefix('idle', 'duet idle dance', 24, true);
				animation.addByPrefix('singUP', 'duet Sing Note UP', 24, false);
				animation.addByPrefix('singLEFT', 'duet Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'duet Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'duet Sing Note DOWN', 24, false);

				loadOffsetFile(curCharacter);
				
				playAnim('idle');

			case 'sarv-ruv':
				frames = Paths.getSparrowAtlas('characters/Duet_Assets_SR');
				iconColor = 'FFE5BCD1';
				animation.addByPrefix('idle', 'Duet Idle', 24, false);
				animation.addByPrefix('singUP', 'Ruv Duet Up', 24, false);
				animation.addByPrefix('singLEFT', 'Ruv Duet Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Ruv Duet Right', 24, false);
				animation.addByPrefix('singDOWN', 'Ruv Duet Down', 24, false);

				animation.addByPrefix('idle-alt', 'Duet Idle', 24, true);
				animation.addByPrefix('singUP-alt', 'Sarv Duet Up', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Sarv Duet Left', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Sarv Duet Right', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Sarv Duet Down', 24, false);

				animation.addByPrefix('3', 'Sarv 3', 24, false);

				addOffset('idle');
				addOffset('idle-alt');

				if (isPlayer)
				{					
					addOffset("singUP", 5, 60);
					addOffset("singLEFT", 85, 10);
					addOffset("singRIGHT", -10, -20);
					addOffset("singDOWN", 115, -65);
					addOffset('3', 13, 0);
					
					addOffset("singUP-alt", 5, 60);
					addOffset("singLEFT-alt", 85, 10);
					addOffset("singRIGHT-alt", -10, -20);
					addOffset("singDOWN-alt", 115, -65);
				}

				else
				{
					addOffset("singUP", 5, 60);
					addOffset("singRIGHT", 25, 10);
					addOffset("singLEFT", 60, -20);
					addOffset("singDOWN", 25, -65);
					addOffset('3', 33, 0);

					addOffset("singUP-alt", 5, 60);
					addOffset("singRIGHT-alt", 25, 10);
					addOffset("singLEFT-alt", 60, -20);
					addOffset("singDOWN-alt", 25, -65);
				}	
				
				playAnim('idle');

			case 'sarv-ruv-both':
				frames = Paths.getSparrowAtlas('characters/Duet_Assets_SR_Both');
				iconColor = 'FFE5BCD1';
				animation.addByPrefix('idle', 'Duet Idle', 24, false);
				animation.addByPrefix('idle-alt', 'Duet Idle', 24, true);
				animation.addByPrefix('singUP', 'Duet Up', 24, false);
				animation.addByPrefix('singLEFT', 'Duet Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Duet Right', 24, false);
				animation.addByPrefix('singDOWN', 'Duet Down', 24, false);

				addOffset('idle');
				addOffset('idle-alt');

				if (isPlayer)
				{
					addOffset("singUP", 5, 60);
					addOffset("singLEFT", 85, 10);
					addOffset("singRIGHT", -10, -20);
					addOffset("singDOWN", 115, -65);
				}

				else
				{
					addOffset("singUP", 5, 60);
					addOffset("singRIGHT", 25, 10);
					addOffset("singLEFT", 60, -20);
					addOffset("singDOWN", 25, -65);
				}	
				
				playAnim('idle');

			case 'nonsense':
				frames = Paths.getSparrowAtlas('characters/Nonsense');
				iconColor = 'FF773D30';
				animation.addByPrefix('singUP', 'NoteUp', 24, false);
				animation.addByPrefix('singDOWN', 'NoteDown', 24, false);
				animation.addByPrefix('singLEFT', 'NoteLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'NoteRight', 24, false);
				animation.addByIndices('danceLeft', 'Idle', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "", 24, false);
				animation.addByIndices('danceRight', 'Idle', [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], "", 24, false);
				animation.addByPrefix('sweat', 'oh no', 24, false);
				animation.addByPrefix('bruh', 'Bruh', 24, false);
					
				addOffset('danceLeft');
				addOffset('danceRight');
				addOffset("singUP", 14, 17);
				addOffset("singRIGHT", 20, -10);
				addOffset("singLEFT", 7, -18);
				addOffset("singDOWN", -2, -52);
				addOffset("sweat", -8, -4);
				addOffset('bruh');

				playAnim('danceRight');

			case 'tordbot':
				tex = Paths.getSparrowAtlas('characters/tordbot_assets');
				frames = tex;

				animation.addByPrefix('idle', "tordbot idle", 24, false);
				animation.addByPrefix('singUP', "tordbot up", 24, false);
				animation.addByPrefix('singDOWN', "tordbot down", 24, false);
				animation.addByPrefix('singLEFT', 'tordbot left', 24, false);
				animation.addByPrefix('singRIGHT', 'tordbot right', 24, false);

				addOffset('idle');
				addOffset("singRIGHT",-20,-20);
				addOffset("singDOWN",-10,-90);
				addOffset("singLEFT",-90);
				addOffset("singUP",-30,29);

				playAnim('idle');

			case 'piconjo':
				frames = Paths.getSparrowAtlas('characters/Piconjo_Assets');
				iconColor = 'FF45177B';
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');
			
			case 'anchor-bowl':
				frames = Paths.getSparrowAtlas('characters/anchorBowlAssets');
				iconColor = 'FF4E589B';

				animation.addByPrefix('idle', "IdleAnchor", 24, false);
				animation.addByPrefix('singUP', "SingUp", 24, false);
				animation.addByPrefix('singDOWN', "SingDown", 24, false);
				animation.addByPrefix('singLEFT', 'SingLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'SingRight', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP");
					addOffset("singRIGHT");
					addOffset("singLEFT");
					addOffset("singDOWN");
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", -15, 156);
					addOffset("singLEFT", 50, 133);
					addOffset("singRIGHT", -26, 133);
					addOffset("singDOWN", -8, 153);
				}

				playAnim('idle');

				setGraphicSize(Std.int(width * 0.8));
				updateHitbox();

			case 'qt-kb':
				frames =  Paths.getSparrowAtlas('characters/qt-kb');
				noteSkin = PlayState.SONG.noteStyle;

				animation.addByPrefix('danceRight', "danceRightNormal", 26, false);
				animation.addByPrefix('danceLeft', "danceLeftNormal", 26, false);

				animation.addByPrefix('singUP', 'singUpQT', 24, false);
				animation.addByPrefix('singDOWN', 'singDownQT', 24, false);
				animation.addByPrefix('singLEFT', 'singLeftQT', 24, false);
				animation.addByPrefix('singRIGHT', 'singRightQT', 24, false);

				animation.addByPrefix('singUP-alt', 'singUpKB', 24, false);
				animation.addByPrefix('singDOWN-alt', 'singDownKB', 24, false);
				animation.addByPrefix('singLEFT-alt', 'singLeftKB', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'singRightKB', 24, false);

				addOffset('danceRight',120,-101);
				addOffset('danceLeft',160,-110);

				addOffset("singUP", 164, -68);
				addOffset("singDOWN", 99, -168);
				addOffset("singLEFT", 133, -75);
				addOffset("singRIGHT", 16, -135);

				addOffset("singUP-alt", 115, 38);
				addOffset("singDOWN-alt", 138, -194);
				addOffset("singLEFT-alt", 214, 23);
				addOffset("singRIGHT-alt", -158, -178);	

			case 'qt-kb-both':
				frames = Paths.getSparrowAtlas('characters/qt-kb-both');

				animation.addByPrefix('danceRight', "danceRightNormal", 26, false);
				animation.addByPrefix('danceLeft', "danceLeftNormal", 26, false);
				
				animation.addByPrefix('singUP', "singUpTogether", 24, false);
				animation.addByPrefix('singDOWN', "singDownTogether", 24, false);
				animation.addByPrefix('singLEFT', 'singLeftTogether', 24, false);
				animation.addByPrefix('singRIGHT', 'singRightTogether', 24, false);

				addOffset('danceRight',120,-101);
				addOffset('danceLeft',160,-110);

				addOffset("singUP", 151, 52);
				addOffset("singDOWN", 140, -196);
				addOffset("singLEFT", 213, 21);	
				addOffset("singRIGHT", -163, -172);	

			case 'kb':
				tex = Paths.getSparrowAtlas('characters/kb');
				frames = tex;
				iconColor = 'FFFF0000';
				noteSkin = PlayState.SONG.noteStyle;

				animation.addByPrefix('danceRight', "KB_DanceRight", 26, false);
				animation.addByPrefix('danceLeft', "KB_DanceLeft", 26, false);
				animation.addByPrefix('singUP', "KB_Up", 24, false);
				animation.addByPrefix('singDOWN', "KB_Down", 24, false);
				animation.addByPrefix('singLEFT', 'KB_Left', 24, false);
				animation.addByPrefix('singRIGHT', 'KB_Right', 24, false);

				loadOffsetFile(curCharacter);

			case 'exe' | 'exe-bw':
				switch (curCharacter)
				{
					case 'exe':
						frames = Paths.getSparrowAtlas('characters/ExeAssets');
						iconColor = 'FFFF0000';
					case 'exe-bw':
						frames = Paths.getSparrowAtlas('characters/bw/ExeAssets');
						iconColor = 'FF484848';
						noteSkin = '1930';
				}
				
				animation.addByPrefix('idle', 'SONICmoveIDLE', 24, false);
				animation.addByPrefix('singUP', 'SONICmoveUP', 24, false);
				animation.addByPrefix('singRIGHT', 'SONICmoveRIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'SONICmoveDOWN', 24, false);
				animation.addByPrefix('singLEFT', 'SONICmoveLEFT', 24, false);
				animation.addByPrefix('singDOWN-alt', 'SONIClaugh', 24, false);

				loadOffsetFile('exe');
	
				playAnim('idle');

			case 'maijin':
				frames = Paths.getSparrowAtlas('characters/MaijinAssets');
				iconColor = 'FF0000D7';
				noteSkin = 'maijin';

				animation.addByPrefix('idle', 'SONICFUNIDLE', 24, false);
				animation.addByPrefix('singUP', 'SONICFUNUP', 24, false);
				animation.addByPrefix('singRIGHT', 'SONICFUNRIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'SONICFUNDOWN', 24, false);
				animation.addByPrefix('singLEFT', 'SONICFUNLEFT', 24, false);
	
				addOffset('idle', -21, 189);

				if (isPlayer)
				{
					addOffset("singUP", -178, 126);
					addOffset("singLEFT", -10, 43);
					addOffset("singRIGHT", -147, -60);
					addOffset("singDOWN", -45, -67);		
				}	
				else
				{
					addOffset("singUP", 22, 126);
					addOffset("singRIGHT", -80, 43);
					addOffset("singLEFT", 393, -60);
					addOffset("singDOWN", 15, -67);		
				}		
	
				playAnim('idle');

			case 'exTricky':
				frames = Paths.getSparrowAtlas('characters/EXTRICKY');
				exSpikes = new FlxSprite(x - 350,y - 170);
				exSpikes.frames = Paths.getSparrowAtlas('characters/FloorSpikes');
				exSpikes.visible = false;
				exSpikes.animation.addByPrefix('spike','Floor Spikes', 24, false);

				animation.addByPrefix('idle', 'Idle', 24);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('Hank', 'Hank', 24, true);

				addOffset('idle');
				addOffset('Hank');
				addOffset("singUP", 0, 100);
				addOffset("singRIGHT", -209,-29);
				addOffset("singLEFT",127,20);
				addOffset("singDOWN",-100,-340);

				playAnim('idle');

			case 'amor' | 'amor-ex':
				switch (curCharacter)
				{
					case 'amor':
						frames = Paths.getSparrowAtlas('characters/amor_assets', 'shared');
						iconColor = "FFD73C92";
					case 'amor-ex':
						frames = Paths.getSparrowAtlas('characters/amorex', 'shared');
						iconColor = "FF9E2947";
				}		
				noteSkin = 'amor';

				animation.addByPrefix('idle', 'Amor idle dance', 24, false);
				animation.addByPrefix('singUP', 'Amor Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'Amor Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Amor Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'Amor Sing Note RIGHT', 24, false);
				animation.addByPrefix('drop', 'Amor drop', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'pc':
				iconColor = "FFd73c92";
				noteSkin = 'amor';
				frames = Paths.getSparrowAtlas('characters/pc', 'shared');
				animation.addByPrefix('idle', 'PC idle', 24, false);
				animation.addByPrefix('singUP', 'PC Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'PC Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'PC Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'PC Note RIGHT', 24, false);

				loadOffsetFile('no');

				playAnim('idle');

			case 'bluskys':
				iconColor = "FF4975ED";
				noteSkin = 'bluskys';
				frames = Paths.getSparrowAtlas('characters/Bluskys', 'shared');
				animation.addByPrefix('idle', 'Bluskys idle dance', 24, false);
				animation.addByPrefix('singUP', 'Bluskys Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'Bluskys Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Bluskys Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'Bluskys Sing Note RIGHT', 24, false);
				animation.addByPrefix('drop', 'Bluskys Letsgo', 24, false);

				loadOffsetFile('bluskys');

				playAnim('idle');

			case 'rushia':
				iconColor = "FF17FFB2";
				frames = Paths.getSparrowAtlas('characters/Russia', 'shared');
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT0', 24, false);

				animation.addByPrefix('idle-alt', 'calm idle', 24, false);
				animation.addByPrefix('singUP-alt', 'up scream', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'right scream', 24, false);
				animation.addByPrefix('singDOWN-alt', 'down scream', 24, false);
				animation.addByPrefix('singLEFT-alt', 'left scream', 24, false);

				setGraphicSize(Std.int(width * 0.85));
				updateHitbox(); 

				loadOffsetFile('rushia');

				playAnim('idle');

			case 'tails' | 'sonic' | 'sonic-forced' | 'sonic-mad':
				switch (curCharacter)
				{
					case 'tails':
						iconColor = 'FFFFAA6F';
						frames = Paths.getSparrowAtlas('characters/tails','shared');
					case 'sonic':
						iconColor = 'FF577DFF';
						frames = Paths.getSparrowAtlas('characters/sonic','shared');
					case 'sonic-forced':
						iconColor = 'FF577DFF';
						frames = Paths.getSparrowAtlas('characters/sonic_forced','shared');
					case 'sonic-mad':
						iconColor = 'FF577DFF';
						frames = Paths.getSparrowAtlas('characters/sonic_mad','shared');
				}
			
				animation.addByPrefix('idle', "idle", 24, false);
				animation.addByPrefix('singUP', "up", 24, false);
				animation.addByPrefix('singRIGHT', "right", 24, false);
				animation.addByPrefix('singLEFT', "left", 24, false);
				animation.addByPrefix('singDOWN', "down", 24, false);

				loadOffsetFile(curCharacter);
				playAnim('idle');

				switch (curCharacter)
				{
					case 'tails' | 'sonic-mad':
						setGraphicSize(Std.int(width * 0.65));
						updateHitbox();
					case 'sonic' | 'sonic-forced':
						setGraphicSize(Std.int(width * 0.7));
						updateHitbox();
				}

			case 'sakuroma':
				frames = Paths.getSparrowAtlas('characters/sakuroma','shared');

				animation.addByPrefix('idle', 'SakuIdle', 24, false);
				animation.addByPrefix('singUP', 'SakuUp', 24);
				animation.addByPrefix('singRIGHT', 'SakuRight', 24);
				animation.addByPrefix('singDOWN', 'SakuDown', 24);
				animation.addByPrefix('singLEFT', 'SakuLeft', 24);
				animation.addByPrefix('laugh', 'Saku Giggle', 24);

				addOffset("singDOWN", 0, -150);
				addOffset("laugh", 28, -95);

				playAnim('idle');

			case 'omega-angry':
				frames = Paths.getSparrowAtlas("characters/mad_omega","shared");
				iconColor = 'FFFFFFFF';
				animation.addByPrefix('idle', 'omega boss idle', 24, false);
				animation.addByPrefix('singUP', 'omega boss UP', 24, false);
				animation.addByPrefix('singDOWN', 'OMEGA FUCKING DOWN ', 24, false);
				animation.addByPrefix('singLEFT', 'OMEGA LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'OMEGA RIGHT', 24, false);

				loadOffsetFile(curCharacter);
				playAnim("idle");

			case 'exe-front':
				frames = Paths.getSparrowAtlas('characters/P2Sonic_Assets');
				iconColor = 'FF010065';
				animation.addByPrefix('idle', 'NewPhase2Sonic Idle instance 1', 24, false);
				animation.addByPrefix('singUP', 'NewPhase2Sonic Up instance 1', 24, false);
				animation.addByPrefix('singDOWN', 'NewPhase2Sonic Down instance 1', 24, false);
				animation.addByPrefix('singLEFT', 'NewPhase2Sonic Left instance 1', 24, false);
				animation.addByPrefix('singRIGHT', 'NewPhase2Sonic Right instance 1', 24, false);
				animation.addByPrefix('singDOWN-alt', 'NewPhase2Sonic Laugh instance 1', 24, false);

				addOffset('idle', -18, 70);
				addOffset("singUP", -4, 60);
				addOffset("singRIGHT", 42, -127);
				addOffset("singLEFT", 159, -105);
				addOffset("singDOWN", -15, -57);
				addOffset("singDOWN-alt", 0, 0);

				antialiasing = true;

				playAnim('idle');

			case 'faker':
				frames = Paths.getSparrowAtlas('characters/Faker_EXE_Assets');
				iconColor = 'FF242490';
				animation.addByPrefix('idle', 'FAKER IDLE instance 1', 24);
				animation.addByPrefix('singUP', 'FAKER UP instance 1', 24);
				animation.addByPrefix('singRIGHT', 'FAKER RIGHT instance 1', 24);
				animation.addByPrefix('singDOWN', 'FAKER DOWN instance 1', 24);
				animation.addByPrefix('singLEFT', 'FAKER LEFT instance 1', 24);

				addOffset('idle');
				addOffset("singUP", 0, 67);
				addOffset("singRIGHT", 24, 32);
				addOffset("singLEFT", 177, 29);
				addOffset("singDOWN",	 -50, -36);

			case 'exe-revie':
				frames = Paths.getSparrowAtlas('characters/Exe_Assets');
				iconColor = 'FF3118A7';
				animation.addByPrefix('idle', 'Exe Idle', 24);
				animation.addByPrefix('singUP', 'Exe Up', 24);
				animation.addByPrefix('singRIGHT', 'Exe Right', 24);
				animation.addByPrefix('singDOWN', 'Exe Down', 24);
				animation.addByPrefix('singLEFT', 'Exe left', 24);

				addOffset('idle', 0, 248);
				addOffset("singUP", 95, 290);
				addOffset("singRIGHT", 31, 217);
				addOffset("singLEFT", 236, 243);
				addOffset("singDOWN", 185, 44);

			case 'hypno' | 'huggy' | 'demoman' | 'hypno-two' | 'cassette-girl' | 'aldryx' | 'missingno' | 'gf-market' | 'prdev' | 'spongebob-pibby' | 'steven-pibby' | 'wooper'
			| 'nikusa' | 'nikusa-shaded' | 'bf-gf-lullaby' | 'gold' | 'aldryx-shaded':  
				// bcuz sometimes i just wanna use the psych jsons without the lag. was totally worth implementing.
				isCustom = true;

				switch (curCharacter)
				{
					case 'aldryx' | 'aldryx-shaded' | 'nikusa' | 'nikusa-shaded':
						noteSkin = 'agoti';
				}
				
				var characterPath:String = 'images/characters/' + curCharacter + '/' + curCharacter;
				var path:String = Paths.jsonNew(characterPath);

				if (!FileSystem.exists(path))
				{
					trace('nvm we usin bf');
					path = Paths.jsonNew('images/characters/bf/bf'); //If a character couldn't be found, change him to BF just to prevent a crash
				}
					
				var rawJson = File.getContent(path);

				var json:CharacterFile = cast Json.parse(rawJson);

				var txtToFind:String = Paths.txtNew('images/' + json.image);

				if(FileSystem.exists(txtToFind))
					frames = Paths.getPackerAtlas(json.image);
				else 
					frames = Paths.getSparrowAtlas(json.image);

				if(json.scale != 1) {
					jsonScale = json.scale;
					setGraphicSize(Std.int(width * jsonScale));
					updateHitbox();
				}

				positionArray = json.position;
				cameraPosition = json.camera_position;

				singDuration = json.sing_duration;
				flipX = !!json.flip_x;
				if(json.no_antialiasing) {
					antialiasing = false;
					noAntialiasing = true;
				}

				if(json.healthbar_colors != null && json.healthbar_colors.length > 2)
					healthColorArray = json.healthbar_colors;

				//cuz the way bar colors are calculated here is like in B&B
				colorPreString = FlxColor.fromRGB(healthColorArray[0], healthColorArray[1], healthColorArray[2]);
				colorPreCut = colorPreString.toHexString();

				trace(colorPreCut);

				iconColor = colorPreCut.substring(2);

				antialiasing = !noAntialiasing;

				animationsArray = json.animations;
				if(animationsArray != null && animationsArray.length > 0) {
					for (anim in animationsArray) {
						var animAnim:String = '' + anim.anim;
						var animName:String = '' + anim.name;
						var animFps:Int = anim.fps;
						var animLoop:Bool = !!anim.loop; //Bruh
						var animIndices:Array<Int> = anim.indices;
						if(animIndices != null && animIndices.length > 0) {
							animation.addByIndices(animAnim, animName, animIndices, "", animFps, animLoop);
						} else {
							animation.addByPrefix(animAnim, animName, animFps, animLoop);
						}

						if (isPlayer)
						{
							if(anim.playerOffsets != null && anim.playerOffsets.length > 1) {
								addOffset(anim.anim, anim.playerOffsets[0], anim.playerOffsets[1]);
							}
							else if(anim.offsets != null && anim.offsets.length > 1) {
								addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
							}
						}
						else
						{
							if(anim.offsets != null && anim.offsets.length > 1) {
								addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
							}
						}
					}
				} else {
					animation.addByPrefix('idle', 'BF idle dance', 24, false);
				}

			//using the psych method instead of modding plus. main reason is to make it easier for me to port them here
			default:
				isCustom = true;
				
				var characterPath:String = 'images/characters/' + curCharacter + '/' + curCharacter;
				var path:String = Paths.jsonNew(characterPath);
				trace('found '+ curCharacter);

				if (!FileSystem.exists(path))
				{
					trace('nvm we usin bf');
					path = Paths.jsonNew('images/characters/bf/bf'); //If a character couldn't be found, change him to BF just to prevent a crash
				}
					
				var rawJson = File.getContent(path);

				var json:CharacterFile = cast Json.parse(rawJson);

				var txtToFind:String = Paths.txtNew('images/' + json.image);
				var rawPic = BitmapData.fromFile(Paths.image(json.image));
				var rawXml:String;

				if(FileSystem.exists(txtToFind))
				{
					rawXml = sys.io.File.getContent(Paths.txtNew('images/' + json.image));
					frames = FlxAtlasFrames.fromSpriteSheetPacker(rawPic,rawXml);
				}
				else 
				{
					rawXml = sys.io.File.getContent(Paths.xmlNew('images/' + json.image));
					frames = FlxAtlasFrames.fromSparrow(rawPic,rawXml);
				}

				if(json.scale != 1) {
					jsonScale = json.scale;
					setGraphicSize(Std.int(width * jsonScale));
					updateHitbox();
				}

				positionArray = json.position;
				cameraPosition = json.camera_position;

				singDuration = json.sing_duration;
				flipX = !!json.flip_x;
				if(json.no_antialiasing) {
					antialiasing = false;
					noAntialiasing = true;
				}

				if(json.healthbar_colors != null && json.healthbar_colors.length > 2)
					healthColorArray = json.healthbar_colors;

				//cuz the way bar colors are calculated here is like in B&B
				colorPreString = FlxColor.fromRGB(healthColorArray[0], healthColorArray[1], healthColorArray[2]);
				colorPreCut = colorPreString.toHexString();

				trace(colorPreCut);

				iconColor = colorPreCut.substring(2);

				antialiasing = !noAntialiasing;

				animationsArray = json.animations;
				if(animationsArray != null && animationsArray.length > 0) {
					for (anim in animationsArray) {
						var animAnim:String = '' + anim.anim;
						var animName:String = '' + anim.name;
						var animFps:Int = anim.fps;
						var animLoop:Bool = !!anim.loop; //Bruh
						var animIndices:Array<Int> = anim.indices;
						if(animIndices != null && animIndices.length > 0) {
							animation.addByIndices(animAnim, animName, animIndices, "", animFps, animLoop);
						} else {
							animation.addByPrefix(animAnim, animName, animFps, animLoop);
							trace('added '+animAnim+' animation');
						}

						if (isPlayer)
						{
							if(anim.playerOffsets != null && anim.playerOffsets.length > 1) {
								addOffset(anim.anim, anim.playerOffsets[0], anim.playerOffsets[1]);
							}
							else if(anim.offsets != null && anim.offsets.length > 1) {
								addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
							}
						}
						else
						{
							if(anim.offsets != null && anim.offsets.length > 1) {
								addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
							}
						}
					}
				} else {
					animation.addByPrefix('idle', 'BF idle dance', 24, false);
				}
		}

		if(animation.getByName('danceLeft') != null && animation.getByName('danceRight') != null)
			danceIdle = true;

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
				if (animation.getByName('singRIGHT-alt') != null)
				{
					var oldAlt = animation.getByName('singRIGHT-alt').frames;
					animation.getByName('singRIGHT-alt').frames = animation.getByName('singLEFT-alt').frames;
					animation.getByName('singLEFT-alt').frames = oldAlt;
				}
			}
		}

		if (!isPlayer)
		{
			// Flip for just bf
			if (curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
				if (animation.getByName('singRIGHT-alt') != null)
				{
					var oldAlt = animation.getByName('singRIGHT-alt').frames;
					animation.getByName('singRIGHT-alt').frames = animation.getByName('singLEFT-alt').frames;
					animation.getByName('singLEFT-alt').frames = oldAlt;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter.contains('dad'))
				dadVar = 6.1;

			if (isCustom)
				dadVar = singDuration;

			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
			case 'gf-pico':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */

	public function numArr(min,max):Array<Int>
	{
		var a = [];
		var l = max - min;
		var p = min;
		for (i in 0...l){
			a.push(p);
			p++;
		}
		trace(a);
		return a;
	}

	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'bf-bigmonika-dead':
					if (animation.curAnim.name != 'crashDeath2')
					{
						if (isPlayer)
							playAnim('idle' + bfAltAnim);
						else
							playAnim('idle' + altAnim);	
					}
				case 'tankman':
					if (animation.curAnim.name != 'singDOWN-alt' && animation.curAnim.name != 'singLEFT-alt')
					{
						if (isPlayer)
							playAnim('idle' + bfAltAnim);
						else
							playAnim('idle' + altAnim);	
					}
				case 'oswald-happy':
					if (animation.curAnim.name != 'oldtimey' && animation.curAnim.name != 'lucky')
					{
						danced = !danced;
		
						if (isPlayer)
						{
							if (danced)
								playAnim('danceRight' + bfAltAnim);
							else
								playAnim('danceLeft' + bfAltAnim);
						}
						else
						{
							if (danced)
								playAnim('danceRight' + altAnim);
							else
								playAnim('danceLeft' + altAnim);
						}	
					}
				case 'oswald-angry':
					if (animation.curAnim.name != 'hah' && animation.curAnim.name != 'notold')
					{
						danced = !danced;
		
						if (isPlayer)
						{
							if (danced)
								playAnim('danceRight' + bfAltAnim);
							else
								playAnim('danceLeft' + bfAltAnim);
						}
						else
						{
							if (danced)
								playAnim('danceRight' + altAnim);
							else
								playAnim('danceLeft' + altAnim);
						}	
					}
				case 'gf-judgev2':
					if (animation.curAnim.name != 'spooked')
					{
						danced = !danced;
		
						if (isPlayer)
						{
							if (danced)
								playAnim('danceRight' + bfAltAnim);
							else
								playAnim('danceLeft' + bfAltAnim);
						}
						else
						{
							if (danced)
								playAnim('danceRight' + altAnim);
							else
								playAnim('danceLeft' + altAnim);
						}	
					}
				case 'bigmonika':
					if (animation.curAnim.name != 'lastNOTE')
					{
						if (isPlayer)
							playAnim('idle' + bfAltAnim);
						else
							playAnim('idle' + altAnim);	
					}
				case 'amor-ex':
					if (animation.curAnim.name != 'drop')
					{
						if (isPlayer)
							playAnim('idle' + bfAltAnim);
						else
							playAnim('idle' + altAnim);	
					}
				default:
					if (danceIdle)
					{
						danced = !danced;
		
						if (isPlayer)
						{
							if (danced)
								playAnim('danceRight' + bfAltAnim);
							else
								playAnim('danceLeft' + bfAltAnim);
						}
						else
						{
							if (danced)
								playAnim('danceRight' + altAnim);
							else
								playAnim('danceLeft' + altAnim);
						}	
					}
					else
					{
						if (isPlayer)
							playAnim('idle' + bfAltAnim);
						else
							playAnim('idle' + altAnim);	
					}
			}
		
			if (color != FlxColor.WHITE && !(curCharacter.startsWith('gf') && PlayState.curStage == 'hallway') && !(!isPlayer && PlayState.curStage == 'pokecenter' && !curCharacter.contains('hypno')))
			{
				color = FlxColor.WHITE;
			}
		}
	}

	public function setZoom(?toChange:Float = 1):Void
	{
		daZoom = toChange;
		scale.set(toChange, toChange);
	}

	public function loadOffsetFile(character:String)
	{
		var offset:Array<String>;
		
		if (isPlayer){
			try {
				offset = CoolUtil.coolTextFile(Paths.txtNew('images/characters/offsets/' + character + "PlayerOffsets", 'shared'));
			} catch (e) {
				try {
					offset = CoolUtil.coolTextFile(Paths.txtNew('images/characters/offsets/' + character + "Offsets", 'shared'));
				}
				catch(e) {
					offset = CoolUtil.coolTextFile(Paths.txtNew('images/characters/offsets/noOffsets', 'shared'));
				}	
			}
			
		}
		else{
			try {
				offset = CoolUtil.coolTextFile(Paths.txtNew('images/characters/offsets/' + character + "Offsets", 'shared'));
			} catch (e) {
				try {
					offset = CoolUtil.coolTextFile(Paths.txtNew('images/characters/offsets/' + character + "PlayerOffsets", 'shared'));
				}
				catch(e) {
					offset = CoolUtil.coolTextFile(Paths.txtNew('images/characters/offsets/noOffsets', 'shared'));
				}		
			}
		}
		

		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}
	}

	public function loadAnims(character:String)
	{
		var anim:Array<String>;
		
		anim = CoolUtil.coolTextFile(Paths.txtNew('images/characters/anims/' + character + "Anims", 'shared'));
		
		for (i in 0...anim.length)
		{
			var data:Array<String> = anim[i].split(':');
			var loop:Bool = false;

			if (data[4] == null)
				loop = false;
			else
			{
				if (data[4] == 'true')
					loop = true;
				else if (data[4] == 'false')
					loop = false;
			}

			if (data[0] == 'prefix')
				animation.addByPrefix(data[1], data[2], Std.parseInt(data[3]), loop);

			//still testing indices so it may not work.  EDIT: I gave up. idk how this works. just use this for prefix characters only
			//if (data[0] == 'indices')
				//animation.addByPrefix(data[1], data[2], animIndices, "", Std.parseInt(data[3]), loop);
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		var missed:Bool = false;

		if (AnimName.endsWith('alt') && animation.getByName(AnimName) == null)
		{
			AnimName = AnimName.split('-')[0];
		}

		if (AnimName.endsWith('miss') && animation.getByName(AnimName) == null)
		{
			AnimName = AnimName.substr(0, AnimName.length - 4);
			missed = true;
		}

		animation.play(AnimName, Force, Reversed, Frame);

		if (curCharacter == 'foks' && AnimName == 'singDOWN' && !missed) {
			FlxG.sound.play(Paths.sound('shine'));
		}

		if (curCharacter == 'exTricky')
		{
			if (AnimName == 'singUP')
			{
				trace('spikes');
				exSpikes.visible = true;
				if (exSpikes.animation.finished)
					exSpikes.animation.play('spike');
			}
		}


		if (missed)
			color = 0xCFAFFF;
		else if (color != FlxColor.WHITE && !(curCharacter.startsWith('gf') && PlayState.curStage == 'hallway') && !(!isPlayer && PlayState.curStage == 'pokecenter' && !curCharacter.contains('hypno')))
			color = FlxColor.WHITE;

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0] * daZoom, daOffset[1] * daZoom);
		}
		else
			offset.set(0, 0);

		var singingGFs:Array<String> = ['gf', 'gf1', 'gf2', 'gf3', 'gf4', 'gf5', 'gf-kaity', 'gf-crucified'];
		
		if (singingGFs.contains(curCharacter))
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}