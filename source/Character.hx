package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var altAnim:String = '';
	public var bfAltAnim:String = '';

	public var holdTimer:Float = 0;

	public var daZoom:Float = 1;

	public var missSupported:Bool = false;
	public var missAltSupported:Bool = false;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets');
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

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-demon':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_demon_assets');
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

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');


			case 'gf-m':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets-m');
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

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'cj-tied':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/cj_tied');
				frames = tex;
				animation.addByIndices('danceLeft', 'CJ', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'CJ', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				playAnim('danceRight');

			case 'gf-selever':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_Selever_assets');
				frames = tex;
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				playAnim('danceRight');

			case 'gf-bw':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/bw/GF_assets');
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

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-cassandra-bw':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/bw/Cassandra_GF_assets');
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

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-alya-bw':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/bw/GF_Alya_assets');
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

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-pico-bw':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/bw/GF_Pico_assets');
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

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-ruv-bw':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/bw/GF_Ruv');
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

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-monika-bw':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/bw/Monika_GF_assets');
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

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-nene-bw':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/bw/Nene_GF_assets');
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

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-nene':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/Nene_GF_assets');
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

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-kaity':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_Kaity_assets');
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

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-hex':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_Hex_assets');
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

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

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

			case 'gf-pico':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_Pico_assets');
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

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'nogf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/nogf_assets');
				frames = tex;
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

			case 'nogf-christmas':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/nogf_christmas_assets');
				frames = tex;
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

			case 'nogf-rebecca':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/nogf_rebecca');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByIndices('sad', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('scared', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('cheer');
				addOffset('sad', 0, -9);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset('scared', 0, -9);

				playAnim('danceRight');

			case 'nogf-glitcher':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/nogf_glitcher');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByIndices('sad', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('hairBlow', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('hairFall', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', 0, -9);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'madgf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/madGF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByIndices('sad', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('cheer');
				addOffset('sad', 0, -9);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				playAnim('danceRight');

			case 'gf-ruv':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_Ruv');
				frames = tex;
				animation.addByIndices('sad', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('hairBlow', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('hairFall', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				playAnim('danceRight');

			case 'gf-ruv-glitcher':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_Ruv_Glitcher');
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

			case 'gf-tankman':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/gfTankman');
				frames = tex;
				animation.addByIndices('sad', 'GF Crying at Gunpoint', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing at Gunpoint', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing at Gunpoint', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('sad', 173, -2);
				addOffset('danceLeft', 175, -9);
				addOffset('danceRight', 175, -9);
				
				playAnim('danceRight');

			case 'gf-crucified':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('sky/gf');
				frames = tex;
				animation.addByIndices('sad', 'GF miss', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF idle', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF idle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('sad', 0, -9);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
				
				playAnim('danceRight');

			case 'crazygf-crucified':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('sky/crazygf');
				frames = tex;
				animation.addByIndices('sad', 'GF idle', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF idle', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF idle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('sad', 0, -9);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
				
				playAnim('danceRight');

			case 'nogf-crucified':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('sky/nogf');
				frames = tex;
				animation.addByIndices('sad', 'GF idle', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF idle', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF idle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('sad', 0, -9);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
				
				playAnim('danceRight');

			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('characters/gfChristmas');
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

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-car':
				tex = Paths.getSparrowAtlas('characters/gfCar');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'dalia-car':
				tex = Paths.getSparrowAtlas('characters/daliaCar');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'holo-cart':
				tex = Paths.getSparrowAtlas('characters/holoCart');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 120, 10);
				addOffset('danceRight', 120, 10);

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/gfPixel');
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

			case 'gf-tankman-pixel':
				tex = Paths.getSparrowAtlas('characters/gfTankmanPixel');
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

			case 'gf-pixel-mario':
				tex = Paths.getSparrowAtlas('characters/gfPixelMario');
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

			case 'amy-pixel-mario':
				tex = Paths.getSparrowAtlas('characters/amyPixelMario');
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

			case 'piper-pixel-mario':
				tex = Paths.getSparrowAtlas('characters/piperPixelMario');
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

			case 'piper-pixeld2':
				tex = Paths.getSparrowAtlas('characters/piperPixeld2');
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

			case 'gf-pixel-neon':
				tex = Paths.getSparrowAtlas('characters/gfPixelNeon');
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

			case 'gf-playtime':
				tex = Paths.getSparrowAtlas('characters/gfPlaytime');
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

			case 'gf-pixeld4':
				tex = Paths.getSparrowAtlas('characters/gfPixeld4');
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

			case 'gf-pixeld4BSide':
				tex = Paths.getSparrowAtlas('characters/gfPixeld4BSide');
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

			case 'nogf-pixel':
				tex = Paths.getSparrowAtlas('characters/nogfPixel');
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

			case 'gf-edgeworth-pixel':
				tex = Paths.getSparrowAtlas('characters/gfEdgeworthPixel');
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

			case 'gf-flowey':
				tex = Paths.getSparrowAtlas('characters/gfFlowey');
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

			case 'miku':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/ev_miku_assets');
				frames = tex;
				animation.addByPrefix('idle', 'Miku idle dance', 24);
				animation.addByPrefix('singUP', 'Miku Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Miku Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Miku Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Miku Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", 14, 50);
				addOffset("singRIGHT", -20, 27);
				addOffset("singLEFT", 25, 5);
				addOffset("singDOWN", -17, -37);

				playAnim('idle');

			case 'miku-mad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/ev_miku_mad');
				frames = tex;
				animation.addByPrefix('idle', 'Miku idle dance', 24);
				animation.addByPrefix('idle-alt', 'Miku idle dance', 24);
				animation.addByPrefix('singUP', 'Miku Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Miku Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Miku Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Miku Sing Note LEFT', 24);
				animation.addByPrefix('singUP-alt', 'Miku Scream Sing Note UP', 24);
				animation.addByPrefix('singRIGHT-alt', 'Miku Scream Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN-alt', 'Miku Scream Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT-alt', 'Miku Scream Sing Note LEFT', 24);

				addOffset('idle');
				addOffset('idle-alt');
				addOffset("singUP", 2, 0);
				addOffset("singRIGHT", -20, 0);
				addOffset("singLEFT", 40, 0);
				addOffset("singDOWN", 12, 0);
				addOffset("singUP-alt", 10, 0);
				addOffset("singRIGHT-alt", -22, 0);
				addOffset("singLEFT-alt", 45, 0);
				addOffset("singDOWN-alt", 15, 0);

				playAnim('idle');

			case 'miku-mad-christmas':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/ev_miku_mad_christmas');
				frames = tex;
				animation.addByPrefix('idle', 'Miku idle dance', 24);
				animation.addByPrefix('idle-alt', 'Miku idle dance', 24);
				animation.addByPrefix('singUP', 'Miku Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Miku Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Miku Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Miku Sing Note LEFT', 24);
				animation.addByPrefix('singUP-alt', 'Miku Scream Sing Note UP', 24);
				animation.addByPrefix('singRIGHT-alt', 'Miku Scream Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN-alt', 'Miku Scream Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT-alt', 'Miku Scream Sing Note LEFT', 24);

				addOffset('idle');
				addOffset('idle-alt');
				addOffset("singUP", 2, 0);
				addOffset("singRIGHT", -20, 0);
				addOffset("singLEFT", 40, 0);
				addOffset("singDOWN", 12, 0);
				addOffset("singUP-alt", 10, 0);
				addOffset("singRIGHT-alt", -22, 0);
				addOffset("singLEFT-alt", 45, 0);
				addOffset("singDOWN-alt", 15, 0);

				playAnim('idle');

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
				frames = tex;
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

			case 'rebecca':
				// rebecca ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/rebecca_asset');
				frames = tex;
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

			case 'henry':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/henry');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -26, 50);
					addOffset("singRIGHT", -70, 10);
					addOffset("singLEFT", 0, 27);
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

				setGraphicSize(Std.int(width * 1.3));
				updateHitbox();

				playAnim('idle');

			case 'shaggy':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/shaggy');
				frames = tex;
				animation.addByPrefix('idle', 'shaggy_idle', 24);
				animation.addByPrefix('singUP', 'shaggy_up', 20);
				animation.addByPrefix('singRIGHT', 'shaggy_right', 20);
				animation.addByPrefix('singDOWN', 'shaggy_down', 24);
				animation.addByPrefix('singLEFT', 'shaggy_left', 24);

				addOffset('idle');
				addOffset("singUP", -6, 0);
				addOffset("singRIGHT", -20, -40);
				addOffset("singLEFT", 100, -120);
				addOffset("singDOWN", 0, -170);

				playAnim('idle');

			case 'hd-spirit':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/HD_SPIRIT');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

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
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
				}
			
				playAnim('idle');

			case 'lila':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/lila');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('idle-alt', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);
				animation.addByPrefix('singDOWN-alt', 'Dad Clear Throat', 24);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", -12, 50);
					addOffset("singRIGHT", -40, 10);
					addOffset("singLEFT", 40, 27);
					addOffset("singDOWN", 40, -30);
					addOffset("singDOWN-alt", 40, -30);
				}
				else
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
					addOffset("singDOWN-alt", 0, -30);
				}
				
				playAnim('idle');

			case 'knuckles':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/knuckles');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('idle-alt', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singDOWN-alt', 'Knuckles Oh No', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

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

			case 'kapi':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/KAPI');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

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

			case 'agoti':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/AGOTI');
				frames = tex;
				animation.addByPrefix('idle', 'Agoti_Idle', 24);
				animation.addByPrefix('singUP', 'Agoti_Up', 24);
				animation.addByPrefix('singRIGHT', 'Agoti_Right', 24);
				animation.addByPrefix('singDOWN', 'Agoti_Down', 24);
				animation.addByPrefix('singLEFT', 'Agoti_Left', 24);

				addOffset('idle');
				addOffset("singUP", 25, 60);
				addOffset("singRIGHT", 80, -53);
				addOffset("singLEFT", 150, 20);
				addOffset("singDOWN", 40, -200);

				playAnim('idle');

			case 'agoti-mad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/AGOTI-MAD');
				frames = tex;
				animation.addByPrefix('idle', 'Angry_Agoti_Idle', 24);
				animation.addByPrefix('singUP', 'Angry_Agoti_Up', 24);
				animation.addByPrefix('singRIGHT', 'Angry_Agoti_Right', 24);
				animation.addByPrefix('singDOWN', 'Angry_Agoti_Down', 24);
				animation.addByPrefix('singLEFT', 'Angry_Agoti_Left', 24);

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

			case 'agoti-glitcher':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/AGOTI-GLITCHER');
				frames = tex;
				animation.addByPrefix('idle', 'Angry_Agoti_Idle', 24);
				animation.addByPrefix('singUP', 'Angry_Agoti_Up', 24);
				animation.addByPrefix('singRIGHT', 'Angry_Agoti_Right', 24);
				animation.addByPrefix('singDOWN', 'Angry_Agoti_Down', 24);
				animation.addByPrefix('singLEFT', 'Angry_Agoti_Left', 24);

				addOffset('idle');
				addOffset("singUP", 55, 150);
				addOffset("singRIGHT", 15, -5);
				addOffset("singLEFT", 140, -30);
				addOffset("singDOWN", 50, -130);

				playAnim('idle');

			case 'agoti-wire':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/AGOTI-WIRE');
				frames = tex;
				animation.addByPrefix('idle', 'Angry_Agoti_Idle', 24);
				animation.addByPrefix('singUP', 'Angry_Agoti_Up', 24);
				animation.addByPrefix('singRIGHT', 'Angry_Agoti_Right', 24);
				animation.addByPrefix('singDOWN', 'Angry_Agoti_Down', 24);
				animation.addByPrefix('singLEFT', 'Angry_Agoti_Left', 24);

				addOffset('idle');
				addOffset("singUP", 55, 150);
				addOffset("singRIGHT", 15, -5);
				addOffset("singLEFT", 140, -30);
				addOffset("singDOWN", 50, -130);

				playAnim('idle');

			case 'tabi':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/TABI');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('idle-alt', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);
				animation.addByPrefix('singUP-alt', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT-alt', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN-alt', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT-alt', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset('idle-alt');
				addOffset("singUP", 44, 50);
				addOffset("singRIGHT", -15, 11);
				addOffset("singLEFT", 104, -28);
				addOffset("singDOWN", -5, -108);
				addOffset("singUP-alt", 44, 50);
				addOffset("singRIGHT-alt", -15, 11);
				addOffset("singLEFT-alt", 104, -28);
				addOffset("singDOWN-alt", -5, -108);

				playAnim('idle');

			case 'tabi-glitcher':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/TABI_glitcher');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('idle-alt', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);
				animation.addByPrefix('singUP-alt', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT-alt', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN-alt', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT-alt', 'Dad Sing Note LEFT', 24);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", 44, 50);
					addOffset("singRIGHT", 34, -28);
					addOffset("singLEFT", 85, -21);
					addOffset("singDOWN", 45, -108);
				}

				else
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", 44, 50);
					addOffset("singRIGHT", -15, 11);
					addOffset("singLEFT", 104, -28);
					addOffset("singDOWN", -5, -108);
				}
				
				playAnim('idle');

			case 'tabi-wire':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/TABI_WIRE');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('idle-alt', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);
				animation.addByPrefix('singUP-alt', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT-alt', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN-alt', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT-alt', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset('idle-alt');
				addOffset("singUP", 44, 50);
				addOffset("singRIGHT", -15, 11);
				addOffset("singLEFT", 104, -28);
				addOffset("singDOWN", -5, -108);
				addOffset("singUP-alt", 44, 50);
				addOffset("singRIGHT-alt", -15, 11);
				addOffset("singLEFT-alt", 104, -28);
				addOffset("singDOWN-alt", -5, -108);

				playAnim('idle');

			case 'tabi-crazy':
				frames = Paths.getSparrowAtlas('characters/MadTabi');
				animation.addByPrefix('idle', 'MadTabiIdle', 24, false);
				animation.addByPrefix('singUP', 'MadTabiUp', 24, false);
				animation.addByPrefix('singDOWN', 'MadTabiDown', 24, false);
				animation.addByPrefix('singLEFT', 'MadTabiLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'MadTabiRight', 24, false);

				addOffset('idle');

				addOffset("singUP", 59, 156);
				addOffset("singRIGHT", -15, -19);
				addOffset("singLEFT", 184, -5);
				addOffset("singDOWN", -5, -30);

				playAnim('idle');

			case 'matt':
				tex = Paths.getSparrowAtlas('characters/matt_assets');
				frames = tex;
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

			case 'tricky':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/tricky');
				frames = tex;
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

			case 'zardy':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/Zardy');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				playAnim('idle');

			case 'liz':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/liz_assets');
				frames = tex;
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

			case 'tord':
				tex = Paths.getSparrowAtlas('characters/tord_assets');
				frames = tex;

				animation.addByPrefix('idle', "tord idle", 24, false);
				animation.addByPrefix('singUP', "tord up", 24, false);
				animation.addByPrefix('singDOWN', "tord down", 24, false);
				animation.addByPrefix('singLEFT', 'tord left', 24, false);
				animation.addByPrefix('singRIGHT', 'tord right', 24, false);

				addOffset('idle');
				addOffset("singDOWN",-4,-21);
				addOffset("singRIGHT",-30,-13);
				addOffset("singUP",9,21);
				addOffset("singLEFT",20,-17);

				playAnim('idle');

			case 'tom':
				tex = Paths.getSparrowAtlas('characters/tom_assets');
				frames = tex;

				animation.addByPrefix('idle', "tord idle", 24, false);
				animation.addByPrefix('idle-alt', "tord idle", 24, false);
				animation.addByPrefix('singUP', "tord up", 24, false);
				animation.addByPrefix('singDOWN', "tord down", 24, false);
				animation.addByPrefix('singLEFT', 'tord left', 24, false);
				animation.addByPrefix('singRIGHT', 'tord right', 24, false);
				animation.addByPrefix('singLEFT-alt', "tord ugh", 24, false);

				addOffset('idle');
				addOffset('idle-alt');
				addOffset("singDOWN",-4,-21);
				addOffset("singLEFT-alt",80,80);
				addOffset("singRIGHT",-30,-13);
				addOffset("singUP",9,21);
				addOffset("singLEFT",20,-17);

				playAnim('idle');	

			case 'hex':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/hex');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT0', 24, false);
				animation.addByPrefix('singUP-alt', 'Dad Jump', 24, false);
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
					addOffset("singUP-alt", 0, 200);
				}	

				else
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
					addOffset("singUP-alt", 0, 200);
				}	

				playAnim('idle');

			case 'hex-virus':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/Hex_Virus');
				frames = tex;
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
					addOffset("singUP", -12, 50);
					addOffset("singRIGHT", -40, 10);
					addOffset("singLEFT", 40, 27);
					addOffset("singDOWN", 40, -30);
					addOffset("singUP-alt", 0, 200);
				}	

				else
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
					addOffset("singUP-alt", 0, 200);
				}	

				playAnim('idle');

			case 'hex-bw':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/bw/hex');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT0', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT0', 24);
				animation.addByPrefix('wink', 'Dad Wink', 24);
				animation.addByPrefix('idle-alt', 'Dad idle dance', 24);

				if (isPlayer)
				{
					animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT Purple', 24);
					animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT Red', 24);
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

			case 'hd-senpai':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/HD_SENPAIANGRY');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Dad Die', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Dad UGH', 24, false);
				animation.addByPrefix('idle-alt', 'Dad idle dance', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", -12, 50);
					addOffset("singRIGHT", -40, 10);
					addOffset("singLEFT", 40, 27);
					addOffset("singDOWN", 40, -30);
					addOffset("singUPmiss", -12, 50);
					addOffset("singRIGHTmiss", -40, 10);
					addOffset("singLEFTmiss", 40, 27);
					addOffset("singDOWNmiss", 40, -30);
					addOffset("singLEFT-alt", -40, 10);
					addOffset("singDOWN-alt", 40, -30);
				}
				else
				{		
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
					addOffset("singUPmiss", -6, 50);
					addOffset("singRIGHTmiss", 0, 27);
					addOffset("singLEFTmiss", -10, 10);
					addOffset("singDOWNmiss", 0, -30);
					addOffset("singLEFT-alt", -10, 10);
					addOffset("singDOWN-alt", 0, -30);
				}		

				playAnim('idle');

			case 'hd-senpai-bw':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/bw/HD_SENPAIANGRY');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);
				animation.addByPrefix('singDOWN-alt', 'Dad Die', 24);
				animation.addByPrefix('singLEFT-alt', 'Dad UGH', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);
				addOffset("singLEFT-alt", -10, 10);
				addOffset("singDOWN-alt", 0, -30);

				playAnim('idle');

			case 'brother':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/brother');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

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
				tex = Paths.getSparrowAtlas('characters/sunday_assets');
				frames = tex;
				animation.addByPrefix('idle-alt', 'sunday alt idle', 24, true);
				animation.addByPrefix('idle', 'sunday idle', 24, true);
				animation.addByPrefix('singUP', 'sunday up', 24, false);
				animation.addByPrefix('singUP-alt', 'sunday alt up', 24, false);
				animation.addByPrefix('singDOWN', 'sunday down', 24, false);
				animation.addByPrefix('singLEFT', 'sunday left', 24, false);
				animation.addByPrefix('singRIGHT', 'sunday right', 24, false);

				addOffset('idle',1,1);
				addOffset('idle-alt',1,1);
				addOffset("singDOWN", 157, -27);
				addOffset("singRIGHT", -71,-10);
				addOffset("singUP", 137, 147);
				addOffset("singUP-alt", 137, 147);
				addOffset("singLEFT", 39,-1);	
				
				if (PlayState.SONG.song.toLowerCase() == "valentine")
				{
					playAnim('idle-alt');
				}else
				{
					playAnim('idle');
				}

			case 'pompom-mad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/pompommad_assets');
				frames = tex;
				animation.addByPrefix('idle', 'pompom mad idle', 24);
				animation.addByPrefix('singUP', 'pompom mad up', 24);
				animation.addByPrefix('singRIGHT', 'pompom mad right', 24);
				animation.addByPrefix('singDOWN', 'pompom mad down', 24);
				animation.addByPrefix('singLEFT', 'pompom mad left', 24);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 20, 27);
					addOffset("singLEFT", -30, 10);
					addOffset("singDOWN", 0, -30);
				}

				else
				{
					addOffset('idle');
					addOffset("singUP", -25, 10);
					addOffset("singRIGHT", 10, -45);
					addOffset("singLEFT", -12, -2);
					addOffset("singDOWN", -15, -75);
				}
				
				playAnim('idle');

			case 'hd-senpaiangry':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/HD_SENPAIMAD');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

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
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
				}		

				playAnim('idle');	

			case 'bf-carol':
				tex = Paths.getSparrowAtlas('characters/carol');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				if (isPlayer)
					{
						animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
						animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
					}
				else
					{
						// Need to be flipped! REDO THIS LATER!
						animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
						animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
					}	
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

			case 'bf-frisk':
				tex = Paths.getSparrowAtlas('characters/frisk');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				if (isPlayer)
					{
						animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
						animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
					}
				else
					{
						// Need to be flipped! REDO THIS LATER!
						animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
						animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
					}	
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
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'garcello':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/garcello_assets');
				frames = tex;
					animation.addByPrefix('idle', 'garcello idle dance', 24, false);
					animation.addByPrefix('idle-alt', 'garcello idle dance', 24, false);
					animation.addByPrefix('singUP', 'garcello Sing Note UP', 24, false);
					animation.addByPrefix('singRIGHT', 'garcello Sing Note RIGHT', 24, false);
					animation.addByPrefix('singDOWN', 'garcello Sing Note DOWN', 24, false);
					animation.addByPrefix('singLEFT', 'garcello Sing Note LEFT', 24, false);
				addOffset('idle');
				addOffset('idle-alt');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				playAnim('idle');

			case 'tom2':
				tex = Paths.getSparrowAtlas('characters/tom_assets_2');
				frames = tex;
					animation.addByPrefix('idle', 'garcello idle dance', 24, false);
					animation.addByPrefix('singUP', 'garcello Sing Note UP', 24, false);
					animation.addByPrefix('singRIGHT', 'garcello Sing Note RIGHT', 24, false);
					animation.addByPrefix('singDOWN', 'garcello Sing Note DOWN', 24, false);
					animation.addByPrefix('singLEFT', 'garcello Sing Note LEFT', 24, false);
					animation.addByPrefix('lame', 'garcello coolguy', 24, false);
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("lame");

				playAnim('idle');

			case 'kou':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/Kou_FNF_assetss');
				frames = tex;
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

			case 'senpaighosty':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/senpaighosty_assets');
				frames = tex;
					animation.addByPrefix('idle', 'garcello idle dance', 24, false);
					animation.addByPrefix('singUP', 'garcello Sing Note UP', 24, false);
					animation.addByPrefix('singRIGHT', 'garcello Sing Note RIGHT', 24, false);
					animation.addByPrefix('singDOWN', 'garcello Sing Note DOWN', 24,  false);
					animation.addByPrefix('singLEFT', 'garcello Sing Note LEFT', 24, false);
					animation.addByPrefix('disappear', 'garcello coolguy', 24, false);
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("disappear");

				playAnim('idle');	
			
			case 'garcellotired':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/garcellotired_assets');
				frames = tex;
					animation.addByPrefix('idle', 'garcellotired idle dance', 24, false);
					animation.addByPrefix('idle-alt', 'garcellotired idle dance', 24, false);
					animation.addByPrefix('singUP', 'garcellotired Sing Note UP', 24, false);
					animation.addByPrefix('singRIGHT', 'garcellotired Sing Note RIGHT', 24, false);
					animation.addByPrefix('singDOWN', 'garcellotired Sing Note DOWN', 24, false);
					animation.addByPrefix('singLEFT', 'garcellotired Sing Note LEFT', 24, false);
					animation.addByPrefix('singUP-alt', 'garcellotired Sing Note UP', 24, false);
					animation.addByPrefix('singRIGHT-alt', 'garcellotired Sing Note RIGHT', 24, false);
					animation.addByPrefix('singLEFT-alt', 'garcellotired Sing Note LEFT', 24, false);
                    animation.addByPrefix('singDOWN-alt', 'garcellotired cough', 24, false);

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

				playAnim('idle');

			case 'tord2':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/tord_assets_2');
				frames = tex;
					animation.addByPrefix('idle', 'garcellotired idle dance', 24);
					animation.addByPrefix('idle-alt', 'garcellotired idle dance', 24);
					animation.addByPrefix('singUP', 'garcellotired Sing Note UP', 24);
					animation.addByPrefix('singRIGHT', 'garcellotired Sing Note RIGHT', 24);
					animation.addByPrefix('singDOWN', 'garcellotired Sing Note DOWN', 24);
					animation.addByPrefix('singLEFT', 'garcellotired Sing Note LEFT', 24);
					animation.addByPrefix('singUP-alt', 'garcellotired Sing Note UP', 24);
					animation.addByPrefix('singRIGHT-alt', 'garcellotired Sing Note RIGHT', 24);
					animation.addByPrefix('singLEFT-alt', 'garcellotired Sing Note LEFT', 24);
                    animation.addByPrefix('singDOWN-alt', 'garcellotired cough', 24);

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

				playAnim('idle');
				
			
			case 'eddsworld-switch':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/eddsworld_switch');
				frames = tex;
					animation.addByPrefix('idle', 'garcellotired idle dance', 24);
					animation.addByPrefix('singUP', 'garcellotired Sing Note UP', 24);
					animation.addByPrefix('singRIGHT', 'garcellotired Sing Note RIGHT', 24);
					animation.addByPrefix('singDOWN', 'garcellotired Sing Note DOWN', 24);
					animation.addByPrefix('singLEFT', 'garcellotired Sing Note LEFT', 24);
					animation.addByPrefix('singUP-alt', 'garcellotired Sing Note UP', 24);
					animation.addByPrefix('singRIGHT-alt', 'garcellotired Sing Note RIGHT', 24);
					animation.addByPrefix('singLEFT-alt', 'garcellotired Sing Note LEFT', 24);
                    animation.addByPrefix('singDOWN-alt', 'garcellotired cough', 24);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUP-alt");
				addOffset("singRIGHT-alt");
				addOffset("singLEFT-alt");
                addOffset("singDOWN-alt");

				playAnim('idle');

			case 'playable-garcello':
				tex = Paths.getSparrowAtlas('characters/playablegarcello_assets');
				frames = tex;
				animation.addByPrefix('idle', 'garcello idle player dance', 24, false);
				animation.addByPrefix('singUP', 'garcello Sing Player Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'garcello Sing Player Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'garcello Sing Player Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'garcello Sing Player Note LEFT', 24, false);

				addOffset('idle', -100, 0);
				addOffset("singUP", -100, 0);
				addOffset("singRIGHT", -100, 0);
				addOffset("singLEFT", -100, 0);
				addOffset("singDOWN", -100, 0);

				playAnim('idle');

			case 'whitty':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/WhittySprites');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24);
				animation.addByPrefix('idle-alt', 'Idle', 24);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24);
				animation.addByPrefix('singUP-alt', 'Whitty Ballistic', 24);

				addOffset('idle');
				addOffset('idle-alt');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);
				addOffset("singUP-alt", 690, 180);

				playAnim('idle');

			case 'whitty-bw':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/bw/WhittySprites');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24);
				animation.addByPrefix('idle-alt', 'Idle', 24);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24);
				animation.addByPrefix('singUP-alt', 'Whitty Ballistic', 24);

				addOffset('idle');
				addOffset('idle-alt');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);
				addOffset("singUP-alt", 690, 180);

				playAnim('idle');

			case 'whittyCrazy':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/WhittyCrazy');
				frames = tex;
				animation.addByPrefix('idle', 'Whitty idle dance', 24);
				animation.addByPrefix('singUP', 'Whitty Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'whitty sing note right', 24);
				animation.addByPrefix('singDOWN', 'Whitty Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Whitty Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", 5, 110);
				addOffset("singRIGHT", 110, -75);
				addOffset("singLEFT", 60, 20);
				addOffset("singDOWN", 130, -130);

				playAnim('idle');
			case 'spooky':
				tex = Paths.getSparrowAtlas('characters/spooky_kids_assets');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);

				playAnim('danceRight');

			case 'spooky-pixel':
				tex = Paths.getSparrowAtlas('characters/spooky_pixel');
				frames = tex;
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
					addOffset("singLEFT", 100, -15	);
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
				tex = Paths.getSparrowAtlas('characters/momi_assets');
				frames = tex;
				animation.addByIndices('danceLeft', 'momi idle',[0,1,2,3,4],"", 24, false);
				animation.addByIndices('danceLeft-alt', 'momi alt idle',[0,1,2,3,4],"", 24, false);
				animation.addByIndices('danceRight', 'momi idle',[8,9,10,11,12],"", 24, false);
				animation.addByIndices('danceRight-alt', 'momi alt idle',[8,9,10,11,12],"", 24, false);
				
				animation.addByPrefix('singUP-alt', 'momi up', 24, false);
				animation.addByPrefix('singDOWN-alt', 'momi down', 24, false);
				animation.addByPrefix('singLEFT-alt', 'momi left', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'momi right', 24, false);
				
				animation.addByPrefix('singUP', 'momi up', 24, false);
				animation.addByPrefix('singDOWN', 'momi down', 24, false);
				animation.addByPrefix('singLEFT', 'momi left', 24, false);
				animation.addByPrefix('singRIGHT', 'momi right', 24, false);
				
				animation.addByPrefix('ah', 'momi ah', 24, false);
				animation.addByPrefix('ah-charged', 'momi charge ah', 24, true);
				animation.addByPrefix('chu', 'momi chu', 24, false);
				animation.addByPrefix('chu-charged', 'momi charge chu', 24, false);

				addOffset('danceLeft');
				addOffset('danceLeft-alt');
				addOffset('danceRight');
				addOffset('danceRight-alt');
				
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				
				addOffset("ah");
				addOffset("chu");
				addOffset("ah-charged");
				addOffset("chu-charged");
				
				addOffset("singUP-alt");
				addOffset("singRIGHT-alt");
				addOffset("singLEFT-alt");
				addOffset("singDOWN-alt");
				playAnim('danceLeft');


			case 'gura-amelia':
				tex = Paths.getSparrowAtlas('characters/gura_amelia');
				frames = tex;
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
				animation.addByPrefix('singUP-alt', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singLEFT-alt', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'spooky sing right', 24, false);
				if (PlayState.SONG.song == 'Nerves')
				{
					animation.addByPrefix('singDOWN-alt', 'spooky sneeze', 24, false);
				}
				else
				{
					animation.addByPrefix('singDOWN-alt', 'spooky DOWN note', 24, false);
				}

				addOffset('danceLeft');
				addOffset('danceRight');

				if (isPlayer)
				{
					addOffset("singUP", -20, 26);
					addOffset("singDOWN", -50, -130);	
					addOffset("singLEFT", 50, -14);
					addOffset("singRIGHT", 0, -10);
					addOffset("singDOWNmiss", 50, -140);
					addOffset("singUPmiss", -20, 26);
					addOffset("singLEFTmiss", 50, -14);
					addOffset("singRIGHTmiss", 0, -10);
					addOffset("singUP-alt", -20, 26);
					addOffset("singLEFT-alt", 50, -14);
					addOffset("singRIGHT-alt", 0, -10);
					addOffset("ah", -20, 26);
					addOffset("chu", 50, -14);
					addOffset("ah-charged", -20, 26);
					addOffset("chu-charged", 50, -14);
					if (PlayState.SONG.song == 'Nerves')
					{
						addOffset("singDOWN-alt", -8, 198);
					}
					else
					{
						addOffset("singDOWN-alt", -50, -130);
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
					addOffset("singUP-alt", -20, 26);
					addOffset("singRIGHT-alt", -92, -17);
					addOffset("singLEFT-alt", 130, -10);
					if (PlayState.SONG.song == 'Nerves')
					{
						addOffset("singDOWN-alt", -8, 198);
					}
					else
					{
						addOffset("singDOWN-alt", 30, -150);
					}
				}

				playAnim('danceRight');

			case 'gura-amelia-bw':
				tex = Paths.getSparrowAtlas('characters/bw/gura_amelia');
				frames = tex;
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
				animation.addByIndices('danceLeft-alt', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight-alt', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);
				animation.addByPrefix('singDOWN-alt', 'Gura Sneeze', 24, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				if (isPlayer)
				{
					addOffset("singUP", -20, 26);
					addOffset("singLEFT", 50, -14);
					addOffset("singRIGHT", 0, -10);
					addOffset("singDOWNmiss", 50, -140);
					addOffset("singUPmiss", -20, 26);
					addOffset("singLEFTmiss", 50, -14);
					addOffset("singRIGHTmiss", 0, -10);
					addOffset("singDOWN", -50, -130);
					addOffset("singDOWN-alt", 15, 32);
				}
				else
				{
					addOffset("singUP", -20, 26);
					addOffset("singRIGHT", -130, -14);
					addOffset("singLEFT", 130, -10);
					addOffset("singDOWNmiss", 50, -140);
					addOffset("singUPmiss", -20, 26);
					addOffset("singRIGHTmiss", -130, -14);
					addOffset("singLEFTmiss", 130, -10);
					addOffset("singDOWN", -50, -130);
					addOffset("singDOWN-alt", 15, 32);
				}

				playAnim('danceRight');

			case 'mom':
				tex = Paths.getSparrowAtlas('characters/Mom_Assets');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle0", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose0", 24, false);
				animation.addByPrefix('singUPmiss', "Mom Up Pose MISS0", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE0", 24, false);
				animation.addByPrefix('singDOWNmiss', "MOM DOWN POSE MISS0", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Mom Left Pose MISS0', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Mom Pose Left MISS0', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -16, 71);
					addOffset("singLEFT", 250, -60);
					addOffset("singRIGHT", -50, -23);
					addOffset("singDOWN", 20, -160);
					addOffset("singUPmiss", -16, 71);
					addOffset("singLEFTmiss", 250, -60);
					addOffset("singRIGHTmiss", -50, -23);
					addOffset("singDOWNmiss", 20, -160);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", 14, 71);
					addOffset("singRIGHT", 10, -60);
					addOffset("singLEFT", 250, -23);
					addOffset("singDOWN", 20, -160);
					addOffset("singUPmiss", 14, 71);
					addOffset("singRIGHTmiss", 10, -60);
					addOffset("singLEFTmiss", 250, -23);
					addOffset("singDOWNmiss", 20, -160);
				}
				

				playAnim('idle');
			
			case 'anchor':
				tex = Paths.getSparrowAtlas('characters/anchorAssets');
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

			case 'anchor-bw':
				tex = Paths.getSparrowAtlas('characters/bw/anchorAssets');
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

			case 'bf-mom':
				tex = Paths.getSparrowAtlas('characters/mombf');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				if (!isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
					animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);
				}
				else
				{
					animation.addByPrefix('singRIGHT', 'Mom Left Pose', 24, false);
					animation.addByPrefix('singLEFT', 'Mom Pose Left', 24, false);
				}
				
				if (!isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", 14, 71);
					addOffset("singRIGHT", 10, -60);
					addOffset("singLEFT", 250, -23);
					addOffset("singDOWN", 20, -160);	
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

			case 'cassandra':
				tex = Paths.getSparrowAtlas('characters/cassandra');
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

			case 'cassandra-bw':
				tex = Paths.getSparrowAtlas('characters/bw/cassandra');
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
				tex = Paths.getSparrowAtlas('characters/sarvente_sheet');
				frames = tex;

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
				animation.addByPrefix('singUP-alt2', "SarvDarkUp", 24, false);
				animation.addByPrefix('singLEFT-alt2', 'SarvDarkLeft', 24, false);
				animation.addByPrefix('singRIGHT-alt2', 'SarvDarkRight', 24, false);
				animation.addByPrefix('singDOWN-alt2', "SarvDarkDown", 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset('idle-alt');
				addOffset("singUP-alt");
				addOffset("singRIGHT-alt");
				addOffset("singLEFT-alt");
				addOffset("singDOWN-alt");
				addOffset("singUP-alt2");
				addOffset("singRIGHT-alt2");
				addOffset("singLEFT-alt2");
				addOffset("singDOWN-alt2");

				playAnim('idle');

			case 'sky-mad':
				tex = Paths.getSparrowAtlas('characters/sky_mad_assets');
				frames = tex;

				animation.addByPrefix('idle', "sky mad idle", 24, false);
				animation.addByPrefix('singUP', "sky mad up", 24, false);
				animation.addByPrefix('singDOWN', "sky mad down", 24, false);
				animation.addByPrefix('singLEFT', 'sky mad left', 24, false);
				animation.addByPrefix('singRIGHT', 'sky mad right', 24, false);
				animation.addByPrefix('singUP-alt', "sky mad up", 24, false);
				animation.addByPrefix('singDOWN-alt', "sky mad down", 24, false);
				animation.addByPrefix('singLEFT-alt', 'sky mad left', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'sky mad right', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUP-alt");
				addOffset("singRIGHT-alt");
				addOffset("singLEFT-alt");
				addOffset("singDOWN-alt");

				playAnim('idle');

			case 'sarvente-lucifer':
				tex = Paths.getSparrowAtlas('characters/smokinhotbabe');
				frames = tex;

				animation.addByPrefix('idle', "LuciferSarvIdle", 24, false);
				animation.addByPrefix('singUP', "LuciferSarvUp", 24, false);
				animation.addByPrefix('singDOWN', "LuciferSarvDown", 24, false);
				animation.addByPrefix('singLEFT', 'LuciferSarvLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'LuciferSarvRight', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				playAnim('idle');

			case 'ruv':
				tex = Paths.getSparrowAtlas('characters/ruv_sheet');
				frames = tex;

				animation.addByPrefix('idle', "RuvIdle", 24, false);
				animation.addByPrefix('singUP', "RuvUp", 24, false);
				animation.addByPrefix('singDOWN', "RuvDown", 24, false);
				animation.addByPrefix('singLEFT', 'RuvLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'RuvRight', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT", 0, -50);
				addOffset("singDOWN", 0, -25);

				playAnim('idle');

			case 'selever':
				tex = Paths.getSparrowAtlas('characters/fuckboi_sheet');
				frames = tex;

				animation.addByPrefix('idle', "SelIdle", 24, false);
				animation.addByPrefix('singUP', "SelUp", 24, false);
				animation.addByPrefix('singDOWN', "SelDown", 24, false);
				animation.addByPrefix('singLEFT', 'SelLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'SelRight', 24, false);
				animation.addByPrefix('hey', 'SelHey', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("hey");

				playAnim('idle');

			case 'roro':
				tex = Paths.getSparrowAtlas('characters/roroAssets');
				frames = tex;

				animation.addByPrefix('idle', "roro Idle", 24, false);
				animation.addByPrefix('singUP', "roro Up Note", 24, false);
				animation.addByPrefix('singDOWN', "roro Down Note", 24, false);
				animation.addByPrefix('singLEFT', 'roro Left Note', 24, false);
				animation.addByPrefix('singRIGHT', 'roro Right Note', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				playAnim('idle');

			case 'roro-bw':
				tex = Paths.getSparrowAtlas('characters/bw/roroAssets');
				frames = tex;

				animation.addByPrefix('idle', "roro Idle", 24, false);
				animation.addByPrefix('singUP', "roro Up Note", 24, false);
				animation.addByPrefix('singDOWN', "roro Down Note", 24, false);
				animation.addByPrefix('singLEFT', 'roro Left Note', 24, false);
				animation.addByPrefix('singRIGHT', 'roro Right Note', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				playAnim('idle');

			case 'chara':
				tex = Paths.getSparrowAtlas('characters/chara');
				frames = tex;

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

			case 'exgf':
				tex = Paths.getSparrowAtlas('characters/exGF');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);
		
				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('characters/momCar');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');

			case 'coco':
				tex = Paths.getSparrowAtlas('characters/Coco_Assets');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				animation.addByPrefix('singUP-alt', 'Coco Laugh Up', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Coco Laugh Down', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Coco Laugh Left', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Coco Laugh Right', 24, false);

				addOffset('idle', 0, 15);
				addOffset("singUP", 35, 52);
				addOffset("singRIGHT", -30, -80);
				addOffset("singLEFT", 250, -52);
				addOffset("singDOWN", 20, -200);
				addOffset("singUP-alt", 35, 52);
				addOffset("singRIGHT-alt", -30, -80);
				addOffset("singLEFT-alt", 250, -52);
				addOffset("singDOWN-alt", 20, -200);

				playAnim('idle');

			case 'coco-car':
				tex = Paths.getSparrowAtlas('characters/cocoCar');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				animation.addByPrefix('singUP-alt', 'Coco Laugh Up', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Coco Laugh Down', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Coco Laugh Left', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Coco Laugh Right', 24, false);

				addOffset('idle', 0, 15);
				addOffset("singUP", 35, 52);
				addOffset("singRIGHT", -30, -80);
				addOffset("singLEFT", 250, -52);
				addOffset("singDOWN", 20, -200);
				addOffset("singUP-alt", 35, 52);
				addOffset("singRIGHT-alt", -30, -80);
				addOffset("singLEFT-alt", 250, -52);
				addOffset("singDOWN-alt", 20, -200);

				playAnim('idle');

			case 'monster':
				tex = Paths.getSparrowAtlas('characters/Monster_Assets');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster left note', 24, false);
				animation.addByPrefix('singLEFT', 'Monster Right note', 24, false);

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
					addOffset("singUP", -20, 50);
					addOffset("singLEFT", -51);
					addOffset("singRIGHT", -30);
					addOffset("singDOWN", -40, -94);				
				}

				playAnim('idle');
				
			case 'haachama':
				tex = Paths.getSparrowAtlas('characters/Haachama_Assets');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle', 0, -70);
				addOffset("singUP", 5, -23);
				addOffset("singRIGHT", -61, -84);
				addOffset("singLEFT", 0, -70);
				addOffset("singDOWN", 20, -130);
				playAnim('idle');

			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('characters/monsterChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster left note', 24, false);
				animation.addByPrefix('singLEFT', 'Monster Right note', 24, false);

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
					addOffset("singUP", -20, 50);
					addOffset("singLEFT", -51);
					addOffset("singRIGHT", -30);
					addOffset("singDOWN", -40, -94);				
				}

			case 'drunk-annie':
				tex = Paths.getSparrowAtlas('characters/drunkAnnie');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);
				playAnim('idle');

			case 'pico':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('idle-alt', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Pico Shoot0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", 20, 20);
					addOffset("singLEFT", 80, -15);
					addOffset("singLEFT-alt", 80, -15);
					addOffset("singRIGHT", -45, 0);
					addOffset("singDOWN", 95, -90);
					addOffset("singDOWN-alt", 165, -90);
					addOffset("singUPmiss", 20, 60);
					addOffset("singLEFTmiss", 80, 20);
					addOffset("singRIGHTmiss", -40, 40);
					addOffset("singDOWNmiss", 105, -48);
				}
				else
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -68, -7);
					addOffset("singLEFT", 65, 9);
					addOffset("singLEFT-alt", 65, 9);
					addOffset("singDOWN", 200, -70);
					addOffset("singDOWN-alt", 130, -70);
					addOffset("singUPmiss", -19, 67);
					addOffset("singRIGHTmiss", -60, 41);
					addOffset("singLEFTmiss", 62, 64);
					addOffset("singDOWNmiss", 210, -28);
				}

				playAnim('idle');

				flipX = true;

			case 'pico-m':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss-m');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('idle-alt', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Pico Shoot0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", 20, 20);
					addOffset("singLEFT", 80, -15);
					addOffset("singLEFT-alt", 80, -15);
					addOffset("singRIGHT", -45, 0);
					addOffset("singDOWN", 95, -90);
					addOffset("singDOWN-alt", 165, -90);
					addOffset("singUPmiss", 20, 60);
					addOffset("singLEFTmiss", 80, 20);
					addOffset("singRIGHTmiss", -40, 40);
					addOffset("singDOWNmiss", 105, -48);
				}
				else
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -68, -7);
					addOffset("singLEFT", 65, 9);
					addOffset("singLEFT-alt", 65, 9);
					addOffset("singDOWN", 200, -70);
					addOffset("singDOWN-alt", 130, -70);
					addOffset("singUPmiss", -19, 67);
					addOffset("singRIGHTmiss", -60, 41);
					addOffset("singLEFTmiss", 62, 64);
					addOffset("singDOWNmiss", 210, -28);
				}

				playAnim('idle');

				flipX = true;

			case 'pico-bw':
				tex = Paths.getSparrowAtlas('characters/bw/Pico_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('idle-alt', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Pico Shoot0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", 20, 20);
					addOffset("singLEFT", 80, -15);
					addOffset("singLEFT-alt", 80, -15);
					addOffset("singRIGHT", -45, 0);
					addOffset("singDOWN", 95, -90);
					addOffset("singDOWN-alt", 165, -90);
					addOffset("singUPmiss", 20, 60);
					addOffset("singLEFTmiss", 80, 20);
					addOffset("singRIGHTmiss", -40, 40);
					addOffset("singDOWNmiss", 105, -48);
				}
				else
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -68, -7);
					addOffset("singLEFT", 65, 9);
					addOffset("singLEFT-alt", 65, 9);
					addOffset("singDOWN", 200, -70);
					addOffset("singDOWN-alt", 130, -70);
					addOffset("singUPmiss", -19, 67);
					addOffset("singRIGHTmiss", -60, 41);
					addOffset("singLEFTmiss", 62, 64);
					addOffset("singDOWNmiss", 210, -28);
				}

				playAnim('idle');

				flipX = true;

			case 'annie-bw':
				tex = Paths.getSparrowAtlas('characters/bw/annie');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('idle-alt', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Pico Shoot0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", 20, 20);
					addOffset("singLEFT", 80, -15);
					addOffset("singLEFT-alt", 80, -15);
					addOffset("singRIGHT", -45, 0);
					addOffset("singDOWN", 95, -90);
					addOffset("singDOWN-alt", 165, -90);
					addOffset("singUPmiss", 20, 60);
					addOffset("singLEFTmiss", 80, 20);
					addOffset("singRIGHTmiss", -40, 40);
					addOffset("singDOWNmiss", 105, -48);
				}
				else
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -68, -7);
					addOffset("singLEFT", 65, 9);
					addOffset("singLEFT-alt", 65, 9);
					addOffset("singDOWN", 200, -70);
					addOffset("singDOWN-alt", 130, -70);
					addOffset("singUPmiss", -19, 67);
					addOffset("singRIGHTmiss", -60, 41);
					addOffset("singLEFTmiss", 62, 64);
					addOffset("singDOWNmiss", 210, -28);
				}

				playAnim('idle');

				flipX = true;

			case 'crazygf':
				tex = Paths.getSparrowAtlas('characters/crazyGF');
				frames = tex;
				animation.addByPrefix('idle', "gf Idle Dance", 24);
				animation.addByPrefix('singUP', 'gf Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'gf Down Note0', 24, false);
				animation.addByPrefix('singRIGHT', 'gf Note Right0', 24, false);
				animation.addByPrefix('singLEFT', 'gf NOTE LEFT0', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", -5, 5);
					addOffset("singLEFT", 65, 0);
					addOffset("singRIGHT", 65, 10);
					addOffset("singDOWN", 30, 10);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", 5, 5);
					addOffset("singLEFT", 35, 0);
					addOffset("singRIGHT", 65, 10);
					addOffset("singDOWN", -30, 10);
				}

				playAnim('idle');

				flipX = true;


			case 'nene':
				tex = Paths.getSparrowAtlas('characters/Nene_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Pico Shoot0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", 20, 20);
					addOffset("singLEFT", 80, -15);
					addOffset("singLEFT-alt", 80, -15);
					addOffset("singRIGHT", -45, 0);
					addOffset("singDOWN", 95, -90);
					addOffset("singDOWN-alt", 185, -100);
					addOffset("singUPmiss", 20, 60);
					addOffset("singLEFTmiss", 80, 20);
					addOffset("singRIGHTmiss", -40, 40);
					addOffset("singDOWNmiss", 105, -48);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -68, -7);
					addOffset("singLEFT", 65, 9);
					addOffset("singLEFT-alt", 65, 9);
					addOffset("singDOWN", 200, -70);
					addOffset("singDOWN-alt", 110, -80);
					addOffset("singUPmiss", -19, 67);
					addOffset("singRIGHTmiss", -60, 41);
					addOffset("singLEFTmiss", 62, 64);
					addOffset("singDOWNmiss", 210, -28);
				}

				playAnim('idle');

				flipX = true;

			case 'nene-bw':
				tex = Paths.getSparrowAtlas('characters/bw/Nene_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Pico Shoot0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", 20, 20);
					addOffset("singLEFT", 80, -15);
					addOffset("singLEFT-alt", 80, -15);
					addOffset("singRIGHT", -45, 0);
					addOffset("singDOWN", 95, -90);
					addOffset("singDOWN-alt", 185, -100);
					addOffset("singUPmiss", 20, 60);
					addOffset("singLEFTmiss", 80, 20);
					addOffset("singRIGHTmiss", -40, 40);
					addOffset("singDOWNmiss", 105, -48);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -68, -7);
					addOffset("singLEFT", 65, 9);
					addOffset("singLEFT-alt", 65, 9);
					addOffset("singDOWN", 200, -70);
					addOffset("singDOWN-alt", 110, -80);
					addOffset("singUPmiss", -19, 67);
					addOffset("singRIGHTmiss", -60, 41);
					addOffset("singLEFTmiss", 62, 64);
					addOffset("singDOWNmiss", 210, -28);
				}

				playAnim('idle');

				flipX = true;

			case 'botan':
				tex = Paths.getSparrowAtlas('characters/botan');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Pico Shoot0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", 20, 20);
					addOffset("singLEFT", 80, -15);
					addOffset("singLEFT-alt", 80, -15);
					addOffset("singRIGHT", -45, 0);
					addOffset("singDOWN", 95, -90);
					addOffset("singDOWN-alt", 185, -100);
					addOffset("singUPmiss", 20, 60);
					addOffset("singLEFTmiss", 80, 20);
					addOffset("singRIGHTmiss", -40, 40);
					addOffset("singDOWNmiss", 105, -48);
				}
				else
				{
					addOffset('idle');
					addOffset("singUP", -46, 18);
					addOffset("singRIGHT", -92, -11);
					addOffset("singLEFT", 19, -11);
					addOffset("singDOWN", 175, -114);
					addOffset("singUPmiss", -49, 17);
					addOffset("singRIGHTmiss", -93, 11);
					addOffset("singLEFTmiss", 18, 10);
					addOffset("singDOWNmiss", 175, -83);
					addOffset("singDOWN-alt", 110, -80);
				}

				playAnim('idle');

				flipX = true;

			case 'bf-annie':
				tex = Paths.getSparrowAtlas('characters/annie');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				if (isPlayer)
					{
						animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
						animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
					}
				else
					{
						// Need to be flipped! REDO THIS LATER!
						animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
						animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
					}
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

			case 'bf-exgf':
				tex = Paths.getSparrowAtlas('characters/playableexGF');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				if (isPlayer)
					{
						animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
						animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
					}
				else
					{
						// Need to be flipped! REDO THIS LATER!
						animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
						animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
					}
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

			case 'bf-sky':
				var tex = Paths.getSparrowAtlas('characters/sky_assets');
				frames = tex;
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

				if (!isPlayer)
					{
						animation.addByPrefix('singRIGHT', 'sky annoyed left', 24, false);
						animation.addByPrefix('singLEFT', 'sky annoyed right', 24, false);
						animation.addByPrefix('singRIGHTmiss', 'sky annoyed alt left', 24, false);
						animation.addByPrefix('singLEFTmiss', 'sky annoyed alt right', 24, false);
						animation.addByPrefix('singRIGHT-alt', 'sky annoyed alt left', 24, false);
						animation.addByPrefix('singLEFT-alt', 'sky annoyed alt right', 24, false);
					}
				else
					{
						animation.addByPrefix('singLEFT', 'sky annoyed left', 24, false);
						animation.addByPrefix('singRIGHT', 'sky annoyed right', 24, false);
						animation.addByPrefix('singLEFTmiss', 'sky annoyed alt left', 24, false);
						animation.addByPrefix('singRIGHTmiss', 'sky annoyed alt right', 24, false);
						animation.addByPrefix('singLEFT-alt', 'sky annoyed alt left', 24, false);
						animation.addByPrefix('singRIGHT-alt', 'sky annoyed alt right', 24, false);		
					}
				
				if (!isPlayer)
				{
					addOffset('danceLeft');
					addOffset('danceRight');
					addOffset("singUP");
					addOffset("singRIGHT");
					addOffset("singLEFT");
					addOffset("singDOWN");
					addOffset("singDOWN-alt");
					addOffset("singUP-alt");
					addOffset("singLEFT-alt");
					addOffset("singRIGHT-alt");
					addOffset('danceLeft-alt');
					addOffset('danceRight-alt');
					addOffset("singUPmiss");
					addOffset("singRIGHTmiss");
					addOffset("singLEFTmiss");
				}

				else
				{
					addOffset('danceLeft');
					addOffset('danceRight');
					addOffset("singUP");
					addOffset("singRIGHT", -50, 0);
					addOffset("singLEFT", 40, 0);
					addOffset("singDOWN");
					addOffset("singDOWN-alt");
					addOffset("singUP-alt");
					addOffset("singLEFT-alt", 40, 0);
					addOffset("singRIGHT-alt", -50, 0);
					addOffset('danceLeft-alt');
					addOffset('danceRight-alt');
					addOffset("singUPmiss");
					addOffset("singRIGHTmiss");
					addOffset("singLEFTmiss");
				}


				playAnim('danceRight');

				flipX = true;

			case 'tankman':
				tex = Paths.getSparrowAtlas('characters/tankmanCaptain');
				frames = tex;
				animation.addByPrefix('idle', "Tankman Idle Dance", 24, false);
				animation.addByPrefix('idle-alt', "Tankman Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'Tankman UP note', 24, false);
				animation.addByPrefix('singDOWN', 'Tankman DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'Tankman Right Note', 24, false);
				animation.addByPrefix('singRIGHT', 'Tankman Note Left', 24, false);
				animation.addByPrefix('singUP-alt', 'TANKMAN UGH', 24, false);
				animation.addByPrefix('singDOWN-alt', 'PRETTY GOOD', 24, false);

				addOffset('idle', -5);
				addOffset('idle-alt', -5);
				addOffset("singUP", 18, 46);
				addOffset("singLEFT", 75, -28);
				addOffset("singRIGHT", -30, -14);
				addOffset("singDOWN", 70, -100);
				addOffset("singUP-alt", -15, -15);
				addOffset("singDOWN-alt", 95, 15);

				playAnim('idle');

				flipX = true;

			case 'tankman-bw':
				tex = Paths.getSparrowAtlas('characters/bw/tankmanCaptain');
				frames = tex;
				animation.addByPrefix('idle', "Tankman Idle Dance", 24, false);
				animation.addByPrefix('idle-alt', "Tankman Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'Tankman UP note', 24, false);
				animation.addByPrefix('singDOWN', 'Tankman DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'Tankman Right Note', 24, false);
				animation.addByPrefix('singRIGHT', 'Tankman Note Left', 24, false);
				animation.addByPrefix('singUP-alt', 'TANKMAN UGH', 24, false);
				animation.addByPrefix('singDOWN-alt', 'PRETTY GOOD', 24, false);

				addOffset('idle', -5);
				addOffset('idle-alt', -5);
				addOffset("singUP", 18, 46);
				addOffset("singLEFT", 75, -28);
				addOffset("singRIGHT", -30, -14);
				addOffset("singDOWN", 70, -100);
				addOffset("singUP-alt", -15, -15);
				addOffset("singDOWN-alt", 95, 15);

				playAnim('idle');

				flipX = true;

			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND');
				frames = tex;
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

				if (!isPlayer)
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
		
				addOffset('idle', -5);
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
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'bf-m':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND-m');
				frames = tex;
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

				if (!isPlayer)
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
		
				addOffset('idle', -5);
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
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'bf-bw':
				var tex = Paths.getSparrowAtlas('characters/bw/BOYFRIEND');
				frames = tex;
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

				if (!isPlayer)
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
		
				addOffset('idle', -5);
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
				addOffset('scared', -4);

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

				if (!isPlayer)
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
		
				addOffset('idle', -5);
				addOffset("singUP", 20, 85);
				addOffset("singRIGHT", -88, 118);
				addOffset("singLEFT", 100, 380);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", 22, 123);
				addOffset("singLEFTmiss", 100, 380);
				addOffset("singRIGHTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);

				playAnim('idle');

				flipX = true;

			case 'bf-miku':
				var tex = Paths.getSparrowAtlas('characters/playable_miku');
				frames = tex;
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

				if (!isPlayer)
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
		
				addOffset('idle', -5);
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
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'bf-aloe':
				var tex = Paths.getSparrowAtlas('characters/ALOE');
				frames = tex;

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				if (!isPlayer)
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

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

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
				addOffset('firstDeath', 67, 7);
				addOffset('deathLoop', 66, 4);
				addOffset('deathConfirm', 67, 57);
				addOffset('scared', 16, 1);

				playAnim('idle');

				flipX = true;

			case 'bf-aloe-bw':
				var tex = Paths.getSparrowAtlas('characters/bw/ALOE');
				frames = tex;

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				if (!isPlayer)
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

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

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
				addOffset('firstDeath', 67, 7);
				addOffset('deathLoop', 66, 4);
				addOffset('deathConfirm', 67, 57);
				addOffset('scared', 16, 1);

				playAnim('idle');

				flipX = true;

			case 'bf-aloe-car':
				var tex = Paths.getSparrowAtlas('characters/aloeCar');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				if (!isPlayer)
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


			case 'bf1':
				var tex = Paths.getSparrowAtlas('characters/bf1');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
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

				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				}
				else
				{
					animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
				}

				addOffset('idle');
				addOffset("singUP", -30, 10);
				addOffset("singRIGHT", -27, -1);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -100);
				addOffset("singUPmiss", -7, 13);
				addOffset("singRIGHTmiss", -12, 22);
				addOffset("singLEFTmiss", -13, -2);
				addOffset("singDOWNmiss", 15, -100);
				addOffset("hey", -10, -2);
				addOffset('firstDeath', 67, 7);
				addOffset('deathLoop', 66, 4);
				addOffset('deathConfirm', 67, 57);
				addOffset('scared', 16, 1);

				playAnim('idle');

				flipX = true;

			case 'bf2':
				var tex = Paths.getSparrowAtlas('characters/bf2');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
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

				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				}
				else
				{
					animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
				}

				addOffset('idle', -5);
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
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'bf3':
				var tex = Paths.getSparrowAtlas('characters/bf3');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
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

				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				}
				else
				{
					animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
				}

				addOffset('idle', -5);
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
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'bf4':
				var tex = Paths.getSparrowAtlas('characters/bf4');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
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

				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				}
				else
				{
					animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
				}

				addOffset('idle', -5);
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
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'bf5':
				var tex = Paths.getSparrowAtlas('characters/bf5');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
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

				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				}
				else
				{
					animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
				}

				addOffset('idle', -5);
				addOffset("singUP", -29, 57);
				addOffset("singRIGHT", -28, 14);
				addOffset("singLEFT", -38, 13);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -39, 67);
				addOffset("singRIGHTmiss", -20, 41);
				addOffset("singLEFTmiss", -28, 14);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 1, -1);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'bf-lexi':
				var tex = Paths.getSparrowAtlas('characters/Lexi');
				frames = tex;
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

				if (!isPlayer)
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
		
				if (!isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", 20, 19);
					addOffset("singRIGHT", -32, -7);
					addOffset("singLEFT", 21, 1);
					addOffset("singDOWN", -15, -47);
					addOffset("singUPmiss", 30, 15);
					addOffset("singRIGHTmiss", 40, 10);
					addOffset("singLEFTmiss", -23, 15);
					addOffset("singDOWNmiss", -4, -31);
					addOffset("hey");
					addOffset('firstDeath', 5, 28);
					addOffset('deathLoop', 0, -5);
					addOffset('deathConfirm', 4, 27);
					addOffset('scared', 0, -5);
				}	
				else
				{
					addOffset('idle');
					addOffset("singUP", -20, 19);
					addOffset("singRIGHT", 32, -7);
					addOffset("singLEFT", -21, 1);
					addOffset("singDOWN", 15, -47);
					addOffset("singUPmiss", -7, 15);
					addOffset("singRIGHTmiss", -20, 10);
					addOffset("singLEFTmiss", 23, 15);
					addOffset("singDOWNmiss", 4, -31);
					addOffset("hey");
					addOffset('firstDeath', -5, 28);
					addOffset('deathLoop', 0, -5);
					addOffset('deathConfirm', -4, 27);
					addOffset('scared', 25, -2);
				}
					
				playAnim('idle');

				flipX = true;

			case 'bf-whitty':
				var tex = Paths.getSparrowAtlas('characters/playableWhitty');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
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

				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				}
				else
				{
					animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
				}
		
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				playAnim('idle');

				flipX = true;

			case 'bf-sans':
				var tex = Paths.getSparrowAtlas('characters/sans');
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

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
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
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'bf-gf':
				var tex = Paths.getSparrowAtlas('characters/playableGF');
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

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
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
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'bf-gf-demon':
				var tex = Paths.getSparrowAtlas('characters/playableGFdemon');
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

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
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
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;


			case 'bf-dad':
				var tex = Paths.getSparrowAtlas('characters/dadbf');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				playAnim('idle');

				flipX = true;

			case 'bf-blantad':
				var tex = Paths.getSparrowAtlas('characters/blantad');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);

				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				}
				else
				{
					animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
				}

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				playAnim('idle');

				flipX = true;


			case 'bf-sarv':
				var tex = Paths.getSparrowAtlas('characters/bfSarv');
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
	
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
	
				addOffset('idle', -5);
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
				addOffset('scared', -4);
	
				playAnim('idle');
	
				flipX = true;

			case 'bf-spooky':
				var tex = Paths.getSparrowAtlas('characters/bfspooky');
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

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
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
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('characters/bfChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				if (!isPlayer)
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

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);

				playAnim('idle');

				flipX = true;
		case 'bf-senpai':
				var tex = Paths.getSparrowAtlas('characters/playableSenpai');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				if (isPlayer)
					{
						animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
						animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
					}
				else
					{
						// Need to be flipped! REDO THIS LATER!
						animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
						animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
					}
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
				addOffset("singUP", -29, 27);				
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);

				playAnim('idle');

				flipX = true;

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('characters/bfChristmas');
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

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				var tex = Paths.getSparrowAtlas('characters/bfCar');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);		
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				if (!isPlayer)
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

				addOffset('idle');
				addOffset("singUP", 24, 56);
				addOffset("singRIGHT", 100, -7);
				addOffset("singLEFT", 15, -14);
				addOffset("singDOWN", 98, -90);
				playAnim('idle');

				flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/bfPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);
				if (!isPlayer)
				{
					animation.addByPrefix('singRIGHT', 'BF LEFT NOTE', 24, false);
					animation.addByPrefix('singLEFT', 'BF RIGHT NOTE', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF LEFT MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF RIGHT MISS', 24, false);
				}
				else
				{	
					animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
					animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				}

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

			case 'bf-senpai-pixel-angry':
				frames = Paths.getSparrowAtlas('characters/bfSenpaiPixelangry');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);
				if (!isPlayer)
				{
					animation.addByPrefix('singRIGHT', 'BF LEFT NOTE', 24, false);
					animation.addByPrefix('singLEFT', 'BF RIGHT NOTE', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF LEFT MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF RIGHT MISS', 24, false);
				}
				else
				{	
					animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
					animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				}

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

			case 'bf-senpai-pixel':
				frames = Paths.getSparrowAtlas('characters/bfSenpaiPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);
				if (!isPlayer)
				{
					animation.addByPrefix('singRIGHT', 'BF LEFT NOTE', 24, false);
					animation.addByPrefix('singLEFT', 'BF RIGHT NOTE', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF LEFT MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF RIGHT MISS', 24, false);
				}
				else
				{	
					animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
					animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				}

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

			case 'bob':
				tex = Paths.getSparrowAtlas('characters/bob_asset');
				frames = tex;
				animation.addByPrefix('idle', "bob_idle", 24);
				animation.addByPrefix('singUP', 'bob_UP', 24, false);
				animation.addByPrefix('singDOWN', 'bob_DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'bob_LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'bob_RIGHT', 24, false);

				addOffset('idle');

				playAnim('idle');

				flipX = true;

			case 'lane-pixel':
				frames = Paths.getSparrowAtlas('characters/Lane_Pixel_assets');
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
				tex = Paths.getSparrowAtlas('characters/gura_amelia_pixel');
				frames = tex;
				animation.addByPrefix('singUP', 'Spooky Pixel Up', 24, false);
				animation.addByPrefix('singDOWN', 'Spooky Pixel Down', 24, false);
				animation.addByPrefix('singLEFT', 'Spooky Pixel Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Spooky Pixel Right', 24, false);
				animation.addByIndices('danceLeft', 'Spooky Pixel Idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'Spooky Pixel Idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 40);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", 30, -140);

				setGraphicSize(Std.int(width * 5));
				updateHitbox();

				playAnim('danceRight');

				antialiasing = false;

			case 'bf-botan-pixel':
				frames = Paths.getSparrowAtlas('characters/bf-botanPixel');
				animation.addByPrefix('idle', 'Pico Pixel Idle', 24, false);
				animation.addByPrefix('singUP', 'Pico Pixel Up0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Pixel Down0', 24, false);
				animation.addByPrefix('singUPmiss', 'Pico Pixel Up Miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Pico Pixel Down Miss', 24, false);
				if (!isPlayer)
				{
					animation.addByPrefix('singRIGHT', 'Pico Pixel Left0', 24, false);
					animation.addByPrefix('singLEFT', 'Pico Pixel Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Pixel Left Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Pixel Right Miss', 24, false);
				}
				else
				{
					animation.addByPrefix('singLEFT', 'Pico Pixel Left0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Pixel Right0', 24, false);			
					animation.addByPrefix('singLEFTmiss', 'Pico Pixel Left Miss', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Pixel Right Miss', 24, false);
				}
				
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
				animation.addByPrefix('idle', 'Whitty Pixel Idle', 24, false);
				animation.addByPrefix('singUP', 'Whitty Pixel Up0', 24, false);
				animation.addByPrefix('singDOWN', 'Whitty Pixel Down0', 24, false);
				animation.addByPrefix('singLEFT', 'Whitty Pixel Left0', 24, false);
				animation.addByPrefix('singRIGHT', 'Whitty Pixel Right0', 24, false);
				if (!isPlayer)
				{
					animation.addByPrefix('singRIGHT', 'Whitty Pixel Left0', 24, false);
					animation.addByPrefix('singLEFT', 'Whitty Pixel Right0', 24, false);
				}
				else
				{
					animation.addByPrefix('singLEFT', 'Whitty Pixel Left0', 24, false);
					animation.addByPrefix('singRIGHT', 'Whitty Pixel Right0', 24, false);
				}

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

			case 'bf-wright-pixel':
				frames = Paths.getSparrowAtlas('characters/bf-wrightPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

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

			case 'bf-pico-pixel':
				frames = Paths.getSparrowAtlas('characters/bf-picoPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

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

			case 'bf-gf-pixel':
				frames = Paths.getSparrowAtlas('characters/bf-gfPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);
				if (!isPlayer)
				{
					animation.addByPrefix('singRIGHT', 'BF LEFT NOTE', 24, false);
					animation.addByPrefix('singLEFT', 'BF RIGHT NOTE', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF LEFT MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF RIGHT MISS', 24, false);
				}
				else
				{	
					animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
					animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				}

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

			case 'bf-rico-pixel':
				frames = Paths.getSparrowAtlas('characters/bf-ricoPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

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

			case 'bf-sonic-pixel':
				frames = Paths.getSparrowAtlas('characters/bf-sonicPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

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

			case 'bf-tankman-pixel':
				frames = Paths.getSparrowAtlas('characters/bf-tankmanPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('idle-alt', 'BF ALT IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUP-alt', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT-alt', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN-alt', 'BF DOWN NOTE', 24, false);
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

				playAnim('idle-alt');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;

			case 'bf-tom-pixel':
				frames = Paths.getSparrowAtlas('characters/bf-tomPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

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

			case 'bf-sans-pixel':
				frames = Paths.getSparrowAtlas('characters/bf-sansPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

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

			case 'bf-pixeld4':
				frames = Paths.getSparrowAtlas('characters/bfPixeld4');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('idle-alt', 'BF ALT IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);		
				animation.addByPrefix('singUP-alt', 'BF ALT UP NOTE', 24, false);
				animation.addByPrefix('singLEFT-alt', 'BF ALT LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'BF ALT RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN-alt', 'BF ALT DOWN NOTE', 24, false);
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

			case 'rosie':
				tex = Paths.getSparrowAtlas('characters/rosie_assets');
				frames = tex;
				animation.addByPrefix('idle', 'rosanna idle', 24, false);
				animation.addByPrefix('singUP', 'rosanna up', 24, false);
				animation.addByPrefix('singRIGHT', 'rosanna right', 24, false);
				animation.addByPrefix('singDOWN', 'rosanna down', 24, false);
				animation.addByPrefix('singLEFT', 'rosanna left', 24, false);
				animation.addByPrefix('ara', 'rosanna ara ara', 24);
	
				addOffset('idle');
				addOffset("singUP", 97, 127);
				addOffset("singRIGHT", -93, -123);
				addOffset("singLEFT", 15, 27);
				addOffset("singDOWN", -29, -126);
				addOffset("ara", -19, 0);
			
				playAnim('idle');
					
			case 'rosie-angry':

				tex = Paths.getSparrowAtlas('characters/rosie_assets');
				frames = tex;
					
				animation.addByPrefix('idle', "angry rosanna idle", 24, false);
				animation.addByPrefix('singUP', "angry rosanna up", 24, false);
				animation.addByPrefix('singDOWN', "angry rosanna down", 24, false);
				animation.addByPrefix('singLEFT', "angry rosanna left", 24, false);
				animation.addByPrefix('singRIGHT', "angry rosanna right", 24, false);
				animation.addByPrefix('fuck this', "rosanna lost it", 24, false);
					
				addOffset('idle');
				addOffset('singUP', 97, 127);
				addOffset('singRIGHT', -93, -123);
				addOffset('singLEFT', 15, 27);
				addOffset('singDOWN', -29, -126);
				addOffset('fuck this', 1295, 87);
	
				playAnim('idle');
				
			
			case 'rosie-furious':
				tex = Paths.getSparrowAtlas('characters/rosie_assets');
				frames = tex;

				animation.addByPrefix('idle', 'furious rosanna idle', 24, false);
				animation.addByPrefix('singUP', 'furious rosanna up', 24, false);
				animation.addByPrefix('singRIGHT', 'furious rosanna right', 24, false);
				animation.addByPrefix('singDOWN', 'furious rosanna down', 24, false);
				animation.addByPrefix('singLEFT', 'furious rosanna left', 24, false);
				animation.addByPrefix('shoot', 'furious rosanna down', 24, false);
	
				addOffset('idle');
				addOffset("singUP", 97, 26);
				addOffset("singRIGHT", 54, 1);
				addOffset("singLEFT", 158, 45);
				addOffset("singDOWN", 229, -126);
				addOffset("shoot", -29, -126);

				playAnim('idle');

			case 'bf-pixeld4BSide':
				frames = Paths.getSparrowAtlas('characters/bfPixeld4');
				animation.addByPrefix('idle', 'BF ALT IDLE', 24, false);
				animation.addByPrefix('idle-alt', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF ALT UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF ALT LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF ALT RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF ALT DOWN NOTE', 24, false);
				animation.addByPrefix('singUP-alt', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT-alt', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN-alt', 'BF DOWN NOTE', 24, false);
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

			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');
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

			case 'bf-tankman-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bf-tankmanPixelDEAD');
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

			case 'bf-pico-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bf-picoPixelsDEAD');
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

			case 'bf-rico-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bf-ricoPixelsDEAD');
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

			case 'bf-sans-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bf-sansPixelsDEAD');
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

			case 'bf-gf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bf-gfPixelsDEAD');
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

			case 'bf-sonic-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bf-sonicPixelsDEAD');
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

			case 'bf-tom-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bf-tomPixelsDEAD');
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

			case 'bf-wright-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bf-wrightPixelsDEAD');
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

			case 'senpai':
				frames = Paths.getSparrowAtlas('characters/senpai');
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

			case 'blantad-pixel':
				frames = Paths.getSparrowAtlas('characters/blantad-pixel');
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

			case 'neon':
				frames = Paths.getSparrowAtlas('characters/neon');
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

				setGraphicSize(Std.int(width * 5));
				updateHitbox();

				antialiasing = false;
			
			case 'miku-pixel':
				frames = Paths.getSparrowAtlas('characters/bitmiku');
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

			case 'monster-pixel':
				frames = Paths.getSparrowAtlas('characters/monsterPixel');
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

			case 'monika':
				frames = Paths.getSparrowAtlas('characters/monika');
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

			case 'colt':
				frames = Paths.getSparrowAtlas('characters/colt');
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

			case 'monika-angry':
				frames = Paths.getSparrowAtlas('characters/monika');
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

			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters/senpai');
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

			case 'mangle-angry':
				frames = Paths.getSparrowAtlas('characters/mangle');
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

			case 'baldi-angry':
				frames = Paths.getSparrowAtlas('characters/baldi');
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

			case 'colt-angry':
				frames = Paths.getSparrowAtlas('characters/colt');
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

			case 'colt-angryd2':
				frames = Paths.getSparrowAtlas('characters/coltd2');
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

			case 'senpai-giddy':
				frames = Paths.getSparrowAtlas('characters/senpaigiddy');
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

			case 'bitdadcrazy':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/BitDadCrazy');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);
				playAnim('idle');	

				setGraphicSize(Std.int(width * 0.85));
				updateHitbox();

				antialiasing = false;	
				
			case 'bitdad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/BitDad');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('switch', 'Dad version switch', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset('switch');
				addOffset("singUP", -10, 40);
				addOffset("singRIGHT", -5, 35);
				addOffset("singLEFT", -10, 20);
				addOffset("singDOWN", 3, -20);
				playAnim('idle');	

				setGraphicSize(Std.int(width * 1));
				updateHitbox();

				antialiasing = false;	

			case 'bitdadBSide':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/BitDadBSide');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('switch', 'Dad version switch', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset('switch');
				addOffset("singUP", -10, 40);
				addOffset("singRIGHT", -5, 35);
				addOffset("singLEFT", -10, 20);
				addOffset("singDOWN", 3, -20);
				playAnim('idle');	

				setGraphicSize(Std.int(width * 1));
				updateHitbox();

				antialiasing = false;

			case 'matt':
				frames = Paths.getSparrowAtlas('characters/matt');
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

			case 'matt-angry':
				frames = Paths.getSparrowAtlas('characters/matt');
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

			case 'opheebop':
				tex = Paths.getSparrowAtlas('characters/Opheebop_Assets');
				frames = tex;
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

			case 'kristoph-angry':
				frames = Paths.getSparrowAtlas('characters/kristoph');
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

			case 'chara-pixel':
				frames = Paths.getSparrowAtlas('characters/chara_pixel');
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
			
			case 'jackson':
				frames = Paths.getSparrowAtlas('characters/jackson');
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

			case 'mario-angry':
				frames = Paths.getSparrowAtlas('characters/mario');
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

			case 'spirit':
				frames = Paths.getPackerAtlas('characters/spirit');
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

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets');
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

				addOffset('idle');
				addOffset('idle-alt');
				addOffset("singUP", -47, 24);
				addOffset("singRIGHT", -1, -23);
				addOffset("singLEFT", -30, 16);
				addOffset("singDOWN", -31, -29);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);

				playAnim('idle');

			case 'neko-crazy':
                frames = Paths.getSparrowAtlas('characters/nf2');
                
                animation.addByPrefix('idle', 'nfc_idle', 24, false);
                animation.addByPrefix('singUP', 'nfc_up', 24, false);
				animation.addByPrefix('singDOWN', 'nfc_down', 24, false);
				animation.addByPrefix('singLEFT', 'nfc_left', 24, false);
				animation.addByPrefix('singRIGHT', 'nfc_right', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'nfc_freeze', 24, false);
                
                addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
                
                playAnim('idle');

			case 'demoncass':
				tex = Paths.getSparrowAtlas('characters/demoncass');
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

			case 'impostor':
				tex = Paths.getSparrowAtlas('characters/impostor');
				frames = tex;
				animation.addByPrefix('idle', 'impostor idle', 12);
				animation.addByPrefix('singUP', 'impostor up', 12);
				animation.addByPrefix('singRIGHT', 'impostor right', 12);
				animation.addByPrefix('singDOWN', 'impostor down', 12);
				animation.addByPrefix('singLEFT', 'impostor left', 12);
				animation.addByPrefix('shoot1', 'impostor shoot 1', 24);
				animation.addByPrefix('shoot2', 'impostor shoot 2', 24);

				addOffset('idle');
				addOffset("singUP", -84, 0);
				addOffset("singRIGHT", -61, -20);
				addOffset("singLEFT", 91, -12);
				addOffset("singDOWN", -36, -65);
				addOffset("shoot1", -54, 75);
				addOffset("shoot2", -27, 124);

				playAnim('idle');

			case 'henry-angry':
				tex = Paths.getSparrowAtlas('characters/henry_angry');
				frames = tex;
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
					//addOffset("singUPmiss", -30, 176);
					//addOffset("singRIGHTmiss", -80, 136);
					//addOffset("singLEFTmiss", 70, 140);
					//addOffset("singDOWNmiss", -30, 10);
				}

				else
				{
					addOffset("singUP", 5, 45);
					addOffset("singRIGHT", 70, -15);
					addOffset("singLEFT", 80, 10);
					addOffset("singDOWN", 30, -70);
					//addOffset("singUPmiss", -30, 176);
					//addOffset("singRIGHTmiss", -80, 136);
					//addOffset("singLEFTmiss", 70, 140);
					//addOffset("singDOWNmiss", -30, 10);
				}
				
				playAnim('danceRight');

			case 'updike':
				tex = Paths.getSparrowAtlas('characters/updike_assets');
				frames = tex;
	
				animation.addByPrefix('idle', "updingdong idle0", 24, false);
				animation.addByPrefix('singUP', "updingdong up note0", 24, false);
				animation.addByPrefix('singDOWN', "updingdong down note0", 24, false);
				animation.addByPrefix('singLEFT', 'updingdong left note0', 24, false);
				animation.addByPrefix('singRIGHT', 'updingdong right note0', 24, false);
	
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				playAnim('idle');

			case 'ruby-worried':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/ruby_worried_assets');
				frames = tex;
				//animation.addByIndices('idle', 'ruby idle dance', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], "", 24, false);
				animation.addByPrefix('idle', 'ruby idle dance', 24, true);
				animation.addByPrefix('singUP', 'ruby Sing Note UP0', 24, false);
				animation.addByPrefix('singLEFT', 'ruby Sing Note LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'ruby Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'ruby Sing Note DOWN0', 24, false);
				
				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", 1, 42);
					addOffset("singLEFT", 4, 19);
					addOffset("singRIGHT", 18, 0);
					addOffset("singDOWN", 11, -38);
				}

				else
				{
					addOffset('idle');
					addOffset("singUP", -18, 42);
					addOffset("singRIGHT", -17, 19);
					addOffset("singLEFT", -22, 0);
					addOffset("singDOWN", -23, -38);
				}
				
				playAnim('idle');	

			case 'ruby':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/ruby_assets');
				frames = tex;
				//animation.addByIndices('idle', 'ruby idle dance', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], "", 24, false);
				animation.addByPrefix('idle', 'ruby idle dance', 24, true);
				animation.addByPrefix('singUP', 'ruby Sing Note UP0', 24, false);
				animation.addByPrefix('singLEFT', 'ruby Sing Note LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'ruby Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'ruby Sing Note DOWN0', 24, false);
				animation.addByPrefix('hey', 'ruby hey0', 24, false);
				
				if (isPlayer)
				{
					addOffset('idle');
					addOffset("singUP", 1, 42);
					addOffset("singLEFT", 4, 19);
					addOffset("singRIGHT", 18, 0);
					addOffset("hey", 24, 19);
					addOffset("singDOWN", 11, -38);
				}

				else
				{
					addOffset('idle');
					addOffset("singUP", -18, 42);
					addOffset("singRIGHT", -17, 19);
					addOffset("hey", -17, 19);
					addOffset("singLEFT", -22, 0);
					addOffset("singDOWN", -23, -38);
				}
				
				playAnim('idle');	
				
			case 'cjClone':
				frames = Paths.getSparrowAtlas('characters/CJCLONE');

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

				animation.addByPrefix('idle', 'cj idle dance', 24, false);
				animation.addByPrefix('singUP', 'cj Sing Note UP0', 24, false);
				animation.addByPrefix('singLEFT', 'cj Sing Note LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'cj Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'cj Sing Note DOWN0', 24, false);
				animation.addByPrefix('singUP-alt', 'cj singleha0', 24, false);
				animation.addByPrefix('haha', 'cj doubleha0', 24, false);
				animation.addByPrefix('intro', 'cj intro0', 24, false);

				addOffset('idle');
				addOffset('intro', 590, 232);
				addOffset("singUP", -46, 28);
				addOffset("singRIGHT", -20, 37);
				addOffset("singLEFT", -2, 3);
				addOffset("singDOWN", -20, -20);
				addOffset('singUP-alt', -46, 28);
				addOffset('haha', -46, 28);
				addOffset('Showtime');

				playAnim('idle');
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
			}
		}
	}

	/*public function sing(direction:Int, ?miss:Bool=false, ?alt:Int=0) 
	{
		var directName:String = "";
		var missName:String = "";
		switch (direction) 
		{
			case 0:
				directName = "singLEFT";
			case 1:
				directName = "singDOWN";
			case 2:
				directName = "singUP";
			case 3:
				directName = "singRIGHT";
		}
		
		if (miss) 
		{
			missName = "miss";
			if (animation.getByName(directName + missName) != null) 
			{
				missSupported = true;
			}

			if (altAnim == '-alt' || bfAltAnim == '-alt')
			{
				if (animation.getByName(directName + missName + '-alt') != null)
				{
					missAltSupported = true;
				}
			}

			if (missSupported && (alt == 0 || missAltSupported))
				directName += missName;
		} 
		if ((altAnim == '-alt' && (!miss || missAltSupported)) || (bfAltAnim == '-alt' && (!miss || missAltSupported)))
		{
			if ((altAnim == '-alt' && animation.getByName(directName + '-alt') != null) || (bfAltAnim == '-alt' && animation.getByName(directName + '-alt') != null))
			{
				directName += "-alt";
			}
		}
		// if we have to miss, but miss isn't supported...
		if (miss && !(missSupported)) 
		{
			// first, we don't want to be using alt, which is already handled.
			// second, we don't want no animation to be played, which again is handled.
			// third, we want character to turn purple, which is handled here.
			color = 0xCFAFFF;
		}
		else if (color != FlxColor.WHITE)
		{
			color = FlxColor.WHITE;
		}
		if (altAnim == '-alt' || bfAltAnim == '-alt') 
		{
			if ((altAnim == '-alt' && animation.getByName(directName + '-alt') != null) || (bfAltAnim == '-alt' && animation.getByName(directName + '-alt') != null)) 
			{
				directName += "-alt";
			} 
		}
		playAnim(directName, true);
	}*/

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
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
			switch (curCharacter)
			{
				case 'gf' | 'gf-tabi':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pico':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'nogf' | 'madgf' | 'nogf-glitcher' | 'nogf-christmas' | 'gf-hex':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-tankman':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-crucified':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'crazygf-crucified':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'nogf-crucified' | 'nogf-rebecca':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-sarv':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-car' |'holo-cart' | 'cj-tied' | 'dalia-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixeld4':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixeld4BSide':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'nogf-pixel' | 'gf-pixel-mario' | 'piper-pixel-mario' | 'amy-pixel-mario' | 'gf-pixel-neon' | 'gf-playtime' | 'piper-pixeld2' | 'gf-tankman-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-edgeworth-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-edd':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-flowey' | 'gf-kaity' | 'gf-m' | 'gf-demon' | 'gf-selever' | 'gf-nene':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-ruv' | 'gf-ruv-glitcher':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gfandbf' | 'gfandbf-fear':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-bw' | 'gf-ruv-bw' | 'gf-alya-bw' | 'gf-nene-bw' | 'gf-monika-bw' | 'gf-pico-bw' | 'gf-cassandra-bw':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

					

				case 'gf1' | 'gf2' | 'gf3' | 'gf4' | 'gf5':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky' | 'henry-angry':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');

				case 'spooky-pixel' | 'gura-amelia-pixel':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				
				case 'gura-amelia' |'gura-amelia-bw':
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
					
			
				case 'bf-sky':
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

				case 'momi':
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
					
				default:
					playAnim('idle' + altAnim);
			}
		}
	}

	public function setZoom(?toChange:Float = 1):Void
	{
		daZoom = toChange;
		scale.set(toChange, toChange);
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0] * daZoom, daOffset[1] * daZoom);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf' || curCharacter == 'gf1' || curCharacter == 'gf2' || curCharacter == 'gf3' || curCharacter == 'gf4' || curCharacter == 'gf5' || curCharacter == 'gf-kaity')
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
