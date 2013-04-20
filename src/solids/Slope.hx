package solids;

import com.haxepunk.HXP;
import com.haxepunk.masks.Polygon;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.geom.Point;
import nme.geom.Rectangle;
import com.haxepunk.graphics.Image;
import com.haxepunk.Mask;
import com.haxepunk.masks.Pixelmask;
/**
 * ...
 * @author Noel Berry
 */
class Slope extends Solid
{
	public var slopeMask:Pixelmask;

	public function new(x:Int, y:Int, type:Int) 
	{
		super(x, y, 0, 0);
		
#if flash
		var slope:BitmapData = new BitmapData(32, 32);
		switch(type) {
			case 0: slope = HXP.getBitmap("gfx/slope1.png");
			case 1: slope = HXP.getBitmap("gfx/slope2.png");
			case 2: slope = HXP.getBitmap("gfx/slope3.png");
			case 3: slope = HXP.getBitmap("gfx/slope4.png");
		}
		
		slopeMask = new Pixelmask(slope, 0, 0);
		mask = slopeMask;
#else
		var poly:Polygon = new Polygon([new Point(0, 0), new Point(32, 0), new Point(32, 32), new Point(0, 32)]);
		switch(type) {
			case 0: poly = new Polygon([new Point(0, 33), new Point(32, 0), new Point(32, 32)]);
			case 1: poly = new Polygon([new Point(0, 0), new Point(32, 33), new Point(0, 32)]);
			case 2: poly = new Polygon([new Point(0, 0), new Point(32, 0), new Point(32, 32)]);
			case 3: poly = new Polygon([new Point(0, 0), new Point(32, 0), new Point(0, 32)]);
		}
		mask = poly;
#end
		//hide us - we don't need to ever be updated
		active = false;
		visible = false;
	}
}