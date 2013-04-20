package solids;

import com.haxepunk.Entity;
/**
 * ...
 * @author Noel Berry
 */
class Solid extends Entity
{
	public function new(x:Int,y:Int,w:Int = 32,h:Int = 32) 
	{
		super(x, y);
		type = "Solid";
		setHitbox(w, h);
		
		//hide us - we don't need to ever be updated or rendered
		active = false;
		visible = false;
	}
}