package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import sys.io.File;
import sys.FileSystem;
import openfl.display.BitmapData;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function lua(key:String,?library:String)
	{
		return getPath('data/$key.lua', TEXT, library);
	}

	inline static public function luaImage(key:String, ?library:String)
	{
		return getPath('data/$key.png', IMAGE, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function txtNew(key:String, ?library:String)
	{
		return getPath('$key.txt', TEXT, library);
	}

	inline static public function xmlNew(key:String, ?library:String)
	{
		return getPath('$key.xml', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function inst2(song:String, ?library:String)
	{
		var songLowercase = StringTools.replace(song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}

		return getPath('music/customsongs/${songLowercase}/Inst.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices2(song:String, ?library:String)
	{
		var songLowercase = StringTools.replace(song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}

		return getPath('music/customsongs/${songLowercase}/Voices.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices(song:String)
	{
		var songLowercase = StringTools.replace(song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
				case 'scary-swings': songLowercase = 'scary swings';
			}

		var pre:String = "";
		var suf:String = "";

		if (PlayState.isNeonight)
			suf = 'NN';
		if (PlayState.isVitor)
			suf = 'V';
		if (PlayState.isBETADCIU && PlayState.storyDifficulty == 5)		
			suf = 'Guest';
		if (PlayState.isBETADCIU && songLowercase == 'kaboom')		
			suf = 'BETADCIU';
		if (Main.isMegalo && songLowercase == 'hill-of-the-void')		
			suf = 'Megalo';

		return 'songs:assets/songs/${songLowercase}/'+pre+'Voices'+suf+'.$SOUND_EXT';
	}

	inline static public function inst(song:String)
	{
		var songLowercase = StringTools.replace(song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
				case 'scary-swings': songLowercase = 'scary swings';
				case 'my-sweets': songLowercase = 'my sweets';
			}

		var pre:String = "";
		var suf:String = "";

		if (Main.noCopyright && song.toLowerCase() == "sharkventure")
			pre = 'Alt_';		
		if (PlayState.isNeonight)
			suf = 'NN';
		if (PlayState.isVitor)		
			suf = 'V';
		if (PlayState.isBETADCIU && PlayState.storyDifficulty == 5)		
			suf = 'Guest';
	
		return 'songs:assets/songs/${songLowercase}/'+pre+'Inst'+suf+'.$SOUND_EXT';
	}

	inline static public function image(key:String, ?library:String)
	{
		return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function image2(key:String, ?library:String)
	{
		return getPath('images/$key', IMAGE, library);
	}

	inline static public function jsonNew(key:String, ?library:String)
	{
		return getPath('$key.json', TEXT, library);
	}

	//for modding plus shit
	inline static public function jsoncNew(key:String, ?library:String)
	{
		return getPath('$key.jsonc', TEXT, library);
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}
}
