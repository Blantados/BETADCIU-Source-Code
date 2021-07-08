package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitSenpai:FlxSprite;
	var portraitBFPixel:FlxSprite;
	var portraitHDSenpai:FlxSprite;
	var portraitHDSenpaiLeft:FlxSprite;
	var portraitTankman:FlxSprite;
	var portraitTankmanHappy:FlxSprite;
	var portraitTankmanSmile:FlxSprite;
	var portraitWhitty:FlxSprite;
	var portraitSarv:FlxSprite;
	var portraitGF:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'whittyvssarv':
				FlxG.sound.playMusic(Paths.music('gunsDialogue'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);

			case 'roses' | 'roses-remix' | 'roses-remix-senpai':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
				
			case 'whittyvssarv':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
				
			case 'dialogue':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);

			default:
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
			
		}
		
		if (!PlayState.curStage.startsWith('school'))
		{
			box.y += 320;
			box.x += 500;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitSenpai = new FlxSprite(-20, 40);
		portraitSenpai.frames = Paths.getSparrowAtlas('portraits/senpaiPortrait');
		portraitSenpai.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitSenpai.setGraphicSize(Std.int(portraitSenpai.width * PlayState.daPixelZoom * 0.9));
		portraitSenpai.updateHitbox();
		portraitSenpai.scrollFactor.set();
		add(portraitSenpai);
		portraitSenpai.visible = false;

		portraitWhitty = new FlxSprite(0, 20);
		portraitWhitty.frames = Paths.getSparrowAtlas('portraits/whittyPort');
		portraitWhitty.animation.addByPrefix('enter', 'Whitty Portrait Normal', 24, false);
		portraitWhitty.animation.addByPrefix('agitated', 'Whitty Portrait Agitated', 24, false);
		portraitWhitty.scrollFactor.set();
		add(portraitWhitty);
		portraitWhitty.visible = false;

		portraitBFPixel = new FlxSprite(0, 40);
		portraitBFPixel.frames = Paths.getSparrowAtlas('portraits/bfPortrait');
		portraitBFPixel.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitBFPixel.setGraphicSize(Std.int(portraitBFPixel.width * PlayState.daPixelZoom * 0.9));
		portraitBFPixel.updateHitbox();
		portraitBFPixel.scrollFactor.set();
		add(portraitBFPixel);
		portraitBFPixel.visible = false;

		portraitSarv = new FlxSprite(0, 20);
		portraitSarv.frames = Paths.getSparrowAtlas('portraits/sarvPort');
		portraitSarv.animation.addByPrefix('enter', 'Sarv Portrait Normal', 24, false);
		portraitSarv.animation.addByPrefix('smile', 'Sarv Portrait Smile', 24, false);
		portraitSarv.scrollFactor.set();
		add(portraitSarv);
		portraitSarv.visible = false;

		portraitGF = new FlxSprite(0, 20);
		portraitGF.frames = Paths.getSparrowAtlas('portraits/gfPort');
		portraitGF.animation.addByPrefix('enter', 'GF Portrait Normal', 24, false);
		portraitGF.scrollFactor.set();
		add(portraitGF);
		portraitGF.visible = false;
		
		box.animation.play('normalOpen');
		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		}
		
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		if (PlayState.curStage == 'school' || PlayState.curStage == 'schoolEvil')
		{
			trace('IS IN SENPAI STAGE');
		}
		else
			box.x += 50;
		portraitSenpai.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitSenpai.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitSenpai.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'WhittyVsSarv')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitSenpai.visible = false;
						portraitBFPixel.visible = false;
						portraitWhitty.visible = false;
						portraitSarv.visible = false;
						portraitGF.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'senpai':
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				if (!portraitSenpai.visible)
				{
					portraitSenpai.visible = true;
					portraitSenpai.animation.play('enter');
				}

			case 'whitty':
				portraitBFPixel.visible = false;
				portraitSenpai.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				box.flipX = true;
				if (!portraitWhitty.visible|| portraitWhitty.animation.curAnim.name != 'enter')
				{
					portraitWhitty.visible = true;
					portraitWhitty.animation.play('enter');
				}

			case 'whitty-mad':
				portraitBFPixel.visible = false;
				portraitSenpai.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				box.flipX = true;
				if (!portraitWhitty.visible || portraitWhitty.animation.curAnim.name != 'agitated')
				{
					portraitWhitty.visible = true;
					portraitWhitty.animation.play('agitated');
				}

			case 'sarv':
				portraitBFPixel.visible = false;
				portraitSenpai.visible = false;
				portraitWhitty.visible = false;
				portraitGF.visible = false;
				box.flipX = false;
				if (!portraitSarv.visible || portraitSarv.animation.curAnim.name != 'enter')
				{
					portraitSarv.visible = true;
					portraitSarv.animation.play('enter');
				}

			case 'gf-gunpoint':
				portraitBFPixel.visible = false;
				portraitSenpai.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				box.flipX = false;
				if (!portraitGF.visible)
				{
					portraitGF.visible = true;
					portraitGF.animation.play('enter');
				}
				
			case 'sarv-smile':
				portraitBFPixel.visible = false;
				portraitSenpai.visible = false;
				portraitWhitty.visible = false;
				portraitGF.visible = false;
				box.flipX = false;
				if (!portraitSarv.visible || portraitSarv.animation.curAnim.name != 'smile')
				{
					portraitSarv.visible = true;
					portraitSarv.animation.play('smile');
				}
				
				
			case 'bf-pixel':
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitSenpai.visible = false;
				portraitWhitty.visible = false;
				if (!portraitBFPixel.visible)
				{
					portraitBFPixel.visible = true;
					portraitBFPixel.animation.play('enter');
				}			
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
