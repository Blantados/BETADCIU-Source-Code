package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import lime.app.Application;

using StringTools;

//bcuz god damn it. those offset things in playstate take up a bunch of space

class CharacterOffsets
{
	public var daOffsetArray:Array<Int> = [0, 0, 0, 0, 0, 0];

	public function new(curCharacter:String = 'dad', isPlayer:Bool = false)
	{
		//in order this is +x, +y, +camPosX, +camPosY, +camPosX from midpoint, +camPosY from midpoint.
		daOffsetArray = [0, 0, 0, 0, 0, 0];

		if (!isPlayer)
		{
			switch (curCharacter)
			{
				case "spooky" | "gura-amelia" | "sunday" | 'spooky-pelo' | 'tankman':
					daOffsetArray = [0, 200, 0, 0, 0, 0];
				case 'oswald-happy' | 'oswald-angry':
					daOffsetArray = [-70, 200, 0, 0, 0, 0];
				case "mia" | 'mia-lookstraight' | 'mia-wire':
					daOffsetArray = [100, 140, 0, 0, 250, -100];			
				case 'sayori':
					daOffsetArray = [0, 110, 400, 0, 0, 0];
				case 'natsuki':
					daOffsetArray = [0, 175, 400, 0, 0, 0];
				case 'yuri' | 'yuri-crazy' | 'yuri-crazy-bw':
					daOffsetArray = [0, 130, 400, 0, 0, 0];
				case 'monika-real':
					daOffsetArray = [0, 60, 400, 0, 0, 0];
				case 'bigmonika':
					daOffsetArray = [0, 0, 0, 0, -100, -200];	
				case 'yukichi-police':
					daOffsetArray = [-70, 130, 0, 0, 0, 0];
				case 'exe' | 'exe-bw':
					daOffsetArray = [100, 175, 0, 0, 0, 0];
				case 'duet-sm':
					daOffsetArray = [150, 380, 0, 0, 300, 0];
				case 'sunky':
					daOffsetArray = [-210, 130, 0, 0, 0, 0];
				case 'cj-ruby' | 'cj-ruby-both':
					daOffsetArray = [-50, 0, 0, 0, 0, 0];
				case 'bosip' | 'demoncass':
					daOffsetArray = [0, -50, 0, 0, 0, 0];
				case "hex-virus" | "agoti-wire" | 'agoti-glitcher' | 'agoti-mad' | 'haachama' | 'haachama-blue':
					daOffsetArray = [0, 100, 0, 0, 0, 0];	
				case "whittyCrazy":
					daOffsetArray = [-25, 0, 400, 0, 0, 0];
				case 'ruv':
					daOffsetArray = [0, -70, 0, 0, 0, 0];	
				case 'sarvente' | 'sarvente-dark':
					daOffsetArray = [-50, -40, 0, 0, 0, 0];	
				case 'monster-christmas' | 'monster' | 'drunk-annie':
					daOffsetArray = [0, 130, 0, 0, 0, 0];	
				case 'dad' | 'shaggy' | 'hd-senpai-giddy' | 'lila' | 'whitty':
					daOffsetArray = [0, 0, 400, 0, 0, 0];
				case 'dad-mad':
					daOffsetArray = [-30, -10, 400, 0, 0, 0];
				case 'bf-blantad':
					daOffsetArray = [0, -75, 0, 0, 0, 0];	
				case 'pico' | 'annie-bw' | 'phil' | 'alya' | 'picoCrazy':
					daOffsetArray = [0, 300, 600, 0, 150, -100];	
				case 'bob2' | 'peri':
					daOffsetArray = [0, 50, 0, 0, 0, 0];
				case 'botan':
					daOffsetArray = [0, 185, 0, 0, 0, 0];
				case 'neko-crazy':
					daOffsetArray = [-50, 230, 0, 0, 300, 0];
				case 'kou' | 'nene' | 'liz' | 'bf-annie' | 'bf-carol' | 'nene2':
					daOffsetArray = [0, 300, 600, 0, 0, 0];	
				case 'bf' | 'bf-frisk' | 'bf-gf' | 'bf-aloe':
					daOffsetArray = [0, 350, 600, 0, 0, 0];	
				case 'rushia':
					daOffsetArray = [105, 250, 600, 0, 0, 0];	
				case 'bf-sonic':
					daOffsetArray = [-100, 350, 0, 0, 0, 0];
				case 'parents-christmas' | 'parents-christmas-soft':
					daOffsetArray = [-500, 0, 0, 0, 0, 0];
				case 'bico-christmas':
					daOffsetArray = [-500, 100, 0, 0, 0, 0];
				case 'senpai' | 'monika' | 'senpai-angry' | 'kristoph-angry' | 'senpai-giddy' | 'baldi-angry-pixel' | 'mangle-angry' | 'monika-angry' | 'green-monika' | 'neon' 
				| 'matt-angry' | 'jackson' | 'mario-angry' | 'colt-angryd2' | 'colt-angryd2corrupted':
					daOffsetArray = [150, 360, 0, 0, 300, 0];
				case 'monika-finale':
					daOffsetArray = [15, 460, 0, 0, 300, 0];
				case 'lane-pixel':
					daOffsetArray = [150, 560, 0, 0, 300, -200];
				case 'bf-gf-pixel' | 'bf-pixel' | 'bf-botan-pixel':
					daOffsetArray = [150, 460, 0, 0, 300, 0];
				case 'bf-sky':
					daOffsetArray = [-100, 400, 0, 0, 300, 0];
				case 'bf-whitty-pixel':
					daOffsetArray = [150, 400, 0, 0, 300, 0];
				case 'gura-amelia-pixel':
					daOffsetArray = [140, 400, 0, 0, 300, 0];
				case 'bitdad' | 'bitdadBSide' | 'bitdadcrazy':
					daOffsetArray = [0, 75, 0, 0, 300, 0];
				case 'spirit' | 'spirit-glitchy':
					daOffsetArray = [-150, 100, 0, 0, 300, 200];
				case 'sky-annoyed':
					daOffsetArray = [0, -20, 0, 0, 0, 0];
				case 'impostor':
					daOffsetArray = [-100, 390, 400, -200, 0, 0];
				case 'updike':
					daOffsetArray = [0, 0, 0, 0, 300, 0];
				case 'bob' | 'angrybob':
					daOffsetArray = [0, 280, 600, 0, 0, 0];
				case 'cjClone':
					daOffsetArray = [-250, -150, 0, 0, 0, 0];				
				case 'exTricky':
					daOffsetArray = [-250, -365, 0, 0, 0, 0];							
				case 'momi':
					daOffsetArray = [0, 50, 0, 0, 300, 0];
				case 'sh-carol' | 'sarvente-lucifer':
					daOffsetArray = [-70, -275, 0, 0, 0, 0];
				case 'garcello' | 'garcellotired' | 'garcellodead':
					daOffsetArray = [-100, 0, 0, 0, 0, 0];
				case 'lucian':
					daOffsetArray = [-30, -60, 300, -15, 0, 0];
				case 'abby':
					daOffsetArray = [-157, 202, 300, -15, 0, 0];
				case 'abby-mad':
					daOffsetArray = [-24, 260, 300, -15, 0, 0];
				case 'roro':
					daOffsetArray = [-500, 0, 0, 0, 0, 0];
				case 'zardy':
					daOffsetArray = [-80, 0, 0, 0, 0, 240];
				case 'taki' | 'rosie' | 'rosie-angry' | 'rosie-furious':
					daOffsetArray = [0, 100, 0, 0, 0, 0];
				case 'brody':
					daOffsetArray = [0, 110, 0, 0, 300, 0];
				case 'selever':
					daOffsetArray = [-50, -65, 0, 0, 300, 0];
				case 'camellia' | 'camelliahalloween':
					daOffsetArray = [-300, -50, 0, 0, 0, 0];
				case 'exe-front':
					daOffsetArray = [-50, 50, 0, 0, 0, 0];
				case 'bf-pixeld4BSide' | 'bf-pixeld4':
					if (!PlayState.curStage.contains('school'))
						daOffsetArray = [300, 150, 0, 0, 0, 0];
				case "rebecca":
					daOffsetArray = [0, 0, 0, 500, 150, 100];
					if (!PlayState.curStage.contains('hungryhippo'))	
						daOffsetArray[1] = 100;
				case 'betty' | 'betty-bw':
					daOffsetArray = [0, 200, 0, 0, 0, 0];
				default:
					daOffsetArray = [0, 0, 0, 0, 0, 0];
			}
		}
		else if (isPlayer)
		{
			switch (curCharacter)
			{
				case 'mia' | 'mia-lookstraight' | 'mia-wire':
					daOffsetArray = [100, -200, 0, 0, 0, 0];
				case 'gold-side' | 'gold-side-blue':
					daOffsetArray = [40, -270, 0, 0, 0, 0];
				case 'sayori':
					daOffsetArray = [-50, -280, -400, 0, 0, 0];
				case 'natsuki':
					daOffsetArray = [0, -175, -400, 0, 0, 0];
				case 'yuri' | 'yuri-crazy' | 'yuri-crazy-bw':
					daOffsetArray = [0, -220, -400, 0, 0, 0];
				case 'crazygf' | 'crazygf-bw':
					daOffsetArray = [50, -80, 0, 0, 0, 0];
				case 'impostor':
					daOffsetArray = [-100, 40, -400, -200, 0, 0];
				case 'bf-nene' | 'bf-nene-scream':
					daOffsetArray = [0, -70, 0, 0, 0, 0];
				case 'pico' | 'annie-bw' | 'kou' | 'phil' | 'nene':
					daOffsetArray = [40, -50, 0, 0, 0, 0];
				case 'bf-demoncesar':
					daOffsetArray = [60, -50, 0, 0, 0, 0];
				case 'demongf' | 'demongf-city':
					daOffsetArray = [100, -100, 0, 0, 0, 0];
				case 'bf-cesar':
					daOffsetArray = [105, -50, 0, 0, 0, 0];
				case 'sunday':
					daOffsetArray = [0, -100, 0, 0, 0, 0];
				case 'monster' | 'monster-christmas':
					daOffsetArray = [100, -250, 0, 0, -100, -100];
				case 'haachama' | 'opheebop':
					daOffsetArray = [50, -250, 0, 0, 0, 0];
				case 'senpai' | 'senpai-giddy' | 'monika' | 'senpai-angry' | 'colt-angry' | 'miku-pixel' | 'mangle-angry' | 'monika-angry' | 'mario-angry' | 'jackson' | 'matt-angry' 
				| 'monster-pixel' | 'maijin-new':
					daOffsetArray = [0, -200, 0, 0, 0, 0];
				case 'bf-whitty-pixel':
					daOffsetArray = [0, -170, 0, 0, 0, 0];
				case "gura-amelia" | "spooky":
					daOffsetArray = [0, -150, 0, 0, 0, 0];
				case 'bana':
					daOffsetArray = [0, -260, 0, 0, 0, 0];
				case 'cassandra':
					daOffsetArray = [0, -330, 0, 0, 0, 0];
				case 'tom2' | 'tord2' | 'matt2' | 'edd2' | 'garcello' | 'garcellotired' | 'garcellodead':
					daOffsetArray = [-100, -350, 0, 0, 0, 0];
				case 'bf-exgf':
					daOffsetArray = [50, -400, 0, 0, 0, 0];
				case 'bf-blantad' | 'bb' | 'anchor' | 'agoti':
					daOffsetArray = [0, -400, 0, 0, 0, 0];
				case 'mom-car' | 'dad' | 'mom' | 'hex' | 'hd-senpai-giddy' | 'hd-senpai-angry' | 'bf-senpai-worried' | 'parents-christmas' | 'henry-blue' | 'whitty' | 'miku'
				| 'lila' | 'lila-pelo' | 'myra' | 'bf-mom' | 'blantad-new' | 'blantad-watch' | 'bf-mom-car' | 'blantad-blue' | 'bf-hd-senpai-angry' | 'bf-hd-senpai-dark' 
				| 'tabi-wire' | 'tabi-glitcher' | 'tabi' | 'sarvente' | 'ruv' | 'cj-ruby':
					daOffsetArray = [0, -350, 0, 0, 0, 0];
				case 'sarv-ruv' | 'sarv-ruv-both':
					daOffsetArray = [-100, -350, 0, 0, 0, 0];
				case 'sky-mad' | 'sky-pissed':
					daOffsetArray = [-50, -180, 0, 0, 0, 0];
				case 'botan':
					daOffsetArray = [40, -75, 0, 0, 0, 0];
				case 'bob':
					daOffsetArray = [0, -300, 0, 0, 0, 0];
				case 'henry-angry':
					daOffsetArray = [0, -70, 0, 0, 0, 0];
				case 'bosip':
					daOffsetArray = [0, -400, 0, 0, 0, 0];
				case 'bf-botan-pixel':
					daOffsetArray = [40, -90, 0, 0, 0, 0];
				case 'liz':
					daOffsetArray = [40, -25, 0, 0, 0, 0];
				case 'selever':
					daOffsetArray = [40, -375, 0, 0, -100, -100];
				case 'bf-pump':
					daOffsetArray = [0, 50, 0, 0, 0, 0];
				case 'tord' | 'tom':
					daOffsetArray = [0, -200, 0, 0, 0, 0];
				case 'tankman' | 'bf-senpai-tankman':
					daOffsetArray = [0, -150, 0, 0, 0, 0];
				case 'ruby-worried':
					daOffsetArray = [200, -510, 0, 0, 0, 0];
				case 'ruby' | 'ruby-worried-night':
					daOffsetArray = [100, -350, 0, 0, 0, 0];
				case 'lucian':
					daOffsetArray = [30, -410, -300, 15, 0, 0];
				case 'sh-carol' | 'sarvente-lucifer':
					daOffsetArray = [0, -625, 0, 0, 0, 0];
				case 'skye-r':
					daOffsetArray = [-100, -350, 0, 0, 0, 0];
				case 'rushia':
					daOffsetArray = [-30, -90, 0, 0, 0, 0];
				default:
					daOffsetArray = [0, 0, 0, 0, 0, 0];
			}		
		}
	}
}