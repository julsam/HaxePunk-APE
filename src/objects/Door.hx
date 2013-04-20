package objects;

import com.haxepunk.graphics.atlas.TextureAtlas;
import nme.geom.Rectangle;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import control.Game;
/**
 * ...
 * @author Noel Berry
 */
class Door extends Entity
{
	public var sprite:Image;
	public var sprite_hover:Image;

	public function new(x:Int, y:Int) 
	{
		super(x, y - 32);
		
#if !flash
		var atlas = TextureAtlas.loadTexturePacker("atlas/objects.xml");
#end
		sprite = new Image(#if flash "gfx/door.png" #else atlas.getRegion("door.png") #end, new Rectangle(0, 0, 32, 64));
		sprite_hover = new Image(#if flash "gfx/door.png" #else atlas.getRegion("door.png") #end, new Rectangle(32, 0, 32, 64));
		
		graphic = sprite;
		setHitbox(32, 32, 0, -32);
	}

	override public function update():Void
	{
		//set the graphic to the default one
		graphic = sprite;
		
		//if we collide with the player...
		if (collideWith(Global.player, x, y) != null) {
			//Note the use of collideWith (above). This is faster than using collde("type")
			
			//set the sprite to the hover one
			graphic = sprite_hover;
			
			//if down is pressed, finish level
			if (Input.pressed(Global.keyDown))
			{
				Global.finished = true;
			}
		}
	}

}