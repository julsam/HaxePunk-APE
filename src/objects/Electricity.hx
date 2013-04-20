package objects;

import flash.geom.Point;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Draw;
/**
 * ...
 * @author Noel Berry
 */
class Electricity extends Entity
{
	public var sprite:Image;
	public var sprite2:Image;

	public var start:Point;
	public var end:Point;

	public function new(x:Int, y:Int, x2:Int, y2:Int) 
	{
		super(x, y);
		
		sprite = new Image(HXP.getBitmap("gfx/electricity.png"));
		sprite2 = new Image(HXP.getBitmap("gfx/electricity.png"));
		
		sprite2.x = x2 - x;
		sprite2.y = y2 - y;
		
		graphic = new Graphiclist([sprite, sprite2]);
		
		start = new Point(x, y);
		end = new Point(x2, y2);
		
	}

	override public function update():Void
	{
		//if we hit the entity
		if (scene.collideLine("Player", Std.int(start.x) + 16, Std.int(start.y) + 16, Std.int(end.x) + 16, Std.int(end.y) + 16, 8) != null)
		{
			Global.player.killme();
		}
	}

	override public function render():Void
	{
		//how many and how crazy
		var amount:Int = 16;
		var crazyness:Int = 16;
		
		//the offset (so that it's not just a straight line)
		var poffset:Point = new Point(0, 0);
		var noffset:Point = new Point(0, 0);
		
		//previous and next point
		var previous:Point = new Point(start.x + 16,start.y + 16);
		var next:Point = new Point(start.x + 16, start.y + 16);
		
		//how much to increase each point by
		var incY:Float = (end.y - start.y) / amount;
		var incX:Float = (end.x - start.x) / amount;
		
		for (i in 0...amount)
		{
			//set the new offset
			noffset = new Point((Math.random() * 16) - (16/2), (Math.random() * 16) - (16/2));
			
			//increase the next point
			next.x += incX;
			next.y += incY;
			
			//if the point is at the end, set the offset to nothing
			if (i == amount - 1) {
				noffset = new Point(0, 0);
			}
			
			//draw the line from the last point, with the last offset, to the new point, with the new offset
			Draw.line(Std.int(previous.x + poffset.x), Std.int(previous.y + poffset.y), Std.int(next.x + noffset.x), Std.int(next.y + noffset.y), 0xFFFFFF);
			
			//set the previous point and offset to the new point and offset
			previous = new Point(next.x, next.y);
			poffset = new Point(noffset.x, noffset.y);
		}
		
		//draw the blocks on the end
		super.render();
	}

}