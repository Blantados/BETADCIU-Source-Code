package;

import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionInputDigital;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

#if (haxe >= "4.0.0")
enum abstract Action(String) to String from String
{
	var UP = "up";
	var LEFT = "left";
	var RIGHT = "right";
	var DOWN = "down";
	var UP_P = "up-press";
	var LEFT_P = "left-press";
	var RIGHT_P = "right-press";
	var DOWN_P = "down-press";
	var UP_R = "up-release";
	var LEFT_R = "left-release";
	var RIGHT_R = "right-release";
	var DOWN_R = "down-release";
	var ACCEPT = "accept";
	var BACK = "back";
	var PAUSE = "pause";
	var RESET = "reset";
	var CHEAT = "cheat";

	var S1 = "s1";
	var S2 = "s2";
	var S3 = "s3";
	var S4 = "s4";
	var S5 = "s5";
	var S6 = "s6";

	var S1_P = "s1-press";
	var S2_P = "s2-press";
	var S3_P = "s3-press";
	var S4_P = "s4-press";
	var S5_P = "s5-press";
	var S6_P = "s6-press";

	var S1_R = "s1_release";
	var S2_R = "s2_release";
	var S3_R = "s3_release";
	var S4_R = "s4_release";
	var S5_R = "s5_release";
	var S6_R = "s6_release";

	var T1 = "t1";
	var T2 = "t2";
	var T3 = "t3";
	var T4 = "t4";
	var T5 = "t5";

	var T1_P = "t1-press";
	var T2_P = "t2-press";
	var T3_P = "t3-press";
	var T4_P = "t4-press";
	var T5_P = "t5-press";

	var T1_R = "t1_release";
	var T2_R = "t2_release";
	var T3_R = "t3_release";
	var T4_R = "t4_release";
	var T5_R = "t5_release";

	var N0 = "n0";
	var N1 = "n1";
	var N2 = "n2";
	var N3 = "n3";
	var N4 = "n4";
	var N5 = "n5";
	var N6 = "n6";
	var N7 = "n7";
	var N8 = "n8";

	var N0_P = "n0-press";
	var N1_P = "n1-press";
	var N2_P = "n2-press";
	var N3_P = "n3-press";
	var N4_P = "n4-press";
	var N5_P = "n5-press";
	var N6_P = "n6-press";
	var N7_P = "n7-press";
	var N8_P = "n8-press";

	var N0_R = "n0-release";
	var N1_R = "n1-release";
	var N2_R = "n2-release";
	var N3_R = "n3-release";
	var N4_R = "n4-release";
	var N5_R = "n5-release";
	var N6_R = "n6-release";
	var N7_R = "n7-release";
	var N8_R = "n8-release";
}
#else
@:enum
abstract Action(String) to String from String
{
	var UP = "up";
	var LEFT = "left";
	var RIGHT = "right";
	var DOWN = "down";
	var UP_P = "up-press";
	var LEFT_P = "left-press";
	var RIGHT_P = "right-press";
	var DOWN_P = "down-press";
	var UP_R = "up-release";
	var LEFT_R = "left-release";
	var RIGHT_R = "right-release";
	var DOWN_R = "down-release";
	var ACCEPT = "accept";
	var BACK = "back";
	var PAUSE = "pause";
	var RESET = "reset";
	var CHEAT = "cheat";

	var S1 = "s1";
	var S2 = "s2";
	var S3 = "s3";
	var S4 = "s4";
	var S5 = "s5";
	var S6 = "s6";

	var S1_P = "s1-press";
	var S2_P = "s2-press";
	var S3_P = "s3-press";
	var S4_P = "s4-press";
	var S5_P = "s5-press";
	var S6_P = "s6-press";

	var S1_R = "s1_release";
	var S2_R = "s2_release";
	var S3_R = "s3_release";
	var S4_R = "s4_release";
	var S5_R = "s5_release";
	var S6_R = "s6_release";

	var T1 = "t1";
	var T2 = "t2";
	var T3 = "t3";
	var T4 = "t4";
	var T5 = "t5";

	var T1_P = "t1-press";
	var T2_P = "t2-press";
	var T3_P = "t3-press";
	var T4_P = "t4-press";
	var T5_P = "t5-press";

	var T1_R = "t1_release";
	var T2_R = "t2_release";
	var T3_R = "t3_release";
	var T4_R = "t4_release";
	var T5_R = "t5_release";

	var N0 = "n0";
	var N1 = "n1";
	var N2 = "n2";
	var N3 = "n3";
	var N4 = "n4";
	var N5 = "n5";
	var N6 = "n6";
	var N7 = "n7";
	var N8 = "n8";

	var N0_P = "n0-press";
	var N1_P = "n1-press";
	var N2_P = "n2-press";
	var N3_P = "n3-press";
	var N4_P = "n4-press";
	var N5_P = "n5-press";
	var N6_P = "n6-press";
	var N7_P = "n7-press";
	var N8_P = "n8-press";

	var N0_R = "n0-release";
	var N1_R = "n1-release";
	var N2_R = "n2-release";
	var N3_R = "n3-release";
	var N4_R = "n4-release";
	var N5_R = "n5-release";
	var N6_R = "n6-release";
	var N7_R = "n7-release";
	var N8_R = "n8-release";
}
#end

enum Device
{
	Keys;
	Gamepad(id:Int);
}

/**
 * Since, in many cases multiple actions should use similar keys, we don't want the
 * rebinding UI to list every action. ActionBinders are what the user percieves as
 * an input so, for instance, they can't set jump-press and jump-release to different keys.
 */
enum Control
{
	UP;
	LEFT;
	RIGHT;
	DOWN;
	RESET;
	ACCEPT;
	BACK;
	PAUSE;
	CHEAT;
	S1;
	S2;
	S3;
	S4;
	S5;
	S6;
	T1;
	T2;
	T3;
	T4;
	T5;
	N0;
	N1;
	N2;
	N3;
	N4;
	N5;
	N6;
	N7;
	N8;
}

enum KeyboardScheme
{
	Solo;
	Duo(first:Bool);
	None;
	Custom;
}

/**
 * A list of actions that a player would invoke via some input device.
 * Uses FlxActions to funnel various inputs to a single action.
 */
class Controls extends FlxActionSet
{
	var _up = new FlxActionDigital(Action.UP);
	var _left = new FlxActionDigital(Action.LEFT);
	var _right = new FlxActionDigital(Action.RIGHT);
	var _down = new FlxActionDigital(Action.DOWN);
	var _upP = new FlxActionDigital(Action.UP_P);
	var _leftP = new FlxActionDigital(Action.LEFT_P);
	var _rightP = new FlxActionDigital(Action.RIGHT_P);
	var _downP = new FlxActionDigital(Action.DOWN_P);
	var _upR = new FlxActionDigital(Action.UP_R);
	var _leftR = new FlxActionDigital(Action.LEFT_R);
	var _rightR = new FlxActionDigital(Action.RIGHT_R);
	var _downR = new FlxActionDigital(Action.DOWN_R);
	var _accept = new FlxActionDigital(Action.ACCEPT);
	var _back = new FlxActionDigital(Action.BACK);
	var _pause = new FlxActionDigital(Action.PAUSE);
	var _reset = new FlxActionDigital(Action.RESET);
	var _cheat = new FlxActionDigital(Action.CHEAT);

	var _s1 = new FlxActionDigital(Action.S1);
	var _s1P = new FlxActionDigital(Action.S1_P);
	var _s1R = new FlxActionDigital(Action.S1_R);

	var _s2 = new FlxActionDigital(Action.S2);
	var _s2P = new FlxActionDigital(Action.S2_P);
	var _s2R = new FlxActionDigital(Action.S2_R);

	var _s3 = new FlxActionDigital(Action.S3);
	var _s3P = new FlxActionDigital(Action.S3_P);
	var _s3R = new FlxActionDigital(Action.S3_R);

	var _s4 = new FlxActionDigital(Action.S4);
	var _s4P = new FlxActionDigital(Action.S4_P);
	var _s4R = new FlxActionDigital(Action.S4_R);

	var _s5 = new FlxActionDigital(Action.S5);
	var _s5P = new FlxActionDigital(Action.S5_P);
	var _s5R = new FlxActionDigital(Action.S5_R);

	var _s6 = new FlxActionDigital(Action.S6);
	var _s6P = new FlxActionDigital(Action.S6_P);
	var _s6R = new FlxActionDigital(Action.S6_R);

	var _t1 = new FlxActionDigital(Action.T1);
	var _t1P = new FlxActionDigital(Action.T1_P);
	var _t1R = new FlxActionDigital(Action.T1_R);

	var _t2 = new FlxActionDigital(Action.T2);
	var _t2P = new FlxActionDigital(Action.T2_P);
	var _t2R = new FlxActionDigital(Action.T2_R);

	var _t3 = new FlxActionDigital(Action.T3);
	var _t3P = new FlxActionDigital(Action.T3_P);
	var _t3R = new FlxActionDigital(Action.T3_R);

	var _t4 = new FlxActionDigital(Action.T4);
	var _t4P = new FlxActionDigital(Action.T4_P);
	var _t4R = new FlxActionDigital(Action.T4_R);

	var _t5 = new FlxActionDigital(Action.T5);
	var _t5P = new FlxActionDigital(Action.T5_P);
	var _t5R = new FlxActionDigital(Action.T5_R);

	var _n0 = new FlxActionDigital(Action.N0);
	var _n1 = new FlxActionDigital(Action.N1);
	var _n2 = new FlxActionDigital(Action.N2);
	var _n3 = new FlxActionDigital(Action.N3);
	var _n4 = new FlxActionDigital(Action.N4);
	var _n5 = new FlxActionDigital(Action.N5);
	var _n6 = new FlxActionDigital(Action.N6);
	var _n7 = new FlxActionDigital(Action.N7);
	var _n8 = new FlxActionDigital(Action.N8);

	var _n0P = new FlxActionDigital(Action.N0_P);
	var _n1P = new FlxActionDigital(Action.N1_P);
	var _n2P = new FlxActionDigital(Action.N2_P);
	var _n3P = new FlxActionDigital(Action.N3_P);
	var _n4P = new FlxActionDigital(Action.N4_P);
	var _n5P = new FlxActionDigital(Action.N5_P);
	var _n6P = new FlxActionDigital(Action.N6_P);
	var _n7P = new FlxActionDigital(Action.N7_P);
	var _n8P = new FlxActionDigital(Action.N8_P);

	var _n0R = new FlxActionDigital(Action.N0_R);
	var _n1R = new FlxActionDigital(Action.N1_R);
	var _n2R = new FlxActionDigital(Action.N2_R);
	var _n3R = new FlxActionDigital(Action.N3_R);
	var _n4R = new FlxActionDigital(Action.N4_R);
	var _n5R = new FlxActionDigital(Action.N5_R);
	var _n6R = new FlxActionDigital(Action.N6_R);
	var _n7R = new FlxActionDigital(Action.N7_R);
	var _n8R = new FlxActionDigital(Action.N8_R);

	#if (haxe >= "4.0.0")
	var byName:Map<String, FlxActionDigital> = [];
	#else
	var byName:Map<String, FlxActionDigital> = new Map<String, FlxActionDigital>();
	#end

	public var gamepadsAdded:Array<Int> = [];
	public var keyboardScheme = KeyboardScheme.None;

	public var UP(get, never):Bool;

	inline function get_UP()
		return _up.check();

	public var LEFT(get, never):Bool;

	inline function get_LEFT()
		return _left.check();

	public var RIGHT(get, never):Bool;

	inline function get_RIGHT()
		return _right.check();

	public var DOWN(get, never):Bool;

	inline function get_DOWN()
		return _down.check();

	public var UP_P(get, never):Bool;

	inline function get_UP_P()
		return _upP.check();

	public var LEFT_P(get, never):Bool;

	inline function get_LEFT_P()
		return _leftP.check();

	public var RIGHT_P(get, never):Bool;

	inline function get_RIGHT_P()
		return _rightP.check();

	public var DOWN_P(get, never):Bool;

	inline function get_DOWN_P()
		return _downP.check();

	public var UP_R(get, never):Bool;

	inline function get_UP_R()
		return _upR.check();

	public var LEFT_R(get, never):Bool;

	inline function get_LEFT_R()
		return _leftR.check();

	public var RIGHT_R(get, never):Bool;

	inline function get_RIGHT_R()
		return _rightR.check();

	public var DOWN_R(get, never):Bool;

	inline function get_DOWN_R()
		return _downR.check();

	public var ACCEPT(get, never):Bool;

	inline function get_ACCEPT()
		return _accept.check();

	public var BACK(get, never):Bool;

	inline function get_BACK()
		return _back.check();

	public var PAUSE(get, never):Bool;

	inline function get_PAUSE()
		return _pause.check();

	public var RESET(get, never):Bool;

	inline function get_RESET()
		return _reset.check();

	public var CHEAT(get, never):Bool;

	inline function get_CHEAT()
		return _cheat.check();

	public var S1(get, never):Bool;
	public var S2(get, never):Bool;
	public var S3(get, never):Bool;
	public var S4(get, never):Bool;
	public var S5(get, never):Bool;
	public var S6(get, never):Bool;

	public var S1_P(get, never):Bool;
	public var S2_P(get, never):Bool;
	public var S3_P(get, never):Bool;
	public var S4_P(get, never):Bool;
	public var S5_P(get, never):Bool;
	public var S6_P(get, never):Bool;

	public var S1_R(get, never):Bool;
	public var S2_R(get, never):Bool;
	public var S3_R(get, never):Bool;
	public var S4_R(get, never):Bool;
	public var S5_R(get, never):Bool;
	public var S6_R(get, never):Bool;

	inline function get_S1() return _s1.check();
	inline function get_S2() return _s2.check();
	inline function get_S3() return _s3.check();
	inline function get_S4() return _s4.check();
	inline function get_S5() return _s5.check();
	inline function get_S6() return _s6.check();

	inline function get_S1_P() return _s1P.check();
	inline function get_S2_P() return _s2P.check();
	inline function get_S3_P() return _s3P.check();
	inline function get_S4_P() return _s4P.check();
	inline function get_S5_P() return _s5P.check();
	inline function get_S6_P() return _s6P.check();

	inline function get_S1_R() return _s1R.check();
	inline function get_S2_R() return _s2R.check();
	inline function get_S3_R() return _s3R.check();
	inline function get_S4_R() return _s4R.check();
	inline function get_S5_R() return _s5R.check();
	inline function get_S6_R() return _s6R.check();

	public var T1(get, never):Bool;
	public var T2(get, never):Bool;
	public var T3(get, never):Bool;
	public var T4(get, never):Bool;
	public var T5(get, never):Bool;

	public var T1_P(get, never):Bool;
	public var T2_P(get, never):Bool;
	public var T3_P(get, never):Bool;
	public var T4_P(get, never):Bool;
	public var T5_P(get, never):Bool;

	public var T1_R(get, never):Bool;
	public var T2_R(get, never):Bool;
	public var T3_R(get, never):Bool;
	public var T4_R(get, never):Bool;
	public var T5_R(get, never):Bool;

	inline function get_T1() return _t1.check();
	inline function get_T2() return _t2.check();
	inline function get_T3() return _t3.check();
	inline function get_T4() return _t4.check();
	inline function get_T5() return _t5.check();

	inline function get_T1_P() return _t1P.check();
	inline function get_T2_P() return _t2P.check();
	inline function get_T3_P() return _t3P.check();
	inline function get_T4_P() return _t4P.check();
	inline function get_T5_P() return _t5P.check();

	inline function get_T1_R() return _t1R.check();
	inline function get_T2_R() return _t2R.check();
	inline function get_T3_R() return _t3R.check();
	inline function get_T4_R() return _t4R.check();
	inline function get_T5_R() return _t5R.check();

	public var N0(get, never):Bool;
	public var N1(get, never):Bool;
	public var N2(get, never):Bool;
	public var N3(get, never):Bool;
	public var N4(get, never):Bool;
	public var N5(get, never):Bool;
	public var N6(get, never):Bool;
	public var N7(get, never):Bool;
	public var N8(get, never):Bool;

	public var N0_P(get, never):Bool;
	public var N1_P(get, never):Bool;
	public var N2_P(get, never):Bool;
	public var N3_P(get, never):Bool;
	public var N4_P(get, never):Bool;
	public var N5_P(get, never):Bool;
	public var N6_P(get, never):Bool;
	public var N7_P(get, never):Bool;
	public var N8_P(get, never):Bool;

	public var N0_R(get, never):Bool;
	public var N1_R(get, never):Bool;
	public var N2_R(get, never):Bool;
	public var N3_R(get, never):Bool;
	public var N4_R(get, never):Bool;
	public var N5_R(get, never):Bool;
	public var N6_R(get, never):Bool;
	public var N7_R(get, never):Bool;
	public var N8_R(get, never):Bool;

	inline function get_N0() return _n0.check();
	inline function get_N1() return _n1.check();
	inline function get_N2() return _n2.check();
	inline function get_N3() return _n3.check();
	inline function get_N4() return _n4.check();
	inline function get_N5() return _n5.check();
	inline function get_N6() return _n6.check();
	inline function get_N7() return _n7.check();
	inline function get_N8() return _n8.check();

	inline function get_N0_P() return _n0P.check();
	inline function get_N1_P() return _n1P.check();
	inline function get_N2_P() return _n2P.check();
	inline function get_N3_P() return _n3P.check();
	inline function get_N4_P() return _n4P.check();
	inline function get_N5_P() return _n5P.check();
	inline function get_N6_P() return _n6P.check();
	inline function get_N7_P() return _n7P.check();
	inline function get_N8_P() return _n8P.check();

	inline function get_N0_R() return _n0R.check();
	inline function get_N1_R() return _n1R.check();
	inline function get_N2_R() return _n2R.check();
	inline function get_N3_R() return _n3R.check();
	inline function get_N4_R() return _n4R.check();
	inline function get_N5_R() return _n5R.check();
	inline function get_N6_R() return _n6R.check();
	inline function get_N7_R() return _n7R.check();
	inline function get_N8_R() return _n8R.check();

	#if (haxe >= "4.0.0")
	public function new(name, scheme = None)
	{
		super(name);

		add(_up);
		add(_left);
		add(_right);
		add(_down);
		add(_upP);
		add(_leftP);
		add(_rightP);
		add(_downP);
		add(_upR);
		add(_leftR);
		add(_rightR);
		add(_downR);
		add(_accept);
		add(_back);
		add(_pause);
		add(_reset);
		add(_cheat);

		add(_s1);
		add(_s2);
		add(_s3);
		add(_s4);
		add(_s5);
		add(_s6);

		add(_s1P);
		add(_s2P);
		add(_s3P);
		add(_s4P);
		add(_s5P);
		add(_s6P);

		add(_s1R);
		add(_s2R);
		add(_s3R);
		add(_s4R);
		add(_s5R);
		add(_s6R);

		add(_t1);
		add(_t2);
		add(_t3);
		add(_t4);
		add(_t5);

		add(_t1P);
		add(_t2P);
		add(_t3P);
		add(_t4P);
		add(_t5P);

		add(_t1R);
		add(_t2R);
		add(_t3R);
		add(_t4R);
		add(_t5R);

		add(_n0);
		add(_n1);
		add(_n2);
		add(_n3);
		add(_n4);
		add(_n5);
		add(_n6);
		add(_n7);
		add(_n8);

		add(_n0P);
		add(_n1P);
		add(_n2P);
		add(_n3P);
		add(_n4P);
		add(_n5P);
		add(_n6P);
		add(_n7P);
		add(_n8P);

		add(_n0R);
		add(_n1R);
		add(_n2R);
		add(_n3R);
		add(_n4R);
		add(_n5R);
		add(_n6R);
		add(_n7R);
		add(_n8R);

		for (action in digitalActions)
			byName[action.name] = action;

		setKeyboardScheme(scheme, false);
	}
	#else
	public function new(name, scheme:KeyboardScheme = null)
	{
		super(name);

		add(_up);
		add(_left);
		add(_right);
		add(_down);
		add(_upP);
		add(_leftP);
		add(_rightP);
		add(_downP);
		add(_upR);
		add(_leftR);
		add(_rightR);
		add(_downR);
		add(_accept);
		add(_back);
		add(_pause);
		add(_reset);
		add(_cheat);

		add(_s1);
		add(_s2);
		add(_s3);
		add(_s4);
		add(_s5);
		add(_s6);

		add(_s1P);
		add(_s2P);
		add(_s3P);
		add(_s4P);
		add(_s5P);
		add(_s6P);

		add(_s1R);
		add(_s2R);
		add(_s3R);
		add(_s4R);
		add(_s5R);
		add(_s6R);

		add(_t1);
		add(_t2);
		add(_t3);
		add(_t4);
		add(_t5);

		add(_t1P);
		add(_t2P);
		add(_t3P);
		add(_t4P);
		add(_t5P);

		add(_t1R);
		add(_t2R);
		add(_t3R);
		add(_t4R);
		add(_t5R);

		add(_n0);
		add(_n1);
		add(_n2);
		add(_n3);
		add(_n4);
		add(_n5);
		add(_n6);
		add(_n7);
		add(_n8);

		add(_n0P);
		add(_n1P);
		add(_n2P);
		add(_n3P);
		add(_n4P);
		add(_n5P);
		add(_n6P);
		add(_n7P);
		add(_n8P);

		add(_n0R);
		add(_n1R);
		add(_n2R);
		add(_n3R);
		add(_n4R);
		add(_n5R);
		add(_n6R);
		add(_n7R);
		add(_n8R);

		for (action in digitalActions)
			byName[action.name] = action;
			
		if (scheme == null)
			scheme = None;
		setKeyboardScheme(scheme, false);
	}
	#end

	override function update()
	{
		super.update();
	}

	// inline
	public function checkByName(name:Action):Bool
	{
		#if debug
		if (!byName.exists(name))
			throw 'Invalid name: $name';
		#end
		return byName[name].check();
	}

	public function getDialogueName(action:FlxActionDigital):String
	{
		var input = action.inputs[0];
		return switch input.device
		{
			case KEYBOARD: return '[${(input.inputID : FlxKey)}]';
			case GAMEPAD: return '(${(input.inputID : FlxGamepadInputID)})';
			case device: throw 'unhandled device: $device';
		}
	}

	public function getDialogueNameFromToken(token:String):String
	{
		return getDialogueName(getActionFromControl(Control.createByName(token.toUpperCase())));
	}

	function getActionFromControl(control:Control):FlxActionDigital
	{
		return switch (control)
		{
			case UP: _up;
			case DOWN: _down;
			case LEFT: _left;
			case RIGHT: _right;
			case ACCEPT: _accept;
			case BACK: _back;
			case PAUSE: _pause;
			case RESET: _reset;
			case CHEAT: _cheat;

			case S1: _s1;
			case S2: _s2;
			case S3: _s3;
			case S4: _s4;
			case S5: _s5;
			case S6: _s6;

			case T1: _t1;
			case T2: _t2;
			case T3: _t3;
			case T4: _t4;
			case T5: _t5;

			case N0: _n0;
			case N1: _n1;
			case N2: _n2;
			case N3: _n3;
			case N4: _n4;
			case N5: _n5;
			case N6: _n6;
			case N7: _n7;
			case N8: _n8;
		}
	}

	static function init():Void
	{
		var actions = new FlxActionManager();
		FlxG.inputs.add(actions);
	}

	/**
	 * Calls a function passing each action bound by the specified control
	 * @param control
	 * @param func
	 * @return ->Void)
	 */
	function forEachBound(control:Control, func:FlxActionDigital->FlxInputState->Void)
	{
		switch (control)
		{
			case UP:
				func(_up, PRESSED);
				func(_upP, JUST_PRESSED);
				func(_upR, JUST_RELEASED);
			case LEFT:
				func(_left, PRESSED);
				func(_leftP, JUST_PRESSED);
				func(_leftR, JUST_RELEASED);
			case RIGHT:
				func(_right, PRESSED);
				func(_rightP, JUST_PRESSED);
				func(_rightR, JUST_RELEASED);
			case DOWN:
				func(_down, PRESSED);
				func(_downP, JUST_PRESSED);
				func(_downR, JUST_RELEASED);
			case ACCEPT:
				func(_accept, JUST_PRESSED);
			case BACK:
				func(_back, JUST_PRESSED);
			case PAUSE:
				func(_pause, JUST_PRESSED);
			case RESET:
				func(_reset, JUST_PRESSED);
			case CHEAT:
				func(_cheat, JUST_PRESSED);
		
			case S1:
				func(_s1, PRESSED);
				func(_s1P, JUST_PRESSED);
				func(_s1R, JUST_RELEASED);
			case S2:
				func(_s2, PRESSED);
				func(_s2P, JUST_PRESSED);
				func(_s2R, JUST_RELEASED);
			case S3:
				func(_s3, PRESSED);
				func(_s3P, JUST_PRESSED);
				func(_s3R, JUST_RELEASED);
			case S4:
				func(_s4, PRESSED);
				func(_s4P, JUST_PRESSED);
				func(_s4R, JUST_RELEASED);
			case S5:
				func(_s5, PRESSED);
				func(_s5P, JUST_PRESSED);
				func(_s5R, JUST_RELEASED);
			case S6:
				func(_s6, PRESSED);
				func(_s6P, JUST_PRESSED);
				func(_s6R, JUST_RELEASED);

			case T1:
				func(_t1, PRESSED);
				func(_t1P, JUST_PRESSED);
				func(_t1R, JUST_RELEASED);
			case T2:
				func(_t2, PRESSED);
				func(_t2P, JUST_PRESSED);
				func(_t2R, JUST_RELEASED);
			case T3:
				func(_t3, PRESSED);
				func(_t3P, JUST_PRESSED);
				func(_t3R, JUST_RELEASED);
			case T4:
				func(_t4, PRESSED);
				func(_t4P, JUST_PRESSED);
				func(_t4R, JUST_RELEASED);
			case T5:
				func(_t5, PRESSED);
				func(_t5P, JUST_PRESSED);
				func(_t5R, JUST_RELEASED);

			case N0:
				func(_n0, PRESSED);
				func(_n0P, JUST_PRESSED);
				func(_n0R, JUST_RELEASED);
			case N1:
				func(_n1, PRESSED);
				func(_n1P, JUST_PRESSED);
				func(_n1R, JUST_RELEASED);
			case N2:
				func(_n2, PRESSED);
				func(_n2P, JUST_PRESSED);
				func(_n2R, JUST_RELEASED);
			case N3:
				func(_n3, PRESSED);
				func(_n3P, JUST_PRESSED);
				func(_n3R, JUST_RELEASED);
			case N4:
				func(_n4, PRESSED);
				func(_n4P, JUST_PRESSED);
				func(_n4R, JUST_RELEASED);
			case N5:
				func(_n5, PRESSED);
				func(_n5P, JUST_PRESSED);
				func(_n5R, JUST_RELEASED);
			case N6:
				func(_n6, PRESSED);
				func(_n6P, JUST_PRESSED);
				func(_n6R, JUST_RELEASED);
			case N7:
				func(_n7, PRESSED);
				func(_n7P, JUST_PRESSED);
				func(_n7R, JUST_RELEASED);
			case N8:
				func(_n8, PRESSED);
				func(_n8P, JUST_PRESSED);
				func(_n8R, JUST_RELEASED);
		}
	}

	public function replaceBinding(control:Control, device:Device, ?toAdd:Int, ?toRemove:Int)
	{
		if (toAdd == toRemove)
			return;

		switch (device)
		{
			case Keys:
				if (toRemove != null)
					unbindKeys(control, [toRemove]);
				if (toAdd != null)
					bindKeys(control, [toAdd]);

			case Gamepad(id):
				if (toRemove != null)
					unbindButtons(control, id, [toRemove]);
				if (toAdd != null)
					bindButtons(control, id, [toAdd]);
		}
	}

	public function copyFrom(controls:Controls, ?device:Device)
	{
		#if (haxe >= "4.0.0")
		for (name => action in controls.byName)
		{
			for (input in action.inputs)
			{
				if (device == null || isDevice(input, device))
					byName[name].add(cast input);
			}
		}
		#else
		for (name in controls.byName.keys())
		{
			var action = controls.byName[name];
			for (input in action.inputs)
			{
				if (device == null || isDevice(input, device))
				byName[name].add(cast input);
			}
		}
		#end

		switch (device)
		{
			case null:
				// add all
				#if (haxe >= "4.0.0")
				for (gamepad in controls.gamepadsAdded)
					if (!gamepadsAdded.contains(gamepad))
						gamepadsAdded.push(gamepad);
				#else
				for (gamepad in controls.gamepadsAdded)
					if (gamepadsAdded.indexOf(gamepad) == -1)
					  gamepadsAdded.push(gamepad);
				#end

				mergeKeyboardScheme(controls.keyboardScheme);

			case Gamepad(id):
				gamepadsAdded.push(id);
			case Keys:
				mergeKeyboardScheme(controls.keyboardScheme);
		}
	}

	inline public function copyTo(controls:Controls, ?device:Device)
	{
		controls.copyFrom(this, device);
	}

	function mergeKeyboardScheme(scheme:KeyboardScheme):Void
	{
		if (scheme != None)
		{
			switch (keyboardScheme)
			{
				case None:
					keyboardScheme = scheme;
				default:
					keyboardScheme = Custom;
			}
		}
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function bindKeys(control:Control, keys:Array<FlxKey>)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, state) -> addKeys(action, keys, state));
		#else
		forEachBound(control, function(action, state) addKeys(action, keys, state));
		#end
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function unbindKeys(control:Control, keys:Array<FlxKey>)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, _) -> removeKeys(action, keys));
		#else
		forEachBound(control, function(action, _) removeKeys(action, keys));
		#end
	}

	inline static function addKeys(action:FlxActionDigital, keys:Array<FlxKey>, state:FlxInputState)
	{
		for (key in keys)
			action.addKey(key, state);
	}

	static function removeKeys(action:FlxActionDigital, keys:Array<FlxKey>)
	{
		var i = action.inputs.length;
		while (i-- > 0)
		{
			var input = action.inputs[i];
			if (input.device == KEYBOARD && keys.indexOf(cast input.inputID) != -1)
				action.remove(input);
		}
	}

	public function setKeyboardScheme(scheme:KeyboardScheme, reset = true)
	{
		loadKeyBinds();

		inline bindKeys(Control.N0, [A]);
		inline bindKeys(Control.N1, [S]);
		inline bindKeys(Control.N2, [D]);
		inline bindKeys(Control.N3, [F]);
		inline bindKeys(Control.N4, [FlxKey.SPACE]);
		inline bindKeys(Control.N5, [H]);
		inline bindKeys(Control.N6, [J]);
		inline bindKeys(Control.N7, [K]);
		inline bindKeys(Control.N8, [L]);

		inline bindKeys(Control.S1, [S]);
		inline bindKeys(Control.S2, [D]);
		inline bindKeys(Control.S3, [F]);
		inline bindKeys(Control.S4, [J]);
		inline bindKeys(Control.S5, [K]);
		inline bindKeys(Control.S6, [L]);

		inline bindKeys(Control.T1, [D]);
		inline bindKeys(Control.T2, [F]);
		inline bindKeys(Control.T3, [FlxKey.SPACE]);
		inline bindKeys(Control.T4, [J]);
		inline bindKeys(Control.T5, [K]);
	}

	public function loadKeyBinds()
	{

		//trace(FlxKey.fromString(FlxG.save.data.upBind));

		removeKeyboard();
		KeyBinds.keyCheck();
	
		inline bindKeys(Control.UP, [FlxKey.fromString(FlxG.save.data.upBind), FlxKey.UP]);
		inline bindKeys(Control.DOWN, [FlxKey.fromString(FlxG.save.data.downBind), FlxKey.DOWN]);
		inline bindKeys(Control.LEFT, [FlxKey.fromString(FlxG.save.data.leftBind), FlxKey.LEFT]);
		inline bindKeys(Control.RIGHT, [FlxKey.fromString(FlxG.save.data.rightBind), FlxKey.RIGHT]);
		inline bindKeys(Control.ACCEPT, [Z, SPACE, ENTER]);
		inline bindKeys(Control.BACK, [BACKSPACE, ESCAPE]);
		inline bindKeys(Control.PAUSE, [P, ENTER, ESCAPE]);
		inline bindKeys(Control.RESET, [FlxKey.fromString(FlxG.save.data.killBind)]);
	}

	function removeKeyboard()
	{
		for (action in this.digitalActions)
		{
			var i = action.inputs.length;
			while (i-- > 0)
			{
				var input = action.inputs[i];
				if (input.device == KEYBOARD)
					action.remove(input);
			}
		}
	}

	public function addGamepad(id:Int, ?buttonMap:Map<Control, Array<FlxGamepadInputID>>):Void
	{
		gamepadsAdded.push(id);
		
		#if (haxe >= "4.0.0")
		for (control => buttons in buttonMap)
			inline bindButtons(control, id, buttons);
		#else
		for (control in buttonMap.keys())
			bindButtons(control, id, buttonMap[control]);
		#end
	}

	inline function addGamepadLiteral(id:Int, ?buttonMap:Map<Control, Array<FlxGamepadInputID>>):Void
	{
		gamepadsAdded.push(id);

		#if (haxe >= "4.0.0")
		for (control => buttons in buttonMap)
			inline bindButtons(control, id, buttons);
		#else
		for (control in buttonMap.keys())
			bindButtons(control, id, buttonMap[control]);
		#end
	}

	public function removeGamepad(deviceID:Int = FlxInputDeviceID.ALL):Void
	{
		for (action in this.digitalActions)
		{
			var i = action.inputs.length;
			while (i-- > 0)
			{
				var input = action.inputs[i];
				if (input.device == GAMEPAD && (deviceID == FlxInputDeviceID.ALL || input.deviceID == deviceID))
					action.remove(input);
			}
		}

		gamepadsAdded.remove(deviceID);
	}

	public function addDefaultGamepad(id):Void
	{
		#if !switch
		addGamepadLiteral(id, [
			Control.ACCEPT => [A],
			Control.BACK => [B],
			Control.UP => [DPAD_UP, LEFT_STICK_DIGITAL_UP],
			Control.DOWN => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN],
			Control.LEFT => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT],
			Control.RIGHT => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT],
			Control.PAUSE => [START],
			Control.RESET => [Y]
		]);
		#else
		addGamepadLiteral(id, [
			//Swap A and B for switch
			Control.ACCEPT => [B],
			Control.BACK => [A],
			Control.UP => [DPAD_UP, LEFT_STICK_DIGITAL_UP, RIGHT_STICK_DIGITAL_UP],
			Control.DOWN => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN, RIGHT_STICK_DIGITAL_DOWN],
			Control.LEFT => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT, RIGHT_STICK_DIGITAL_LEFT],
			Control.RIGHT => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT, RIGHT_STICK_DIGITAL_RIGHT],
			Control.PAUSE => [START],
			//Swap Y and X for switch
			Control.RESET => [Y],
			Control.CHEAT => [X]
		]);
		#end
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function bindButtons(control:Control, id, buttons)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, state) -> addButtons(action, buttons, state, id));
		#else
		forEachBound(control, function(action, state) addButtons(action, buttons, state, id));
		#end
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function unbindButtons(control:Control, gamepadID:Int, buttons)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, _) -> removeButtons(action, gamepadID, buttons));
		#else
		forEachBound(control, function(action, _) removeButtons(action, gamepadID, buttons));
		#end
	}

	inline static function addButtons(action:FlxActionDigital, buttons:Array<FlxGamepadInputID>, state, id)
	{
		for (button in buttons)
			action.addGamepad(button, state, id);
	}

	static function removeButtons(action:FlxActionDigital, gamepadID:Int, buttons:Array<FlxGamepadInputID>)
	{
		var i = action.inputs.length;
		while (i-- > 0)
		{
			var input = action.inputs[i];
			if (isGamepad(input, gamepadID) && buttons.indexOf(cast input.inputID) != -1)
				action.remove(input);
		}
	}

	public function getInputsFor(control:Control, device:Device, ?list:Array<Int>):Array<Int>
	{
		if (list == null)
			list = [];

		switch (device)
		{
			case Keys:
				for (input in getActionFromControl(control).inputs)
				{
					if (input.device == KEYBOARD)
						list.push(input.inputID);
				}
			case Gamepad(id):
				for (input in getActionFromControl(control).inputs)
				{
					if (input.deviceID == id)
						list.push(input.inputID);
				}
		}
		return list;
	}

	public function removeDevice(device:Device)
	{
		switch (device)
		{
			case Keys:
				setKeyboardScheme(None);
			case Gamepad(id):
				removeGamepad(id);
		}
	}

	static function isDevice(input:FlxActionInput, device:Device)
	{
		return switch device
		{
			case Keys: input.device == KEYBOARD;
			case Gamepad(id): isGamepad(input, id);
		}
	}

	inline static function isGamepad(input:FlxActionInput, deviceID:Int)
	{
		return input.device == GAMEPAD && (deviceID == FlxInputDeviceID.ALL || input.deviceID == deviceID);
	}
}
