package objects;

import com.haxepunk.graphics.atlas.TextureAtlas;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
/**
 * ...
 * @author Noel Berry
 */
class Moving extends Physics
{
	public var sprite:Image ;

	public var direction:Bool;
	public var movement:Float;
	public var carry:Array<String>;

	public function new(x:Int, y:Int) 
	{
		//our x/y position
		super(x, y);
		
#if !flash
		var atlas = TextureAtlas.loadTexturePacker("atlas/objects.xml");
#end
		sprite = new Image(#if flash "gfx/moving.png" #else atlas.getRegion("moving.png") #end);
		
		direction = HXP.choose([true, false]);
		movement = 2;
		carry = ["Solid", "Player"];
	
		//graphic & hitbox
		graphic = sprite;
		setHitbox(64, 32);
	}

	override public function update():Void {
		
		//move in the correct direction
		speed.x = direction ? movement : - movement;
		
		//move stuff that's on top of us, for each type of entity we can carry
		for (i in carry) {
			moveontop(i, speed.x);
		}
		
		//move ourselves
		motion();
		
		//if we've stopped moving, switch directions!
		if (speed.x == 0) {
			direction = !direction;
		}
	}

}