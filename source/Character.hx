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

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public static var isCustom:Bool = false;
	public var altAnim:String = '';
	public var bfAltAnim:String = '';
	public var danceIdle:Bool = false; //Character use "danceLeft" and "danceRight" instead of "idle" "-- why didn't i think of this?"
	
	public var enemyOffsetX:Int = 0;
	public var enemyOffsetY:Int = 0;
	public var camOffsetX:Int = 0;
	public var camOffsetY:Int = 0;
	public var followCamX:Int = 0;
	public var followCamY:Int = 0;
	public var midpointX:Int = 0;
	public var midpointY:Int = 0;
	public var isDie:Bool = false;
	public var isPixel:Bool = false;
	public var noteSkin:String = PlayState.SONG.noteStyle;
	public var iconColor:String;

	public var holdTimer:Float = 0;

	public var daZoom:Float = 1;

	public var missSupported:Bool = false;
	public var missAltSupported:Bool = false;
	public var tex:FlxAtlasFrames;
	public var exSpikes:FlxSprite;

	public var playerOffset:Array<String>;
	var pre:String = "";

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;
		iconColor = isPlayer ? 'FF66FF33' : 'FFFF0000';
				
		antialiasing = true;
		isCustom = false;
		pre = "";
		
		switch (curCharacter)
		{
			case 'gf' | 'gf-special' | 'gf-demon' | 'gf-christmas' | 'gf-bw' | 'madgf' | 'gf-kaity' | 'gf-hex' | 'gf-pico' | 'gf-cassandra-bw' | 'gf-alya-bw' | 'gf-pico-bw' | 'gf-monika-bw' 
			| 'madgf-christmas'	| 'gf-arcade' | 'gf-ghost' | 'gf-b3' | 'gf-aloe' | 'gf-pelo-spooky':
				// GIRLFRIEND CODE
				switch (curCharacter)
				{
					case 'gf-demon':
						frames = Paths.getSparrowAtlas('characters/GF_demon_assets');
					case 'gf':
						frames = Paths.getSparrowAtlas('characters/GF_assets');
					case 'gf-arcade':
						frames = Paths.getSparrowAtlas('characters/GF_arcade_assets');
					case 'gf-special':
						frames = Paths.getSparrowAtlas('characters/GF_Special');
					case 'gf-christmas':
						frames = Paths.getSparrowAtlas('characters/gfChristmas');
					case 'gf-ghost':
						frames = Paths.getSparrowAtlas('characters/gfghost');
					case 'gf-bw':
						frames = Paths.getSparrowAtlas('characters/bw/GF_assets');
					case 'madgf':			
						frames = Paths.getSparrowAtlas('characters/madGF_assets');
					case 'madgf-christmas':			
						frames = Paths.getSparrowAtlas('characters/madgfChristmas');
					case 'gf-kaity':
						frames = Paths.getSparrowAtlas('characters/GF_Kaity_assets');
					case 'gf-hex':
						frames = Paths.getSparrowAtlas('characters/GF_Hex_assets');
					case 'gf-pico':
						frames = Paths.getSparrowAtlas('characters/GF_Pico_assets');
					case 'gf-cassandra-bw':
						frames = Paths.getSparrowAtlas('characters/bw/Cassandra_GF_assets');
					case 'gf-alya-bw':
						frames = Paths.getSparrowAtlas('characters/bw/GF_Alya_assets');
					case 'gf-pico-bw':
						frames = Paths.getSparrowAtlas('characters/bw/GF_Pico_assets');
					case 'gf-monika-bw':
						frames = Paths.getSparrowAtlas('characters/bw/Monika_GF_assets');
					case 'gf-b3':
						frames = Paths.getSparrowAtlas('characters/b3/GF_assets');
					case 'gf-aloe':
						frames = Paths.getSparrowAtlas('characters/GF_Aloe_assets');
					case 'gf-pelo-spooky':
						frames = Paths.getSparrowAtlas('characters/GF_assets_pelo_spooky');
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
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);
				animation.addByIndices('danceLeft-alt', 'GF Dancing Beat edgy', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight-alt', 'GF Dancing Beat edgy', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

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

			case 'gf-nene' | 'gf-nene-bw' | 'gf-nene-cry':
				switch (curCharacter)
				{
					case 'gf-nene':
						frames = Paths.getSparrowAtlas('characters/Nene_GF_assets');
					case 'gf-nene-bw':
						frames = Paths.getSparrowAtlas('characters/bw/Nene_GF_assets');	
					case 'gf-nene-cry':
						frames = Paths.getSparrowAtlas('characters/Nene_GF_assets_cry');
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

			case 'nogf' | 'emptygf' | 'nogf-night' | 'nogf-wire' | 'nogf-christmas' | 'nogf-rebecca' | 'nogf-glitcher' | 'nogf-bw':
				// GIRLFRIEND CODE
				switch (curCharacter)
				{
					case 'nogf':
						frames = Paths.getSparrowAtlas('characters/nogf_assets');
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

				addOffset('sad', 0);
				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);
				
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

				addOffset('sad', 0);
				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);
				addOffset('singUP', 0);
				addOffset('singRIGHT', 0);
				addOffset('singLEFT', 0);
				addOffset('singDOWN', 0);
				
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

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'gf-rock2':
				frames = Paths.getSparrowAtlas('characters/GF_rock');
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);

				addOffset('hairBlow', 45, -8);

				playAnim('hairBlow');

			case 'holo-cart' | 'holo-cart-hover' | 'holo-cart-hover-botan' | 'holo-cart-ohno':
				switch (curCharacter)
				{
					case 'holo-cart':
						tex = Paths.getSparrowAtlas('characters/holoCart');
					case 'holo-cart-hover':
						tex = Paths.getSparrowAtlas('characters/holoCartHover');
					case 'holo-cart-hover-botan':
						tex = Paths.getSparrowAtlas('characters/holoCartHoverBotan');
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

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

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

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

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

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);
				addOffset('switch', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'miku':
				frames = Paths.getSparrowAtlas('characters/ev_miku_assets');
				iconColor = 'FF32CDCC';
				animation.addByPrefix('idle', 'Miku idle dance', 24, false);
				animation.addByPrefix('singUP', 'Miku Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Miku Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Miku Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Miku Sing Note LEFT', 24, false);

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

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'dad':
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
				frames = tex;
				iconColor = 'FFAF66CE';
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT0', 24, false);
				animation.addByPrefix('singUPmiss', 'Dad Sing Note UP MISS0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Dad Sing Note RIGHT MISS0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Dad Sing Note DOWN MISS0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Dad Sing Note LEFT MISS0', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -12, 50);
					addOffset("singRIGHT", -40, 10);
					addOffset("singLEFT", 40, 27);
					addOffset("singDOWN", 40, -30);
					addOffset("singUPmiss", -12, 50);
					addOffset("singRIGHTmiss", -40, 10);
					addOffset("singLEFTmiss", 40, 27);
					addOffset("singDOWNmiss", 40, -30);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
					addOffset("singUPmiss", -6, 50);
					addOffset("singRIGHTmiss", 0, 27);
					addOffset("singLEFTmiss", -10, 10);
					addOffset("singDOWNmiss", 0, -30);
				}

				playAnim('idle');

			case 'cg5' | 'calli' | 'calli-mad' | 'calli-sad' | 'calli-mad-alpha' | 'calli-sad-alpha' | 'dad-b3' | 'midas' | 'anders' | 'anders-fearsome':
				iconColor = 'FFFF9FC0';
				switch (curCharacter)
				{
					case 'cg5':
						frames = Paths.getSparrowAtlas('characters/CG5');
						iconColor = 'FF003366';
					case 'calli':
						frames = Paths.getSparrowAtlas('characters/CALLI');
					case 'calli-mad':
						frames = Paths.getSparrowAtlas('characters/CALLI_MAD');
					case 'calli-sad':
						frames = Paths.getSparrowAtlas('characters/CALLI_SAD');
					case 'calli-mad-alpha':
						frames = Paths.getSparrowAtlas('characters/CALLI_MAD_ALPHA');
					case 'calli-sad-alpha':
						frames = Paths.getSparrowAtlas('characters/CALLI_SAD_ALPHA');
					case 'dad-b3':
						frames = Paths.getSparrowAtlas('characters/b3/DADDY_DEAREST');
						iconColor = 'FF6E5D71';
					case 'midas':
						frames = Paths.getSparrowAtlas('characters/MIDAS');
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
			
				switch (curCharacter)
				{
					case 'calli' | 'calli-mad' | 'calli-sad':
						loadOffsetFile('calli');					
					case 'calli-mad-alpha' | 'calli-sad-alpha':
						addOffset('idle');
						addOffset("singUP", -9, 8);
						addOffset("singRIGHT", 0, 10);
						addOffset("singLEFT", 0, -11);
						addOffset("singDOWN");
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
						frames = Paths.getSparrowAtlas('characters/BlantadStarving');
				}				
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT0', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", 30, 16);
					addOffset("singRIGHT", 31, 1);
					addOffset("singLEFT", 84, -6);
					addOffset("singDOWN", 39, -13);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", -7, 16);
					addOffset("singRIGHT", -6, -7);
					addOffset("singLEFT", -9, 0);
					addOffset("singDOWN", -10, -12);
				}

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
				tex = Paths.getSparrowAtlas('characters/Cyrix_Crazy');
				frames = tex;
				iconColor = 'FF88DE30';
				noteSkin = PlayState.SONG.noteStyle;
	
				animation.addByPrefix('idle', 'crazycyrix idle', 24);
				animation.addByPrefix('singUP', 'crazycyrix up note', 24);
				animation.addByPrefix('singRIGHT', 'crazycyrix right note', 24);
				animation.addByPrefix('singDOWN', 'crazycyrix down note', 24);
				animation.addByPrefix('singLEFT', 'crazycyrix left note', 24);
			
				addOffset('idle', 0, -94);
				addOffset("singUP", 60, 19);
				addOffset("singRIGHT", 0, -49);
				addOffset("singLEFT", 110, -17);
				addOffset("singDOWN", -10, -33);
			
				playAnim('idle');
		
				this.scale.x = 0.85;
				this.scale.y = 0.85;

			case 'rebecca':
				tex = Paths.getSparrowAtlas('characters/rebecca_asset');
				frames = tex;
				iconColor = 'FF19618C';
				animation.addByPrefix('idle', 'rebecca idle dance', 24);
				animation.addByPrefix('singUP', 'rebecca Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'rebecca Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'rebecca Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'rebecca Sing Note LEFT', 24);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -25, 30);
					addOffset("singLEFT", 190, -143);
					addOffset("singRIGHT", -75, -116);
					addOffset("singDOWN", -30, -310);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", -15, 30);
					addOffset("singRIGHT", -30, -143);
					addOffset("singLEFT", 157, -116);
					addOffset("singDOWN", -30, -310);
				}

				playAnim('idle');

			case 'henry' | 'henry-blue':
				switch (curCharacter)
				{
					case 'henry':
						tex = Paths.getSparrowAtlas('characters/henry');
						iconColor = 'FFE1E1E1';
					case 'henry-blue':
						tex = Paths.getSparrowAtlas('characters/henry_blue');
				}
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -26, 50);
					addOffset("singRIGHT", -54, 15);
					addOffset("singLEFT", 60, 27);
					addOffset("singDOWN", 70, -30);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
				}				

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

				addOffset('danceLeft');
				addOffset('idle_s', 0, 11);
				addOffset('danceLeft-alt', 0, 10);
				addOffset('danceRight-alt', 0, 10);

				if (isPlayer)
				{
					addOffset('danceRight', -28, 0);
					addOffset("singUP", -26, 20);
					addOffset("singLEFT", 130, -40);
					addOffset("singRIGHT", -50, -120);
					addOffset("singDOWN", 120, -170);
				}
				
				else
				{
					addOffset('danceRight');
					addOffset("singUP", -26, 21);
					addOffset("singRIGHT", 4, -37);
					addOffset("singLEFT", 180, -115);
					addOffset("singDOWN", 0, -160);
					addOffset('power', -4, 28);
					addOffset("singUP-alt", -8, 34);
					addOffset("singRIGHT-alt", 8, -25);
					addOffset("singLEFT-alt", 160, -120);
					addOffset("singDOWN-alt", 0, -157);
				}				

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

			case 'beebz':
				frames = Paths.getSparrowAtlas('characters/beebz');
				iconColor = 'FFA2588C';
				animation.addByPrefix('idle', 'Beebz_Idle', 24, false);
				animation.addByPrefix('singUP', 'Beebz_up', 24, false);
				animation.addByPrefix('singDOWN', 'Beebz_down', 24, false);
				animation.addByPrefix('singLEFT', 'Beebz_left', 24, false);
				animation.addByPrefix('singRIGHT', 'Beebz_right', 24, false);
				
				loadOffsetFile(curCharacter);
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
				animation.addByPrefix('idle-alt', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Knuckles Oh No', 24, true);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", -12, 50);
					addOffset("singRIGHT", -40, 10);
					addOffset("singLEFT", 40, 27);
					addOffset("singDOWN", 40, -30);
					addOffset("singDOWN-alt", 110, -200);
				}
				else
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
					addOffset("singDOWN-alt", 70, -200);
				}		

				playAnim('idle');

			case 'kapi' | 'kapi-angry' | 'hubert':
				noteSkin = 'kapi';
				iconColor = 'FF4E68C2';
				switch (curCharacter)
				{
					case 'kapi':
						frames = Paths.getSparrowAtlas('characters/KAPI');
					case 'kapi-angry':
						frames = Paths.getSparrowAtlas('characters/KAPI_ANGRY');
					case 'hubert':
						frames = Paths.getSparrowAtlas('characters/MrSaladHubert');
						noteSkin = PlayState.SONG.noteStyle;
						iconColor = 'FF8A9C5E';
				}
							
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", 6, 50);
					addOffset("singLEFT", 0, 27);
					addOffset("singRIGHT", 10, 10);
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
				tex = Paths.getSparrowAtlas('characters/AGOTI');
				frames = tex;
				iconColor = 'FF494949';
				animation.addByPrefix('idle', 'Agoti_Idle', 24, false);
				animation.addByPrefix('singUP', 'Agoti_Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Agoti_Right', 24, false);
				animation.addByPrefix('singDOWN', 'Agoti_Down', 24, false);
				animation.addByPrefix('singLEFT', 'Agoti_Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 25, 60);
				addOffset("singRIGHT", 80, -53);
				addOffset("singLEFT", 150, 20);
				addOffset("singDOWN", 40, -200);

				playAnim('idle');

			case 'agoti-mad' | 'agoti-glitcher' | 'agoti-wire':
				tex = Paths.getSparrowAtlas('characters/AGOTI-MAD');
				switch (curCharacter)
				{
					case 'agoti-mad':
						tex = Paths.getSparrowAtlas('characters/AGOTI-MAD');
						iconColor = 'FF494949';
					case 'agoti-glitcher':
						tex = Paths.getSparrowAtlas('characters/AGOTI-GLITCHER');
					case 'agoti-wire':
						tex = Paths.getSparrowAtlas('characters/AGOTI-WIRE');
				}
				noteSkin = 'agoti';
				frames = tex;
				animation.addByPrefix('idle', 'Angry_Agoti_Idle', 24);
				animation.addByPrefix('singUP', 'Angry_Agoti_Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry_Agoti_Right', 24, false);
				animation.addByPrefix('singDOWN', 'Angry_Agoti_Down', 24, false);
				animation.addByPrefix('singLEFT', 'Angry_Agoti_Left', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -65, 150);
					addOffset("singLEFT", 215, -5);
					addOffset("singRIGHT", -80, -30);
					addOffset("singDOWN", 120, -130);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", 55, 150);
					addOffset("singRIGHT", 15, -5);
					addOffset("singLEFT", 140, -30);
					addOffset("singDOWN", 50, -130);
				}
				
				playAnim('idle');

			case 'tabi' | 'tabi-glitcher' | 'tabi-wire':
				switch (curCharacter)
				{
					case 'tabi':
						iconColor = 'FFFFBB81';
						frames = Paths.getSparrowAtlas('characters/TABI');
					case 'tabi-wire':
						frames = Paths.getSparrowAtlas('characters/TABI_WIRE');
					case 'tabi-glitcher':
						frames = Paths.getSparrowAtlas('characters/TABI_glitcher');
				}
				
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				addOffset('idle');

				if (isPlayer)
				{			
					addOffset("singUP", 44, 50);
					addOffset("singRIGHT", 34, -28);
					addOffset("singLEFT", 85, -21);
					addOffset("singDOWN", 45, -108);
				}

				else
				{
					addOffset("singUP", 44, 50);
					addOffset("singRIGHT", -15, 11);
					addOffset("singLEFT", 104, -28);
					addOffset("singDOWN", -5, -108);
				}
				
				playAnim('idle');

			case 'tabi-crazy':
				frames = Paths.getSparrowAtlas('characters/MadTabi');
				animation.addByPrefix('idle', 'MadTabiIdle', 24, false);
				animation.addByPrefix('singUP', 'MadTabiUp', 24, false);
				animation.addByPrefix('singDOWN', 'MadTabiDown', 24, false);
				animation.addByPrefix('singLEFT', 'MadTabiLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'MadTabiRight', 24, false);
				iconColor = 'FFFFA15D';
				noteSkin = 'tabi';
				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -51, 156);
					addOffset("singLEFT", 115, -19);
					addOffset("singRIGHT", -76, -5);
					addOffset("singDOWN", -5, -60);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", 59, 96);
					addOffset("singRIGHT", -15, -19);
					addOffset("singLEFT", 184, -5);
					addOffset("singDOWN", 25, -60);
				}
				
				playAnim('idle');

			case 'little-man':
				frames = Paths.getSparrowAtlas('characters/Small_Guy');
				iconColor = 'FFFFFFFF';
				noteSkin = PlayState.SONG.noteStyle;
				animation.addByPrefix('idle', "idle", 24);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				loadOffsetFile(curCharacter);

			case 'calebcity':
				frames = Paths.getSparrowAtlas('characters/PizzaMan');
				iconColor = 'FF8F8366';
				animation.addByPrefix('idle', "PizzasHere", 29);
				animation.addByPrefix('fall', "PizzasHere", 29);
				animation.addByPrefix('singUP', 'Up', 29, false);
				animation.addByPrefix('singDOWN', 'Down', 29, false);
				animation.addByPrefix('singLEFT', 'Left', 29, false);
				animation.addByPrefix('singRIGHT', 'Right', 29, false);//
				addOffset('idle');

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
			
				animation.addByPrefix('idle', pre+'IDLE', 24, false);
				animation.addByPrefix('singUP', pre+'UP', 24, false);
				animation.addByPrefix('singDOWN', pre+'DOWN', 24, false);
				animation.addByPrefix('singLEFT', pre+'LEFT', 24, false);
				animation.addByPrefix('singRIGHT', pre+'RIGHT', 24, false);

				switch (curCharacter)
				{
					case 'abby':
						addOffset('idle', 32);
						addOffset("singUP", -76, 106);
						addOffset("singRIGHT", -18, -33);
						addOffset("singLEFT", 10, 64);
						addOffset("singDOWN", -98, -76);
					case 'abby-mad':
						addOffset('idle', -46);
						addOffset("singUP", -20, 82);
						addOffset("singDOWN", -36, -31);
						addOffset("singLEFT", 2, 32);
						addOffset("singRIGHT", -7, -31);
				}
				
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
				
				addOffset('idle');
				addOffset("singUP", 21, -37);
				addOffset("singLEFT", -12, 14);
				addOffset("singRIGHT", 26, 12);
				addOffset("singDOWN", 21, 61);
				
				playAnim('idle');

			case 'lucian':
				frames = Paths.getSparrowAtlas('maginage/Lucian Poses');
				animation.addByPrefix('idle', 'LucianIdle', 24, false);
				animation.addByPrefix('singUP', 'LucianUp', 24, false);
				animation.addByPrefix('singDOWN', 'LucianDown', 24, false);
				animation.addByPrefix('singLEFT', 'LucianLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'LucianRight', 24, false);

				addOffset('idle');

				if (isPlayer)
				{
					addOffset("singUP", -25, 60);
					addOffset("singLEFT", 160, -75);
					addOffset("singRIGHT", -50, 10);
					addOffset("singDOWN", 10, -20);
				}
				else
				{
					addOffset("singUP", -15, 60);
					addOffset("singRIGHT", -60, -75);
					addOffset("singLEFT", 50, 10);
					addOffset("singDOWN", -10, -20);
				}		

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

				addOffset('idle');
				addOffset("singUP", -41, 21);
				addOffset("singRIGHT", -10, -14);
				addOffset("singLEFT", 63, -24);
				addOffset("singDOWN", -62, -19);

				if (isPlayer)
				{
					addOffset("singUP", -21, 21);
					addOffset("singRIGHT", -40, -14);
					addOffset("singLEFT", 63, -24);
					addOffset("singDOWN", -30, -19);
				}
				
				addOffset("singUPmiss", -21, 21);
				addOffset("singRIGHTmiss", -40, -14);
				addOffset("singLEFTmiss", 63, -24);
				addOffset("singDOWNmiss", -15, -28);

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

			case 'tricky':
				frames = Paths.getSparrowAtlas('characters/tricky');
				iconColor = 'FF185F40';
				animation.addByPrefix('idle', 'Idle', 24);
				animation.addByPrefix('idle-alt', 'Idle', 24);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24);
				animation.addByPrefix('singDOWN-alt', 'Scream', 24);

				addOffset('idle');
				addOffset('idle-alt');
				addOffset("singUP", 93, -1);
				addOffset("singRIGHT", 16, -100);
				addOffset("singLEFT", 103, 3);
				addOffset("singDOWN", 6, -9);
				addOffset("singDOWN-alt", 6, -9);

				playAnim('idle');

			case 'zardy' | 'starecrown' | 'whitty-minus' | 'whitty-minus-b3' | 'lexi-b3' | 'happymouse' | 'papyrus' | 'kirbo' | 'dr-springheel' | 'noke' | 'ron' | 'cablecrow' | 'mario'
			| 'trollge' | 'jester' | 'tornsketchy' | 'happymouse2' | 'sunky' | 'herobrine' | 'mokey' | 'geese-minus' | 'geese':
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
					case 'happymouse':
						frames = Paths.getSparrowAtlas('characters/happymouse_assets');
						iconColor = 'FFFAFAFA';
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
				}
				
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Sing Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24, false);
				animation.addByPrefix('singDOWN', 'Sing Down', 24, false);
				animation.addByPrefix('singLEFT', 'Sing Left', 24, false);

				switch (curCharacter)
				{
					case 'happymouse2':
						animation.addByPrefix('singDOWN-alt', 'Laugh', 24, false);
						addOffset('singDOWN-alt');
				}

				switch (curCharacter)
				{
					case 'whitty-minus' | 'whitty-minus-b3':
						loadOffsetFile('whitty-minus');
					case 'happymouse' | 'happymouse2' | 'sunky':
						loadOffsetFile('no');
					default:
						loadOffsetFile(curCharacter);
				}	

				playAnim('idle');

				if (curCharacter == 'noke') {
					flipX = true;
				}

			case 'monika-real':
				// I love my wife - SirDuSterBuster
				tex = Paths.getSparrowAtlas('characters/Doki_MonikaNonPixel_Assets');
				frames = tex;
				animation.addByPrefix('idle', 'Monika Returns Idle', 24, false);
				animation.addByPrefix('singUP', 'Monika Returns Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Monika Returns Right', 24, false);
				animation.addByPrefix('singDOWN', 'Monika Returns Down', 24, false);
				animation.addByPrefix('singLEFT', 'Monika Returns Left', 24, false);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * .9));
				playAnim('idle');

			case 'natsuki':
				//natsuki is bae -- blantados
				tex = Paths.getSparrowAtlas('characters/Doki_Nat_Assets');
				frames = tex;
				animation.addByPrefix('idle', 'Nat Idle', 24, false);
				animation.addByPrefix('singUP', 'Nat Sing Note Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Nat Sing Note Right', 24, false);
				animation.addByPrefix('singDOWN', 'Nat Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Nat Sing Note Left', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

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

			case 'kkslider':
				frames = Paths.getSparrowAtlas('characters/kk_assets');
				iconColor = 'FFFFFFFF';
				animation.addByPrefix('idle', 'kk idle', 24, false);
				animation.addByPrefix('singUP', 'kk up', 24, false);
				animation.addByPrefix('singRIGHT', 'kk right', 24, false);
				animation.addByPrefix('singDOWN', 'kk down', 24, false);
				animation.addByPrefix('singLEFT', 'kk left', 24, false);

				loadOffsetFile('no');

				playAnim('idle');

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

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -67, -28);
					addOffset("singLEFT", -25, -29);
					addOffset("singRIGHT", -100, -6);
					addOffset("singDOWN", -87, -9);
					addOffset("singUPmiss", -68, -30);
					addOffset("singLEFTmiss", -26, -31);
					addOffset("singRIGHTmiss", -109, -7);
					addOffset("singDOWNmiss", -75, -10);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", 23, -28);
					addOffset("singRIGHT", -53, -28);
					addOffset("singLEFT", 47, -5);
					addOffset("singDOWN", 43, -9);
					addOffset("singUPmiss", 25, -29);
					addOffset("singRIGHTmiss", -46, -31);
					addOffset("singLEFTmiss", 47, -6);
					addOffset("singDOWNmiss", 40, -10);
				}

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

				if (curCharacter == 'tom')//
				{
					animation.addByPrefix('singLEFT-alt', "tord ugh", 24, false);
					if (isPlayer)
						addOffset("singLEFT-alt", 0, 80);
					else
						addOffset("singLEFT-alt", 80, 80);
				}

				loadOffsetFile('tord');

				playAnim('idle');

			case 'hex':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/hex');
				frames = tex;
				noteSkin = PlayState.SONG.noteStyle;
				iconColor = 'FFF46C4E';
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT0', 24, false);
				animation.addByPrefix('singUP-alt', 'Dad Jump', 24, false);

				if (isPlayer)
				{
					animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT Purple', 24, false);
					animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT Red', 24, false);
				}

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -12, 50);
					addOffset("singRIGHT", -40, 10);
					addOffset("singLEFT", 40, 27);
					addOffset("singDOWN", 40, -30);
					addOffset("singUP-alt", 0, 200);
				}	

				else
				{
					addOffset('idle');
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
					addOffset("singUP-alt", 0, 200);
				}	

				playAnim('idle');

			case 'hex-virus':
				frames = Paths.getSparrowAtlas('characters/Hex_Virus');
				iconColor = 'FF0A1233';
				animation.addByPrefix('idle', 'Hex crazy idle', 24, false);
				animation.addByPrefix('singUP', 'Hex crazy up', 24, false);
				animation.addByPrefix('singRIGHT', 'Hex crazy right', 24, false);
				animation.addByPrefix('singDOWN', 'Hex crazy down', 24, false);
				animation.addByPrefix('singLEFT', 'Hex crazy left', 24, false);
				animation.addByPrefix('idle-alt', 'Hex crazy idle', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", 4, 110);
					addOffset("singRIGHT", -50, 65);
					addOffset("singLEFT", 160, -13);
					addOffset("singDOWN", -10, -60);
				}	

				else
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
				}	

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
						frames = Paths.getSparrowAtlas('characters/HD_SENPAI_GIDDY');//
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

				if (isPlayer)
				{		
					addOffset('idle');
					addOffset("singUP", -12, 50);
					addOffset("singRIGHT", -24, 10);
					addOffset("singLEFT", 70, 27);
					addOffset("singDOWN", 64, -36);
					addOffset("singLEFT-alt", -40, 10);
					addOffset("singDOWN-alt", 40, -30);
				}
				else
				{		
					addOffset('idle');
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
					addOffset("singLEFT-alt", -10, 10);
					addOffset("singDOWN-alt", 0, -30);
				}		

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

				if (isPlayer)
				{		
					addOffset('idle');
					addOffset("singUP", -12, 50);
					addOffset("singRIGHT", -24, 10);
					addOffset("singLEFT", 70, 27);
					addOffset("singDOWN", 64, -36);
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

			case 'bf-senpai-worried':
				frames = Paths.getSparrowAtlas('characters/HD_SENPAIWORRIED');
				iconColor = 'FFFFAA6F';
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

				addOffset('idle',1,1);

				if (isPlayer)
				{
					addOffset('idle-alt',28,3);
					addOffset("singDOWN", 117, -27);
					addOffset("singRIGHT", -11,-1);
					addOffset("singUP", 84, 147);
					addOffset("singUP-alt", 467, 147);
					addOffset("singLEFT", 220,-10);	
				}
				else
				{	
					addOffset('idle-alt',1,3);
					addOffset("singDOWN", 157, -27);
					addOffset("singRIGHT", -71,-10);
					addOffset("singUP", 137, 147);
					addOffset("singUP-alt", 137, 147);
					addOffset("singLEFT", 39,-1);	
				}
					
				if (PlayState.SONG.song.toLowerCase() == "valentine")
				{
					playAnim('idle-alt');
				}
				else
				{
					playAnim('idle');
				}

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

				addOffset('idle');
				if (isPlayer)
				{			
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 20, 27);
					addOffset("singLEFT", -30, 10);
					addOffset("singDOWN", 0, -30);
				}

				else
				{
					addOffset("singUP", -25, 10);
					addOffset("singRIGHT", 10, -45);
					addOffset("singLEFT", -12, -2);
					addOffset("singDOWN", -15, -75);
				}
				
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

				addOffset('idle', -10, 75);
				addOffset("singUP", -10, 75);
				addOffset("singRIGHT", -10, 75);
				addOffset("singLEFT", -10, 75);
				addOffset("singDOWN", -10, 75);
				addOffset("singUPmiss", -10, 75);
				addOffset("singRIGHTmiss", -10, 75);
				addOffset("singLEFTmiss", -10, 75);
				addOffset("singDOWNmiss", -10, 75);

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

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", 0, -15);
					addOffset("singLEFT", 20, -60);
					addOffset("singRIGHT", -25, -25);
					addOffset("singDOWN", - 25, -85);
				}

				else
				{
					addOffset('idle');
					addOffset("singUP", -60, -15);
					addOffset("singRIGHT", -100, -60);
					addOffset("singLEFT", -45, -25);
					addOffset("singDOWN", -55, -85);
				}
				
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

			case 'sayori-blue':
				tex = Paths.getSparrowAtlas('characters/blue/sayori');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);

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
					addOffset("singUP", 52, 67);
					addOffset("singRIGHT", 50, 144);
					addOffset("singLEFT", 54, 72);
					addOffset("singDOWN", 8, 125);
				}

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

			case 'isabella':
				frames = Paths.getSparrowAtlas('characters/Isabella_Assets');
				iconColor = 'FF663366';

				animation.addByPrefix('idle', 'IsaIdle', 24, false);
				animation.addByPrefix('singUP', 'IsaUp', 24, false);
				animation.addByPrefix('singRIGHT', 'IsaRight', 24, false);
				animation.addByPrefix('singDOWN', 'IsaDown', 24,  false);
				animation.addByPrefix('singLEFT', 'IsaLeft', 24, false);

				addOffset('idle');
				addOffset("singUP", -10, 45);
				addOffset("singRIGHT", -30, 10);
				addOffset("singLEFT", 90, 10);
				addOffset("singDOWN", 0, -10);

				playAnim('idle');

			case 'kodacho':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/Kodacho_Assets');
				iconColor = 'FFECBDF5';

				animation.addByPrefix('idle', 'Koda Idle', 24, false);
				animation.addByPrefix('singUP', 'koda up', 24, false);
				animation.addByPrefix('singRIGHT', 'koda right', 24, false);
				animation.addByPrefix('singDOWN', 'koda down', 24,  false);
				animation.addByPrefix('singLEFT', 'Koda left note', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", 0, -10);
					addOffset("singLEFT", 10, -20);
					addOffset("singRIGHT", -10, 15);
					addOffset("singDOWN", -30, -80);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", 0, -10);
					addOffset("singRIGHT", -20, -20);
					addOffset("singLEFT", 30, 15);
					addOffset("singDOWN", -30, -80);
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

				addOffset('idle');				

				if (isPlayer)
				{			
					addOffset("singUP", -16, 50);
					addOffset("singLEFT", 40, 27);
					addOffset("singRIGHT", -40, -20);
					addOffset("singDOWN", 40, -50);
					addOffset("singUP-alt", 290, 180);
				}
				else
				{
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, -20);
					addOffset("singDOWN", 0, -50);
					addOffset("singUP-alt", 690, 180);
				}			

				playAnim('idle');

			case 'whittyCrazy':
				frames = Paths.getSparrowAtlas('characters/WhittyCrazy');
				iconColor = 'FFFF0000';
				animation.addByPrefix('idle', 'Whitty idle dance', 24, false);
				animation.addByPrefix('singUP', 'Whitty Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'whitty sing note right', 24, false);
				animation.addByPrefix('singDOWN', 'Whitty Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Whitty Sing Note LEFT', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 110);
				addOffset("singRIGHT", 110, -75);
				addOffset("singLEFT", 60, 20);
				addOffset("singDOWN", 130, -130);

				playAnim('idle');

			case 'spooky' | 'spooky-b3' | 'jevil' | 'spooky-pelo':
				var name:String = curCharacter;
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

			case 'gura-amelia' | 'gura-amelia-walfie' | 'gura-amelia-bw':
				switch (curCharacter)
				{
					case 'gura-amelia':
						frames = Paths.getSparrowAtlas('characters/gura_amelia');
					case 'gura-amelia-walfie':
						frames = Paths.getSparrowAtlas('characters/AmeSame_assets_WALFIE');
					case 'gura-amelia-bw':
						frames = Paths.getSparrowAtlas('characters/bw/gura_amelia');
				}
				if (!curCharacter.contains('bw')){
					iconColor = 'FFFFA054';
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
					{
						addOffset("singDOWN-alt", -8, 198);
					}
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
					{
						addOffset("singDOWN-alt", -8, 198);
					}
				}

				playAnim('danceRight');

			case 'mom' | 'static':
				switch (curCharacter)
				{
					case 'mom':
						frames = Paths.getSparrowAtlas('characters/Mom_Assets');
						iconColor = 'FFD8558E';
					case 'static':
						frames = Paths.getSparrowAtlas('characters/static_Assets');
						iconColor = 'FF434050';
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

				loadOffsetFile(curCharacter);
				
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
				iconColor = 'FFC4E666';

				animation.addByPrefix('idle', 'mel idle', 24, false);
				animation.addByPrefix('singUP', 'mel up', 24, false);
				animation.addByPrefix('singRIGHT', 'mel right', 24, false);
				animation.addByPrefix('singDOWN', 'mel down', 24, false);
				animation.addByPrefix('singLEFT', 'mel left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 20);
				addOffset("singRIGHT", 10, -20);
				addOffset("singLEFT", 60, -20);
				addOffset("singDOWN", 20, -25);

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

			case 'coco' | 'coco-car':
				switch (curCharacter)
				{
					case 'coco':
						tex = Paths.getSparrowAtlas('characters/Coco_Assets');
					case 'coco-car':
						tex = Paths.getSparrowAtlas('characters/cocoCar');	
				}

				frames = tex;
				iconColor = 'FFE67A34';

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

			case 'bob2':
				frames = Paths.getSparrowAtlas('characters/bob_assets');
				iconColor = "FFEBDD44";
				animation.addByPrefix('idle', 'BOB idle dance', 24, false);
				animation.addByPrefix('singUP', 'BOB Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'BOB Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'BOB Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'BOB Sing Note RIGHT', 24, false);

				addOffset('idle');
				addOffset("singUP", -36, 57);
				addOffset("singRIGHT", -62, 32);
				addOffset("singLEFT",31, 13);
				addOffset("singDOWN", -31, -10);

				playAnim('idle');

			case 'bosip':
				frames = Paths.getSparrowAtlas('characters/bosip_assets');
				iconColor = "FFE18B38";
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
				
			case 'haachama':
				frames = Paths.getSparrowAtlas('characters/Haachama_Assets');
				iconColor = 'FFF58F2B';
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
				iconColor = 'FF773D30';
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

				animation.addByPrefix('idle', 'austin idle dance', 24);

				animation.addByPrefix('singUP', 'austin Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'austin Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'austin Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'austin Sing Note LEFT', 24);

				animation.addByPrefix('singUPmiss', 'austin miss up', 24);
				animation.addByPrefix('singRIGHTmiss', 'austin miss right', 24);
				animation.addByPrefix('singDOWNmiss', 'austin miss down', 24);
				animation.addByPrefix('singLEFTmiss', 'austin miss left', 24);

				animation.addByPrefix('firstDeath', "austin fucking dies", 24, false);
				animation.addByPrefix('deathLoop', "austin fucking dies loop", 24, false);
				animation.addByPrefix('deathConfirm', "austin fucking dies confirm", 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'brody':
				tex = Paths.getSparrowAtlas('characters/Brody_Assets','shared');
				frames = tex;
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

			case 'crazygf':
				frames = Paths.getSparrowAtlas('characters/crazyGF');
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

			case 'botan' | 'botan-b3':
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

			case 'tankman' | 'tankman-mad' | 'tankman-bw' | 'tankman-sad-blue':
				switch (curCharacter)
				{
					case 'tankman':
						tex = Paths.getSparrowAtlas('characters/tankmanCaptain');
					case 'tankman-mad':
						tex = Paths.getSparrowAtlas('characters/tankman_mad');
					case 'tankman-bw':
						tex = Paths.getSparrowAtlas('characters/bw/tankmanCaptain');
					case 'tankman-sad-blue':
						tex = Paths.getSparrowAtlas('characters/blue/tankmanSad');
				}
				iconColor = 'FF2C2D41';
				
				frames = tex;
				animation.addByPrefix('idle', "Tankman Idle Dance", 24, false);
				animation.addByPrefix('idle-alt', "Tankman Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'Tankman UP note', 24, false);
				animation.addByPrefix('singDOWN', 'Tankman DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'Tankman Right Note', 24, false);
				animation.addByPrefix('singRIGHT', 'Tankman Note Left', 24, false);
				animation.addByPrefix('singUP-alt', 'TANKMAN UGH', 24, false);
				animation.addByPrefix('singDOWN-alt', 'PRETTY GOOD', 24, false);
				animation.addByPrefix('lilDude', 'Lil Dude', 24, false);

				addOffset('idle', -5);
				addOffset('idle-alt', -5);

				if (isPlayer)
				{
					addOffset("singUP", 18, 46);
					addOffset("singLEFT", 100, -30);
					addOffset("singRIGHT", -28, -12);
					addOffset("singDOWN", 68, -104);
					addOffset("singUP-alt", -20, -9);
					addOffset("singDOWN-alt", 95, 15);
					addOffset("lilDude");
				}
				else
				{
					addOffset("singUP", 44, 46);
					addOffset("singLEFT", 82, -12);
					addOffset("singRIGHT", -25, -30);
					addOffset("singDOWN", 68, -104);
					addOffset("singUP-alt", -20, -9);
					addOffset("singDOWN-alt", -5, 15);
					addOffset("lilDude", -9, 2);
				}

				playAnim('idle');

				flipX = true;

			case 'bf' | 'bf-bw' | 'bf-kaity' | 'bf-sonic' | 'bf-blue' | 'bf-pump' | 'bf-sonic-bw' | 'bf-ex-night' | 'bf-ghost' | 'bf-b3' | 'bf-frisk' | 'bf-gf' | 'bf-gf-demon'
			| 'bf-kitty' | 'bf-nene':
				switch (curCharacter)
				{				
					case 'bf-bw':
						frames = Paths.getSparrowAtlas('characters/bw/BOYFRIEND');
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
					case 'bf-sonic':
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
					case 'bf-frisk':
						frames = Paths.getSparrowAtlas('characters/frisk');
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
					case 'bf-nene':
						frames = Paths.getSparrowAtlas('characters/Nene_Assets');
						iconColor = 'FFFFF29E';
						noteSkin = 'holofunk';
				}

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('singUP-alt', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);	
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
		
				if (curCharacter == 'bf-b3' || curCharacter == 'bf-nene' || curCharacter == 'bf-sonic') {
					loadOffsetFile(curCharacter);
				}
				else {
					loadOffsetFile('bf');
				}
				
				playAnim('idle');

				flipX = true;

			case 'bf-cesar':
				var tex = Paths.getSparrowAtlas('characters/cesar');
				frames = tex;

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
				addOffset("singUP", -20, 13);
				addOffset("singRIGHT", -35, -9);
				addOffset("singLEFT", 30, -4);
				addOffset("singDOWN", -5, -75);
				addOffset("singUPmiss", -56, 10);
				addOffset("singRIGHTmiss", -48, -15);
				addOffset("singLEFTmiss", 21, -3);
				addOffset("singDOWNmiss", -33, -75);
				addOffset("hey", -10, 3);
				addOffset("transition", -10, 3);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -10, -12);

				playAnim('idle');

				flipX = true;

			case 'bf-demoncesar' | 'bf-demoncesar-bw' | 'bf-demoncesar-trollge':
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
				}
				
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

			case 'bf-aloe' | 'bf-aloe-bw' | 'bf-aloe-corrupt':
				switch (curCharacter)
				{
					case 'bf-aloe':
						frames = Paths.getSparrowAtlas('characters/ALOE');
						iconColor = 'FFEF71B1';
					case 'bf-aloe-bw':
						frames = Paths.getSparrowAtlas('characters/bw/ALOE');
					case 'bf-aloe-corrupt':
						frames = Paths.getSparrowAtlas('characters/ALOE_CORRUPT');
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
				animation.addByPrefix('singLEFT', 'bob_LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'bob_RIGHT', 24, false);

				addOffset('idle');

				playAnim('idle');

				flipX = true;

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

				addOffset('idle');
				addOffset('idle-alt');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");			
				addOffset("singUP-alt");
				addOffset("singRIGHT-alt");
				addOffset("singLEFT-alt");
				addOffset("singDOWN-alt");
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
						addOffset("singUP", 97, 127);
						addOffset("singRIGHT", -93, -123);
						addOffset("singLEFT", 15, 27);
						addOffset("singDOWN", -29, -126);
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

			case 'senpai-angry'| 'glitch-angry' | 'kristoph-angry' | 'chara-pixel' | 'jackson' | 'mario-angry' | 'matt-angry' | 'mangle-angry' | 'baldi-angry' | 'colt-angry' 
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
					case 'baldi-angry':
						frames = Paths.getSparrowAtlas('characters/baldi');
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

			case 'parents-christmas' | 'parents-christmas-angel' | 'parents-christmas-soft' | 'bico-christmas' | 'skye':
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
					case 'skye':
						frames = Paths.getSparrowAtlas('characters/skye');
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
				
			case 'cjClone':
				frames = Paths.getSparrowAtlas('characters/CJCLONE');
				iconColor = 'FFFF0000';

				animation.addByPrefix('idle', 'Idle', 24);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('Hank', 'Showtime', 24, true);

				addOffset('idle');
				addOffset("singUP", -46, 28);
				addOffset("singRIGHT", -20, 37);
				addOffset("singLEFT", -2, 3);
				addOffset("singDOWN", -20, -20);
				addOffset('ha', -46, 28);
				addOffset('haha', -46, 28);
				addOffset('Hank');

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

			case 'isa':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/isa');
				frames = tex;
				animation.addByPrefix('idle', 'IdleIsa', 24, false);
				animation.addByPrefix('singUP', 'IsaUp', 24, false);
				animation.addByPrefix('singRIGHT', 'IsaRight', 24, false);
				animation.addByPrefix('singDOWN', 'DownIsa', 24, false);
				animation.addByPrefix('singLEFT', 'LeftIsa', 24, false);

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
					addOffset("singUP", 83, -19);
					addOffset("singRIGHT", 0, -8);
					addOffset("singLEFT", 0, -5);
					addOffset("singDOWN", 0, -20);
				}

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

			case 'amor-ex':
				iconColor = "FF9E2947";
				noteSkin = 'amor';
				frames = Paths.getSparrowAtlas('characters/amorex', 'shared');
				animation.addByPrefix('idle', 'amor idle big0', 24, false);
				animation.addByPrefix('singUP', 'amor up big', 24, false);
				animation.addByPrefix('singDOWN', 'amor down big', 24, false);
				animation.addByPrefix('singLEFT', 'amor left big', 24, false);
				animation.addByPrefix('singRIGHT', 'amor right big', 24, false);
				animation.addByPrefix('drop', 'amor fucking dies', 24, false);

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

				addOffset('idle');
				addOffset("singUP", -30, 36);
				addOffset("singRIGHT", -64, -13);
				addOffset("singLEFT",-30, -12);
				addOffset("singDOWN", -35, -23);
				addOffset("drop", 55, 84);

				playAnim('idle');

			default:
				#if sys
					// fuck me. I need to clean this shit.
					curCharacter = curCharacter.trim();
					isCustom = true;
					if (StringTools.endsWith(curCharacter, "-dead")) {
						isDie = true;
						curCharacter = curCharacter.substr(0, curCharacter.length - 5);
					}
					var charJson:Dynamic = null;
					var isError:Bool = false;
					try {
						charJson = CoolUtil.parseJson(Assets.getText(Paths.jsoncNew('images/customchars/customchars')));
					} catch (exception) {
						// uh oh someone messed up their json
						Application.current.window.alert("Hey! You messed up your customchars.jsonc. Your game won't crash but it will load bf. "+exception, "Alert");
						isError = true;
					}
					if (!isError) {
						// use assets, as it is less laggy
						var animJson = sys.io.File.getContent(Paths.image2('customchars/'+curCharacter+'/'+curCharacter+'.json'));
						var parsedAnimJson:Dynamic = CoolUtil.parseJson(animJson);

						var rawPic = BitmapData.fromFile(Paths.image('customchars/'+curCharacter+'/'+curCharacter));
						var tex:FlxAtlasFrames;
						var rawXml:String;
						// GOD IS DEAD WHY DOES THIS NOT WORK
						if (FileSystem.exists(Paths.image2('customchars/'+curCharacter+'/'+curCharacter+'.txt'))){
							rawXml = sys.io.File.getContent(Paths.image2('customchars/'+curCharacter+'/'+curCharacter+'.txt'));
							tex = FlxAtlasFrames.fromSpriteSheetPacker(rawPic,rawXml);
						} else {
							rawXml = sys.io.File.getContent(Paths.image2('customchars/'+curCharacter+'/'+curCharacter+'.xml'));
							tex = FlxAtlasFrames.fromSparrow(rawPic,rawXml);
						}
						frames = tex;

						for( field in Reflect.fields(parsedAnimJson.animation) ) {
							var fps = 24;
							if (Reflect.hasField(Reflect.field(parsedAnimJson.animation,field), "fps")) {
								fps = Reflect.field(parsedAnimJson.animation,field).fps;
							}
							var loop = false;
							if (Reflect.hasField(Reflect.field(parsedAnimJson.animation,field), "loop")) {
								loop = Reflect.field(parsedAnimJson.animation,field).loop;
							}
							if (Reflect.hasField(Reflect.field(parsedAnimJson.animation,field),"flippedname") && !isPlayer) {
								// the double not is to turn a null into a false
								if (Reflect.hasField(Reflect.field(parsedAnimJson.animation,field),"indices")) {
									var indicesAnim:Array<Int> = Reflect.field(parsedAnimJson.animation,field).indices;
									animation.addByIndices(field, Reflect.field(parsedAnimJson.animation,field).flippedname, indicesAnim, "", fps, !!Reflect.field(parsedAnimJson.animation,field).loop);
								} else {
									animation.addByPrefix(field,Reflect.field(parsedAnimJson.animation,field).flippedname, fps, !!Reflect.field(parsedAnimJson.animation,field).loop);
								}

							} else {
								if (Reflect.hasField(Reflect.field(parsedAnimJson.animation,field),"indices")) {
									var indicesAnim:Array<Int> = Reflect.field(parsedAnimJson.animation,field).indices;
									animation.addByIndices(field, Reflect.field(parsedAnimJson.animation,field).name, indicesAnim, "", fps, !!Reflect.field(parsedAnimJson.animation,field).loop);
								} else {
									animation.addByPrefix(field,Reflect.field(parsedAnimJson.animation,field).name, fps, !!Reflect.field(parsedAnimJson.animation,field).loop);
								}
							}
						}

						if (isPlayer)
						{
							for( field in Reflect.fields(parsedAnimJson.playeroffset)) {
								addOffset(field, Reflect.field(parsedAnimJson.playeroffset,field)[0],  Reflect.field(parsedAnimJson.playeroffset,field)[1]);
							}
						}
						else
						{
							for( field in Reflect.fields(parsedAnimJson.offset)) {
								addOffset(field, Reflect.field(parsedAnimJson.offset,field)[0],  Reflect.field(parsedAnimJson.offset,field)[1]);
							}
						}
				
						camOffsetX = if (parsedAnimJson.camOffset != null) parsedAnimJson.camOffset[0] else 0;
						camOffsetY = if (parsedAnimJson.camOffset != null) parsedAnimJson.camOffset[1] else 0;
						enemyOffsetX = if (parsedAnimJson.enemyOffset != null) parsedAnimJson.enemyOffset[0] else 0;
						enemyOffsetY = if (parsedAnimJson.enemyOffset != null) parsedAnimJson.enemyOffset[1] else 0;
						followCamX = if (parsedAnimJson.followCam != null) parsedAnimJson.followCam[0] else 150;
						followCamY = if (parsedAnimJson.followCam != null) parsedAnimJson.followCam[1] else -100;
						midpointX = if (parsedAnimJson.midpoint != null) parsedAnimJson.midpoint[0] else 0;
						midpointY = if (parsedAnimJson.midpoint != null) parsedAnimJson.midpoint[1] else 0;
						flipX = if (parsedAnimJson.flipx != null) parsedAnimJson.flipx else false;

						isPixel = parsedAnimJson.isPixel;
						if (parsedAnimJson.isPixel) {
							antialiasing = false;
							setGraphicSize(Std.int(width * 6));
							updateHitbox(); // when the hitbox is sus!
						}
						if (!isDie) {
							width += if (parsedAnimJson.size != null) parsedAnimJson.size[0] else 0;
							height += if (parsedAnimJson.size != null) parsedAnimJson.size[1] else 0;
						}
						playAnim(parsedAnimJson.playAnim);
					} else {
						// uh oh we got an error
						// pretend its boyfriend to prevent crashes
						frames = Paths.getSparrowAtlas('characters/BOYFRIEND');
					
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
	
						loadOffsetFile('bf');
	
						flipX = true;
						playAnim('idle');
					}
					#end
		}

		if(animation.getByName('danceLeft') != null && animation.getByName('danceRight') != null)
		{
			danceIdle = true;
		}

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
	public function dance()
	{
		if (!debugMode)
		{
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
				{
					playAnim('idle' + bfAltAnim);
				}
				else
				{
					playAnim('idle' + altAnim);
				}		
			}

			if (color != FlxColor.WHITE)
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

	public function setSwitchNotes():Void
	{
		switch (PlayState.curStage)
		{
			default:
				if (PlayState.changeArrows)
				{
					if (isPlayer)
						noteSkin = PlayState.bfNoteStyle;
					else
						noteSkin = PlayState.dadNoteStyle;
				}
					
				else
					noteSkin = PlayState.SONG.noteStyle;
		}
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
		else if (color != FlxColor.WHITE)
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