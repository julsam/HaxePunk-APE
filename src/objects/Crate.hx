package objects;

import com.haxepunk.graphics.atlas.TextureAtlas;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
/**
 * ...
 * @author Noel Berry
 */
class Crate extends Physics
{
	public var sprite:Image;

	//this is here to check how long the player has been pushing
	//BEFORE we start to move.
	public var timer:Int;
	//what direction we're pushing (0 = none, -1 = left, 1 = right)
	public var pushing:Int;
	//if we're moving (being pushed)
	public var moving:Bool;
	//our speed when being pushed (shouldn't be larger than player speed)
	public var movement:Int;

	public function new(x:Int, y:Int) 
	{
		super(x, y);
		
#if !flash
		var atlas = TextureAtlas.loadTexturePacker("atlas/objects.xml");
#end
		sprite = new Image(#if flash "gfx/crate.png" #else atlas.getRegion("crate.png") #end);
		
		timer = 10;
		pushing;
		moving = false;
		movement = 2;
		
		graphic = sprite;
		type = "Solid";
		
		setHitbox(32, 32);
	}

	override public function update():Void 
	{
		//only move vertically here
		motion(false, true);
		gravity();
		
		//check if we're being pushed
		pushing = 0;
		if (collide("Player", x + 1, y) != null && Input.check(Global.keyLeft)) {
			pushing = -1;
		}
		if (collide("Player", x - 1, y) != null && Input.check(Global.keyRight)) {
			pushing = 1;
		}
		
		//if we're being pushed, count the timer down
		if (pushing == -1)
		{
			if (timer > 0) { timer --; }
			//start moving if timer has hit bottom
			if (timer < 1) { moving = true; }
		}
		
		if (pushing == 1)
		{
			if (timer > 0) { timer --; }
			if (timer < 1) { moving = true; }
		}
		
		//if we're moving
		if (moving) 
		{
			//if we're still being pushed, set our speed
			if (pushing != 0) { speed.x = movement * pushing; }
			//update our position
			motion(true, false);
			//update the player position
			Global.player.motion(true,false);
			
			//no longer being pushed
			if (pushing == 0)
			{
				timer = 10;
				moving = false;
			}
		}
		
		//slide to a stop if we're not moving
		if (!moving) { 
			friction(true, false); 
			motion(true, false); 
		}
	}
}