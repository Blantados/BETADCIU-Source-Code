// this file is for modchart things, this is to declutter playstate.hx

// Lua
import openfl.display3D.textures.VideoTexture;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
#if desktop
import flixel.tweens.FlxEase;
import openfl.filters.ShaderFilter;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import lime.app.Application;
import flixel.FlxSprite;
import llua.Convert;
import llua.Lua;
import llua.State;
import llua.LuaL;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.FlxSound;
import flixel.effects.FlxFlicker;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.util.FlxTimer;

#if desktop
import Sys;
import sys.FileSystem;
#end

using StringTools;

class ModchartState 
{
	//public static var shaders:Array<LuaShader> = null;

	public static var lua:State = null;
	var lePlayState:PlayState = null;
	public static var Function_Stop = 1;
	public static var Function_Continue = 0;

	function callLua(func_name : String, args : Array<Dynamic>, ?type : String) : Dynamic
	{
		var result : Any = null;

		Lua.getglobal(lua, func_name);

		for( arg in args ) {
		Convert.toLua(lua, arg);
		}

		result = Lua.pcall(lua, args.length, 1, 0);
		var p = Lua.tostring(lua,result);
		var e = getLuaErrorMessage(lua);

		if (e != null)
		{
			if (p != null)
				{
					Application.current.window.alert("LUA ERROR:\n" + p + "\nhaxe things: " + e,"Kade Engine Modcharts");
					lua = null;
					LoadingState.loadAndSwitchState(new MainMenuState());
				}
			// trace('err: ' + e);
		}
		if( result == null) {
			return null;
		} else {
			return convert(result, type);
		}

	}

	static function toLua(l:State, val:Any):Bool {
		switch (Type.typeof(val)) {
			case Type.ValueType.TNull:
				Lua.pushnil(l);
			case Type.ValueType.TBool:
				Lua.pushboolean(l, val);
			case Type.ValueType.TInt:
				Lua.pushinteger(l, cast(val, Int));
			case Type.ValueType.TFloat:
				Lua.pushnumber(l, val);
			case Type.ValueType.TClass(String):
				Lua.pushstring(l, cast(val, String));
			case Type.ValueType.TClass(Array):
				Convert.arrayToLua(l, val);
			case Type.ValueType.TObject:
				objectToLua(l, val);
			default:
				trace("haxe value not supported - " + val + " which is a type of " + Type.typeof(val));
				return false;
		}

		return true;

	}

	static function objectToLua(l:State, res:Any) {

		var FUCK = 0;
		for(n in Reflect.fields(res))
		{
			trace(Type.typeof(n).getName());
			FUCK++;
		}

		Lua.createtable(l, FUCK, 0); // TODONE: I did it

		for (n in Reflect.fields(res)){
			if (!Reflect.isObject(n))
				continue;
			Lua.pushstring(l, n);
			toLua(l, Reflect.field(res, n));
			Lua.settable(l, -3);
		}

	}

	function getType(l, type):Any
	{
		return switch Lua.type(l,type) {
			case t if (t == Lua.LUA_TNIL): null;
			case t if (t == Lua.LUA_TNUMBER): Lua.tonumber(l, type);
			case t if (t == Lua.LUA_TSTRING): (Lua.tostring(l, type):String);
			case t if (t == Lua.LUA_TBOOLEAN): Lua.toboolean(l, type);
			case t: throw 'you don goofed up. lua type error ($t)';
		}
	}

	function getReturnValues(l) {
		var lua_v:Int;
		var v:Any = null;
		while((lua_v = Lua.gettop(l)) != 0) {
			var type:String = getType(l,lua_v);
			v = convert(lua_v, type);
			Lua.pop(l, 1);
		}
		return v;
	}


	private function convert(v : Any, type : String) : Dynamic { // I didn't write this lol
		if( Std.is(v, String) && type != null ) {
		var v : String = v;
		if( type.substr(0, 4) == 'array' ) {
			if( type.substr(4) == 'float' ) {
			var array : Array<String> = v.split(',');
			var array2 : Array<Float> = new Array();

			for( vars in array ) {
				array2.push(Std.parseFloat(vars));
			}

			return array2;
			} else if( type.substr(4) == 'int' ) {
			var array : Array<String> = v.split(',');
			var array2 : Array<Int> = new Array();

			for( vars in array ) {
				array2.push(Std.parseInt(vars));
			}

			return array2;
			} else {
			var array : Array<String> = v.split(',');
			return array;
			}
		} else if( type == 'float' ) {
			return Std.parseFloat(v);
		} else if( type == 'int' ) {
			return Std.parseInt(v);
		} else if( type == 'bool' ) {
			if( v == 'true' ) {
			return true;
			} else {
			return false;
			}
		} else {
			return v;
		}
		} else {
		return v;
		}
	}

	function getLuaErrorMessage(l) {
		var v:String = Lua.tostring(l, -1);
		Lua.pop(l, 1);
		return v;
	}

	public function setVar(var_name : String, object : Dynamic){
		// trace('setting variable ' + var_name + ' to ' + object);

		Lua.pushnumber(lua,object);
		Lua.setglobal(lua, var_name);
	}

	public function getVar(var_name : String, type : String) : Dynamic {
		var result : Any = null;

		// trace('getting variable ' + var_name + ' with a type of ' + type);

		Lua.getglobal(lua, var_name);
		result = Convert.fromLua(lua,-1);
		Lua.pop(lua,1);

		if( result == null ) {
		return null;
		} else {
		var result = convert(result, type);
		//trace(var_name + ' result: ' + result);
		return result;
		}
	}

	function getActorByName(id:String):Dynamic
	{
		// pre defined names
		switch(id)
		{
			case 'boyfriend':
                @:privateAccess
				return PlayState.boyfriend;
			case 'boyfriend1':
                @:privateAccess
				return PlayState.boyfriend1;
			case 'boyfriend2':
                @:privateAccess
				return PlayState.boyfriend2;
			case 'gf':
                @:privateAccess
				return PlayState.gf;
			case 'dad':
                @:privateAccess
				return PlayState.dad;
			case 'dad1':
                @:privateAccess
				return PlayState.dad1;
			case 'dad2':
                @:privateAccess
				return PlayState.dad2;
			case 'blantadBG':
                @:privateAccess
				return PlayState.blantadBG;
			case 'camFollow':
                @:privateAccess
				return PlayState.camFollow;
			case 'camHUD':
                @:privateAccess
				return PlayState.instance.camHUD;
			case 'camGame':
                @:privateAccess
				return FlxG.camera;
			case 'camGame.scroll':
                @:privateAccess
				return FlxG.camera.scroll;
		}
		// lua objects or what ever
		if (luaSprites.get(id) == null)
		{
			if (luaTrails.get(id) == null)
			{
				if (Std.parseInt(id) == null)
					return Reflect.getProperty(PlayState.instance,id);
				return PlayState.PlayState.strumLineNotes.members[Std.parseInt(id)];
			}
			return luaTrails.get(id);
		}
		return luaSprites.get(id);
	}

	function getPropertyByName(id:String)
	{
		return Reflect.field(PlayState.instance,id);
	}

	function getCurCharacter(id:String)
	{
		return getActorByName(id).curCharacter;
	}

	public static var luaSprites:Map<String,FlxSprite> = [];
	public static var luaTrails:Map<String,DeltaTrail> = [];

	//Kade why tf is it not like in PlayState???

	function changeGFCharacter(id:String, x:Float, y:Float, ?xFactor:Float = 0.95, ?yFactor:Float = 0.95)
	{		
		PlayState.instance.removeObject(PlayState.gf);
		//PlayState.gf = new Character(x, y, null);
		PlayState.instance.destroyObject(PlayState.gf);
		PlayState.gf = new Character(x, y, id);
		PlayState.gf.scrollFactor.set(xFactor, yFactor);
		PlayState.instance.addObject(PlayState.gf);
	}

	function changeDadCharacter(id:String, x:Float, y:Float, ?xFactor:Float = 1, ?yFactor:Float = 1)
	{		
		PlayState.instance.removeObject(PlayState.instance.dadTrail);
		PlayState.instance.removeObject(PlayState.dad);
		PlayState.instance.destroyObject(PlayState.dad);
		PlayState.dad = new Character(x, y, id);
		PlayState.dad.scrollFactor.set(xFactor, yFactor);
		PlayState.instance.addObject(PlayState.instance.dadTrail);
		PlayState.instance.dadTrail.resetTrail();
		PlayState.instance.addObject(PlayState.dad);

		if (PlayState.newIcons)
		{
			if (PlayState.swapIcons)
				PlayState.instance.iconP2.changeIcon(id);
			else
				''; //do nothing
		}
		else
			PlayState.instance.iconP2.useOldSystem(id);

		if (PlayState.changeArrows)
		{
			PlayState.regenerateDadArrows = true;
		}
		if (PlayState.defaultBar)
		{
			PlayState.healthBar.createFilledBar(FlxColor.fromString('#' + PlayState.dad.iconColor), FlxColor.fromString('#' + PlayState.boyfriend.iconColor));
			PlayState.healthBar.updateBar();
		}	
	}

	function changeDad1Character(id:String, x:Float, y:Float)
	{		
		PlayState.instance.removeObject(PlayState.instance.dad1Trail);
		PlayState.instance.removeObject(PlayState.dad1);
		PlayState.instance.destroyObject(PlayState.dad1);
		PlayState.dad1 = new Character(x, y, id);
		PlayState.instance.addObject(PlayState.instance.dad1Trail);
		PlayState.instance.dad1Trail.resetTrail();
		PlayState.instance.addObject(PlayState.dad1);

		if (PlayState.changeArrowSongs.contains(PlayState.SONG.song.toLowerCase()))
			PlayState.regenerateDadArrows = true;

		if (PlayState.defaultBar)
		{
			PlayState.healthBar.createFilledBar(FlxColor.fromString('#' + PlayState.dad1.iconColor), FlxColor.fromString('#' + PlayState.boyfriend.iconColor));
			PlayState.healthBar.updateBar();
		}	
	}

	function changeDad2Character(id:String, x:Float, y:Float)
	{		
		PlayState.instance.removeObject(PlayState.dad2);
		PlayState.instance.destroyObject(PlayState.dad2);
		PlayState.dad2 = new Character(x, y, id);
		PlayState.instance.addObject(PlayState.dad2);

		if (PlayState.changeArrowSongs.contains(PlayState.SONG.song.toLowerCase()))
			PlayState.regenerateDadArrows = true;

		if (PlayState.defaultBar)
		{
			PlayState.healthBar.createFilledBar(FlxColor.fromString('#' + PlayState.dad2.iconColor), FlxColor.fromString('#' + PlayState.boyfriend.iconColor));
			PlayState.healthBar.updateBar();
		}	
	}

	function changeBoyfriendCharacter(id:String, x:Float, y:Float, ?xFactor:Float = 1, ?yFactor:Float = 1)
	{	
		var animationName:String = "no way anyone have an anim name this big";
		var animationFrame:Int = 0;						
		if (PlayState.boyfriend.animation.curAnim.name.startsWith('sing'))
		{
			animationName = PlayState.boyfriend.animation.curAnim.name;
			animationFrame = PlayState.boyfriend.animation.curAnim.curFrame;
		}

		PlayState.instance.removeObject(PlayState.instance.bfTrail);
		PlayState.instance.removeObject(PlayState.boyfriend);
		PlayState.instance.destroyObject(PlayState.boyfriend);
		PlayState.boyfriend = new Boyfriend(x, y, id);
		PlayState.boyfriend.scrollFactor.set(xFactor, yFactor);
		PlayState.instance.addObject(PlayState.instance.bfTrail);
		PlayState.instance.bfTrail.resetTrail();
		PlayState.instance.addObject(PlayState.boyfriend);

		if (PlayState.newIcons)
		{
			if (PlayState.swapIcons)
				PlayState.instance.iconP1.changeIcon(id);
			else
				''; //do nothing
		}
		else
			PlayState.instance.iconP1.useOldSystem(id);

		if (PlayState.changeArrows)
			PlayState.regenerateDadArrows = true;

		if (PlayState.defaultBar)
		{
			PlayState.healthBar.createFilledBar(FlxColor.fromString('#' + PlayState.dad.iconColor), FlxColor.fromString('#' + PlayState.boyfriend.iconColor));
			PlayState.healthBar.updateBar();
		}	

		if (PlayState.boyfriend.animOffsets.exists(animationName))
			PlayState.boyfriend.playAnim(animationName, true, false, animationFrame);
	}

	function changeBoyfriend1Character(id:String, x:Float, y:Float)
	{							
		PlayState.instance.removeObject(PlayState.instance.bf1Trail);
		PlayState.instance.removeObject(PlayState.boyfriend1);
		//PlayState.boyfriend1 = new Boyfriend1(x, y, null);
		PlayState.instance.destroyObject(PlayState.boyfriend1);
		PlayState.boyfriend1 = new Boyfriend(x, y, id);
		PlayState.instance.addObject(PlayState.instance.bf1Trail);
		PlayState.instance.bf1Trail.resetTrail();
		PlayState.instance.addObject(PlayState.boyfriend1);

		if (PlayState.changeArrowSongs.contains(PlayState.SONG.song.toLowerCase()))
		{
			PlayState.regenerateDadArrows = true;
		}
		if (PlayState.defaultBar)
		{
			PlayState.healthBar.createFilledBar(FlxColor.fromString('#' + PlayState.dad.iconColor), FlxColor.fromString('#' + PlayState.boyfriend1.iconColor));
			PlayState.healthBar.updateBar();
		}	
	}

	function changeBoyfriend2Character(id:String, x:Float, y:Float)
	{							
		PlayState.instance.removeObject(PlayState.boyfriend2);
		PlayState.instance.destroyObject(PlayState.boyfriend2);
		PlayState.boyfriend2 = new Boyfriend(x, y, id);
		PlayState.instance.addObject(PlayState.boyfriend2);
		
		if (PlayState.defaultBar)
		{
			PlayState.healthBar.createFilledBar(FlxColor.fromString('#' + PlayState.dad.iconColor), FlxColor.fromString('#' + PlayState.boyfriend2.iconColor));
			PlayState.healthBar.updateBar();
		}	
	}

	//does this work. right? -- future me here. yes it does.
	function changeStage(id:String)
	{	
		PlayState.instance.removeObject(PlayState.gf);
		PlayState.instance.removeObject(PlayState.dad);
		PlayState.instance.removeObject(PlayState.boyfriend);

		if (PlayState.SONG.song.toLowerCase() == 'epiphany' && PlayState.storyDifficulty == 5)
			PlayState.instance.removeObject(PlayState.dad1);

		for (i in PlayState.Stage.toAdd)
		{
			PlayState.instance.removeObject(i);
			PlayState.instance.destroyObject(i);
		}	

		for (i in PlayState.Stage.layInFront[0])
		{
			PlayState.instance.removeObject(i);
			PlayState.instance.destroyObject(i);
		}	

		for (i in PlayState.Stage.layInFront[1])
		{
			PlayState.instance.removeObject(i);
			PlayState.instance.destroyObject(i);
		}	

		for (i in PlayState.Stage.layInFront[2])
		{
			PlayState.instance.removeObject(i);
			PlayState.instance.destroyObject(i);
		}	
		
		PlayState.instance.removeObject(PlayState.Stage);
		PlayState.instance.destroyObject(PlayState.Stage);
		
		PlayState.Stage = new Stage(id);
		PlayState.curStage = PlayState.Stage.curStage;
		PlayState.defaultCamZoom = PlayState.Stage.camZoom;
		for (i in PlayState.Stage.toAdd)
		{
			PlayState.instance.addObject(i);
		}	
		
		for (index => array in PlayState.Stage.layInFront)
		{
			switch (index)
			{
				case 0:
					PlayState.instance.addObject(PlayState.gf);
					PlayState.gf.scrollFactor.set(0.95, 0.95);
					for (bg in array)
						PlayState.instance.addObject(bg);
				case 1:
					if (PlayState.SONG.song.toLowerCase() == 'epiphany' && PlayState.storyDifficulty == 5)
						PlayState.instance.addObject(PlayState.dad1);

					PlayState.instance.addObject(PlayState.dad);
					for (bg in array)
						PlayState.instance.addObject(bg);
				case 2:
					PlayState.instance.addObject(PlayState.boyfriend);
					for (bg in array)
						PlayState.instance.addObject(bg);
			}
		}	
	}

	

	// this is better. easier to port shit from playstate.
	function changeGFCharacterBetter(x:Float, y:Float, id:String, ?xFactor:Float = 0.95, ?yFactor:Float = 0.95)
	{		
		PlayState.instance.removeObject(PlayState.gf);
		//PlayState.gf = new Character(x, y, null);
		PlayState.instance.destroyObject(PlayState.gf);
		PlayState.gf = new Character(x, y, id);
		PlayState.gf.scrollFactor.set(xFactor, yFactor);
		PlayState.instance.addObject(PlayState.gf);
	}

	function changeDadCharacterBetter(x:Float, y:Float, id:String)
	{		
		PlayState.instance.removeObject(PlayState.dad);
		//PlayState.dad = new Character(x, y, null);
		PlayState.instance.destroyObject(PlayState.dad);
		PlayState.dad = new Character(x, y, id);
		PlayState.instance.addObject(PlayState.dad);

		if (PlayState.newIcons)
		{
			if (PlayState.swapIcons)
				PlayState.instance.iconP2.changeIcon(id);
			else
				''; //do nothing
		}
		else
			PlayState.instance.iconP2.useOldSystem(id);

		if (PlayState.changeArrowSongs.contains(PlayState.SONG.song.toLowerCase()))
			PlayState.regenerateDadArrows = true;

		if (PlayState.defaultBar)
		{
			PlayState.healthBar.createFilledBar(FlxColor.fromString('#' + PlayState.dad.iconColor), FlxColor.fromString('#' + PlayState.boyfriend.iconColor));
			PlayState.healthBar.updateBar();
		}	
	}

	function changeBoyfriendCharacterBetter(x:Float, y:Float, id:String)
	{							
		PlayState.instance.removeObject(PlayState.boyfriend);
		//PlayState.boyfriend = new Boyfriend(x, y, null);
		PlayState.instance.destroyObject(PlayState.boyfriend);
		PlayState.boyfriend = new Boyfriend(x, y, id);
		PlayState.instance.addObject(PlayState.boyfriend);

		if (PlayState.newIcons)
		{
			if (PlayState.swapIcons)
				PlayState.instance.iconP1.changeIcon(id);
			else
				''; //do nothing
		}
		else
			PlayState.instance.iconP1.useOldSystem(id);

		if (PlayState.changeArrowSongs.contains(PlayState.SONG.song.toLowerCase()))//
		{
			PlayState.regenerateDadArrows = true;
		}
		if (PlayState.defaultBar)
		{
			PlayState.healthBar.createFilledBar(FlxColor.fromString('#' + PlayState.dad.iconColor), FlxColor.fromString('#' + PlayState.boyfriend.iconColor));
			PlayState.healthBar.updateBar();
		}	
	}

	function tweenFadeInAndOut(id:String, time:Float, delayTime:Float, time2:Float, ?bg:Bool = false)
	{		
		if (bg)
		{
			FlxTween.tween(PlayState.Stage.swagBacks[id], {alpha: 1}, time, {ease:FlxEase.cubeIn, onComplete:function(twn:FlxTween)
				{
					new FlxTimer().start(delayTime, function(tmr:FlxTimer)
					{
						FlxTween.tween(PlayState.Stage.swagBacks[id], {alpha: 0}, time2, {ease:FlxEase.cubeOut});
					});			
				}	
			});		
		}
		else
		{
			FlxTween.tween(getActorByName(id), {alpha: 1}, time, {ease:FlxEase.cubeIn, onComplete:function(twn:FlxTween)
				{
					new FlxTimer().start(delayTime, function(tmr:FlxTimer)
					{
						FlxTween.tween(getActorByName(id), {alpha: 0}, time2, {ease:FlxEase.cubeOut});
					});			
				}	
			});	
		}							
	}

	function moveHoloDancers(id:String)
	{		
		PlayState.instance.grpLimoDancersHolo.forEach(function(dancer:BackgroundDancerHolo)
		{
			FlxTween.tween(dancer, {x: dancer.x, y: dancer.y - 3800}, 1, {ease: FlxEase.quadInOut});
		});			
	}
	
	function makeAnimatedLuaSprite(spritePath:String,names:Array<String>,prefixes:Array<String>,startAnim:String, id:String)
	{
		#if sys
		// pre lowercasing the song name (makeAnimatedLuaSprite)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
			case 'scary-swings': songLowercase = 'scary swings';
		}

		var data:BitmapData = BitmapData.fromFile(Sys.getCwd() + "assets/data/" + songLowercase + '/' + spritePath + ".png");

		var sprite:FlxSprite = new FlxSprite(0,0);

		sprite.frames = FlxAtlasFrames.fromSparrow(FlxGraphic.fromBitmapData(data), Sys.getCwd() + "assets/data/" + songLowercase + "/" + spritePath + ".xml");

		trace(sprite.frames.frames.length);

		for (p in 0...names.length)
		{
			var i = names[p];
			var ii = prefixes[p];
			sprite.animation.addByPrefix(i,ii,24,false);
		}

		luaSprites.set(id,sprite);

        PlayState.instance.addObject(sprite);

		sprite.animation.play(startAnim);
		return id;
		#end
	}

	function makeLuaSprite(spritePath:String,toBeCalled:String, drawBehind:Bool, ?xFactor:Float = 1, ?yFactor:Float = 1)
	{
		#if sys
		// pre lowercasing the song name (makeLuaSprite)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
			case 'scary-swings': songLowercase = 'scary swings';
		}

		var data:BitmapData = BitmapData.fromFile(Sys.getCwd() + "assets/data/" + songLowercase + '/' + spritePath + ".png");

		var sprite:FlxSprite = new FlxSprite(0,0);
		var imgWidth:Float = FlxG.width / data.width;
		var imgHeight:Float = FlxG.height / data.height;
		var scale:Float = imgWidth <= imgHeight ? imgWidth : imgHeight;

		// Cap the scale at x1
		if (scale > 1)
			scale = 1;

		sprite.makeGraphic(Std.int(data.width * scale),Std.int(data.width * scale),FlxColor.TRANSPARENT);
		sprite.scrollFactor.set(xFactor, yFactor);

		var data2:BitmapData = sprite.pixels.clone();
		var matrix:Matrix = new Matrix();
		matrix.identity();
		matrix.scale(scale, scale);
		data2.fillRect(data2.rect, FlxColor.TRANSPARENT);
		data2.draw(data, matrix, null, null, null, true);
		sprite.pixels = data2;
		
		luaSprites.set(toBeCalled,sprite);
		// and I quote:
		// shitty layering but it works!
        @:privateAccess
        {
            if (drawBehind)
            {
                PlayState.instance.removeObject(PlayState.gf);
                PlayState.instance.removeObject(PlayState.boyfriend);
                PlayState.instance.removeObject(PlayState.dad);
            }
            PlayState.instance.addObject(sprite);
            if (drawBehind)
            {
                PlayState.instance.addObject(PlayState.gf);
                PlayState.instance.addObject(PlayState.boyfriend);
                PlayState.instance.addObject(PlayState.dad);
            }
        }
		#end
		return toBeCalled;
	}

    public function die()
    {
        Lua.close(lua);
		lua = null;
    }

    // LUA SHIT

    function new()
    {
        		trace('opening a lua state (because we are cool :))');
				lua = LuaL.newstate();
				LuaL.openlibs(lua);
				trace("Lua version: " + Lua.version());
				trace("LuaJIT version: " + Lua.versionJIT());
				Lua.init_callbacks(lua);
				
				//shaders = new Array<LuaShader>();

				// pre lowercasing the song name (new)
				var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
				switch (songLowercase) {
					case 'dad-battle': songLowercase = 'dadbattle';
					case 'philly-nice': songLowercase = 'philly';
					case 'scary-swings': songLowercase = 'scary swings';
				}

				var suf:String = "";
				if (PlayState.isNeonight)
				{
					if (!FlxG.save.data.stageChange)
						suf = '-neo-noStage';
					else
						suf = '-neo';
				}
				if (PlayState.isVitor)
					suf = '-vitor';	
				
				if (PlayState.isBETADCIU && PlayState.storyDifficulty == 5)
				{
					if (PlayState.isSpres)
					{
						if (!FlxG.save.data.stageChange)
							suf = '-guest-noStage';				
						else
							suf = '-guest';
					}
					else
						suf = '-guest';	
				}

				if (PlayState.isBETADCIU && FileSystem.exists(Paths.lua(songLowercase  + "/modchart-betadciu")))
					suf = '-betadciu';
				
				if (PlayState.isBETADCIU && PlayState.SONG.song.toLowerCase() == 'hill-of-the-void' && !FlxG.save.data.stageChange)
					suf = '-noStage';

				var result = LuaL.dofile(lua, Paths.lua(songLowercase + "/modchart" + suf)); // execute le file
	
				if (result != 0)
				{
					Application.current.window.alert("LUA COMPILE ERROR:\n" + Lua.tostring(lua,result),"Kade Engine Modcharts");//kep this
					lua = null;
					LoadingState.loadAndSwitchState(new MainMenuState());
				}

				// get some fukin globals up in here bois
	
				setVar("difficulty", PlayState.storyDifficulty);
				setVar("bpm", Conductor.bpm);
				setVar("scrollspeed", FlxG.save.data.scrollSpeed != 1 ? FlxG.save.data.scrollSpeed : PlayState.SONG.speed);
				setVar("fpsCap", FlxG.save.data.fpsCap);
				setVar("downscroll", FlxG.save.data.downscroll);
				setVar("flashing", FlxG.save.data.flashing);
				setVar("distractions", FlxG.save.data.distractions);
	
				setVar("curStep", 0);
				setVar("daSection", 0);
				setVar("curBeat", 0);
				setVar("crochetReal", Conductor.crochet);
				setVar("crochet", Conductor.stepCrochet);
				setVar("safeZoneOffset", Conductor.safeZoneOffset);
	
				setVar("hudZoom", PlayState.instance.camHUD.zoom);
				setVar("cameraZoom", FlxG.camera.zoom);
				setVar("dadZoom", PlayState.dad.setZoom);
				setVar("bfZoom", PlayState.boyfriend.setZoom);
				setVar("gfZoom", PlayState.gf.setZoom);
	
				setVar("cameraAngle", FlxG.camera.angle);
				setVar("camHudAngle", PlayState.instance.camHUD.angle);
	
				setVar("followBFXOffset",0);
				setVar("followBFYOffset",0);
				setVar("followDadXOffset",0);
				setVar("followDadYOffset",0);

				setVar("bfAltAnim", false);
				setVar("dadAltAnim", false);
				setVar("bfNotesVisible", true);
				setVar("dadNotesInvisible", false);
	
				setVar("showOnlyStrums", false);
				setVar("strumLine1Visible", true);
				setVar("strumLine2Visible", true);
	
				setVar("screenWidth",FlxG.width);
				setVar("screenHeight",FlxG.height);
				setVar("windowWidth",FlxG.width);
				setVar("windowHeight",FlxG.height);
				setVar("hudWidth", PlayState.instance.camHUD.width);
				setVar("hudHeight", PlayState.instance.camHUD.height);
	
				setVar("mustHit", false);
				setVar("newIcons", false);
				setVar("swapIcons", true);
				setVar("playDadSing", true);
				setVar("playBFSing", true);

				setVar("strumLineY", PlayState.instance.strumLine.y);
				
				// callbacks
	
				// sprites
	
				Lua_helper.add_callback(lua,"makeSprite", makeLuaSprite);
				
				Lua_helper.add_callback(lua,"changeDadCharacter", changeDadCharacter);

				Lua_helper.add_callback(lua,"changeBoyfriendCharacter", changeBoyfriendCharacter);

				Lua_helper.add_callback(lua,"changeGFCharacter", changeGFCharacter);

				Lua_helper.add_callback(lua,"changeStage", changeStage);

				Lua_helper.add_callback(lua,"changeDadCharacterBetter", changeDadCharacterBetter);

				Lua_helper.add_callback(lua,"changeBoyfriendCharacterBetter", changeBoyfriendCharacterBetter);

				Lua_helper.add_callback(lua,"changeGFCharacterBetter", changeGFCharacterBetter);

				Lua_helper.add_callback(lua,"tweenFadeInAndOut", tweenFadeInAndOut);

				Lua_helper.add_callback(lua,"moveHoloDancers", moveHoloDancers);

				Lua_helper.add_callback(lua,"getProperty", getPropertyByName);//

				Lua_helper.add_callback(lua,"getCurCharacter", getCurCharacter);

				Lua_helper.add_callback(lua,"changeDad1Character", changeDad1Character);

				Lua_helper.add_callback(lua,"changeBoyfriend1Character", changeBoyfriend1Character);

				Lua_helper.add_callback(lua,"changeDad2Character", changeDad2Character);

				Lua_helper.add_callback(lua,"changeBoyfriend2Character", changeBoyfriend2Character);
				
				// Lua_helper.add_callback(lua,"makeAnimatedSprite", makeAnimatedLuaSprite);
				// this one is still in development

				Lua_helper.add_callback(lua,"destroySprite", function(id:String) {
					var sprite = luaSprites.get(id);
					if (sprite == null)
						return false;
					PlayState.instance.removeObject(sprite);
					return true;
				});

				Lua_helper.add_callback(lua,"destroyObject", function(id:String) {
					PlayState.instance.destroyObject(getActorByName(id));
				});

				
				Lua_helper.add_callback(lua,"setScrollFactor", function(id:String , x:Float, y:Float) {
					getActorByName(id).scrollFactor.set(x, y);
				});
	
				// hud/camera

				Lua_helper.add_callback(lua,"initBackgroundVideo", function(videoName:String) {
					trace('playing assets/videos/' + videoName + '.webm');
					PlayState.instance.backgroundVideo("assets/videos/" + videoName + ".webm");
				});

				Lua_helper.add_callback(lua,"updateHealthbar", function(dadColor:String = "", bfColor:String = ""){
					var opponent:String;
					var player:String;

					if (dadColor == "")
						opponent = PlayState.dad.iconColor;
					else
						opponent = dadColor;

					if (bfColor == "")
						player = PlayState.boyfriend.iconColor;
					else
						player = bfColor;

					PlayState.healthBar.createFilledBar(FlxColor.fromString('#' + opponent), FlxColor.fromString('#' + player));
					PlayState.healthBar.updateBar();
				});

				Lua_helper.add_callback(lua,"pauseVideo", function() {
					if (!GlobalVideo.get().paused)
						GlobalVideo.get().pause();
				});

				Lua_helper.add_callback(lua,"resumeVideo", function() {
					if (GlobalVideo.get().paused)
						GlobalVideo.get().pause();
				});

				Lua_helper.add_callback(lua,"playSound", function(id:String) {
					FlxG.sound.play(Paths.sound(id));
				});

				Lua_helper.add_callback(lua,"changeDadIcon", function(id:String) {
					PlayState.instance.iconP2.useOldSystem(id);
				});

				Lua_helper.add_callback(lua,"changeBFIcon", function(id:String) {
					PlayState.instance.iconP1.useOldSystem(id);
				});

				Lua_helper.add_callback(lua,"softCountdown", function(id:String) {
					PlayState.instance.softCountdown(id);
				});

				Lua_helper.add_callback(lua,"fixTrail", function(id:String) {
					PlayState.instance.fixTrailShit(id);
				});

				Lua_helper.add_callback(lua,"resetTrail", function(id:String) {
					getActorByName(id).resetTrail();
				});

				Lua_helper.add_callback(lua,"generateNumberFromRange", function(min:Float, max:Float) {
					return FlxG.random.float(min, max);
				});

				Lua_helper.add_callback(lua,"startWriting", function(timer:Int = 15, word:String) {
					PlayState.instance.writeStuff(timer, word);
				});

				Lua_helper.add_callback(lua,"zoomingFunctionThing", function(?camSpeed:Float = 0.55, ?camZoomMult:Float = 1) {
					PlayState.Stage.zoomingFunctionThing(camSpeed, camZoomMult); //only works on concert stage. don't use anywhere else
				});

				Lua_helper.add_callback(lua,"exeStatic", function(?id:String) {
					PlayState.instance.staticHitMiss(); //only works on concert stage. don't use anywhere else
				});

				Lua_helper.add_callback(lua,"changeDadIconNew", function(id:String) {
					PlayState.instance.iconP2.changeIcon(id);
				});

				Lua_helper.add_callback(lua,"changeBFIconNew", function(id:String) {
					PlayState.instance.iconP1.changeIcon(id);
				});

				Lua_helper.add_callback(lua,"getCurCharacter", function(id:String) {
					return getActorByName(id).curCharacter();
				});

				Lua_helper.add_callback(lua,"setBFStaticNotes", function(id:String) {
					PlayState.bfNoteStyle = id;
				});

				Lua_helper.add_callback(lua,"setDadStaticNotes", function(id:String) {
					PlayState.dadNoteStyle = id;
				});

				Lua_helper.add_callback(lua,"setDadNotes", function(id:String) {
					PlayState.SONG.dadNoteStyle = id;
				});

				Lua_helper.add_callback(lua,"setDownscroll", function(id:Bool) {
					FlxG.save.data.downscroll = id;
				});

				Lua_helper.add_callback(lua,"setBFNotes", function(id:String) {
					PlayState.SONG.bfNoteStyle = id;
				});

				Lua_helper.add_callback(lua,"setupNoteSplash", function(id:String) {
					PlayState.splashSkin = id;
				});

				Lua_helper.add_callback(lua,"pixelStrums", function(id:String, on:Bool) {
					if (id == 'dad')
						PlayState.pixelStrumsDad = on;
					else if (id == 'bf')
						PlayState.pixelStrumsBF = on;
				});

				Lua_helper.add_callback(lua,"removeObject", function(id:String) {
					PlayState.instance.removeObject(getActorByName(id));
				});

				Lua_helper.add_callback(lua,"addObject", function(id:String) {
					PlayState.instance.addObject(getActorByName(id));
				});

				Lua_helper.add_callback(lua,"changeStaticNotes", function(id:String, ?id2:String) {
					if (id2 == "" || id2 == null)id2 = id;
					PlayState.instance.changeStaticNotes(id, id2);
				});

				Lua_helper.add_callback(lua,"doStaticSign", function(lestatic:Int = 0, ?leopa:Bool = true) {
					PlayState.instance.doStaticSign(lestatic, leopa);
				});

				Lua_helper.add_callback(lua,"characterZoom", function(id:String, zoomAmount:Float) {
					getActorByName(id).setZoom(zoomAmount);
				});
				
				Lua_helper.add_callback(lua,"restartVideo", function() {
					GlobalVideo.get().restart();
				});

				Lua_helper.add_callback(lua,"getVideoSpriteX", function() {
					return PlayState.instance.videoSprite.x;
				});

				Lua_helper.add_callback(lua,"getVideoSpriteY", function() {
					return PlayState.instance.videoSprite.y;
				});

				Lua_helper.add_callback(lua,"setVideoSpritePos", function(x:Int,y:Int) {
					PlayState.instance.videoSprite.setPosition(x,y);
				});
				
				Lua_helper.add_callback(lua,"setVideoSpriteScale", function(scale:Float) {
					PlayState.instance.videoSprite.setGraphicSize(Std.int(PlayState.instance.videoSprite.width * scale));
				});
	
				Lua_helper.add_callback(lua,"setHudAngle", function (x:Float) {
					PlayState.instance.camHUD.angle = x;
				});
				
				Lua_helper.add_callback(lua,"setHealth", function (heal:Float) {
					PlayState.instance.health = heal;
				});

				Lua_helper.add_callback(lua,"minusHealth", function (heal:Float) {
					PlayState.instance.health -= heal;
				});

				Lua_helper.add_callback(lua,"setHudPosition", function (x:Int, y:Int) {
					PlayState.instance.camHUD.x = x;
					PlayState.instance.camHUD.y = y;
				});
	
				Lua_helper.add_callback(lua,"getHudX", function () {
					return PlayState.instance.camHUD.x;
				});
	
				Lua_helper.add_callback(lua,"getHudY", function () {
					return PlayState.instance.camHUD.y;
				});

				Lua_helper.add_callback(lua,"getPlayerStrumsY", function (id:Int) {
					return PlayState.strumLineNotes.members[id].y;
				});
				
				Lua_helper.add_callback(lua,"setCamPosition", function (x:Int, y:Int) {
					FlxG.camera.x = x;
					FlxG.camera.y = y;
				});

                Lua_helper.add_callback(lua,"shakeCam", function (i:Float, d:Float) {
					FlxG.camera.shake(i, d);
				});

				Lua_helper.add_callback(lua,"shakeHUD", function (i:Float, d:Float) {
					PlayState.instance.camHUD.shake(i, d);
				});
				Lua_helper.add_callback(lua, "fadeCam", function (r:Int,g:Int,b:Int, d:Float, f:Bool) {
					var c:FlxColor = new FlxColor();
					c.setRGB(r, g, b);
					FlxG.camera.fade(FlxColor.WHITE, d, f);
				});
				Lua_helper.add_callback(lua, "flashCam", function (r:Int,g:Int,b:Int, d:Float, f:Bool) {
					var c:FlxColor = new FlxColor();
					c.setRGB(r, g, b);
					FlxG.camera.flash(c, d, f);
				});

				Lua_helper.add_callback(lua, "flashCamHUD", function (r:Int,g:Int,b:Int, d:Float, f:Bool) {
					var c:FlxColor = new FlxColor();
					c.setRGB(r, g, b);
					PlayState.instance.camHUD.flash(c, d, f);
				});

				Lua_helper.add_callback(lua, "inAndOutCam", function (d:Float, d2:Float, d3:Float) 
				{
					FlxG.camera.fade(FlxColor.WHITE, d, false, function()
					{
						new FlxTimer().start(d2, function(tmr:FlxTimer)
						{
							FlxG.camera.fade(FlxColor.WHITE, d3, true);
						});			
					}	
					);										
				});
	
				Lua_helper.add_callback(lua,"getCameraX", function () {
					return FlxG.camera.x;
				});
	
				Lua_helper.add_callback(lua,"getCameraY", function () {
					return FlxG.camera.y;
				});

				Lua_helper.add_callback(lua,"setCamZoom", function(zoomAmount:Float) {
					FlxG.camera.zoom = zoomAmount;
				});

				Lua_helper.add_callback(lua,"addCamZoom", function(zoomAmount:Float) {
					FlxG.camera.zoom += zoomAmount;
				});

				Lua_helper.add_callback(lua,"addHudZoom", function(zoomAmount:Float) {
					PlayState.instance.camHUD.zoom += zoomAmount;
				});
	
				Lua_helper.add_callback(lua,"setDefaultCamZoom", function(zoomAmount:Float) {
					PlayState.defaultCamZoom = zoomAmount;
				});

				Lua_helper.add_callback(lua,"setHudZoom", function(zoomAmount:Float) {
					PlayState.instance.camHUD.zoom = zoomAmount;
				});

				Lua_helper.add_callback(lua,"setCamFollow", function(x:Float, y:Float) {
					PlayState.camFollowIsOn = false;
					PlayState.camFollow.setPosition(x, y);
				});

				Lua_helper.add_callback(lua,"setDelayedCamFollow", function(time:Float,x:Float, y:Float) {
					PlayState.camFollowIsOn = false;

					new FlxTimer().start(time, function(tmr:FlxTimer)
					{
						PlayState.camFollow.setPosition(x, y);
					});	
				});

				Lua_helper.add_callback(lua,"sundayFilter", function(bool:Bool) {
					//The string does absolutely nothing
					PlayState.instance.chromOn = bool;
				});

				Lua_helper.add_callback(lua,"offCamFollow", function(id:String) {
					//The string does absolutely nothing
					PlayState.camFollowIsOn = false;
				});

				Lua_helper.add_callback(lua,"resetCamFollow", function(id:String) {
					//The string does absolutely nothing
					PlayState.camFollowIsOn = true;
				});

				Lua_helper.add_callback(lua,"snapCam", function(x:Float, y:Float) {
					//The string does absolutely nothing
					PlayState.camFollowIsOn = false;
					PlayState.defaultCamFollow = false;
					{
						var camPosition:FlxObject;
						camPosition = new FlxObject(0, 0, 1, 1);
						camPosition.setPosition(x, y);
						FlxG.camera.focusOn(camPosition.getPosition());
					}
				});

				Lua_helper.add_callback(lua,"resetSnapCam", function(id:String) {
					//The string does absolutely nothing
					PlayState.defaultCamFollow = true;
				});

				Lua_helper.add_callback(lua,"toggleSnapCam", function(id:Bool) {
					//The string does absolutely nothing
					PlayState.defaultCamFollow = id;
				});
				
				Lua_helper.add_callback(lua,"resetCamEffects", function(id:String) {
					PlayState.defaultCamFollow = true;
					PlayState.camFollowIsOn = true;
				});

				// strumline

				Lua_helper.add_callback(lua, "setStrumlineY", function(y:Float)
				{
					PlayState.instance.strumLine.y = y;
				});
	
				// actors
				
				Lua_helper.add_callback(lua,"getRenderedNotes", function() {
					return PlayState.instance.notes.length;
				});
	
				Lua_helper.add_callback(lua,"getRenderedNoteX", function(id:Int) {
					return PlayState.instance.notes.members[id].x;
				});
	
				Lua_helper.add_callback(lua,"getRenderedNoteY", function(id:Int) {
					return PlayState.instance.notes.members[id].y;
				});

				Lua_helper.add_callback(lua,"getRenderedNoteType", function(id:Int) {
					return PlayState.instance.notes.members[id].noteData;
				});

				Lua_helper.add_callback(lua,"isSustain", function(id:Int) {
					return PlayState.instance.notes.members[id].isSustainNote;
				});

				Lua_helper.add_callback(lua,"isParentSustain", function(id:Int) {
					return PlayState.instance.notes.members[id].prevNote.isSustainNote;
				});

				
				Lua_helper.add_callback(lua,"getRenderedNoteParentX", function(id:Int) {
					return PlayState.instance.notes.members[id].prevNote.x;
				});

				Lua_helper.add_callback(lua,"getRenderedNoteParentY", function(id:Int) {
					return PlayState.instance.notes.members[id].prevNote.y;
				});

				Lua_helper.add_callback(lua,"getRenderedNoteHit", function(id:Int) {
					return PlayState.instance.notes.members[id].mustPress;
				});

				Lua_helper.add_callback(lua,"getRenderedNoteCalcX", function(id:Int) {
					if (PlayState.instance.notes.members[id].mustPress)
						return PlayState.playerStrums.members[Math.floor(Math.abs(PlayState.instance.notes.members[id].noteData))].x;
					return PlayState.strumLineNotes.members[Math.floor(Math.abs(PlayState.instance.notes.members[id].noteData))].x;
				});

				Lua_helper.add_callback(lua,"anyNotes", function() {
					return PlayState.instance.notes.members.length != 0;
				});

				Lua_helper.add_callback(lua,"getRenderedNoteStrumtime", function(id:Int) {
					return PlayState.instance.notes.members[id].strumTime;
				});
	
				Lua_helper.add_callback(lua,"getRenderedNoteScaleX", function(id:Int) {
					return PlayState.instance.notes.members[id].scale.x;
				});
	
				Lua_helper.add_callback(lua,"setRenderedNotePos", function(x:Float,y:Float, id:Int) {
					if (PlayState.instance.notes.members[id] == null)
						throw('error! you cannot set a rendered notes position when it doesnt exist! ID: ' + id);
					else
					{
						PlayState.instance.notes.members[id].modifiedByLua = true;
						PlayState.instance.notes.members[id].x = x;
						PlayState.instance.notes.members[id].y = y;
					}
				});
	
				Lua_helper.add_callback(lua,"setRenderedNoteAlpha", function(alpha:Float, id:Int) {
					PlayState.instance.notes.members[id].modifiedByLua = true;
					PlayState.instance.notes.members[id].alpha = alpha;
				});
	
				Lua_helper.add_callback(lua,"setRenderedNoteScale", function(scale:Float, id:Int) {
					PlayState.instance.notes.members[id].modifiedByLua = true;
					PlayState.instance.notes.members[id].setGraphicSize(Std.int(PlayState.instance.notes.members[id].width * scale));
				});

				Lua_helper.add_callback(lua,"setRenderedNoteScale", function(scaleX:Int, scaleY:Int, id:Int) {
					PlayState.instance.notes.members[id].modifiedByLua = true;
					PlayState.instance.notes.members[id].setGraphicSize(scaleX,scaleY);
				});

				Lua_helper.add_callback(lua,"getRenderedNoteWidth", function(id:Int) {
					return PlayState.instance.notes.members[id].width;
				});


				Lua_helper.add_callback(lua,"setRenderedNoteAngle", function(angle:Float, id:Int) {
					PlayState.instance.notes.members[id].modifiedByLua = true;
					PlayState.instance.notes.members[id].angle = angle;
				});
	
				Lua_helper.add_callback(lua,"setActorX", function(x:Int,id:String, ?bg:Bool = false) {
					if (bg){
						PlayState.Stage.swagBacks[id].x = x;
					}
					else {
						getActorByName(id).x = x;
					}	
				});
				
				Lua_helper.add_callback(lua,"setActorAccelerationX", function(x:Int,id:String) {
					getActorByName(id).acceleration.x = x;
				});
				
				Lua_helper.add_callback(lua,"setActorDragX", function(x:Int,id:String) {
					getActorByName(id).drag.x = x;
				});
				
				Lua_helper.add_callback(lua,"setActorVelocityX", function(x:Int,id:String, ?bg:Bool = false) {
					if (bg){
						PlayState.Stage.swagBacks[id].velocity.x = x;
					}
					else {
						getActorByName(id).velocity.x = x;
					}				
				});
				
				Lua_helper.add_callback(lua,"playActorAnimation", function(id:String,anim:String,force:Bool = false,reverse:Bool = false, ?frame:Int = 0) {
					getActorByName(id).playAnim(anim, force, reverse, frame);
				});

				Lua_helper.add_callback(lua,"playBGAnimation", function(id:String,anim:String,force:Bool = false,reverse:Bool = false) {
					PlayState.Stage.swagBacks[id].animation.play(anim, force, reverse);
				});

				Lua_helper.add_callback(lua,"playBGAnimation2", function(id:String,anim:String,force:Bool = false,reverse:Bool = false) {
					getActorByName(id).animation.play(anim, force, reverse);
				});

				Lua_helper.add_callback(lua,"setDadAltAnim", function(alt:String){
					PlayState.dad.altAnim = alt;
				});

				Lua_helper.add_callback(lua,"setBFAltAnim", function (alt:String){
					PlayState.boyfriend.bfAltAnim = alt;
				});

				Lua_helper.add_callback(lua,"setGFAltAnim", function(alt:String){
					PlayState.gf.altAnim = alt;
				});

				Lua_helper.add_callback(lua,"flickerActor", function (id:FlxObject, duration:Float, interval:Float) {
					FlxFlicker.flicker(id, duration, interval);
				});
	
				Lua_helper.add_callback(lua,"setActorAlpha", function(alpha:Float,id:String, ?bg:Bool = false) {
					if (bg){
						PlayState.Stage.swagBacks[id].alpha = alpha;
					}
					else {
						getActorByName(id).alpha = alpha;
					}
				});

				/*Lua_helper.add_callback(lua,"boomBoom", function(visible:Bool,id:String, id2:Int) {
					getActorByName(id).members[id2].visible = visible;
				});*/

				Lua_helper.add_callback(lua,"setActorVisibility", function(alpha:Bool,id:String, ?bg:Bool = false) {
					if (bg){
						PlayState.Stage.swagBacks[id].visible = alpha;
					}
					else {
						getActorByName(id).visible = alpha;
					}	
				});
	
				Lua_helper.add_callback(lua,"setActorY", function(y:Int,id:String, ?bg:Bool = false) {
					if (bg){
						PlayState.Stage.swagBacks[id].y = y;
					}
					else {
						getActorByName(id).y = y;
					}	
				});

				Lua_helper.add_callback(lua,"setActorAccelerationY", function(y:Int,id:String) {
					getActorByName(id).acceleration.y = y;
				});
				
				Lua_helper.add_callback(lua,"setActorDragY", function(y:Int,id:String) {
					getActorByName(id).drag.y = y;
				});
				
				Lua_helper.add_callback(lua,"setActorVelocityY", function(y:Int,id:String) {
					getActorByName(id).velocity.y = y;
				});
				
				Lua_helper.add_callback(lua,"setActorAngle", function(angle:Int,id:String) {
					getActorByName(id).angle = angle;
				});
	
				Lua_helper.add_callback(lua,"setActorScale", function(scale:Float,id:String, ?bg:Bool = false) {
					if (bg) {
						PlayState.Stage.swagBacks[id].setGraphicSize(Std.int(PlayState.Stage.swagBacks[id].width * scale));
					}
					else {
						getActorByName(id).setGraphicSize(Std.int(getActorByName(id).width * scale));
					}		
				});
				
				Lua_helper.add_callback(lua, "setActorScaleXY", function(scaleX:Float, scaleY:Float, id:String)
				{
					getActorByName(id).setGraphicSize(Std.int(getActorByName(id).width * scaleX), Std.int(getActorByName(id).height * scaleY));
				});

				Lua_helper.add_callback(lua,"stopGFDance", function(stop:Bool) {
					PlayState.picoCutscene = stop;
				});

				Lua_helper.add_callback(lua,"isPixel", function(change:Bool) {
					PlayState.isPixel = change;
				});
	
				Lua_helper.add_callback(lua, "setActorFlipX", function(flip:Bool, id:String)
				{
					getActorByName(id).flipX = flip;
				});
				

				Lua_helper.add_callback(lua, "setActorFlipY", function(flip:Bool, id:String)
				{
					getActorByName(id).flipY = flip;
				});
	
				Lua_helper.add_callback(lua,"getActorWidth", function (id:String) {
					return getActorByName(id).width;
				});
	
				Lua_helper.add_callback(lua,"getActorHeight", function (id:String) {
					return getActorByName(id).height;
				});
	
				Lua_helper.add_callback(lua,"getActorAlpha", function(id:String) {
					return getActorByName(id).alpha;
				});
	
				Lua_helper.add_callback(lua,"getActorAngle", function(id:String) {
					return getActorByName(id).angle;
				});
	
				Lua_helper.add_callback(lua,"getActorX", function (id:String, ?bg:Bool = false) {
					if (bg)
						return PlayState.Stage.swagBacks[id].x;
					else
						return getActorByName(id).x;
				});
	
				Lua_helper.add_callback(lua,"getActorY", function (id:String, ?bg:Bool = false) {
					if (bg)
						return PlayState.Stage.swagBacks[id].y;
					else
						return getActorByName(id).y;
				});

				Lua_helper.add_callback(lua,"getActorXMidpoint", function (id:String) {
					return getActorByName(id).getMidpoint().x;
				});
	
				Lua_helper.add_callback(lua,"getActorYMidpoint", function (id:String) {
					return getActorByName(id).getMidpoint().y;
				});

				Lua_helper.add_callback(lua,"setWindowPos",function(x:Int,y:Int) {
					Application.current.window.x = x;
					Application.current.window.y = y;
				});

				Lua_helper.add_callback(lua,"getWindowX",function() {
					return Application.current.window.x;
				});

				Lua_helper.add_callback(lua,"getWindowY",function() {
					return Application.current.window.y;
				});

				Lua_helper.add_callback(lua,"resizeWindow",function(Width:Int,Height:Int) {
					Application.current.window.resize(Width,Height);
				});
				
				Lua_helper.add_callback(lua,"getScreenWidth",function() {
					return Application.current.window.display.currentMode.width;
				});

				Lua_helper.add_callback(lua,"getScreenHeight",function() {
					return Application.current.window.display.currentMode.height;
				});

				Lua_helper.add_callback(lua,"getWindowWidth",function() {
					return Application.current.window.width;
				});

				Lua_helper.add_callback(lua,"getWindowHeight",function() {
					return Application.current.window.height;
				});

	
				// tweens
				
				Lua_helper.add_callback(lua,"tweenCameraPos", function(toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {x: toX, y: toY}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});
								
				Lua_helper.add_callback(lua,"tweenCameraAngle", function(toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {angle:toAngle}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenCameraZoom", function(toZoom:Float, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {zoom:toZoom}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenHudPos", function(toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {x: toX, y: toY}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});
								
				Lua_helper.add_callback(lua,"tweenHudAngle", function(toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {angle:toAngle}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenHudZoom", function(toZoom:Float, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {zoom:toZoom}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenPos", function(id:String, toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, y: toY}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});

				Lua_helper.add_callback(lua,"tweenPosQuad", function(id:String, toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, y: toY}, time, {ease: FlxEase.quadInOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosXAngle", function(id:String, toX:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, angle: toAngle}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosYAngle", function(id:String, toY:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {y: toY, angle: toAngle}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenAngle", function(id:String, toAngle:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {angle: toAngle}, time, {ease: FlxEase.linear, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});

				Lua_helper.add_callback(lua,"tweenCameraPosOut", function(toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {x: toX, y: toY}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});
								
				Lua_helper.add_callback(lua,"tweenCameraAngleOut", function(toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {angle:toAngle}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenCameraZoomOut", function(toZoom:Float, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {zoom:toZoom}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenHudPosOut", function(toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {x: toX, y: toY}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});
								
				Lua_helper.add_callback(lua,"tweenHudAngleOut", function(toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {angle:toAngle}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenHudZoomOut", function(toZoom:Float, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {zoom:toZoom}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenPosOut", function(id:String, toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, y: toY}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosXAngleOut", function(id:String, toX:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, angle: toAngle}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosYAngleOut", function(id:String, toY:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {y: toY, angle: toAngle}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenAngleOut", function(id:String, toAngle:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {angle: toAngle}, time, {ease: FlxEase.cubeOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});

				Lua_helper.add_callback(lua,"tweenCameraPosIn", function(toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {x: toX, y: toY}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});
								
				Lua_helper.add_callback(lua,"tweenCameraAngleIn", function(toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {angle:toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenCameraZoomIn", function(toZoom:Float, time:Float, onComplete:String) {
					FlxTween.tween(FlxG.camera, {zoom:toZoom}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenHudPosIn", function(toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {x: toX, y: toY}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});
								
				Lua_helper.add_callback(lua,"tweenHudAngleIn", function(toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {angle:toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenHudZoomIn", function(toZoom:Float, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.instance.camHUD, {zoom:toZoom}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,["camera"]);}}});
				});

				Lua_helper.add_callback(lua,"tweenPosIn", function(id:String, toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, y: toY}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosXAngleIn", function(id:String, toX:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosYAngleIn", function(id:String, toY:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {y: toY, angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenAngleIn", function(id:String, toAngle:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenFadeIn", function(id:String, toAlpha:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {alpha: toAlpha}, time, {ease: FlxEase.circIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});

				Lua_helper.add_callback(lua,"tweenFadeInBG", function(id:String, toAlpha:Float, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.Stage.swagBacks[id], {alpha: toAlpha}, time, {ease: FlxEase.circIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenFadeOut", function(id:String, toAlpha:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {alpha: toAlpha}, time, {ease: FlxEase.circOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});

				Lua_helper.add_callback(lua,"tweenFadeOutBG", function(id:String, toAlpha:Float, time:Float, onComplete:String) {
					FlxTween.tween(PlayState.Stage.swagBacks[id], {alpha: toAlpha}, time, {ease: FlxEase.circOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});

				Lua_helper.add_callback(lua,"tweenFadeOutOneShot", function(id:String, toAlpha:Float, time:Float) {
					FlxTween.tween(getActorByName(id), {alpha: toAlpha}, time, {type: FlxTweenType.ONESHOT});
				});

				Lua_helper.add_callback(lua,"tweenColor", function(id:String, time:Float, initColor:FlxColor, finalColor:FlxColor) {
					FlxTween.color(getActorByName(id), time, initColor, finalColor);
				});

				//my version of some psych tweens
				Lua_helper.add_callback(lua,"tweenAnglePsych", function(id:String, toAngle:Int, time:Float, ease:String, onComplete:String, ?bg:Bool = false) {
					if (bg)
						FlxTween.tween(PlayState.Stage.swagBacks[id], {angle: toAngle}, time, {ease: getFlxEaseByString(ease), onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
					else
						FlxTween.tween(getActorByName(id), {angle: toAngle}, time, {ease: getFlxEaseByString(ease), onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});

				Lua_helper.add_callback(lua,"tweenXPsych", function(id:String, toX:Int, time:Float, ease:String, onComplete:String, ?bg:Bool = false) {
					if (bg)
						FlxTween.tween(PlayState.Stage.swagBacks[id], {x: toX}, time, {ease: getFlxEaseByString(ease), onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
					else
						FlxTween.tween(getActorByName(id), {x: toX}, time, {ease: getFlxEaseByString(ease), onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});

				Lua_helper.add_callback(lua,"tweenYPsych", function(id:String, toY:Int, time:Float, ease:String, onComplete:String, ?bg:Bool = false) {
					if (bg)
						FlxTween.tween(PlayState.Stage.swagBacks[id], {y: toY}, time, {ease: getFlxEaseByString(ease), onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
					else
						FlxTween.tween(getActorByName(id), {y: toY}, time, {ease: getFlxEaseByString(ease), onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});

				Lua_helper.add_callback(lua,"tweenZoomPsych", function(id:String, toZoom:Int, time:Float, ease:String, onComplete:String, ?bg:Bool = false) {
					if (bg)
						FlxTween.tween(PlayState.Stage.swagBacks[id], {zoom: toZoom}, time, {ease: getFlxEaseByString(ease), onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
					else
						FlxTween.tween(getActorByName(id), {zoom: toZoom}, time, {ease: getFlxEaseByString(ease), onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});

				//forgot and accidentally commit to master branch
				// shader
				
				/*Lua_helper.add_callback(lua,"createShader", function(frag:String,vert:String) {
					var shader:LuaShader = new LuaShader(frag,vert);

					trace(shader.glFragmentSource);

					shaders.push(shader);
					// if theres 1 shader we want to say theres 0 since 0 index and length returns a 1 index.
					return shaders.length == 1 ? 0 : shaders.length;
				});

				
				Lua_helper.add_callback(lua,"setFilterHud", function(shaderIndex:Int) {
					PlayState.instance.camHUD.setFilters([new ShaderFilter(shaders[shaderIndex])]);
				});

				Lua_helper.add_callback(lua,"setFilterCam", function(shaderIndex:Int) {
					FlxG.camera.setFilters([new ShaderFilter(shaders[shaderIndex])]);
				});*/

				// default strums

				for (i in 0...PlayState.strumLineNotes.length) {
					var member = PlayState.strumLineNotes.members[i];
					trace(PlayState.strumLineNotes.members[i].x + " " + PlayState.strumLineNotes.members[i].y + " " + PlayState.strumLineNotes.members[i].angle + " | strum" + i);
					//setVar("strum" + i + "X", Math.floor(member.x));
					setVar("defaultStrum" + i + "X", Math.floor(member.x));
					//setVar("strum" + i + "Y", Math.floor(member.y));
					setVar("defaultStrum" + i + "Y", Math.floor(member.y));
					//setVar("strum" + i + "Angle", Math.floor(member.angle));
					setVar("defaultStrum" + i + "Angle", Math.floor(member.angle));
					setVar("defaultStrum" + i + "Alpha", Math.floor(member.alpha));
					trace("Adding strum" + i);
				}

				//dumb group dancer shit
				// default strums
    }

    public function executeState(name,args:Array<Dynamic>)
    {
        return Lua.tostring(lua,callLua(name, args));
    }

    public static function createModchartState():ModchartState
    {
        return new ModchartState();
    }

	function getFlxEaseByString(?ease:String = '') {
		switch(ease.toLowerCase().trim()) {
			case 'backin': return FlxEase.backIn;
			case 'backinout': return FlxEase.backInOut;
			case 'backout': return FlxEase.backOut;
			case 'bouncein': return FlxEase.bounceIn;
			case 'bounceinout': return FlxEase.bounceInOut;
			case 'bounceout': return FlxEase.bounceOut;
			case 'circin': return FlxEase.circIn;
			case 'circinout': return FlxEase.circInOut;
			case 'circout': return FlxEase.circOut;
			case 'cubein': return FlxEase.cubeIn;
			case 'cubeinout': return FlxEase.cubeInOut;
			case 'cubeout': return FlxEase.cubeOut;
			case 'elasticin': return FlxEase.elasticIn;
			case 'elasticinout': return FlxEase.elasticInOut;
			case 'elasticout': return FlxEase.elasticOut;
			case 'expoin': return FlxEase.expoIn;
			case 'expoinout': return FlxEase.expoInOut;
			case 'expoout': return FlxEase.expoOut;
			case 'quadin': return FlxEase.quadIn;
			case 'quadinout': return FlxEase.quadInOut;
			case 'quadout': return FlxEase.quadOut;
			case 'quartin': return FlxEase.quartIn;
			case 'quartinout': return FlxEase.quartInOut;
			case 'quartout': return FlxEase.quartOut;
			case 'quintin': return FlxEase.quintIn;
			case 'quintinout': return FlxEase.quintInOut;
			case 'quintout': return FlxEase.quintOut;
			case 'sinein': return FlxEase.sineIn;
			case 'sineinout': return FlxEase.sineInOut;
			case 'sineout': return FlxEase.sineOut;
			case 'smoothstepin': return FlxEase.smoothStepIn;
			case 'smoothstepinout': return FlxEase.smoothStepInOut;
			case 'smoothstepout': return FlxEase.smoothStepInOut;
			case 'smootherstepin': return FlxEase.smootherStepIn;
			case 'smootherstepinout': return FlxEase.smootherStepInOut;
			case 'smootherstepout': return FlxEase.smootherStepOut;
		}
		return FlxEase.linear;
	}

}
#end