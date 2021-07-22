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
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';
	var direction:String = '';

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
	var portraitSelever:FlxSprite;
	var portraitZero:FlxSprite;
	var portraitMonika:FlxSprite;
	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitLeftPixel:FlxSprite;
	var portraitRightPixel:FlxSprite;

	var gasp:Bool = false;
	var norm:Bool = false;

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

		portraitWhitty = new FlxSprite(-100, FlxG.height - 700);
		portraitWhitty.frames = Paths.getSparrowAtlas('portraits/whittyPort');
		portraitWhitty.animation.addByPrefix('enter', 'Whitty Portrait Normal', 24, false);
		portraitWhitty.animation.addByPrefix('agitated', 'Whitty Portrait Agitated', 24, false);
		portraitWhitty.animation.addByPrefix('crazy', 'Whitty Portrait Crazy', 24, false);
		portraitWhitty.scrollFactor.set();
		add(portraitWhitty);
		portraitWhitty.visible = false;

		portraitMonika = new FlxSprite(-20, 40);
		portraitMonika.frames = Paths.getSparrowAtlas('portraits/monika');
		portraitMonika.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
		portraitMonika.setGraphicSize(Std.int(portraitMonika.width * PlayState.daPixelZoom * 0.9));
		portraitMonika.updateHitbox();
		portraitMonika.scrollFactor.set();
		add(portraitMonika);
		portraitMonika.visible = false;
		
		portraitZero = new FlxSprite(-300, 20);
		portraitZero.frames = Paths.getSparrowAtlas('portraits/016portrait');
		portraitZero.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
		portraitZero.scrollFactor.set();
		add(portraitZero);
		portraitZero.visible = false;

		portraitSelever = new FlxSprite(200, FlxG.height - 575);
		portraitSelever.frames = Paths.getSparrowAtlas('portraits/mfmportraits');
		portraitSelever.animation.addByPrefix('happy', 'SelHappy', 24, false);
		portraitSelever.animation.addByPrefix('smile', 'SelSmile', 24, false);
		portraitSelever.animation.addByPrefix('XD', 'SelXD', 24, false);
		portraitSelever.animation.addByPrefix('angry', 'SelAngery', 24, false);
		portraitSelever.animation.addByPrefix('upset', 'SelUpset', 24, false);
		portraitSelever.animation.addByPrefix('tf', 'SelTF', 24, false);
		portraitSelever.scrollFactor.set();
		add(portraitSelever);
		portraitSelever.visible = false;

		portraitBFPixel = new FlxSprite(0, 40);
		portraitBFPixel.frames = Paths.getSparrowAtlas('portraits/bfPortrait');
		portraitBFPixel.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitBFPixel.setGraphicSize(Std.int(portraitBFPixel.width * PlayState.daPixelZoom * 0.9));
		portraitBFPixel.updateHitbox();
		portraitBFPixel.scrollFactor.set();
		add(portraitBFPixel);
		portraitBFPixel.visible = false;

		portraitSarv = new FlxSprite(200, FlxG.height - 550);
		portraitSarv.frames = Paths.getSparrowAtlas('portraits/mfmportraits');
		portraitSarv.animation.addByPrefix('happy', 'SarvHappy', 24, false);
		portraitSarv.animation.addByPrefix('sad', 'SarvSad', 24, false);
		portraitSarv.animation.addByPrefix('upset', 'SarvUpset', 24, false);
		portraitSarv.animation.addByPrefix('angry', 'SarvAngery', 24, false);
		portraitSarv.animation.addByPrefix('smile', 'SarvSmile', 24, false);
		portraitSarv.animation.addByPrefix('devil', 'SarvDevil', 24, false);
		portraitSarv.scrollFactor.set();
		add(portraitSarv);
		portraitSarv.visible = false;

		portraitGF = new FlxSprite(0, 20);
		portraitGF.frames = Paths.getSparrowAtlas('portraits/gfPort');
		portraitGF.animation.addByPrefix('enter', 'GF Portrait Normal', 24, false);
		portraitGF.scrollFactor.set();
		add(portraitGF);
		portraitGF.visible = false;

		portraitLeft = new FlxSprite(0, 20);
		portraitLeft.frames = Paths.getSparrowAtlas('portraits/gfPort');
		portraitLeft.animation.addByPrefix('enter', 'GF Portrait Normal', 24, false);
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 20);
		portraitRight.frames = Paths.getSparrowAtlas('portraits/gfPort');
		portraitRight.animation.addByPrefix('enter', 'GF Portrait Normal', 24, false);
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		portraitLeftPixel = new FlxSprite(-20, 40);
		portraitLeftPixel.frames = Paths.getSparrowAtlas('portraits/senpaiPortrait');
		portraitLeftPixel.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeftPixel.setGraphicSize(Std.int(portraitLeftPixel.width * PlayState.daPixelZoom * 0.9));
		portraitLeftPixel.updateHitbox();
		portraitLeftPixel.scrollFactor.set();
		add(portraitLeftPixel);
		portraitLeftPixel.visible = false;

		portraitRightPixel = new FlxSprite(0, 40);
		portraitRightPixel.frames = Paths.getSparrowAtlas('portraits/bfPortrait');
		portraitRightPixel.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRightPixel.setGraphicSize(Std.int(portraitRightPixel.width * PlayState.daPixelZoom * 0.9));
		portraitRightPixel.updateHitbox();
		portraitRightPixel.scrollFactor.set();
		add(portraitRightPixel);
		portraitRightPixel.visible = false;

		
		box.animation.play('normalOpen');
		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'roses')
		{
			box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		}
		
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		if (PlayState.curStage.contains('school'))
		{
			trace('IS IN SENPAI STAGE');
		}
		else
			box.x += 50;
		portraitSenpai.screenCenter(X);

		if (!PlayState.curStage.startsWith('school'))
		{
			portraitSenpai.x -= 50;
			portraitSenpai.y += 20;
			portraitBFPixel.x += 50;
			portraitBFPixel.y += 20;
			portraitMonika.x -= 50;
			portraitMonika.y += 20;
			portraitLeftPixel.x -= 50;
			portraitLeftPixel.y += 20;
			portraitRightPixel.x += 50;
			portraitRightPixel.y += 20;
		}

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

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'whittyvssarv')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitSenpai.visible = false;
						portraitBFPixel.visible = false;
						portraitWhitty.visible = false;
						portraitSarv.visible = false;
						portraitZero.visible = false;
						portraitSelever.visible = false;
						portraitMonika.visible = false;
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

	/*function tweenShit(id:String):Void
	{
		alpha = 0;
		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			alpha += 0.1;

			if (direction == 'right')
			{
				FlxTween.tween(id, {y: y - 100}, 1);
			}
			else
			{
				FlxTween.tween(id, {y: y + 100}, 1);
			}

			if (alpha < 1)
			{
				tmr.reset(0.1);
			}
		});	
	}*/

	/*function visibilityShit():Void
	{
		portraitSenpai.visible = false;
		portraitBFPixel.visible = false;
		portraitWhitty.visible = false;
		portraitSarv.visible = false;
		portraitGF.visible = false;
		portraitZero.visible = false;
		portraitMonika.visible = false;
		portraitSelever.visible = false;
		portraitLeft.visible = false;
		portraitRight.visible = false;
		portraitLeftPixel.visible = false;
		portraitRightPixel.visible = false;
	}*/

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
				portraitZero.visible = false;
				portraitMonika.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;			
				if (!portraitSenpai.visible)
				{
					portraitSenpai.visible = true;
					portraitSenpai.animation.play('enter');
				}

			case 'whitty':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitMonika.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitWhitty.visible|| portraitWhitty.animation.curAnim.name != 'enter')
				{		
					portraitWhitty.visible = true;		
					portraitWhitty.animation.play('enter');
				}

			case 'whitty-mad':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitMonika.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitWhitty.visible || portraitWhitty.animation.curAnim.name != 'agitated')
				{
					portraitWhitty.visible = true;
					portraitWhitty.animation.play('agitated');
				}

			case 'sarv':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitMonika.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitSarv.visible || portraitSarv.animation.curAnim.name != 'happy')
				{
					portraitSarv.visible = true;
					portraitSarv.animation.play('happy');
				}

			case 'gf-gunpoint':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitZero.visible = false;
				portraitMonika.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitGF.visible)
				{
					portraitGF.visible = true;
					portraitGF.animation.play('enter');
				}

			case 'shadowman':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitGF.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitZero.visible = false;
				portraitMonika.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitRight.visible || (portraitRight.visible && portraitRight.frames != Paths.getSparrowAtlas('portraits/WhoDisBlanta')))
				{
					portraitRight.visible = true;
					portraitRight.frames = Paths.getSparrowAtlas('portraits/WhoDisBlanta');
					portraitRight.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitRight.animation.play('enter');
				}
				
			case 'sarv-smile':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitMonika.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitSarv.visible || portraitSarv.animation.curAnim.name != 'smile')
				{
					portraitSarv.visible = true;
					portraitSarv.animation.play('smile');
				}

			case 'zero':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitMonika.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitZero.visible || (portraitZero.visible && portraitZero.frames != Paths.getSparrowAtlas('portraits/016portrait')))
				{
					portraitZero.visible = true;
					portraitZero.frames = Paths.getSparrowAtlas('portraits/016portrait');
					portraitZero.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitZero.animation.play('enter');
				}

			case 'zerohuh':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitMonika.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitZero.visible || (portraitZero.visible && portraitZero.frames != Paths.getSparrowAtlas('portraits/016huh')))
				{
					portraitZero.visible = true;
					portraitZero.frames = Paths.getSparrowAtlas('portraits/016huh');
					portraitZero.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitZero.animation.play('enter');
				}

			case 'zerosmile':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitMonika.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitZero.visible || (portraitZero.visible && portraitZero.frames != Paths.getSparrowAtlas('portraits/016smile')))
				{
					portraitZero.visible = true;
					portraitZero.frames = Paths.getSparrowAtlas('portraits/016smile');
					portraitZero.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitZero.animation.play('enter');
				}

			case 'monika':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitMonika.visible || (portraitMonika.visible && portraitMonika.frames != Paths.getSparrowAtlas('portraits/monika')))
				{
					portraitMonika.visible = true;
					portraitMonika.frames = Paths.getSparrowAtlas('portraits/monika');
					portraitMonika.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitMonika.animation.play('enter');
				}

			case 'monikaright':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitMonika.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;	
				if (!portraitRightPixel.visible || (portraitRightPixel.visible && portraitRightPixel.frames != Paths.getSparrowAtlas('portraits/monikaright')))
				{
					portraitRightPixel.visible = true;
					portraitRightPixel.frames = Paths.getSparrowAtlas('portraits/monikaright');
					portraitRightPixel.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitRightPixel.animation.play('enter');
				}

			case 'monikaangry':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitMonika.visible || (portraitMonika.visible && portraitMonika.frames != Paths.getSparrowAtlas('portraits/monikaangry')))
				{
					portraitMonika.visible = true;
					portraitMonika.frames = Paths.getSparrowAtlas('portraits/monikaangry');
					portraitMonika.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitMonika.animation.play('enter');
				}

			case 'monikaangryright':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitMonika.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;	
				if (!portraitRightPixel.visible || (portraitRightPixel.visible && portraitRightPixel.frames != Paths.getSparrowAtlas('portraits/monikaangryright')))
				{
					portraitRightPixel.visible = true;
					portraitRightPixel.frames = Paths.getSparrowAtlas('portraits/monikaangryright');
					portraitRightPixel.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitRightPixel.animation.play('enter');
				}

			case 'monikagasp':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitMonika.visible || (portraitMonika.visible && portraitMonika.frames != Paths.getSparrowAtlas('portraits/monikagaspleft')))
				{
					portraitMonika.visible = true;
					portraitMonika.frames = Paths.getSparrowAtlas('portraits/monikagaspleft');
					portraitMonika.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitMonika.animation.play('enter');
				}

			case 'monikagaspright':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitMonika.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				if (!portraitRightPixel.visible || (portraitRightPixel.visible && portraitRightPixel.frames != Paths.getSparrowAtlas('portraits/monikagasp')))
				{
					portraitRightPixel.visible = true;
					portraitRightPixel.frames = Paths.getSparrowAtlas('portraits/monikagasp');
					portraitRightPixel.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitRightPixel.animation.play('enter');
				}

			case 'monikahappy':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitMonika.visible || (portraitMonika.visible && portraitMonika.frames != Paths.getSparrowAtlas('portraits/monikahappy')))
				{
					portraitMonika.visible = true;
					portraitMonika.frames = Paths.getSparrowAtlas('portraits/monikahappy');
					portraitMonika.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitMonika.animation.play('enter');
				}

			case 'monikahappyright':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitMonika.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;	
				if (!portraitRightPixel.visible || (portraitRightPixel.visible && portraitRightPixel.frames != Paths.getSparrowAtlas('portraits/monikahappyright')))
				{
					portraitRightPixel.visible = true;
					portraitRightPixel.frames = Paths.getSparrowAtlas('portraits/monikahappyright');
					portraitRightPixel.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitRightPixel.animation.play('enter');
				}

			case 'monikahmm':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitMonika.visible || (portraitMonika.visible && portraitMonika.frames != Paths.getSparrowAtlas('portraits/monikahmm')))
				{
					portraitMonika.visible = true;
					portraitMonika.frames = Paths.getSparrowAtlas('portraits/monikahmm');
					portraitMonika.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitMonika.animation.play('enter');
				}
					
			case 'bf-pixel':
				portraitSenpai.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitMonika.visible = false;
				portraitSelever.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitBFPixel.visible)
				{
					portraitBFPixel.visible = true;
					portraitBFPixel.animation.play('enter');
				}	
				
			case 'sel':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitMonika.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitSelever.visible || (portraitSelever.visible && portraitSelever.animation.curAnim.name != ('happy')))
				{
					portraitSelever.visible = true;
					portraitSelever.animation.play('happy');
				}

			case 'selsmile':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitMonika.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitSelever.visible || (portraitSelever.visible && portraitSelever.animation.curAnim.name != ('smile')))
				{
					portraitSelever.visible = true;
					portraitSelever.animation.play('smile');
				}

			case 'selupset':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitMonika.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitSelever.visible || (portraitSelever.visible && portraitSelever.animation.curAnim.name != ('upset')))
				{
					portraitSelever.visible = true;
					portraitSelever.animation.play('upset');
				}

			case 'selxd':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitMonika.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitSelever.visible || (portraitSelever.visible && portraitSelever.animation.curAnim.name != ('XD')))
				{
					portraitSelever.visible = true;
					portraitSelever.animation.play('XD');
				}

			case 'selangry':
				portraitSenpai.visible = false;
				portraitBFPixel.visible = false;
				portraitWhitty.visible = false;
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitZero.visible = false;
				portraitMonika.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitSelever.visible || (portraitSelever.visible && portraitSelever.animation.curAnim.name != ('angry')))
				{
					portraitSelever.visible = true;
					portraitSelever.animation.play('angry');
				}
			
			case 'seltf':
				portraitSarv.visible = false;
				portraitGF.visible = false;
				portraitSenpai.visible = false;
				portraitWhitty.visible = false;
				portraitBFPixel.visible = false;
				portraitMonika.visible = false;
				portraitZero.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeftPixel.visible = false;
				portraitRightPixel.visible = false;		
				if (!portraitSelever.visible || (portraitSelever.visible && portraitSelever.animation.curAnim.name != ('tf')))
				{
					portraitSelever.visible = true;
					portraitSelever.animation.play('tf');
				}
		}

		switch (direction)
		{
			case 'faceright':
				if (portraitZero.flipX == false)
				{
					portraitZero.animation.play('enter');
					portraitZero.flipX = true;
				}

				if (portraitBFPixel.flipX == true)
				{
					portraitBFPixel.animation.play('enter');
					portraitBFPixel.flipX = false;
				}

				if (portraitSenpai.flipX == false)
				{
					portraitSenpai.animation.play('enter');
					portraitSenpai.flipX = true;
				}

				if (portraitRightPixel.flipX == true)
				{
					portraitRightPixel.animation.play('enter');
					portraitRightPixel.flipX = false;
				}

				if (portraitLeftPixel.flipX == false)
				{
					portraitLeftPixel.animation.play('enter');
					portraitLeftPixel.flipX = true;
				}

				portraitSarv.flipX = true;
				portraitGF.flipX = true;
				portraitWhitty.flipX = true;
				portraitMonika.flipX = false;
				portraitSelever.flipX = true;
				
		
				portraitZero.x = 50;
				portraitBFPixel.x = 0;
				portraitGF.x = 0;
				portraitSenpai.x = 0;
				portraitMonika.x = 0;
				portraitSarv.x = 800;
				portraitSelever.x = 800;
				portraitWhitty.x = 0;
				portraitLeftPixel.x = 0;
				portraitRightPixel.x = 0;		

				if (!PlayState.curStage.contains('school'))
				{
					box.flipX = false;
				}	

			case 'faceleft':
				if (portraitZero.flipX == true)
				{
					portraitZero.animation.play('enter');
					portraitZero.flipX = false;
				}

				if (portraitBFPixel.flipX == false)
				{
					portraitBFPixel.animation.play('enter');
					portraitBFPixel.flipX = true;
				}

				if (portraitSenpai.flipX == true)
				{
					portraitSenpai.animation.play('enter');
					portraitSenpai.flipX = false;
				}

				if (portraitRightPixel.flipX == false)
				{
					portraitRightPixel.animation.play('enter');
					portraitRightPixel.flipX = true;
				}

				if (portraitLeftPixel.flipX == true)
				{
					portraitLeftPixel.animation.play('enter');
					portraitLeftPixel.flipX = false;
				}

				portraitSarv.flipX = false;
				portraitGF.flipX = false;
				portraitWhitty.flipX = false;
				portraitMonika.flipX = false;
				portraitSelever.flipX = false;
				
				portraitZero.x = -300;
				portraitBFPixel.x = -20;
				portraitGF.x = 0;
				portraitSenpai.x = -20;
				portraitMonika.x = -20;
				portraitSarv.x = 200;
				portraitSelever.x = 200;
				portraitWhitty.x = -100;
				portraitLeftPixel.x = -20;
				portraitRightPixel.x = -20;

				if (!PlayState.curStage.contains('school'))
				{
					box.flipX = true;
				}	

			case 'default':
				if (portraitZero.flipX == true)
				{
					portraitZero.animation.play('enter');
					portraitZero.flipX = false;
				}

				if (portraitBFPixel.flipX == true)
				{
					portraitBFPixel.animation.play('enter');
					portraitBFPixel.flipX = false;
				}

				if (portraitSenpai.flipX == true)
				{
					portraitSenpai.animation.play('enter');
					portraitSenpai.flipX = false;
				}

				if (portraitRightPixel.flipX == true)
				{
					portraitRightPixel.animation.play('enter');
					portraitRightPixel.flipX = false;
				}

				if (portraitLeftPixel.flipX == true)
				{
					portraitLeftPixel.animation.play('enter');
					portraitLeftPixel.flipX = false;
				}

				portraitSarv.flipX = false;
				portraitGF.flipX = false;
				portraitWhitty.flipX = false;
				portraitMonika.flipX = false;
				portraitSelever.flipX = false;

				portraitZero.x = -300;
				portraitBFPixel.x = 0;
				portraitGF.x = 0;
				portraitSenpai.x = -20;
				portraitMonika.x = -20;
				portraitSarv.x = 200;
				portraitSelever.x = 200;
				portraitWhitty.x = -100;
				portraitLeftPixel.x = -20;
				portraitRightPixel.x = 0;

				if (!PlayState.curStage.contains('school'))
				{
					if (curCharacter.contains('gf') || curCharacter.contains('right') || curCharacter.contains('shadowman'))
					{
						box.flipX = false;
					}
					else
					{
						box.flipX = true;
					}
				}	
		}

	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		direction = splitName[2];

		if (splitName[2] == 'faceright' || splitName[2] == 'faceleft')
		{
			dialogueList[0] = dialogueList[0].substr(splitName[1].length + splitName[2].length + 3).trim();
		}
		else
		{
			direction = 'default';
			dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
		}		
	}
}
