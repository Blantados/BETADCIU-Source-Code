package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;

using StringTools;

class PreloadStage extends MusicBeatState
{
	public var curStage:String = '';
	public var camZoom:Float; // The zoom of the camera to have at the start of the game
	public var hideLastBG:Bool = false; // True = hide last BGs and show ones from slowBacks on certain step, False = Toggle visibility of BGs from SlowBacks on certain step
	// Use visible property to manage if BG would be visible or not at the start of the game
	public var tweenDuration:Float = 2; // How long will it tween hiding/showing BGs, variable above must be set to True for tween to activate
	public var toAdd:Array<Dynamic> = []; // Add BGs on stage startup, load BG in by using "toAdd.push(bgVar);"
	// Layering algorithm for noobs: Everything loads by the method of "On Top", example: You load wall first(Every other added BG layers on it), then you load road(comes on top of wall and doesn't clip through it), then loading street lights(comes on top of wall and road)
	public var swagBacks:Map<String,
		Dynamic> = []; // Store BGs here to use them later (for example with slowBacks, using your custom stage event or to adjust position in stage debug menu(press 8 while in PlayState with debug build of the game))
	public var swagGroup:Map<String, FlxTypedGroup<Dynamic>> = []; // Store Groups
	public var animatedBacks:Array<FlxSprite> = []; // Store animated backgrounds and make them play animation(Animation must be named Idle!! Else use swagGroup/swagBacks and script it in stepHit/beatHit function of this file!!)
	public var layInFront:Array<Array<FlxSprite>> = [[], [], []]; // BG layering, format: first [0] - in front of GF, second [1] - in front of opponent, third [2] - in front of boyfriend(and technically also opponent since Haxe layering moment)
	public var slowBacks:Map<Int,
		Array<FlxSprite>> = []; // Change/add/remove backgrounds mid song! Format: "slowBacks[StepToBeActivated] = [Sprites,To,Be,Changed,Or,Added];"
	public var toCamHUD:Array<Dynamic> = []; // Add BGs on stage startup, load BG in by using "toCamHUD.push(bgVar);"
	// BGs still must be added by using toAdd Array for them to show in game after slowBacks take effect!!
	// BGs still must be added by using toAdd Array for them to show in game after slowBacks take effect!!
	// All of the above must be set or used in your stage case code block!!

	var pre:String = ""; //lol
	var suf:String = ""; //lol2

	//moving the offset shit here too
	public var gfXOffset:Float = 0;
	public var dadXOffset:Float = 0;
	public var bfXOffset:Float = 0;
	public var gfYOffset:Float = 0;
	public var dadYOffset:Float = 0;
	public var bfYOffset:Float = 0;

	var fastCarCanDrive:Bool = false;

	public function new(daStage:String)
	{
		super();
		this.curStage = daStage;
		camZoom = 1.05; // Don't change zoom here, unless you want to change zoom of every stage that doesn't have custom one --shouldn't this just be 0.9 since most use it then switch the zoom for halloween and school?
		pre = "";
		suf = "";
		fastCarCanDrive = false;

		switch (daStage)
		{
			case 'halloween' | 'halloweenmanor' | 'halloween-pelo':
			{	
				var halloweenBG = new FlxSprite(-200, -80);
				switch (daStage)
				{
					case 'halloween':
						halloweenBG.frames = Paths.getSparrowAtlas('halloween_bg', 'week2');
					case 'halloweenmanor':
						halloweenBG.frames = Paths.getSparrowAtlas('manor_bg', 'week2');
					case 'halloween-pelo':
						halloweenBG.frames = Paths.getSparrowAtlas('halloween_bg_pelo', 'week2');
						camZoom = 0.9;
				}
				
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				swagBacks['halloweenBG'] = halloweenBG;
				toAdd.push(halloweenBG);
			}
			case 'philly' | 'phillyannie':
			{
				switch (daStage)
				{
					case 'philly': pre = 'philly';
					case 'phillyannie': pre = 'annie';
				}

				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image(pre+'/sky', 'week3'));
				bg.scrollFactor.set(0.1, 0.1);
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image(pre+'/city', 'week3'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				swagBacks['city'] = city;
				toAdd.push(city);

				var phillyCityLights = new FlxTypedGroup<FlxSprite>();
				swagGroup['phillyCityLights'] = phillyCityLights;
				toAdd.push(phillyCityLights);

				for (i in 0...5)
				{
					var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image(pre+'/win' + i, 'week3'));
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = FlxG.save.data.antialiasing;
					phillyCityLights.add(light);
				}

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image(pre+'/behindTrain', 'week3'));
				swagBacks['streetBehind'] = streetBehind;
				toAdd.push(streetBehind);

				var phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image(pre+'/train', 'week3'));
				swagBacks['phillyTrain'] = phillyTrain;
				toAdd.push(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes', 'week3'));
				FlxG.sound.list.add(trainSound);

				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image(pre+'/street', 'week3'));
				swagBacks['street'] = street;
				toAdd.push(street);
			}

			case 'limo':
			{
				camZoom = 0.9;

				var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset', 'week4'));
				skyBG.scrollFactor.set(0.1, 0.1);
				swagBacks['skyBG'] = skyBG;
				toAdd.push(skyBG);

				var bgLimo:FlxSprite = new FlxSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo', 'week4');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				swagBacks['bgLimo'] = bgLimo;
				toAdd.push(bgLimo);
	
				var grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
				swagGroup['grpLimoDancers'] = grpLimoDancers;
				toAdd.push(grpLimoDancers);

				for (i in 0...5)
				{
					var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					grpLimoDancers.add(dancer);
					swagBacks['dancer' + i] = dancer;
				}

				var limo = new FlxSprite(-120, 550);
				limo.frames = Paths.getSparrowAtlas('limo/limoDrive', 'week4');
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;
				layInFront[0].push(limo);
				swagBacks['limo'] = limo;

				var fastCar = new FlxSprite(-12600, 160).loadGraphic(Paths.image('limo/fastCarLol', 'week4'));
				swagBacks['fastCar'] = fastCar;
				toAdd.push(fastCar);

				fastCarCanDrive = true;
			}

			case 'limoholo':
			{
				camZoom = 0.9;
	
				var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('holofunk/limoholo/limoSunset'));
				skyBG.scrollFactor.set(0.1, 0.1);
				swagBacks['skyBG'] = skyBG;
				toAdd.push(skyBG);
				
				var bgLimo:FlxSprite = new FlxSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('holofunk/limoholo/bgLimo');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				swagBacks['bgLimo'] = bgLimo;
				toAdd.push(bgLimo);

				var grpLimoDancersHolo = new FlxTypedGroup<BackgroundDancerHolo>();
				swagGroup['grpLimoDancersHolo'] = grpLimoDancersHolo;
				toAdd.push(grpLimoDancersHolo);

				for (i in 0...5)
				{
					var dancer:BackgroundDancerHolo = new BackgroundDancerHolo((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					grpLimoDancersHolo.add(dancer);
					swagBacks['dancer' + i] = dancer;
				}

				var limo = new FlxSprite(-120, 550);
				limo.frames = Paths.getSparrowAtlas('holofunk/limoholo/limoDrive');
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;
				layInFront[0].push(limo);
				swagBacks['limo'] = limo;

				var fastCar = new FlxSprite(-12600, 160).loadGraphic(Paths.image('holofunk/limoholo/fastCarLol'));
				swagBacks['fastCar'] = fastCar;
				toAdd.push(fastCar);

				fastCarCanDrive = true;
			}
			case 'mall' | 'softdeez': //soft deez nuts
			{
				camZoom = 0.80;

				switch (curStage)
				{
					case 'mall':
						pre = 'christmas';
						suf = 'week5';
					case 'softdeez':
						pre = 'skye';
						suf = 'week1';
				}

				var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image(pre+'/bgWalls', suf));
				bg.antialiasing = FlxG.save.data.antialiasing;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var upperBoppers = new FlxSprite(-240, -90);

				if (PlayState.dad.curCharacter == 'bico-christmas' || PlayState.dad.curCharacter.contains('pico') && PlayState.dad.curCharacter != 'piconjo') {
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBopNoPico', 'week5');
				}
				else {
					upperBoppers.frames = Paths.getSparrowAtlas(pre+'/upperBop', suf);
				}
				
				upperBoppers.animation.addByPrefix('idle', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = FlxG.save.data.antialiasing;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				swagBacks['upperBoppers'] = upperBoppers;
				toAdd.push(upperBoppers);
				animatedBacks.push(upperBoppers);

				var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image(pre+'/bgEscalator', suf));
				bgEscalator.antialiasing = FlxG.save.data.antialiasing;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				swagBacks['bgEscalator'] = bgEscalator;
				toAdd.push(bgEscalator);

				var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image(pre+'/christmasTree', suf));
				tree.antialiasing = FlxG.save.data.antialiasing;
				tree.scrollFactor.set(0.40, 0.40);
				swagBacks['tree'] = tree;
				toAdd.push(tree);

				var bottomBoppers:FlxSprite;

				if (pre == 'skye')
				{
					bottomBoppers = new FlxSprite(-540, -210);
					bottomBoppers.scrollFactor.set(1, 1);
				}		
				else
				{
					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.scrollFactor.set(0.9, 0.9);
				}
					
			
				bottomBoppers.frames = Paths.getSparrowAtlas(pre+'/bottomBop', suf);
				bottomBoppers.animation.addByPrefix('idle', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = FlxG.save.data.antialiasing;
				
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				swagBacks['bottomBoppers'] = bottomBoppers;
				toAdd.push(bottomBoppers);
				animatedBacks.push(bottomBoppers);

				var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image(pre+'/fgSnow', suf));
				fgSnow.active = false;
				fgSnow.antialiasing = FlxG.save.data.antialiasing;
				swagBacks['fgSnow'] = fgSnow;
				toAdd.push(fgSnow);

				var santa = new FlxSprite(-840, 150);
				santa.frames = Paths.getSparrowAtlas(pre+'/santa', suf);
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = FlxG.save.data.antialiasing;
				swagBacks['santa'] = santa;
				toAdd.push(santa);
				animatedBacks.push(santa);
			}
			case 'mallSoft':
			{
				camZoom = 0.80;

				var bg = new FlxSprite(-1000, -500).loadGraphic(Paths.image('soft/christmas/bgWalls'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var upperBoppers = new FlxSprite(-240, -90);
				var bottomBoppers = new FlxSprite(-150, 0);

				if (PlayState.SONG.song.toLowerCase() == 'ugh-remix' || PlayState.SONG.song.toLowerCase() == 'hope') {			
					upperBoppers.frames = Paths.getSparrowAtlas('soft/christmas/angrybogosbinted');
					bottomBoppers.frames = Paths.getSparrowAtlas('soft/christmas/bopit');
				}
				else {		
					upperBoppers.frames = Paths.getSparrowAtlas('soft/christmas/normalfuckerspng');	
					bottomBoppers.frames = Paths.getSparrowAtlas('soft/christmas/bop1');
				}
				
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				swagBacks['upperBoppers'] = upperBoppers;
				toAdd.push(upperBoppers);
				animatedBacks.push(upperBoppers);

				var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('soft/christmas/bgEscalator'));
				bgEscalator.antialiasing = true;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				swagBacks['bgEscalator'] = bgEscalator;
				toAdd.push(bgEscalator);

				var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('soft/christmas/christmasTree'));
				tree.antialiasing = true;
				tree.scrollFactor.set(0.40, 0.40);
				swagBacks['tree'] = tree;
				toAdd.push(tree);

				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();			
				swagBacks['bottomBoppers'] = bottomBoppers;
				toAdd.push(bottomBoppers);
				animatedBacks.push(bottomBoppers);

				if (PlayState.SONG.song.toLowerCase() == 'ugh-remix')
				{
					var blantadBG2 = new FlxSprite(-300, 120);
					blantadBG2.frames = Paths.getSparrowAtlas('soft/christmas/allAloneRIP');
					blantadBG2.animation.addByPrefix('bop', 'blantad', 24, false);
					blantadBG2.antialiasing = true;
					blantadBG2.scrollFactor.set(0.9, 0.9);
					add(blantadBG2);
				}

				var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('soft/christmas/fgSnow'));
				fgSnow.active = false;
				fgSnow.antialiasing = true;
				swagBacks['fgSnow'] = fgSnow;
				toAdd.push(fgSnow);

				var santa = new FlxSprite(-840, 150);
				santa.frames = Paths.getSparrowAtlas('soft/christmas/santa1');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = true;
				swagBacks['santa'] = santa;
				layInFront[2].push(santa);
				animatedBacks.push(santa);
				
				if (PlayState.SONG.song.toLowerCase() == 'ugh-remix')
				{
					var gfBG = new GirlfriendBG(1164, 426, 'characters/softPico_Christmas', 'GF Dancing Beat');
					gfBG.antialiasing = true;
					gfBG.scrollFactor.set(0.9, 0.9);
					gfBG.setGraphicSize(Std.int(gfBG.width * 0.8));
					gfBG.updateHitbox();
					swagBacks['gfBG'] = gfBG;
					toAdd.push(gfBG);

					var momDadBG = new FlxSprite(-400, 110);
					momDadBG.frames = Paths.getSparrowAtlas('characters/parents_xmas_soft');
					momDadBG.animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
					momDadBG.antialiasing = true;
					swagBacks['momDadBG'] = momDadBG;
					toAdd.push(momDadBG);

					var softBFBG = new FlxSprite (1594, 440);
					softBFBG.frames = Paths.getSparrowAtlas('characters/softie_crimmus2');
					softBFBG.animation.addByPrefix('idle', 'BF idle dance', 24, false);
					softBFBG.setGraphicSize(Std.int(softBFBG.width * 0.9));
					softBFBG.updateHitbox();
					softBFBG.antialiasing = true;
					swagBacks['softBFBG'] = softBFBG;
					toAdd.push(softBFBG);
				}
			}
			case 'mallEvil' | 'mallAnnie':
			{
				switch (daStage)
				{
					case 'mallEvil':
						pre = 'christmas';
						suf = 'week5';
					case 'mallAnnie':
						pre = 'annie';
						suf = 'week3';
				}

				var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image(pre+'/evilBG', suf));
				bg.antialiasing = FlxG.save.data.antialiasing;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image(pre+'/evilTree', suf));
				evilTree.antialiasing = FlxG.save.data.antialiasing;
				evilTree.scrollFactor.set(0.2, 0.2);
				swagBacks['evilTree'] = evilTree;
				toAdd.push(evilTree);

				var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image(pre+'/evilSnow', suf));
				evilSnow.antialiasing = FlxG.save.data.antialiasing;
				swagBacks['evilSnow'] = evilSnow;
				toAdd.push(evilSnow);
			}

			case 'school':
			{
				var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky', 'week6'));
				bgSky.scrollFactor.set(0.1, 0.1);
				swagBacks['bgSky'] = bgSky;
				toAdd.push(bgSky);

				var repositionShit = -200;

				var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool', 'week6'));
				bgSchool.scrollFactor.set(0.6, 0.90);
				swagBacks['bgSchool'] = bgSchool;
				toAdd.push(bgSchool);

				var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet', 'week6'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				swagBacks['bgStreet'] = bgStreet;
				toAdd.push(bgStreet);

				var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack', 'week6'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				swagBacks['fgTrees'] = fgTrees;
				toAdd.push(fgTrees);

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('weeb/weebTrees', 'week6');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				swagBacks['bgTrees'] = bgTrees;
				toAdd.push(bgTrees);

				var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals', 'week6');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				swagBacks['treeLeaves'] = treeLeaves;
				toAdd.push(treeLeaves);

				var widShit = Std.int(bgSky.width * 6);

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);

				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();

				var bgGirls = new BackgroundGirls(-100, 190);
				bgGirls.scrollFactor.set(0.9, 0.9);

				if (PlayState.SONG.song.toLowerCase() == 'roses')
				{
					bgGirls.getScared();
				}

				bgGirls.setGraphicSize(Std.int(bgGirls.width * PlayState.daPixelZoom));
				bgGirls.updateHitbox();
				swagBacks['bgGirls'] = bgGirls;
				toAdd.push(bgGirls);
			}
			case 'schoolEvil':
			{
				var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
				var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

				var posX = 400;
				var posY = 200;

				var bg:FlxSprite = new FlxSprite(posX, posY);
				bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool', 'week6');
				bg.animation.addByPrefix('idle', 'background 2', 24);
				bg.animation.play('idle');
				bg.scrollFactor.set(0.8, 0.9);
				bg.scale.set(6, 6);
				swagBacks['bg'] = bg;
				toAdd.push(bg);
			}

			case 'tank2':
			{
				camZoom = 0.9;
				
				var tankSky:FlxSprite = new FlxSprite(-400, -400).loadGraphic(Paths.image('tank/tankSky'));
				tankSky.antialiasing = true;
				tankSky.scrollFactor.set(0, 0);
				swagBacks['tankSky'] = tankSky;
				toAdd.push(tankSky);
				
				var tankClouds:FlxSprite = new FlxSprite(-700, -100).loadGraphic(Paths.image('tank/tankClouds'));
				tankClouds.antialiasing = true;
				tankClouds.scrollFactor.set(0.1, 0.1);
				swagBacks['tankClouds'] = tankClouds;
				toAdd.push(tankClouds);
				
				var tankMountains:FlxSprite = new FlxSprite(-300, -20).loadGraphic(Paths.image('tank/tankMountains'));
				tankMountains.antialiasing = true;
				tankMountains.setGraphicSize(Std.int(tankMountains.width * 1.1));
				tankMountains.scrollFactor.set(0.2, 0.2);
				tankMountains.updateHitbox();
				swagBacks['tankMountains'] = tankMountains;
				toAdd.push(tankMountains);
				
				var tankBuildings:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('tank/tankBuildings'));
				tankBuildings.antialiasing = true;
				tankBuildings.setGraphicSize(Std.int(tankBuildings.width * 1.1));
				tankBuildings.scrollFactor.set(0.3, 0.3);
				tankBuildings.updateHitbox();
				swagBacks['tankBuildings'] = tankBuildings;
				toAdd.push(tankBuildings);
				
				var tankRuins:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('tank/tankRuins'));
				tankRuins.antialiasing = true;
				tankRuins.setGraphicSize(Std.int(tankRuins.width * 1.1));
				tankRuins.scrollFactor.set(0.35, 0.35);
				tankRuins.updateHitbox();
				swagBacks['tankRuins'] = tankRuins;
				toAdd.push(tankRuins);

				var smokeLeft:FlxSprite = new FlxSprite(-200, -100).loadGraphic(Paths.image('tank/smokeLeft'));
				smokeLeft.frames = Paths.getSparrowAtlas('tank/smokeLeft');
				smokeLeft.animation.addByPrefix('idle', 'SmokeBlurLeft', 24, true);
				smokeLeft.animation.play('idle');
				smokeLeft.scrollFactor.set (0.4, 0.4);
				smokeLeft.antialiasing = true;
				swagBacks['smokeLeft'] = smokeLeft;
				toAdd.push(smokeLeft);

				var smokeRight:FlxSprite = new FlxSprite(1100, -100).loadGraphic(Paths.image('tank/smokeRight'));
				smokeRight.frames = Paths.getSparrowAtlas('tank/smokeRight');
				smokeRight.animation.addByPrefix('idle', 'SmokeRight', 24, true);
				smokeRight.animation.play('idle');
				smokeRight.scrollFactor.set (0.4, 0.4);
				smokeRight.antialiasing = true;
				swagBacks['smokeRight'] = smokeRight;
				toAdd.push(smokeRight);
				
				var tankWatchtower = new FlxSprite(100, 50);
				tankWatchtower.frames = Paths.getSparrowAtlas('tank/tankWatchtower');
				tankWatchtower.animation.addByPrefix('idle', 'watchtower gradient color', 24, false);
				tankWatchtower.animation.play('idle');
				tankWatchtower.scrollFactor.set(0.5, 0.5);
				tankWatchtower.antialiasing = true;
				swagBacks['tankWatchtower'] = tankWatchtower;
				toAdd.push(tankWatchtower);
				
				var tankGround:FlxSprite = new FlxSprite(-420, -150).loadGraphic(Paths.image('tank/tankGround'));
				tankGround.setGraphicSize(Std.int(tankGround.width * 1.15));
				tankGround.updateHitbox();
				tankGround.antialiasing = true;
				swagBacks['tankGround'] = tankGround;
				toAdd.push(tankGround);

				var tank0 = new FlxSprite(-500, 650);
				tank0.frames = Paths.getSparrowAtlas('tank/tank0');
				tank0.animation.addByPrefix('idle', 'fg tankhead far right', 24, false);
				tank0.scrollFactor.set(1.7, 1.5);
				tank0.antialiasing = true;
				swagBacks['tank0'] = tank0;
				layInFront[2].push(tank0);

				var tank1 = new FlxSprite(-300, 750);
				tank1.frames = Paths.getSparrowAtlas('tank/tank1');
				tank1.animation.addByPrefix('idle', 'fg', 24, false);
				tank1.scrollFactor.set(2, 0.2);
				tank1.antialiasing = true;
				swagBacks['tank1'] = tank1;
				layInFront[2].push(tank1);

				var tank2 = new FlxSprite(450, 940);
				tank2.frames = Paths.getSparrowAtlas('tank/tank2');
				tank2.animation.addByPrefix('idle', 'foreground', 24, false);
				tank2.scrollFactor.set(1.5, 1.5);
				tank2.antialiasing = true;
				swagBacks['tank2'] = tank2;
				layInFront[2].push(tank2);

				var tank4 = new FlxSprite(1300, 900);
				tank4.frames = Paths.getSparrowAtlas('tank/tank4');
				tank4.animation.addByPrefix('idle', 'fg', 24, false);
				tank4.scrollFactor.set(1.5, 1.5);
				tank4.antialiasing = true;
				swagBacks['tank4'] = tank4;
				layInFront[2].push(tank4);

				var tank5 = new FlxSprite(1620, 700);
				tank5.frames = Paths.getSparrowAtlas('tank/tank5');
				tank5.animation.addByPrefix('idle', 'fg', 24, false);
				tank5.scrollFactor.set(1.5, 1.5);
				tank5.antialiasing = true;
				swagBacks['tank5'] = tank5;
				layInFront[2].push(tank5);

				var tank3 = new FlxSprite(1300, 1200);
				tank3.frames = Paths.getSparrowAtlas('tank/tank3');
				tank3.animation.addByPrefix('idle', 'fg', 24, false);
				tank3.scrollFactor.set(1.5, 1.5);
				tank3.antialiasing = true;
				swagBacks['tank3'] = tank3;
				layInFront[2].push(tank3);
			}

			//let's try this shall we?
			case 'night':
			{
				camZoom = 0.75;
				curStage = 'night';

				var theEntireFuckingStage:FlxTypedGroup<FlxSprite>;

				theEntireFuckingStage = new FlxTypedGroup<FlxSprite>();
				swagGroup['theEntireFuckingStage'] = theEntireFuckingStage;
				toAdd.push(theEntireFuckingStage);

				var bg1:FlxSprite = new FlxSprite(-970, -580).loadGraphic(Paths.image('b&b/night/BG1', 'shared'));
				bg1.antialiasing = true;
				bg1.scale.set(0.8, 0.8);
				bg1.scrollFactor.set(0.3, 0.3);
				bg1.active = false;
				theEntireFuckingStage.add(bg1);

				var bg2:FlxSprite = new FlxSprite(-1240, -650).loadGraphic(Paths.image('b&b/night/BG2', 'shared'));
				bg2.antialiasing = true;
				bg2.scale.set(0.5, 0.5);
				bg2.scrollFactor.set(0.6, 0.6);
				bg2.active = false;
				theEntireFuckingStage.add(bg2);

				var bg3:FlxSprite = new FlxSprite(-630, -330).loadGraphic(Paths.image('b&b/night/BG3', 'shared'));
				bg3.antialiasing = true;
				bg3.scale.set(0.8, 0.8);
				bg3.active = false;
				theEntireFuckingStage.add(bg3);

				var bg4:FlxSprite = new FlxSprite(-1390, -740).loadGraphic(Paths.image('b&b/night/BG4', 'shared'));
				bg4.antialiasing = true;
				bg4.scale.set(0.6, 0.6);
				bg4.active = false;
				theEntireFuckingStage.add(bg4);

				var bg5:FlxSprite = new FlxSprite(-34, 90);
				bg5.antialiasing = true;
				bg5.scale.set(1.4, 1.4);
				bg5.frames = Paths.getSparrowAtlas('b&b/night/pixelthing', 'shared');
				bg5.animation.addByPrefix('idle', 'pixelthing', 24);
				bg5.animation.play('idle');
				swagBacks['bg5'] = bg5;
				toAdd.push(bg5);

				var pc = new FlxSprite(115, 166);
				pc.frames = Paths.getSparrowAtlas('characters/pc', 'shared');
				pc.animation.addByPrefix('idle', 'PC idle', 24, false);
				pc.animation.addByPrefix('singUP', 'PC Note UP', 24, false);
				pc.animation.addByPrefix('singDOWN', 'PC Note DOWN', 24, false);
				pc.animation.addByPrefix('singLEFT', 'PC Note LEFT', 24, false);
				pc.animation.addByPrefix('singRIGHT', 'PC Note RIGHT', 24, false);
				swagBacks['pc'] = pc;
				toAdd.push(pc);

				theEntireFuckingStage = new FlxTypedGroup<FlxSprite>();
				swagGroup['theEntireFuckingStage'] = theEntireFuckingStage;
				toAdd.push(theEntireFuckingStage);

				var phillyCityLights = new FlxTypedGroup<FlxSprite>();
				swagGroup['phillyCityLights'] = phillyCityLights;
				toAdd.push(phillyCityLights);

				var coolGlowyLights = new FlxTypedGroup<FlxSprite>();
				swagGroup['coolGlowyLights'] = coolGlowyLights;
				toAdd.push(coolGlowyLights);

				var coolGlowyLightsMirror = new FlxTypedGroup<FlxSprite>();
				swagGroup['coolGlowyLightsMirror'] = coolGlowyLightsMirror;
				toAdd.push(coolGlowyLightsMirror);

				for (i in 0...4)
				{
					var light:FlxSprite = new FlxSprite().loadGraphic(Paths.image('b&b/night/light' + i, 'shared'));
					light.scrollFactor.set(0, 0);
					light.cameras = [PlayState.instance.camHUD];
					light.visible = false;
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
					swagBacks['light' + i] = light;

					var glow:FlxSprite = new FlxSprite().loadGraphic(Paths.image('b&b/night/Glow' + i, 'shared'));
					glow.scrollFactor.set(0, 0);
					glow.cameras = [PlayState.instance.camHUD];
					glow.visible = false;
					glow.updateHitbox();
					glow.antialiasing = true;
					coolGlowyLights.add(glow);
					swagBacks['glow' + i] = glow;

					var glow2:FlxSprite = new FlxSprite().loadGraphic(Paths.image('b&b/night/Glow' + i, 'shared'));
					glow2.scrollFactor.set(0, 0);
					glow2.cameras = [PlayState.instance.camHUD];
					glow2.visible = false;
					glow2.updateHitbox();
					glow2.antialiasing = true;
					coolGlowyLightsMirror.add(glow2);
					swagBacks['glow2' + i] = glow2;
				}

				var areYouReady = new FlxTypedGroup<FlxSprite>();
				swagGroup['areYouReady'] = areYouReady;
				toAdd.push(areYouReady);

				for (i in 0...3) {
					var shit:FlxSprite = new FlxSprite();
					switch (i) {
						case 0:
							shit = new FlxSprite().loadGraphic(Paths.image('b&b/ARE', 'shared'));
						case 1:
							shit = new FlxSprite().loadGraphic(Paths.image('b&b/YOU', 'shared'));
						case 2:
							shit = new FlxSprite().loadGraphic(Paths.image('b&b/READY', 'shared'));
					}
					shit.cameras = [PlayState.instance.camHUD];
					shit.visible = false;
					areYouReady.add(shit);
					swagBacks['shit' + i] = shit;
				} 
			}

			case 'takiStage': 
			{
				camZoom = 0.6;

				var bg:FlxSprite = new FlxSprite(-200, -100).loadGraphic(Paths.image('fever/week2bgtaki'));
				bg.antialiasing = true;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var moreDark = new FlxSprite(0, 0).loadGraphic(Paths.image('fever/effectShit/evenMOREdarkShit'));
				moreDark.cameras = [PlayState.instance.camHUD];
				swagBacks['moreDark'] = moreDark;
				layInFront[2].push(moreDark);
			}

			case 'polus' | 'polus2':
			{
				camZoom = 0.9;

				var sky:FlxSprite = new FlxSprite(-834.3, -620.5).loadGraphic(Paths.image('polus/polusSky'));
				sky.antialiasing = true;
				sky.scrollFactor.set(0.5, 0.5);
				sky.active = false;
				swagBacks['sky'] = sky;
				toAdd.push(sky);	

				var rocks:FlxSprite = new FlxSprite(-915.8, -411.3).loadGraphic(Paths.image('polus/polusrocks'));
				rocks.updateHitbox();
				rocks.antialiasing = true;
				rocks.scrollFactor.set(0.6, 0.6);
				rocks.active = false;
				swagBacks['rocks'] = rocks;
				toAdd.push(rocks);
				
				var hills:FlxSprite = new FlxSprite(-1238.05, -180.55).loadGraphic(Paths.image('polus/polusHills'));
				hills.updateHitbox();
				hills.antialiasing = true;
				hills.scrollFactor.set(0.9, 0.9);
				hills.active = false;
				swagBacks['hills'] = hills;
				toAdd.push(hills);

				var warehouse:FlxSprite = new FlxSprite(-458.35, -315.6).loadGraphic(Paths.image('polus/polusWarehouse'));
				warehouse.updateHitbox();
				warehouse.antialiasing = true;
				warehouse.scrollFactor.set(0.9, 0.9);
				warehouse.active = false;
				swagBacks['warehouse'] = warehouse;
				toAdd.push(warehouse);

				if (daStage == 'polus2')
				{
					var crowd:FlxSprite = new FlxSprite(-280.5, 240.8);
					crowd.frames = Paths.getSparrowAtlas('polus/CrowdBop');
					crowd.animation.addByPrefix('idle', 'CrowdBop', 24, false);
					crowd.animation.play('idle');
					crowd.scrollFactor.set(1, 1);
					crowd.antialiasing = true;
					crowd.updateHitbox();
					crowd.scale.set(1.5, 1.5);
					swagBacks['crowd'] = crowd;
					animatedBacks.push(crowd);
					toAdd.push(crowd);
					
					var deadBF = new FlxSprite(532.95, 465.95).loadGraphic(Paths.image('polus/bfdead'));
					deadBF.antialiasing = true;
					deadBF.scrollFactor.set(1, 1);
					deadBF.updateHitbox();	
					swagBacks['deadBF'] = deadBF;
					layInFront[0].push(deadBF);
				}

				var ground:FlxSprite = new FlxSprite(-580.9, 241.85).loadGraphic(Paths.image('polus/polusGround'));
				ground.updateHitbox();
				ground.antialiasing = true;
				ground.scrollFactor.set(1, 1);
				ground.active = false;
				swagBacks['ground'] = ground;
				toAdd.push(ground);
			}	
			
			case 'space': 
			{
				camZoom = 0.7;

				var spaceBG:FlxSprite = new FlxSprite(-450, -160).loadGraphic(Paths.image('space/spaceBG'));
				spaceBG.setGraphicSize(Std.int(spaceBG.width * 1.5));
				spaceBG.updateHitbox();
				spaceBG.antialiasing = true;
				spaceBG.scrollFactor.set(0.1, 0.1);
				spaceBG.active = false;
				swagBacks['spaceBG'] = spaceBG;
				toAdd.push(spaceBG);

				var holoBoppers = new FlxSprite(-410, -360);
				holoBoppers.frames = Paths.getSparrowAtlas('space/holoBop');
				holoBoppers.animation.addByPrefix('idle', 'Holo Boppers', 24, false);
				holoBoppers.antialiasing = true;
				holoBoppers.scrollFactor.set(0.2, 0.2);
				holoBoppers.setGraphicSize(Std.int(holoBoppers.width * 1.2));
				holoBoppers.updateHitbox();
				swagBacks['holoBoppers'] = holoBoppers;
				animatedBacks.push(holoBoppers);
				toAdd.push(holoBoppers);	
				
				new FlxTimer().start(3.2, function(tmr:FlxTimer)
				{
					if(holoBoppers.y == -330) FlxTween.tween(holoBoppers, {y: -360}, 3.1, 
						{ease: FlxEase.quadInOut});
					else  FlxTween.tween(holoBoppers, {y: -330}, 3.1, 
						{ease: FlxEase.quadInOut});
				}, 0);		

				var spacerocks:FlxSprite = new FlxSprite(-360, -30).loadGraphic(Paths.image('space/spacerocks'));	
				spacerocks.updateHitbox();			
				spacerocks.antialiasing = true;
				spacerocks.scrollFactor.set(0.4, 0.4);
				spacerocks.active = false;
				swagBacks['spacerocks'] = spacerocks;
				toAdd.push(spacerocks);

				new FlxTimer().start(3, function(tmr:FlxTimer)
				{
					if(spacerocks.y == -65) FlxTween.tween(spacerocks, {y: -30}, 2.9, 
						{ease: FlxEase.quadInOut});
					else  FlxTween.tween(spacerocks, {y: -65}, 2.9, 
						{ease: FlxEase.quadInOut});
				}, 0);

				var spacestage:FlxSprite = new FlxSprite(-500, -220).loadGraphic(Paths.image('space/spacestage'));
				spacestage.setGraphicSize(Std.int(spacestage.width * 1.2));
				spacestage.updateHitbox();
				spacestage.antialiasing = true;
				spacestage.active = false;
				swagBacks['spacestage'] = spacestage;
				toAdd.push(spacestage);

				var spacerocksFG:FlxSprite = new FlxSprite(-1620, -160).loadGraphic(Paths.image('space/spacerocksFG'));
				spacerocksFG.setGraphicSize(Std.int(spacerocksFG.width * 1.3));
				spacerocksFG.updateHitbox();			
				spacerocksFG.antialiasing = true;
				spacerocksFG.scrollFactor.set(1.6, 1.6);
				spacerocksFG.active = false;
				swagBacks['spacerocksFG'] = spacerocksFG;
				toAdd.push(spacerocksFG);

				new FlxTimer().start(3, function(tmr:FlxTimer)
				{
					if(spacerocksFG.y == -120) FlxTween.tween(spacerocksFG, {y: -160}, 2.9, 
						{ease: FlxEase.quadInOut});
					else  FlxTween.tween(spacerocksFG, {y: -120}, 2.9, 
						{ease: FlxEase.quadInOut});
				}, 0);
			}

			case 'pillars':
			{
				camZoom = 0.55;

				var white:FlxSprite = new FlxSprite().makeGraphic(FlxG.width * 5, FlxG.height * 5, FlxColor.fromRGB(255, 230, 230));
				white.screenCenter();
				white.scrollFactor.set();
				swagBacks['white'] = white;
				toAdd.push(white);

				var void:FlxSprite = new FlxSprite(0, 0);
				void.frames = Paths.getSparrowAtlas('agoti/the_void');
				void.animation.addByPrefix('move', 'VoidShift', 50, true);
				void.animation.play('move');
				void.setGraphicSize(Std.int(void.width * 2.5));
				void.screenCenter();
				void.y += 250;
				void.x += 55;
				void.antialiasing = true;
				void.scrollFactor.set(0.7, 0.7);
				swagBacks['void'] = void;
				toAdd.push(void);

				var bgpillar:FlxSprite = new FlxSprite(-1000, -700);
				bgpillar.frames = Paths.getSparrowAtlas('agoti/Pillar_BG_Stage');
				bgpillar.animation.addByPrefix('move', 'Pillar_BG', 24, true);
				bgpillar.animation.play('move');
				bgpillar.setGraphicSize(Std.int(bgpillar.width * 1.25));
				bgpillar.antialiasing = true;
				bgpillar.scrollFactor.set(0.7, 0.7);
				swagBacks['bgpillar'] = bgpillar;
				toAdd.push(bgpillar);

				if (PlayState.isNeonight && PlayState.SONG.song.toLowerCase() == 'crucify')
				{
					var rock:FlxSprite = new FlxSprite().loadGraphic(Paths.image('agoti/rock', 'shared'));
					rock.setPosition(600,250);
					rock.scrollFactor.set(0.95, 0.95);
					swagBacks['rock'] = rock;
					toAdd.push(rock);
				}

				var speaker = new FlxSprite(-650, 600);
				speaker.frames = Paths.getSparrowAtlas('agoti/LoudSpeaker_Moving');
				speaker.animation.addByPrefix('bop', 'StereoMoving', 24, false);
				speaker.updateHitbox();
				speaker.antialiasing = true;
				swagBacks['speaker'] = speaker;
				toAdd.push(speaker);
			}

			case 'ITB':
			{
				camZoom = 0.70;

				var bg17:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('b&b/ITB/Layer 5', 'shared'));
				bg17.antialiasing = true;
				bg17.scrollFactor.set(0.3, 0.3);
				bg17.active = false;
				swagBacks['bg17'] = bg17;
				toAdd.push(bg17);

				var bg16:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('b&b/ITB/Layer 4', 'shared'));
				bg16.antialiasing = true;
				bg16.scrollFactor.set(0.4, 0.4);
				bg16.active = false;
				swagBacks['bg16'] = bg16;
				toAdd.push(bg16);

				var bg15:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('b&b/ITB/Layer 3', 'shared'));
				bg15.antialiasing = true;
				bg15.scrollFactor.set(0.6, 0.6);
				bg15.active = false;
				swagBacks['bg15'] = bg15;
				toAdd.push(bg15);

				var bg14:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('b&b/ITB/Layer 2', 'shared'));
				bg14.antialiasing = true;
				bg14.scrollFactor.set(0.7, 0.7);
				bg14.active = false;
				swagBacks['bg14'] = bg14;
				toAdd.push(bg14);

				var bg1:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('b&b/ITB/Layer 1 (back tree)', 'shared'));
				bg1.antialiasing = true;
				bg1.scrollFactor.set(0.7, 0.7);
				bg1.active = false;
				swagBacks['bg1'] = bg1;
				toAdd.push(bg1);

				var bg13:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('b&b/ITB/Layer 1 (Tree)', 'shared'));
				bg13.antialiasing = true;
				bg13.active = false;
				swagBacks['bg13'] = bg13;
				toAdd.push(bg13);

				var bg4:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('b&b/ITB/Layer 1 (flower and grass)', 'shared'));
				bg4.antialiasing = true;
				bg4.active = false;
				swagBacks['bg4'] = bg4;
				toAdd.push(bg4);

				var phillyCityLights = new FlxTypedGroup<FlxSprite>();
				swagGroup['phillyCityLights'] = phillyCityLights;
				toAdd.push(phillyCityLights);

				var bg9:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('b&b/ITB/layer 1 (light 1)', 'shared'));
				bg9.antialiasing = true;
				bg9.scrollFactor.set(0.8, 0.8);
				bg9.alpha = 0;
				bg9.active = false;
				phillyCityLights.add(bg9);
				swagBacks['bg9'] = bg9;

				var bg10:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('b&b/ITB/Layer 1 (Light 2)', 'shared'));
				bg10.antialiasing = true;
				bg10.scrollFactor.set(0.8, 0.8);
				bg10.alpha = 0;
				bg10.active = false;
				phillyCityLights.add(bg10);
				swagBacks['bg10'] = bg10;

				var bg5:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('b&b/ITB/Layer 1 (Grass 2)', 'shared'));
				bg5.antialiasing = true;
				bg5.active = false;
				swagBacks['bg5'] = bg5;
				toAdd.push(bg5);

				var bg8:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('b&b/ITB/Layer 1 (Lamp)', 'shared'));
				bg8.antialiasing = true;
				bg8.active = false;
				swagBacks['bg8'] = bg8;
				layInFront[0].push(bg8);

				var bg6:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('b&b/ITB/Layer 1 (Grass)', 'shared'));
				bg6.antialiasing = true;
				bg6.active = false;
				swagBacks['bg6'] = bg6;
				layInFront[0].push(bg6);

				var bg7:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('b&b/ITB/Layer 1 (Ground)', 'shared'));
				bg7.antialiasing = true;
				bg7.active = false;
				swagBacks['bg7'] = bg7;
				layInFront[0].push(bg7);
			}
				

			case 'neopolis':
			{
				camZoom = 1.05;

				var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSkyNeon'));
				bgSky.scrollFactor.set(0.1, 0.1);
				swagBacks['bgSky'] = bgSky;
				toAdd.push(bgSky);

				var repositionShit = -200;

				var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreetNeon'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				swagBacks['bgStreet'] = bgStreet;
				toAdd.push(bgStreet);

				var widShit = Std.int(bgSky.width * 6);

				bgSky.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);

				bgSky.updateHitbox();
				bgStreet.updateHitbox();
			}

			case 'school-monika-finale':
			{
				camZoom = 0.9;

				var posX = 50;
				var posY = 200;

				var space = new FlxBackdrop(Paths.image('monika/FinaleBG_1'));
				space.velocity.set(-10, 0);
				space.antialiasing = false;
				space.scrollFactor.set(0.1, 0.1);
				space.scale.set(1.65, 1.65);
				swagBacks['space'] = space;
				toAdd.push(space);

				var bg2 = new FlxSprite(70, posY).loadGraphic(Paths.image('monika/FinaleBG_2'));
				bg2.antialiasing = false;
				bg2.scale.set(2.3, 2.3);
				bg2.scrollFactor.set(0.4, 0.6);
				swagBacks['bg2'] = bg2;
				toAdd.push(bg2);

				var stageFront2 = new FlxSprite(posX, posY).loadGraphic(Paths.image('monika/FinaleFG'));
				stageFront2.antialiasing = false;
				stageFront2.scale.set(1.5, 1.5);
				stageFront2.scrollFactor.set(1, 1);
				swagBacks['stageFront2'] = stageFront2;
				toAdd.push(stageFront2);
			}

			case 'cg5stage':
			{
				camZoom = 0.9;

				var bg = new FlxSprite(-535, -166).loadGraphic(Paths.image('cg5/mixroom', 'week1'));
				bg.antialiasing = true;
				bg.setGraphicSize(Std.int(bg.width * 0.9));
				bg.updateHitbox();
				bg.scrollFactor.set(1, 0.9);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var stageFront = new FlxSprite(-507, -117).loadGraphic(Paths.image('cg5/recordroom', 'week1'));
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(1, 0.9);
				stageFront.active = false;
				stageFront.setGraphicSize(Std.int(stageFront.width * 0.9));
				stageFront.updateHitbox();
				swagBacks['stageFront'] = stageFront;
				layInFront[0].push(stageFront);

				var stageFront2 = new FlxSprite(-507, -117).loadGraphic(Paths.image('cg5/room_lights', 'week1'));
				stageFront2.antialiasing = true;
				stageFront2.scrollFactor.set(1, 0.9);
				stageFront2.active = false;
				stageFront2.setGraphicSize(Std.int(stageFront2.width * 0.9));
				stageFront2.updateHitbox();
				swagBacks['stageFront2'] = stageFront2;
				layInFront[0].push(stageFront2);
			}

			case 'sunshine' | 'withered':
			{
				camZoom = 1.05;
				switch (daStage)
				{
					case 'sunshine': pre = 'happy';
					case 'withered': pre = 'slightlyannoyed_';				
				}

				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('bob/'+pre+'sky'));
				bg.updateHitbox();
				bg.active = false;
				bg.antialiasing = true;
				bg.scrollFactor.set(0.1, 0.1);
				swagBacks['bg'] = bg;
				toAdd.push(bg);
				
				var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(Paths.image('bob/'+pre+'ground'));
				ground.updateHitbox();
				ground.active = false;
				ground.antialiasing = true;
				swagBacks['ground'] = ground;
				toAdd.push(ground);
			}

			case 'hungryhippo' | 'hungryhippo-blantad':
			{		
				camZoom = 0.6;

				if (daStage == 'hungryhippo-blantad'){
					suf = '_blantad';
				}
				var bg = new FlxSprite(-800, -600).loadGraphic(Paths.image('rebecca/hungryhippo_bg'+suf));
		
				bg.scrollFactor.set(1.0, 1.0);
				swagBacks['bg'] = bg;
				toAdd.push(bg);
			}

			case 'alleysoft':
			{
				camZoom = 0.8;
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('soft/alleybg'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var stageFront:FlxSprite = new FlxSprite(-630,-200).loadGraphic(Paths.image('soft/alleyfloor'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(1, 1);
				stageFront.active = false;
				swagBacks['stageFront'] = stageFront;
				toAdd.push(stageFront);
				
				var stageCurtains:FlxSprite = new FlxSprite(-200, -100).loadGraphic(Paths.image('soft/alleycat'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
				swagBacks['stageCurtains'] = stageCurtains;
				toAdd.push(stageCurtains);
			}

			case 'gamer':
			{
				camZoom = 0.9;

				var bg:FlxSprite = new FlxSprite(-1130, -380).loadGraphic(Paths.image('liz/bgamser'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var stageFront:FlxSprite = new FlxSprite(-730, -2012).loadGraphic(Paths.image('liz/bgMain'));
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				swagBacks['stageFront'] = stageFront;
				toAdd.push(stageFront);

				var zero16 = new FlxSprite(-387, 173);
				zero16.frames = Paths.getSparrowAtlas("liz/016_Assets");
				zero16.animation.addByPrefix('idle', "016 idle", 24, false);
				swagBacks['zero16'] = zero16;
				animatedBacks.push(zero16);
				toAdd.push(zero16);	
			}

			case 'street1':
			{
				camZoom = 0.9;

				var bg = new FlxSprite(-500, -200).loadGraphic(Paths.image('street1'));
				bg.setGraphicSize(Std.int(bg.width * 0.9));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;		
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				if (PlayState.SONG.song.toLowerCase() == 'happy')
				{
					PlayState.daJumpscare.frames = Paths.getSparrowAtlas('exe/sonicJUMPSCARE1930');
				}
			}	

			case 'zardymaze':
			{
				camZoom = 0.9;

				var zardyBackground = new FlxSprite(-600, -200);
				zardyBackground.frames = Paths.getSparrowAtlas('zardy/Maze', 'shared');
				zardyBackground.animation.addByPrefix('Maze','Stage', 16);
				zardyBackground.antialiasing = true;
				zardyBackground.scrollFactor.set(0.9, 0.9);
				zardyBackground.animation.play('Maze');
				swagBacks['zardyBackground'] = zardyBackground;
				toAdd.push(zardyBackground);
			}

			case 'FMMstage' | 'FMMstagedusk' | 'FMMstagenight':
			{
				var time:String = '';

				camZoom = 0.6;
				curStage = 'FMMstage';

				switch (daStage)
				{
					case 'FMMstage':
						time = 'Day';
					case 'FMMstagedusk':
						time = 'Dusk';
					case 'FMMstagenight':
						time = 'Night';
				}
				var bg:FlxSprite = new FlxSprite(-1000, -350).loadGraphic(Paths.image('FMMStage/FMM'+time+'BG'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var FMMBuildings:FlxSprite = new FlxSprite(-1290, -380).loadGraphic(Paths.image('FMMStage/FMM'+time+'Buildings'));
				FMMBuildings.setGraphicSize(Std.int(FMMBuildings.width * 1.1));
				FMMBuildings.updateHitbox();
				FMMBuildings.antialiasing = true;
				FMMBuildings.scrollFactor.set(0.7, 0.7);
				FMMBuildings.active = false;
				swagBacks['FMMBuildings'] = FMMBuildings;
				toAdd.push(FMMBuildings);

				var FMMRail:FlxSprite = new FlxSprite(-1290, -490).loadGraphic(Paths.image('FMMStage/FMM'+time+'Rail'));
				FMMRail.setGraphicSize(Std.int(FMMRail.width * 1.1));
				FMMRail.updateHitbox();
				FMMRail.antialiasing = true;
				FMMRail.scrollFactor.set(0.8, 0.8);
				FMMRail.active = false;
				swagBacks['FMMRail'] = FMMRail;
				toAdd.push(FMMRail);

				var FMMFront:FlxSprite = new FlxSprite(-1290, -475).loadGraphic(Paths.image('FMMStage/FMM'+time+'Front'));
				FMMFront.setGraphicSize(Std.int(FMMFront.width * 1.1));
				FMMFront.updateHitbox();
				FMMFront.antialiasing = true;
				FMMFront.scrollFactor.set(0.9, 0.9);
				FMMFront.active = false;
				swagBacks['FMMFront'] = FMMFront;
				toAdd.push(FMMFront);
			}

			case 'emptystage2':
			{
				camZoom = 0.0;
			
				var bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('emptystageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);
			}

			case 'sunkStage':
			{
				camZoom = 0.9;
			
				var bg = new FlxSprite(-400, 0).loadGraphic(Paths.image('exe/SunkBG'));
				bg.antialiasing = true;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				bg.scrollFactor.set(0.95, 0.95);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);
			}

			case 'mind':
            {
        		camZoom = 0.8;
				curStage = 'mind';

				var bg:FlxSprite = new FlxSprite(-600, -145).loadGraphic(Paths.image('corruption/tormentor/TormentorBG'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);	

				var funnytv:FlxSprite = new FlxSprite(120, 145);
				funnytv.frames = Paths.getSparrowAtlas('corruption/tormentor/TormentorStatic');
				funnytv.animation.addByPrefix('idle', 'Tormentor Static', 24);
				funnytv.animation.play('idle');
				funnytv.scrollFactor.set(0.9, 0.9);
				funnytv.setGraphicSize(Std.int(funnytv.width * 1.3));
				swagBacks['funnytv'] = funnytv;
				toAdd.push(funnytv);	
            }

			case 'mind2':
            {
        		camZoom = 0.8;

				var wBg = new FlxSprite(-600, -145).loadGraphic(Paths.image('corruption/tormentor/shit'));
				wBg.updateHitbox();
				wBg.antialiasing = true;
				wBg.scrollFactor.set(0.9, 0.9);
				wBg.active = false;
				swagBacks['wBg'] = wBg;
				toAdd.push(wBg);

				var bg2 = new FlxSprite(-600, -145).loadGraphic(Paths.image('corruption/tormentor/fuck'));
				bg2.updateHitbox();
				bg2.antialiasing = true;
				bg2.scrollFactor.set(0.9, 0.9);
				bg2.active = false;
				swagBacks['bg2'] = bg2;
				toAdd.push(bg2);

				var bg = new FlxSprite(-600, -145).loadGraphic(Paths.image('corruption/tormentor/TormentorBG'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);	

				var funnytv = new FlxSprite(120, 145);
				funnytv.frames = Paths.getSparrowAtlas('corruption/tormentor/TormentorStatic');
				funnytv.animation.addByPrefix('idle', 'Tormentor Static', 24);
				funnytv.animation.play('idle');
				funnytv.scrollFactor.set(0.9, 0.9);
				funnytv.setGraphicSize(Std.int(funnytv.width * 1.3));
				swagBacks['funnytv'] = funnytv;
				toAdd.push(funnytv);	
            }

			case 'momiStage':
			{
				camZoom = 0.9;

				var bg:FlxSprite = new FlxSprite(-175.3, -225.95).loadGraphic(Paths.image('momi/bg'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 1);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);	
				FlxG.sound.cache(Paths.sound("carPass1"));
					
				var dust = new FlxSprite( -238.3, 371.55);
				dust.frames = Paths.getSparrowAtlas("momi/dust");
				dust.animation.addByPrefix("bop", "dust", 24, false);
				dust.scrollFactor.set(1.2, 1.2);
				dust.visible = false;
				dust.animation.play("bop");
				swagBacks['dust'] = dust;
				layInFront[2].push(dust);	
					
				var car = new FlxSprite( -1514.4, 199.8);
				car.scrollFactor.set(1.2,1.2);
				car.frames = Paths.getSparrowAtlas("momi/car");
				car.animation.addByPrefix("go", "car", 24, false);
				car.visible = true;
				car.animation.play("go");
				swagBacks['car'] = car;
				layInFront[2].push(car);
				if(PlayState.SONG.song.toLowerCase() == "gura-nazel")dust.visible = true;
			}

			case 'studio':
			{
				camZoom = 0.9;

				var speakerScale:Float = 0.845;

				var bg_back:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('studio/studio_evenfurtherback'));
				bg_back.setGraphicSize(Std.int(bg_back.width * 0.845));
				bg_back.screenCenter();
				bg_back.antialiasing = true;
				bg_back.scrollFactor.set(0.85, 0.85);
				bg_back.active = false;
				bg_back.x += 32;
				swagBacks['bg_back'] = bg_back;
				toAdd.push(bg_back);	

				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('studio/studio_back'));
				bg.setGraphicSize(Std.int(bg.width * 0.845));
				bg.screenCenter();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);	

				var cy_spk1 = new FlxSprite(0, 0);
				cy_spk1.frames = Paths.getSparrowAtlas("studio/studio_speaker");
				cy_spk1.animation.addByPrefix('idle', 'speaker', 24);
				cy_spk1.animation.play('idle');
				cy_spk1.antialiasing = true;
				cy_spk1.scale.x = speakerScale;
				cy_spk1.scale.y = speakerScale;
				cy_spk1.screenCenter();
				cy_spk1.scrollFactor.set(0.9, 0.9);
				cy_spk1.x += -672;
				cy_spk1.y += -32;
				swagBacks['cy_spk1'] = cy_spk1;
				animatedBacks.push(cy_spk1);
				toAdd.push(cy_spk1);	

				var cy_spk2 = new FlxSprite(0, 0);
				cy_spk2.frames = Paths.getSparrowAtlas("studio/studio_speaker");
				cy_spk2.animation.addByPrefix('idle', 'speaker', 24);
				cy_spk2.animation.play('idle');
				cy_spk2.antialiasing = true;
				cy_spk2.scale.x = speakerScale;
				cy_spk2.scale.y = speakerScale;
				cy_spk2.screenCenter();
				cy_spk2.scrollFactor.set(0.9, 0.9);
				cy_spk2.x += 640;
				cy_spk2.y += -32;
				cy_spk2.flipX = true;
				swagBacks['cy_spk2'] = cy_spk2;
				animatedBacks.push(cy_spk2);
				toAdd.push(cy_spk2);	

				var bg_fx:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('studio/studio_fx'));
				bg_fx.setGraphicSize(Std.int(bg.width * 0.845));
				bg_fx.screenCenter();
				bg_fx.antialiasing = true;
				bg_fx.scrollFactor.set(0.9, 0.9);
				bg_fx.active = false;
				swagBacks['bg_fx'] = bg_fx;
				toAdd.push(bg_fx);	
			}

			case 'studio-crash':
			{
				camZoom = 0.9;

				var cy_crash = new FlxSprite(0, 0);
				cy_crash.frames = Paths.getSparrowAtlas("studio/crash_back");
				cy_crash.animation.addByPrefix('code', 'code', 24, true);
				cy_crash.antialiasing = true;
				cy_crash.setGraphicSize(Std.int(cy_crash.width * 1.75));
				cy_crash.screenCenter();
				cy_crash.antialiasing = true;
				cy_crash.scrollFactor.set(0.85, 0.85);
				cy_crash.x += 32;
				cy_crash.y += 80;
				cy_crash.animation.play('code');
				swagBacks['cy_crash'] = cy_crash;
				toAdd.push(cy_crash);
			}	
			
			case 'ron':
			{
				camZoom = 0.9;

				var bg:FlxSprite = new FlxSprite(-100,10).loadGraphic(Paths.image('bob/happyRon_sky'));
				bg.updateHitbox();
				bg.scale.x = 1.2;
				bg.scale.y = 1.2;
				bg.active = false;
				bg.antialiasing = true;
				bg.scrollFactor.set(0.1, 0.1);
				swagBacks['bg'] = bg;
				toAdd.push(bg);	

				var ground:FlxSprite = new FlxSprite(-537, -250).loadGraphic(Paths.image('bob/happyRon_ground'));
				ground.updateHitbox();
				ground.active = false;
				ground.antialiasing = true;
				swagBacks['ground'] = ground;
				toAdd.push(ground);	
			}

			case 'kbStreet': 
			{
				camZoom = 0.8125;

				//Back Layer - Normal
				var streetBG = new FlxSprite(-750, -145).loadGraphic(Paths.image('qt/streetBack'));
				streetBG.antialiasing = true;
				streetBG.scrollFactor.set(0.9, 0.9);
				swagBacks['streetBG'] = streetBG;
				toAdd.push(streetBG);	

				//Front Layer - Normal
				var streetFront:FlxSprite = new FlxSprite(-820, 710).loadGraphic(Paths.image('qt/streetFront'));
				streetFront.setGraphicSize(Std.int(streetFront.width * 1.15));
				streetFront.updateHitbox();
				streetFront.antialiasing = true;
				streetFront.scrollFactor.set(0.9, 0.9);
				streetFront.active = false;
				swagBacks['streetFront'] = streetFront;
				toAdd.push(streetFront);	

				var qt_tv01 = new FlxSprite(-62, 540);
				qt_tv01.frames = Paths.getSparrowAtlas('qt/TV_V5');
				qt_tv01.animation.addByPrefix('idle', 'TV_Idle', 24, true);
				qt_tv01.animation.addByPrefix('eye', 'TV_brutality', 24, true); //Replaced the hex eye with the brutality symbols for more accurate lore.
				qt_tv01.animation.addByPrefix('error', 'TV_Error', 24, true);	
				qt_tv01.animation.addByPrefix('404', 'TV_Bluescreen', 24, true);		
				qt_tv01.animation.addByPrefix('alert', 'TV_Attention', 32, false);		
				qt_tv01.animation.addByPrefix('watch', 'TV_Watchout', 24, true);
				qt_tv01.animation.addByPrefix('drop', 'TV_Drop', 24, true);
				qt_tv01.animation.addByPrefix('sus', 'TV_sus', 24, true);
				qt_tv01.setGraphicSize(Std.int(qt_tv01.width * 1.2));
				qt_tv01.updateHitbox();
				qt_tv01.antialiasing = true;
				qt_tv01.scrollFactor.set(0.89, 0.89);
				qt_tv01.animation.play('idle');
				swagBacks['qt_tv01'] = qt_tv01;
				toAdd.push(qt_tv01);	
			
				var qt_gas01 = new FlxSprite();
				qt_gas01.frames = Paths.getSparrowAtlas('qt/Gas_Release');
				qt_gas01.animation.addByPrefix('burst', 'Gas_Release', 38, false);	
				qt_gas01.animation.addByPrefix('burstALT', 'Gas_Release', 49, false);
				qt_gas01.animation.addByPrefix('burstFAST', 'Gas_Release', 76, false);	
				qt_gas01.setGraphicSize(Std.int(qt_gas01.width * 2.5));	
				qt_gas01.antialiasing = true;
				qt_gas01.scrollFactor.set();
				qt_gas01.alpha = 0.72;
				qt_gas01.setPosition(-180,250);
				qt_gas01.angle = -31;	
				swagBacks['qt_gas01'] = qt_gas01;
				layInFront[2].push(qt_gas01);			

				var qt_gas02 = new FlxSprite();
				qt_gas02.frames = Paths.getSparrowAtlas('qt/Gas_Release');
				qt_gas02.animation.addByPrefix('burst', 'Gas_Release', 38, false);	
				qt_gas02.animation.addByPrefix('burstALT', 'Gas_Release', 49, false);
				qt_gas02.animation.addByPrefix('burstFAST', 'Gas_Release', 76, false);	
				qt_gas02.setGraphicSize(Std.int(qt_gas02.width * 2.5));
				qt_gas02.antialiasing = true;
				qt_gas02.scrollFactor.set();
				qt_gas02.alpha = 0.72;
				qt_gas02.setPosition(1320,250);
				qt_gas02.angle = 31;
				swagBacks['qt_gas02'] = qt_gas02;
				layInFront[2].push(qt_gas02);
			}

			case 'room-space': 
			{
                camZoom = 0.8;
				
				var space:FlxSprite = new FlxSprite(-800, -370).loadGraphic(Paths.image('nonsense/Outside_Space'));
				space.setGraphicSize(Std.int(space.width * 0.8));
				space.antialiasing = true;
				space.scrollFactor.set(0.8, 0.8);
				space.active = false;
				swagBacks['space'] = space;
				toAdd.push(space);	
				
				var spaceTex = Paths.getSparrowAtlas('nonsense/BACKGROUND_space');

				var NHroom = new FlxSprite( -800, -370);
				NHroom.frames = spaceTex;
				NHroom.animation.addByPrefix('space', 'Wall Broken anim', 24, true);
				NHroom.animation.play('space');
				NHroom.setGraphicSize(Std.int(NHroom.width * 0.9));
				NHroom.antialiasing = true;
				swagBacks['NHroom'] = NHroom;
				toAdd.push(NHroom);
			}

			case 'melonfarm': 
			{
				var bg:FlxSprite = new FlxSprite(-90, -20).loadGraphic(Paths.image('fever/melonfarm/sky'));
				bg.scrollFactor.set(0.1, 0.1);
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var city:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('fever/melonfarm/bg'));
				swagBacks['city'] = city;
				toAdd.push(city);	

				var street:FlxSprite = new FlxSprite(-70).loadGraphic(Paths.image('fever/melonfarm/street'));
				swagBacks['street'] = street;
				toAdd.push(street);	
			}

			case 'manifest':
			{
				camZoom = 0.9;

				var manifestBG = new FlxSprite(-388, -232);
				manifestBG.frames = Paths.getSparrowAtlas('sky/bg_manifest');
				manifestBG.animation.addByPrefix('idle', 'bg_manifest0', 24, false);
				manifestBG.animation.addByPrefix('noflash', 'bg_noflash0', 24, false);		
				manifestBG.scrollFactor.set(0.4, 0.4);
				manifestBG.antialiasing = true;
				manifestBG.animation.play('noflash');
				swagBacks['manifestBG'] = manifestBG;
				toAdd.push(manifestBG);	

				var manifestFloor = new FlxSprite(-1053, -465);
				manifestFloor.frames = Paths.getSparrowAtlas('sky/floorManifest');
				manifestFloor.animation.addByPrefix('idle', 'floorManifest0', 24, false);
				manifestFloor.animation.addByPrefix('noflash', 'floornoflash0', 24, false);
				manifestFloor.antialiasing = true;
				manifestFloor.animation.play('noflash');
				manifestBG.scrollFactor.set(0.9, 0.9);
				swagBacks['manifestFloor'] = manifestFloor;
				toAdd.push(manifestFloor);	

				if (PlayState.SONG.song.toLowerCase() == 'manifest' && PlayState.isBETADCIU)
				{
					var gfCrazyBG = new FlxSprite(-300, 120);
					gfCrazyBG.frames = Paths.getSparrowAtlas('characters/crazyGF');
					gfCrazyBG.animation.addByPrefix('idle', 'gf Idle Dance', 24, false);
					gfCrazyBG.antialiasing = true;
					gfCrazyBG.setGraphicSize(Std.int(gfCrazyBG.width * 1.1));
					gfCrazyBG.updateHitbox();
					gfCrazyBG.scrollFactor.set(0.9, 0.9);
					gfCrazyBG.flipX = true;
					swagBacks['gfCrazyBG'] = gfCrazyBG;
					toAdd.push(gfCrazyBG);	
				}
			}

			case 'skybroke':
			{
				camZoom = 0.9;

				var manifestBG = new FlxSprite(-388, -232);
				manifestBG.frames = Paths.getSparrowAtlas('sky/bg_annoyed');
				manifestBG.animation.addByPrefix('idle', 'bg2', 24, false);
				manifestBG.animation.addByIndices('noflash', "bg2", [5], "", 24, false);
				manifestBG.scrollFactor.set(0.4, 0.4);
				manifestBG.antialiasing = true;
				manifestBG.animation.play('noflash');
				swagBacks['manifestBG'] = manifestBG;
				toAdd.push(manifestBG);	

				var manifestHole = new FlxSprite (160, -70);
				manifestHole.frames = Paths.getSparrowAtlas('sky/manifesthole');
				manifestHole.animation.addByPrefix('idle', 'manifest hole', 24, false);
				manifestHole.animation.addByIndices('noflash', "manifest hole", [5], "", 24, false);
				manifestHole.scrollFactor.set(0.7, 1);
				manifestHole.setGraphicSize(Std.int(manifestHole.width * 0.9));
				manifestHole.updateHitbox();
				manifestHole.animation.play('noflash');
				manifestHole.antialiasing = true;
				swagBacks['manifestHole'] = manifestHole;
				toAdd.push(manifestHole);				
			}

			case 'churchselever' | 'churchsarv' | 'churchruv' | 'churchsarvdark':
			{
				camZoom = 0.71;

				curStage = daStage;
				if (daStage == 'churchsarvdark')
				{
					curStage = 'churchsarv';
				}
				
				var floor:FlxSprite = new FlxSprite(-660, -1060).loadGraphic(Paths.image('sacredmass/'+curStage+'/floor'));
				floor.setGraphicSize(Std.int(floor.width * 1.3));
				floor.updateHitbox();
				floor.antialiasing = true;
				floor.scrollFactor.set(0.9, 0.9);
				floor.active = false;
				swagBacks['floor'] = floor;
				toAdd.push(floor);	

				var bg = new FlxSprite(-660, -1060).loadGraphic(Paths.image('sacredmass/'+curStage+'/bg'));
				bg.setGraphicSize(Std.int(bg.width * 1.3));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);	

				var pillars:FlxSprite = new FlxSprite(-660, -1060).loadGraphic(Paths.image('sacredmass/'+curStage+'/pillars'));
				pillars.setGraphicSize(Std.int(pillars.width * 1.3));
				pillars.updateHitbox();
				pillars.antialiasing = true;
				pillars.scrollFactor.set(0.9, 0.9);
				pillars.active = false;
				swagBacks['pillars'] = pillars;
				toAdd.push(pillars);	

				if (daStage == 'churchruv')
				{
					var pillarbroke = new FlxSprite(-660, -1060).loadGraphic(Paths.image('sacredmass/churchruv/pillarbroke'));
					pillarbroke.setGraphicSize(Std.int(pillarbroke.width * 1.3));
					pillarbroke.updateHitbox();
					pillarbroke.antialiasing = true;
					pillarbroke.scrollFactor.set(0.9, 0.9);
					pillarbroke.active = false;
					swagBacks['pillarbroke'] = pillarbroke;
					layInFront[0].push(pillarbroke);
				}

				if (daStage == 'churchsarv' && (PlayState.SONG.song.contains('Worship') || PlayState.SONG.song.toLowerCase() == 'lament') || daStage == 'churchsarvdark')
				{
					pillars.color = 0xFFD6ABBF;
					floor.color = 0xFFD6ABBF;
					bg.color = 0xFFD6ABBF;
				}
			}

			case 'destroyedpaper':
			{		
				camZoom = 0.75;

				var bg:FlxSprite = new FlxSprite(-230, -95);
				bg.frames = Paths.getSparrowAtlas('Sketchy/destroyedpaperjig');
				bg.animation.addByPrefix('idle', 'DestroyedPaper', 24);
				bg.setGraphicSize(Std.int(bg.width * 0.5));
				bg.animation.play('idle');
				bg.scrollFactor.set(0.8, 1.0);
				bg.scale.set(2.3, 2.3);
				bg.antialiasing = true;
				swagBacks['bg'] = bg;
				toAdd.push(bg);	

				var rips:FlxSprite = new FlxSprite(-230, -95);
				rips.frames = Paths.getSparrowAtlas('Sketchy/PaperRips');
				rips.animation.addByPrefix('idle', 'Ripping Graphic', 24);
				rips.setGraphicSize(Std.int(rips.width * 0.5));
				rips.animation.play('idle');
				rips.scrollFactor.set(1.0, 1.0);
				rips.scale.set(2.0, 2.0);
				rips.antialiasing = true;
				swagBacks['rips'] = rips;
				toAdd.push(rips);	
			}

			case 'neko-bedroom':
			{
				camZoom = 0.7;
				curStage = 'bed-room';
				var BedRoom = new FlxSprite(-600, -200).loadGraphic(Paths.image('neko/bg_bedroom', 'shared'));
				BedRoom.antialiasing = true;
				BedRoom.scrollFactor.set(0.97, 0.97);
				BedRoom.active = false;
				swagBacks['BedRoom'] = BedRoom;
				toAdd.push(BedRoom);	
			}

			case 'garStage' | 'eddhouse2':
			{
				camZoom = 0.9;

				switch (daStage)
				{
					case 'garStage': pre = 'garcello';
					case 'eddhouse2': pre = 'tord';
				}

				var bg = new FlxSprite(-500, -170).loadGraphic(Paths.image(pre+'/garStagebg'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);	

				var stageFront:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image(pre+'/garStage'));
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				swagBacks['stageFront'] = stageFront;
				toAdd.push(stageFront);	
			}

			case 'arcade4':
			{
				camZoom = 0.9;

				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('kapi/closed'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);	

				var bottomBoppers = new FlxSprite(-600, -200);
				bottomBoppers.frames = Paths.getSparrowAtlas('kapi/bgFreaks');
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.92, 0.92);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				swagBacks['bottomBoppers'] = bottomBoppers;
				toAdd.push(bottomBoppers);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('kapi/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				swagBacks['stageFront'] = stageFront;
				toAdd.push(stageFront);

				var phillyCityLights = new FlxTypedGroup<FlxSprite>();
				swagGroup['phillyCityLights'] = phillyCityLights;
				toAdd.push(phillyCityLights);

				for (i in 0...4)
				{
					var light:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('kapi/win' + i));
					light.scrollFactor.set(0.9, 0.9);
					light.visible = false;
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
					swagBacks['light' + i] = light;		
				}

				var upperBoppers = new FlxSprite(-600, -200);
				upperBoppers.frames = Paths.getSparrowAtlas('kapi/upperBop');
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(1.05, 1.05);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 1));
				upperBoppers.updateHitbox();
				swagBacks['upperBoppers'] = upperBoppers;
				toAdd.push(upperBoppers);
			}	
			case 'stadium':
			{
				camZoom = 0.575;

				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('b3/stadium'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var upperBoppers = new FlxSprite(-600, -255);
				upperBoppers.frames = Paths.getSparrowAtlas('b3/mia_boppers');
				upperBoppers.animation.addByPrefix('idle', "Back Crowd Bop", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(1, 1);
				upperBoppers.updateHitbox();
				upperBoppers.animation.play('idle');
				swagBacks['upperBoppers'] = upperBoppers;
				toAdd.push(upperBoppers);
				animatedBacks.push(upperBoppers);

				var bottomBoppers = new FlxSprite(-600, -266);
				bottomBoppers.frames = Paths.getSparrowAtlas('b3/mia_boppers');
				bottomBoppers.animation.addByPrefix('idle', "Front Crowd Bop", 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(1, 1);
				bottomBoppers.updateHitbox();
				bottomBoppers.animation.play('idle');
				swagBacks['bottomBoppers'] = bottomBoppers;
				toAdd.push(bottomBoppers);
				animatedBacks.push(bottomBoppers);

				var lights:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('b3/lights'));
				lights.antialiasing = true;
				lights.scrollFactor.set(1, 1);
				lights.active = false;
				swagBacks['lights'] = lights;
				layInFront[2].push(lights);
			}
			case 'throne':
			{		
				camZoom = 0.69;

				var bg = new FlxSprite(-550, -243).loadGraphic(Paths.image('anchor/watah'));
				bg.scrollFactor.set(0.1, 0.1);
				bg.setGraphicSize(Std.int(bg.width * 1.5));
				bg.updateHitbox();
				bg.antialiasing = true;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var bg2 = new FlxSprite(-1271, -724).loadGraphic(Paths.image('anchor/throne'));
				bg2.scrollFactor.set(0.9, 0.9);
				bg2.setGraphicSize(Std.int(bg2.width * 1.95));
				bg2.updateHitbox();
				bg2.antialiasing = true;
				swagBacks['bg2'] = bg2;
				toAdd.push(bg2);

				var bottomBoppers = new FlxSprite(-564, 2);
				bottomBoppers.frames = Paths.getSparrowAtlas('anchor/feesh3');
				bottomBoppers.animation.addByPrefix('idle', 'ikan', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 0.95));
				bottomBoppers.updateHitbox();
				swagBacks['bottomBoppers'] = bottomBoppers;
				toAdd.push(bottomBoppers);
				animatedBacks.push(bottomBoppers);
						
				var bgcrowd = new FlxSprite(-1020, 460);
				bgcrowd.frames = Paths.getSparrowAtlas('anchor/front');
				bgcrowd.animation.addByPrefix('idle', 'ikan', 24, false);
				bgcrowd.antialiasing = true;
				bgcrowd.setGraphicSize(Std.int(bgcrowd.width * 1.2));
				bgcrowd.updateHitbox();
				swagBacks['bgcrowd'] = bgcrowd;
				layInFront[2].push(bgcrowd);
				animatedBacks.push(bgcrowd);
			}

			case 'prologue':
			{
				camZoom = 0.9;

				var bg:FlxSprite = new FlxSprite(-100, -100).loadGraphic(Paths.image('prologue/rooftopsky'));
				bg.scrollFactor.set(0.1, 0.1);
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('prologue/distantcity'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				swagBacks['city'] = city;
				toAdd.push(city);

				var phillyCityLights = new FlxTypedGroup<FlxSprite>();
				swagGroup['phillyCityLights'] = phillyCityLights;
				toAdd.push(phillyCityLights);

				for (i in 0...5)
				{
						var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('prologue/win' + i));
						light.scrollFactor.set(0.3, 0.3);
						light.visible = false;
						light.setGraphicSize(Std.int(light.width * 0.85));
						light.updateHitbox();
						light.antialiasing = true;
						phillyCityLights.add(light);
						swagBacks['light' + i] = light;	
				}

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('prologue/poll'));
				swagBacks['streetBehind'] = streetBehind;
				toAdd.push(streetBehind);
					
				var street:FlxSprite = new FlxSprite(-130, streetBehind.y).loadGraphic(Paths.image('prologue/rooftop'));
				swagBacks['street'] = street;
				toAdd.push(street);
			}	

			case 'ripdiner':
			{
				camZoom = 0.5;
				var bg:FlxSprite = new FlxSprite(-820, -200).loadGraphic(Paths.image('fever/lastsongyukichi','shared'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var bottomBoppers3 = new FlxSprite(-800, -180);
				bottomBoppers3.frames = Paths.getSparrowAtlas('fever/CROWD1', 'shared');
				bottomBoppers3.animation.addByPrefix('idle', "CROWD1", 24, false);
				bottomBoppers3.animation.play('idle');
				bottomBoppers3.scrollFactor.set(0.9, 0.9);
				swagBacks['bottomBoppers3'] = bottomBoppers3;		
				layInFront[2].push(bottomBoppers3);
				animatedBacks.push(bottomBoppers3);
			}

			case 'genocide':
			{
				camZoom = 0.8;

				var siniFireBehind = new FlxTypedGroup<SiniFire>();
				swagGroup['siniFireBehind'] = siniFireBehind;
				
				var siniFireFront = new FlxTypedGroup<SiniFire>();
				swagGroup['siniFireFront'] = siniFireFront;
			
				
				var genocideBG = new FlxSprite(-600, -300).loadGraphic(Paths.image('tabi/fire/wadsaaa'));
				genocideBG.antialiasing = true;
				genocideBG.scrollFactor.set(0.9, 0.9);
				swagBacks['genocideBG'] = genocideBG;		
				toAdd.push(genocideBG);

				for (i in 0...2)
				{
					var daFire:SiniFire = new SiniFire(genocideBG.x + (720 + (((95 * 10) / 2) * i)), genocideBG.y + 180, true, false, 30, i * 10, 84);
					daFire.antialiasing = true;
					daFire.scrollFactor.set(0.9, 0.9);
					daFire.scale.set(0.4, 1);
					daFire.y += 50;
					siniFireBehind.add(daFire);
					swagBacks['daFire' + i] = daFire;	
				}
				
				toAdd.push(siniFireBehind);
				
				var genocideBoard = new FlxSprite(genocideBG.x, genocideBG.y).loadGraphic(Paths.image('tabi/fire/boards'));
				genocideBoard.antialiasing = true;
				genocideBoard.scrollFactor.set(0.9, 0.9);
				swagBacks['genocideBoard'] = genocideBoard;		
				toAdd.push(genocideBoard);
				
				var fire1:SiniFire = new SiniFire(genocideBG.x + (-100), genocideBG.y + 889, true, false, 30);
				fire1.antialiasing = true;
				fire1.scrollFactor.set(0.9, 0.9);
				fire1.scale.set(2.5, 1.5);
				fire1.y -= fire1.height * 1.5;
				fire1.flipX = true;
				swagBacks['fire1'] = fire1;	
				siniFireFront.add(fire1);
				
				var fire2:SiniFire = new SiniFire((fire1.x + fire1.width) - 80, genocideBG.y + 889, true, false, 30);
				fire2.antialiasing = true;
				fire2.scrollFactor.set(0.9, 0.9);
				fire2.y -= fire2.height * 1;
				swagBacks['fire2'] = fire2;	
				siniFireFront.add(fire2);
				
				var fire3:SiniFire = new SiniFire((fire2.x + fire2.width) - 30, genocideBG.y + 889, true, false, 30);
				fire3.antialiasing = true;
				fire3.scrollFactor.set(0.9, 0.9);
				fire3.y -= fire3.height * 1;
				swagBacks['fire3'] = fire3;	
				siniFireFront.add(fire3);

				var fire4:SiniFire = new SiniFire((fire3.x + fire3.width) - 10, genocideBG.y + 889, true, false, 30);
				fire4.antialiasing = true;
				fire4.scrollFactor.set(0.9, 0.9);
				fire4.scale.set(1.5, 1.5);
				fire4.y -= fire4.height * 1.5;
				swagBacks['fire4'] = fire4;	
				siniFireFront.add(fire4);
				
				toAdd.push(siniFireFront);
				
				var path:String = "";

				if (PlayState.isNeonight && PlayState.SONG.song.toLowerCase() == 'crucify')
					path = Paths.image('tabi/fire/glowyfurniture2');
				else
					path = Paths.image('tabi/fire/glowyfurniture');

				var fuckYouFurniture:FlxSprite = new FlxSprite(genocideBG.x, genocideBG.y).loadGraphic(path);
				fuckYouFurniture.antialiasing = true;
				fuckYouFurniture.scrollFactor.set(0.9, 0.9);
				swagBacks['fuckYouFurniture'] = fuckYouFurniture;		
				toAdd.push(fuckYouFurniture);

				var destBoombox:FlxSprite = new FlxSprite(400, 130).loadGraphic(Paths.image('tabi/fire/Destroyed_boombox'));
				destBoombox.y += (destBoombox.height - 648) * -1;
				destBoombox.y += 150;
				destBoombox.x -= 110;
				destBoombox.scale.set(1.2, 1.2);
				swagBacks['destBoombox'] = destBoombox;		
				toAdd.push(destBoombox);

				var sumsticks:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('tabi/fire/overlayingsticks'));
				sumsticks.antialiasing = true;
				sumsticks.scrollFactor.set(0.9, 0.9);
				sumsticks.active = false;
				swagBacks['sumsticks'] = sumsticks;		
				layInFront[2].push(sumsticks);
			}

			case 'neon':
			{
				camZoom = 0.7;
				var hscriptPath = 'shootin/neon/';

				var bg = new FlxSprite(-430, -438).loadGraphic(Paths.image(hscriptPath + 'sky'));
				bg.scrollFactor.set(0.1, 0.1);
				bg.antialiasing = true;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var city = new FlxSprite(-2000, -300).loadGraphic(Paths.image(hscriptPath + 'city'));
				city.antialiasing = true;
   				city.updateHitbox();
				swagBacks['city'] = city;
				toAdd.push(city);

				var phillyCityLights = new FlxTypedGroup<FlxSprite>();
				swagGroup['phillyCityLights'] = phillyCityLights;
				toAdd.push(phillyCityLights);

				for (i in 0...5)
				{
					var light:FlxSprite = new FlxSprite(-120, 117).loadGraphic(Paths.image(hscriptPath + 'win' + i + ''));
					light.visible = false;
					light.antialiasing = true;
					phillyCityLights.add(light);
					swagBacks['light' + i] = light;	
				}

				var streetBehind = new FlxSprite(-40, 10).loadGraphic(Paths.image(hscriptPath + 'behindTrain'));
				streetBehind.antialiasing = true;
				swagBacks['streetBehind'] = streetBehind;
				toAdd.push(streetBehind);

				var phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image(hscriptPath + 'train'));
				phillyTrain.antialiasing = true;
				swagBacks['phillyTrain'] = phillyTrain;
				toAdd.push(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				var street = new FlxSprite(-120, 117).loadGraphic(Paths.image(hscriptPath + 'street'));
				street.antialiasing = true;
				swagBacks['street'] = street;
				toAdd.push(street);

				if (PlayState.SONG.song.toLowerCase() == 'technokinesis')
				{
					var chara = new Character(250, 300, 'chara');
					swagBacks['chara'] = chara;
					toAdd.push(chara);
				}
			}
			case 'defeat':
			{
				camZoom = 0.9;

				var defeat:FlxSprite = new FlxSprite(0, 100).loadGraphic(Paths.image('defeatfnf', 'shared'));		
				defeat.setGraphicSize(Std.int(defeat.width * 2));
				defeat.scrollFactor.set(1,1);
				defeat.antialiasing = true;
				swagBacks['defeat'] = defeat;
				toAdd.push(defeat);
			}
			case 'studioLot':
			{
				camZoom = 0.9;

				var bg:FlxSprite = new FlxSprite(-300, -400).loadGraphic(Paths.image('studioLot/sky'));
				bg.antialiasing = FlxG.save.data.antialiasing;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var mountainback:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('studioLot/mountainback'));
				mountainback.updateHitbox();
				mountainback.scrollFactor.set(0.9, 0.9);
				mountainback.active = false;
				swagBacks['mountainback'] = mountainback;
				toAdd.push(mountainback);

				var moutainsfoward:FlxSprite = new FlxSprite(-500, 100).loadGraphic(Paths.image('studioLot/moutainsfoward'));
				moutainsfoward.updateHitbox();
				moutainsfoward.scrollFactor.set(0.9, 0.9);
				moutainsfoward.active = false;
				swagBacks['moutainsfoward'] = moutainsfoward;
				toAdd.push(moutainsfoward);

				var bushes:FlxSprite = new FlxSprite(-100, -700).loadGraphic(Paths.image('studioLot/bushes'));
				bushes.updateHitbox();
				bushes.antialiasing = FlxG.save.data.antialiasing;
				bushes.scrollFactor.set(0.9, 0.9);
				bushes.active = false;
				swagBacks['bushes'] = bushes;
				toAdd.push(bushes);

				var studio:FlxSprite = new FlxSprite(0, -1000).loadGraphic(Paths.image('studioLot/studio'));
				studio.updateHitbox();
				studio.scrollFactor.set(0.9, 0.9);
				studio.active = false;
				swagBacks['studio'] = studio;
				toAdd.push(studio);

				var ground:FlxSprite = new FlxSprite(-1200, 560).loadGraphic(Paths.image('studioLot/ground'));
				ground.setGraphicSize(Std.int(ground.width * 2));
				ground.updateHitbox();
				ground.scrollFactor.set(0.9, 0.9);
				ground.active = false;
				swagBacks['ground'] = ground;
				toAdd.push(ground);
			}

			case 'incident':
			{
				camZoom = 1.4;
				var bgt:FlxSprite = new FlxSprite(-500, -260).loadGraphic(Paths.image('BB1'));
				bgt.active = false;				
				swagBacks['bgt'] = bgt;
				toAdd.push(bgt);

				if(PlayState.SONG.gfVersion != 'gf-trollge')
				{
					var trashcan:FlxSprite = new FlxSprite(565, 420).loadGraphic(Paths.image('trashcan'));
					trashcan.scrollFactor.set(0.95, 0.95);
					trashcan.active = false;			
					swagBacks['trashcan'] = trashcan;
					toAdd.push(trashcan);
				}
			}

			case 'stare': 
			{
				camZoom = 0.9;

				var starecrownBG = new FlxSprite(-400, -175);
				starecrownBG.frames = Paths.getSparrowAtlas('starecrown/Maze');
				starecrownBG.animation.addByPrefix('idle', 'Stage');
				starecrownBG.animation.play('idle');
				starecrownBG.antialiasing = true;
				starecrownBG.scrollFactor.set(0.3, 0.3);
				starecrownBG.setGraphicSize(Std.int(starecrownBG.width * 1.5));
				starecrownBG.updateHitbox();
				swagBacks['starecrownBG'] = starecrownBG;
				toAdd.push(starecrownBG);
			}

			case 'garStageRise':
			{
				camZoom = 0.9;
				
				var bg = new FlxSprite(-500, -170).loadGraphic(Paths.image('garcello/garStagebgRise'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var stageFront:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('garcello/garStageRise'));
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				swagBacks['stageFront'] = stageFront;
				toAdd.push(stageFront);
			}

			case 'garStageDead':
			{
				camZoom = 0.9;

				var bg:FlxSprite = new FlxSprite(-500, -170).loadGraphic(Paths.image('garcello/garStagebgAlt'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.7, 0.7);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var smoker:FlxSprite = new FlxSprite(0, -290);
				smoker.frames = Paths.getSparrowAtlas('garcello/garSmoke');
				smoker.setGraphicSize(Std.int(smoker.width * 1.7));
				smoker.alpha = 0.3;
				smoker.animation.addByPrefix('garsmoke', "smokey", 13);
				smoker.animation.play('garsmoke');
				smoker.scrollFactor.set(0.7, 0.7);
				swagBacks['smoker'] = smoker;
				toAdd.push(smoker);

				var bgAlley:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('garcello/garStagealt'));
				bgAlley.antialiasing = true;
				bgAlley.scrollFactor.set(0.9, 0.9);
				bgAlley.active = false;
				swagBacks['bgAlley'] = bgAlley;
				toAdd.push(bgAlley);

				var corpse:FlxSprite = new FlxSprite(-230, 540).loadGraphic(Paths.image('garcello/gardead'));
				corpse.antialiasing = true;
				corpse.scrollFactor.set(0.9, 0.9);
				corpse.active = false;
				swagBacks['corpse'] = corpse;
				toAdd.push(corpse);

				var smoke:FlxSprite = new FlxSprite(0, 0);
				smoke.frames = Paths.getSparrowAtlas('garcello/garSmoke');
				smoke.setGraphicSize(Std.int(smoke.width * 1.6));
				smoke.animation.addByPrefix('garsmoke', "smokey", 15);
				smoke.animation.play('garsmoke');
				smoke.scrollFactor.set(1.1, 1.1);
				swagBacks['smoke'] = smoke;
				layInFront[2].push(smoke);
			}

			case 'operaStage' | 'operaStage-old':
			{
				camZoom = 0.9;

				switch (daStage)
				{
					case 'operaStage': pre = 'operastage';
					case 'operaStage-old': pre = 'operastage_old';
				}
	
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('backgrounds/'+pre+'/stageback','shared'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('backgrounds/'+pre+'/stagefront','shared'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				swagBacks['stageFront'] = stageFront;
				toAdd.push(stageFront);
			}

			//the end of my stuff
			case 'stage' | 'holostage' | 'FNAFstage' | 'holostage-corrupt' | 'arcade' | 'ballin':
			{
				camZoom = 0.9;
				var stageShit:String ='';

				switch (daStage)
				{
					case 'stage':
						stageShit = '';
					case 'holostage':
						stageShit = 'holofunk/stage/';
					case 'FNAFstage':
						stageShit = 'FNAF/';
					case 'holostage-corrupt':
						stageShit = 'holofunk/stage/corrupt';
					case 'arcade':
						stageShit = 'kapi/';
					case 'ballin':
						stageShit = 'hex/';
				}

				if (daStage == 'holostage-corrupt')
				{
					var bg2 = new FlxSprite(-600, -200).loadGraphic(Paths.image('holofunk/stage/eyes'));
					bg2.antialiasing = true;
					bg2.scrollFactor.set(0.9, 0.9);
					bg2.active = false;
					swagBacks['bg2'] = bg2;
					toAdd.push(bg2);
				}

				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image(stageShit+'stageback'));
				bg.antialiasing = FlxG.save.data.antialiasing;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image(stageShit+'stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = FlxG.save.data.antialiasing;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				swagBacks['stageFront'] = stageFront;
				toAdd.push(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image(stageShit+'stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = FlxG.save.data.antialiasing;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				swagBacks['stageCurtains'] = stageCurtains;
				toAdd.push(stageCurtains);
			}
			default:
			{
				camZoom = 0.9;
				curStage = 'stage';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
				bg.antialiasing = FlxG.save.data.antialiasing;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = FlxG.save.data.antialiasing;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				swagBacks['stageFront'] = stageFront;
				toAdd.push(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = FlxG.save.data.antialiasing;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				swagBacks['stageCurtains'] = stageCurtains;
				toAdd.push(stageCurtains);
			}
		}

		switch (daStage)
		{
			case 'halloween-pelo':
				bfXOffset = 200;
				gfXOffset = 100;
				dadXOffset = 100;
			case 'garStage' | 'eddhouse2' | 'garStageRise' | 'garStageDead':
				bfXOffset = 100;
			case 'stadium':
				bfXOffset = 150;
				bfYOffset = 300;
				dadXOffset = -45;
				dadYOffset = 300;
				gfXOffset = -65;
				gfYOffset = 200;
			case 'room-space':
				bfXOffset = 330;
			case 'melonfarm': 
				bfXOffset = 180;
				bfYOffset = -50;
			case 'mallEvil' | 'mallAnnie':
				bfXOffset = 320;
				dadYOffset = -80;
			case 'hungryhippo' | 'hungryhippo-blantad':
				dadYOffset = 150;
				if (PlayState.SONG.song.toLowerCase() == 'hunger')
				{
					bfXOffset = 100;
					bfYOffset = 210;
				}
			case 'incident':
				bfXOffset = 200;
				bfYOffset = 20;
				gfXOffset = 320;
				gfYOffset = 50;
			case 'skybroke':
				bfXOffset = 60;
				bfYOffset = -145;
				dadXOffset = -170;
				gfXOffset = -40;
				gfYOffset = -170;
			case 'polus' | 'polus2':
				dadXOffset = -270;
				dadYOffset = -240;
				gfXOffset = -200;
				gfYOffset = -235;
				bfXOffset = -20;
				bfYOffset = -230;
			case 'school-monika-finale':
				dadYOffset = -69;
				dadXOffset = 300;
				bfXOffset = 200;
				bfYOffset = 260;
				gfXOffset = 180;
				gfYOffset = 300;
			case 'FMMstage':
				bfXOffset = 280;
				bfYOffset = 50;
				dadXOffset = -315;
				dadYOffset = 50;
				gfXOffset = -140;
				gfYOffset = -50;	
			case 'zardymaze':
				dadYOffset = 140;
				gfYOffset = 140;
				bfXOffset = 80;
				bfYOffset = 140;	
			case 'prologue':
				dadYOffset = 50;
				bfYOffset = 80;
			case 'mall' | 'mallSoft' | 'softdeez':
				bfXOffset = 230;
			case 'emptystage2':
				bfXOffset = 100;
				dadXOffset = -100;
			case 'throne':
				bfXOffset = 100;
				dadXOffset = -180;
				gfXOffset = -107;
				gfYOffset = -23;
			case 'manifest':
				dadXOffset = 20;
				dadYOffset = -5;
				bfXOffset = 60;
				bfYOffset = -185;
				gfXOffset = 80;
				gfYOffset = -185;
			case 'momiStage':
				bfXOffset = 160;
				bfYOffset = -100;
				gfXOffset = 60;
				gfYOffset = -118;
				dadXOffset = -33;
				dadYOffset = -82;
			case 'night':
				dadXOffset = -370;
				dadYOffset = 39;
				bfXOffset = 191;
				bfYOffset = -20;
				gfXOffset = 300;
				gfYOffset = -50;
			case 'mind' | 'mind2':
				bfXOffset = -200;
				bfYOffset = 270;
				dadXOffset = -120;
				dadYOffset = 220;
			case 'cg5stage':
				bfXOffset = 100;
				bfYOffset = 100;
				dadXOffset = -50;
				dadYOffset = 100;
			case 'tank2':
				bfXOffset = 40;
				gfXOffset = 10;
				gfYOffset = -30;
				dadXOffset = -80;
				dadYOffset = 60;
			case 'defeat':
				gfYOffset = -2000;
			case 'studioLot':
				bfXOffset = 100;
				bfYOffset = 30;
			case 'churchsarv' | 'churchruv' | 'churchselever' | 'churchsarvdark':
				gfXOffset = -150;
				gfYOffset = -180;
				dadXOffset = -100;
			case 'sunkStage':
				dadYOffset = 100;
				bfYOffset = 100;
				gfYOffset = 100;
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		switch (curStage)
		{
			case 'philly' | 'phillyannie':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
			case 'zardymaze':
				if (swagBacks['zardyBackground'].animation.finished){
					swagBacks['zardyBackground'].animation.play('Maze');
				}
			case 'ITB':
				var phillyCityLights = swagGroup['phillyCityLights'];
				var lightsTimer:Array<Int> = [200, 700];
				for (i in 0...phillyCityLights.members.length) {
					if (lightsTimer[i] == 0) {
						lightsTimer[i] = -1;
						FlxTween.tween(phillyCityLights.members[i], {alpha: 1}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadOut, 
							onComplete: function(tween:FlxTween)
							{
								FlxTween.tween(phillyCityLights.members[i], {alpha: 0}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadIn, 
									onComplete: function(tween:FlxTween)
									{
										var daRando = new FlxRandom();
										lightsTimer[i] = daRando.int(1000, 1500);
									}, 
								});
							}, 
						});
					} else
						lightsTimer[i]--;
				}		
		}
	}

	override function stepHit()
	{
		super.stepHit();

		var array = slowBacks[curStep];
		if (array != null && array.length > 0)
		{
			if (hideLastBG)
			{
				for (bg in swagBacks)
				{
					if (!array.contains(bg))
					{
						var tween = FlxTween.tween(bg, {alpha: 0}, tweenDuration, {
							onComplete: function(tween:FlxTween):Void
							{
								bg.visible = false;
							}
						});
					}
				}
				for (bg in array)
				{
					bg.visible = true;
					FlxTween.tween(bg, {alpha: 1}, tweenDuration);
				}
			}
			else
			{
				for (bg in array)
					bg.visible = !bg.visible;
			}
		}
	}

	// Variables and Functions for Stages
	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (animatedBacks.length > 0)
		{
			for (bg in animatedBacks)
				bg.animation.play('idle', true);
		}

		switch (curStage)
		{
			case 'halloween' | 'halloweenmanor':
				if (FlxG.random.bool(Conductor.bpm > 320 ? 100 : 10) && curBeat > lightningStrikeBeat + lightningOffset)
				{
					lightningStrikeShit();
					trace('spooky');
				}
			case 'school':
				swagBacks['bgGirls'].dance();
			case 'arcade4':
				if (curBeat % 2 == 1)
					swagBacks['upperBoppers'].animation.play('bop', true);
				if (curBeat % 2 == 0)
					swagBacks['bottomBoppers'].animation.play('bop', true);
			case 'limo':
				swagGroup['grpLimoDancers'].forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case 'limoholo':
				swagGroup['grpLimoDancersHolo'].forEach(function(dancer:BackgroundDancerHolo)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case 'manifest':
				if (PlayState.SONG.song.toLowerCase() == 'manifest' && PlayState.isBETADCIU)
					swagBacks['gfCrazyBG'].animation.play('idle');
			case 'mallSoft':
				swagBacks['gfBG'].dance();
				swagBacks['momDadBG'].animation.play('idle');
				swagBacks['softBFBG'].animation.play('idle');
			case 'pillars':
				swagBacks['speaker'].animation.play('bop');
			case "philly" | "phillyannie" | "prologue" | "neon":
				if (curStage != "prologue" && curStage != "neon")
				{
					if (!trainMoving) {
						trainCooldown += 1;
					}	
					if (curBeat % 8 == 4 && FlxG.random.bool(Conductor.bpm > 320 ? 150 : 30) && !trainMoving && trainCooldown > 8)
					{
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
						trace('train');
					}
				}
				
				if (curBeat % 4 == 0)
				{
					var phillyCityLights = swagGroup['phillyCityLights'];
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
				}

				if (PlayState.SONG.song.toLowerCase() == 'technokinesis' && curStage == 'neon') {
					swagBacks['chara'].playAnim('idle');
				}
			case 'kbStreet':
				if(curBeat >= 80 && curBeat <= 208) 
				{
					if (curBeat % 16 == 0)
					{
						swagBacks['qt_gas01'].animation.play('burst');
						swagBacks['qt_gas02'].animation.play('burst');
					}
				}
			case 'tank2':
				if (curBeat % 2 == 0)
				{	
					swagBacks['tankWatchtower'].animation.play('idle', true);
					swagBacks['tank0'].animation.play('idle', true);
					swagBacks['tank1'].animation.play('idle', true);
					swagBacks['tank2'].animation.play('idle', true);
					swagBacks['tank4'].animation.play('idle', true);
					swagBacks['tank5'].animation.play('idle', true);
					swagBacks['tank3'].animation.play('idle', true);
				}
		}
	}

	var curLight:Int = 0;

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		swagBacks['halloweenBG'].animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		if (PlayState.boyfriend.animOffsets.exists('scared')){
			PlayState.boyfriend.playAnim('scared', true);
		}
		if (PlayState.gf.animOffsets.exists('scared')){
		PlayState.gf.playAnim('scared', true);
		}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var trainSound:FlxSound;

	function trainStart():Void
	{
		trainMoving = true;
		trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			PlayState.gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			var phillyTrain = swagBacks['phillyTrain'];
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		PlayState.gf.playAnim('hairFall');
		swagBacks['phillyTrain'].x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	public function resetFastCar():Void
	{
		var fastCar = swagBacks['fastCar'];
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		if (fastCar.frames != null)
		{
			fastCar.velocity.x = 0;
		}		
		fastCarCanDrive = true;
	}

	public function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		swagBacks['fastCar'].velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			if (curStage == 'limo' || curStage == 'limoholo')
			{
				resetFastCar();
			}			
		});
	}
}