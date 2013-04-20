package control;

import com.haxepunk.utils.Draw;
import haxe.xml.Fast;
import objects.Crate;
import objects.Door;
import objects.Electricity;
import objects.Moving;
import objects.Player;
import objects.Spikes;
import solids.Slope;
import solids.Solid;

import nme.geom.Point;
import nme.geom.Rectangle;
import nme.utils.ByteArray;
import nme.Assets;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Tilemap;

/**
 * ...
 * @author Noel Berry
 */
class Game extends Scene
{
	public var tileset:Tilemap;

	//timer so that reset level doesn't happen right away...
	public var reset:Int = 60;
	
	private var xml:Xml;

	public function new()
	{
		super();
	}
	
	override public function begin():Void
	{	
		//set the level to 0
		Global.level = 0;
		
		Global.levels.push("levels/Level1.oel");
		Global.levels.push("levels/Level2.oel");
		
		//load next level
		nextlevel();
	}
	
	override public function update():Void 
	{
		//only update if the game is not paused
		if (!Global.paused) { super.update(); }
		
		//if we should restart
		if (Global.restart) { 
		
			//make a timer so it isn't instant
			reset -= 1;
			if (reset == 0) {
				//restart level
				restartlevel();
				//set restart to false
				Global.restart = false;
				//reset our timer
				reset = 60;
			}
		}
		
		//load next level on level completion
		if (Global.finished) {
			nextlevel();
		}
	}

	public function loadlevel():Void 
	{
		//get the XML
		xml = Xml.parse(Assets.getText(Global.levels[Global.level-1]));
		var fast = new haxe.xml.Fast(xml.firstElement());
		
		//set the level size
		HXP.width = Std.parseInt(fast.node.width.innerData);
		HXP.height = Std.parseInt(fast.node.height.innerData);
		
		//add the tileset to the world
		add(new Entity(0, 0, tileset = new Tilemap(HXP.getBitmap("gfx/tileset.png"), HXP.width, HXP.height, Global.grid, Global.grid)));
		
		//add the view, and the player
		add(Global.player = new Player(Std.parseInt(fast.node.objects.node.player.att.x), Std.parseInt(fast.node.objects.node.player.att.y)));
		
		//set the view to follow the player, within no restraints, and let it "stray" from the player a bit.
		//for example, if the last parameter was 1, the view would be static with the player. If it was 10, then
		//it would trail behind the player a bit. Higher the number, slower it follows.
		add(Global.view = new View(cast(Global.player, Entity), new Rectangle(0, 0, HXP.width, HXP.height), 10));
		
		//add tiles
		for (o in fast.node.tilesAbove.nodes.tile) {
			//place the tiles in the correct position
			//NOTE that you should replace the "5" with the amount of columns in your tileset!
			var col = Std.int(Std.parseInt(o.att.x) / Global.grid);
			var row = Std.int(Std.parseInt(o.att.y) / Global.grid);
			var index = Std.int((5 * (Std.parseInt(o.att.ty) / Global.grid)) + (Std.parseInt(o.att.tx) / Global.grid));
			tileset.setTile(col, row, index);
		}
		
		//place the solids
		for (o in fast.node.floors.nodes.rect) {
			//place flat solids, setting their position & width/height
			add(new Solid(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.w), Std.parseInt(o.att.h)));
		}
		
		if (fast.hasNode.slopes) {
			for (o in fast.node.slopes.nodes.slope) {
				//place a slope
				add(new Slope(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.type)));
			}
		}
		//place a crate
		for (o in fast.node.objects.nodes.crate) {
			add(new Crate(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
		}
		
		//place a moving platform
		for (o in fast.node.objects.nodes.moving) {
			add(new Moving(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
		}
		
		//place a moving platform
		for (o in fast.node.objects.nodes.spikes) {
			add(new Spikes(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
		}
		
#if flash
		//place electricity
		for (o in fast.node.objects.nodes.electricity) {
			var p:Point = new Point();
			//get the end point of the electricity (via nodes)
			p = new Point(Std.parseInt(o.node.node.att.x), Std.parseInt(o.node.node.att.y));
			
			//add electricity to the world
			add(new Electricity(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.int(p.x), Std.int(p.y)));
		}
#end

		//add the door
		for (o in fast.node.objects.nodes.door) {
			add(new Door(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
		}
	}


	/**
	 * Loads up the next level (removes all entities of the current world, increases Global.level, calls loadlevel)
	 * @return	void
	 */
	public function nextlevel():Void
	{
		removeAll();
		
		if (Global.level < Global.levels.length) {
			Global.level++;
		}
		Global.finished = false;
		
		loadlevel();
	}


	/**
	 * Reloads the current level
	 * @return	void
	 */
	public function restartlevel():Void
	{
		removeAll();
		loadlevel();
		
		//increase deaths
		Global.deaths++;
	}

}