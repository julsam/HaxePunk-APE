package;

import com.haxepunk.utils.Key;
import control.View;
import objects.Player;
/*
 * This class contains a number of global variables to be used throughout the game
 */
class Global
{
	public static var time:Int = 0;
	public static var deaths:Int = 0;
	public static var gems:Int = 0;
	public static var level:Int = 0;
	public static var levels:Array<String> = new Array<String>();
	
	public static var newgame:Bool = false;
	public static var loadgame:Bool = false;
	
	public static var musicon:Bool = true;
	public static var soundon:Bool = true;
	
	public static var keyUp:Int = Key.UP;
	public static var keyDown:Int = Key.DOWN;
	public static var keyLeft:Int = Key.LEFT;
	public static var keyRight:Int = Key.RIGHT;
	public static var keyA:Int = Key.X;
	
	public static var player:Player;
	public static var view:View;
	
	public static var paused:Bool = false;
	public static var restart:Bool = false;
	public static var finished:Bool = false;
	
	public static inline var grid:Int = 32;

}