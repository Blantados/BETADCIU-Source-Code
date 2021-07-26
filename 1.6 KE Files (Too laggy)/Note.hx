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
	public var baseStrum:Float = 0;

	public var rStrumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var rawNoteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var pixel:Bool = false;
	public var burning:Bool = false;
	public var danger:Bool = false;
	public var modifiedByLua:Bool = false;
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var originColor:Int = 0; // The sustain note's original note's color
	public var noteType:Int = 0;
	public var noteTypeCheck:String = '';

	public var noteCharterObject:FlxSprite;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public var rating:String = "shit";

	public var modAngle:Float = 0; // The angle set by modcharts
	public var localAngle:Float = 0; // The angle to be edited inside Note.hx

	public var dataColor:Array<String> = ['purple', 'blue', 'green', 'red'];
	public var quantityColor:Array<Int> = [RED_NOTE, 2, BLUE_NOTE, 2, PURP_NOTE, 2, BLUE_NOTE, 2];
	public var arrowAngles:Array<Int> = [180, 90, 270, 0];

	public var isParent:Bool = false;
	public var parent:Note = null;
	public var spotInLine:Int = 0;
	public var sustainActive:Bool = true;

	public var children:Array<Note> = [];

	public function new(strumTime:Float, _noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, noteTypeCheck:String="normal", ?noteType:Int = 0, ?inCharter:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		this.noteType = noteType;
		isSustainNote = sustainNote;
		this.noteTypeCheck = noteTypeCheck;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;

		if (inCharter)
		{
			this.strumTime = strumTime;
			rStrumTime = strumTime;
		}
		else
		{
			this.strumTime = strumTime;
			rStrumTime = strumTime - (FlxG.save.data.offset);
			#if sys
			if (PlayState.isSM)
			{
				rStrumTime = Math.round(rStrumTime + Std.parseFloat(PlayState.sm.header.OFFSET));
			}
			#end
		}

		if (this.strumTime < 0 )
			this.strumTime = 0;

		if (PlayState.curStage == 'auditorHell')
		{
			burning = _noteData > 7;
		}
		else if (PlayState.curStage == 'tank' || PlayState.curStage == 'garStage' || PlayState.curStage == 'eddhouse')
		{
			danger = _noteData > 7;
		}
		else
		{
			pixel = _noteData > 7;
		}

		noteData = _noteData % 4;

		var daStage:String = PlayState.curStage;

		if(isSustainNote && prevNote.burning && PlayState.curStage == 'auditorHell') 
		{ 
			burning = true;
		}

		if(isSustainNote && prevNote.danger) 
		{ 
			danger = true;
		}

		var noteTypeCheck:String = 'normal';

		if (inCharter)
		{
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
	
			setGraphicSize(Std.int(width * 0.7));
			updateHitbox();
			antialiasing = true;
		}

		else
		{
			if (PlayState.SONG.noteStyle == null) {
				switch(PlayState.storyWeek) {case 6: noteTypeCheck = 'pixel';}
			} else {noteTypeCheck = PlayState.SONG.noteStyle;}
	
			switch (noteTypeCheck)
			{
				case 'pixel':
					loadGraphic(Paths.image('notestuff/arrows-pixels'), true, 17, 17);
	
					animation.add('greenScroll', [6]);
					animation.add('redScroll', [7]);
					animation.add('blueScroll', [5]);
					animation.add('purpleScroll', [4]);
	
					if (isSustainNote)
					{
						loadGraphic(Paths.image('notestuff/arrowEnds'), true, 7, 6);
	
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
	
				case 'pixel-corrupted':
					loadGraphic(Paths.image('notestuff/arrows-pixelscorrupted'), true, 17, 17);
	
					animation.add('greenScroll', [6]);
					animation.add('redScroll', [7]);
					animation.add('blueScroll', [5]);
					animation.add('purpleScroll', [4]);
	
					if (isSustainNote)
					{
						loadGraphic(Paths.image('notestuff/arrowEndscorrupted'), true, 7, 6);
	
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
	
				case 'kapi':
					frames = Paths.getSparrowAtlas('notestuff/KAPINOTE_assets');
	
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
	
					if (pixel)
					{
						loadGraphic(Paths.image('notestuff/arrows-pixels'), true, 17, 17);
	
						animation.add('greenScroll', [6]);
						animation.add('redScroll', [7]);
						animation.add('blueScroll', [5]);
						animation.add('purpleScroll', [4]);
	
						if (isSustainNote)
						{
							loadGraphic(Paths.image('notestuff/arrowEnds'), true, 7, 6);
	
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
						antialiasing = false;
					}
	
					setGraphicSize(Std.int(width * 0.7));
					updateHitbox();
					antialiasing = true;	
	
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
	
				case 'normal':
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
	
					setGraphicSize(Std.int(width * 0.7));
					updateHitbox();
					antialiasing = true;
	
					if (pixel)
					{
						loadGraphic(Paths.image('notestuff/arrows-pixels'), true, 17, 17);
	
						animation.add('greenScroll', [6]);
						animation.add('redScroll', [7]);
						animation.add('blueScroll', [5]);
						animation.add('purpleScroll', [4]);
	
						if (isSustainNote)
						{
							loadGraphic(Paths.image('notestuff/arrowEnds'), true, 7, 6);
	
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
						antialiasing = false;				
					}
	
					else if (danger)
					{
						loadGraphic(Paths.image('notestuff/warningNote'), true, 157, 154);
	
						animation.add('greenScroll', [0]);
						animation.add('redScroll', [0]);
						animation.add('blueScroll', [0]);
						animation.add('purpleScroll', [0]);
	
						setGraphicSize(Std.int(width * 0.7));
						updateHitbox();
						antialiasing = true;
					}
	
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
	
					if (pixel)
					{
						loadGraphic(Paths.image('notestuff/arrows-pixels'), true, 17, 17);
	
						animation.add('greenScroll', [6]);
						animation.add('redScroll', [7]);
						animation.add('blueScroll', [5]);
						animation.add('purpleScroll', [4]);
	
						if (isSustainNote)
						{
							loadGraphic(Paths.image('notestuff/arrowEnds'), true, 7, 6);
	
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
						antialiasing = false;
					}
	
				case 'empty':
					frames = Paths.getSparrowAtlas('notestuff/Note_Assets_withPixel');
	
					if (pixel)
					{
						animation.addByPrefix('greenScroll', 'PixelUp0');
						animation.addByPrefix('redScroll', 'PixelRight0');
						animation.addByPrefix('blueScroll', 'PixelDown0');
						animation.addByPrefix('purpleScroll', 'PixelLeft0');
	
						animation.addByPrefix('purpleholdend', 'PixelLeftHoldEnd');
						animation.addByPrefix('greenholdend', 'PixelUpHoldEnd');
						animation.addByPrefix('redholdend', 'PixelRightHoldEnd');
						animation.addByPrefix('blueholdend', 'PixelDownHoldEnd');
	
						animation.addByPrefix('purplehold', 'PixelLeftHoldPiece');
						animation.addByPrefix('greenhold', 'PixelUpHoldPiece');
						animation.addByPrefix('redhold', 'PixelRightHoldPiece');
						animation.addByPrefix('bluehold', 'PixelDownHoldPiece');
						antialiasing = false;
					}
					else
					{
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
					}
	
					setGraphicSize(Std.int(width * 0.7));
					updateHitbox();
					antialiasing = true;
	
				default:
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
	
					setGraphicSize(Std.int(width * 0.7));
					updateHitbox();
					antialiasing = true;
	
					if (pixel)
					{
						loadGraphic(Paths.image('notestuff/arrows-pixels'), true, 17, 17);
	
						animation.add('greenScroll', [6]);
						animation.add('redScroll', [7]);
						animation.add('blueScroll', [5]);
						animation.add('purpleScroll', [4]);
	
						if (isSustainNote)
						{
							loadGraphic(Paths.image('notestuff/arrowEnds'), true, 7, 6);
	
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
						antialiasing = false;
					}
	
					else if (danger)
					{
						loadGraphic(Paths.image('notestuff/warningNote'), true, 157, 154);
	
						animation.add('greenScroll', [0]);
						animation.add('redScroll', [0]);
						animation.add('blueScroll', [0]);
						animation.add('purpleScroll', [0]);
	
						setGraphicSize(Std.int(width * 0.7));
						updateHitbox();
						antialiasing = true;
					}
			}
		}
		
			
		switch (noteData)
		{
			case 0:
				x += swagWidth * 0;
				animation.play('purpleScroll');
			case 1:
				x += swagWidth * 1;
				animation.play('blueScroll');
			case 2:
				x += swagWidth * 2;
				animation.play('greenScroll');
			case 3:
				x += swagWidth * 3;
				animation.play('redScroll');
		}

		// trace(prevNote);

		// we make sure its downscroll and its a SUSTAIN NOTE (aka a trail, not a note)
		// and flip it so it doesn't look weird.
		// THIS DOESN'T FUCKING FLIP THE NOTE, CONTRIBUTERS DON'T JUST COMMENT THIS OUT JESUS

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}


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

		if (FlxG.save.data.downscroll && isSustainNote && pixel) 
		{
			flipY = true;
		}		

		if(isSustainNote && prevNote.burning && PlayState.curStage == 'auditorHell') { 
			this.kill(); 
		}

		if(isSustainNote && prevNote.danger) { 
			this.kill(); 
		}

		if (mustPress)
		{
			// ass
			if (burning && PlayState.curStage == 'auditorHell') // these though, REALLY hard to hit.
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