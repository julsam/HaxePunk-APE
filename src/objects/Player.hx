package objects;

import nme.geom.Point;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Player extends Physics
{
	public var sprite:Spritemap;

	//how fast we accelerate
	public var movement:Float;
	public var jump:Float;

	//current player direction (true = right, false = left)
	public var direction:Bool;

	//are we on the ground?
	public var onground:Bool;

	//are we walljumping? (0 = no, 1 = left, 2 = right)
	public var walljumping:Int;
	//can we double jump? (false = no, true = yes)
	public var doublejump:Bool;

	public var dead:Bool;
	public var start:Point;

	public function new(x:Int, y:Int) 
	{
		//set position
		super(x, y);
		start = new Point(x, y);
		
		sprite = new Spritemap(HXP.getBitmap("gfx/player.png"), 32, 32, animEnd);

		movement = 1;
		jump = 8;

		direction = true;

		onground = false;

		walljumping = 0;
		doublejump = false;

		dead = false;
		start = new Point();
		
		//set different speeds and such
		mGravity = 0.4;
		mMaxspeed = new Point(4, 8);
		mFriction = new Point(0.5, 0.5);
		
		//set up animations
		sprite.add("standLeft", [0], 0, false);
		sprite.add("standRight", [8], 0, false);
		sprite.add("walkLeft", [0, 1, 2, 3, 4, 5, 6, 7], 0.2, true);
		sprite.add("walkRight", [8, 9, 10, 11, 12, 13, 14, 15], 0.2, true);
		
		sprite.add("jumpLeft", [2], 0, false);
		sprite.add("jumpRight", [10], 0, false);
		
		sprite.add("slideRight", [16], 0, false);
		sprite.add("slideLeft", [17], 0, false);
		
		sprite.play("standRight");
		
		//set hitbox & graphic
		setHitbox(12, 24, -10, -8);
		graphic = sprite;
		type = "Player";
	}

	override public function update():Void 
	{	
		//did we... die?
		if (dead) {
			sprite.alpha -= 0.1;
			return;
		} else if ( sprite.alpha < 1 ) {
			sprite.alpha += 0.1;
		}
		
		//are we on the ground?
		onground = false;
		if (collide(solid, x, y + 1) != null) 
		{ 
			onground = true;
			walljumping = 0;
			doublejump = true;
		}
		
		//set acceleration to nothing
		acceleration.x = 0;
		
		//increase acceeration, if we're not going too fast
		if (Input.check(Global.keyLeft) && speed.x > -mMaxspeed.x) { acceleration.x = - movement; direction = false; }
		if (Input.check(Global.keyRight) && speed.x < mMaxspeed.x) { acceleration.x = movement; direction = true; }
		
		//friction (apply if we're not moving, or if our speed.x is larger than maxspeed)
		if ((!Input.check(Global.keyLeft) && !Input.check(Global.keyRight)) || Math.abs(speed.x) > mMaxspeed.x) {
			friction(true, false);
		}
		
		//jump
		if (Input.pressed(Global.keyA))
		{
			var jumped:Bool = false;
			
			//normal jump
			if (onground) { 
				speed.y = -jump; 
				jumped = true; 
			}
			
			//wall jump
			if (collide(solid, x - 1, y) != null && !jumped && walljumping != 3) 
			{ 
				speed.y = -jump;		//jump up
				speed.x = mMaxspeed.x * 2;	//move right fast
				walljumping = 2;		//and set wall jump direction
				jumped = true;		//so we don't "use up" or double jump
			}
			//same as above
			if (collide(solid, x + 1, y) != null && !jumped && walljumping != 3) 
			{ 
				speed.y = -jump; 
				speed.x = - mMaxspeed.x * 2;
				walljumping = 1;
				jumped = true;
			}
			
			//set double jump to false
			if (!onground && !jumped && doublejump) { 
				speed.y = -jump;
				doublejump = false;
				//set walljumping to 0 so we can move back in any direction again
				//incase we were wall jumping prior to this double jump.
				//if you don't want to allow walljumping after a double jump, set this to 3.
				walljumping = 0;
			} 
		}
		
		
		//REMOVED AS OF V0.90 - Felt bad with this in here
		//if we ARE walljumping, make sure we can't go back
		/*if (walljumping > 0)
		{
		if (walljumping == 2 && speed.x < 0) { speed.x = 0; }
		if (walljumping == 1 && speed.x > 0) { speed.x = 0; }
		}*/
		
		//set the gravity
		gravity();
		
		//make sure we're not going too fast vertically
		//the reason we don't stop the player from moving too fast left/right is because
		//that would (partially) destroy the walljumping. Instead, we just make sure the player,
		//using the arrow keys, can't go faster than the max speed, and if we are going faster
		//than the max speed, descrease it with friction slowly.
		maxspeed(false, true);
		
		//variable jumping (tripple gravity)
		if (speed.y < 0 && !Input.check(Global.keyA)) { gravity(); gravity(); }
		
		
		//set the sprites according to if we're on the ground, and if we are moving or not
		if (onground)
		{
			if (speed.x < 0) { sprite.play("walkLeft"); }
			if (speed.x > 0) { sprite.play("walkRight"); }
			
			if (speed.x == 0) {
				if (direction) { sprite.play("standRight"); } else { sprite.play("standLeft"); }
			}
		} else {
			if (direction) { sprite.play("jumpRight"); } else { sprite.play("jumpLeft"); }
			
			//are we sliding on a wall?
			if (collide(solid, x - 1, y) != null) { sprite.play("slideRight"); }
			if (collide(solid, x + 1, y) != null) { sprite.play("slideLeft"); }
		}
		
		
		//set the motion. We set this later so it stops all movement if we should be stopped
		motion();
		
		//did we just get.. KILLED? D:
		if (collide("Spikes", x, y) != null && speed.y > 0)
		{
			//killme!
			killme();
		}
		
	}

	public function killme():Void
	{
		dead = true;
		Global.restart = true;
	}

	public function animEnd():Void { }

}