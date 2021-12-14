package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class NoteSplash extends FlxSprite
{
	private var idleAnim:String;
	private var textureLoaded:String = null;

	public function new(x:Float = 0, y:Float = 0, ?note:Int = 0) {
		super(x, y);

		var skin:String = '';

		switch (PlayState.SONG.noteStyle)
		{
			case '1930' | 'fever' | 'holofunk' | 'maijin':
				skin = '-'+ PlayState.SONG.noteStyle;
			case 'taki' | 'party-crasher':
				skin = '-fever';
			default:
				skin = PlayState.splashSkin;
		}

		switch (PlayState.SONG.bfNoteStyle)
		{
			case '1930' | 'fever' | 'holofunk' | 'maijin':
				skin = '-'+ PlayState.SONG.noteStyle;
			case 'taki' | 'party-crasher':
				skin = '-fever';
			default:
				skin = PlayState.splashSkin;
		}
		

		if (skin == 'normal' || skin == 'default') skin = "";

		loadAnims(skin);

		setupNoteSplash(x, y, note);
			
		antialiasing = true;
	}

	public function setupNoteSplash(x:Float, y:Float, note:Int = 0, texture:String = null, hueColor:Float = 0, satColor:Float = 0, brtColor:Float = 0) {
		setPosition(x - Note.swagWidth * 0.95, y - Note.swagWidth);
		if (texture == '-holofunk')
		{
			switch (note)
			{
				case 0:
					this.x += 30;
				// offset.set(-20, 0);
				case 1:
					this.y += 30;
				// offset.set(0, -20);
				case 2:
					this.y += 30;
				// offset.set(0, -20);
				case 3:
					this.x += 30;
					// offset.set(-20, 0);
			}
			alpha = 0.75;
			scale.set(1.2, 1.2);
		}
		else
		{
			alpha = 0.6;
			scale.set(1, 1);
			offset.set(0, 0);
		}
		

		if(texture == null) {
			texture = "";
		}
		else 
		{
			switch (PlayState.SONG.noteStyle)
			{
				case '1930' | 'fever':
					texture = '-'+ PlayState.SONG.noteStyle;
				case 'taki' | 'party-crasher':
					texture = '-fever';
				default:
					texture = PlayState.splashSkin;
			}

			if (PlayState.changeArrows)
			{
				switch (PlayState.SONG.bfNoteStyle)
				{
					case '1930' | 'fever':
						texture = '-'+ PlayState.SONG.noteStyle;
					case 'taki' | 'party-crasher':
						texture = '-fever';
					default:
						texture = PlayState.splashSkin;
				}
			}	
		}

		if(textureLoaded != texture) {
			loadAnims(texture);
		}

		if (texture == '-fever')
		{
			scale.set(1.08, 1.08);
			if(note == 0 || note == 3)
				offset.set((0.291 * this.width) - 150, (0.315 * this.height) - 150);
			else
				offset.set((0.33 * this.width) - 150, (0.315 * this.height) - 150);
		}


		var animNum:Int = FlxG.random.int(1, 2);
		animation.play('note' + note + '-' + animNum, true);
		animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
	}

	function loadAnims(skin:String) {
		frames = Paths.getSparrowAtlas("notestuff/noteSplashes" + skin);
		for (i in 1...3) {
			animation.addByPrefix("note1-" + i, "note impact " + i + " blue", 24, false);
			animation.addByPrefix("note2-" + i, "note impact " + i + " green", 24, false);
			animation.addByPrefix("note0-" + i, "note impact " + i + " purple", 24, false);
			animation.addByPrefix("note3-" + i, "note impact " + i + " red" , 24, false);
		}
	}

	override function update(elapsed:Float) {
		if(animation.curAnim.finished) kill();

		super.update(elapsed);
	}
}