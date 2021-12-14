package;

import flixel.addons.effects.FlxSkewedSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end
import PlayState;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var modifiedByLua:Bool = false;
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var noteType:Int = 0;
	public var style:String = "";
	public var mania:Int = 0;
	public var dType:Int = 0;
	public var pixelBurn:Bool = false;
	public var blackStatic:Bool = false;

	public var noteScore:Float = 1;

	//different notes
	public var markov:Bool = false;
	public var danger:Bool = false;
	public var burning:Bool = false;
	public var staticNote:Bool = false;
	public var bomb:Bool = false;
	public var neonNote:Bool = false;

	public static var swagWidth:Float = 160 * 0.7;
	public static var noteScale:Float;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public var rating:String = "shit";

	public function new(_strumTime:Float, _noteData:Int, ?_prevNote:Note, ?sustainNote:Bool = false, ?noteType:Int = 0, style:String = 'normal')
	{
		super();

		if (prevNote == null)
			prevNote = this;

		prevNote = _prevNote;
		this.noteType = noteType;
		isSustainNote = sustainNote;
		this.style = style;

		swagWidth = 160 * 0.7; //factor not the same as noteScale
		noteScale = 0.7;
		mania = 0;
		switch (PlayState.SONG.mania)
		{
			case 1:
				swagWidth = 120 * 0.7;
				noteScale = 0.6;
				mania = 1;
			case 2:
				swagWidth = 90 * 0.7;
				noteScale = 0.46;
				mania = 2;
			case 3:
				swagWidth = 140 * 0.7;
				noteScale = 0.66;
				mania = 3;
		}

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;

		strumTime = _strumTime;

		if (this.strumTime < 0 )
			this.strumTime = 0;

		if (PlayState.curStage == 'auditorHell')
			burning = _noteData > 7;

		if (PlayState.SONG.song.toLowerCase() == 'hill-of-the-void')
			neonNote = _noteData > 7;

		noteData = _noteData % Main.keyAmmo[mania];
		
		var daStage:String = PlayState.curStage;

		if(isSustainNote && prevNote.burning && PlayState.curStage == 'auditorHell') 
		{ 
			burning = true;
		}

		if(isSustainNote) 
		{ 
			switch (noteType)
			{
				case 2:
					markov = true;
				case 3:
					danger = true;
				case 4:
					burning = true;
				case 5:
					staticNote = true;
				case 6:
					bomb = true;
			}			
		}

		//defaults if no noteStyle was found in chart
		var noteTypeCheck:String = 'normal';

		switch (style)
		{
			case 'pixel' | 'pixel-corrupted' | 'neon' | 'doki-pixel':
				var suf:String = "";
				switch (style)
				{
					case 'pixel-corrupted':
						suf = '-corrupted';
					case 'neon':
						suf = '-neon';
					case 'doki-pixel':
						suf = '-doki';
				}

				loadGraphic(Paths.image('notestuff/arrows-pixels'+suf), true, 17, 17);
						
				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);

				if (isSustainNote)
				{
					loadGraphic(Paths.image('notestuff/arrowEnds'+suf), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			case 'pixel-combined':
				loadGraphic(Paths.image('notestuff/arrows-pixelscombined'), true, 17, 17);

				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);
				
				animation.add('redScroll2', [27]);
				animation.add('greenScroll2', [26]);
				animation.add('blueScroll2', [25]);
				animation.add('purpleScroll2', [24]);

				if (isSustainNote)
				{
					loadGraphic(Paths.image('notestuff/arrowEndscombined'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);

					animation.add('purpleholdend2', [12]);
					animation.add('blueholdend2', [13]);
					animation.add('greenholdend2', [14]);
					animation.add('redholdend2', [15]);
					
					animation.add('purplehold2', [8]);
					animation.add('bluehold2', [9]);
					animation.add('greenhold2', [10]);
					animation.add('redhold2', [11]);			
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			case 'auditor':
				frames = Paths.getSparrowAtlas('notestuff/NOTE_assets');

				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');

				if (burning)
				{
					frames = Paths.getSparrowAtlas('notestuff/ALL_deathnotes');
					animation.addByPrefix('greenScroll', 'Green Arrow');
					animation.addByPrefix('redScroll', 'Red Arrow');
					animation.addByPrefix('blueScroll', 'Blue Arrow');
					animation.addByPrefix('purpleScroll', 'Purple Arrow');
				}

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;	

			case 'normal' | 'gray' | 'corrupted' | 'kapi' | 'cross' | '1930' | 'taki' | 'fever' | 'agoti' | 'void' | 'shootin' | 'holofunk' | 'trollge' | 'starecrown' 
			| 'tabi' | 'sketchy' | 'darker' | 'doki' | 'nyan' | 'amor' | 'bluskys' | 'bf-b&b' | 'bob' | 'bosip' | 'ron' | 'gloopy' | 'party-crasher' | 'eteled' | 'austin'
			| 'stepmania' | 'littleman':
				frames = Paths.getSparrowAtlas('notestuff/'+style);
				
				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;

			case 'exe':
				frames = Paths.getSparrowAtlas('notestuff/exe');

				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');
				animation.addByPrefix('goldScroll', 'gold0');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');
				animation.addByPrefix('goldholdend', 'red hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');
				animation.addByPrefix('goldhold', 'red hold piece');

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;

			case 'guitar':
				frames = Paths.getSparrowAtlas('notestuff/GH_NOTES');

				animation.addByPrefix('greenScroll', 'upNote0');
				animation.addByPrefix('redScroll', 'rightNote0');
				animation.addByPrefix('blueScroll', 'downNote0');
				animation.addByPrefix('purpleScroll', 'leftNote0');

				animation.addByPrefix('purpleholdend', 'leftHoldEnd');
				animation.addByPrefix('greenholdend', 'upHoldEnd');
				animation.addByPrefix('redholdend', 'rightHoldEnd');
				animation.addByPrefix('blueholdend', 'downHoldEnd');

				animation.addByPrefix('purplehold', 'leftHold0');
				animation.addByPrefix('greenhold', 'upHold0');
				animation.addByPrefix('redhold', 'rightHold0');
				animation.addByPrefix('bluehold', 'downHold0');

				antialiasing = true;

			case 'bw':
				frames = Paths.getSparrowAtlas('notestuff/NOTE_assets_BW');

				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;

			case 'empty':
				frames = Paths.getSparrowAtlas('notestuff/Note_Assets_withPixel');

				animation.addByPrefix('greenScroll', 'Up0');
				animation.addByPrefix('redScroll', 'Right0');
				animation.addByPrefix('blueScroll', 'Down0');
				animation.addByPrefix('purpleScroll', 'Left0');

				animation.addByPrefix('purpleholdend', 'LeftHoldEnd');
				animation.addByPrefix('greenholdend', 'UpHoldEnd');
				animation.addByPrefix('redholdend', 'RightHoldEnd');
				animation.addByPrefix('blueholdend', 'DownHoldEnd');

				animation.addByPrefix('purplehold', 'LeftHoldPiece');
				animation.addByPrefix('greenhold', 'UpHoldPiece');
				animation.addByPrefix('redhold', 'RightHoldPiece');
				animation.addByPrefix('bluehold', 'DownHoldPiece');

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;

			default:
				frames = Paths.getSparrowAtlas('notestuff/'+style);

				if (frames == null)
				{
					if (mania > 0)
						frames = Paths.getSparrowAtlas('notestuff/shaggyNotes');
					else
						frames = Paths.getSparrowAtlas('notestuff/NOTE_assets');
				}
				
				
				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');

				if (mania > 0)
				{
					animation.addByPrefix('whiteScroll', 'white0');
					animation.addByPrefix('yellowScroll', 'yellow0');
					animation.addByPrefix('violetScroll', 'violet0');
					animation.addByPrefix('blackScroll', 'black0');
					animation.addByPrefix('darkScroll', 'dark0');

					animation.addByPrefix('whiteholdend', 'white hold end');
					animation.addByPrefix('yellowholdend', 'yellow hold end');
					animation.addByPrefix('violetholdend', 'violet hold end');
					animation.addByPrefix('blackholdend', 'black hold end');
					animation.addByPrefix('darkholdend', 'dark hold end');

					animation.addByPrefix('whitehold', 'white hold piece');
					animation.addByPrefix('yellowhold', 'yellow hold piece');
					animation.addByPrefix('violethold', 'violet hold piece');
					animation.addByPrefix('blackhold', 'black hold piece');
					animation.addByPrefix('darkhold', 'dark hold piece');
				}

				setGraphicSize(Std.int(width * noteScale));
				updateHitbox();
				antialiasing = true;
		}

		switch (noteType)
		{
			case 2:
				if (PlayState.SONG.noteStyle.contains('pixel') || PlayState.isPixel)
				{
					loadGraphic(Paths.image('notestuff/arrows-pixels'), true, 17, 17);
					animation.add('greenScroll', [22]);
					animation.add('redScroll', [23]);
					animation.add('blueScroll', [21]);
					animation.add('purpleScroll', [20]);

					antialiasing = false;
					setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					updateHitbox();
				}
				else
				{
					frames = Paths.getSparrowAtlas('notestuff/markov');

					animation.addByPrefix('greenScroll', 'markov green0');
					animation.addByPrefix('redScroll', 'markov red0');
					animation.addByPrefix('blueScroll', 'markov blue0');
					animation.addByPrefix('purpleScroll', 'markov purple0');

					animation.addByPrefix('purpleholdend', 'markov pruple end hold');
					animation.addByPrefix('greenholdend', 'markov green hold end');
					animation.addByPrefix('redholdend', 'markov red hold end');
					animation.addByPrefix('blueholdend', 'markov blue hold end');

					animation.addByPrefix('purplehold', 'markov purple hold piece');
					animation.addByPrefix('greenhold', 'markov green hold piece');
					animation.addByPrefix('redhold', 'markov red hold piece');
					animation.addByPrefix('bluehold', 'markov blue hold piece');

					setGraphicSize(Std.int(width * 0.7));
					updateHitbox();
					antialiasing = true;
				}
			case 3:
				if (PlayState.SONG.noteStyle.contains('pixel') || PlayState.isPixel)
				{
					loadGraphic(Paths.image('notestuff/warningNotePixel'), true, 16, 16);

					animation.add('greenScroll', [0]);
					animation.add('redScroll', [0]);
					animation.add('blueScroll', [0]);
					animation.add('purpleScroll', [0]);
					pixelBurn = true;

					setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					updateHitbox();
					antialiasing = false;
				}
				else
				{
					loadGraphic(Paths.image('notestuff/warningNote'), true, 157, 154);

					animation.add('greenScroll', [0]);
					animation.add('redScroll', [0]);
					animation.add('blueScroll', [0]);
					animation.add('purpleScroll', [0]);

					setGraphicSize(Std.int(width * noteScale));
					updateHitbox();
					antialiasing = true;
				}	
			case 4:
				if (PlayState.SONG.noteStyle.contains('pixel') || PlayState.isPixel)
				{
					loadGraphic(Paths.image('notestuff/NOTE_fire-pixel'), true, 21, 31);
					
					animation.add('greenScroll', [6, 7, 6, 8], 8);
					animation.add('redScroll', [9, 10, 9, 11], 8);
					animation.add('blueScroll', [3, 4, 3, 5], 8);
					animation.add('purpleScroll', [0, 1 ,0, 2], 8);
					x -= 15;

					setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					updateHitbox();
					antialiasing = false;
				}
				else
				{
					frames = Paths.getSparrowAtlas('notestuff/NOTE_fire');
					if(!FlxG.save.data.downscroll){
						animation.addByPrefix('blueScroll', 'blue fire');
						animation.addByPrefix('greenScroll', 'green fire');
					}
					else{
						animation.addByPrefix('greenScroll', 'blue fire');
						animation.addByPrefix('blueScroll', 'green fire');
					}
					animation.addByPrefix('redScroll', 'red fire');
					animation.addByPrefix('purpleScroll', 'purple fire');

					if(FlxG.save.data.downscroll)
						flipY = true;

					x -= 50;

					setGraphicSize(Std.int(width * noteScale));
					updateHitbox();
					antialiasing = true;	
				}	
			case 5:
				if (neonNote)
				{
					loadGraphic(Paths.image('notestuff/exeNotes-neon'), true, 17, 17);
					
					animation.add('greenScroll', [6]);
					animation.add('redScroll', [7]);
					animation.add('blueScroll', [5]);
					animation.add('purpleScroll', [4]);

					setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					updateHitbox();
					antialiasing = false;
				}
				else
				{
					if (PlayState.SONG.noteStyle == '1930' || PlayState.SONG.noteStyle == 'bw')
					{
						frames = Paths.getSparrowAtlas('notestuff/staticNotes1930');
						blackStatic = true;
					}
					else
						frames = Paths.getSparrowAtlas('notestuff/staticNotes');
	
					animation.addByPrefix('greenScroll', 'green static');
					animation.addByPrefix('redScroll', 'red static');
					animation.addByPrefix('blueScroll', 'blue static');
					animation.addByPrefix('purpleScroll', 'purple static');
	
					setGraphicSize(Std.int(width * 0.7));
					
					updateHitbox();
					antialiasing = true;
				}
			case 6:
				if (PlayState.SONG.player2 == 'whittyCrazy')
				{
					loadGraphic(Paths.image('notestuff/bombNote'), true, 222, 152);

					animation.add('greenScroll', [0]);
					animation.add('redScroll', [0]);
					animation.add('blueScroll', [0]);
					animation.add('purpleScroll', [0]);
	
					setGraphicSize(Std.int(width * noteScale));
					updateHitbox();
					antialiasing = true;
				}
				else
				{				
					frames = Paths.getSparrowAtlas('notestuff/HURTNOTE_assets');

					animation.addByPrefix('greenScroll', 'green0');
					animation.addByPrefix('redScroll', 'red0');
					animation.addByPrefix('blueScroll', 'blue0');
					animation.addByPrefix('purpleScroll', 'purple0');

					animation.addByPrefix('purpleholdend', 'pruple end hold');
					animation.addByPrefix('greenholdend', 'green hold end');
					animation.addByPrefix('redholdend', 'red hold end');
					animation.addByPrefix('blueholdend', 'blue hold end');

					animation.addByPrefix('purplehold', 'purple hold piece');
					animation.addByPrefix('greenhold', 'green hold piece');
					animation.addByPrefix('redhold', 'red hold piece');
					animation.addByPrefix('bluehold', 'blue hold piece');

					setGraphicSize(Std.int(width * 0.7));
					updateHitbox();
					antialiasing = true;
				}
			
			case 7:
				frames = Paths.getSparrowAtlas('notestuff/NOTE_rushia');

				animation.addByPrefix('greenScroll', 'green alone0');
				animation.addByPrefix('redScroll', 'red alone0');
				animation.addByPrefix('blueScroll', 'blue alone0');
				animation.addByPrefix('purpleScroll', 'purple alone0');

				animation.addByPrefix('purpleholdend', 'purple tail');
				animation.addByPrefix('greenholdend', 'green tail');
				animation.addByPrefix('redholdend', 'red tail');
				animation.addByPrefix('blueholdend', 'blue tail');

				animation.addByPrefix('purplehold', 'purple hold');
				animation.addByPrefix('greenhold', 'green hold');
				animation.addByPrefix('redhold', 'red hold');
				animation.addByPrefix('bluehold', 'blue hold');

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;
			case 8:
				frames = Paths.getSparrowAtlas('notestuff/NOTE_haato');

				animation.addByPrefix('greenScroll', 'green alone0');
				animation.addByPrefix('redScroll', 'red alone0');
				animation.addByPrefix('blueScroll', 'blue alone0');
				animation.addByPrefix('purpleScroll', 'purple alone0');

				animation.addByPrefix('purpleholdend', 'purple tail');
				animation.addByPrefix('greenholdend', 'green tail');
				animation.addByPrefix('redholdend', 'red tail');
				animation.addByPrefix('blueholdend', 'blue tail');

				animation.addByPrefix('purplehold', 'purple hold');
				animation.addByPrefix('greenhold', 'green hold');
				animation.addByPrefix('redhold', 'red hold');
				animation.addByPrefix('bluehold', 'blue hold');

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;
			case 9:
				loadGraphic(Paths.image('notestuff/scytheNotes'), true, 150, 150);

				animation.add('greenScroll', [2]);
				animation.add('redScroll', [1]);
				animation.add('blueScroll', [3]);
				animation.add('purpleScroll', [0]);

				setGraphicSize(Std.int(width * noteScale));
				updateHitbox();
				antialiasing = true;	
			case 10:
				if (neonNote)
				{
					loadGraphic(Paths.image('notestuff/exeNotes-neon'), true, 17, 17);
					
					animation.add('greenScroll', [2]);
					animation.add('redScroll', [3]);
					animation.add('blueScroll', [1]);
					animation.add('purpleScroll', [0]);

					setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					updateHitbox();
					antialiasing = false;
				}
				else
				{
					frames = Paths.getSparrowAtlas('notestuff/PhantomNote');
					animation.addByPrefix('greenScroll', 'green withered');
					animation.addByPrefix('redScroll', 'red withered');
					animation.addByPrefix('blueScroll', 'blue withered');
					animation.addByPrefix('purpleScroll', 'purple withered');
	
					setGraphicSize(Std.int(width * 0.7));
						
					updateHitbox();
					antialiasing = true;
				}
			
		}

		if (burning && !pixelBurn && PlayState.curStage != 'auditorHell' || bomb)
			setGraphicSize(Std.int(width * 0.86));	
			
		switch (noteData)
		{
			//not usin this anymore
		}

		var frameN:Array<String> = ['purple', 'blue', 'green', 'red'];
		switch (mania)
		{
			case 1:
				frameN = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
			case 2:
				frameN = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark'];
			case 3:
				if (style == 'exe')
					frameN = ['purple', 'blue', 'gold', 'green', 'red'];
				else
					frameN = ['purple', 'blue', 'white', 'green', 'red'];
		}

		x += swagWidth * noteData;
		animation.play(frameN[noteData] + 'Scroll');

		if (style == "guitar"){
			offset.x = -15;
			offset.y = -30;
		}

		if (FlxG.save.data.downscroll && sustainNote) 
			flipY = true;

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			animation.play(frameN[noteData] + 'holdend');
			switch (noteData)
			{
				case 0:
					//nope
			}

			updateHitbox();

			x -= width / 2;
			if (style == "guitar"){
				x -= width ;
			}

			if (style == "guitar"){
				offset.x = -15;
			}

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						//nope
				}

				prevNote.animation.play(frameN[prevNote.noteData] + 'hold');

				if(FlxG.save.data.scrollSpeed != 1)
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * FlxG.save.data.scrollSpeed;
				else
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.save.data.downscroll && isSustainNote)
		{
			flipY = true;
		}		

		if(isSustainNote && prevNote.burning && PlayState.curStage == 'auditorHell') { 
			this.kill(); 
		}

		if(isSustainNote) 
		{ 
			switch (noteType)
			{
				case 2 | 3 | 4 | 5 | 6:
					this.kill();
			}			
		}

		if (mustPress)
		{
			switch (noteType)
			{
				case 4 | 6 | 8 | 9 | 10:
					if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 0.6)
						&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.4)) // also they're almost impossible to hit late!
						canBeHit = true;
					else
						canBeHit = false;
				case 2:
					if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 0.3)
						&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.2)) // also they're almost impossible to hit late!
						canBeHit = true;
					else
						canBeHit = false;
				default:
					if (burning && PlayState.curStage == 'auditorHell') // the auditor ones
					{
						if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 0.3)
							&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.2)) // also they're almost impossible to hit late!
							canBeHit = true;
						else
							canBeHit = false;
					}
					else
					{
						if (isSustainNote)
						{
							if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 1.5)
								&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
								canBeHit = true;
							else
								canBeHit = false;
						}
						else
						{
							if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
								&& strumTime < Conductor.songPosition + Conductor.safeZoneOffset)
								canBeHit = true;
							else
								canBeHit = false;
						}
					}
			}
		
			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset * Conductor.timeScale && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}