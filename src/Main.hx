package ;

import control.Game;
import nme.events.KeyboardEvent;
import com.haxepunk.Engine;
import com.haxepunk.HXP;
import nme.display.FPS;
import nme.Lib;
import control.Menu;

/**
 * ...
 * @author julsam
 */

class Main extends Engine
{
	public function new()
	{	
		super(640, 480, 60, true);
	}

	override public function init()
	{
#if android
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, androidOnKeyUp);
#end

#if debug
		HXP.console.enable();
#end
		
		HXP.scene = new Menu();
	}
	
	private function androidOnKeyUp(e:KeyboardEvent):Void
	{
#if android
		if (e.keyCode == 27) {
			// When you call "stopPropagation" or "stopImmediatePropagation" it will cancel the default behavior 
			// for the button. Use this to disable minimizing entirely, or here, exiting the application instead.
			e.stopImmediatePropagation();
			exit();
		}
#end
	}
	
	public function exit():Void
	{
#if (android || windows || linux)
		Lib.exit();
#end
	}

	public static function main() { new Main(); }

}