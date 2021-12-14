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
import sys.FileSystem;

#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class GuestBETADCIUState extends MusicBeatState
{
	var songs:Array<SongMetadata7> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 5;

	var scoreText:FlxText;
	var diffText:FlxText;
	var comboText:FlxText;
	var text2:FlxText;
	var text3:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var combo:String = '';
	var canMove:Bool = true;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	public static var downscroll:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	public var ytIcon:FlxSprite;

	override function create()
	{
		FlxG.mouse.visible = true;

		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.fadeIn(2, 0, 0.8);
			FlxG.sound.playMusic(Paths.music('guest'), 0);
		}	

		 #if desktop
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In Guest BETADCIU Menu", null);
		 #end

		var isDebug:Bool = false;

		MainMenuState.mainMusic = false;
		canMove = true;

		#if debug
		isDebug = true;
		#end

			addWeek(['Epiphany', "Rabbit's-Luck",/* 'Ghost-VIP'*/], 1, ['bigmonika', 'oswald-happy',/* 'camellia'*/]);

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFfd719b;
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

		ytIcon = new FlxSprite().loadGraphic(Paths.image('extraIcons'), true, 176, 176);
		ytIcon.setGraphicSize(Std.int(ytIcon.width * 1.2));
		ytIcon.scrollFactor.set();
		ytIcon.screenCenter();
		ytIcon.x += 350;
		ytIcon.y -= 50;
		ytIcon.animation.add('snow', [0]);
		ytIcon.animation.add('spres', [1]);
		ytIcon.animation.play('snow');
		add(ytIcon);

		var text1 = new FlxText(ytIcon.x - 150, ytIcon.y + 220, 0, "This BETADCIU was made by:", 32);
		text1.setFormat(Paths.font("Aller_Rg.ttf"), 36, FlxColor.WHITE, CENTER);
		text1.borderColor = FlxColor.BLACK;
		text1.borderSize = 3;
		text1.borderStyle = FlxTextBorderStyle.OUTLINE;
		text1.bold = true;
		add(text1);

		text2 = new FlxText(ytIcon.x - 150, text1.y + 60, 0, "", 36);
		text2.setFormat('Pixel Arial 11 Bold', 36, FlxColor.RED, CENTER);
		text2.borderColor = FlxColor.BLACK;
		text2.borderSize = 3;
		text2.borderStyle = FlxTextBorderStyle.OUTLINE;
		text2.bold = true;
		add(text2);

		text3 = new FlxText(ytIcon.x - 110, text2.y + 65, 0, "Link to their channel!", 40);
		text3.setFormat(Paths.font("Aller_Rg.ttf"), 40, FlxColor.fromString('#FF0078D4'), CENTER);
		text3.borderColor = FlxColor.BLACK;
		text3.borderSize = 3;
		text3.borderStyle = FlxTextBorderStyle.OUTLINE;
		text3.bold = true;
		add(text3);

		changeSelection();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */
 

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata7(songName, weekNum, songCharacter));
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

		if (FlxG.mouse.overlaps(text3)) //this is like...  way easier than that isOnBtt stuff
		{
			text3.color = 0xFF77BDFF;
			if (FlxG.mouse.justPressed && canMove)
			{
				switch (songs[curSelected].songName.toLowerCase())
				{
					case 'epiphany':
						fancyOpenURL("https://www.youtube.com/channel/UCCAE5-m4RfHeVOQq5OY02AQ");
					case "rabbit's-luck":
						fancyOpenURL("https://www.youtube.com/c/spres");
				}
				
			}
		}
		else if (!FlxG.mouse.overlaps(text3))
			text3.color = 0xFF0078D4;

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

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
			PlayState.isNeonight = false;
			PlayState.isVitor = false;
			PlayState.isBETADCIU = true;
			PlayState.isBonus = false;
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

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		combo = Highscore.getCombo(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 5:
				diffText.text = "HARD";
		}
	}

	public function changeIcon():Void
	{
		switch (songs[curSelected].songName.toLowerCase())
		{
			case 'epiphany':
			{
				ytIcon.animation.play('snow');
				text2.text = "Snow The Fox";
				text2.color = 0xFFB94545;
				text2.x = 790;
			}
			case "rabbit's-luck":
			{
				ytIcon.animation.play('spres');
				text2.text = 'spres';
				text2.color = 0xFF3F47CC;
				text2.x = 910;
			}		
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

		changeIcon();

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

class SongMetadata7
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
