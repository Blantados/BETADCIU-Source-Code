package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class BonusSongsState extends MusicBeatState
{
	var songs:Array<SongMetadata3> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var infoText:FlxText;
	var diffText:FlxText;
	var comboText:FlxText;
	var copyrightText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var combo:String = '';

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	var bgPixel:FlxSprite;
	var infoBG:FlxSprite;

	var blackScreen:FlxSprite;
	var enterText:Alphabet;
	var otherText:FlxText;

	var inUnlockMenu:Bool;
	public static var canMove:Bool;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		 if (FlxG.sound.music.volume == 0 || !FlxG.sound.music.playing)
		{
			FlxG.sound.music.volume = 1;
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		inUnlockMenu = false;
		canMove = true;
			
		FlxG.sound.cache(Paths.sound("unlock", 'shared'));

		 #if desktop
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In Bonus Song Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		var lamentCombo:String = '';
		var rootsCombo:String = '';
		var spookyCombo:String = '';
		var ughCombo:String = '';
		var argumentCombo:String = '';
		var unholyCombo:String = '';

		#if !switch
		lamentCombo = Highscore.getCombo('Lament', 2);
		rootsCombo = Highscore.getCombo('Roots', 2);
		spookyCombo = Highscore.getCombo('Spooky-Fight', 2);
		ughCombo = Highscore.getCombo('Ugh', 2);
		argumentCombo = Highscore.getCombo('Argument', 2);
		unholyCombo = Highscore.getCombo('Unholy-Worship', 2);
		#end

		addWeek(['Tutorial-Remix'], 1, ['gf']);
		addWeek(['Monika', 'Roses-Remix-Senpai'], 1, ['monika', 'senpai-angry']);
		addWeek(['Pico-G', 'Good-Enough', 'EEEAAAOOO'], 3, ['nene', 'bf-annie', 'lila']);
		addWeek(['WhittyVsSarv', 'High-Sarv', 'Ruvbattle'], 4, ['sarvente', 'sarvente', 'ruv']);
		addWeek(['Winter-Horrorland-Miku', 'Memories'], 5, ['miku-mad-christmas', 'sarvente-worried-night']);
		addWeek(['Their-Battle', 'Glitcher', 'Sussus-Moogus'], 6, ['tabi', 'agoti-glitcher', 'impostor']);
		addWeek(['Five-Nights' ,'FNFVSEDDSWORLD', 'Accidental-Bop'], 7, ['hex', 'tord2', 'tord2']);
		addWeek(['Sharkventure', 'Context', 'Pom-Pomeranian'], 8, ['liz', 'sky-annoyed', 'cj-ruby']);
		addWeek(['Milf-G', 'Demon-Training', 'No-Cigar'], 9, ['rosie', 'dad', 'garcello']);
		addWeek(['Fruity-Encounter', 'Get Out'], 10, ['mia', 'peri']);
		addWeek(['Gura-Nazel', 'Gun-Buddies', 'Possession'], 11, ['gura-amelia', 'botan', 'coco-car']);
		addWeek(['Unholy-Worship', 'Argument', 'Pure-Gospel'], 12, ['dad', 'sarvente-lucifer', 'sh-carol']);
		addWeek(['Sunshine', 'Jump-in', 'Aspirer'], 13, ['bob2', 'bob', 'blantad-blue']);
		addWeek(['Ballistic', 'Expurgation', 'Crucify'], 14, ['picoCrazy', 'cjClone', 'gf']);
		addWeek(['Ugh-Remix', 'Honeydew'], 15, ['tankman', 'hd-senpai-happy']);
		addWeek(['Mad-Tall', 'Spooky-Fight', 'Happy'], 16, ['bf-carol', 'zardy', 'exe-bw']);

		if (lamentCombo == 'GFC' && ughCombo == 'GFC' && spookyCombo == 'GFC' && unholyCombo == 'GFC' && argumentCombo == 'GFC' || isDebug)
		{
			addSong('Cursed-Cocoa', 16, 'bico-christmas');
			Main.cursedUnlocked = true;
			FlxG.save.data.cursedUnlocked = true;
		}	

		addWeek(['Lament', 'Roots'], 17, ['sarvente', 'monika']);

		if (lamentCombo == 'GFC' && rootsCombo == 'GFC')
		{
			addSong('Deathmatch-Holo', 17, 'calli-mad');
			Main.deathHolo = true;
			FlxG.save.data.deathHoloUnlocked = true;
		}	

		addWeek(['Technokinesis', 'Copy-Cat', 'Milk'], 18, ['yukichi-mad', 'nene2', 'mom']);
		addWeek(['Norsky', 'Spectral-Spat', 'Really-Happy'], 19, ['sky-pissed', 'gar-spirit', 'yuri-crazy-bw']);
		addWeek(['Kaboom', 'Monochrome', 'Reactor'], 20, ['whittyCrazy', 'bigmonika', 'midas-r']);
		addWeek(['Synthesize', 'Endless', 'Triple-Trouble'], 21, ['bf-aloe', 'haachama-blue', 'beast-sonic']);
		addWeek(["You-Cant-Run", 'Bi-nb', 'Smile'], 22, ['dad', 'sunday', 'betty-bw']);


		if (TitleState.curWacky[1].contains('uncorruption') && Main.seenMessage)
			addSong('Restore', 6, 'senpai-glitch');
	
		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGLightBlue'));
		add(bg);
		
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		comboText = new FlxText(diffText.x + 100, diffText.y, 0, "", 24);
		comboText.font = diffText.font;
		add(comboText);

		add(scoreText);

		infoText = new FlxText(FlxG.width * 0.7, 105, FlxG.height, "", 20);
		infoText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, LEFT);
		infoText.text = 'This song contains copyrighted' 
		+ '\ncontent. Press P for Alternate'
		+ '\nInst.';

		copyrightText = new FlxText(FlxG.width * 0.7, 155, FlxG.height, "", 32);
		copyrightText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT);
		if (!Main.noCopyright) 
			copyrightText.text = '\nAlternate Inst: Off';
		else 
			copyrightText.text = '\nAlternate Inst: On';
		
		infoBG = new FlxSprite(scoreText.x - 6, 100).makeGraphic(Std.int(FlxG.width * 0.35), 132, 0xFF000000);
		infoBG.alpha = 0.6;
		add(infoBG);

		add(infoText);
		add(copyrightText);

		blackScreen = new FlxSprite(-100, -100).makeGraphic(Std.int(FlxG.width * 0.9), Std.int(FlxG.height * 0.5), FlxColor.BLACK);
		blackScreen.screenCenter();
		blackScreen.scrollFactor.set();
		blackScreen.alpha = 0.9;
		blackScreen.visible = false;
		add(blackScreen);

		var daSong:String = 'Deathmatch';

		if (!FlxG.save.data.deathHoloUnlocked)
			daSong = 'Deathmatch';
		else
			daSong = 'Deathmatch Holo\n';

		enterText = new Alphabet(0, 0, daSong + " Unlocked", true);
		enterText.screenCenter();
		enterText.y -= 100;
		enterText.visible = false;
		add(enterText);
		
		otherText = new FlxText(0, 0, FlxG.width, "" , 44);
		otherText.setFormat('Pixel Arial 11 Bold', 44, FlxColor.WHITE, CENTER);
		if (!FlxG.save.data.deathHoloUnlocked)
		{
			otherText.text = "Asset Password:"
			+ "\nsenpaiandtankman11";
		}		
		else
		{
			otherText.text = "No locked assets."
			+ "\nPress Enter to Continue";
		}	
		
		otherText.screenCenter();
		otherText.y += 50;
		otherText.visible = false;
		add(otherText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		if (FlxG.save.data.deathUnlocked && !FlxG.save.data.seenDeathPassword)
		{
			FlxG.sound.play(Paths.sound('unlock', 'shared'));
			blackScreen.visible = true;
			enterText.visible = true;
			otherText.visible = true;
			inUnlockMenu = true;
			FlxG.save.data.seenDeathPassword = true;
		}

		if (FlxG.save.data.deathHoloUnlocked && !FlxG.save.data.seenDeathHoloPassword)
		{
			FlxG.sound.play(Paths.sound('unlock', 'shared'));
			blackScreen.visible = true;
			enterText.visible = true;
			otherText.visible = true;
			inUnlockMenu = true;
			FlxG.save.data.seenDeathHoloPassword = true;
		}
			
		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata3(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		if (inUnlockMenu)
		{
			canMove = false;
		}

		if (inUnlockMenu && FlxG.keys.justPressed.ENTER)
		{		
			FlxTween.tween(enterText, {alpha: 0}, 0.5);
			FlxTween.tween(otherText, {alpha: 0}, 0.5);
			FlxTween.tween(blackScreen, {alpha: 0}, 0.5);

			new FlxTimer().start(0.75, function(tmr:FlxTimer)
			{
				inUnlockMenu = false;
				canMove = true;
			});
		}

		scoreText.text = "PERSONAL BEST:" + lerpScore;
		comboText.text = combo + '\n';

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP && canMove)
		{
			changeSelection(-1);
		}
		if (downP && canMove)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P && canMove)
			changeDiff(-1);
		if (controls.RIGHT_P && canMove)
			changeDiff(1);

		if (controls.BACK && canMove)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (accepted && canMove)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.isBETADCIU = false;
			PlayState.isNeonight = false;
			PlayState.isVitor = false;
			PlayState.isBonus = true;
			PlayState.storyDifficulty = curDifficulty;
			canMove = false;

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			var llll = FlxG.sound.play(Paths.sound('confirmMenu')).length;
			grpSongs.forEach(function(e:Alphabet){
				if (e.text != songs[curSelected].songName){
					FlxTween.tween(e, {x: -6000}, llll / 1000,{onComplete:function(e:FlxTween){
					
						if (FlxG.keys.pressed.ALT){
							FlxG.switchState(new ChartingState());
						}else{
							LoadingState.loadAndSwitchState(new PlayState());
						}
					}});
				}else{
					FlxFlicker.flicker(e);
					trace(curSelected);
					FlxTween.tween(e, {x: e.x + 20}, llll/1000);
				}
			
			
			
			
			});
		}

		if (songs[curSelected].songName.toLowerCase() == 'sharkventure')
		{
			infoBG.visible = true;
			infoText.visible = true;
			copyrightText.visible = true;	
		}
		else if (songs[curSelected].songName.toLowerCase() != 'sharkventure')
		{
			infoBG.visible = false;
			infoText.visible = false;
			copyrightText.visible = false;		
		}

		if (infoText.visible == true && FlxG.keys.justPressed.P)
		{
			Main.noCopyright = !Main.noCopyright;
			if (!Main.noCopyright) 
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				copyrightText.text = '\nAlternate Inst: Off';
			}
			else 
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				copyrightText.text = '\nAlternate Inst: On';
			}
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;
		
		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;
		
		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		combo = Highscore.getCombo(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "HARD";
		}
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		combo = Highscore.getCombo(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class SongMetadata3
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
