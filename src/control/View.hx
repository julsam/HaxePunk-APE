package control;

import flash.geom.Point;
import flash.geom.Rectangle;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
/**
 * ...
 * @author Noel Berry
 */
class View extends Entity
{
	public var _tofollow:Entity;
	public var _within:Rectangle;
	public var _speed:Float;

	public function new(tofollow:Entity, within:Rectangle = null, speed:Float = 1) 
	{
		super();
		
		//set x to current camera position so we don't "jump" to 0,0 on creation
		x = HXP.camera.x;
		y = HXP.camera.y;
		
		setView(tofollow, within, speed);
	}


	/**
	 * Sets the view (camera) to follow a particular entity within a rectangle, at a set speed
	 * @param	tofollow	The entity to follow
	 * @param	within	The rectangle that the view should stay within (if any)
	 * @param	speed	Speed at which to follow the entity (1=static with entity, >1=follows entity)
	 * @return	void
	 */
	public function setView(tofollow:Entity, within:Rectangle = null, speed:Float = 1):Void
	{
		_tofollow = tofollow;
		_within = within;
		_speed = speed;
	}

	override public function update():Void
	{
		//follow the entity
		
		var dist:Float = HXP.distance(_tofollow.x - HXP.screen.width / 2, _tofollow.y - HXP.screen.height / 2, HXP.camera.x, HXP.camera.y);
		var spd:Float = dist / _speed;
		
		HXP.stepTowards(this, _tofollow.x - HXP.screen.width / 2, _tofollow.y - HXP.screen.height / 2, spd);
		
		HXP.camera.x = x;
		HXP.camera.y = y;
		
		//stay within contstraints
		if(_within != null) {
			if (HXP.camera.x < _within.x) { HXP.camera.x = _within.x; }
			if (HXP.camera.y < _within.y) { HXP.camera.y = _within.y; }
			
			if (HXP.camera.x +HXP.screen.width > _within.x + _within.width) { HXP.camera.x = _within.x + _within.width - HXP.screen.width; }
			if (HXP.camera.y + HXP.screen.height > _within.y + _within.height) { HXP.camera.y = _within.y + _within.height - HXP.screen.height; }
		}
	}
}