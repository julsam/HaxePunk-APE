package control;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Draw;
import com.haxepunk.Scene;

class Transition extends Scene
{
	//the screen (to display)
	public var screen:Image;
	//the entity that actually holds the screen
	public var display:Entity;
	//what world to goto
	public var _goto:Dynamic;
	//the alpha to put over
	public var alpha:Float = 0;

	public function new(goto:Dynamic) 
	{
		super();
		
		//set the screen to what was last being displayed
		screen = new Image(HXP.buffer);
		//add the display entity with the new graphic
		add(display = new Entity(0, 0, screen));
		
		//set goto
		_goto = goto;
	}

	override public function render():Void
	{
#if flash
		//fade out
		Draw.rect(0, 0, HXP.width, HXP.height, 0x000000, alpha);
#end
		alpha += 0.1;
		
		//if we're done, go to the next world
		if (Math.floor(alpha) == 1) {
			HXP.scene = Type.createInstance(_goto, []);
		}
	}
}