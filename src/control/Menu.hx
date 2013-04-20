package control;

import nme.geom.Rectangle;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.atlas.TextureAtlas;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Scene;
/*
 * The main menu of the game. We use this to load a new game, continue an old one,
 * or to check out the options
 */
class Menu extends Scene
{
	//add the banner as an image
	public var sprBanner:Image;

	//add each menu option from the menu.png
	public var sprNewGame:Image;
	public var sprNewGameHover:Image;
	public var sprLoadGame:Image;
	public var sprLoadGameHover:Image;

	//create a new graphic list of our images
	public var sprites:Graphiclist;
	//variable that contains the entity that holds all the graphics
	public var display:Entity;

	//current menu selected
	public var selected:Int = 0;
	//if a menu selection has been changed (so we're not executing this every frame)
	public var changed:Bool = true;

	public function new() 
	{
		super();
		
#if !flash
		var atlas = TextureAtlas.loadTexturePacker("atlas/menu.xml");
#end
		sprBanner = new Image(#if flash "gfx/banner.png" #else atlas.getRegion("banner.png") #end);
		
		sprNewGame = new Image(#if flash "gfx/menu.png" #else atlas.getRegion("menu.png") #end, new Rectangle(0, 0, 640, 64));
		sprNewGameHover = new Image(#if flash "gfx/menu.png" #else atlas.getRegion("menu.png") #end, new Rectangle(0, 64, 640, 64));
		sprLoadGame = new Image(#if flash "gfx/menu.png" #else atlas.getRegion("menu.png") #end, new Rectangle(0, 128, 640, 64));
		sprLoadGameHover = new Image(#if flash "gfx/menu.png" #else atlas.getRegion("menu.png") #end,new Rectangle(0,192,640,64));

		sprites = new Graphiclist([sprBanner, sprNewGame, sprNewGameHover, sprLoadGame, sprLoadGameHover]);
	
		//add the display entity to the world
		add(display = new Entity(0, 0, sprites));

		//image positions
		sprBanner.y = -128;
		sprNewGame.y = sprNewGameHover.y = 200;
		sprLoadGame.y = sprLoadGameHover.y = 264;
	}

	override public function update():Void
	{
		//make the banner slide in
		sprBanner.y += - Math.floor(sprBanner.y / 10);
		
		//if the menu selection changed
		if (changed)
		{
			//if the selection is out of the range, reset it
			if (selected < 0) { selected = 0; }
			if (selected > 1) { selected = 1; }
			
			//set the incorrect images to visible/invisible
			sprNewGame.visible = selected == 0 ? false : true;
			sprNewGameHover.visible = !sprNewGame.visible;
			sprLoadGame.visible = selected == 1 ? false : true;
			sprLoadGameHover.visible = !sprLoadGame.visible;
			
			//we're done changing
			changed = false;
		}
		
		//change selection
		if (Input.pressed( Global.keyDown)) { selected += 1; }
		if (Input.pressed( Global.keyUp)) { selected -= 1; }
		
		if (Input.pressed(Global.keyA)) { 
			//fade out, go to the game
			#if flash
			HXP.scene = new Transition(Game); 
			#else
			HXP.scene = new Game(); 
			#end
		}

		if (Input.pressed(Key.ANY)) { changed = true; }
	}

}