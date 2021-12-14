package;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.FlxCamera;
import flixel.addons.ui.FlxInputText;

using StringTools;

class TextSubState extends MusicBeatSubstate
{
	var selectedWord:String;
	var realWord:String = '';
	var position:Int = 0;
	var writtenText:FlxInputText; //yeah i changed the way this works to how my password system works
	var poemText:FlxText; //yeah i changed the way this works to how my password system works
	//i couldn't think of many words
	var words:Array<String> = [
		'Unhardcoded Baby!'
	];

	var lines:FlxTypedGroup<FlxSprite>;
	var daBox:FlxSprite;
	var unowns:FlxTypedSpriteGroup<FlxSprite>;
	public var win:Void->Void = null;
	public var lose:Void->Void = null;
	var timer:Int = 10;
	var timerTxt:FlxText;
	public function new(theTimer:Int = 15, word:String = '')
	{
		//unhardcoded the words so you can add extras.
		words = CoolUtil.coolTextFile(Paths.txt('unownWords'));

		timer = theTimer;
		super();
		var overlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFB3DFd8);
		overlay.alpha = 0.4;
		add(overlay);
		selectedWord = words[FlxG.random.int(0, words.length - 1)];
		switch (FlxG.random.int(0, 100)) {
			case 50:
				selectedWord = 'Nice Cock';
			case 51:
				selectedWord = 'Yeah you lost theres no way youre typing all of this';
			case 52:
				selectedWord = 'booba';
			case 53:
				selectedWord = 'Parfait Girls';
			case 54:
				selectedWord = 'Deez Nuts';
			case 55:
				selectedWord = 'Ratio';
		}
		if (word != '')
			selectedWord = word;
		//i forgor if there's a function to do this
		var splitWord = selectedWord.split(' ');
		var dum:Bool = false;
		realWord = selectedWord;
		trace(realWord);

		daBox = new FlxSprite(0, 0).loadGraphic(Paths.image('doki/box')); 
		daBox.screenCenter();
		add(daBox);
		
		/*lines = new FlxTypedGroup<FlxSprite>();
		add(lines);

		unowns = new FlxTypedSpriteGroup<FlxSprite>();
		add(unowns);
		
		var realThing:Int = 0;
		for (i in 0...selectedWord.length) {
			if (!selectedWord.isSpace(i)) 
			{
				var unown:FlxSprite = new FlxSprite(0, 90);
				//unown.x += 350 - (35 * selectedWord.length);
				//var thing = 1 - (0.05 * selectedWord.length); 
				if (260 - (15 * selectedWord.length) <= 0)
					unown.x += 40 * i;
				else
					unown.x += (260 - (15 * selectedWord.length)) * i;
				var realScale = 1 - (0.05 * selectedWord.length); 
				if (realScale < 0.2)
					realScale = 0.2;
				unown.scale.set(realScale, realScale);
				unown.updateHitbox();
				unown.frames = Paths.getSparrowAtlas('Unown_Alphabet', 'shared');
				unown.animation.addByPrefix('idle', selectedWord.charAt(i), 24, true);
				unown.animation.play('idle');
				unowns.add(unown);

				var line:FlxSprite = new FlxSprite(unown.x, unown.y).loadGraphic(Paths.image('line', 'shared'));
				line.y += 500;
				line.scale.set(unown.scale.x, unown.scale.y);
				line.updateHitbox();
				line.ID = realThing;
				lines.add(line);
				realThing++;
			}
		}

		unowns.screenCenter(X);
		for (i in 0...lines.length) {
			lines.members[i].x = unowns.members[i].x;
		}*/

		poemText = new FlxText(0, 0, 0, realWord, 48);
		poemText.setFormat( Paths.font('Aller_Rg'), 48, FlxColor.BLACK, CENTER);
		poemText.screenCenter();
		poemText.y -= 100;
		add(poemText);

		writtenText = new FlxInputText(0, 300, 550, '', 36, FlxColor.BLACK, 0xFFFEE6F4);
		writtenText.fieldBorderColor = FlxColor.WHITE;
		writtenText.fieldBorderThickness = 3;
		writtenText.hasFocus = true;
		writtenText.screenCenter();
		//writtenText.y += 75;
		writtenText.font = Paths.font('Hallogen.ttf');
		add(writtenText);

		timerTxt = new FlxText(FlxG.width / 2 - 10, 430, 0, '0', 32);
		timerTxt.alignment = 'center';
		timerTxt.font = Paths.font('RifficFree-Bold.ttf');
		timerTxt.borderColor = 0xFFBA5A99;
		timerTxt.borderSize = 3;
		timerTxt.borderStyle = FlxTextBorderStyle.OUTLINE;
		add(timerTxt);
		timerTxt.text = Std.string(timer);
	}

	function correctLetter() {
		close();
		win();
		FlxG.sound.play(Paths.sound('CORRECT', 'shared'));
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER && writtenText.text == realWord)
			correctLetter();
		else if (FlxG.keys.justPressed.ENTER && writtenText.text != realWord)
		{
			writtenText.text = "";
			FlxG.sound.play(Paths.sound('glitch', 'shared'));
		}

		/*for (i in lines) {
			if (i.ID == position) {
				FlxFlicker.flicker(i, 1.3, 1, true, false);
			} else if (i.ID < position) {
				i.visible = false;
				i.alpha = 0;
			}
		}
		if (FlxG.keys.justPressed.ANY) {
			if (realWord.charAt(position) == '?') {
				if (FlxG.keys.justPressed.SLASH && FlxG.keys.pressed.SHIFT)
					correctLetter();
				else if (!FlxG.keys.justPressed.SHIFT)
					FlxG.sound.play(Paths.sound('BUZZER', 'shared'));
			} else if (realWord.charAt(position) == '!') {
				if (FlxG.keys.justPressed.ONE && FlxG.keys.pressed.SHIFT)
					correctLetter();
				else if (!FlxG.keys.justPressed.SHIFT)
					FlxG.sound.play(Paths.sound('BUZZER', 'shared'));
			} else {
				if (FlxG.keys.anyJustPressed([FlxKey.fromString(realWord.charAt(position))])) {
					correctLetter();
				} else
					FlxG.sound.play(Paths.sound('BUZZER', 'shared'));
			}
		}*/
	}

	override function beatHit()
	{
		super.beatHit();
		if (timer > 0)
			timer--;
		else {
			close();
			lose();	
		}
		timerTxt.text = Std.string(timer);
	}

	override public function close() {
		FlxG.autoPause = true;
		super.close();
	}
}
