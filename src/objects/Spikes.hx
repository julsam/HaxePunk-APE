package objects;

import com.haxepunk.graphics.atlas.TextureAtlas;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Pixelmask;
/**
 * ...
 * @author Noel Berry
 */
class Spikes extends Entity
{
	public var sprite:Image;

	public function new(x:Int, y:Int) 
	{
		//set position
		super(x, y);
		
#if !flash
		var atlas = TextureAtlas.loadTexturePacker("atlas/objects.xml");
#end
		sprite = new Image(#if flash "gfx/spikes.png" #else atlas.getRegion("spikes.png") #end);
		
		//set graphic and mask
		graphic = sprite;
		
#if flash
		mask = new Pixelmask(HXP.getBitmap("gfx/spikes.png"));
#else
		// use hitbox instead of a mask for native targets, PixelMask doesn't accept an AtlasRegion as argument.
		setHitbox(Std.int(atlas.getRegion("spikes.png").width), Std.int(atlas.getRegion("spikes.png").height));
#end
		
		//set type
		type = "Spikes";
	}

}